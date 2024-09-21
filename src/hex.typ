#import "regex.typ": regex-match

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
  let filled = 0

  // transform constraints
  if constraints.len() != n2 * 3 {
    panic("Wrong constraint size. Expected " + str(n2 * 3) + ", received " + str(constraints.len()))
  }
  constraints = constraints.map(t => if type(t) == content {
    t.text
  } else {
    t
  })
  let max-len = calc.max(..constraints.map(t => t.len()))
  constraints = constraints.chunks(n2)

  // get the answer strings, and pad them
  let a = if answer == none {
    ()
  } else if type(answer) == array {
    answer
  } else {
    answer.text.split("\n")
  }
  if a.len() < n2 {
    a += ("",) * (n2 - a.len())
  }
  for i in range(n2) {
    let len = n2 - calc.abs(i - n1)
    if a.at(i).len() < len {
      a.at(i) += " " * (len - a.at(i).len())
    }
    a.at(i) = a.at(i).slice(0, len)
    // count letters
    for c in a.at(i) {
      if c.match(alphabet) != none {
        filled += 1
      }
    }
  }

  // build other views
  let b = for i in range(n2) {
    (
      for j in range(n2 - calc.abs(i - n1)) {
        (a.at(n2 - 1 - j - calc.max(i - n1, 0)).at(calc.min(calc.min(i + n1, n2 - 1) - j, i)),)
      }.join(),
    )
  }
  let c = for i in range(n2) {
    (
      for j in range(n2 - calc.abs(i - n1)) {
        (a.at(calc.max(n1 - i, 0) + j).at(calc.min(n2 - 1 - calc.max(i - n1, 0) - j, n2 - i - 1)),)
      }.join(),
    )
  }

  let large-hexagon = for i in range(n2) {
    for j in range(n2 - calc.abs(i - n1)) {
      // there is a strange offset
      place(dx: (j + calc.abs(i - n1) * 0.5) * r3 * s, dy: i * 1.5 * s, cell)
    }
  }

  let center-x = (n1 + 0.5) * r3 * s
  let center-y = (n1 * 1.5 + 1) * s

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
        dx: center-x + (-calc.abs(i - n1) * 0.5) * r3 * s + 0.5em,
        dy: (i - n1) * 1.5 * s,
        move(dx: -0.2em, dy: -0.2em, circle(fill: check-result, radius: 0.2em)),
      )
      place(
        dx: center-x + (-calc.abs(i - n1) * 0.5) * r3 * s + 1.0em,
        dy: (i - n1) * 1.5 * s - s * 0.5,
        box(height: s, align(horizon, raw(cons, lang: "re"))),
      )
    }
  }

  let char-box(ch) = box(
    width: r3 * s,
    height: 1.5 * s,
    align(center + horizon)[
      #set text(
        size: 1.2em,
        fill: if ch.match(alphabet) != none {
          blue
        } else {
          purple
        },
      )
      #ch
    ],
  )

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
    large-hexagon

    place(dx: center-x, dy: center-y, make-decorates(constraints, a))

    make-grid-texts(a)

    if answer != none {
      place(left + bottom, text(orange)[#filled/#total])
    }
  }

  let aa = (a, b, c)

  // compose pages
  if show-whole {
    let ext = max-len * 0.5em + 1em // extension by constrains
    let ext-r = max-len * 0.5em + 1em
    let ext-l = ext-r * 0.5
    let ext-y = max-len * 0.5em * (r3 / 2) + 1em

    set page(
      height: center-x * 2 + ext-y * 2 + margin * 2,
      width: center-y * 2 + ext * 1.5 + margin * 2,
      margin: (y: ext-y, left: ext-r * 0.66, right: ext-r),
    )

    large-hexagon

    for i in range(3) {
      place(
        dx: center-x,
        dy: center-y,
        rotate(i * 120deg, make-decorates(constraints.at(i), aa.at(i))),
      )
    }

    make-grid-texts(a)

    if answer != none {
      place(
        left + bottom,
        dx: -ext-l * 0.66 + 0.5em,
        dy: ext-y - 0.5em,
        text(orange)[#filled/#total],
      )
    }

    pagebreak(weak: true)
  }

  if show-views {
    set page(
      height: (n2 + 0.33) * 1.5 * s + margin * 2 + 1em,
      width: (n2 + 1) * r3 * s + max-len * 0.5em + 1em,
      margin: margin,
    )

    for k in range(3) {
      puzzle-view(constraints.at(k), aa.at(k))
      pagebreak(weak: true)
    }
  }
}
