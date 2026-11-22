open Mocha
open Test_utils

/***
A dense switch on ints whose highest case can't be reached loses its default,
so a value above the cases matches nothing. The unreachable case is the point
of the test, hence the warning attribute.
*/

@inline(never) let id = x => x

@@warning("-11")

let classify = (n: int, flag: bool) =>
  switch (n, flag) {
  | (_, true) => 0
  | (2 .. 4, _) => 1
  | (0, _) => 2
  | (5, true) => 3
  | _ => 99
  }

describe(__MODULE__, () => {
  test("a value above the cases", () => {
    // Actual: undefined, expected: 99
    eq(__LOC__, classify(6, false), 99)
    // Actual: undefined, expected: 99
    eq(__LOC__, classify(100, false), 99)
  })
})
