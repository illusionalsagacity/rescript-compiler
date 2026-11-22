open Mocha
open Test_utils

/***
A self tail call evaluates its arguments right to left, while any other call
evaluates them left to right.
*/

@inline(never) let id = x => x

let order = ref("")

@inline(never)
let note = (name, value: int) => {
  order := order.contents ++ name
  value
}

let rec selfCall = (a, b, n) =>
  if n == 0 {
    a + b
  } else {
    selfCall(note("a", a), note("b", b), n - 1)
  }

@inline(never) let other = (a, b, _n) => a + b

let otherCall = (a, b) => other(note("a", a), note("b", b), 0)

describe(__MODULE__, () => {
  test("a self tail call", () => {
    order := ""
    eq(__LOC__, selfCall(1, 2, 1), 3)
    // Actual: "ba", expected: "ab"
    eq(__LOC__, order.contents, "ab")
  })

  test("another call", () => {
    order := ""
    eq(__LOC__, otherCall(1, 2), 3)
    eq(__LOC__, order.contents, "ab")
  })
})
