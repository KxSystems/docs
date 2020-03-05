---
title: Operations in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Operations in kdb+ and q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Operations




Now that we know how to form and access the basic datatypes, it’s time to do things with them. Part of the beauty of q is that you can match tool to problem. If data and complex querying is your problem then you use tables, but when you need to do complex calculations, you take the data out and manipulate it using very powerful primitives on atoms, lists, and dictionaries. 

You might think there is nothing new in this. After all, Java + SQL is also a Turing-complete system so can do the same. In principle. 

In practice, q has three advantages:

1.  All these datatypes coexist in the same process, so there is no overhead in going from one to the other.
2.  Java primitives apply to atoms. The non-table primitives in q apply not just to atoms but also to entire lists and dictionaries, so the code is much shorter. 
3.  The q interpreter is seriously fast. 

Let’s start with the operations on atoms and lists. The first set of examples shows that many operations apply to two atoms, an atom and a list, or two lists of the same length.

## Operations on atoms and lists

```q
q)x:5
q)x
5
q)y:6
q)x+y
11
q)x,:9 2 -4
'type
  [0]  x,:9 2 -4
        ^
```

The last expression returns a `type` error because `x` is not a list, so concatenation is not well-defined.

```q
q)x:enlist x
q)x
,5
```

`x` is now the list having the single item 5.

```q
q)x,: 9 2 -4 / now it works
q)x
5 9 2 -4
```

No initial comma is shown because an entity with several items must be a list.

```q
q)x+y / add 6 to each item
11 15 8 2

q)show z:x*y
30 54 12 -24
q)z + 3 2 4 1 / add corresponding items
33 56 16 -23
```

Operations are processed in right-to-left order.
Others think of operations as being evaluated in left-**of**-right order.
(Similarly to $\sum{f(x)}$).
Whichever way you think of it, there is **no** operator precedence, only position precedence. Thus

```q
q)5 * 4 - 4 / returns 0, first do 4 - 4 and then multiply that result by 5
0
```

Here are some other binary operations that can apply to atoms or lists in the same set (atom op atom; atom op list; list op atom; list op list if the same length).

```txt
a+b     Add
a-b     Subtract
a*b     Multiply
a%b     Divide
a=b     Equal
a>b     More
a<b     Less
a|b     Or (Greater)
a&b     And (Lesser)
```

Note that division is a percent sign. (The reason is that `/` is reserved
for other purposes.) Here are some unary keywords:

```txt
neg b    Negate (render negative)
not b    (equal zero)
abs b    Absolute Value
null b   (equal null)
floor b  (integer part)
```

!!! tip "Open a browser window to the Reference Card and bookmark it."  

<i class="fas fa-book"></i>
[Reference card](../../ref/index.md)


## Mostly boolean operators

```q
q)show zz: (0%0; 4 % 0; 4; 0; -3 % 0)
0n
0w
4
0
-0w
```

`0n` is for 0 divided by 0, `0w` is positive infinity, and `-0`w is negative infinity.

```q
q)null zz / infinities are not null
10000b

q)floor 3.2
3
q)floor -3.2
-4

q)x: 3 2 6 3
q)y: 7 1 4 6
q)x<y
1001b
```

Corresponding items of `x` and `y` are compared.
We see that boolean `1b` is True and `0b` is False.

```q
q)x:"algebras"
q)y:"calculus"
q)x>y
01010100b
```

`"a">"c"` is false, `"l">"a"` is true, and so on.

The Greater operator returns the greater of its arguments no matter what the domain.

```q
q)x|y
"clleurus"
q)x&y
"aagcblas"
```

Greater and Lesser apply to boolean arguments, when they correspond to logical OR and AND.

```q
q)(x>y) | x<y
11111110b
q)(x>y) & x<y
00000000b
```

Other operators deserve special mention.

The keyword `in` determines whether each item of the left argument list is among the items of the right argument list. It returns a boolean array.

The function `where` finds the positions in a boolean array where the boolean value is 1. (`where` has other purposes, but this is the main one.)


## `in`, `where`, indexing

```q
q)x: 6 8 7 2 4 13 6
q)y: 3 5 6 7 8

q)x in y            / flag items of x also in y
1110001b
q)where x in y      / indexes of items of x also in y
0 1 2 6
q)x where x in y    / select items of x also in y
6 8 7 6
```

The above is a form of set intersection.
We might not want any duplicates.

```q
q)distinct x where x in y
6 8 7
```

As we are starting to develop some expressions of non-trivial length, it is time to show how to define procedures that embody those expressions. Forming a procedure is like assigning an expression (in programming-language terminology, a ‘lambda expression’) to a variable. Because set manipulation occurs all over most application, we define set functions first.


## Procedures

The `[x;y]` indicates the name of the arguments: the formal parameters.
The unary keyword `distinct` removes duplicates from a list.

```q
q)intersect:{[x;y] distinct x where x in y}

q)a: 4 2 6 4 3 5 1
q)b: 3 5 4 6 7 2 8 9
q)intersect[a;b]
4 2 6 3 5
```

Next we define a function that determines whether one list is a subset of the other.

The function `min` returns the minimum item of a vector. If a boolean vector, then `min` will return 1 only if all items are 1.

```q
q)subset:{[x;y] min x in y}
q)subset[a;b]
0b
q)subset[a;a]
1b

q)c: `a`b`a`b`d`e / remember no spaces in symbol lists
q)d: `b`d`a`e`f
q)subset[c;d]
1b
q)subset[d;c]
0b
```

Set difference is the discovery of all items in a first list that are not in a second.
This function produces a boolean vector of the items in `x` that are in `y` (`x in y`).
Flips the bits so 1 goes to 0 and 0 goes to 1 (`not x in y`).
Then it finds the locations of those bits (`where not x in y`).
Finally, it indexes `x` with those locations.

```q
q)difference:{[x;y] x where not x in y}
q)difference[c;d] / no such element
0#`
q)difference[d;c] /  only `f is in d but not in c
,`f
```


## Statistical functions

As befits a programming language for analytics, q provides a rich set of mathematical and statistical primitives. 
You might want to bookmark them.

<i class="fas fa-book-open"></i>
[Mathematics and statistics](../../basics/math.md)

```q
q)a: 4 3 6 13 1 32 8
q)std a
9.839529
```


## String functions

The keyword `like` determines whether a string matches a pattern.
The keyword `ss` finds the positions of a pattern.

```q
q)a: "We the people of the United States"
q)a like "people" / "people" doesn't match the whole string
0b
q)a like "*people*" / * is a wildcard
1b
q)a ss "the" / positions where the word "the" starts
3 17
```

<i class="fas fa-book-open"></i>
[String functions](../../basics/strings.md)


## Important unary keywords

Some other important unary keywords:

<pre markdown="1" class="language-txt">
[`string`](../../ref/string.md)   atoms (including symbols) as strings
[`first`](../../ref/first.md)    first item of a list, value of a dictionary, or row of a table
[`reverse`](../../ref/reverse.md)  reversed list
[`til`](../../ref/til.md)      generate a sequence of numbers
[`group`](../../ref/group.md)    applied to a vector, a dictionary where
           key: unique items in the vector 
           value: lists of their positions
</pre>

```q
q)string `ILoveNY
"ILoveNY"
q)reverse string `ILoveNY
"YNevoLI"
q)til 15
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14
q)reverse til 15
14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
q)show z: 50+ til 5
50 51 52 53 54
q)show zdup: z, reverse z / the comma is concatenation
50 51 52 53 54 54 53 52 51 50
q)group zdup
50| 0 9
51| 1 8
52| 2 7
53| 3 6
54| 4 5
```

`group zdup` returns a dictionary with the unique elements of `zdup` in the key and their positions in the value.

```q
q)d:`name`salary! (`tom`dick`harry; 30 30 35)
q)first d
`tom`dick`harry
q)key d
`name`salary
q)show e:flip d / names are domains and values are column
name  salary
------------
tom   30
dick  30
harry 35
q)first e
name  | `tom
salary| 30

q)`name xkey `e
`e
q)key e
name
-----
tom
dick
harry
```


## Binary primitives

Some other common binary primitives.
(You may have noticed that the unary primitives are all keywords.
Most of the binary primitives are just keyboard characters.)

<pre markdown="1" class="language-txt">
~    [Match](../../ref/match.md)   tell whether two entities have the same contents
,    [Join](../../ref/join.md)    concatenate two lists
_    [Drop](../../ref/drop.md)    drop items from a list
\#    [Take](../../ref/take.md)    select items of a list
?    [Find](../../ref/find.md)    find the positions of items in a list
?    [Deal](../../ref/deal.md)    generate random numbers
[bin](../../ref/bin.md)          binary search
</pre>

```q
q)x: 2 4 3 5
q)y: 2 5 3 4
q)x = y
1010b
q)x ~ y / not identical
0b
q)z: 2 4 3 5
q)x ~ z / identical
1b
q)z,z,y,z / concatenation
2 4 3 5 2 4 3 5 2 5 3 4 2 4 3 5
q)w: z, (2*z), (3*y)
q)w
2 4 3 5 4 8 6 10 6 15 9 12
q)5 _ w / drop the first 5 items
8 6 10 6 15 9 12
q)-5 _ w / drop last 5 items
2 4 3 5 4 8 6
q)a: "We the people of the United States"
q)5 # a / first 5 items
"We th"
q)-5 # a / last 5 items
"tates"
```

With a vector left argument, `_` is the [Cut](../../ref/cut.md) operator.

```q
q)a = " "
0010001000000100100010000001000000b
q)ii: where a = " " / positions of the blanks
q)ii _ a
" the"
" people"
" of"
" the"
" United"
" States"
```

The result above is a list where each item is the part of the list between one blank and the next.

```q
q)7 # "abc"
"abcabca"
q)a ? "p" / first position with a "p"
7
q)a ? "ptb" / first positionS of "p", "t" and "b"
7 3 34
```

Above, `"b"` is never present so its position is the length of the string, which is 34.

When the left and right arguments are atoms we can generate random numbers that can be float.

```q
q)7 ? 5.2 / 7 numbers between 0 and 5.2
0.9677783 4.321816 3.661838 2.394824 2.102985 0.9226833 2.556388
```

Or whole numbers.

```q
q)9 ? 18
15 1 1 8 6 11 10 8 9

q)-9 ? 18 / without replacement
13 9 10 2 3 0 15 1 7

q)-15 ? 15 / permutations
13 0 1 3 7 10 6 4 14 11 9 8 2 5 12

q)7 ? `cain`abel`job`isaac
`job`job`abel`abel`job`cain`isaac

q)show evens: 2 * til 20
0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38
q)evens bin 4 / 4 is at position 2
2
q)evens bin 5 / also 2, because 5 < 6 which is at the next position
2
```

<i class="fas fa-book"></i>
[Reference card](../../ref/index.md)

---
<i class="far fa-hand-point-right"></i>
[Operations on dictionaries](operations-dict.md)

