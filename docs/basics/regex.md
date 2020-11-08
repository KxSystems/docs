---
title: Regular expressions in q | Basics | q and kdb+ documentation
description: Syntax of regular expressions in q
author: Stephen Taylor
date: November 2020
---
# Regular expressions


Keywords [`like`](../ref/like.md), [`ss`, and `ssr`](../ref/ss.md) interpret their second arguments as a limited form of [Regular Expression](https://en.wikipedia.org/wiki/Regular_expression "Wikipedia") (regex).

In a q regex pattern certain characters have special meaning:

```txt
?    wildcard: matches any character
*    matches any sequence of characters
[]   embraces a list of alternatives, any of which matches
```


## Wildcard

A `?` in the pattern matches any character. 

```q
q)("brown";"drown";"frown";"grown") like "?rown"
1111b
q)"the brown duck drowned" ss "?rown"
4 15
```


## List of alternatives

A list of alternatives is embraced by square brackets and consists of:

```txt
[^] + [char|range]{1,} 
```
where

-   `char` is a character atom
-   `range` has the form `0-9`, `a-z`, or `A-Z`

Beginning the list with a caret makes the list match any characters _except_ those listed. 

```q
q)"brown" like "[bf]rown"
1b
q)"brown" like "[^cf]rown"
1b
q)"br^wn" like "br[&^]wn"
1b
```

The list can include ranges of the form `0-9`, `a-z`, and `A-Z`.

```q
q)"brAwn" like "br[A-Z]wn"
1b
q)"br0wn" like "br[0-3]wn"
1b
q)"br0wn" like "br[3-6]wn"
0b
q)"br0wn" like "br[^3-6]wn"
1b
```

Within a list of alternatives `?` and `*` are not wildcards.

```q
q)"brown" like "br?*wn"
1b
q)"brown" like "br[?*]wn"
0b
```


## Matching special characters

Special characters can be matched by bracketing them as lists of alternatives.

```q
q)"br*wn" like "br[*]wn"
1b
q)"br?wn" like "br[?]wn"
1b
q)"br]wn" like "[bf]r[]]wn"
1b

q)a:("roam";"rome")
q)a like "r?me"
01b
q)a like "ro*"
11b
q)a like "ro[ab]?"
10b
q)a like "ro[^ab]?"
01b
q)"a[c" like "a[[]c"
1b
q)(`$("ab*c";"abcc"))like"ab[*]c"
10b
q)(`$("ab?c";"abcc"))like"ab[?]c"
10b
q)(`$("ab^c";"abcc"))like"ab[*^]c"
10b
```


## Empty strings

Empty strings are everywhere. They cannot be matched by `ss` or `ssr`.

```q
q)"A grown man in a gown" ss "rown"
,3
q)"A grown man in a gown" ss "own"
4 18
q)"A grown man in a gown" ss "n"
6 10 13 20
q)"A grown man in a gown" ss ""
'length
  [0]  "A grown man in a gown" ss ""
                               ^
```


## Arbitrary sequence

!!! warning "There are limits to matching patterns containing `*`"

A `*` in a pattern matches a sequence of any length, including an empty string.

```q
q)"brown" like "br*wn"
1b
q)"broom of your own" like "br*wn"
1b
q)"brwn" like "br*wn"
1b
```


### `ss`, `ssr`

With patterns containing `*`, keywords `ss` and `ssr` signal a `length` error.

```q
q)s:"Now is the time for all good men to come to the aid of the party."
q)s ss "t?e"
7 44 55
q)s ss "t*e"
'length
  [0]  s ss "t*e"
         ^
```


### `like`

Some patterns with `*` are too difficult to match. 
They produce a `nyi` error.

```q
q)s like "*the*"
1b
q)s like "*the*the*"
'nyi
  [0]  s like "*the*the*"
         ^
q)s like "*the*the"
'nyi
  [0]  s like "*the*the"
         ^
```


## Worked example

The left argument in the following example is a list of telephone book entries:

```q
q)tb
"Smith John 101 N Broadway Elmsville 123-4567"
"Smyth Barbara 27 Maple Ave Elmstwn 321-7654"
"Smythe Ken 321-a Maple Avenue Elmstown 123-9999"
"Smothers 11 Jordan Road Oakwood 123-2357"
"Smith-Hawkins K Maple St Elmwood 321-832e"

q)tb like "Smith*"
10001b
q)tb like "Sm?th*"
11111b
q)tb like "Sm[iy]th*"
11101b
```

We can try finding everyone with the telephone exchange code 321 as follows:

```q
q)tb like "*321-*"
01101b
```

Unfortunately, this pattern also picks up the item for Ken Smythe, who has `"321-"` as part of his address. Since the exchange code is part of a telephone number the `"-"` must be followed by a digit, which can be expressed by the pattern `*321-[0123456789]*`. There is a shorthand for long sequences of alternatives, which in this case is `*321-[0-9]*`.

```q
q)tb like "*321-[0-9]*"
01001b
```

Other sequences for which this shorthand works are sequences of alphabetic characters (in alphabetic order). The pattern in the last example isn’t foolproof. We would also have picked up Ken Smythe’s item if his street number had been 321-1a instead of 321-a. Since the telephone number comes at the end of the text, we could repeat the above alternative four times and leave out the final `"*"`, indicating that there are four digits are at the end of each item.

```q
q)tb like "*321-[0-9][0-9][0-9][0-9]"
01000b
```

Unfortunately this pattern misses the last item, which has an error in the last position of the telephone number. However, in this case the simpler pattern `*321-????` will work. It is generally best to not over-specify the pattern constraint.

```q
q)tb like "*321-????"
01001b
```

The reserved character `^` selects characters that are not among the specified alternatives. For example, there are errors in some items where the last position in the telephone number is not a digit. We can locate all those errors as follows.

```q
q)tb like "*[^0-9]"
00001b
```



## Regex libraries

For something more flexible, it is possible to use regex libs such as 
:fontawesome-brands-github: 
[google/re2](https://github.com/google/re2).

The code below was compiled to use `re2` with V3.1. The `k.h` file can be downloaded from 

:fontawesome-brands-github: 
[KxSystems/kdb/c/c](https://github.com/KxSystems/kdb/tree/master/c/c) 

This can be compiled for 64-bit Linux:

```bash
g++ -m64 -fPIC -O2 re2.cc -o re2.so -I . re2/obj/libre2.a -DKXVER=3 -shared -static
```

and the resulting `re2.so` copied into the `$QHOME/l64` subdirectory.

It can then be loaded and called in q:

```q
q)f:`re2 2:(`FullMatch;2) / bind FullMatch to f
q)f["hello world";"hello ..rld"]
```

```c
#include <re2/re2.h>
#include <re2/filtered_re2.h>
#include <stdlib.h>  //malloc
#include <stdio.h>
#include"k.h"

using namespace re2;

extern "C" {
Z S makeErrStr(S s1,S s2){Z __thread char b[256];snprintf(b,256,"%s - %s",s1,s2);R b;}
Z __inline S c2s(S s,J n){S r=(S)malloc(n+1);R r?memcpy(r,s,n),r[n]=0,r:(S)krr((S)"wsfull (re2)");}
K FullMatch(K x,K y){
  S s,sy;K r;
  P(x->t&&x->t!=KC&&x->t!=KS&&x->t!=-KS||y->t!=KC,krr((S)"type"))
  U(sy=c2s((S)kC(y),y->n))
  RE2 pattern(sy,RE2::Quiet);
  free(sy);
  P(!pattern.ok(),krr(makeErrStr((S)"bad regex",(S)pattern.error().c_str())))
  if(!x->t||x->t==KS){
    J i=0;
    K r=ktn(KB,x->n);
    for(;i<x->n;i++){
      K z=0;
      P(!x->t&&(z=kK(x)[i])->t!=KC,(r0(r),krr((S)"type")))
      s=z?c2s((S)kC(z),z->n):kS(x)[i];P(!s,(r0(r),(K)0))
      kG(r)[i]=RE2::FullMatch(s,pattern);
      if(z)free(s);
    }
    R r;
  }
  s=x->t==-KS?x->s:c2s((S)kC(x),x->n);
  r=kb(RE2::FullMatch(s,pattern));
  if(s!=x->s)free(s);
  R r;
}
}
```

:fontawesome-solid-book:
[Dynamic Load](../ref/dynamic-load.md)


## Regex in q

Itis also possible to create a regex matcher in q, using a state machine, e.g.

```q
/ want to match "x*fz*0*0"
q)m:({0};{2*x="x"};{2+x="f"};{4*x="z"};{4+x="0"};{5+x="0"};{7-x="0"};{7-x="0"})
q)f:{6=1 m/x}
q)f"xyzfz000"
1b
```

However, this does not return until all input chars have been processed, even if a match can be eliminated on the first char. This could be accomodated here:

```q
q)f:{6~last{$[count x 1;((m x 0)[first x 1];1 _ x 1);(0;first x)]}/[{0<x 0};(1;x)]}
```
