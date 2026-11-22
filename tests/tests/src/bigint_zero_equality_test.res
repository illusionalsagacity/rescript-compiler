open Mocha
open Test_utils

/***
Equality of bigint literals compares their signs, so `-0n == 0n` folds to
`false`.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("negative zero", () => {
    // Actual: false, expected: true
    eq(__LOC__, -0n == 0n, true)
    // Actual: true, expected: false
    eq(__LOC__, -0n != 0n, false)
    // Actual: false, expected: true
    eq(__LOC__, -0n == 0n, id(-0n) == id(0n))
  })
})
