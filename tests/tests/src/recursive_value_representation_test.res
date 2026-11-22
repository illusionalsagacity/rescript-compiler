open Mocha
open Test_utils

/***
A recursive value (`let rec a = C(1, a)`) is built field by field, without the
constructor's `TAG` (or `@tag`) field, and with an explicit `undefined` for an
optional field the literal leaves out.
*/

@inline(never) let id = x => x

type rec list = Cons(int, list) | Nil

let rec cyclic = Cons(1, cyclic)

@tag("kind")
type rec tagged = One({x: int, next: tagged}) | Two

let rec cyclicTagged = One({x: 1, next: cyclicTagged})

type rec optional = {o?: int, next: optional}

let rec cyclicOptional = {next: cyclicOptional}

let field: ('a, string) => Nullable.t<string> = %raw(`(x, name) => x[name]`)
let keys: 'a => array<string> = %raw(`x => Object.keys(x)`)

describe(__MODULE__, () => {
  test("the TAG field", () => {
    // Actual: undefined, expected: "Cons"
    eq(__LOC__, field(cyclic, "TAG"), field(Cons(1, Nil), "TAG"))
  })

  test("a @tag field", () => {
    // Actual: undefined, expected: "One"
    eq(__LOC__, field(cyclicTagged, "kind"), field(One({x: 1, next: Two}), "kind"))
  })

  test("an optional field left out", () => {
    // Actual: ["o", "next"], expected: ["next"]
    eq(__LOC__, keys(cyclicOptional), ["next"])
  })
})
