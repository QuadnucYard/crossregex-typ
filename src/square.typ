#import "regex.typ": regex-match

#let square = polygon.regular(size: calc.sqrt(2) * 1em, vertices: 4, stroke: 0.5pt)

#let char-box-4(ch, alphabet) = box(
  width: 1em,
  height: 1em,
  align(center + horizon)[
    #set text(
      size: 1em,
      fill: if ch.match(alphabet) != none {
        blue
      } else {
        purple
      },
    )
    #ch
  ],
)

#let crossregex-square(size, alphabet: auto, constraints: (), answer: none, show-whole: true, show-views: true) = {
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
      place(dx: j * 1em, dy: i * 1em, square)
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
        dx: n * 0.5 * 1em + 0.5em,
        dy: (i - n * 0.5 + 0.5) * 1em,
        move(dx: -0.2em, dy: -0.2em, circle(fill: check-result, radius: 0.2em)),
      )
      place(
        dx: n * 0.5 * 1em + 1.0em,
        dy: (i - n * 0.5) * 1em,
        box(height: 1em, align(horizon, raw(cons, lang: "re"))),
      )
    }
  }

  let make-grid-texts(a) = {
    // place cell texts
    for i in range(n) {
      for j in range(n) {
        place(
          dx: j * 1em,
          dy: i * 1em,
          char-box-4(a.at(i).at(j), alphabet),
        )
      }
    }
  }

  let puzzle-view(constraints, a) = {
    large-square

    place(dx: n * 0.5 * 1em, dy: n * 0.5 * 1em, make-decorates(constraints, a))

    make-grid-texts(a)

    if answer != none {
      place(left + bottom, text(orange)[#filled/#total])
    }
  }

  let aa = (a, b)

  // compose pages
  if show-whole {
    let margin = 0.5em
    let margin-x = max-len * 0.5em + 1em + margin
    let margin-y = max-len * 0.5em + 1em + margin + 1em

    set page(
      height: n * 1em + (margin + margin-y),
      width: n * 1em + (margin + margin-x),
      margin: margin,
    )

    large-square

    for i in range(2) {
      place(
        dx: n * 0.5 * 1em,
        dy: n * 0.5 * 1em,
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
    let margin = 0.5em
    set page(
      height: (n + 1) * 1em + margin * 2,
      width: (n + 1) * 1em + max-len * 0.5em + margin * 2,
      margin: margin,
    )

    for k in range(2) {
      puzzle-view(constraints.at(k), aa.at(k))
      pagebreak(weak: true)
    }
  }
}
