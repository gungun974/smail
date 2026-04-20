# smail

Write HTML compliant email with peace of mind and [Lustre](https://hex.pm/packages/lustre) 😌

[![Package Version](https://img.shields.io/hexpm/v/smail)](https://hex.pm/packages/smail)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/smail/)

```sh
gleam add smail@1

```
```gleam
import gleam/io
import gleam/option.{Some}
import lustre/attribute
import lustre/element/html
import smail/email

pub fn main() {
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
    email.body([#("background-color", "#fffbe8")], [], [
      email.preview("No more tables by hand. Just write your email and relax 😌"),
      email.container([], [
        email.section(
          [
            attribute.style("padding", "0.75rem 1.5rem"),
            attribute.style("background-color", "#292d3e"),
            attribute.style("border-radius", "0.5rem"),
            attribute.style("color", "#fefefc"),
          ],
          [
            email.text(
              [
                attribute.style("margin", "0"),
                attribute.style("margin-bottom", "0.5rem"),
                attribute.style("font-size", "1.125rem"),
                attribute.style("line-height", "1.75rem"),
              ],
              [
                html.text("Write emails "),
                html.span(
                  [
                    attribute.style("color", "#ffaff3"),
                    attribute.style("font-weight", "600"),
                  ],
                  [html.text("with peace of mind")],
                ),
                html.text("."),
              ],
            ),
            email.text(
              [
                attribute.style("margin", "0"),
                attribute.style("margin-bottom", "0.5rem"),
                attribute.style("color", "#d4d4d4"),
                attribute.style("font-size", "1rem"),
                attribute.style("line-height", "1.5rem"),
              ],
              [
                html.text(
                  "No more tables by hand. Just write your email and relax 😌",
                ),
              ],
            ),
            email.section([attribute.style("margin", "1rem 0")], [
              email.hr([]),
            ]),
            email.center([], [
              email.button(
                [
                  #("border-radius", "100px"),
                  #("background-color", "#ffaff3"),
                  #("color", "#1e1e1e"),
                  #("padding", "12px 32px 11px"),
                ],
                [attribute.href("https://hexdocs.pm/smail")],
                [html.text("Get started")],
              ),
            ]),
          ],
        ),
      ]),
    ]),
  ])
  |> email.to_html
  |> io.println
}
```

Further documentation can be found at <https://hexdocs.pm/smail>.
