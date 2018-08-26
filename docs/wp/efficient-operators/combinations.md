---
title: Combining operators
authors: 
    - Conor Slattery
    - Stephen Taylor
date: August 2018
keywords: efficiency, kdb+, operators, q
---

# Combining operators




Multiple operators can be used within the same expression, or even
applied to the same function, to achieve a result which cannot
be obtained using only one. 

In this section, we will look at some common and useful examples. 
While the results produced by these examples might seem confusing initially, by
taking each operator in turn and applying it to its unary, binary or
higher-rank argument we can see the rules already described are still
being followed.

The example below uses both Each Prior and Scan to return the first rows of Pascal’s Triangle.

```q
q) pascal:{[numRows] fn:{(+':)x,0} ; numRows fn\1};
q) pascal 7
1
1 1
1 2 1
1 3 3 1
1 4 6 4 1
1 5 10 10 5 1
1 6 15 20 15 6 1
1 7 21 35 35 21 7 1
```

To understand what is happening here first look at the definition of `fn`. 
Here, Each Prior is applied to the Add operator. 
The derivative returns the sum of all adjacent pairs in its argument.
Zero is appended to the argument to retain the final 1 in each evaluation.
 
The Scan operator applied to the unary function `fn` derives a function that uses the results of one iteration as the argument of the next.
After `numRows` iterations the result of each iteration,
along with the initial argument, is returned.
 
A commonly used example of applying multiple operators to a function is
illustrated in the following piece of code `,/:\:`, which returns
all possible combinations of two lists by applying Each Left
and Each Right to the Join function `,`. 
The order of the operators affects the result.

```q
q) raze 1 2 3 ,/:\: 4 5 6
1 4
1 5
1 6
2 4
2 5
2 6
3 4
3 5
3 6
q) raze 1 2 3 ,\:/: 4 5 6
1 4
2 4
3 4
1 5
2 5
3 5
1 6
2 6
3 6
```
 
To grasp how q interprets the above, note the following equivalences.

```txt
1 2 3 ,/:\: 4 5 6     <==>     ((1,/:4 5 6);(2,/:4 5 6);(3,/:4 5 6))
1 2 3 ,\:/: 4 5 6     <==>     ((1 2 3,\:4);(1 2 3,\:5);(1 2 3,\:6))
```

Another example of combining operators is `,//`. 
This repeatedly flattens a nested list until it cannot be flattened any more.

The two Over operators in this example do different things. 
The left-hand Over is applied to the Join operator, deriving `,/`, 
which joins the first item of its argument to the second, 
the result to the third item, and so on through the rest of the list. 
(The aggregate `,/` is in fact the `raze` function.)

```q
q)l:(1 2 3;(4 5;6);(7;8;(9;10;11)))        / mixed list
q)(,/)l
1
2
3
4 5
6
7
8
9 10 11
q)raze[l]~(,/)l
1b
```

The derivative `,/` is ambivalent. 
We shall pass it to the second Over as a unary argument: `(,/)/`.
This form is Converge. 
The derivative `,/` is applied until it has no further effect.

```q
q)((,/)/)l
1 2 3 4 5 6 7 8 9 10 11
```

But the inner parentheses are unnecessary. 

```q
q)(,//)l
1 2 3 4 5 6 7 8 9 10 11
```

In `,//` the argument of the second `/` is `,/`. 

The Each operator can also be combined with itself in order to apply a function to the required level of depth in nested lists.

```q
q) lst:(3 2 8;(3.2;6h);("AS";4))
q) type lst
0h
q) (type')lst
7 0 0h
q) (type'')lst
-7 -7 -7h
-9 -5h
10 -7h
q) (type''')lst
-7 -7 -7h
-9 -5h
(-10 -10h;-7h)
```


