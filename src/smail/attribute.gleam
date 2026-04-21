import gleam/int
import gleam/string
import smail/vdom/vattr

pub type Attribute =
  vattr.Attribute

pub fn attribute(name: String, value: String) -> Attribute {
  vattr.attribute(name, value)
}

/// Create an empty attribute. This is not added to the DOM and not rendered when
/// calling [`element.to_string`](./element.html#to_string), but it is useful for
/// _conditionally_ adding attributes to an element.
///
pub fn none() -> Attribute {
  class("")
}

// GLOBAL ATTRIBUTES -----------------------------------------------------------

/// A class is a non-unique identifier for an element primarily used for styling
/// purposes. You can provide multiple classes as a space-separated list and any
/// style rules that apply to any of the classes will be applied to the element.
///
/// To conditionally toggle classes on and off, you can use the [`classes`](#classes)
/// function instead.
///
/// > **Note**: unlike most attributes, multiple `class` attributes are merged
/// > with any existing other classes on an element. Classes added _later_ in the
/// > list will override classes added earlier.
///
pub fn class(name: String) -> Attribute {
  attribute("class", name)
}

/// A class is a non-unique identifier for an element primarily used for styling
/// purposes. You can provide multiple classes as a space-separated list and any
/// style rules that apply to any of the classes will be applied to the element.
/// This function allows you to conditionally toggle classes on and off.
///
/// > **Note**: unlike most attributes, multiple `class` attributes are merged
/// > with any existing other classes on an element. Classes added _later_ in the
/// > list will override classes added earlier.
///
pub fn classes(names: List(#(String, Bool))) -> Attribute {
  class(do_classes(names, ""))
}

fn do_classes(names: List(#(String, Bool)), class: String) -> String {
  case names {
    [] -> class
    [#(name, True), ..rest] -> class <> name <> " " <> do_classes(rest, class)
    [#(_, False), ..rest] -> do_classes(rest, class)
  }
}

/// Specifies the text direction of the element's content. The following values
/// are accepted:
///
/// | Value  | Description                                                          |
/// |--------|----------------------------------------------------------------------|
/// | "ltr"  | The element's content is left-to-right.                              |
/// | "rtl"  | The element's content is right-to-left.                              |
/// | "auto" | The element's content direction is determined by the content itself. |
///
/// > **Note**: the `"auto"` value should only be used as a last resort in cases
/// > where the content's direction is truly unknown. The heuristic used by
/// > browsers is naive and only considers the first character available that
/// > indicates the direction.
///
pub fn dir(direction: String) -> Attribute {
  attribute("dir", direction)
}

/// The `"id"` attribute is used to uniquely identify a single element within a
/// document. It can be used to reference the element in CSS with the selector
/// `#id`, in JavaScript with `document.getElementById("id")`, or by anchors on
/// the same page with the URL `"#id"`.
///
pub fn id(value: String) -> Attribute {
  attribute("id", value)
}

/// Specifies the language of the element's content and the language of any of
/// this element's attributes that contain text. The `"lang"` attribute applies
/// to the element itself and all of its descendants, unless overridden by
/// another `"lang"` attribute on a descendant element.
///
/// The value must be a valid [BCP 47 language tag](https://tools.ietf.org/html/bcp47).
///
pub fn lang(language: String) -> Attribute {
  attribute("lang", language)
}

/// Provide a single property name and value to be used as inline styles for the
/// element. If either the property name or value is empty, this attribute will
/// be ignored.
///
/// > **Note**: unlike most attributes, multiple `style` attributes are merged
/// > with any existing other styles on an element. Styles added _later_ in the
/// > list will override styles added earlier.
///
pub fn style(property: String, value: String) -> Attribute {
  case property, value {
    "", _ | _, "" -> class("")
    _, _ -> attribute("style", property <> ":" <> value <> ";")
  }
}

/// Provide a list of property-value pairs to be used as inline styles for the
/// element. Empty properties or values are omitted from the final style string.
///
/// > **Note**: unlike most attributes, multiple `styles` attributes are merged
/// > with any existing other styles on an element. Styles added _later_ in the
/// > list will override styles added earlier.
///
pub fn styles(properties: List(#(String, String))) -> Attribute {
  attribute("style", do_styles(properties, ""))
}

fn do_styles(properties: List(#(String, String)), styles: String) -> String {
  case properties {
    [] -> styles
    [#("", _), ..rest] | [#(_, ""), ..rest] -> do_styles(rest, styles)
    [#(name, value), ..rest] ->
      do_styles(rest, styles <> name <> ":" <> value <> ";")
  }
}

/// Annotate an element with additional information that may be suitable as a
/// tooltip, such as a description of a link or image.
///
/// It is **not** recommended to use the `title` attribute as a way of providing
/// accessibility information to assistive technologies. User agents often do not
/// expose the `title` attribute to keyboard-only users or touch devices, for
/// example.
///
pub fn title(text: String) -> Attribute {
  attribute("title", text)
}

// ANCHOR AND LINK ATTRIBUTES --------------------------------------------------

/// Specifies the URL of a linked resource. This attribute can be used on various
/// elements to create hyperlinks or to load resources.
///
pub fn href(url: String) -> Attribute {
  attribute("href", url)
}

/// Specifies the relationship between the current document and the linked
/// resource. Common values for emails include `"noopener noreferrer"` for
/// external links.
///
pub fn rel(value: String) -> Attribute {
  attribute("rel", value)
}

/// Specifies where to display the linked resource or where to open the link.
/// The following values are accepted:
///
/// | Value     | Description                                             |
/// |-----------|---------------------------------------------------------|
/// | "_self"   | Open in the same frame/window (default)                 |
/// | "_blank"  | Open in a new window or tab                             |
/// | "_parent" | Open in the parent frame                                |
/// | "_top"    | Open in the full body of the window                     |
/// | framename | Open in a named frame                                   |
///
/// > **Note**: consider against using `"_blank"` for links to external sites as it
/// > removes user control over their browsing experience.
///
pub fn target(value: String) -> Attribute {
  attribute("target", value)
}

// IMAGE ATTRIBUTES ------------------------------------------------------------

/// Specifies text that should be displayed when the image cannot be rendered.
/// This attribute is essential for accessibility, providing context about the
/// image to users who cannot see it, including those using screen readers.
///
pub fn alt(text: String) -> Attribute {
  attribute("alt", text)
}

/// Specifies the URL of an image or resource to be used.
///
pub fn src(url: String) -> Attribute {
  attribute("src", url)
}

/// Specifies the width of the element.
///
pub fn width(value: String) -> Attribute {
  attribute("width", value)
}

/// Specifies the height of the element in pixels.
///
pub fn height(value: Int) -> Attribute {
  attribute("height", int.to_string(value))
}

/// Specifies horizontal whitespace in pixels on the left and right sides of
/// an image. Legacy attribute still useful for email client compatibility.
///
pub fn hspace(value: Int) -> Attribute {
  attribute("hspace", int.to_string(value))
}

/// Specifies vertical whitespace in pixels on the top and bottom sides of
/// an image. Legacy attribute still useful for email client compatibility.
///
pub fn vspace(value: Int) -> Attribute {
  attribute("vspace", int.to_string(value))
}

// ELEMENT ATTRIBUTES ----------------------------------------------------------

/// Name of the element to use for form submission and in the form.elements API
///
pub fn name(element_name: String) -> Attribute {
  attribute("name", element_name)
}

/// Type of element
///
pub fn type_(control_type: String) -> Attribute {
  attribute("type", control_type)
}

/// Specifies the value of an element.
///
pub fn value(control_value: String) -> Attribute {
  attribute("value", control_value)
}

// META ATTRIBUTES -------------------------------------------------------------

/// Sets a pragma directive for a document. This is used in meta tags to define
/// behaviors the user agent should follow.
///
pub fn http_equiv(value: String) -> Attribute {
  attribute("http-equiv", value)
}

/// Specifies the value of the meta element, which varies depending on the value
/// of the name or http-equiv attribute.
///
pub fn content(value: String) -> Attribute {
  attribute("content", value)
}

/// Declares the character encoding used in the document. When used with a meta
/// element, this replaces the need for the `http_equiv("content-type")` attribute.
///
pub fn charset(value: String) -> Attribute {
  attribute("charset", value)
}

// TABLE ATTRIBUTES ------------------------------------------------------------

/// Specifies the alignment of an element's content. Commonly used on tables,
/// table cells, and images in email clients that have limited CSS support.
///
/// | Value    | Description                 |
/// |----------|-----------------------------|
/// | "left"   | Aligns content to the left  |
/// | "center" | Centers content             |
/// | "right"  | Aligns content to the right |
///
pub fn align(value: String) -> Attribute {
  attribute("align", value)
}

/// Specifies the vertical alignment of content within a table cell.
///
/// | Value    | Description                      |
/// |----------|----------------------------------|
/// | "top"    | Aligns content to the top        |
/// | "middle" | Centers content vertically       |
/// | "bottom" | Aligns content to the bottom     |
///
pub fn valign(value: String) -> Attribute {
  attribute("valign", value)
}

/// Specifies a background color using an HTML attribute. Important for email
/// clients like Outlook that may ignore CSS `background-color`.
///
pub fn bgcolor(value: String) -> Attribute {
  attribute("bgcolor", value)
}

/// Specifies a background image URL using an HTML attribute. Used on tables
/// and table cells for email clients that support it.
///
pub fn background(url: String) -> Attribute {
  attribute("background", url)
}

/// Specifies the border width of a table or image. Setting `border(0)` on
/// images is a common email best practice to remove default link borders.
///
pub fn border(value: Int) -> Attribute {
  attribute("border", int.to_string(value))
}

/// Specifies the space between the cell walls and the cell content in a table.
/// Works in email clients where CSS padding on cells may not be fully supported.
///
pub fn cellpadding(value: Int) -> Attribute {
  attribute("cellpadding", int.to_string(value))
}

/// Specifies the space between cells in a table. Works in email clients where
/// CSS margin on cells may not be supported.
///
pub fn cellspacing(value: Int) -> Attribute {
  attribute("cellspacing", int.to_string(value))
}

/// A short, abbreviated description of the header cell's content provided as an
/// alternative label to use for the header cell when referencing the cell in other
/// contexts. Some user-agents, such as speech readers, may present this description
/// before the content itself.
///
pub fn abbr(value: String) -> Attribute {
  attribute("abbr", value)
}

/// A non-negative integer value indicating how many columns the header cell spans
/// or extends. The default value is `1`. User agents dismiss values higher than
/// `1000` as incorrect, defaulting such values to `1`.
///
pub fn colspan(value: Int) -> Attribute {
  attribute("colspan", int.to_string(value))
}

/// A list of space-separated strings corresponding to the id attributes of the
/// `<th>` elements that provide the headers for this header cell.
///
pub fn headers(ids: List(String)) -> Attribute {
  attribute("headers", string.join(ids, " "))
}

/// A non-negative integer value indicating how many rows the header cell spans
/// or extends. The default value is `1`; if its value is set to `0`, the header
/// cell will extends to the end of the table grouping section, that the `<th>`
/// belongs to. Values higher than `65534` are clipped at `65534`.
///
pub fn rowspan(value: Int) -> Attribute {
  attribute("rowspan", {
    value
    |> int.max(0)
    |> int.min(65_534)
    |> int.to_string()
  })
}

/// Specifies the number of consecutive columns a `<colgroup>` element spans. The
/// value must be a positive integer greater than zero.
///
pub fn span(value: Int) -> Attribute {
  attribute("span", int.to_string(value))
}

/// The `scope` attribute specifies whether a header cell is a header for a row,
/// column, or group of rows or columns. The following values are accepted:
///
/// The `scope` attribute is only valid on `<th>` elements.
///
pub fn scope(value: String) -> Attribute {
  attribute("scope", value)
}

// TIME ATTRIBUTES -------------------------------------------------------------

/// Indicates the time and/or date of a `<time>` element. Values may be one of
/// the following formats:
///
/// | Description                       | Syntax                                                                                                                                     | Examples                                                                                                                                   |
/// |-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
/// | Valid month string                | `YYYY-MM`                                                                                                                                  | `2011-11`, `2013-05`                                                                                                                       |
/// | Valid date string                 | `YYYY-MM-DD`                                                                                                                               | `1887-12-01`                                                                                                                               |
/// | Valid local date and time string  | `YYYY-MM-DD HH:MM`, `YYYY-MM-DD HH:MM:SS`, `YYYY-MM-DD HH:MM:SS.mmm`, `YYYY-MM-DDTHH:MM`, `YYYY-MM-DDTHH:MM:SS`, `YYYY-MM-DDTHH:MM:SS.mmm` | `2013-12-25 11:12`, `1972-07-25 13:43:07`, `1941-03-15 07:06:23.678`, `2013-12-25T11:12`, `1972-07-25T13:43:07`, `1941-03-15T07:06:23.678` |
/// | Valid global date and time string | A valid local date and time string followed by a valid time-zone offset string                                                             | `2013-12-25 11:12+0200`, `1972-07-25 13:43:07+04:30`, `1941-03-15 07:06:23.678Z`, `2013-12-25T11:12-08:00`                                 |
/// | Valid week string                 | `YYYY-WWW`                                                                                                                                 | `2013-W46`                                                                                                                                 |
///
/// A comprehensive list of valid formats can be found on [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/time#valid_datetime_values).
///
pub fn datetime(value: String) -> Attribute {
  attribute("datetime", value)
}

// ARIA ATTRIBUTES -------------------------------------------------------------

/// Add an `aria-*` attribute to an HTML element. The key will be prefixed by
/// `aria-`.
///
pub fn aria(name: String, value: String) -> Attribute {
  attribute("aria-" <> name, value)
}

///
///
pub fn role(name: String) -> Attribute {
  attribute("role", name)
}

/// The aria-hidden state indicates whether the element is exposed to an accessibility
/// API.
///
pub fn aria_hidden(value: Bool) -> Attribute {
  aria("hidden", case value {
    True -> "true"
    False -> "false"
  })
}

/// The aria-label attribute defines a string value that can be used to name an
/// element, as long as the element's role does not prohibit naming.
///
pub fn aria_label(value: String) -> Attribute {
  aria("label", value)
}

/// The aria-labelledby attribute identifies the element (or elements) that labels
/// the element it is applied to.
///
pub fn aria_labelledby(value: String) -> Attribute {
  aria("labelledby", value)
}

/// The global aria-describedby attribute identifies the element (or elements)
/// that describes the element on which the attribute is set.
///
pub fn aria_describedby(value: String) -> Attribute {
  aria("describedby", value)
}

/// The global aria-description attribute defines a string value that describes
/// or annotates the current element.
///
pub fn aria_description(value: String) -> Attribute {
  aria("description", value)
}

/// The aria-level attribute defines the hierarchical level of an element within
/// a structure.
///
pub fn aria_level(value: Int) -> Attribute {
  aria("level", int.to_string(value))
}

/// The aria-roledescription attribute defines a human-readable, author-localised
/// description for the role of an element.
///
pub fn aria_roledescription(value: String) -> Attribute {
  aria("roledescription", value)
}
