open Mocha
open Test_utils

/***
A `for` loop's bound is evaluated once, before the loop, but a bound that is a
variable the body assigns is re-read on every iteration.
*/

@inline(never) let id = x => x

let reassignedBound = () => {
  let n = ref(id(3))
  let count = ref(0)
  for _ in 0 to n.contents {
    n := 100
    count := count.contents + 1
  }
  count.contents
}

let reassignedBoundMinusOne = () => {
  let n = ref(id(3))
  let count = ref(0)
  for _ in 0 to n.contents - 1 {
    n := 100
    count := count.contents + 1
  }
  count.contents
}

describe(__MODULE__, () => {
  test("a bound the body assigns", () => {
    // Actual: 101, expected: 4
    eq(__LOC__, reassignedBound(), 4)
    // Actual: 100, expected: 3
    eq(__LOC__, reassignedBoundMinusOne(), 3)
  })
})
