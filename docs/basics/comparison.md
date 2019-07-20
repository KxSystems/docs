---
title: Comparison
description: Operators and keywords for comparing values
author: Stephen Taylor
keywords: comparison, differ, equal, greater-than, greater-than-or-equal, kdb+, less-than, less-than-or-equal, match, not-equal, operators, q
---
# Comparison






## More or less

<table class="kx-compact" markdown="1">
<tr><td>[`<`](../ref/less-than.md)   </td><td> Less Than        </td><td> [`>`](../ref/greater-than.md)  </td><td> Greater Than</td></tr>
<tr><td>[`<=`](../ref/less-than.md)  </td><td> Up To            </td><td> [`>=`](../ref/greater-than.md) </td><td> At Least</td></tr>
<tr><td>[`&`](../ref/lesser.md)      </td><td> Lesser           </td><td> [`|`](../ref/greater.md)       </td><td> Greater</td></tr>
<tr><td>[`min`](../ref/min.md)       </td><td> least, minimum   </td><td> [`max`](../ref/max.md)         </td><td> greatest, maximum</td></tr>
<tr><td>[`mins`](../ref/min.md#mins) </td><td> running minimums </td><td> [`maxs`](../ref/max.md#maxs)   </td><td> running maximums</td></tr>
<tr><td>[`mmin`](../ref/min.md#mmin) </td><td> moving minimums  </td><td> [`mmax`](../ref/max.md#mmax)   </td><td> moving maximums</td></tr>
</table>


## Six comparison operators

<table class="kx-compact" markdown="1">
<tr><td>`=`</td><td>[Equal](../ref/equal.md)</td><td>`<>`</td><td>[Not Equal](../ref/not-equal.md)</td></tr>
<tr><td>`>`</td><td>[Greater Than](../ref/greater-than.md)</td><td>`>=`</td><td>[At Least](../ref/greater-than.md)</td></tr>
<tr><td>`<`</td><td>[Less Than](../ref/less-than.md)</td><td>`<=`</td><td>[Up To](../ref/less-than.md)</td></tr>
</table>

Syntax: (e.g.) `x = y`, `=[x;y]`

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

Unlike [Match](../ref/match.md), they are not strict about type.

```q
q)1~1h
0b
q)1=1h
1b
```

[Comparison tolerance](precision.md#comparison-tolerance) applies when matching floats.

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


## `deltas`

Keyword [`deltas`](../ref/deltas.md) is a uniform unary function that returns the differences between items in its numeric list argument.


## `differ` 

Keyword [`differ`](../ref/differ.md) is a uniform unary function that returns a boolean list indicating where consecutive pairs of items in `x` differ.


## Match

[Match](../ref/match.md) (`~`) compares its arguments and returns a boolean atom to say whether they are the same.


<i class="far fa-hand-point-right"></i> 
[Comparison tolerance](precision.md#comparison-tolerance)

