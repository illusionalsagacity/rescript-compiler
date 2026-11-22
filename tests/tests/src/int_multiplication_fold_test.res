open Mocha
open Test_utils

/***
Int multiplication and power of constants are folded exactly, while at runtime
they are computed as floats and truncated with `| 0`, which loses low bits
when the product is above 2^53, so the two disagree.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("multiplication", () => {
    // Actual: 1, expected: 0
    eq(__LOC__, 2147483647 * 2147483647, id(2147483647) * id(2147483647))
    // Actual: -67153019, expected: -67153024
    eq(__LOC__, 123456789 * 987654321, id(123456789) * id(987654321))
  })

  test("power", () => {
    // Actual: -1, expected: 689956864
    eq(__LOC__, 3 ** 40, id(3) ** id(40))
    // Actual: -1, expected: 0
    eq(__LOC__, 31 ** 31, id(31) ** id(31))
  })
})
