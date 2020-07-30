---
title: Temporal data – Knowledge Base – kdb+ and q documentation
description: How to handle temporal data in q
keywords: data, kdb+, q, temporal
---
# How to handle temporal data in q






## Stepped attribute

In traditional RDMSs temporal changes in data are often represented by adding valid-time-interval information to each relationship, usually achieved by adding start and end columns to the relational tables. This approach is often wasteful because in many cases the end of each interval is the start of the next leading to a lot of repetition. Q offers a better alternative. Recall that adding an `` `s `` attribute to a dictionary makes it behave as a step function.

Compare

```q
q)d:(10*til 10)!til 10
q)d 5 10 15
0N 1 0N
```

and

```q
q)s:`s#d
q)s 5 10 15
0 1 1
```

Since keyed tables in q are a special case of a dictionary, adding an `` `s `` attribute to a keyed table has similar effect. For example, consider a table that records changes in a phone book:

```q
q)show ph
name date      | phone
---------------| -----
Bill 2000.01.01| 4444
John 2000.01.01| 5555
John 2000.06.10| 4444
```

Without an `` `s `` attribute, this table will readily produce for example John’s phone number on the date of the change, but any other date will produce an `0N`.

```q
q)show ph ((`John;2000.01.01);(`John;2000.03.01);(`John;2000.06.10))
phone
-----
5555

4444
```

Adding the attribute will change the result to

```q
q)ph:`s#ph
q)show ph ((`John;2000.01.01);(`John;2000.03.01);(`John;2000.06.10))
phone
-----
5555
5555
4444
```

Such tables can be used with `lj`:

```q
q)show x
name date      | x
---------------| -
John 2000.06.08| 0
John 2000.06.09| 1
John 2000.06.10| 2
John 2000.06.11| 3
John 2000.06.12| 4
q)show x lj ph
name date      | x phone
---------------| -------
John 2000.06.08| 0 5555
John 2000.06.09| 1 5555
John 2000.06.10| 2 4444
John 2000.06.11| 3 4444
John 2000.06.12| 4 4444
```


### Upsert into a stepped dictionary

If you try to upsert into a dict flagged as stepped, a `'step` error will be signalled.

```q
q)d:`s#`a`b!1 2;
q)`d upsert `c`d!3 4
'step
```

To update such a dict, remove the `` `s`` attribute, upsert, and add the `` `s`` attribute again.


## Comparing temporals

Particularly notice the comparison of ordinal with cardinal datatypes, such as timestamps with minutes.

```q
q)times: 09:15:37 09:29:01 09:29:15 09:29:15 09:30:01 09:35:27
 
q)tab:([] timeSpan:`timespan$times; timeStamp:.z.D+times)
q)meta tab
c        | t f a
---------| -----
timeSpan | n
timeStamp| p
 
q)select from tab where timeStamp>09:29
timeSpan             timeStamp
--------------------------------------------------
0D09:30:01.000000000 2016.09.06D09:30:01.000000000
0D09:35:27.000000000 2016.09.06D09:35:27.000000000
 
q)select from tab where timeSpan>09:29
timeSpan             timeStamp
--------------------------------------------------
0D09:29:01.000000000 2016.09.06D09:29:01.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000
0D09:29:15.000000000 2016.09.06D09:29:15.000000000
0D09:30:01.000000000 2016.09.06D09:30:01.000000000
0D09:35:27.000000000 2016.09.06D09:35:27.000000000
```

It looks like the timestamp filter is searching for any _minute_ greater than `09:29`, while the timespan is returning any _times_ that are greater than `09:29`.

When comparing ordinals with cardinals (i.e. timestamp with minute), ordinal is converted to the cardinal type first. E.g. in

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

:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md)
