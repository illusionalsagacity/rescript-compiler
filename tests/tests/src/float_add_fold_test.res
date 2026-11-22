open Mocha
open Test_utils

/***
`Float.fromInt` of an int literal stays an int literal, and adding or
subtracting such literals is folded with int32 arithmetic, which wraps.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("two literals", () => {
    // Actual: -2147483648, expected: 2147483648
    eq(__LOC__, Float.fromInt(2147483647) +. Float.fromInt(1), 2147483648.0)
  })

  test("a chain", () => {
    let x = id(10.0)
    // Actual: -2147483638, expected: 2147483658
    eq(__LOC__, x +. Float.fromInt(2147483647) +. Float.fromInt(1), 2147483658.0)
    // Actual: 8, expected: 4294967304
    eq(__LOC__, x +. Float.fromInt(2147483647) +. Float.fromInt(2147483647), 4294967304.0)
  })

  test("the smallest int", () => {
    // Actual: 2147483658, expected: -2147483638
    eq(__LOC__, id(10.0) +. Float.fromInt(-2147483648), -2147483638.0)
  })
})
