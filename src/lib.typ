/// Make a wonderful crossregex game.
///
/// - size (int): the size of the grids, namely the number of cells on the edge.
/// - constraints (array): All constraint regular expressions, given in clockwise order.
/// - answer (none, array, content): Your answers, either a multi-line raw block or an array of strings. The character in one cell is represented as a char in the string.
/// - show-whole (bool): Whether to show all constraints in one page.
/// - show-views (bool): Whether to show three views separately.
#let crossregex(
  size,
  shape: "hex",
  alphabet: "[A-Z]",
  constraints: (),
  answer: none,
  show-whole: true,
  show-views: true,
) = {
  let alphabet = if type(alphabet) == regex {
    alphabet
  } else {
    regex(alphabet)
  }
  if shape == "hex" {
    import "hex.typ": crossregex-hex
    crossregex-hex(
      size,
      alphabet: alphabet,
      constraints: constraints,
      answer: answer,
      show-whole: show-whole,
      show-views: show-views,
    )
  } else if shape == "square" {
    import "square.typ": crossregex-square
    crossregex-square(
      size,
      alphabet: alphabet,
      constraints: constraints,
      answer: answer,
      show-whole: show-whole,
      show-views: show-views,
    )
  } else {
    panic("unsupported shape: " + repr(shape))
  }
}
