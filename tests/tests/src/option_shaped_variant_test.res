open Mocha
open Test_utils

/***
A variant with constructors `None` and `Some(_)` is given the representation of
`option`, ignoring `@as` and `@unboxed`.
*/

@inline(never) let id = x => x

type five = | @as(5) None | Some(int)

@unboxed type nullable = | @as(null) None | Some(string)

let nullValue: nullable = %raw(`null`)

describe(__MODULE__, () => {
  test("@as on None", () => {
    // Actual: undefined, expected: 5
    eq(__LOC__, (Obj.magic((None: five)): int), 5)
  })

  test("@unboxed with @as(null)", () => {
    // Actual: "some", expected: "none"
    eq(
      __LOC__,
      switch nullValue {
      | None => "none"
      | Some(_) => "some"
      },
      "none",
    )
  })
})
