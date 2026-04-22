// IMPORTS ---------------------------------------------------------------------

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/string_tree.{type StringTree}
import houdini
import smail/vdom/vattr.{type Attribute}

// TYPES -----------------------------------------------------------------------

pub type Element {
  Fragment(children: List(Element))

  Element(
    tag: String,
    attributes: List(Attribute),
    children: List(Element),
    void: Bool,
  )

  Text(content: String)

  UnsafeInnerHtml(
    tag: String,
    //
    attributes: List(Attribute),
    inner_html: String,
  )
}

// CONSTRUCTORS ----------------------------------------------------------------

pub fn fragment(children children: List(Element)) -> Element {
  Fragment(children:)
}

pub fn element(
  tag tag: String,
  attributes attributes: List(Attribute),
  children children: List(Element),
  void void: Bool,
) -> Element {
  Element(tag:, attributes: vattr.prepare(attributes), children:, void:)
}

pub fn is_void_html_element(tag: String) -> Bool {
  case tag {
    "area"
    | "base"
    | "br"
    | "col"
    | "embed"
    | "hr"
    | "img"
    | "input"
    | "link"
    | "meta"
    | "param"
    | "source"
    | "track"
    | "wbr" -> True
    _ -> False
  }
}

pub fn text(content content: String) -> Element {
  Text(content: content)
}

pub fn unsafe_inner_html(
  tag tag: String,
  attributes attributes: List(Attribute),
  inner_html inner_html: String,
) -> Element {
  UnsafeInnerHtml(tag:, attributes: vattr.prepare(attributes), inner_html:)
}

type CascadingStyle {
  CascadingStyle(color: String)
}

// HTML RENDERING ------------------------------------------------------------

pub fn to_html_string(node: Element) -> String {
  node
  |> to_html_string_tree(None)
  |> string_tree.to_string
}

fn to_html_string_tree(
  node: Element,
  cascading_style: Option(CascadingStyle),
) -> StringTree {
  let cascading_style = case node {
    Element(attributes:, ..) | UnsafeInnerHtml(attributes:, ..) -> {
      case
        list.find_map(attributes, fn(attribute) {
          case attribute.name == "color" {
            False -> Error(Nil)
            True -> Ok(attribute.value)
          }
        })
      {
        Ok(color) -> Some(CascadingStyle(color:))
        Error(_) -> cascading_style
      }
    }
    _ -> cascading_style
  }

  case node {
    Text(content: "") -> string_tree.new()
    Text(content:) -> string_tree.from_string(houdini.escape(content))

    Element(tag:, attributes:, void:, ..) if void -> {
      let html = string_tree.from_string("<" <> tag)

      let attributes = case cascading_style {
        Some(style) ->
          vattr.prepare([
            vattr.attribute("style", "color:" <> style.color <> ";"),
            ..attributes
          ])
        None -> attributes
      }

      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(" />")
    }

    Element(tag:, attributes:, children:, ..) -> {
      let html = string_tree.from_string("<" <> tag)

      let has_text_children =
        list.any(children, fn(child) {
          case child {
            Text(..) -> True
            _ -> False
          }
        })

      let attributes = case cascading_style {
        Some(style) if has_text_children ->
          vattr.prepare([
            vattr.attribute("style", "color:" <> style.color <> ";"),
            ..attributes
          ])
        _ -> attributes
      }

      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> children_to_html_string_tree(cascading_style, children)
      |> string_tree.append("</" <> tag <> ">")
    }

    UnsafeInnerHtml(tag:, attributes:, inner_html:) -> {
      let html = string_tree.from_string("<" <> tag)

      let attributes = case cascading_style {
        Some(style) ->
          vattr.prepare([
            vattr.attribute("style", "color:" <> style.color <> ";"),
            ..attributes
          ])
        None -> attributes
      }

      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> string_tree.append(inner_html)
      |> string_tree.append("</" <> tag <> ">")
    }

    Fragment(children:) -> {
      marker_comment("smail:fragment")
      |> children_to_html_string_tree(cascading_style, children)
      |> string_tree.append_tree(marker_comment("/smail:fragment"))
    }
  }
}

fn children_to_html_string_tree(
  html: StringTree,
  cascading_style: Option(CascadingStyle),
  children: List(Element),
) -> StringTree {
  use html, child <- list.fold(children, html)
  string_tree.append_tree(html, to_html_string_tree(child, cascading_style))
}

fn marker_comment(label: String) {
  string_tree.from_string("<!-- " <> label <> " -->")
}

// PLAIN RENDERING ------------------------------------------------------------

type CascadingDisplay {
  DisplayNone
  DisplayNewLine
  DisplayInline
  DisplayTable
}

fn get_element_display(node: Element) {
  case node {
    Element(tag:, attributes:, ..) -> {
      case
        list.find_map(attributes, fn(attribute) {
          case attribute.name == "style" {
            False -> Error(Nil)
            True -> {
              string.split(attribute.value, ";")
              |> list.find_map(fn(style) {
                case string.split_once(style, ":") {
                  Ok(#("display", value)) -> Ok(string.trim(value))
                  _ -> Error(Nil)
                }
              })
            }
          }
        })
      {
        Ok("none") -> DisplayNone
        Ok("block") -> DisplayNewLine
        Ok("inline") -> DisplayInline
        Ok("inline-block") -> DisplayInline
        Ok("flex") -> DisplayNewLine
        Ok("inline-flex") -> DisplayInline
        Ok("grid") -> DisplayNewLine
        Ok("inline-grid") -> DisplayInline
        Ok("table") -> DisplayTable
        Ok("inline-table") -> DisplayInline
        Ok("table-row") -> DisplayInline
        Ok("table-cell") -> DisplayInline
        Ok("table-column") -> DisplayInline
        Ok("table-column-group") -> DisplayInline
        Ok("table-row-group") -> DisplayInline
        Ok("table-header-group") -> DisplayInline
        Ok("table-footer-group") -> DisplayInline
        Ok("table-caption") -> DisplayInline
        Ok("list-item") -> DisplayInline
        Ok("contents") -> DisplayInline
        Ok("flow-root") -> DisplayInline
        _ ->
          case tag {
            "a"
            | "abbr"
            | "acronym"
            | "b"
            | "bdo"
            | "big"
            | "br"
            | "button"
            | "cite"
            | "code"
            | "dfn"
            | "em"
            | "i"
            | "img"
            | "input"
            | "kbd"
            | "label"
            | "map"
            | "object"
            | "output"
            | "q"
            | "samp"
            | "select"
            | "small"
            | "span"
            | "strong"
            | "sub"
            | "sup"
            | "textarea"
            | "time"
            | "tt"
            | "var" -> DisplayInline
            "table" -> DisplayTable
            "tr" -> DisplayInline
            "td" | "th" -> DisplayInline
            "col" -> DisplayInline
            "colgroup" -> DisplayInline
            "tbody" -> DisplayInline
            "thead" -> DisplayInline
            "tfoot" -> DisplayInline
            "caption" -> DisplayInline
            "li" -> DisplayInline
            "html" -> DisplayInline
            "head" -> DisplayInline
            "body" -> DisplayInline
            _ -> DisplayNewLine
          }
      }
    }
    _ -> DisplayInline
  }
}

type CascadingWhiteSpace {
  WhiteSpaceNormal
  WhiteSpaceNowrap
  WhiteSpacePre
  WhiteSpacePreWrap
  WhiteSpacePreLine
}

fn get_element_white_space(node: Element) -> option.Option(CascadingWhiteSpace) {
  case node {
    Element(tag:, attributes:, ..) -> {
      case
        list.find_map(attributes, fn(attribute) {
          case attribute.name == "style" {
            False -> Error(Nil)
            True -> {
              string.split(attribute.value, ";")
              |> list.find_map(fn(style) {
                case string.split_once(style, ":") {
                  Ok(#("white-space", value)) -> Ok(string.trim(value))
                  _ -> Error(Nil)
                }
              })
            }
          }
        })
      {
        Ok("nowrap") -> Some(WhiteSpaceNowrap)
        Ok("pre") -> Some(WhiteSpacePre)
        Ok("pre-wrap") -> Some(WhiteSpacePreWrap)
        Ok("pre-line") -> Some(WhiteSpacePreLine)
        Ok("normal") -> Some(WhiteSpaceNormal)
        Ok(_) -> None
        Error(_) ->
          case tag {
            "pre" -> Some(WhiteSpacePre)
            _ -> None
          }
      }
    }
    _ -> None
  }
}

const plain_text_wrap_column = 72

const plain_text_nbsp = "\u{00A0}"

pub fn to_plain_string(node: Element) -> String {
  node
  |> to_plain_string_tree(WhiteSpaceNormal)
  |> string_tree.to_string
  |> string.replace(plain_text_nbsp, " ")
}

fn wrap_text(text: StringTree, max_width: Int) -> StringTree {
  text
  |> string_tree.split("\n")
  |> list.map(wrap_line(_, max_width))
  |> string_tree.join("\n")
}

fn wrap_line(line: StringTree, max_width: Int) -> StringTree {
  line
  |> string_tree.split(" ")
  |> list.fold(#(string_tree.new(), 0), fn(acc, word) {
    let #(tree, col) = acc
    let word_len = string.length(string_tree.to_string(word))
    case col {
      0 -> #(string_tree.append_tree(tree, word), word_len)
      _ -> {
        let new_col = col + 1 + word_len
        case new_col > max_width {
          True -> #(
            string_tree.append_tree(string_tree.append(tree, "\n"), word),
            word_len,
          )
          False -> #(
            string_tree.append_tree(string_tree.append(tree, " "), word),
            new_col,
          )
        }
      }
    }
  })
  |> fn(acc) { acc.0 }
}

fn to_plain_string_tree(
  node: Element,
  white_space: CascadingWhiteSpace,
) -> StringTree {
  case node {
    Text(content: "") -> string_tree.new()
    Text(content:) -> {
      let text = houdini.escape(content)
      case white_space {
        WhiteSpaceNowrap ->
          string_tree.from_string(string.replace(text, " ", plain_text_nbsp))
        _ -> string_tree.from_string(text)
      }
    }
    Element(tag:, void:, ..) if void -> {
      case tag {
        "br" -> string_tree.from_string("\n")
        "hr" ->
          int.range(
            from: 0,
            to: plain_text_wrap_column,
            with: string_tree.new(),
            run: fn(acc, _) { string_tree.append(acc, "-") },
          )
          |> string_tree.append("\n\n")
        _ -> string_tree.new()
      }
    }
    Element(children:, ..) -> {
      let effective_white_space = case get_element_white_space(node) {
        None -> white_space
        Some(ws) -> ws
      }
      case get_element_display(node) {
        DisplayNewLine -> {
          let content =
            string_tree.new()
            |> children_to_plain_string_tree(effective_white_space, children)
          case effective_white_space {
            WhiteSpaceNormal | WhiteSpacePreLine ->
              wrap_text(content, plain_text_wrap_column)
            WhiteSpaceNowrap | WhiteSpacePre | WhiteSpacePreWrap -> content
          }
          |> string_tree.append("\n\n")
        }
        DisplayInline | DisplayTable -> {
          string_tree.new()
          |> children_to_plain_string_tree(effective_white_space, children)
        }
        DisplayNone -> string_tree.new()
      }
    }
    UnsafeInnerHtml(..) -> string_tree.new()
    Fragment(children:) -> {
      string_tree.new()
      |> children_to_plain_string_tree(white_space, children)
    }
  }
}

fn children_to_plain_string_tree(
  html: StringTree,
  white_space: CascadingWhiteSpace,
  children: List(Element),
) -> StringTree {
  use html, child <- list.fold(children, html)
  string_tree.append_tree(html, to_plain_string_tree(child, white_space))
}
