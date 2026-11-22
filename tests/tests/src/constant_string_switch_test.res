open Mocha
open Test_utils

/***
A string switch on a constant is folded to the first matching case, which for
merged arms (`A | B => ...`) is the empty case that falls through to the next.
*/

@inline(never) let id = x => x

type letter = A | B | C | D

external fromString: string => letter = "%identity"

@inline
let name = (x: letter) =>
  switch x {
  | A | B => "ab"
  | C => "c"
  | D => "d"
  }

describe(__MODULE__, () => {
  test("a constant matching a merged arm", () => {
    // Actual: undefined, expected: "ab"
    eq(__LOC__, name(fromString("A")), "ab")
    eq(__LOC__, name(fromString("B")), "ab")
  })
})
