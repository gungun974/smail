// IMPORTS ---------------------------------------------------------------------

import gleam/list
import gleam/order.{type Order}
import gleam/string
import gleam/string_tree.{type StringTree}
import houdini
import lustremail/internals/constants

// TYPES -----------------------------------------------------------------------

pub type Attribute {
  Attribute(name: String, value: String)
}

// CONSTRUCTORS ----------------------------------------------------------------

pub fn attribute(name name: String, vaue value: String) -> Attribute {
  Attribute(name:, value:)
}

//

pub fn prepare(attributes: List(Attribute)) -> List(Attribute) {
  case attributes {
    // empty attribute lists or attribute lists with only a single attribute are
    // always sorted and merged by definition, so we don't have to touch them.
    [] | [_] -> attributes

    _ ->
      attributes
      // Sort in reverse because `merge` will build the list in reverse anyway.
      |> list.sort(by: fn(a, b) { compare(b, a) })
      |> merge(constants.empty_list)
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
      let value = style1 <> ";" <> style2
      let attribute = Attribute(name: "style", value: value)

      merge([attribute, ..rest], merged)
    }

    [attribute, ..rest] -> merge(rest, [attribute, ..merged])
  }
}

@external(javascript, "./vattr.ffi.mjs", "compare")
pub fn compare(a: Attribute, b: Attribute) -> Order {
  string.compare(a.name, b.name)
}

// STRING RENDERING ------------------------------------------------------------

pub fn to_string_tree(attributes: List(Attribute)) -> StringTree {
  use html, attr <- list.fold(attributes, string_tree.new())

  case attr {
    Attribute(name: "", ..) -> html
    Attribute(name:, value: "") -> string_tree.append(html, " " <> name)
    Attribute(name:, value:) ->
      string_tree.append(html, {
        " " <> name <> "=\"" <> houdini.escape(value) <> "\""
      })
  }
}
