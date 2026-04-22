import filepath
import gleam/erlang/application
import gleam/io
import gleam/option.{Some}
import lumenmail/message
import lumenmail/smtp
import simplifile
import smail/attribute
import smail/element.{type Element}
import smail/element/email
import smail/element/html
import smail/style

pub fn main() {
  let mail = email("Sara")

  io.println(
    mail
    |> element.to_plain_text(),
  )

  let assert Ok(priv_directory) = application.priv_directory("exemple")

  let img = case
    simplifile.read_bits(filepath.join(priv_directory, "lucymail.png"))
  {
    Ok(bits) -> bits
    _ -> <<>>
  }

  let email =
    message.new()
    |> message.from_name_email("Lucy", "lucy@example.com")
    |> message.to_email("sara@example.com")
    |> message.subject("Hey, psst!")
    |> message.html_body(mail |> element.to_html())
    |> message.inline_attachment(
      "lucymail.png",
      message.ApplicationOctetStream,
      img,
      "lucymail.png",
    )

  let assert Ok(client) =
    smtp.builder("127.0.0.1", 1025)
    |> smtp.connect()

  let assert Ok(_) = smtp.send(client, email)
  let assert Ok(_) = smtp.close(client)
}

fn email(name: String) {
  let text_lg = [
    style.font_size("1.125rem"),
    style.line_height("1.75rem"),
  ]

  let text_base = [
    style.font_size("1rem"),
    style.line_height("1.5rem"),
  ]

  layout(
    email.preview(
      "Gleam is a friendly language for building type-safe systems !",
    ),
    [
      email.text(
        [
          style.margin("0"),
          style.margin_top("0.5rem"),
          style.margin_bottom("0.5rem"),
          ..text_lg
        ],
        [
          html.text("Hoi, "),
          html.span(
            [
              style.font_weight("600"),
              style.white_space("nowrap"),
            ],
            [html.text(name)],
          ),
        ],
      ),
      email.text(
        [style.margin("0"), style.margin_bottom("0.5rem"), ..text_base],
        [
          html.text("Have you heard about the Gleam programming language ?"),
        ],
      ),
      email.text(
        [
          style.margin("0"),
          style.margin_bottom("0.5rem"),
          style.font_style("italic"),
          ..text_base
        ],
        [
          html.span(
            [
              style.font_weight("600"),
              style.white_space("nowrap"),
              style.color("#ffaff3"),
            ],
            [html.text("Gleam")],
          ),
          html.text(
            " is a friendly language for building scalable, type-safe systems !",
          ),
        ],
      ),
      email.section(
        [
          style.margin_top("1rem"),
          style.margin_bottom("1rem"),
        ],
        [email.hr([])],
      ),
      email.row([style.margin_bottom("1rem")], [
        email.column([style.padding_right("0.5rem")], [
          email.text(
            [
              style.margin("0"),
              style.font_weight("600"),
              style.color("#fefefc"),
              ..text_base
            ],
            [html.text("Here to help")],
          ),
          email.text([style.margin("0"), style.color("#d4d4d4"), ..text_base], [
            html.text("Fun and stress-free"),
          ]),
        ]),
        email.column([style.padding_left("0.5rem")], [
          email.text(
            [
              style.margin("0"),
              style.font_weight("600"),
              style.color("#fefefc"),
              ..text_base
            ],
            [html.text("Multilingual")],
          ),
          email.text([style.margin("0"), style.color("#d4d4d4"), ..text_base], [
            html.text("🩷 BEAM & JS"),
          ]),
        ]),
      ]),
      email.row([], [
        email.column([], [
          email.text(
            [
              style.margin("0"),
              style.margin_bottom("1rem"),
              style.font_style("italic"),
              style.color("#fefefc"),
              ..text_base
            ],
            [
              html.text("Give it a try !"),
              html.br([]),
              html.span(
                [
                  style.font_weight("600"),
                  style.white_space("nowrap"),
                ],
                [
                  email.link(
                    [
                      attribute.href("https://tour.gleam.run"),
                      attribute.rel("noopener noreferrer"),
                      style.color("#ffaff3"),
                    ],
                    [html.text("tour.gleam.run")],
                  ),
                ],
              ),
            ],
          ),
        ]),
        email.column(
          [style.vertical_align("middle"), attribute.valign("middle")],
          [
            email.center([], [
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
          ],
        ),
      ]),
    ],
  )
}

fn layout(preview: Element, children: List(Element)) {
  email.html(
    [
      attribute.lang("en"),
      attribute.dir("ltr"),
    ],
    [
      email.head([], [
        html.meta([
          attribute.name("color-scheme"),
          attribute.content("light"),
        ]),
        html.meta([
          attribute.name("supported-color-schemes"),
          attribute.content("light"),
        ]),
        html.style(
          [],
          "
:root {
  color-scheme: light;
}

@media(min-width:640px){
    .sm_px-12{
        padding-left:3rem!important;
        padding-right:3rem!important
    }
    .sm_px-6{
        padding-left:1.5rem!important;
        padding-right:1.5rem!important
    }
}
      ",
        ),
        email.font(
          family: "Josefin Sans",
          fallback_family: [email.Verdana],
          web_font: Some(email.WebFont(
            url: "https://fonts.gstatic.com/s/josefinsans/v32/Qw3aZQNVED7rKGKxtqIqX5EUDXx4.woff2",
            format: email.Woff2,
          )),
          weight: Some(email.Weight400),
          style: Some(email.StyleNormal),
        ),
        email.font(
          family: "Josefin Sans",
          fallback_family: [email.Verdana],
          web_font: Some(email.WebFont(
            url: "https://fonts.gstatic.com/s/josefinsans/v32/Qw3EZQNVED7rKGKxtqIqX5EUCEx6XHg.woff2",
            format: email.Woff2,
          )),
          weight: Some(email.Weight400),
          style: Some(email.StyleItalic),
        ),
        email.font(
          family: "Josefin Sans",
          fallback_family: [email.Verdana],
          web_font: Some(email.WebFont(
            url: "https://fonts.gstatic.com/s/josefinsans/v32/Qw3aZQNVED7rKGKxtqIqX5EUDXx4.woff2",
            format: email.Woff2,
          )),
          weight: Some(email.Weight600),
          style: Some(email.StyleNormal),
        ),
      ]),
      email.body(
        [
          style.background_color("#fffbe8"),
        ],
        [
          preview,
          email.container(
            [
              style.margin_bottom("2rem"),
              style.margin_left("auto"),
              style.margin_right("auto"),
              attribute.class("sm_px-6"),
            ],
            [
              email.center(
                [
                  style.margin_top("2rem"),
                  style.margin_bottom("1rem"),
                ],
                [
                  email.img([
                    attribute.alt("Lucy Mail"),
                    attribute.src("cid:lucymail.png"),
                    style.height("120"),
                    attribute.align("center"),
                  ]),
                ],
              ),
              email.section(
                [
                  style.padding("0.75rem 1.5rem"),
                  style.line_height("1.5rem"),
                  style.width("100%"),
                  style.background_color("#292d3e"),
                  attribute.style(
                    "box-shadow",
                    "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)",
                  ),
                  style.border_radius("0.5rem"),
                  style.color("#fefefc"),
                  style.text_align("left"),

                  attribute.class("sm_px-12"),
                ],
                children,
              ),
            ],
          ),
        ],
      ),
    ],
  )
}
