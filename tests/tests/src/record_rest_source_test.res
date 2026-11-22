open Mocha
open Test_utils

/***
After `let {x: _, ...rest} = r`, later reads of `r`'s fields are replaced by
the destructured locals, but so are writes and method calls, so a write goes to
a local and a method loses its `this`.
*/

@inline(never) let id = x => x

type mutableXy = {mutable x: int, y: int}
type xy = {x: int, y: int}
type onlyY = {y: int}

let writeAfterRest = (a: mutableXy) => {
  let b = (a :> xy)
  let {x: _, ...onlyY as rest} = b
  a.x = 42
  (rest, a)
}

type greeter = {name: string, greet: unit => string, other: int}
type onlyOther = {other: int}

let greeter: greeter = %raw(`{name: "n", greet() { return this ? this.name : "no this" }, other: 1}`)

let callAfterRest = (c: greeter) => {
  let {greet: _, name: _, ...onlyOther as rest} = c
  (rest, c.greet())
}

describe(__MODULE__, () => {
  test("a write after the rest", () => {
    let (_, a) = writeAfterRest({x: 1, y: 2})
    // Actual: 1, expected: 42
    eq(__LOC__, a.x, 42)
  })

  test("a method call after the rest", () => {
    let (_, greeting) = callAfterRest(greeter)
    // Actual: "no this", expected: "n"
    eq(__LOC__, greeting, "n")
  })
})
