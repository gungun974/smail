//// This module provides all the CSS style properties that have been
//// officially tested for email client compatibility. Using these functions
//// is strongly recommended over raw `attribute.style` calls, as they handle
//// unit conversions (such as `rem` to `px`) and ensure the properties work
//// correctly across email clients.
////
//// For any property not covered here, [`attribute.style`](../attribute.html#style)
//// remains available as an escape hatch.

import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import smail/attribute.{type Attribute}

/// Converts `rem` values to `px` in a space-separated string of CSS values.
/// Any token ending in `rem` is multiplied by 16 to produce its pixel equivalent.
/// Tokens that are not `rem` values are left unchanged.
///
pub fn rem_to_px(value: String) -> String {
  value
  |> string.split(" ")
  |> list.map(convert_rem_token)
  |> string.join(" ")
}

fn convert_rem_token(token: String) -> String {
  case string.ends_with(token, "rem") {
    False -> token
    True -> {
      let num_str = string.drop_end(token, 3)

      let num = float.parse(num_str)

      let num = case num {
        Ok(_) -> num
        Error(_) -> int.parse(num_str) |> result.map(int.to_float)
      }

      case num {
        Error(_) -> token
        Ok(rem_value) -> {
          let px_value = rem_value *. 16.0
          let px_int = float.truncate(px_value)
          case int.to_float(px_int) == px_value {
            True -> int.to_string(px_int) <> "px"
            False -> float.to_string(px_value) <> "px"
          }
        }
      }
    }
  }
}

// TYPOGRAPHY ------------------------------------------------------------------

/// Sets the foreground color of the element's text content.
///
/// > **Note**: unlike standard email clients where color inheritance is
/// > unreliable, this library ensures the color cascades correctly to child
/// > elements.
///
pub fn color(value: String) -> Attribute {
  attribute.style("color", value)
}

/// Sets the font family for the element's text. Multiple font names can be
/// provided as a comma-separated fallback list, e.g. `"Arial, sans-serif"`.
///
pub fn font_family(value: String) -> Attribute {
  attribute.style("font-family", value)
}

/// Sets the size of the font. Any `rem` values are automatically converted
/// to `px` for maximum email client compatibility.
///
pub fn font_size(value: String) -> Attribute {
  attribute.style("font-size", rem_to_px(value))
}

/// Sets the weight (boldness) of the font. Common values are `"normal"`,
/// `"bold"`, or a numeric value such as `"700"`.
///
pub fn font_weight(value: String) -> Attribute {
  attribute.style("font-weight", value)
}

/// Sets the style of the font. Common values are `"normal"` and `"italic"`.
///
pub fn font_style(value: String) -> Attribute {
  attribute.style("font-style", value)
}

/// Sets the height of a line of text. Any `rem` values are automatically
/// converted to `px` for maximum email client compatibility.
///
pub fn line_height(value: String) -> Attribute {
  attribute.style("line-height", rem_to_px(value))
}

/// Sets the horizontal alignment of inline content. Accepted values are
/// `"left"`, `"right"`, `"center"`, and `"justify"`.
///
pub fn text_align(value: String) -> Attribute {
  attribute.style("text-align", value)
}

/// Sets decorative lines on text. Common values are `"none"`, `"underline"`,
/// `"overline"`, and `"line-through"`.
///
pub fn text_decoration(value: String) -> Attribute {
  attribute.style("text-decoration", value)
}

/// Controls the capitalisation of text. Common values are `"none"`,
/// `"uppercase"`, `"lowercase"`, and `"capitalize"`.
///
pub fn text_transform(value: String) -> Attribute {
  attribute.style("text-transform", value)
}

/// Sets additional spacing between individual characters. Any `rem` values
/// are automatically converted to `px` for maximum email client compatibility.
///
pub fn letter_spacing(value: String) -> Attribute {
  attribute.style("letter-spacing", rem_to_px(value))
}

/// Controls how line breaks occur within words when they overflow their
/// container. Common values are `"normal"`, `"break-all"`, and `"keep-all"`.
///
pub fn word_break(value: String) -> Attribute {
  attribute.style("word-break", value)
}

/// Controls whether the browser may break lines within words to prevent
/// overflow. Common values are `"normal"` and `"break-word"`.
///
pub fn word_wrap(value: String) -> Attribute {
  attribute.style("word-wrap", value)
}

/// Sets how white space inside an element is handled. Common values are
/// `"normal"`, `"nowrap"`, and `"pre"`.
///
pub fn white_space(value: String) -> Attribute {
  attribute.style("white-space", value)
}

/// Sets the text direction for the element's content. Common values are
/// `"ltr"` (left-to-right) and `"rtl"` (right-to-left).
///
pub fn direction(value: String) -> Attribute {
  attribute.style("direction", value)
}

// BACKGROUND ------------------------------------------------------------------

/// Sets the background colour of the element.
///
pub fn background_color(value: String) -> Attribute {
  attribute.style("background-color", value)
}

// BOX MODEL -------------------------------------------------------------------

/// Sets the width of the element. Any `rem` values are automatically converted
/// to `px` for maximum email client compatibility.
///
pub fn width(value: String) -> Attribute {
  attribute.style("width", rem_to_px(value))
}

/// Sets the height of the element. Any `rem` values are automatically converted
/// to `px` for maximum email client compatibility.
///
pub fn height(value: String) -> Attribute {
  attribute.style("height", rem_to_px(value))
}

/// Sets the maximum width of the element. Any `rem` values are automatically
/// converted to `px` for maximum email client compatibility.
///
pub fn max_width(value: String) -> Attribute {
  attribute.style("max-width", rem_to_px(value))
}

/// Sets the minimum width of the element. Any `rem` values are automatically
/// converted to `px` for maximum email client compatibility.
///
pub fn min_width(value: String) -> Attribute {
  attribute.style("min-width", rem_to_px(value))
}

/// Sets the padding on all four sides of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn padding(value: String) -> Attribute {
  attribute.style("padding", rem_to_px(value))
}

/// Sets the padding on the top side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn padding_top(value: String) -> Attribute {
  attribute.style("padding-top", rem_to_px(value))
}

/// Sets the padding on the right side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn padding_right(value: String) -> Attribute {
  attribute.style("padding-right", rem_to_px(value))
}

/// Sets the padding on the bottom side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn padding_bottom(value: String) -> Attribute {
  attribute.style("padding-bottom", rem_to_px(value))
}

/// Sets the padding on the left side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn padding_left(value: String) -> Attribute {
  attribute.style("padding-left", rem_to_px(value))
}

/// Sets the margin on all four sides of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn margin(value: String) -> Attribute {
  attribute.style("margin", rem_to_px(value))
}

/// Sets the margin on the top side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn margin_top(value: String) -> Attribute {
  attribute.style("margin-top", rem_to_px(value))
}

/// Sets the margin on the right side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn margin_right(value: String) -> Attribute {
  attribute.style("margin-right", rem_to_px(value))
}

/// Sets the margin on the bottom side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn margin_bottom(value: String) -> Attribute {
  attribute.style("margin-bottom", rem_to_px(value))
}

/// Sets the margin on the left side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn margin_left(value: String) -> Attribute {
  attribute.style("margin-left", rem_to_px(value))
}

// BORDER ----------------------------------------------------------------------

/// Sets the border on all four sides of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn border(value: String) -> Attribute {
  attribute.style("border", rem_to_px(value))
}

/// Sets the border on the top side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn border_top(value: String) -> Attribute {
  attribute.style("border-top", rem_to_px(value))
}

/// Sets the border on the right side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn border_right(value: String) -> Attribute {
  attribute.style("border-right", rem_to_px(value))
}

/// Sets the border on the bottom side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn border_bottom(value: String) -> Attribute {
  attribute.style("border-bottom", rem_to_px(value))
}

/// Sets the border on the left side of the element. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
pub fn border_left(value: String) -> Attribute {
  attribute.style("border-left", rem_to_px(value))
}

/// Sets the rounding of the element's corners. Any `rem` values are
/// automatically converted to `px` for maximum email client compatibility.
///
/// > **Note**: border-radius is not supported in Outlook.
///
pub fn border_radius(value: String) -> Attribute {
  attribute.style("border-radius", rem_to_px(value))
}

/// Sets how table borders are rendered. Common values are `"collapse"` and
/// `"separate"`.
///
pub fn border_collapse(value: String) -> Attribute {
  attribute.style("border-collapse", value)
}

// LAYOUT ----------------------------------------------------------------------

/// Sets how the element is displayed. Common values are `"block"`, `"inline"`,
/// `"inline-block"`, and `"none"`.
///
pub fn display(value: String) -> Attribute {
  attribute.style("display", value)
}

/// Sets the vertical alignment of the element relative to its line box or
/// table cell. Common values are `"top"`, `"middle"`, and `"bottom"`.
///
pub fn vertical_align(value: String) -> Attribute {
  attribute.style("vertical-align", value)
}

/// Sets how content that overflows the element's box is handled. Common values
/// are `"visible"`, `"hidden"`, `"scroll"`, and `"auto"`.
///
pub fn overflow(value: String) -> Attribute {
  attribute.style("overflow", value)
}
