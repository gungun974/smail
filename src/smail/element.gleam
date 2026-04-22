//// Write HTML compliant emails with peace of mind, like
//// [Lustre](https://hex.pm/packages/lustre).
////
//// `smail` is a library for composing HTML emails in Gleam. It handles all
//// the quirks of email client rendering (Outlook MSO, Yahoo, AOL, Apple
//// Mail, etc.) through the [`smail/element/email`](./element/email.html)
//// module so you can focus on content rather than compatibility.
////
//// Once your email is composed, use the rendering functions to produce the
//// final output:
////
//// - [`to_html`](#to_html) — renders the element tree to an HTML string
////   ready to be sent as the body of an HTML email.
//// - [`to_plain_text`](#to_plain_text) — renders the element tree to a plain
////   text fallback for email clients that do not support HTML.

import smail/attribute.{type Attribute}
import smail/internal/vnode

// TYPES -----------------------------------------------------------------------

pub type Element =
  vnode.Element

// CONSTRUCTORS ----------------------------------------------------------------

/// Creates an HTML element with the given tag name, attributes, and children.
/// Void elements (such as `<img>` or `<br>`) are detected automatically and
/// rendered without a closing tag.
///
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

/// Like [`element`](#element) but lets you explicitly control whether the
/// element is void. Use this when you need a custom tag that should be
/// rendered without a closing tag.
///
pub fn advanced(
  tag: String,
  attributes: List(Attribute),
  children: List(Element),
  void: Bool,
) -> Element {
  vnode.element(tag:, attributes:, children:, void:)
}

/// Creates a text node. HTML special characters in `content` are escaped
/// automatically.
///
pub fn text(content: String) -> Element {
  vnode.text(content:)
}

/// Creates an empty element that renders nothing. Useful for conditionally
/// including or omitting content without changing the structure of the tree.
///
pub fn none() -> Element {
  vnode.text(content: "")
}

/// Groups multiple elements together without introducing a wrapping tag in
/// the rendered output.
///
pub fn fragment(children: List(Element)) -> Element {
  vnode.fragment(children:)
}

/// Creates an element whose inner content is set directly from a raw HTML
/// string without any escaping. The provided HTML is injected as-is into
/// the output.
///
/// > **Warning**: never pass untrusted user input to this function as it will
/// > be rendered verbatim, which may introduce XSS vulnerabilities.
///
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

/// Renders an element tree to a plain text string. Lines are wrapped at
/// 72 characters by default.
///
/// Use [`advanced_to_plain_text`](#advanced_to_plain_text) to customise the
/// wrapping behaviour.
///
pub fn to_plain_text(el: Element) -> String {
  vnode.to_plain_string(el, 72, True)
}

pub type PlainTextConfig {
  PlainTextConfig(wrap_column: Int, enable_wrapping: Bool)
}

/// Like [`to_plain_text`](#to_plain_text) but accepts a `PlainTextConfig` to
/// control the column at which lines are wrapped and whether wrapping is
/// enabled at all.
///
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
