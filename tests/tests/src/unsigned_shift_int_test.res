open Mocha
open Test_utils

/***
An unsigned shift by a positive constant is assumed to fit an int, so its `| 0`
is dropped, but a count of 32 or more is masked to 0 and the result can be
above the int range.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("a count of 32", () => {
    // Actual: 4294967295, expected: -1
    eq(__LOC__, Int.shiftRightUnsigned(id(-1), 32), Int.shiftRightUnsigned(id(-1), id(32)))
    // Actual: 4294967295, expected: -1
    eq(__LOC__, Int.shiftRightUnsigned(id(-1), 32), -1)
  })
})
