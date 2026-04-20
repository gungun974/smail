import filepath
import gleam/erlang/application
import gleam/option.{Some}
import lumenmail/message
import lumenmail/smtp
import smail/attribute
import smail/element.{type Element}
import smail/element/html
import smail/email
import simplifile

pub fn main() {
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
    |> message.html_body(email("Sara") |> email.to_html())
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
    attribute.style("font-size", "1.125rem"),
    attribute.style("line-height", "1.75rem"),
  ]

  let text_base = [
    attribute.style("font-size", "1rem"),
    attribute.style("line-height", "1.5rem"),
  ]

  layout(
    email.preview(
      "Gleam is a friendly language for building type-safe systems !",
    ),
    [
      email.text(
        [
          attribute.style("margin", "0"),
          attribute.style("margin-top", "0.5rem"),
          attribute.style("margin-bottom", "0.5rem"),
          ..text_lg
        ],
        [
          html.text("Hoi, "),
          html.span(
            [
              attribute.style("font-weight", "600"),
              attribute.style("white-space", "nowrap"),
            ],
            [html.text(name)],
          ),
        ],
      ),
      email.text(
        [
          attribute.style("margin", "0"),
          attribute.style("margin-bottom", "0.5rem"),
          ..text_base
        ],
        [
          html.text("Have you heard about the Gleam programming language ?"),
        ],
      ),
      email.text(
        [
          attribute.style("margin", "0"),
          attribute.style("margin-bottom", "0.5rem"),
          attribute.style("font-style", "italic"),
          ..text_base
        ],
        [
          html.span(
            [
              attribute.style("font-weight", "600"),
              attribute.style("white-space", "nowrap"),
              attribute.style("color", "#ffaff3"),
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
          attribute.style("margin-top", "1rem"),
          attribute.style("margin-bottom", "1rem"),
        ],
        [email.hr([])],
      ),
      email.row([attribute.style("margin-bottom", "1rem")], [
        email.column([attribute.style("padding-right", "0.5rem")], [
          email.text(
            [
              attribute.style("margin", "0"),
              attribute.style("font-weight", "600"),
              attribute.style("color", "#fefefc"),
              ..text_base
            ],
            [html.text("Here to help")],
          ),
          email.text(
            [
              attribute.style("margin", "0"),
              attribute.style("color", "#d4d4d4"),
              ..text_base
            ],
            [html.text("Fun and stress-free")],
          ),
        ]),
        email.column([attribute.style("padding-left", "0.5rem")], [
          email.text(
            [
              attribute.style("margin", "0"),
              attribute.style("font-weight", "600"),
              attribute.style("color", "#fefefc"),
              ..text_base
            ],
            [html.text("Multilingual")],
          ),
          email.text(
            [
              attribute.style("margin", "0"),
              attribute.style("color", "#d4d4d4"),
              ..text_base
            ],
            [html.text("🩷 BEAM & JS")],
          ),
        ]),
      ]),
      email.row([], [
        email.column([], [
          email.text(
            [
              attribute.style("margin", "0"),
              attribute.style("margin-bottom", "1rem"),
              attribute.style("font-style", "italic"),
              attribute.style("color", "#fefefc"),
              ..text_base
            ],
            [
              html.text("Give it a try !"),
              html.br([]),
              html.span(
                [
                  attribute.style("font-weight", "600"),
                  attribute.style("white-space", "nowrap"),
                ],
                [
                  email.link(
                    [
                      attribute.href("https://tour.gleam.run"),
                      attribute.rel("noopener noreferrer"),
                      attribute.style("color", "#ffaff3"),
                    ],
                    [html.text("tour.gleam.run")],
                  ),
                ],
              ),
            ],
          ),
        ]),
        email.column(
          [attribute.style("vertical-align", "middle"), attribute.valign("middle")],
          [
          email.center([], [
            email.button(
              [
                attribute.style("border-radius", "100px"),
                attribute.style("background-color", "#ffaff3"),
                attribute.style("color", "#1e1e1e"),
                attribute.style("padding", "12px 32px 11px"),
                attribute.href("https://tour.gleam.run"),
              ],
              [html.text("Try Gleam")],
            ),
          ]),
        ]),
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
          attribute.style("background-color", "#fffbe8"),
        ],
        [
          preview,
          email.container(
            [
              attribute.style("margin-bottom", "2rem"),
              attribute.style("margin-left", "auto"),
              attribute.style("margin-right", "auto"),
              attribute.class("sm_px-6"),
            ],
            [
              email.center(
                [
                  attribute.style("margin-top", "2rem"),
                  attribute.style("margin-bottom", "1rem"),
                ],
                [
                  email.img([
                    attribute.alt("Lucy Mail"),
                    attribute.src("cid:lucymail.png"),
                    attribute.height(120),
                    attribute.border(0),
                    attribute.align("center"),
                  ]),
                ],
              ),
              email.section(
                [
                  attribute.style("padding", "0.75rem 1.5rem"),
                  attribute.style("line-height", "1.5rem"),
                  attribute.style("width", "100%"),
                  attribute.style("background-color", "#292d3e"),
                  attribute.bgcolor("#292d3e"),
                  attribute.style(
                    "box-shadow",
                    "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)",
                  ),
                  attribute.style("border-radius", "0.5rem"),
                  attribute.style("color", "#fefefc"),
                  attribute.style("text-align", "left"),

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
