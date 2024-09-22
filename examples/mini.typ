#import "../src/lib.typ": crossregex-hex

#crossregex-hex(
  3,
  constraints: (
    `A.*`,
    `B.*`,
    `C.*`,
    `D.*`,
    `E.*`,
    `F.*`,
    `G.*`,
    `H.*`,
    `I.*`,
    `J.*`,
    `K.*`,
    `L.*`,
    `M.*`,
    `N.*`,
    `O.*`,
  ),
  answer: (
    "ABC",
    "DEFG",
    "HIJKL",
    "MNOP",
    "QRS",
  ),
)
