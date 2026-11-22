open Mocha
open Test_utils

/***
`{...base, b: e}` copies `base` before `e` is evaluated, but when `e` needs
statements and the record has an optional field, the copy is made after them.
*/

@inline(never) let id = x => x

type r = {mutable a: int, b: int, c?: int}

let mutateInOverride = (base: r) => {
  ...base,
  b: try {
    base.a = 100
    id(5)
  } catch {
  | _ => 0
  },
}

let order = []

@inline(never)
let trace = (name, value) => {
  order->Array.push(name)
  value
}

let traced = (base: r) => {
  ...trace("base", base),
  b: try {
    trace("b", id(5))
  } catch {
  | _ => 0
  },
}

describe(__MODULE__, () => {
  test("an override that mutates the base", () => {
    // Actual: 100, expected: 1
    eq(__LOC__, mutateInOverride({a: 1, b: 2}).a, 1)
  })

  test("evaluation order", () => {
    ignore(traced({a: 1, b: 2}))
    // Actual: ["b", "base"], expected: ["base", "b"]
    eq(__LOC__, order, ["base", "b"])
  })
})
