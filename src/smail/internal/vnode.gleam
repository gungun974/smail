import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/string_tree.{type StringTree}
import houdini
import smail/internal/vattr.{type Attribute}

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

type CascadingTable {
  Table
  TableRowGroup
  TableRow
  TableCell
}

type CascadingDisplay {
  DisplayNone
  DisplayNewLine
  DisplayInline
  DisplayTable(CascadingTable)
}

fn get_element_display(node: Element) {
  case node {
    Element(tag:, attributes:, ..) -> {
      case
        list.find(attributes, fn(attribute) {
          attribute.name == "role" && attribute.value == "presentation"
        })
      {
        Ok(_) -> DisplayInline
        _ -> {
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
            Ok("table") -> DisplayTable(Table)
            Ok("inline-table") -> DisplayTable(Table)
            Ok("table-row") -> DisplayTable(TableRow)
            Ok("table-cell") -> DisplayTable(TableCell)
            Ok("table-column") -> DisplayTable(TableRow)
            Ok("table-column-group") -> DisplayTable(TableCell)
            Ok("table-row-group") -> DisplayTable(TableRowGroup)
            Ok("table-header-group") -> DisplayTable(TableRowGroup)
            Ok("table-footer-group") -> DisplayTable(TableRowGroup)
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
                "table" -> DisplayTable(Table)
                "tr" -> DisplayTable(TableRow)
                "td" | "th" -> DisplayTable(TableCell)
                "col" -> DisplayInline
                "colgroup" -> DisplayInline
                "tbody" -> DisplayTable(TableRowGroup)
                "thead" -> DisplayTable(TableRowGroup)
                "tfoot" -> DisplayTable(TableRowGroup)
                "caption" -> DisplayInline
                "li" -> DisplayInline
                "html" -> DisplayInline
                "head" -> DisplayInline
                "body" -> DisplayInline
                _ -> DisplayNewLine
              }
          }
        }
      }
    }
    _ -> DisplayInline
  }
}

fn get_element_has_border(node: Element) -> Bool {
  case node {
    Element(attributes:, ..) -> {
      let border_attr =
        list.find_map(attributes, fn(attr) {
          case attr.name == "border" {
            True -> Ok(string.trim(attr.value))
            False -> Error(Nil)
          }
        })

      case border_attr {
        Ok("0") -> False
        Ok("none") -> False
        _ -> {
          case
            list.find_map(attributes, fn(attribute) {
              case attribute.name == "style" {
                False -> Error(Nil)
                True ->
                  string.split(attribute.value, ";")
                  |> list.find_map(fn(style) {
                    case string.split_once(style, ":") {
                      Ok(#("border", value)) -> Ok(string.trim(value))
                      Ok(#("border-width", value)) -> Ok(string.trim(value))
                      Ok(#("border-style", value)) -> Ok(string.trim(value))
                      _ -> Error(Nil)
                    }
                  })
              }
            })
          {
            Ok("0") | Ok("none") | Ok("0px") -> False
            _ -> True
          }
        }
      }
    }
    _ -> True
  }
}

fn get_element_is_full_width(node: Element) -> Bool {
  case node {
    Element(attributes:, ..) -> {
      let width_attr =
        list.find_map(attributes, fn(attr) {
          case attr.name == "width" {
            True -> Ok(string.trim(attr.value))
            False -> Error(Nil)
          }
        })

      case width_attr {
        Ok("100%") -> True
        _ ->
          case
            list.find_map(attributes, fn(attribute) {
              case attribute.name == "style" {
                False -> Error(Nil)
                True ->
                  string.split(attribute.value, ";")
                  |> list.find_map(fn(style) {
                    case string.split_once(style, ":") {
                      Ok(#("width", value)) -> Ok(string.trim(value))
                      _ -> Error(Nil)
                    }
                  })
              }
            })
          {
            Ok("100%") -> True
            _ -> False
          }
      }
    }
    _ -> False
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

const plain_text_nbsp = "\u{00A0}"

pub fn to_plain_string(
  node: Element,
  wrap_column: Int,
  enable_wrapping: Bool,
) -> String {
  node
  |> to_plain_string_tree(WhiteSpaceNormal, wrap_column, enable_wrapping)
  |> string_tree.to_string
  |> string.remove_suffix("\n\n")
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
  wrap_column: Int,
  enable_wrapping: Bool,
) -> StringTree {
  case node {
    Text(content: "") -> string_tree.new()
    Text(content:) -> {
      case white_space {
        WhiteSpaceNowrap ->
          string_tree.from_string(string.replace(content, " ", plain_text_nbsp))
        _ -> string_tree.from_string(content)
      }
    }
    Element(tag:, void:, ..) if void -> {
      case tag {
        "br" -> string_tree.from_string("\n")
        "hr" ->
          int.range(
            from: 0,
            to: wrap_column,
            with: string_tree.new(),
            run: fn(acc, _) { string_tree.append(acc, "-") },
          )
          |> string_tree.append("\n\n")
        _ -> string_tree.new()
      }
    }
    Element(tag:, children:, attributes:, ..) -> {
      let effective_white_space = case get_element_white_space(node) {
        None -> white_space
        Some(ws) -> ws
      }
      let content = case get_element_display(node) {
        DisplayNewLine -> {
          let content =
            string_tree.new()
            |> children_to_plain_string_tree(
              effective_white_space,
              wrap_column,
              enable_wrapping,
              children,
            )
          case effective_white_space {
            WhiteSpaceNormal | WhiteSpacePreLine if enable_wrapping ->
              wrap_text(content, wrap_column)
            _ -> content
          }
          |> string_tree.append("\n\n")
        }

        DisplayTable(Table) ->
          render_to_plain_string_table(
            white_space,
            wrap_column,
            enable_wrapping,
            children,
            node,
          )

        DisplayInline | DisplayTable(_) -> {
          string_tree.new()
          |> children_to_plain_string_tree(
            effective_white_space,
            wrap_column,
            enable_wrapping,
            children,
          )
        }
        DisplayNone -> string_tree.new()
      }

      case tag {
        "h1" -> content |> string_tree.prepend("# ")
        "h2" -> content |> string_tree.prepend("## ")
        "h3" -> content |> string_tree.prepend("### ")
        "a" ->
          case
            list.find(attributes, fn(attribute) { attribute.name == "href" })
          {
            Ok(link) ->
              content
              |> string_tree.append(": ")
              |> string_tree.append(link.value)
            Error(_) -> content
          }
        _ -> content
      }
    }
    UnsafeInnerHtml(..) -> string_tree.new()
    Fragment(children:) -> {
      string_tree.new()
      |> children_to_plain_string_tree(
        white_space,
        wrap_column,
        enable_wrapping,
        children,
      )
    }
  }
}

fn is_full_width_presentation_table(node: Element) -> Bool {
  case node {
    Element(tag: "table", attributes:, ..) ->
      list.any(attributes, fn(a) {
        a.name == "role" && a.value == "presentation"
      })
      && get_element_is_full_width(node)
    _ -> False
  }
}

fn children_to_plain_string_tree(
  html: StringTree,
  white_space: CascadingWhiteSpace,
  wrap_column: Int,
  enable_wrapping: Bool,
  children: List(Element),
) -> StringTree {
  children
  |> list.fold(#(html, False, False), fn(acc, child) {
    let #(tree, prev_is_section, prev_ends_newline) = acc
    let child_tree =
      to_plain_string_tree(child, white_space, wrap_column, enable_wrapping)
    let is_section = is_full_width_presentation_table(child)
    let tree = case prev_is_section && is_section && !prev_ends_newline {
      True -> string_tree.append(tree, "\n\n")
      False -> tree
    }
    let ends_newline = case is_section {
      True -> string.ends_with(string_tree.to_string(child_tree), "\n\n")
      False -> False
    }
    #(string_tree.append_tree(tree, child_tree), is_section, ends_newline)
  })
  |> fn(acc) { acc.0 }
}

fn table_prepare_row_and_cell(
  row: Element,
  white_space: CascadingWhiteSpace,
  wrap_column: Int,
  enable_wrapping: Bool,
) {
  case row, get_element_display(row) {
    Element(children:, ..), DisplayTable(TableRow) ->
      Ok(
        children
        |> list.filter_map(fn(cell) {
          case get_element_display(cell) {
            DisplayTable(TableCell) ->
              Ok({
                to_plain_string_tree(
                  cell,
                  white_space,
                  wrap_column,
                  enable_wrapping,
                )
                |> string_tree.to_string
                |> string.trim
                |> string.split("\n")
                |> list.filter(fn(l) { l != "" })
              })
            _ -> Error(Nil)
          }
        }),
      )
    _, _ -> Error(Nil)
  }
}

fn table_render_line(
  row: List(List(String)),
  col_widths: List(Int),
  has_border: Bool,
) -> StringTree {
  let max_lines =
    list.fold(row, 1, fn(acc, cell_lines) {
      int.max(acc, list.length(cell_lines))
    })

  int.range(
    from: 0,
    to: max_lines,
    with: string_tree.new(),
    run: fn(acc, line_idx) {
      let line =
        list.index_map(col_widths, fn(w, i) {
          let cell_line = case list.drop(row, i) {
            [cell_lines, ..] ->
              case list.drop(cell_lines, line_idx) {
                [l, ..] -> l
                [] -> ""
              }
            [] -> ""
          }
          " "
          <> cell_line
          <> string.repeat(" ", w - string.length(cell_line) + 1)
        })
        |> fn(cells) {
          let cells = list.map(cells, string_tree.from_string)
          case has_border {
            True ->
              string_tree.join(cells, "|")
              |> string_tree.prepend("|")
              |> string_tree.append("|")
            False -> string_tree.join(cells, " ")
          }
        }
      case line_idx {
        0 -> line
        _ -> acc |> string_tree.append("\n") |> string_tree.append_tree(line)
      }
    },
  )
}

fn render_to_plain_string_table(
  white_space: CascadingWhiteSpace,
  wrap_column: Int,
  enable_wrapping: Bool,
  children: List(Element),
  node: Element,
) -> StringTree {
  let header_rows =
    list.flat_map(children, fn(child) {
      case child, get_element_display(child) {
        Element(tag: "thead", children:, ..), DisplayTable(TableRowGroup) ->
          list.filter_map(children, table_prepare_row_and_cell(
            _,
            white_space,
            wrap_column,
            enable_wrapping,
          ))
        _, _ -> []
      }
    })

  let body_rows =
    list.flat_map(children, fn(child) {
      case child, get_element_display(child) {
        Element(tag: "thead", ..), DisplayTable(TableRowGroup) -> []
        Element(children:, ..), DisplayTable(TableRowGroup) ->
          list.filter_map(children, table_prepare_row_and_cell(
            _,
            white_space,
            wrap_column,
            enable_wrapping,
          ))
        _, _ ->
          case
            table_prepare_row_and_cell(
              child,
              white_space,
              wrap_column,
              enable_wrapping,
            )
          {
            Ok(row) -> [row]
            Error(_) -> []
          }
      }
    })

  let all_rows = list.append(header_rows, body_rows)

  let num_cols =
    list.fold(all_rows, 0, fn(acc, row) { int.max(acc, list.length(row)) })

  let col_widths =
    int.range(from: 0, to: num_cols, with: [], run: fn(acc, i) {
      let w =
        list.fold(all_rows, 0, fn(row_acc, row) {
          case list.drop(row, i) {
            [cell_lines, ..] ->
              list.fold(cell_lines, row_acc, fn(line_acc, line) {
                int.max(line_acc, string.length(line))
              })
            [] -> row_acc
          }
        })
      list.append(acc, [w])
    })

  let has_border = get_element_has_border(node)

  let col_widths = case get_element_is_full_width(node), num_cols > 0 {
    True, True -> {
      let target = case has_border {
        True -> { wrap_column - 1 } / num_cols - 3
        False -> { wrap_column + 1 } / num_cols - 3
      }
      list.map(col_widths, fn(w) { int.max(w, target) })
    }
    _, _ -> col_widths
  }

  let rendered_header =
    list.map(header_rows, table_render_line(_, col_widths, has_border))
  let rendered_body =
    list.map(body_rows, table_render_line(_, col_widths, has_border))

  case rendered_header, rendered_body {
    [], [] -> string_tree.new()
    [], _ -> string_tree.join(rendered_body, "\n")
    _, [] -> string_tree.join(rendered_header, "\n")
    _, _ -> {
      let separator = case has_border {
        True ->
          col_widths
          |> list.map(fn(w) {
            string_tree.from_string(string.repeat("-", w + 2))
          })
          |> string_tree.join("+")
          |> string_tree.prepend("|")
          |> string_tree.append("|")
        False ->
          col_widths
          |> list.map(fn(w) {
            string_tree.from_string(string.repeat(" ", w + 2))
          })
          |> string_tree.join(" ")
      }

      string_tree.concat([
        string_tree.join(rendered_header, "\n"),
        separator |> string_tree.prepend("\n") |> string_tree.append("\n"),
        string_tree.join(rendered_body, "\n"),
      ])
    }
  }
  |> string_tree.append("\n\n")
}
