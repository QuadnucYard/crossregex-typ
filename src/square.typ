#import "layout.typ": *
#import "process.typ": *

#let crossregex-square(
  size,
  alphabet: regex("[A-Z]"),
  constraints: (),
  answer: none,
  show-whole: true,
  show-views: true,
  cell: polygon.regular(size: calc.sqrt(2) * 1em, vertices: 4, stroke: 0.5pt),
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

  let n = size
  let total = n * n

  let (constraints, max-len, answer, filled, a, aa) = process-args(
    rows: n,
    row-len: i => n,
    constraints: constraints,
    constraint-size: n * 2,
    answer: answer,
    alphabet: alphabet,
    rotators: ((i, j) => (j, n - i - 1),),
  )

  let large-square = for i in range(n) {
    for j in range(n) {
      place(dx: j * s, dy: i * s, cell)
    }
  }

  let center = (x: n * 0.5 * s, y: n * 0.5 * s)
  let ext = max-len * 0.5em + 1em // extension by constrains

  let make-decorates = decoration-builder(
    i => {
      (x: center.x, y: (i - n * 0.5 + 0.5) * s)
    },
    s,
  )

  let char-box = char-box-builder(s, s, cell-config, alphabet)

  let make-grid-texts(a) = {
    // place cell texts
    for i in range(n) {
      for j in range(n) {
        place(
          dx: j * s,
          dy: i * s,
          char-box(a.at(i).at(j)),
        )
      }
    }
  }

  let puzzle-view(constraints, a) = {
    show: block.with(width: n * s + ext, height: n * s)

    large-square

    place(dx: center.x, dy: center.y, make-decorates(constraints, a))

    make-grid-texts(a)
  }

  let puzzle-whole = {
    show: block.with(width: center.x * 2 + ext, height: center.y * 2 + ext)

    large-square

    for i in range(2) {
      place(
        dx: center.x,
        dy: center.y,
        rotate(i * 90deg, make-decorates(constraints.at(i), aa.at(i))),
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
    num-views: 2,
    progress: prog,
    margin: margin,
  )
}
