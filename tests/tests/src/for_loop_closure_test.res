open Mocha
open Test_utils

/***
Closures created in a `for` loop each capture their own iteration's variable,
also when the start isn't safe to delay past a bound that needs statements.
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

let closuresDownto = () => {
  let fs = []
  for i in id(2) downto switch id(Some(0)) {
  | Some(n) => n
  | None => 1
  } {
    fs->Array.push(() => i)
  }
  fs->Array.map(f => f())
}

let emptyRange = () => {
  let fs = []
  for i in id(3) to try {
    id(1)
  } catch {
  | _ => 0
  } {
    fs->Array.push(() => i)
  }
  fs->Array.length
}

let startBeforeEnd = () => {
  let order = []
  let note = x => {
    order->Array.push(x)
    x
  }
  let fs = []
  for i in note(1) to try {
    note(3)
  } catch {
  | _ => 0
  } {
    fs->Array.push(() => i)
  }
  (order, fs->Array.map(f => f()))
}

let uppercaseExotic = () => {
  let fs = []
  for \"Start" in id(0) to try {
    id(2)
  } catch {
  | _ => 0
  } {
    fs->Array.push(() => \"Start")
  }
  for \"End" in 3 to id(4) {
    fs->Array.push(() => \"End")
  }
  fs->Array.map(f => f())
}

// The end needs no statements, so the loop needs no variable to hold the start.
let startAndEndInHeader = () => {
  let order = []
  let note = x => {
    order->Array.push(x)
    x
  }
  let fs = []
  for i in note(1) to note(3) {
    fs->Array.push(() => i)
  }
  (order, fs->Array.map(f => f()))
}

// The end's statements change what the start read.
let mutableVariableStart = () => {
  let x = ref(0)
  let count = ref(0)
  for _ in x.contents to try {
    x := 5
    id(6)
  } catch {
  | _ => 0
  } {
    count := count.contents + 1
  }
  count.contents
}

let mutableFieldStart = (x: ref<int>) => {
  let count = ref(0)
  for _ in x.contents to try {
    x := 5
    id(6)
  } catch {
  | _ => 0
  } {
    count := count.contents + 1
  }
  count.contents
}

let arrayElementStart = arr => {
  let count = ref(0)
  for _ in arr->Array.getUnsafe(0) to try {
    arr->Array.setUnsafe(0, 5)
    id(6)
  } catch {
  | _ => 0
  } {
    count := count.contents + 1
  }
  count.contents
}

// The start can't change, so the loop needs no variable to hold it.
let immutableStart = start => {
  let x = ref(0)
  let fs = []
  for i in start to {
    x := 2
    x.contents + 1
  } {
    fs->Array.push(() => i)
  }
  fs->Array.map(f => f())
}

describe(__MODULE__, () => {
  test("closures capture each iteration", () => {
    eq(__LOC__, closures(), [0, 1, 2])
  })
  test("closures capture each iteration with downto", () => {
    eq(__LOC__, closuresDownto(), [2, 1, 0])
  })
  test("empty range runs no iteration", () => {
    eq(__LOC__, emptyRange(), 0)
  })
  test("the start runs before the end's statements", () => {
    eq(__LOC__, startBeforeEnd(), ([1, 3], [1, 2, 3]))
  })
  test("uppercase exotic loop variables", () => {
    eq(__LOC__, uppercaseExotic(), [0, 1, 2, 3, 4])
  })
  test("a start stays in the loop header before an end without statements", () => {
    eq(__LOC__, startAndEndInHeader(), ([1, 3], [1, 2, 3]))
  })
  test("a mutable start is read before the end's statements", () => {
    eq(__LOC__, mutableVariableStart(), 7)
    eq(__LOC__, mutableFieldStart(ref(0)), 7)
    eq(__LOC__, arrayElementStart([0]), 7)
  })
  test("an immutable start stays in the loop header", () => {
    eq(__LOC__, immutableStart(1), [1, 2, 3])
  })
})
