open Mocha
open Test_utils

/***
An int remainder by a constant is emitted without `| 0`, so a negative
dividend with no remainder gives `-0`.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("a negative dividend", () => {
    // Actual: false, expected: true
    eq(__LOC__, Object.is(mod(id(-4), 2), 0), true)
    // Actual: false, expected: true
    eq(__LOC__, Object.is(mod(id(-2147483648), -1), 0), true)
  })
})
