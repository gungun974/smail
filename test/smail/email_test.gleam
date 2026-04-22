import birdie
import gleam/option
import smail/attribute
import smail/element/html
import smail/email
import smail/style
import smail_format

fn html_snap(content content: String, title title: String) {
  let assert Ok(content) = smail_format.format_html(content)
  birdie.snap(content: content, title: title)
}

fn empty_email() {
  email.html([], [])
}

pub fn empty_html_email_test() {
  email.to_html(empty_email())
  |> html_snap(title: "empty html email")
}

pub fn empty_plain_email_test() {
  email.to_plain_text(empty_email())
  |> birdie.snap(title: "empty plain email")
}

// ------------------------------

fn text_email() {
  email.text([], [
    html.text("Hoi"),
  ])
}

pub fn text_html_email_test() {
  email.to_html(text_email())
  |> html_snap(title: "text html email")
}

pub fn text_plain_email_test() {
  email.to_plain_text(text_email())
  |> birdie.snap(title: "text plain email")
}

// ------------------------------

fn head_email() {
  email.html([], [
    email.head([], []),
    email.body([], [html.text("Hoi")]),
  ])
}

pub fn head_html_email_test() {
  email.to_html(head_email())
  |> html_snap(title: "head html email")
}

// ------------------------------

fn head_with_extra_email() {
  email.html([], [
    email.head([], [
      html.meta([
        attribute.name("color-scheme"),
        attribute.content("light"),
      ]),
    ]),
    email.body([], []),
  ])
}

pub fn head_with_extra_html_email_test() {
  email.to_html(head_with_extra_email())
  |> html_snap(title: "head with extra html email")
}

// ------------------------------

fn body_email() {
  email.html([], [
    email.body([], [html.text("Hoi")]),
  ])
}

pub fn body_html_email_test() {
  email.to_html(body_email())
  |> html_snap(title: "body html email")
}

pub fn body_plain_email_test() {
  email.to_plain_text(body_email())
  |> birdie.snap(title: "body plain email")
}

// ------------------------------

fn body_with_styles_email() {
  email.html([], [
    email.body([style.background_color("#f6f6f6"), style.padding("20px 0")], [
      html.text("Colored Hoi"),
    ]),
  ])
}

pub fn body_with_styles_html_email_test() {
  email.to_html(body_with_styles_email())
  |> html_snap(title: "body with styles html email")
}

// ------------------------------

fn container_email() {
  email.html([], [
    email.body([], [
      email.container([], [html.text("Container content")]),
    ]),
  ])
}

pub fn container_html_email_test() {
  email.to_html(container_email())
  |> html_snap(title: "container html email")
}

pub fn container_plain_email_test() {
  email.to_plain_text(container_email())
  |> birdie.snap(title: "container plain email")
}

// ------------------------------

fn container_with_padding_email() {
  email.html([], [
    email.body([], [
      email.container([style.padding("20px"), style.margin("0 auto")], [
        html.text("Padded Hoi"),
      ]),
    ]),
  ])
}

pub fn container_with_padding_html_email_test() {
  email.to_html(container_with_padding_email())
  |> html_snap(title: "container with padding html email")
}

// ------------------------------

fn section_email() {
  email.html([], [
    email.body([], [
      email.section([], [html.text("Hoi")]),
      email.section([], [html.text("Proute")]),
    ]),
  ])
}

pub fn section_html_email_test() {
  email.to_html(section_email())
  |> html_snap(title: "section html email")
}

pub fn section_plain_email_test() {
  email.to_plain_text(section_email())
  |> birdie.snap(title: "section plain email")
}

// ------------------------------

fn section_with_styles_email() {
  email.html([], [
    email.body([], [
      email.section(
        [style.background_color("#fff"), style.padding("20px 40px")],
        [html.text("Styled section")],
      ),
    ]),
  ])
}

pub fn section_with_styles_html_email_test() {
  email.to_html(section_with_styles_email())
  |> html_snap(title: "section with styles html email")
}

// ------------------------------

fn img_email() {
  email.html([], [
    email.body([], [
      email.img([
        attribute.alt("Lucy Mail"),
        attribute.src("cid:lucymail.png"),
        style.height("120"),
        attribute.align("center"),
      ]),
    ]),
  ])
}

pub fn img_html_email_test() {
  email.to_html(img_email())
  |> html_snap(title: "img html email")
}

// ------------------------------

fn hr_email() {
  email.html([], [
    email.body([], [
      email.text([], [html.text("Hoi")]),
      email.hr([]),
      email.text([], [html.text("Proute")]),
    ]),
  ])
}

pub fn hr_html_email_test() {
  email.to_html(hr_email())
  |> html_snap(title: "hr html email")
}

pub fn hr_plain_email_test() {
  email.to_plain_text(hr_email())
  |> birdie.snap(title: "hr plain email")
}

// ------------------------------

fn link_email() {
  email.html([], [
    email.body([], [
      email.link([attribute.href("https://tour.gleam.run")], [
        html.text("Visit the gleam tour"),
      ]),
    ]),
  ])
}

pub fn link_html_email_test() {
  email.to_html(link_email())
  |> html_snap(title: "link html email")
}

pub fn link_plain_email_test() {
  email.to_plain_text(link_email())
  |> birdie.snap(title: "link plain email")
}

// ------------------------------

fn preview_short_email() {
  email.html([], [
    email.body([], [
      email.preview(
        "Gleam is a friendly language for building type-safe systems !",
      ),
    ]),
  ])
}

pub fn preview_short_html_email_test() {
  email.to_html(preview_short_email())
  |> html_snap(title: "preview short html email")
}

// ------------------------------

fn preview_long_email() {
  email.html([], [
    email.body([], [
      email.preview(
        "This is a very long preview text that exceeds the maximum length of one hundred and fifty characters and should be truncated at that point",
      ),
    ]),
  ])
}

pub fn preview_long_html_email_test() {
  email.to_html(preview_long_email())
  |> html_snap(title: "preview long html email")
}

// ------------------------------

fn button_email() {
  email.html([], [
    email.body([], [
      email.button(
        [
          style.border_radius("100px"),
          style.background_color("#ffaff3"),
          style.color("#1e1e1e"),
          style.padding("12px 32px 11px"),
          attribute.href("https://tour.gleam.run"),
        ],
        [html.text("Try Gleam")],
      ),
    ]),
  ])
}

pub fn button_html_email_test() {
  email.to_html(button_email())
  |> html_snap(title: "button html email")
}

pub fn button_plain_email_test() {
  email.to_plain_text(button_email())
  |> birdie.snap(title: "button plain email")
}

// ------------------------------

fn h1_email() {
  email.html([], [
    email.body([], [
      email.h1([], [html.text("Heading 1")]),
    ]),
  ])
}

pub fn h1_html_email_test() {
  email.to_html(h1_email())
  |> html_snap(title: "h1 html email")
}

pub fn h1_plain_email_test() {
  email.to_plain_text(h1_email())
  |> birdie.snap(title: "h1 plain email")
}

// ------------------------------

fn h2_email() {
  email.html([], [
    email.body([], [
      email.h2([], [html.text("Heading 2")]),
    ]),
  ])
}

pub fn h2_html_email_test() {
  email.to_html(h2_email())
  |> html_snap(title: "h2 html email")
}

pub fn h2_plain_email_test() {
  email.to_plain_text(h2_email())
  |> birdie.snap(title: "h2 plain email")
}

// ------------------------------

fn h3_email() {
  email.html([], [
    email.body([], [
      email.h3([], [html.text("Heading 3")]),
    ]),
  ])
}

pub fn h3_html_email_test() {
  email.to_html(h3_email())
  |> html_snap(title: "h3 html email")
}

pub fn h3_plain_email_test() {
  email.to_plain_text(h3_email())
  |> birdie.snap(title: "h3 plain email")
}

// ------------------------------

fn row_column_email() {
  email.html([], [
    email.body([], [
      email.row([], [
        email.column([attribute.width("50%")], [html.text("Left")]),
        email.column([attribute.width("50%")], [html.text("Right")]),
      ]),
    ]),
  ])
}

pub fn row_column_html_email_test() {
  email.to_html(row_column_email())
  |> html_snap(title: "row column html email")
}

pub fn row_column_plain_email_test() {
  email.to_plain_text(row_column_email())
  |> birdie.snap(title: "row column plain email")
}

// ------------------------------

fn center_email() {
  email.html([], [
    email.body([], [
      email.center([], [
        email.text([], [
          html.text("center"),
        ]),
      ]),
    ]),
  ])
}

pub fn center_html_email_test() {
  email.to_html(center_email())
  |> html_snap(title: "center html email")
}

pub fn center_plain_email_test() {
  email.to_plain_text(center_email())
  |> birdie.snap(title: "center plain email")
}

// ------------------------------

fn font_email() {
  email.html([], [
    email.head([], [
      email.font(
        family: "Josefin Sans",
        fallback_family: [email.Verdana, email.SansSerif],
        web_font: option.Some(email.WebFont(
          url: "https://fonts.gstatic.com/s/josefinsans/v32/Qw3aZQNVED7rKGKxtqIqX5EUDXx4.woff2",
          format: email.Woff2,
        )),
        weight: option.None,
        style: option.None,
      ),
    ]),
    email.body([], [html.text("Custom font email")]),
  ])
}

pub fn font_html_email_test() {
  email.to_html(font_email())
  |> html_snap(title: "font html email")
}

// ------------------------------

fn font_with_weight_and_style_email() {
  email.html([], [
    email.head([], [
      email.font(
        family: "Roboto",
        fallback_family: [email.Arial],
        web_font: option.None,
        weight: option.Some(email.Weight700),
        style: option.Some(email.StyleItalic),
      ),
    ]),
    email.body([], []),
  ])
}

pub fn font_with_weight_and_style_html_email_test() {
  email.to_html(font_with_weight_and_style_email())
  |> html_snap(title: "font with weight and style html email")
}

// ------------------------------

fn advanced_plain_text_email() {
  email.text([], [
    html.text(
      "This is a long line that might need wrapping depending on the configuration used when converting to plain text.",
    ),
  ])
}

pub fn advanced_plain_text_default_test() {
  email.advanced_to_plain_text(
    advanced_plain_text_email(),
    email.PlainTextConfig(wrap_column: 72, enable_wrapping: True),
  )
  |> birdie.snap(title: "advanced plain text default config")
}

pub fn advanced_plain_text_no_wrap_test() {
  email.advanced_to_plain_text(
    advanced_plain_text_email(),
    email.PlainTextConfig(wrap_column: 72, enable_wrapping: False),
  )
  |> birdie.snap(title: "advanced plain text no wrap config")
}

pub fn advanced_plain_text_narrow_wrap_test() {
  email.advanced_to_plain_text(
    advanced_plain_text_email(),
    email.PlainTextConfig(wrap_column: 40, enable_wrapping: True),
  )
  |> birdie.snap(title: "advanced plain text narrow wrap config")
}

// ------------------------------

fn full_email() {
  email.html([], [
    email.head([], []),
    email.body([style.background_color("#f6f6f6")], [
      email.preview("Order confirmed!"),
      email.container([], [
        email.section([style.padding("20px")], [
          email.h1([], [html.text("Order confirmed")]),
          email.text([], [html.text("Your order has been confirmed.")]),
          email.hr([]),
          email.row([], [
            email.column([attribute.width("50%")], [
              email.text([], [html.text("Item: Widget")]),
            ]),
            email.column([attribute.width("50%")], [
              email.text([], [html.text("Price: $9.99")]),
            ]),
          ]),
          email.center([], [
            email.button(
              [
                style.background_color("#000"),
                style.color("#fff"),
                style.padding("12px 24px"),
                attribute.href("https://example.com/order"),
              ],
              [html.text("View order")],
            ),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn simple_table_email() {
  email.html([], [
    email.body([], [
      html.table([], [
        html.tr([], [
          html.td([], [html.text("A")]),
          html.td([], [html.text("B")]),
        ]),
        html.tr([], [
          html.td([], [html.text("C")]),
          html.td([], [html.text("D")]),
        ]),
      ]),
    ]),
  ])
}

pub fn simple_table_html_email_test() {
  email.to_html(simple_table_email())
  |> html_snap(title: "simple table html email")
}

pub fn simple_table_plain_email_test() {
  email.to_plain_text(simple_table_email())
  |> birdie.snap(title: "simple table plain email")
}

// ------------------------------

fn full_table_email() {
  email.html([], [
    email.body([], [
      html.table([], [
        html.thead([], [
          html.tr([], [
            html.td([], [html.text("1")]),
            html.td([], [html.text("2")]),
          ]),
        ]),
        html.tbody([], [
          html.tr([], [
            html.td([], [html.text("A")]),
            html.td([], [html.text("B")]),
          ]),
          html.tr([], [
            html.td([], [html.text("C")]),
            html.td([], [html.text("D")]),
          ]),
        ]),
      ]),
    ]),
  ])
}

pub fn full_table_html_email_test() {
  email.to_html(full_table_email())
  |> html_snap(title: "full table html email")
}

pub fn full_table_plain_email_test() {
  email.to_plain_text(full_table_email())
  |> birdie.snap(title: "full table plain email")
}

// ------------------------------

fn nested_table_email() {
  email.html([], [
    email.body([], [
      html.table([], [
        html.tr([], [
          html.td([], [html.text("Outer A")]),
          html.td([], [
            html.table([], [
              html.tr([], [
                html.td([], [html.text("Inner 1")]),
                html.td([], [html.text("Inner 2")]),
              ]),
              html.tr([], [
                html.td([], [html.text("Inner 3")]),
                html.td([], [html.text("Inner 4")]),
              ]),
            ]),
          ]),
        ]),
        html.tr([], [
          html.td([], [html.text("Outer B")]),
          html.td([], [html.text("Outer C")]),
        ]),
      ]),
    ]),
  ])
}

pub fn nested_table_html_email_test() {
  email.to_html(nested_table_email())
  |> html_snap(title: "nested table html email")
}

pub fn nested_table_plain_email_test() {
  email.to_plain_text(nested_table_email())
  |> birdie.snap(title: "nested table plain email")
}

// ------------------------------

pub fn full_html_email_test() {
  email.to_html(full_email())
  |> html_snap(title: "full html email")
}

pub fn full_plain_email_test() {
  email.to_plain_text(full_email())
  |> birdie.snap(title: "full plain email")
}
