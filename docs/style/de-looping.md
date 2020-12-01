---
author: Stevan Apter
keywords: kdb+, q, style
---

# De-looping



<!-- FIXME: Test code. -->

List algorithms in q are simpler, shorter, clearer, and almost always faster than their looping counterparts. Summing all the items of a matrix, all the rows of a matrix, all the columns of a matrix `m`:

```q
+/[m]               / sum the columns of m
+/'[m]              / sum the rows of m
+//[m]              / sum m
```

Summing the rows with a nested loop:

```q
vsum:{[m]           / shoot this code
  r:(count m)#0;
  i:-1;
  do[count m;
    i+:1;
    v:m[i;];
    s:0;
    j:-1;
    do[count v;
      j+:1;
      s:s+v[j]];
      r[i]:s];
  r}
```

Sometimes it is necessary to write loopy code, either because the algorithm is inherently iterative, or because we aren’t smart enough to find the list solution in the time available. The literature devoted to this topic is vast, and we won’t replay it here. Instead we’ll concentrate on an example which shows how, in some cases, a clear looping solution can serve as a stepping stone on the way to loop elimination. 

We want to write a function which takes 

-   some table columns of strings
-   the same number of strings

and returns the indexes of rows where each string occurs in the same item of each string list:

```q
q)t
id   c1      c2
----------------------
1000 "this"  "and"
1001 "is"    "this"
1002 "the"   "is"
1003 "first" "yet"
1004 "list"  "another"
q)S:("is";"an")
q)search[L;S]
0 4
```

The column names don’t matter. Let’s solve for the values.

```q
L:t `c1`c2
```

```q
q)L:(("this";"is";"the";"first";"list");("and";"this";"is";"yet";"another"))
```

An obvious subproblem is a single list of strings and a single string. Let’s write a function which takes one string list `x` and one string `y` and tells us which items of `x` contain `y`:

```q
sss:{where count each x ss\:y}
q)sss[L 0;S 0]
0 1 4
```

Now, using `sss`, we write the loopy version:

```q
search1:{                              / loopy search
  r:til count first x;                 /   initialize result to all rows
  i:0;                                 /   initialize counter
  do[count x;                          /   loop over each string list
    r@:sss[x[i]@r;y[i]];               /     save result indexed by hits
    i+:1];                             /     increment counter
  r}                                   /   indexes of rows where all hit
```

At each iteration, we derive a new result by indexing the previous result of `sss` by the new result of `sss`. The arguments to `sss` are the i-th string list indexed by the previous result and the i-th string. (Alarm bells should now be going off for q programmers familiar with `+/` – and which are not?)

Most loop eliminations are achieved by using some form of Each, but this is not one of them[^1]. The result of each iteration depends on the result of the previous iteration, and each-iterations are independent of one another. So the next place to look is `f/` – Over.

An Over solution will have the form `f/[x;y;z]`, where `f` will be applied iteratively to three arguments:

-   `x`, the result of the previous iteration
-   `y`, a list of string lists
-   `z`, a list of strings to search for in corresponding lists of `y`

A good `f` is:

```q
{x@sss[y@x;z]}
```

which we get by re-lettering the inner calculation of the `do`-loop and discarding the loop index `i`.

Now define `search2` as this function over the appropriate values

```q
search2:{{x@sss[y@x;z]}/[til count first x;x;y]}
```

Observe that we prime the iteration with `til count first L`, the indexes of the first string list.

```q
q)search2[L;S]
0 4
```

!!! important "Derive non-looping solutions from well-designed looping solutions."

[^1]: Not strictly true: the problem can be solved with Each, but the converging solution using Over is both faster and more readable.


