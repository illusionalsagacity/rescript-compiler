open Mocha
open Test_utils

/***
A guard can mutate the scrutinee, but fields of a pattern matrix are read once
before it, so the rows after a failing guard see the old value. The same match
with another first row re-reads the field.
*/

@inline(never) let id = x => x

type q = {mutable a: int, mutable b: int}

@inline(never)
let clearB = (r: q) => {
  r.b = 0
  false
}

let guardFirst = (r: q) =>
  switch r {
  | _ if clearB(r) => 1
  | {b: 0} => 2
  | _ => 9999
  }

let rowFirst = (r: q) =>
  switch r {
  | {a: 7} => 0
  | {a: 1} if clearB(r) => 1
  | {b: 0} => 2
  | _ => 9999
  }

describe(__MODULE__, () => {
  test("a field the guard mutates", () => {
    eq(__LOC__, rowFirst({a: 1, b: 1}), 2)
    // Actual: 9999, expected: 2
    eq(__LOC__, guardFirst({a: 0, b: 1}), 2)
  })
})
