open Mocha
open Test_utils

/***
Equality of two `Float.fromInt` literals reads one side as unsigned, so
`Float.fromInt(-1) == Float.fromInt(-1)` folds to `false`.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("negative literals", () => {
    // Actual: false, expected: true
    eq(__LOC__, Float.fromInt(-1) == Float.fromInt(-1), true)
    // Actual: true, expected: false
    eq(__LOC__, Float.fromInt(-1) != Float.fromInt(-1), false)
  })
})
