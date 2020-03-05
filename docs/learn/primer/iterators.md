---
title: Iterators in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Iterators in kdb+ and q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Iterators


Most iteration in q is implicit in atomic operators. Most of the rest is controlled with special operators, called _iterators_. 

It is possible to write explicit loops in q, but it is rarely necessary to do so.

The [map iterators](../../ref/iterators.md) Each, Each Left, Each Right, and Each Prior control how operators are iterated through argument lists.

```q
q)x: 10 30 20 40
q)y: 13 34 25 46

q)x,y
10 30 20 40 13 34 25 46

q)x,'y                  / x join Each y
10 13
30 34
20 25
40 46

q)x,\: y                / x Join Each Left y
10 13 34 25 46
30 13 34 25 46
20 13 34 25 46
40 13 34 25 46

q)x,/: y                / x Join Each Right y
10 30 20 40 13
10 30 20 40 34
10 30 20 40 25
10 30 20 40 46

q)show x: 1 _ x         / drop the first item
30 20 40
q)show y: -2 _ y        / drop the last two items
13 34

q)/ combine Each Left and Each Right to be a cross-product (Cartesian product)
q)x,/:\:y 
30 13 30 34
20 13 20 34
40 13 40 34
```

A cross-product combines each item from `x` with each from `y`. 
Because the above format may not be convenient there is a special unary keyword that undoes a level of nesting: `raze`.

```q
q)raze x,/:\:y
30 13
30 34
20 13
20 34
40 13
40 34
```

Sometimes a function is meant to be applied to each item of a list.
That is, it is unary with respect to each item of the list.
The [`each`](../../ref/each.md) keyword take a unary function as left argument.

```q
q)reverse (1 2 3 4;"abc")      / reverse the two items of this list
"abc"
1 2 3 4

q)reverse each (1 2 3 4;"abc") / reverse each list within this pair
4 3 2 1
"cba"
```

Here is an example that shows how you can use your function with this.
Suppose we want to compute a random selection of the items

```q
rockroll: `i`love`rockandroll
```

for each element of a numerical list, e.g.

```q
numlist: 4 7 3 2
```

We define a function

```q
myrand:{[n] n ? rockroll}
```

Then we can apply `myrand` to each element of `numlist`.

```q
q)myrand each numlist
`i`i`rockandroll`love
`rockandroll`love`rockandroll`rockandroll`love`i`love
`rockandroll`rockandroll`love
`i`love
```

The point is that it creates a list for each element in `numlist`. 

<i class="fas fa-book-open"></i>
[Iteration](../../basics/iteration.md)


---
<i class="far fa-hand-point-right"></i>
[Table operations (qSQL)](table-operations.md)

