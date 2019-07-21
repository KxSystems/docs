---
title: Regular expressions
description: Support for Regular Expression handling in q.
keywords: kdb+, library, q, regex, regular expression
---
# Regular expressions



## Special characters

In a q [Regular Expression](https://en.wikipedia.org/wiki/Regular_expression) (regex) pattern certain characters have special meaning:

char | meaning
---- | -----------------------------------------------------------
`?`  | matches any character
`*`  | matches any sequence of characters
`[]` | embraces a list of alternatives, any of which matches
`^`  | at the beginning of a list of alternatives indicates they are _not_ to be matched

Special characters can be matched by bracketing them.

```q
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

<i class="far fa-hand-point-right"></i> 
[`like`](../ref/like.md)


## Regex libraries

For those who need something more flexible, it’s possible to use regex libs such as 
<i class="fab fa-github"></i> 
[google/re2](https://github.com/google/re2), 

The code below was compiled to use `re2` with V3.1. The `k.h` file can be downloaded from 
<i class="fab fa-github"></i> 
[KxSystems/kdb/c/c](https://github.com/KxSystems/kdb/tree/master/c/c) 
This can be compiled for 64-bit Linux:

```bash
g++ -m64 -fPIC -O2 re2.cc -o re2.so -I . re2/obj/libre2.a -DKXVER=3 -shared -static
```

and the resulting `re2.so` copied into the `$QHOME/l64` subdirectory.

It can then be loaded and called in kdb+:

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

Another library which has been loaded into kdb+ is http://q.o.potam.us/?p=pcre although you will need to test whether it works with your current version of kdb+.

<i class="far fa-hand-point-right"></i>
Reference: [Dynamic Load](../ref/dynamic-load.md)


## Regex in q

It’s also possible to create a regex matcher in q, using a state machine, e.g.

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
