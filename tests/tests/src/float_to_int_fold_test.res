open Mocha
open Test_utils

/***
`Float.toInt` of a constant is folded with OCaml's `Int32.of_float`, which
saturates (and is unspecified out of range), while the JavaScript `x | 0` wraps.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("values out of int range", () => {
    // Actual: 2147483647, expected: -64771072
    eq(__LOC__, Float.toInt(3e10), Float.toInt(id(3e10)))
    // Actual: -2147483648, expected: 64771072
    eq(__LOC__, Float.toInt(-3e10), Float.toInt(id(-3e10)))
    // Actual: 2147483647, expected: 0
    eq(__LOC__, Float.toInt(4294967296.0), Float.toInt(id(4294967296.0)))
    // Actual: 2147483647, expected: 0
    eq(__LOC__, Float.toInt(1e300), Float.toInt(id(1e300)))
  })
})
