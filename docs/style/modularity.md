---
author: Stevan Apter
keywords: kdb+, q, style
---

# Modularity



Function modularity is a Good Thing, and one way to achieve it is through the judicious use of subfunction abstraction. Artfully modularized systems are easier to understand than ones which are either impenetrably monolithic or which have been decomposed haphazardly.

Kernighan & Plauger’s rules of modularity still apply to q:

-   Use subfunctions.
-   Make the coupling between modules visible. 
-   Each module should do one thing well.
-   Ensure every module hides something. 

To which we add two new rules:

-   Hide shared subfunctions in directories.
-   Localize unshared subfunctions. 

As subfunctions are abstracted, the number of global functions increases. This may help us in the reading of program text, but interfere with our attempts to explore the system interactively. If `.d` is a directory, then we would like `keys .d` to consist of just the entry points of `.d`. So where do the non-entry point subfunctions go?

First define `.d.u`, the utility directory of `.d`. Banish all shared subfunctions of `.d` to `.d.u`. A shared subfunction is one which is called by more than one function in `.d` and/or `.d.u`. In large systems, or where the entry points themselves are shared subfunctions, it may pay to place all the code in `.d.u` and make the functions in `.d` simple covers on the ‘real’ entry points living in `.d.u`. For an example of this approach, see `q.k`. <!-- FIXME Confirm. -->

Next, localize all subfunctions which are called by only one function. For example:

We want to write a function `tree` which produces an indented list representation of the structure of some portion of the K tree. `tree` takes an initial directory `x` and recursively descends from `x` until it finds a non-dictionary. Each recursive step increments a counter variable `y`, which tells the level of descent and is used to calculate the number of spaces to prefix to the (unqualified) directory name. 

Here is a version of `tree`:

```q
q)tree
{
  p:$[x~`; x; `$({x,".",y}/)string x];        / path:special case `
  c:key p;
  $[0>type c;
    ();
    (enlist(y#" "),string last x),(,/)(p,/:1_c) .z.s\:y+1]
  }
q)-1 tree[`;0]

 Q
  vt
  BP
 h
  tx
  ty
 j
 o
-1
```

:fontawesome-regular-hand-point-right: 
Reference: [`.z.s`](../ref/dotz.md#zs-self)

Observe that the user of `tree` has to supply an initial value for the counter, always 0. Bit of gunk. 

We can’t avoid making `tree` binary, since q doesn’t let us define variadic functions. We’d also like to have ` tree` print the list and return null, and that seems to involve testing the counter to decide whether to return a result (if the call is recursive) or print with no result, if the call is top-level. We are now well beyond gunk. 

In languages without local functions, we would probably settle for having two functions:

```q
tree:{-1 treeRec[x;0];}
treeRec:{…
```

where `treeRec` is the recursive function just described, and `tree` is the entry point. 

In q the solution is to make the recursive routine a local subfunction:

```q
q)tree
{
  tr:{
    p:$[x~`; x; `$({x,".",y}/)string x];        / path:special case `
    c:key p;
    $[0>type c;
      ();
      (enlist(y#" "),string last x),(,/)(p,/:1_c) .z.s\:y+1]
  };
  -1 tr[`;0];
  }
q)tree `

 Q
  vt
  BP
 h
  tx
  ty
 j
 o
```

