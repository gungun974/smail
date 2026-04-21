import smail/attribute.{type Attribute}

// TYPOGRAPHY ------------------------------------------------------------------

pub fn color(value: String) -> Attribute {
  attribute.style("color", value)
}

pub fn font_family(value: String) -> Attribute {
  attribute.style("font-family", value)
}

pub fn font_size(value: String) -> Attribute {
  attribute.style("font-size", value)
}

pub fn font_weight(value: String) -> Attribute {
  attribute.style("font-weight", value)
}

pub fn font_style(value: String) -> Attribute {
  attribute.style("font-style", value)
}

pub fn line_height(value: String) -> Attribute {
  attribute.style("line-height", value)
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
  attribute.style("letter-spacing", value)
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
  attribute.style("width", value)
}

pub fn height(value: String) -> Attribute {
  attribute.style("height", value)
}

pub fn max_width(value: String) -> Attribute {
  attribute.style("max-width", value)
}

pub fn min_width(value: String) -> Attribute {
  attribute.style("min-width", value)
}

pub fn padding(value: String) -> Attribute {
  attribute.style("padding", value)
}

pub fn padding_top(value: String) -> Attribute {
  attribute.style("padding-top", value)
}

pub fn padding_right(value: String) -> Attribute {
  attribute.style("padding-right", value)
}

pub fn padding_bottom(value: String) -> Attribute {
  attribute.style("padding-bottom", value)
}

pub fn padding_left(value: String) -> Attribute {
  attribute.style("padding-left", value)
}

pub fn margin(value: String) -> Attribute {
  attribute.style("margin", value)
}

pub fn margin_top(value: String) -> Attribute {
  attribute.style("margin-top", value)
}

pub fn margin_right(value: String) -> Attribute {
  attribute.style("margin-right", value)
}

pub fn margin_bottom(value: String) -> Attribute {
  attribute.style("margin-bottom", value)
}

pub fn margin_left(value: String) -> Attribute {
  attribute.style("margin-left", value)
}

// BORDER ----------------------------------------------------------------------

pub fn border(value: String) -> Attribute {
  attribute.style("border", value)
}

pub fn border_top(value: String) -> Attribute {
  attribute.style("border-top", value)
}

pub fn border_right(value: String) -> Attribute {
  attribute.style("border-right", value)
}

pub fn border_bottom(value: String) -> Attribute {
  attribute.style("border-bottom", value)
}

pub fn border_left(value: String) -> Attribute {
  attribute.style("border-left", value)
}

pub fn border_radius(value: String) -> Attribute {
  attribute.style("border-radius", value)
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
