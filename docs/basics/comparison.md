---
title: Comparison | Basics | kdb+ and q documentation
description: Operators and keywords for comparing values
author: Stephen Taylor
keywords: comparison, differ, equal, greater-than, greater-than-or-equal, kdb+, less-than, less-than-or-equal, match, not-equal, operators, q
---
# Comparison






<div markdown="1" class="typewriter">
[<     Less Than](../ref/less-than.md)            [>     Greater Than](../ref/greater-than.md)             [deltas  differences](../ref/deltas.md)
[<=    Up To](../ref/less-than.md)                [>=    At Least](../ref/greater-than.md)                 [differ  flag changes](../ref/differ.md)
[&     Lesser](../ref/lesser.md)               [|     Greater](../ref/greater.md)
[min   least, minimum](../ref/min.md)       [max   greatest, maximum](../ref/max.md)
[mins  running minimums](../ref/min.md#mins)     [maxs  running maximums](../ref/max.md#maxs)
[mmin  moving minimums](../ref/min.md#mmin)      [mmax  moving maximums](../ref/max.md#mmax)
</div>


## Six comparison operators

<div markdown="1" class="typewriter">
[=  Equal](../ref/equal.md)            [<>  Not Equal](../ref/not-equal.md)
[\>  Greater Than](../ref/greater-than.md)     [>=  At Least](../ref/greater-than.md)
[<  Less Than](../ref/less-than.md)        [<=  Up To](../ref/less-than.md)
</div>

Syntax: (e.g.) `x = y`, `=[x;y]`

These binary operators work intuitively on numerical values (converting types when necessary), and apply also to lists, dicts, and tables.
They are atomic.

Returns `1b` where `x` and `y` are equal, else `0b`. 

```q
q)"hello" = "world"
00010b
q)5h>4h
1b
q)0x05<4
0b
q)0>(1i;-2;0h;1b;0N;-0W)
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

`< > = >= <= <>` are [multithreaded primitives](../kb/mt-primitives.md).

!!! tip "For booleans, `<>` is the same as _exclusive or_ (XOR)."


## Temporal values 

Below is a matrix of the [type](datatypes.md) used when the temporal types differ in a comparison (note: scrolling to the right may be required to view full table):

| comparison types | **timestamp** | **month**       | **date**        | **datetime** | **timespan**    | **minute** | **second** | **time** |
| ---              | ---           | ---             | ---             | ---          | ---             | ---        | ---        | ---      |
| **timestamp**    | _timestamp_   | _timestamp_     | _timestamp_     | _timestamp_  | _timespan_      | _minute_   | _second_   | _time_   |
| **month**        | _timestamp_   | _month_         | _date_          | _not supported_ | _not supported_ | _not supported_ |_not supported_   | _not supported_ |
| **date**         | _timestamp_   | _date_          | _date_          | _datetime_   | _not supported_ | _not supported_ |_not supported_   | _not supported_ |
| **datetime**     | _timestamp_   | _not supported_ | _datetime_      | _datetime_   | _timespan_      | _minute_   | _second_   | _time_   |
| **timespan**     | _timespan_    | _not supported_ | _not supported_ | _timespan_   | _timespan_      | _timespan_ | _timespan_ | _timespan_ |
| **minute**       | _minute_      | _not supported_ | _not supported_ | _minute_     | _timespan_      | _minute_   | _second_   | _time_   |
| **second**       | _second_      | _not supported_ | _not supported_ | _second_     | _timespan_      | _second_   | _second_   | _time_   |
| **time**         | _time_        | _not supported_ | _not supported_ | _time_       | _timespan_      | _time_     | _time_     | _time_   |

For example
```q
q)20:00:00.000603286 within 13:30 20:00t            / comparison of timespan and time, time converted to timespan values 0D13:30:00.000000000 0D20:00:00.000000000
0b
q)2024.10.07D20:00:00.000603286 within 13:30 20:00t / comparison of timestamp and time, timestamp converted to time value 20:00:00.000
1b
```

Particularly notice the comparison of ordinal with cardinal datatypes, such as timestamps with minutes.

```q
q)times: 09:15:37 09:29:01 09:29:15 09:29:15 09:30:01 09:35:27
q)tab:([] timeSpan:`timespan$times; timeStamp:.z.D+times)
q)meta tab
c        | t f a
---------| -----
timeSpan | n
timeStamp| p
```

When comparing `timestamp` with `minute`, the timestamps are converted to minutes such that `` `minute$2024.11.01D09:29:15.000000000 `` becomes `09:29` and therefore doesnt appear in the output:

```q
q)select from tab where timeStamp>09:29     / comparing timestamp with minute
timeSpan             timeStamp
--------------------------------------------------
0D09:30:01.000000000 2016.09.06D09:30:01.000000000
0D09:35:27.000000000 2016.09.06D09:35:27.000000000
```

When comparing `timespan` with `minute`, the minute is converted to timespan such that `09:29` becomes `0D09:29:00.000000000` for the following comparison:

```q
q)select from tab where timeSpan>09:29     / comparing timespan with minute
timeSpan             timeStamp
--------------------------------------------------
0D09:29:01.000000000 2016.09.06D09:29:01.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000
0D09:30:01.000000000 2016.09.06D09:30:01.000000000
0D09:35:27.000000000 2016.09.06D09:35:27.000000000
```

Therefore, when comparing ordinals with cardinals (i.e. timestamp with minute), ordinal is converted to the cardinal type first. 

For example:
```q
q)select from tab where timeStamp=09:29
timeSpan             timeStamp
--------------------------------------------------
0D09:29:01.000000000 2016.09.06D09:29:01.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000

q)tab.timeStamp=09:29
011100b
```

is equivalent to

```q
q)(`minute$tab.timeStamp)=09:29
011100b
```
and thus
```q
q)tab.timeStamp<09:29
100000b
q)tab.timeStamp>09:29
000011b
```

:fontawesome-solid-street-view: 
_Q for Mortals_
[§4.9.1 Temporal Comparison](/q4m3/4_Operators/#491-temporal-comparison)


## Different types

The comparison operators also work on text values (characters, symbols).

```q
q)"0" < ("4"; "f"; "F"; 4)  / characters are treated as their numeric value
1110b
q)"alpha" > "omega"         / strings are char lists
00110b
q)`alpha > `omega           / but symbols compare atomically
0b
```

When comparing two values of different types, the general rule (apart from those for temporal types above) is that the [underlying values](glossary.md#underlying-value) are compared. 


## Nulls

Nulls of any type are equal. 

```q
q)n:(0Nh;0Ni;0N;0Ne;0n) / nulls
q)n =/:\: n
11111b
11111b
11111b
11111b
11111b
```

Any value exceeds a null.

```q
q)inf: (0Wh;0Wi;0W;0We;0w)  / numeric infinities
q)n < neg inf
11111b
```


## Infinities

Infinities of different type are ordered by their width. 
In ascending order:

```txt
negative: -float < -real < -long < -int < -short
positive:  short <  int  <  long < real < float 
```

```q
q)inf: (0Wh;0Wi;0W;0We;0w)    / numeric infinities in ascending type width
q)(>=) prior inf              / from short to float
11111b
q)(>=) prior reverse neg inf  / from -float to -short
11111b
```

This follows the rule above for comparing values of different types.


## `deltas`

Keyword [`deltas`](../ref/deltas.md) is a uniform unary function that returns the differences between items in its numeric list argument.


## `differ` 

Keyword [`differ`](../ref/differ.md) is a uniform unary function that returns a boolean list indicating where consecutive pairs of items in `x` differ.


## Match

[Match](../ref/match.md) (`~`) compares its arguments and returns a boolean atom to say whether they are the same.


:fontawesome-solid-book: 
[Comparison tolerance](precision.md#comparison-tolerance)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.3.3 Order](/q4m3/4_Operators/#433-order)

