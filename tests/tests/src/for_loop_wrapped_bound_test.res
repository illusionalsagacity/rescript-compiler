open Mocha
open Test_utils

/***
`for i in a to x - 1` is rewritten to `i < x`, which is wrong when `x - 1`
wraps around the int range.
*/

@inline(never) let id = x => x

let count = (x: int) => {
  let n = ref(0)
  for _ in 2147483646 to x - 1 {
    n := n.contents + 1
  }
  n.contents
}

describe(__MODULE__, () => {
  test("a bound that wraps", () => {
    // Actual: 0, expected: 2
    eq(__LOC__, count(id(-2147483648)), 2)
  })
})
