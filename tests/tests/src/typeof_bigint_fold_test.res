open Mocha
open Test_utils

/***
`typeof` of a bigint literal folds to `"number"`.
*/

@inline(never) let id = x => x

describe(__MODULE__, () => {
  test("a bigint literal", () => {
    // Actual: #number, expected: #bigint
    eq(__LOC__, Type.typeof(10n), #bigint)
    // Actual: #number, expected: #bigint
    eq(__LOC__, Type.typeof(10n), Type.typeof(id(10n)))
  })
})
