# `sums`

Syntax: `sums x`, `sums[x]` (unary, uniform)

Where `x` is a numeric or temporal list, returns the cumulative sums of the items of `x`. 

The sum of an atom is itself. Nulls are treated as zeros.
```q
q)sums 7                        / cumulative sum atom (returned unchanged)
7
q)sums 2 3 5 7                  / cumulative sum list
2 5 10 17
q)sums 2 3 0N 7                 / 0N is treated as 0
2 5 5 12
q)sums (1 2 3;2 3 5)            / cumulative sum list of lists
1 2 3                           / same as (1 2 3;1 2 3 + 2 3 5)
3 5 8
q)\l sp.q
q)select sums qty by s from sp  / use in select statement
s | qty
--| --------------------------
s1| 300 500 900 1100 1200 1600
s2| 300 700
s3| ,200
s4| 100 300 600
q)sums "abc"                    / type error if list is not numeric
'type
```

<i class="far fa-hand-point-right"></i> [Mathematics](/basics/math), [sum](sums)


