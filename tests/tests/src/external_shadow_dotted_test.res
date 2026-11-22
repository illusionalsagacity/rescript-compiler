open Mocha
open Test_utils

/***
A local named like the first part of a dotted global (`shadowTarget` for
`shadowTarget.value`) shadows the global the external refers to.
*/

@inline(never) let id = x => x

%%raw(`globalThis.shadowTarget = {value: () => "global"}`)

@val external value: unit => string = "shadowTarget.value"

let shadowed = () => {
  let shadowTarget = id(1)
  (shadowTarget, value())
}

describe(__MODULE__, () => {
  test("a local named like a dotted global", () => {
    // Actual: throws TypeError: shadowTarget.value is not a function, expected: (1, "global")
    eq(__LOC__, shadowed(), (1, "global"))
  })
})
