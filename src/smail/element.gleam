import smail/attribute.{type Attribute}
import smail/vdom/vnode

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
