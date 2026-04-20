//// Write HTML compliant email with peace of mind and [Lustre](https://hex.pm/packages/lustre) 😌
////
//// This module provides a set of components that produce HTML output
//// compatible with email clients. It handles the quirks of email rendering
//// (Outlook MSO, Yahoo, AOL, Apple Mail, etc.) so you can write emails
//// with ease of mind and less table.
////
//// Use `to_string` to render the final HTML string to send as the body
//// of an HTML email.

import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import lustremail/attribute.{type Attribute}
import lustremail/element.{type Element}
import lustremail/element/html

/// Converts an element to a string with XHTML 1.0 doctype.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.html([], [
///   email.head([], []),
///   email.body([], [], [html.text("Hello!")]),
/// ])
/// |> email.to_html
/// // -> "<!DOCTYPE html PUBLIC ...><html>...</html>"
/// ```
///
pub fn to_html(el: Element) -> String {
  element.to_document_string(el)
  |> string.replace(
    "<!doctype html>",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">",
  )
}

/// Render the root `<html>` element.
///
/// Thin wrapper around `lustre/element/html.html`.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
///
/// email.html([], [
///   email.head([], []),
///   email.body([], [], []),
/// ])
/// ```
///
pub fn html(attrs: List(Attribute), children: List(Element)) {
  html.html(attrs, children)
}

/// Render the `<head>` element with email-required meta tags prepended.
///
/// Automatically inserts two meta tags before any provided children:
/// - `Content-Type: text/html; charset=UTF-8` — ensures correct character encoding.
/// - `x-apple-disable-message-reformatting` — prevents Apple Mail from resizing
///   or reformatting the email layout on iOS devices.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.head([], [
///   html.meta([
///     attribute.name("color-scheme"),
///     attribute.content("light"),
///   ]),
/// ])
/// ```
///
pub fn head(attrs: List(Attribute), children: List(Element)) -> Element {
  html.head(attrs, [
    html.meta([
      attribute.content("text/html; charset=UTF-8"),
      attribute.http_equiv("Content-Type"),
    ]),
    html.meta([
      attribute.name("x-apple-disable-message-reformatting"),
    ]),
    ..children
  ])
}

/// A CSS generic or named fallback font family.
///
pub type FallbackFont {
  Arial
  Helvetica
  Verdana
  Georgia
  TimesNewRoman
  Serif
  SansSerif
  Monospace
  Cursive
  Fantasy
  CustomFallback(String)
}

/// The format of a web font file, used in the `src:` declaration of `@font-face`.
///
pub type FontFormat {
  Woff
  Woff2
  TrueType
  OpenType
  EmbeddedOpenType
  Svg
}

/// The CSS `font-weight` value for a web font.
///
pub type FontWeight {
  WeightNormal
  WeightBold
  WeightBolder
  WeightLighter
  Weight100
  Weight200
  Weight300
  Weight400
  Weight500
  Weight600
  Weight700
  Weight800
  Weight900
}

/// The CSS `font-style` value for a web font.
///
pub type FontStyle {
  StyleNormal
  StyleItalic
  StyleOblique
}

/// A remote web font to load via `@font-face`.
///
pub type WebFont {
  WebFont(url: String, format: FontFormat)
}

pub type FontParams {
  FontParams
}

fn fallback_font_to_string(font: FallbackFont) -> String {
  case font {
    Arial -> "Arial"
    Helvetica -> "Helvetica"
    Verdana -> "Verdana"
    Georgia -> "Georgia"
    TimesNewRoman -> "Times New Roman"
    Serif -> "serif"
    SansSerif -> "sans-serif"
    Monospace -> "monospace"
    Cursive -> "cursive"
    Fantasy -> "fantasy"
    CustomFallback(s) -> s
  }
}

fn font_format_to_string(format: FontFormat) -> String {
  case format {
    Woff -> "woff"
    Woff2 -> "woff2"
    TrueType -> "truetype"
    OpenType -> "opentype"
    EmbeddedOpenType -> "embedded-opentype"
    Svg -> "svg"
  }
}

fn font_weight_to_string(weight: FontWeight) -> String {
  case weight {
    WeightNormal -> "normal"
    WeightBold -> "bold"
    WeightBolder -> "bolder"
    WeightLighter -> "lighter"
    Weight100 -> "100"
    Weight200 -> "200"
    Weight300 -> "300"
    Weight400 -> "400"
    Weight500 -> "500"
    Weight600 -> "600"
    Weight700 -> "700"
    Weight800 -> "800"
    Weight900 -> "900"
  }
}

fn font_style_to_string(style: FontStyle) -> String {
  case style {
    StyleNormal -> "normal"
    StyleItalic -> "italic"
    StyleOblique -> "oblique"
  }
}

/// Generate a `<style>` element that declares a custom web font and applies it globally.
///
/// ## Example
///
/// ```gleam
/// import gleam/option
/// import lustremail/email
///
/// email.font(
///   family: "Josefin Sans",
///   fallback_family: [email.Verdana, email.SansSerif],
///   web_font: option.Some(email.WebFont(
///     url: "https://fonts.gstatic.com/s/josefinsans/v32/Qw3aZQNVED7rKGKxtqIqX5EUDXx4.woff2",
///     format: email.Woff2,
///   )),
///   weight: option.None,
///   style: option.None,
/// )
/// ```
///
pub fn font(
  family font_family: String,
  fallback_family fallback_font_family: List(FallbackFont),
  web_font web_font: Option(WebFont),
  weight font_weight: Option(FontWeight),
  style font_style: Option(FontStyle),
) {
  let font_style_css = case font_style {
    Some(style) -> "font-style:" <> font_style_to_string(style) <> ";"
    None -> ""
  }

  let font_weight_css = case font_weight {
    Some(weight) -> "font-weight:" <> font_weight_to_string(weight) <> ";"
    None -> ""
  }

  let mso_alt_css = case fallback_font_family {
    [first, ..] -> "mso-font-alt:'" <> fallback_font_to_string(first) <> "';"
    [] -> ""
  }

  let src_css = case web_font {
    Some(WebFont(url, format)) ->
      "src:url(" <> url <> ") format('" <> font_format_to_string(format) <> "')"
    None -> ""
  }

  let fallbacks =
    fallback_font_family
    |> list.map(fallback_font_to_string)
    |> list.map(fn(f) { "," <> f })
    |> string.join("")

  html.style(
    [],
    "@font-face{"
      <> "font-family:'"
      <> font_family
      <> "';"
      <> font_style_css
      <> font_weight_css
      <> mso_alt_css
      <> src_css
      <> "}"
      <> "*{font-family:'"
      <> font_family
      <> "'"
      <> fallbacks
      <> "}",
  )
}

/// Render the email `<body>` element with cross-client compatibility fixes.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.body(
///   [#("background-color", "#f6f6f6"), #("padding", "20px 0")],
///   [],
///   [html.text("Email content here")],
/// )
/// ```
///
pub fn body(
  styles: List(#(String, String)),
  attrs: List(Attribute),
  children: List(Element),
) -> Element {
  html.body(
    [
      attribute.styles(
        list.filter(styles, fn(style) {
          case style.0 {
            "margin" -> False
            "margin-left" -> False
            "margin-right" -> False
            "margin-top" -> False
            "margin-bottom" -> False
            _ -> True
          }
        }),
      ),
      ..attrs
    ],
    [
      html.table(
        [
          attribute.attribute("align", "center"),
          attribute.role("presentation"),
          attribute.attribute("cellspacing", "0"),
          attribute.attribute("cellpadding", "0"),
          attribute.attribute("width", "100%"),
          attribute.attribute("border", "0"),
        ],
        [
          html.tbody([], [
            html.tr([], [
              // Yahoo and AOL remove all styles of the body element while converting it to a div,
              // so we need to apply them to to an inner cell.
              //
              // See https://github.com/resend/react-email/issues/662.
              html.td([attribute.styles(styles)], children),
            ]),
          ]),
        ],
      ),
    ],
  )
}

/// Render a centered email container with a maximum width of 600 px (37.5 em).
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.body([], [], [
///   email.container([], [
///     html.text("Centered content, max 600px wide"),
///   ]),
/// ])
/// ```
///
pub fn container(attrs: List(Attribute), children: List(Element)) -> Element {
  html.table(
    [
      attribute.role("presentation"),
      attribute.attribute("cellspacing", "0"),
      attribute.attribute("cellpadding", "0"),
      attribute.attribute("border", "0"),
      attribute.attribute("width", "100%"),
      attribute.attribute("align", "center"),
      attribute.style("max-width", "37.5em"),
      ..attrs
    ],
    [
      html.tbody([], [
        html.tr([attribute.style("width", "100%")], [
          html.td([], children),
        ]),
      ]),
    ],
  )
}

/// Render a full-width layout section.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.container([], [
///   email.section([], [
///     email.text([], [html.text("First section")]),
///   ]),
///   email.section([], [
///     email.text([], [html.text("Second section")]),
///   ]),
/// ])
/// ```
///
pub fn section(attrs: List(Attribute), children: List(Element)) -> Element {
  html.table(
    [
      attribute.role("presentation"),
      attribute.attribute("cellspacing", "0"),
      attribute.attribute("cellpadding", "0"),
      attribute.attribute("border", "0"),
      attribute.attribute("width", "100%"),
      attribute.attribute("align", "center"),
      ..attrs
    ],
    [
      html.tbody([], [
        html.tr([], [
          html.td([], children),
        ]),
      ]),
    ],
  )
}

/// Render an `<img>` element with email-safe default styles.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/attribute
///
/// email.img([
///   attribute.src("https://example.com/logo.png"),
///   attribute.alt("Company logo"),
///   attribute.width(200),
/// ])
/// ```
///
pub fn img(attrs: List(Attribute)) {
  html.img([
    attribute.style("display", "block"),
    attribute.style("outline", "none"),
    attribute.style("border", "none"),
    attribute.style("text-decoration", "none"),
    ..attrs
  ])
}

/// Render a paragraph `<p>` with email-safe default typography.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.text([], [
///   html.text("Your order has been confirmed."),
/// ])
/// ```
///
pub fn text(attrs: List(Attribute), children: List(Element)) -> Element {
  html.p(
    [
      attribute.style("font-size", "14px"),
      attribute.style("line-height", "24px"),
      attribute.style("border", "none"),
      attribute.style("text-decoration", "none"),
      ..attrs
    ],
    children,
  )
}

/// Render a horizontal rule `<hr>` styled as a thin separator line.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.section([], [
///   email.text([], [html.text("Above the line")]),
///   email.hr([]),
///   email.text([], [html.text("Below the line")]),
/// ])
/// ```
///
pub fn hr(attrs: List(Attribute)) -> Element {
  html.hr([
    attribute.style("width", "100%"),
    attribute.style("border", "none"),
    attribute.style("border-top", "1px solid #eaeaea"),
    ..attrs
  ])
}

/// Render an `<a>` link with email-safe default styles.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/attribute
/// import lustre/element/html
///
/// email.link(
///   [attribute.href("https://example.com")],
///   [html.text("Visit our website")],
/// )
/// ```
///
pub fn link(attrs: List(Attribute), children: List(Element)) -> Element {
  html.a(
    [
      attribute.target("_blank"),
      attribute.style("color", "#067df7"),
      attribute.style("text-decoration-line", "none"),
      ..attrs
    ],
    children,
  )
}

const preview_max_length = 150

const whitespace_codes = "\u{00A0}\u{200C}\u{200B}\u{200D}\u{200E}\u{200F}\u{FEFF}"

/// Render a hidden preview text node shown in email client inbox previews.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
///
/// email.html([], [
///   email.head([], []),
///   email.body([], [], [
///     email.preview("Your order #1234 has been shipped!"),
///     email.container([], []),
///   ]),
/// ])
/// ```
///
pub fn preview(text: String) -> Element {
  let truncated = string.slice(text, at_index: 0, length: preview_max_length)
  let truncated_length = string.length(truncated)

  let whitespace_node = case truncated_length < preview_max_length {
    True ->
      html.div([], [
        html.text(string.repeat(
          whitespace_codes,
          preview_max_length - truncated_length,
        )),
      ])
    False -> html.text("")
  }

  html.div(
    [
      attribute.style("display", "none"),
      attribute.style("overflow", "hidden"),
      attribute.style("line-height", "1px"),
      attribute.style("opacity", "0"),
      attribute.style("max-height", "0"),
      attribute.style("max-width", "0"),
    ],
    [html.text(truncated), whitespace_node],
  )
}

fn px_to_pt(px: Int) -> Float {
  int.to_float(px) *. 0.75
}

fn do_compute_font_width_and_space_count(
  expected_width: Int,
  count: Int,
) -> #(Float, Int) {
  let font_width = int.to_float(expected_width) /. int.to_float(count) /. 2.0
  case font_width <=. 5.0 {
    True -> #(font_width, count)
    False -> do_compute_font_width_and_space_count(expected_width, count + 1)
  }
}

fn compute_font_width_and_space_count(expected_width: Int) -> #(Float, Int) {
  case expected_width {
    0 -> #(0.0, 0)
    _ -> do_compute_font_width_and_space_count(expected_width, 1)
  }
}

fn parse_px(value: String) -> Int {
  value
  |> string.replace("px", "")
  |> string.trim
  |> int.parse
  |> result.unwrap(0)
}

fn parse_padding_shorthand(value: String) -> #(Int, Int, Int, Int) {
  case
    string.trim(value)
    |> string.split(" ")
    |> list.filter(fn(s) { s != "" })
  {
    [a] -> {
      let v = parse_px(a)
      #(v, v, v, v)
    }
    [a, b] -> #(parse_px(a), parse_px(b), parse_px(a), parse_px(b))
    [a, b, c] -> #(parse_px(a), parse_px(b), parse_px(c), parse_px(b))
    [a, b, c, d] -> #(parse_px(a), parse_px(b), parse_px(c), parse_px(d))
    _ -> #(0, 0, 0, 0)
  }
}

fn parse_padding(styles: List(#(String, String))) -> #(Int, Int, Int, Int) {
  let #(base_top, base_right, base_bottom, base_left) =
    list.find(styles, fn(s) { s.0 == "padding" })
    |> result.map(fn(s) { parse_padding_shorthand(s.1) })
    |> result.unwrap(#(0, 0, 0, 0))

  let top =
    list.find(styles, fn(s) { s.0 == "padding-top" })
    |> result.map(fn(s) { parse_px(s.1) })
    |> result.unwrap(base_top)

  let right =
    list.find(styles, fn(s) { s.0 == "padding-right" })
    |> result.map(fn(s) { parse_px(s.1) })
    |> result.unwrap(base_right)

  let bottom =
    list.find(styles, fn(s) { s.0 == "padding-bottom" })
    |> result.map(fn(s) { parse_px(s.1) })
    |> result.unwrap(base_bottom)

  let left =
    list.find(styles, fn(s) { s.0 == "padding-left" })
    |> result.map(fn(s) { parse_px(s.1) })
    |> result.unwrap(base_left)

  #(top, right, bottom, left)
}

/// Render a clickable button compatible with Outlook (MSO) and modern email clients.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/attribute
/// import lustre/element/html
///
/// email.button(
///   styles: [
///     #("background-color", "#000"),
///     #("color", "#fff"),
///     #("padding", "12px 24px"),
///   ],
///   attrs: [attribute.href("https://example.com")],
///   children: [html.text("Click me")],
/// )
/// ```
///
pub fn button(
  styles: List(#(String, String)),
  attrs: List(Attribute),
  children: List(Element),
) -> Element {
  let #(pt, pr, pb, pl) = parse_padding(styles)
  let y = pt + pb
  let text_raise = px_to_pt(y)

  let #(pl_font_width, pl_space_count) = compute_font_width_and_space_count(pl)
  let #(pr_font_width, pr_space_count) = compute_font_width_and_space_count(pr)

  let pl_mso_html =
    "<!--[if mso]><i style=\"mso-font-width:"
    <> float.to_string(pl_font_width *. 100.0)
    <> "%;mso-text-raise:"
    <> float.to_string(text_raise)
    <> "\" hidden>"
    <> string.repeat("&#8202;", pl_space_count)
    <> "</i><![endif]-->"

  let pr_mso_html =
    "<!--[if mso]><i style=\"mso-font-width:"
    <> float.to_string(pr_font_width *. 100.0)
    <> "%\" hidden>"
    <> string.repeat("&#8202;", pr_space_count)
    <> "&#8203;</i><![endif]-->"

  html.a(
    [
      attribute.target("_blank"),
      attribute.styles([
        #("line-height", "100%"),
        #("text-decoration", "none"),
        #("display", "inline-block"),
        #("max-width", "100%"),
        #("mso-padding-alt", "0px"),
        ..styles
      ]),
      ..attrs
    ],
    [
      // The `&#8202;` is as close to `1px` of an empty character as we can get, then, we use the `mso-font-width`
      // to scale it according to what padding the developer wants. `mso-font-width` also does not allow for percentages
      // >= 500% so we need to add extra spaces accordingly.
      //
      // See https://github.com/resend/react-email/issues/1512 for why we do not use letter-spacing instead.
      element.unsafe_raw_html("span", [], pl_mso_html),
      html.span(
        [
          attribute.styles([
            #("max-width", "100%"),
            #("display", "inline-block"),
            #("line-height", "120%"),
            #("mso-padding-alt", "0px"),
            #("mso-text-raise", float.to_string(px_to_pt(pb))),
          ]),
        ],
        children,
      ),
      element.unsafe_raw_html("span", [], pr_mso_html),
    ],
  )
}

/// Render an `<h1>` heading with email-safe default styles.
///
pub fn h1(attrs: List(Attribute), children: List(Element)) -> Element {
  html.h1(
    [
      attribute.style("font-size", "36px"),
      attribute.style("font-weight", "bold"),
      attribute.style("line-height", "40px"),
      attribute.style("margin", "16px 0"),
      ..attrs
    ],
    children,
  )
}

/// Render an `<h2>` heading with email-safe default styles.
///
pub fn h2(attrs: List(Attribute), children: List(Element)) -> Element {
  html.h2(
    [
      attribute.style("font-size", "30px"),
      attribute.style("font-weight", "bold"),
      attribute.style("line-height", "36px"),
      attribute.style("margin", "16px 0"),
      ..attrs
    ],
    children,
  )
}

/// Render an `<h3>` heading with email-safe default styles.
///
pub fn h3(attrs: List(Attribute), children: List(Element)) -> Element {
  html.h3(
    [
      attribute.style("font-size", "24px"),
      attribute.style("font-weight", "bold"),
      attribute.style("line-height", "32px"),
      attribute.style("margin", "16px 0"),
      ..attrs
    ],
    children,
  )
}

/// Render a horizontal row used for multi-column layouts.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/element/html
///
/// email.row([], [
///   email.column([], [html.text("Left column")]),
///   email.column([], [html.text("Right column")]),
/// ])
/// ```
///
pub fn row(attrs: List(Attribute), children: List(Element)) -> Element {
  html.table(
    [
      attribute.role("presentation"),
      attribute.attribute("cellspacing", "0"),
      attribute.attribute("cellpadding", "0"),
      attribute.attribute("border", "0"),
      attribute.attribute("width", "100%"),
      ..attrs
    ],
    [html.tbody([], [html.tr([], children)])],
  )
}

/// Render a column cell inside a `row`.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/attribute
/// import lustre/element/html
///
/// email.row([], [
///   email.column([attribute.attribute("width", "50%")], [
///     html.text("Left"),
///   ]),
///   email.column([attribute.attribute("width", "50%")], [
///     html.text("Right"),
///   ]),
/// ])
/// ```
///
pub fn column(attrs: List(Attribute), children: List(Element)) -> Element {
  html.td([attribute.style("vertical-align", "top"), ..attrs], children)
}

/// Render a horizontally centered wrapper.
///
/// ## Example
///
/// ```gleam
/// import lustremail/email
/// import lustre/attribute
/// import lustre/element/html
///
/// email.center([], [
///   email.button(
///     [#("background-color", "#000"), #("padding", "12px 24px")],
///     [attribute.href("https://example.com")],
///     [html.text("Get started")],
///   ),
/// ])
/// ```
///
pub fn center(attrs: List(Attribute), children: List(Element)) -> Element {
  html.table(
    [
      attribute.role("presentation"),
      attribute.attribute("cellspacing", "0"),
      attribute.attribute("cellpadding", "0"),
      attribute.attribute("border", "0"),
      attribute.attribute("align", "center"),
      ..attrs
    ],
    [html.tbody([], [html.tr([], [html.td([], children)])])],
  )
}
