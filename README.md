# smail

Write HTML compliant email with peace of mind like [Lustre](https://hex.pm/packages/lustre) 😌

[![Package Version](https://img.shields.io/hexpm/v/smail)](https://hex.pm/packages/smail)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smail/)

```sh
gleam add smail@1
```

```gleam
import gleam/io
import gleam/option.{Some}
import smail/attribute
import smail/element
import smail/element/email
import smail/element/html
import smail/style

pub fn main() {
  let mail =
    email.html([attribute.lang("en"), attribute.dir("ltr")], [
      email.head([], [
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
      ]),
      email.body([style.background_color("#fffbe8")], [
        email.preview(
          "No more tables by hand. Just write your email and relax 😌",
        ),
        email.container([], [
          email.section(
            [
              style.padding("0.75rem 1.5rem"),
              style.background_color("#292d3e"),
              style.border_radius("0.5rem"),
              style.color("#fefefc"),
            ],
            [
              email.text(
                [
                  style.margin("0"),
                  style.margin_bottom("0.5rem"),
                  style.font_size("1.125rem"),
                  style.line_height("1.75rem"),
                ],
                [
                  html.text("Write emails "),
                  html.span(
                    [
                      style.color("#ffaff3"),
                      style.font_weight("600"),
                    ],
                    [html.text("with peace of mind")],
                  ),
                  html.text("."),
                ],
              ),
              email.text(
                [
                  style.margin("0"),
                  style.margin_bottom("0.5rem"),
                  style.color("#d4d4d4"),
                  style.font_size("1rem"),
                  style.line_height("1.5rem"),
                ],
                [
                  html.text(
                    "No more tables by hand. Just write your email and relax 😌",
                  ),
                ],
              ),
              email.section([style.margin("1rem 0")], [
                email.hr([]),
              ]),
              email.center([], [
                email.button(
                  [
                    style.border_radius("100px"),
                    style.background_color("#ffaff3"),
                    style.color("#1e1e1e"),
                    style.padding("12px 32px 11px"),
                    attribute.href("https://hexdocs.pm/smail"),
                  ],
                  [html.text("Get started")],
                ),
              ]),
            ],
          ),
        ]),
      ]),
    ])

  mail
  |> element.to_html
  |> io.println

  mail
  |> element.to_plain_text
  |> io.println
}
```

Further documentation can be found at <https://hexdocs.pm/smail>.
