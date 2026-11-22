open Mocha
open Test_utils

/***
`if c { true } else { false }` is simplified to `c` when `c` is `&&` or `||`,
which in JavaScript return an operand, not a boolean, when the operands are
cast to `bool`.
*/

@inline(never) let id = x => x

external truthy: int => bool = "%identity"

let both = (x, y) =>
  if truthy(x) && truthy(y) {
    true
  } else {
    false
  }

let either = (x, y) =>
  if truthy(x) || truthy(y) {
    true
  } else {
    false
  }

describe(__MODULE__, () => {
  test("&&", () => {
    // Actual: #number, expected: #boolean
    eq(__LOC__, Type.typeof(both(1, 5)), #boolean)
    // Actual: #number, expected: #boolean
    eq(__LOC__, Type.typeof(both(0, 5)), #boolean)
  })

  test("||", () => {
    // Actual: #number, expected: #boolean
    eq(__LOC__, Type.typeof(either(0, 7)), #boolean)
  })
})
