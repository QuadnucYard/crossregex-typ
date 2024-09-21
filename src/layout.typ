#import "regex.typ": regex-match

#let char-box-builder(width, height, cell-config, alphabet) = {
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

#let decoration-builder(positioner, height) = {
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

      let pos = positioner(i)
      place(
        dx: pos.x + 0.5em,
        dy: pos.y,
        move(dx: -0.2em, dy: -0.2em, circle(fill: check-result, radius: 0.2em)),
      )
      place(
        dx: pos.x + 1.0em,
        dy: pos.y - height * 0.5,
        box(height: height, align(horizon, raw(cons, lang: "re"))),
      )
    }
  }
}

#let make-progress(filled, total) = {
  text(orange)[#filled/#total]
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
