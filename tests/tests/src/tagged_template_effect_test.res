open Mocha
open Test_utils

/***
A tagged template calls its tag, but its result being unused drops the call.
*/

@inline(never) let id = x => x

let calls = ref(0)

let countingTag: taggedTemplate<int, int> = Obj.magic((_strings: array<string>, _value: int) => {
  calls := calls.contents + 1
  1
})

let unusedResult = () => {
  let _ = countingTag`local ${2}`
}

describe(__MODULE__, () => {
  test("an unused tagged template", () => {
    calls := 0
    unusedResult()
    // Actual: 0, expected: 1
    eq(__LOC__, calls.contents, 1)
  })
})
