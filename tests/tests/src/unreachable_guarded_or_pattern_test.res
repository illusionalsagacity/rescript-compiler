@@warning("-11")

/* A guarded or-pattern after a case that matches everything. */

open Mocha
open Test_utils

@inline(never)
let id = x => x

type color = Red | Green | Blue

let int = (x: int, flag) =>
  switch x {
  | 0 => 3
  | _ => 1
  | 2 | 3 if flag => 5
  }

let string = (x, flag) =>
  switch x {
  | "a" => 3
  | _ => 1
  | "b" | "c" if flag => 5
  }

let variant = (x, flag) =>
  switch x {
  | Red => 3
  | _ => 1
  | Green | Blue if flag => 5
  }

let option = (x, flag) =>
  switch x {
  | None => 3
  | Some(_) => 1
  | Some(1 | 2) if flag => 5
  }

/* The first or-pattern is reachable, and falls through when its guard fails. */
let reachable = (x, first, second) =>
  switch x {
  | 0 => 3
  | 1 | 2 if first => 9
  | _ => 7
  | 1 | 2 if second => 5
  }

describe(__MODULE__, () => {
  test("int", () => {
    eq(__LOC__, int(id(0), true), 3)
    eq(__LOC__, int(id(2), true), 1)
  })

  test("string", () => {
    eq(__LOC__, string(id("a"), true), 3)
    eq(__LOC__, string(id("b"), true), 1)
  })

  test("variant", () => {
    eq(__LOC__, variant(id(Red), true), 3)
    eq(__LOC__, variant(id(Green), true), 1)
  })

  test("option", () => {
    eq(__LOC__, option(id(None), true), 3)
    eq(__LOC__, option(id(Some(1)), true), 1)
  })

  test("after a reachable guarded or-pattern", () => {
    eq(__LOC__, reachable(id(1), true, true), 9)
    eq(__LOC__, reachable(id(1), false, true), 7)
    eq(__LOC__, reachable(id(3), true, true), 7)
  })
})
