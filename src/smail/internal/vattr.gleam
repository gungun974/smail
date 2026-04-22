import gleam/list
import gleam/order.{type Order}
import gleam/string
import gleam/string_tree.{type StringTree}
import houdini

// TYPES -----------------------------------------------------------------------

pub type Attribute {
  Attribute(name: String, value: String)
}

// CONSTRUCTORS ----------------------------------------------------------------

pub fn attribute(name name: String, vaue value: String) -> Attribute {
  Attribute(name:, value:)
}

fn expand_style_attributes(attrs: List(Attribute)) -> List(Attribute) {
  list.flat_map(attrs, fn(attr) {
    case attr.name == "style" {
      False -> [attr]
      True -> {
        let derived =
          string.split(attr.value, ";")
          |> list.filter_map(fn(style) {
            case string.split_once(style, ":") {
              Ok(#("color", value)) -> Ok(attribute("color", value))
              Ok(#("text-align", value)) -> Ok(attribute("align", value))
              Ok(#("background-color", value)) ->
                Ok(attribute("bgcolor", value))
              Ok(#("width", value)) -> Ok(attribute("width", value))
              Ok(#("height", value)) -> Ok(attribute("height", value))
              Ok(#("border", value)) -> Ok(attribute("border", value))
              Ok(#("vertical-align", value)) -> Ok(attribute("valign", value))
              _ -> Error(Nil)
            }
          })
        [attr, ..derived]
      }
    }
  })
}

pub fn prepare(attributes: List(Attribute)) -> List(Attribute) {
  case attributes {
    // empty attribute lists or attribute lists with only a single attribute are
    // always sorted and merged by definition, so we don't have to touch them.
    [] | [_] -> attributes

    _ ->
      attributes
      |> expand_style_attributes
      // Sort in reverse because `merge` will build the list in reverse anyway.
      |> list.sort(by: fn(a, b) { compare(b, a) })
      |> merge([])
  }
}

pub fn merge(
  attributes: List(Attribute),
  merged: List(Attribute),
) -> List(Attribute) {
  case attributes {
    [] -> merged

    [Attribute(name: "", ..), ..rest]
    | [Attribute(name: "class", value: ""), ..rest]
    | [Attribute(name: "style", value: ""), ..rest] -> merge(rest, merged)

    [
      Attribute(name: "class", value: class1),
      Attribute(name: "class", value: class2),
      ..rest
    ] -> {
      let value = class1 <> " " <> class2
      let attribute = Attribute(name: "class", value: value)

      merge([attribute, ..rest], merged)
    }

    [
      Attribute(name: "style", value: style1),
      Attribute(name: "style", value: style2),
      ..rest
    ] -> {
      let value = case string.ends_with(style1, ";") {
        True -> style1 <> style2
        False -> style1 <> ";" <> style2
      }
      let attribute = Attribute(name: "style", value: value)

      merge([attribute, ..rest], merged)
    }

    [Attribute(name: name1, ..), Attribute(name: name2, ..) as keep, ..rest]
      if name1 == name2
    -> merge([keep, ..rest], merged)

    [attribute, ..rest] -> merge(rest, [attribute, ..merged])
  }
}

@external(javascript, "./vattr_ffi.mjs", "compare")
pub fn compare(a: Attribute, b: Attribute) -> Order {
  string.compare(a.name, b.name)
}

// STRING RENDERING ------------------------------------------------------------

pub fn to_string_tree(attributes: List(Attribute)) -> StringTree {
  use html, attr <- list.fold(attributes, string_tree.new())

  case attr {
    Attribute(name: "", ..) -> html
    Attribute(name:, value: "") ->
      string_tree.append(html, " " <> name <> "=\"" <> name <> "\"")
    Attribute(name:, value:) ->
      string_tree.append(html, {
        " " <> name <> "=\"" <> houdini.escape(value) <> "\""
      })
  }
}
