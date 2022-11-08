---
title: Q versions of Python array programming examples| Documentation for kdb+ and q
description: Python programming examples and their q equivalents
author: Stephen Taylor
date: February 2020
---
# Array programs


From
:fontawesome-solid-globe:
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and Python solutions.


## [Sum of an array](https://www.geeksforgeeks.org/python-program-to-find-sum-of-array/)

```python
>>> sum([1, 2, 3])
6
>>> sum([15, 12, 13, 10])
50
```

```q
q)sum each (1 2 3; 15 12 13 10)
6 50
```


## [Largest item in an array](https://www.geeksforgeeks.org/python-program-to-find-largest-element-in-an-array/)

```python
>>> max([10, 20, 4])
20
>>> max([20, 10, 20, 4, 100])
100
```
```q
q)max each (10 20 4; 20 10 20 4 100)
20 100
```


## [Rotate an array](https://www.geeksforgeeks.org/python-program-for-program-for-array-rotation-2/)

```python
>>> import numpy as np
>>> np.roll([1, 2, 3, 4, 5, 6, 7],-2)
array([3, 4, 5, 6, 7, 1, 2])
```

Q has a [primitive for rotating lists](../../../ref/rotate.md).

```q
q)2 rotate 1 2 3 4 5 6 7
3 4 5 6 7 1 2
```


## [Remainder of array multiplication divided by n](https://www.geeksforgeeks.org/python-program-for-find-reminder-of-array-multiplication-divided-by-n/)

```python
def findremainder(arr, n):
    lens, mul = len(arr), 1
    for i in range(lens):
        mul = (mul * (arr[i] % n)) % n
    return mul % n
```
```python
>>> findremainder([ 100, 10, 5, 25, 35, 14 ], 11)
9
```
```q
findRemainder:{(x*y) mod 11} over
```
```q
q)findRemainder 100 10 5 25 35 14
9
```

<big>:fontawesome-regular-comment:</big>
The binary lambda `{(x*y)mod 11}` returns the modulo-11 of the product of two numbers.
[`over`](../../../ref/over.md) applies it to reduce the argument list.

The naïve solution

```q
q)(prd 100 10 5 25 35 14) mod 11
9
```

overflows for a long list.


## [Reconstruct array, replacing `arr[i]` with `(arr[i-1]+1)%M`](https://www.geeksforgeeks.org/reconstruct-the-array-by-replacing-arri-with-arri-11-m/)

```python
def construct(m, a):
    ind, n = 0, len(a)

    # Finding the index which is not -1
    for i in range(n):
        if (a[i]!=-1):
            ind = i
            break

    # Calculating the values of the indexes ind-1 to 0
    for i in range(ind-1, -1, -1):
        if (a[i]==-1):
            a[i]=(a[i + 1]-1 + m)% m

    # Calculating the values of the indexes ind + 1 to n
    for i in range(ind + 1, n):
        if(a[i]==-1):
            a[i]=(a[i-1]+1)% m
    print(*a)
```
```python
>>> construct(7, [5, -1, -1, 1, 2, 3])
5 6 0 1 2 3
>>> construct(10, [5, -1, 7, -1, 9, 0])
5 6 7 8 9 0
```

```q
construct:{[v;M] {$[y=-1;(x+1)mod z;y]}[;;M]\[v]}
```
```q
q)construct[5 -1 -1 1 2 3;7]
5 6 0 1 2 3
q)construct[5 -1 7 -1 9 0;10]
5 6 7 8 9 0
```

<big>:fontawesome-regular-comment:</big>
The q solution applies a binary lambda

```q
{$[y=-1;(x+1)mod z;y]}[;;M]
```

to successive pairs of items of argument vector `v`.
The lambda is defined with three arguments and projected on `M` – constant for each iteration – so becoming a binary that can be iterated through the vector.

Successive application relies on the [Scan](../../../ref/accumulators.md#binary-application) iterator.


## [Is array monotonic?](https://www.geeksforgeeks.org/python-program-to-check-if-given-array-is-monotonic/)

```python
def isMonotonic(A):
    return (all(A[i] <= A[i + 1] for i in range(len(A) - 1)) or
        all(A[i] >= A[i + 1] for i in range(len(A) - 1)))
```
```python
>>> isMonotonic([6, 5, 4, 4])
True
```
```q
isMonotonic:{asc[x]in(x;reverse x)}
```
```q
q)isMonotonic 6 5 4 4
1b
q)isMonotonic 6 5 3 4
0b
```

<big>:fontawesome-regular-comment:</big>
Both these solutions overcompute. The Python program traverses the entire list twice. The q program sorts the entire list. Native sort in q is very fast, but if the list is long and likely to fail we might prefer to iterate and stop as soon as we find the list is not monotonic.

Monotony can rise or fall, so we test the first pair for both cases. The first several items in the list may match, so we continue testing with both ≤ and ≥ until we eliminate one or both. So, a two-item initial state.

```q
(1;(<=;>=))
```

`1` is the next (first) index to test; the operators `(<=;>=)` are the tests to apply. (They would be `(<;>)` for strict monotony.) Our function will try the tests, returning those that pass, and the next index, as the next state. We shall apply it with the [While iterator](../../../ref/accumulators.md#while), so we need it be unary, i.e. to take one argument. We also want it to refer to the list, so we project a binary lambda on the list to bind the list to the lambda as a constant value for its `y` argument.

```q
q)v:5 5 5 5 6 6 7 8 9 11  / list to test
q)it:(1;(<=;>=))  / initial state: index and tests
q)try:{[x;y] i:x 0; f:x 1; (i+1; f where f .\:y i-1 0) }[;v]
q){count x 1} try\it
1  (~>;~<)
2  (~>;~<)
3  (~>;~<)
4  (~>;~<)
5  ,~>
6  ,~>
7  ,~>
8  ,~>
9  ,~>
10 ,~>
11 ()
```

Above we see the ≤ test eliminated after item 4.
Our test function for the iterator `{count x 1}` stops iteration when the list of functions is empty.
The last result will be `(n;())`, with `n` the next index that would have been tested.

We can improve this, using the [Converge](../../../ref/accumulators.md#converge) iterator.

```q
isMt:{[v]                             / is monotonic?
  try:{[x;y]                          /   apply tests x[1] between y x[0]-1 0
    i:x 0; f:x 1;                     /     index; tests
    go:i<count y;                     /     end of list?
    f:$[go;f where f .\:y i-1 0;f];   /     tests passed
    go&:0<count f;                    /     keep testing?
    (i+go;f)
  }[;v];                              /   project onto v
  it:(1;(<=;>=));                     /   initial state
  count[v]=first try/[it] }           / reached end of v?
```

The first item of the final result of `try/[it]` is the last index for which at least one of the tests ≤ and ≥ held true. We compare it to `count[v]` to see if `try` got to the end of the list. 

The second item of the final result is the list of tests that held true. 
Instead of testing the final index, we could count that list to see if either ≤ or ≥ held true throughout `v`. The result of `isMt` would then be `  {0<count x 1}try/[it]`

```q
q)isMt 6 5 4 4
1b
q)isMt 6 5 3 4
0b
```

The above approach can be generalized.
The list of functions could be of any length, contain any binary functions.
The initial index could be anywhere in the list, and `try` adapted to stop iteration before the end of the list.


---
:fontawesome-regular-hand-point-right:
[List examples](list.md)