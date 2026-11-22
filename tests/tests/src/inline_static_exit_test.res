open Mocha
open Test_utils

/***
An `@inline` function whose `switch` compiles to a static exit, inlined twice,
can run the first copy's handler in the second copy, as both copies share the
exit's id.
*/

@inline(never) let id = x => x

@inline(never) let big = (s: string) => s ++ "!" ++ s

@inline
let pick = (x: int, y: int, flag: bool) =>
  switch (x, y) {
  | (0, _) | (_, 0) =>
    if flag {
      "t"
    } else {
      big("a") ++ big("b")
    }
  | _ => "other"
  }

let constant = pick(0, 5, true)
let computed = pick(id(0), id(5), id(false))

describe(__MODULE__, () => {
  test("two inlined copies", () => {
    eq(__LOC__, constant, "t")
    // Actual: "t", expected: "a!ab!b"
    eq(__LOC__, computed, "a!ab!b")
  })
})
