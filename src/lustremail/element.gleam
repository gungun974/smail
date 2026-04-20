import gleam/string_tree.{type StringTree}
import lustremail/attribute.{type Attribute}
import lustremail/vdom/vnode.{Element, Fragment, UnsafeInnerHtml}

// TYPES -----------------------------------------------------------------------

pub type Element =
  vnode.Element

// CONSTRUCTORS ----------------------------------------------------------------

pub fn element(
  tag: String,
  attributes: List(Attribute),
  children: List(Element),
) -> Element {
  vnode.element(
    tag: tag,
    attributes:,
    children: children,
    void: vnode.is_void_html_element(tag),
  )
}

pub fn advanced(
  tag: String,
  attributes: List(Attribute),
  children: List(Element),
  void: Bool,
) -> Element {
  vnode.element(tag:, attributes:, children:, void:)
}

pub fn text(content: String) -> Element {
  vnode.text(content:)
}

pub fn none() -> Element {
  vnode.text(content: "")
}

pub fn fragment(children: List(Element)) -> Element {
  vnode.fragment(children:)
}

pub fn unsafe_raw_html(
  tag: String,
  attributes: List(Attribute),
  inner_html: String,
) -> Element {
  vnode.unsafe_inner_html(tag:, attributes:, inner_html:)
}

// CONVERSIONS -----------------------------------------------------------------

pub fn to_string(element: Element) -> String {
  vnode.to_string(element)
}

pub fn to_document_string(el: Element) -> String {
  "<!doctype html>\n" <> vnode.to_string(wrap_document(el))
}

pub fn to_string_tree(element: Element) -> StringTree {
  vnode.to_string_tree(element)
}

pub fn to_document_string_tree(el: Element) -> StringTree {
  string_tree.from_string("<!doctype html>\n")
  |> string_tree.append_tree(vnode.to_string_tree(wrap_document(el)))
}

type DocumentType {
  Html
  HeadOnly
  BodyOnly
  HeadAndBody
  Other
}

fn get_document_type(el: Element) -> DocumentType {
  case el {
    Element(tag: "html", ..) | UnsafeInnerHtml(tag: "html", ..) -> Html
    Element(tag: "head", ..) | UnsafeInnerHtml(tag: "head", ..) -> HeadOnly
    Element(tag: "body", ..) | UnsafeInnerHtml(tag: "body", ..) -> BodyOnly
    Fragment(children: [child]) -> get_document_type(child)
    Fragment(children: [head, body]) ->
      case get_document_type(head), get_document_type(body) {
        HeadOnly, BodyOnly -> HeadAndBody
        _, _ -> Other
      }
    _ -> Other
  }
}

fn wrap_document(el: Element) -> Element {
  case get_document_type(el) {
    Html -> el
    HeadOnly | BodyOnly | HeadAndBody -> element("html", [], [el])
    Other -> element("html", [], [element("body", [], [el])])
  }
}
