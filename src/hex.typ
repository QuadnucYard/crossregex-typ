#import "layout.typ": *
#import "process.typ": *

#let r3 = calc.sqrt(3)

#let crossregex-hex(
  size,
  alphabet: regex("[A-Z]"),
  constraints: (),
  answer: none,
  show-whole: true,
  show-views: true,
  cell: move(
    dx: (1.5 - calc.sqrt(3)) * 0.5em,
    dy: (calc.sqrt(3) - 1.5) * 0.5em,
    rotate(30deg, polygon.regular(size: 2em, vertices: 6, stroke: 0.5pt)),
  ),
  cell-config: (
    size: 1em,
    text-style: (:),
    valid-color: blue,
    invalid-color: purple,
  ),
  margin: 0.5em,
) = {
  let cell-config = (
    size: 1em,
    text-style: (:),
    valid-color: blue,
    invalid-color: purple,
  ) + cell-config
  let s = cell-config.size

  let n1 = size - 1
  let n2 = size * 2 - 1
  let total = 3 * size * (size - 1) + 1

  let (constraints, max-len, answer, filled, a, aa) = process-args(
    rows: n2,
    row-len: i => n2 - calc.abs(i - n1),
    constraints: constraints,
    constraint-size: n2 * 3,
    answer: answer,
    alphabet: alphabet,
    rotators: (
      (i, j) => (n2 - 1 - j - calc.max(i - n1, 0), calc.min(calc.min(i + n1, n2 - 1) - j, i)),
      ((i, j) => (calc.max(n1 - i, 0) + j, calc.min(n2 - 1 - calc.max(i - n1, 0) - j, n2 - i - 1))),
    ),
  )

  let large-hexagon = for i in range(n2) {
    for j in range(n2 - calc.abs(i - n1)) {
      // there is a strange offset
      place(dx: (j + calc.abs(i - n1) * 0.5) * r3 * s, dy: i * 1.5 * s, cell)
    }
  }

  let center = (x: (n1 + 0.5) * r3 * s, y: (n1 * 1.5 + 1) * s)
  let ext = max-len * 0.5em + 1em // extension by constrains

  let make-decorates = decoration-builder(
    i => {
      (x: center.x + -calc.abs(i - n1) * 0.5 * r3 * s, y: (i - n1) * 1.5 * s)
    },
    s,
  )

  let char-box = char-box-builder(r3 * s, 1.5 * s, cell-config, alphabet)

  let make-grid-texts(a) = {
    // place cell texts
    for i in range(n2) {
      for j in range(n2 - calc.abs(i - n1)) {
        place(
          dx: (j + calc.abs(i - n1) * 0.5) * r3 * s,
          dy: (i * 1.5 + 0.25) * s,
          char-box(a.at(i).at(j)),
        )
      }
    }
  }

  let puzzle-view(constraints, a) = {
    show: block.with(width: center.x * 2 + ext, height: center.y * 2)

    large-hexagon

    place(dx: center.x, dy: center.y, make-decorates(constraints, a))

    make-grid-texts(a)
  }

  let puzzle-whole = {
    show: block.with(width: center.x * 2 + ext * 1.5, height: center.y * 2 + ext * r3)

    show: move.with(dx: ext * 0.5, dy: ext * r3 / 2)

    large-hexagon

    for i in range(3) {
      place(
        dx: center.x,
        dy: center.y,
        rotate(i * 120deg, make-decorates(constraints.at(i), aa.at(i))),
      )
    }

    make-grid-texts(a)
  }

  let prog = if answer != none {
    make-progress(filled, total)
  }

  doc-layout(
    whole-maker: if show-whole {
      () => puzzle-whole
    },
    view-maker: if show-views {
      k => puzzle-view(constraints.at(k), aa.at(k))
    },
    num-views: 3,
    progress: prog,
    margin: margin,
  )
}
