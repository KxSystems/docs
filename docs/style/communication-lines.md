---
title: Lines of communication – Remarks on Style – kdb+ and q documentation
description: A variable is a line of communication between where it is set and where it is read. The length of that line affects clarity. 
author: Stephen Taylor
date: Sep 2018
keywords: kdb+, q, style
---
# Lines of communication


A variable is a line of communication between where it is set and where it is read. The length of that line affects clarity. 

Naming a function or value saves it for use later – and ‘further away’. It’s a way to communicate across ‘distance’ – time and space. It tells the reader: remember this, we’re going to need it later. 

Each such request is a burden.

The nearer and sooner we use it, the sooner we unburden our reader, and more clearly she sees what’s going on. We should shorten our communication paths. But what is shorter than what?

Let’s try to formalise our intuitions about distances within the workspace by ranking different instances of distance.


## Distance within an expression

The expression being executed is where the action is. So our first metric is distance within an expression. Consider the following two equivalent function lines.

```q
rows:format 1; selection:where rows#0 1   / [1]
selection:where(rows:format 1)#0 1        / [2]
```

The distance in [2] between setting and reading `rows` is less than in [1]. Now consider a third equivalent.

```q
selection:{where x#0 1}format 1           / [3]
```

Here a lambda is used, carrying the value in its argument `x`, which is local to it, and thus clearly extinguished when the lambda has been evaluated. Because it’s clear no further use will be made of this stored value, [3] is clearer than [2], where `rows` might have had some later use.

Of course, an even clearer expression is:

```q
selection:where(format 1)#0 1             / [4]
```

in which not even a local name is assigned.


## Distance between lines

Our second intuition of ‘distance’ is between lines in a function. The more function lines separate the naming and the using of an object, the further apart they are, and the longer is the communication path. Any two name references in the same line of code are closer together than any two references on different lines.


## Distance between functions

Our third intuition of distance is between levels on the execution stack, or execution stack. References on different levels of the execution stack are further apart than references in the same lambda.

These intuited distances seem to combine according to discernible rules. Consider: function `F` calls `G`, then `H`. `G` sets a variable `a`, and `H` reads it. (We do not recommend this design.)

```q
F:{[x]
  G x
  H}
```

The distance between naming `a` in `G` and reading it in `H` is something like the sum of the distance in `F` between lines [1] and [2], and the one-level differences in the evaluation stack between `G` and `F`, and `H` and `F`.

Shortening the line of communication increases clarity. Having `G` return `a` as a result, and `H` take it as an argument gives us:

```q
F:{[x]
H G x}
```

And even better: `F:'[H;G]` where the distances between symbols `F`, `G` and `H` are even shorter. Here we see that the principle of shortening lines of communication at least recommends to us practices we already know promote clarity.

**Shorten lines of communication.**


:fontawesome-regular-hand-point-right:
[“Three Principles of Coding Clarity”](http://archive.vector.org.uk/art10009750)
