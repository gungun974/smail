// IMPORTS ---------------------------------------------------------------------

import lustremail/attribute.{type Attribute}
import lustremail/element.{type Element, element}
import lustremail/internals/constants

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
pub fn article(attrs: List(Attribute), children: List(Element)) -> Element {
  element("article", attrs, children)
}

///
pub fn aside(attrs: List(Attribute), children: List(Element)) -> Element {
  element("aside", attrs, children)
}

///
pub fn footer(attrs: List(Attribute), children: List(Element)) -> Element {
  element("footer", attrs, children)
}

///
pub fn header(attrs: List(Attribute), children: List(Element)) -> Element {
  element("header", attrs, children)
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

///
pub fn hgroup(attrs: List(Attribute), children: List(Element)) -> Element {
  element("hgroup", attrs, children)
}

///
pub fn main(attrs: List(Attribute), children: List(Element)) -> Element {
  element("main", attrs, children)
}

///
pub fn nav(attrs: List(Attribute), children: List(Element)) -> Element {
  element("nav", attrs, children)
}

///
pub fn section(attrs: List(Attribute), children: List(Element)) -> Element {
  element("section", attrs, children)
}

///
pub fn search(attrs: List(Attribute), children: List(Element)) -> Element {
  element("search", attrs, children)
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
pub fn menu(attrs: List(Attribute), children: List(Element)) -> Element {
  element("menu", attrs, children)
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
pub fn audio(attrs: List(Attribute), children: List(Element)) -> Element {
  element("audio", attrs, children)
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

///
pub fn track(attrs: List(Attribute)) -> Element {
  element("track", attrs, constants.empty_list)
}

///
pub fn video(attrs: List(Attribute), children: List(Element)) -> Element {
  element("video", attrs, children)
}

// HTML ELEMENTS: EMBEDDED CONTENT ---------------------------------------------

///
pub fn embed(attrs: List(Attribute)) -> Element {
  element("embed", attrs, constants.empty_list)
}

///
pub fn iframe(attrs: List(Attribute)) -> Element {
  element("iframe", attrs, constants.empty_list)
}

///
pub fn object(attrs: List(Attribute)) -> Element {
  element("object", attrs, constants.empty_list)
}

///
pub fn picture(attrs: List(Attribute), children: List(Element)) -> Element {
  element("picture", attrs, children)
}

///
pub fn portal(attrs: List(Attribute)) -> Element {
  element("portal", attrs, constants.empty_list)
}

///
pub fn source(attrs: List(Attribute)) -> Element {
  element("source", attrs, constants.empty_list)
}

// HTML ELEMENTS: SCRIPTING ----------------------------------------------------

///
pub fn canvas(attrs: List(Attribute)) -> Element {
  element("canvas", attrs, constants.empty_list)
}

///
pub fn noscript(attrs: List(Attribute), children: List(Element)) -> Element {
  element("noscript", attrs, children)
}

///
pub fn script(attrs: List(Attribute), js: String) -> Element {
  element.unsafe_raw_html("script", attrs, js)
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

// HTML ELEMENTS: FORMS --------------------------------------------------------

///
pub fn button(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("button", attrs, children)
}

///
pub fn datalist(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("datalist", attrs, children)
}

///
pub fn fieldset(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("fieldset", attrs, children)
}

///
pub fn form(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("form", attrs, children)
}

///
pub fn input(attrs: List(Attribute)) -> Element {
  element.element("input", attrs, constants.empty_list)
}

///
pub fn label(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("label", attrs, children)
}

///
pub fn legend(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("legend", attrs, children)
}

///
pub fn meter(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("meter", attrs, children)
}

///
pub fn optgroup(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("optgroup", attrs, children)
}

///
pub fn option(attrs: List(Attribute), label: String) -> Element {
  element.element("option", attrs, [element.text(label)])
}

///
pub fn output(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("output", attrs, children)
}

///
pub fn progress(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("progress", attrs, children)
}

///
pub fn select(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("select", attrs, children)
}

///
pub fn textarea(attrs: List(Attribute), content: String) -> Element {
  element.element("textarea", attrs, [element.text(content)])
}

// HTML ELEMENTS: INTERACTIVE ELEMENTS -----------------------------------------

///
pub fn details(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("details", attrs, children)
}

///
pub fn dialog(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("dialog", attrs, children)
}

///
pub fn summary(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("summary", attrs, children)
}

// HTML ELEMENTS: WEB COMPONENTS -----------------------------------------------

///
pub fn slot(attrs: List(Attribute), fallback: List(Element)) -> Element {
  element.element("slot", attrs, fallback)
}

///
pub fn template(attrs: List(Attribute), children: List(Element)) -> Element {
  element.element("template", attrs, children)
}
