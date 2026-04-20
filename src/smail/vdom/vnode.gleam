// IMPORTS ---------------------------------------------------------------------

import gleam/list
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

// STRING RENDERING ------------------------------------------------------------

pub fn to_string(node: Element) -> String {
  node
  |> to_string_tree()
  |> string_tree.to_string
}

pub fn to_string_tree(node: Element) -> StringTree {
  case node {
    Text(content: "") -> string_tree.new()
    Text(content:) -> string_tree.from_string(houdini.escape(content))

    Element(tag:, attributes:, void:, ..) if void -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
    }

    Element(tag:, attributes:, children:, ..) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> children_to_string_tree(children)
      |> string_tree.append("</" <> tag <> ">")
    }

    UnsafeInnerHtml(tag:, attributes:, inner_html:) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> string_tree.append(inner_html)
      |> string_tree.append("</" <> tag <> ">")
    }

    Fragment(children:) -> {
      marker_comment("smail:fragment")
      |> children_to_string_tree(children)
      |> string_tree.append_tree(marker_comment("/smail:fragment"))
    }
  }
}

fn children_to_string_tree(
  html: StringTree,
  children: List(Element),
) -> StringTree {
  use html, child <- list.fold(children, html)
  string_tree.append_tree(html, to_string_tree(child))
}

pub fn to_snapshot(node: Element, debug: Bool) -> String {
  do_to_snapshot_builder(node:, raw: False, debug:, indent: 0)
  |> string_tree.to_string
}

fn do_to_snapshot_builder(
  node node: Element,
  raw raw: Bool,
  debug debug: Bool,
  indent indent: Int,
) -> StringTree {
  let spaces = string.repeat("  ", indent)

  case node {
    Text(content: "") -> string_tree.new()
    Text(content:) if raw -> string_tree.from_strings([spaces, content])
    Text(content:) ->
      string_tree.from_strings([spaces, houdini.escape(content)])

    Element(tag:, attributes:, void: True, ..) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.prepend(spaces)
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
    }

    Element(tag:, attributes:, children: [], ..) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.prepend(spaces)
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> string_tree.append("</" <> tag <> ">")
    }

    Element(tag:, attributes:, children:, ..) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)
      html
      |> string_tree.prepend(spaces)
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">\n")
      |> children_to_snapshot_builder(
        children:,
        raw:,
        debug:,
        indent: indent + 1,
      )
      |> string_tree.append(spaces)
      |> string_tree.append("</" <> tag <> ">")
    }

    UnsafeInnerHtml(tag:, attributes:, inner_html:) -> {
      let html = string_tree.from_string("<" <> tag)
      let attributes = vattr.to_string_tree(attributes)

      html
      |> string_tree.prepend(spaces)
      |> string_tree.append_tree(attributes)
      |> string_tree.append(">")
      |> string_tree.append(inner_html)
      |> string_tree.append("</" <> tag <> ">")
    }

    Fragment(children:) if debug -> {
      marker_comment("smail:fragment")
      |> string_tree.prepend(spaces)
      |> string_tree.append("\n")
      |> children_to_snapshot_builder(
        children:,
        raw:,
        debug:,
        indent: indent + 1,
      )
      |> string_tree.append(spaces)
      |> string_tree.append_tree(marker_comment("/smail:fragment"))
    }

    Fragment(children:) ->
      children_to_snapshot_builder(
        html: string_tree.new(),
        children: children,
        raw: raw,
        debug: debug,
        indent: indent,
      )
  }
}

fn children_to_snapshot_builder(
  html html: StringTree,
  children children: List(Element),
  raw raw: Bool,
  debug debug: Bool,
  indent indent: Int,
) -> StringTree {
  case children {
    [Text(content: a), Text(content: b), ..rest] ->
      children_to_snapshot_builder(
        html:,
        children: [Text(content: a <> b), ..rest],
        raw:,
        debug:,
        indent:,
      )

    [child, ..rest] ->
      child
      |> do_to_snapshot_builder(raw:, debug:, indent:)
      |> string_tree.append("\n")
      |> string_tree.prepend_tree(html)
      |> children_to_snapshot_builder(children: rest, raw:, debug:, indent:)

    [] -> html
  }
}

fn marker_comment(label: String) {
  string_tree.from_string("<!-- " <> label <> " -->")
}
