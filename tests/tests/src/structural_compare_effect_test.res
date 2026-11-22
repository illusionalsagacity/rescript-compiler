open Mocha
open Test_utils

/***
Structural comparison throws on functions, but an unused comparison is treated
as free of side effects and dropped.
*/

@inline(never) let id = x => x

let f = id(x => x + 1)
let g = id(x => x + 2)

let unusedEquality = () => {
  let _unused = f == g
  "no throw"
}

let unusedCompare = () => {
  let _unused = compare(f, g)
  "no throw"
}

describe(__MODULE__, () => {
  test("an unused comparison of functions", () => {
    // Actual: "no throw", expected: "threw"
    eq(
      __LOC__,
      try unusedEquality() catch {
      | _ => "threw"
      },
      "threw",
    )
    // Actual: "no throw", expected: "threw"
    eq(
      __LOC__,
      try unusedCompare() catch {
      | _ => "threw"
      },
      "threw",
    )
  })
})
