open Mocha
open Test_utils

/***
An `@as(int)` value outside the int32 range is wrapped to int32 when it's
emitted, so it no longer matches the JavaScript value it stands for.
*/

@inline(never) let id = x => x

type big = | @as(3000000000) Big | @as(5) Five | Other

let fromJs: big = %raw(`3000000000`)

let name = (x: big) =>
  switch x {
  | Big => "big"
  | Five => "five"
  | Other => "other"
  }

describe(__MODULE__, () => {
  test("a value above int32", () => {
    // Actual: -1294967296, expected: 3000000000
    eq(__LOC__, (Obj.magic(Big): float), 3000000000.0)
    // Actual: undefined, expected: "big"
    eq(__LOC__, name(fromJs), "big")
  })
})
