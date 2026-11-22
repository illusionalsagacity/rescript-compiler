open Mocha
open Test_utils

/***
Unit and ignored arguments of an external call are evaluated before the call's
other arguments and its receiver.
*/

@inline(never) let id = x => x

%%raw(`globalThis.externalArgumentOrder = () => {}`)

@val external call: (int, unit) => unit = "externalArgumentOrder"

type receiver
@send external method: (receiver, int, unit) => unit = "method"

let receiver: receiver = %raw(`{method() {}}`)

let order = ref("")

@inline(never)
let note = (name, value) => {
  order := order.contents ++ name
  value
}

describe(__MODULE__, () => {
  test("a unit argument", () => {
    order := ""
    call(note("a", 1), note("b", ()))
    // Actual: "ba", expected: "ab"
    eq(__LOC__, order.contents, "ab")
  })

  test("a unit argument of a method", () => {
    order := ""
    method(note("o", receiver), note("a", 1), note("b", ()))
    // Actual: "boa", expected: "oab"
    eq(__LOC__, order.contents, "oab")
  })
})
