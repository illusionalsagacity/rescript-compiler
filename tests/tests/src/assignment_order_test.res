open Mocha
open Test_utils

/***
`target().a = e` evaluates `target()` first, but when `e` is a block the block's
statements are moved before the target.
*/

@inline(never) let id = x => x

type cell = {mutable a: int}

let order = ref("")

@inline(never)
let note = (name, value) => {
  order := order.contents ++ name
  value
}

let cell = {a: 0}

@inline(never) let target = () => note("t", cell)

describe(__MODULE__, () => {
  test("an expression value", () => {
    order := ""
    target().a = note("v", 5)
    eq(__LOC__, order.contents, "tv")
  })

  test("a block value", () => {
    order := ""
    target().a = {
      ignore(note("v", 0))
      5
    }
    // Actual: "vt", expected: "tv"
    eq(__LOC__, order.contents, "tv")
  })
})
