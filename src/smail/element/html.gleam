// IMPORTS ---------------------------------------------------------------------

import smail/attribute.{type Attribute}
import smail/element.{type Element, element}
import smail/internals/constants

// HTML ELEMENTS: MAIN ROOT ----------------------------------------------------

///
pub fn html(attrs: List(Attribute), children: List(Element)) -> Element {
  element("html", attrs, children)
}

pub fn text(content: String) -> Element {
  element.text(content)
}

// HTML ELEMENTS: DOCUMENT METADATA --------------------------------------------

///
pub fn base(attrs: List(Attribute)) -> Element {
  element("base", attrs, constants.empty_list)
}

///
pub fn head(attrs: List(Attribute), children: List(Element)) -> Element {
  element("head", attrs, children)
}

///
pub fn link(attrs: List(Attribute)) -> Element {
  element("link", attrs, constants.empty_list)
}

///
pub fn meta(attrs: List(Attribute)) -> Element {
  element("meta", attrs, constants.empty_list)
}

///
pub fn style(attrs: List(Attribute), css: String) -> Element {
  element.unsafe_raw_html("style", attrs, css)
}

///
pub fn title(attrs: List(Attribute), content: String) -> Element {
  element("title", attrs, [text(content)])
}

// HTML ELEMENTS: SECTIONING ROOT -----------------------------------------------

///
pub fn body(attrs: List(Attribute), children: List(Element)) -> Element {
  element("body", attrs, children)
}

// HTML ELEMENTS: CONTENT SECTIONING -------------------------------------------

///
pub fn address(attrs: List(Attribute), children: List(Element)) -> Element {
  element("address", attrs, children)
}

///
pub fn h1(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h1", attrs, children)
}

///
pub fn h2(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h2", attrs, children)
}

///
pub fn h3(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h3", attrs, children)
}

///
pub fn h4(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h4", attrs, children)
}

///
pub fn h5(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h5", attrs, children)
}

///
pub fn h6(attrs: List(Attribute), children: List(Element)) -> Element {
  element("h6", attrs, children)
}

// HTML ELEMENTS: TEXT CONTENT -------------------------------------------------

///
pub fn blockquote(attrs: List(Attribute), children: List(Element)) -> Element {
  element("blockquote", attrs, children)
}

///
pub fn dd(attrs: List(Attribute), children: List(Element)) -> Element {
  element("dd", attrs, children)
}

///
pub fn div(attrs: List(Attribute), children: List(Element)) -> Element {
  element("div", attrs, children)
}

///
pub fn dl(attrs: List(Attribute), children: List(Element)) -> Element {
  element("dl", attrs, children)
}

///
pub fn dt(attrs: List(Attribute), children: List(Element)) -> Element {
  element("dt", attrs, children)
}

///
pub fn figcaption(attrs: List(Attribute), children: List(Element)) -> Element {
  element("figcaption", attrs, children)
}

///
pub fn figure(attrs: List(Attribute), children: List(Element)) -> Element {
  element("figure", attrs, children)
}

///
pub fn hr(attrs: List(Attribute)) -> Element {
  element("hr", attrs, constants.empty_list)
}

///
pub fn li(attrs: List(Attribute), children: List(Element)) -> Element {
  element("li", attrs, children)
}

///
pub fn ol(attrs: List(Attribute), children: List(Element)) -> Element {
  element("ol", attrs, children)
}

///
pub fn p(attrs: List(Attribute), children: List(Element)) -> Element {
  element("p", attrs, children)
}

///
pub fn pre(attrs: List(Attribute), children: List(Element)) -> Element {
  element("pre", attrs, children)
}

///
pub fn ul(attrs: List(Attribute), children: List(Element)) -> Element {
  element("ul", attrs, children)
}

// HTML ELEMENTS: INLINE TEXT SEMANTICS ----------------------------------------

///
pub fn a(attrs: List(Attribute), children: List(Element)) -> Element {
  element("a", attrs, children)
}

///
pub fn abbr(attrs: List(Attribute), children: List(Element)) -> Element {
  element("abbr", attrs, children)
}

///
pub fn b(attrs: List(Attribute), children: List(Element)) -> Element {
  element("b", attrs, children)
}

///
pub fn bdi(attrs: List(Attribute), children: List(Element)) -> Element {
  element("bdi", attrs, children)
}

///
pub fn bdo(attrs: List(Attribute), children: List(Element)) -> Element {
  element("bdo", attrs, children)
}

///
pub fn br(attrs: List(Attribute)) -> Element {
  element("br", attrs, constants.empty_list)
}

///
pub fn cite(attrs: List(Attribute), children: List(Element)) -> Element {
  element("cite", attrs, children)
}

///
pub fn code(attrs: List(Attribute), children: List(Element)) -> Element {
  element("code", attrs, children)
}

///
pub fn data(attrs: List(Attribute), children: List(Element)) -> Element {
  element("data", attrs, children)
}

///
pub fn dfn(attrs: List(Attribute), children: List(Element)) -> Element {
  element("dfn", attrs, children)
}

///
pub fn em(attrs: List(Attribute), children: List(Element)) -> Element {
  element("em", attrs, children)
}

///
pub fn i(attrs: List(Attribute), children: List(Element)) -> Element {
  element("i", attrs, children)
}

///
pub fn kbd(attrs: List(Attribute), children: List(Element)) -> Element {
  element("kbd", attrs, children)
}

///
pub fn mark(attrs: List(Attribute), children: List(Element)) -> Element {
  element("mark", attrs, children)
}

///
pub fn q(attrs: List(Attribute), children: List(Element)) -> Element {
  element("q", attrs, children)
}

///
pub fn rp(attrs: List(Attribute), children: List(Element)) -> Element {
  element("rp", attrs, children)
}

///
pub fn rt(attrs: List(Attribute), children: List(Element)) -> Element {
  element("rt", attrs, children)
}

///
pub fn ruby(attrs: List(Attribute), children: List(Element)) -> Element {
  element("ruby", attrs, children)
}

///
pub fn s(attrs: List(Attribute), children: List(Element)) -> Element {
  element("s", attrs, children)
}

///
pub fn samp(attrs: List(Attribute), children: List(Element)) -> Element {
  element("samp", attrs, children)
}

///
pub fn small(attrs: List(Attribute), children: List(Element)) -> Element {
  element("small", attrs, children)
}

///
pub fn span(attrs: List(Attribute), children: List(Element)) -> Element {
  element("span", attrs, children)
}

///
pub fn strong(attrs: List(Attribute), children: List(Element)) -> Element {
  element("strong", attrs, children)
}

///
pub fn sub(attrs: List(Attribute), children: List(Element)) -> Element {
  element("sub", attrs, children)
}

///
pub fn sup(attrs: List(Attribute), children: List(Element)) -> Element {
  element("sup", attrs, children)
}

///
pub fn time(attrs: List(Attribute), children: List(Element)) -> Element {
  element("time", attrs, children)
}

///
pub fn u(attrs: List(Attribute), children: List(Element)) -> Element {
  element("u", attrs, children)
}

///
pub fn var(attrs: List(Attribute), children: List(Element)) -> Element {
  element("var", attrs, children)
}

///
pub fn wbr(attrs: List(Attribute)) -> Element {
  element("wbr", attrs, constants.empty_list)
}

// HTML ELEMENTS: IMAGE AND MULTIMEDIA -----------------------------------------

///
pub fn area(attrs: List(Attribute)) -> Element {
  element("area", attrs, constants.empty_list)
}

///
pub fn img(attrs: List(Attribute)) -> Element {
  element("img", attrs, constants.empty_list)
}

/// Used with <area> elements to define an image map (a clickable link area).
///
pub fn map(attrs: List(Attribute), children: List(Element)) -> Element {
  element("map", attrs, children)
}

// HTML ELEMENTS: DEMARCATING EDITS ---------------------------------------------

///
pub fn del(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("del", attrs, children)
}

///
pub fn ins(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("ins", attrs, children)
}

// HTML ELEMENTS: TABLE CONTENT ------------------------------------------------

///
pub fn caption(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("caption", attrs, children)
}

///
pub fn col(attrs: List(Attribute)) -> Element {
  element.element("col", attrs, constants.empty_list)
}

///
pub fn colgroup(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("colgroup", attrs, children)
}

///
pub fn table(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("table", attrs, children)
}

///
pub fn tbody(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("tbody", attrs, children)
}

///
pub fn td(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("td", attrs, children)
}

///
pub fn tfoot(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("tfoot", attrs, children)
}

///
pub fn th(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("th", attrs, children)
}

///
pub fn thead(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("thead", attrs, children)
}

///
pub fn tr(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("tr", attrs, children)
}
