import smail/attribute.{type Attribute}
import smail/internal/vnode

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

/// Converts an element to an HTML email.
///
/// ## Example
///
/// ```gleam
/// import smail/email
/// import smail/element/html
///
/// email.html([], [
///   email.head([], []),
///   email.body([], [html.text("Hello!")]),
/// ])
/// |> email.to_html
/// ```
///
pub fn to_html(el: Element) -> String {
  "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
  <> vnode.to_html_string(wrap_document(el))
}

pub fn to_plain_text(el: Element) -> String {
  vnode.to_plain_string(el, 72, True)
}

pub type PlainTextConfig {
  PlainTextConfig(wrap_column: Int, enable_wrapping: Bool)
}

pub fn advanced_to_plain_text(el: Element, config: PlainTextConfig) -> String {
  vnode.to_plain_string(el, config.wrap_column, config.enable_wrapping)
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
    vnode.Element(tag: "html", ..) | vnode.UnsafeInnerHtml(tag: "html", ..) ->
      Html
    vnode.Element(tag: "head", ..) | vnode.UnsafeInnerHtml(tag: "head", ..) ->
      HeadOnly
    vnode.Element(tag: "body", ..) | vnode.UnsafeInnerHtml(tag: "body", ..) ->
      BodyOnly
    vnode.Fragment(children: [child]) -> get_document_type(child)
    vnode.Fragment(children: [head, body]) ->
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
