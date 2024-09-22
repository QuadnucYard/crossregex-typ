#import "hex.typ": crossregex-hex
#import "square.typ": crossregex-square

/// Make a wonderful cross-regex puzzle.
///
/// - size (int): the size of the grids, namely the number of cells on the edge.
/// - constraints (array): All constraint regular expressions, given in clockwise order.
/// - answer (none, array, content): Your answers, either a multi-line raw block or an array of strings. The character in one cell is represented as a char in the string.
/// - show-whole (bool): Whether to show all constraints in one page.
/// - show-views (bool): Whether to show three views separately.
#let crossregex(size, shape: "hex", ..args) = {
  if shape == "hex" {
    crossregex-hex(size, ..args)
  } else if shape == "square" {
    crossregex-square(size, ..args)
  } else {
    panic("unsupported shape: " + repr(shape))
  }
}
