---
title: Comparison
keywords: comparison, differ, equal, greater-than, greater-than-or-equal, kdb+, less-than, less-than-or-equal, match, not-equal, operators
---

# Comparison



<i class="far fa-hand-point-right"></i> [Comparison tolerance](precision.md#comparison-tolerance)


## Six comparison operators

<table class="kx-compact" markdown="1">
<tr><td>`=`</td><td>[equal](../ref/equal.md)</td><td>`<>`</td><td>[not-equal](../ref/not-equal.md)</td></tr>
<tr><td>`>`</td><td>[greater-than](../ref/greater-than.md)</td><td>`>=`</td><td>[greater-than-or-equal](../ref/greater-than.md)</td></tr>
<tr><td>`<`</td><td>[less-than](../ref/less-than.md)</td><td>`<=`</td><td>[less-than-or-equal](../ref/less-than.md)</td></tr>
</table>

Syntax: (eg) `x = y`

These binary operators work intuitively on numerical values (converting types when necessary), and apply also to lists, dicts, and tables.
They are atomic.

Returns `1b` where `x` and `y` are equal, else `0b`. 

```q
q)"hello" = "world"
00010b
q)5h>4h
1b
q)0x05<4j
0b
q)0>(1i;-2j;0h;1b;0N;-0W)
010011b
q)5>=(`a`b!4 6)
a| 1
b| 0
```

Unlike Match, they are not strict about type.

```q
q)1~1h
0b
q)1=1h
1b
```

Comparison tolerance applies when matching floats.

```q
q)(1 + 1e-13) = 1
1b
```

!!! tip 

    For booleans, `<>` is the same as _exclusive or_ (XOR).


### Non-numerical arguments

The comparison operators also work on non-numerical values (characters, temporal values, symbols) – not always intuitively.

```q
q)"0" < ("4"; "f"; "F"; 4)  / characters are treated as their numeric value
1110b
q)"alpha" > "omega"         / strings are char lists
00110b
q)`alpha > `omega           / but symbols compare atomically
0b
```

Particularly notice the comparison of ordinal with cardinal datatypes, such as timestamps with minutes.

```q
q)times: 09:15:37 09:29:01 09:29:15 09:29:15 09:30:01 09:35:27
q)spans:`timespan$times  / timespans:  cardinal
q)stamps:.z.D+times      / timestamps: ordinal 
q)t:09:29                / minute:     cardinal
```

When comparing ordinals with cardinals, ordinal is converted to the cardinal type first: `stamps=t` is equivalent to ``(`minute$stamps)=t`` and thus 

```q
q)(stamps<t;stamps=t;stamps>t)
100000b
011100b
000011b
q)(spans<t;spans=t;spans>t)
100000b
000000b
011111b
```

<i class="far fa-hand-point-right"></i> Knowledge Base: [Temporal data](../kb/temporal-data.md#comparing-temporals)


## [`differ`](../ref/differ.md)

Uniform unary function that returns a boolean list indicating where consecutive pairs of items in `x` differ. 


## [Match](../ref/match.md) 

Match (`~`) compares its arguments and returns a boolean atom to say whether they are the same.