# `count`




_Count the items of a list or dictionary_

Syntax: `count x`, `count[x]`  
Syntax: `(#)x`, `#[x]` (deprecated)

Where `x` is an atom or list, returns

-   for a list, the number of its items
-   for an atom, 1

```q
q)count 0                            / atom
1
q)count "zero"                       / vector
4
q)count (2;3 5;"eight")              / mixed list
3
q)count each (2;3 5;"eight")
1 2 5
q)count `a`b`c!2 3 5                 / dictionary
3
q)/ the items of a table are its rows
q)count ([]city:`London`Paris`Berlin; country:`England`France`Germany)
3
q)count each ([]city:`London`Paris`Berlin; country:`England`France`Germany)
2 2 2
```

Use with [`each`](progressive-operators.md#each) to count the number of items at each level of a list or dictionary.

```q
q)RaggedArray:(1 2 3;4 5;6 7 8 9;0)
q)count RaggedArray
4
q)count each RaggedArray
3 2 4 1
q)RaggedDict:`a`b`c!(1 2;3 4 5;"hello")
q)count RaggedDict
3
q)count each RaggedDict
a| 2
b| 3
c| 5
q)\l sp.q
q)count sp
12
```


