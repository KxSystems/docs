---
title: Execution control in kdb+ | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Execution control in q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Appendix 2: Execution control




Every programming language since Algol has offered _if/then_, _if/then/else_, and _while_. Q is no exception, though good q programmers tend not to need these structures – especially looping structures – as much as programmers in scalar languages do.

Many languages offer a functional conditional of the form `test ? truex : falsex`, where `truex` and `falsex` are the respective expressions to evaluate after `test` has evaluated as true or false.

The [Cond](../../ref/cond.md) operator extends this to _if/then/elseif/then/elseif…_.

```txt
$[test; truex; falsex] / minimal form
$[test1; truex1; ...; testn; truexn; falsex]
```

A list of expressions can be bracketed to denote a block. 
Within Cond, the result is that of the last expression evaluated. 

```q
q)a:$[2=2; [foo:42; 2+3 4 5]; [bar:43; "foxtrot"]]
q)bar  / not defined
'bar
  [0]  bar
       ^
q)foo
42
q)a
5 6 7

q)val: 35
q)$[val > 60; val; val < 30; 0; [x: neg val; 2*x]]
-70
```

!!! tip "Vector operators offer efficient alternatives to control structures."

```q
q){x*0 -2 1 sum x>=/:30 60} 25 35 90
0 -70 90
```

If you find yourself writing something like this:

```q
q)/ Do not write code like this. Just don't.
q)/ compute the square of each number up to n then subtract 1
q)squareminusone:{[n] out: (); i: 0; while[i < n; out,: (i*i)-1; i:i+1]; out}
q)squareminusone[5]
-1 0 3 8 15
```

look for a non-looping solution. Look _hard_. It will almost certainly run faster. 

```q
q)squareminusonealt:{-1+{x*x}til x}
q)squareminusonealt 5 
-1 0 3 8 15
```

Heck, it will probably _read_ faster. If the code is more legible than your name for it, reconsider whether to name it. 

```q
q){-1+{x*x}til x} 5
-1 0 3 8 15
```

<i class="fas fa-book"></i>
[Reference card](../../ref/index.md)
<br>
<i class="fas fa-book-open"></i>
[Execution control](../../basics/control.md)


---
<i class="far fa-hand-point-right"></i>
[Appendix 3: Input/output to files](file-io.md)