#import "../src/crossregex.typ": crossregex

#crossregex(
  7,
  constraints: (
    `.*H.*H.*`,
    `(DI|NS|TH|OM)*`,
    `F.*[AO].*[AO].*`,
    `(O|RHH|MM)*`,
    `.*`,
    `C*MC(CCC|MM)*`,
    `[^C]*[^R]*III.*`,
    `(...?)\1*`,
    `([^X]|XCC)*`,
    `(RR|HHH)*.?`,
    `N.*X.X.X.*E`,
    `R*D*M*`,
    `.(C|HH)*`,
    `.*G.*V.*H.*`,
    `[CR]*`,
    `.*XEXM*`,
    `.*DD.*CCM.*`,
    `.*XHCR.*X.*`,
    `.*(.)(.)(.)(.)\4\3\2\1.*`,
    `.*(IN|SE|HI)`,
    `[^C]*MMM[^C]*`,
    `.*(.)C\1X\1.*`,
    `[CEIMU]*OH[AEMOR]*`,
    `(RX|[^R])*`,
    `[^M]*M[^M]*`,
    `(S|MM|HHH)*`,
    `.*SE.*UE.*`,
    `.*LR.*RL.*`,
    `.*OXR.*`,
    `([^EMC]|EM)*`,
    `(HHX|[^HX])*`,
    `.*PRR.*DDC.*`,
    `.*`,
    `[AM]*CM(RC)*R?`,
    `([^MC]|MM|CC)*`,
    `(E|CR|MN)*`,
    `P+(..)\1.*`,
    `[CHMNOR]*I[CHMNOR]*`,
    `(ND|ET|IN)[^X]*`,
  ),
  answer: (
    "NHPEH S",
    "DIOM--TH",
    "FH NX  PH",
    "MMOMMMMRHH",
    " C E MCRX M",
    "CMCCc?MMMMMM",
    "HRXRMciIIiX S",
    "OREOREOREORE",
    "VCXCCOHMXCC",
    "RRRRHHHRRU",
    "NCX X X E",
    "RRdDdddd",
    "GCChhhh",
  ),
)
