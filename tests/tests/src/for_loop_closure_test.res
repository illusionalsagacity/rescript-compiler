open Mocha
open Test_utils

/***
Closures created in a `for` loop each capture their iteration's variable, but
with a start that isn't safe to delay and a bound that needs statements, the
loop variable is declared outside the loop and shared.
*/

@inline(never) let id = x => x

let closures = () => {
  let fs = []
  for i in id(0) to try {
    id(2)
  } catch {
  | _ => 0
  } {
    fs->Array.push(() => i)
  }
  fs->Array.map(f => f())
}

describe(__MODULE__, () => {
  test("closures capture each iteration", () => {
    // Actual: [3, 3, 3], expected: [0, 1, 2]
    eq(__LOC__, closures(), [0, 1, 2])
  })
})
