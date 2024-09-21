#import "regex.typ": regex-match

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
  let filled = 0

  // transform constraints
  if constraints.len() != n * 2 {
    panic("Wrong constraint size. Expected " + str(n * 2) + ", received " + str(constraints.len()))
  }
  constraints = constraints.map(t => if type(t) == content {
    t.text
  } else {
    t
  })
  let max-len = calc.max(..constraints.map(t => t.len()))
  constraints = constraints.chunks(n)

  // get the answer strings, and pad them
  let a = if answer == none {
    ()
  } else if type(answer) == array {
    answer
  } else {
    answer.text.split("\n")
  }
  if a.len() < n {
    a += ("",) * (n - a.len())
  }
  for i in range(n) {
    if a.at(i).len() < n {
      a.at(i) += " " * (n - a.at(i).len())
    }
    a.at(i) = a.at(i).slice(0, n)
    // count letters
    for c in a.at(i) {
      if c.match(alphabet) != none {
        filled += 1
      }
    }
  }

  // build other views
  let b = for i in range(n) {
    (
      for j in range(n) {
        (a.at(j).at(n - i - 1),)
      }.join(),
    )
  }

  let large-square = for i in range(n) {
    for j in range(n) {
      place(dx: j * s, dy: i * s, cell)
    }
  }

  let make-decorates(constraints, a) = {
    // place constraint expressions
    show raw.where(block: false): box.with(fill: gray.transparentize(90%), outset: (x: 0.1em, y: 0.2em), radius: 0.2em)

    for (i, cons) in constraints.enumerate() {
      let check-result = if regex-match("^" + cons + "$", a.at(i)) {
        if a.at(i).contains(" ") {
          yellow
        } else {
          green
        }
      } else {
        red
      }

      place(
        dx: n * 0.5 * s + 0.5em,
        dy: (i - n * 0.5 + 0.5) * s,
        move(dx: -0.2em, dy: -0.2em, circle(fill: check-result, radius: 0.2em)),
      )
      place(
        dx: n * 0.5 * s + 1.0em,
        dy: (i - n * 0.5) * s,
        box(height: s, align(horizon, raw(cons, lang: "re"))),
      )
    }
  }

  let char-box(ch) = box(
    width: s,
    height: s,
    align(center + horizon)[
      #set text(
        ..cell-config.text-style,
        fill: if ch.match(alphabet) != none {
          cell-config.valid-color
        } else {
          cell-config.invalid-color
        },
      )
      #ch
    ],
  )

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
    large-square

    place(dx: n * 0.5 * s, dy: n * 0.5 * s, make-decorates(constraints, a))

    make-grid-texts(a)

    if answer != none {
      place(left + bottom, text(orange)[#filled/#total])
    }
  }

  let aa = (a, b)

  // compose pages
  if show-whole {
    let ext = max-len * 0.5em + 1em // extension by constrains

    set page(
      height: n * s + ext + margin * 2,
      width: n * s + (ext + 1em) + margin * 2,
      margin: margin,
    )

    large-square

    for i in range(2) {
      place(
        dx: n * 0.5 * s,
        dy: n * 0.5 * s,
        rotate(i * 90deg, make-decorates(constraints.at(i), aa.at(i))),
      )
    }

    make-grid-texts(a)

    if answer != none {
      place(
        left + bottom,
        text(orange)[#filled/#total],
      )
    }

    pagebreak(weak: true)
  }

  if show-views {
    set page(
      height: n * s + margin * 2 + 1em,
      width: n * s + max-len * 0.5em + 1em + margin * 2,
      margin: margin,
    )

    for k in range(2) {
      puzzle-view(constraints.at(k), aa.at(k))
      pagebreak(weak: true)
    }
  }
}
