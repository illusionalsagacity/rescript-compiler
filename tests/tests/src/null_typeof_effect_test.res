open Mocha
open Test_utils

/***
`isNullable` and `typeof` of an array or block literal fold to a constant and
drop the literal's side effects.
*/

@inline(never) let id = x => x

let count = ref(0)

@inline(never)
let tick = () => {
  count := count.contents + 1
  1
}

describe(__MODULE__, () => {
  test("isNullable", () => {
    count := 0
    let isNullable = Nullable.isNullable(Nullable.make([tick()]))
    // Actual: (false, 0), expected: (false, 1)
    eq(__LOC__, (isNullable, count.contents), (false, 1))
  })

  test("typeof", () => {
    count := 0
    let kind = Type.typeof([tick()])
    // Actual: (#object, 0), expected: (#object, 1)
    eq(__LOC__, (kind, count.contents), (#object, 1))
  })
})
