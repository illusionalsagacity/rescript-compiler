open Mocha
open Test_utils

/***
JavaScript masks a shift count to its low 5 bits, but shifts of constants are
folded with OCaml's shifts, which give 0 for a count out of 0..31.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("shift left", () => {
    // Actual: 0, expected: 1
    eq(__LOC__, Int.shiftLeft(1, 32), Int.shiftLeft(id(1), id(32)))
    // Actual: 0, expected: 2
    eq(__LOC__, Int.shiftLeft(1, 33), Int.shiftLeft(id(1), id(33)))
    // Actual: 0, expected: -1073741824
    eq(__LOC__, Int.shiftLeft(7, -2), Int.shiftLeft(id(7), id(-2)))
  })

  test("shift right", () => {
    // Actual: 0, expected: 1
    eq(__LOC__, Int.shiftRight(1, 32), Int.shiftRight(id(1), id(32)))
    // Actual: -1, expected: -4
    eq(__LOC__, Int.shiftRight(-8, 33), Int.shiftRight(id(-8), id(33)))
  })

  test("unsigned shift right", () => {
    // Actual: 0, expected: 5
    eq(__LOC__, Int.shiftRightUnsigned(5, 32), Int.shiftRightUnsigned(id(5), id(32)))
    // Actual: 0, expected: 2147483647
    eq(__LOC__, Int.shiftRightUnsigned(-1, 33), Int.shiftRightUnsigned(id(-1), id(33)))
  })
})
