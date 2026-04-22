import gleam/int
import gleam/list
import gleam/string

pub fn format_html(code: String) -> Result(String, Nil) {
  let parts = string.split(code, "<")

  let #(lines, _) =
    list.fold(parts, #([], 0), fn(state, part) {
      let #(lines, indent) = state
      case part {
        "" -> state
        _ ->
          case string.split_once(part, ">") {
            Error(_) -> state
            Ok(#(tag, after)) -> {
              let trimmed_after = string.trim(after)
              case string.starts_with(tag, "/") {
                True -> {
                  let new_indent = int.max(0, indent - 1)
                  let line =
                    string.repeat("  ", new_indent) <> "<" <> tag <> ">"
                  let new_lines = case trimmed_after {
                    "" -> [line, ..lines]
                    t -> [t, line, ..lines]
                  }
                  #(new_lines, new_indent)
                }
                False -> {
                  let line =
                    string.repeat("  ", indent) <> "<" <> tag <> ">"
                  let is_self_closing =
                    string.ends_with(tag, "/")
                    || string.starts_with(tag, "!")
                  let new_indent = case is_self_closing {
                    True -> indent
                    False -> indent + 1
                  }
                  let new_lines = case trimmed_after {
                    "" -> [line, ..lines]
                    t -> [string.repeat("  ", new_indent) <> t, line, ..lines]
                  }
                  #(new_lines, new_indent)
                }
              }
            }
          }
      }
    })

  Ok(lines |> list.reverse |> string.join("\n") |> string.trim)
}
