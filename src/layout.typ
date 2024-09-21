#import "regex.typ": regex-match

#let build-char-box(width, height, cell-config, alphabet) = {
  ch => box(
    width: width,
    height: height,
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
}

#let build-decoration(positioner, height) = {
  (constraints, a) => {
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

      let (x, y) = positioner(i)
      place(
        dx: x + 0.5em,
        dy: y,
        move(dx: -0.2em, dy: -0.2em, circle(fill: check-result, radius: 0.2em)),
      )
      place(
        dx: x + 1.0em,
        dy: y - height * 0.5,
        box(height: height, align(horizon, raw(cons, lang: "re"))),
      )
    }
  }
}

#let build-layout(
  angle: none,
  rows: none,
  row-len: none,
  cell: none,
  cell-size: none,
  cell-config: none,
  alphabet: none,
  cell-positioner: none,
  cell-text-offset: none,
  char-box-size: none,
  deco-positioner: none,
  center: none,
  num-views: none,
  view-size: none,
  whole-size: none,
  whole-grid-offset: (0em, 0em),
) = {

  let large-shape = for i in range(rows) {
    for j in range(row-len(i)) {
      let (x, y) = cell-positioner(i, j)
      place(dx: x, dy: y, cell)
    }
  }


  let make-decorates = build-decoration(deco-positioner, cell-size)

  let char-box = build-char-box(..char-box-size, cell-config, alphabet)

  let make-grid(a) = {
    large-shape

    // place cell texts
    for i in range(rows) {
      for j in range(row-len(i)) {
        let (x, y) = cell-positioner(i, j)
        let (ox, oy) = cell-text-offset
        place(
          dx: x + ox,
          dy: y + oy,
          char-box(a.at(i).at(j)),
        )
      }
    }
  }

  let puzzle-view(constraints, a) = {
    let (w, h) = view-size
    show: block.with(width: w, height: h)

    make-grid(a)

    place(dx: center.x, dy: center.y, make-decorates(constraints, a))

  }

  let puzzle-whole(constraints, aa) = {
    let (w, h) = whole-size
    show: block.with(width: w, height: h)
    let (dx, dy) = whole-grid-offset
    show: move.with(dx: dx, dy: dy)

    make-grid(aa.at(0))

    for i in range(num-views) {
      place(
        dx: center.x,
        dy: center.y,
        rotate(i * angle, make-decorates(constraints.at(i), aa.at(i))),
      )
    }
  }

  (puzzle-whole: puzzle-whole, puzzle-view: puzzle-view)
}

/// Compose pages
#let doc-layout(whole-maker: none, view-maker: none, num-views: none, progress: none, margin: 0.5em) = {
  if whole-maker != none {
    set page(height: auto, width: auto, margin: margin)

    let pw = whole-maker()
    set block(spacing: 0.5em)
    pw
    progress

    pagebreak(weak: true)
  }

  if view-maker != none {
    set page(height: auto, width: auto, margin: margin)

    for k in range(num-views) {
      let pv = view-maker(k)
      set block(spacing: 0.5em)
      pv
      progress

      pagebreak(weak: true)
    }
  }
}
