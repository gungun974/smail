import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import smail/attribute.{type Attribute}

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

//TODO: Explain need to be placed on text
pub fn color(value: String) -> Attribute {
  attribute.style("color", value)
}

pub fn font_family(value: String) -> Attribute {
  attribute.style("font-family", value)
}

pub fn font_size(value: String) -> Attribute {
  attribute.style("font-size", rem_to_px(value))
}

pub fn font_weight(value: String) -> Attribute {
  attribute.style("font-weight", value)
}

pub fn font_style(value: String) -> Attribute {
  attribute.style("font-style", value)
}

pub fn line_height(value: String) -> Attribute {
  attribute.style("line-height", rem_to_px(value))
}

pub fn text_align(value: String) -> Attribute {
  attribute.style("text-align", value)
}

pub fn text_decoration(value: String) -> Attribute {
  attribute.style("text-decoration", value)
}

pub fn text_transform(value: String) -> Attribute {
  attribute.style("text-transform", value)
}

pub fn letter_spacing(value: String) -> Attribute {
  attribute.style("letter-spacing", rem_to_px(value))
}

pub fn word_break(value: String) -> Attribute {
  attribute.style("word-break", value)
}

pub fn word_wrap(value: String) -> Attribute {
  attribute.style("word-wrap", value)
}

pub fn white_space(value: String) -> Attribute {
  attribute.style("white-space", value)
}

pub fn direction(value: String) -> Attribute {
  attribute.style("direction", value)
}

// BACKGROUND ------------------------------------------------------------------

pub fn background_color(value: String) -> Attribute {
  attribute.style("background-color", value)
}

// BOX MODEL -------------------------------------------------------------------

pub fn width(value: String) -> Attribute {
  attribute.style("width", rem_to_px(value))
}

pub fn height(value: String) -> Attribute {
  attribute.style("height", rem_to_px(value))
}

pub fn max_width(value: String) -> Attribute {
  attribute.style("max-width", rem_to_px(value))
}

pub fn min_width(value: String) -> Attribute {
  attribute.style("min-width", rem_to_px(value))
}

pub fn padding(value: String) -> Attribute {
  attribute.style("padding", rem_to_px(value))
}

pub fn padding_top(value: String) -> Attribute {
  attribute.style("padding-top", rem_to_px(value))
}

pub fn padding_right(value: String) -> Attribute {
  attribute.style("padding-right", rem_to_px(value))
}

pub fn padding_bottom(value: String) -> Attribute {
  attribute.style("padding-bottom", rem_to_px(value))
}

pub fn padding_left(value: String) -> Attribute {
  attribute.style("padding-left", rem_to_px(value))
}

pub fn margin(value: String) -> Attribute {
  attribute.style("margin", rem_to_px(value))
}

pub fn margin_top(value: String) -> Attribute {
  attribute.style("margin-top", rem_to_px(value))
}

pub fn margin_right(value: String) -> Attribute {
  attribute.style("margin-right", rem_to_px(value))
}

pub fn margin_bottom(value: String) -> Attribute {
  attribute.style("margin-bottom", rem_to_px(value))
}

pub fn margin_left(value: String) -> Attribute {
  attribute.style("margin-left", rem_to_px(value))
}

// BORDER ----------------------------------------------------------------------

pub fn border(value: String) -> Attribute {
  attribute.style("border", rem_to_px(value))
}

pub fn border_top(value: String) -> Attribute {
  attribute.style("border-top", rem_to_px(value))
}

pub fn border_right(value: String) -> Attribute {
  attribute.style("border-right", rem_to_px(value))
}

pub fn border_bottom(value: String) -> Attribute {
  attribute.style("border-bottom", rem_to_px(value))
}

pub fn border_left(value: String) -> Attribute {
  attribute.style("border-left", rem_to_px(value))
}

//TODO: Explain don't work on Outlook
pub fn border_radius(value: String) -> Attribute {
  attribute.style("border-radius", rem_to_px(value))
}

pub fn border_collapse(value: String) -> Attribute {
  attribute.style("border-collapse", value)
}

// LAYOUT ----------------------------------------------------------------------

pub fn display(value: String) -> Attribute {
  attribute.style("display", value)
}

pub fn vertical_align(value: String) -> Attribute {
  attribute.style("vertical-align", value)
}

pub fn overflow(value: String) -> Attribute {
  attribute.style("overflow", value)
}
