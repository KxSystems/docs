// title: Editing tools for code.kx.com/q
// author: stephen@kx.com
// date: 2022-06-04

/ DOMAIN AND RANGE TABLES
/ examples: ddt2(*)
/           ddt1(sum)

/ constants
C:"bgxhijefcspmdznuvt"                        / datatypes (characters)
N:"h"$(1+til 19)except 3                      / datatypes (numbers)
V:@[.'[$;;`$]C,'1;C?"gs";:;(0Ng;`abc)]        / datatypes (values)
VV:5?'raze(0b;0Ng;"xhijef"$10;enlist .Q.a;`3;(10_C)$.z.d+.z.t)  / vectors of types C

rt:{$[x~`type;".";C N?abs type x]}            / result type

ddt2:{[op;c;vt]												        / display domain table for binary op in Markdown
  typ:{rt .[x;y;`$]}[op]''[vt];               /   result types
  rg:(asc distinct raze typ)except".";				/   range
  r:flip[("  ",c),'" "],c,'"|",'typ; 					/   formatted results
  r:.[;(1;::);:;"-"]raze each(,[;" "]'')r;		/   widen display
  -1 (1 rotate)("```";"```txt"),r; 
  -1 "\nRange: `",rg,"`"; 
  }[;C;V,/:\:V]

ddt1:{[op;c;vv]                               / display domain table for unary op in Markdown
  typ:rt each @'[op;;`$] vv;                  /   result types
  r:(c;typ);                                  /   formatted results
  r:{(" ",x)raze 0,'1+til count x}each r;     /   widen
  r:("domain:";"range: "),'r;                 /   label
  -1 (1 rotate)("```";"```txt"),r;            /   code block
  }[;C;VV]

/ TEXT LAYOUT
/ example: losic
losicx:{[m;c;s]                               / Lay out strings s in c columns with minimum margin m
  rws:ceiling(count s)%c;                     /   # rows
  w:m+max count each s;                       /   column width
  p:w#" ";                                    /   pad
  b:(w$'s),((c*rws)-count s)#enlist w#" ";    /   uncut block
  -1 raze each flip rws cut b; }

losic:losicx[3]                               / Lay out strings s in c columns with minimum margin 3