open Mocha
open Test_utils

/***
A constant cast to `bool` is folded as truthy unless it is `false`, `0` or a
constant constructor, but `""`, `0.0`, `-0.0` and `0n` are falsy, and
`Some(None)` is an object, which is truthy.
*/

@inline(never) let id = x => x

external truthy: 'a => bool = "%identity"

let runtime = x =>
  if truthy(x) {
    "truthy"
  } else {
    "falsy"
  }

@inline
let inlined = x =>
  if truthy(x) {
    "truthy"
  } else {
    "falsy"
  }

describe(__MODULE__, () => {
  test("falsy constants", () => {
    // Actual: "truthy", expected: "falsy"
    eq(__LOC__, inlined(""), runtime(id("")))
    // Actual: "truthy", expected: "falsy"
    eq(__LOC__, inlined(0.0), runtime(id(0.0)))
    // Actual: "truthy", expected: "falsy"
    eq(__LOC__, inlined(-0.0), runtime(id(-0.0)))
    // Actual: "truthy", expected: "falsy"
    eq(__LOC__, inlined(0n), runtime(id(0n)))
  })

  test("a nested option", () => {
    // Actual: "falsy", expected: "truthy"
    eq(__LOC__, inlined(Some(None)), runtime(id(Some(None))))
  })
})
