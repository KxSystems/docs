---
title: Q versions of Python list programming examples| Documentation for kdb+ and q
description: Python list programming examples and their q equivalents
author: Stephen Taylor
date: April 2020
---
# List programs

From
:fontawesome-solid-globe:
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and Python solutions.




## [Interchange first and last elements in a list](https://www.geeksforgeeks.org/python-program-to-interchange-first-and-last-elements-in-a-list/)

```python
>>> lis = [12, 35, 9, 56, 24]

>>> lis[0], lis[-1] = lis[-1], lis[0]
>>> lis
[24, 35, 9, 56, 12]
```

`-1` is not an index in q, so we need the end index: `count[x]-1`.
This gives equivalent q expressions.

```q
q)lis:12 35 9 56 24

q)lis[fl]:lis reverse fl:0,count[lis]-1
q)lis
24 35 9 56 12
```


## [Swap two items in a list](https://www.geeksforgeeks.org/python-program-to-swap-two-elements-in-a-list/)

```python
def swapPositions(list, pos1, pos2):
    list[pos1], list[pos2] = list[pos2], list[pos1]
    return list
```
```python
>>> swapPositions([23, 65, 19, 90], 0, 2)
[19, 65, 23, 90]
```

```q
swapPositions:{@[x;y,z;:;x z,y]}
```
```q
q)swapPositions[23 65 19 90;0;2]
19 65 23 90
```

<big>:fontawesome-regular-comment:</big>
Functional [Amend](../../../ref/amend.md) `@` lets us specify the list, the indexes to amend, the function to apply (in this case Assign `:`) and the replacement values. Functional Amend can modify a persisted list at selected indexes without reading the entire list into memory – very efficient for long lists.

Functional Amend is used here to apply Assign (`:`) at selected indexes of the list. The effect is simply to replace selected items. Other operators – or functions – can be used instead of Assign. 


## [Remove Nth occurrence of the given word](https://www.geeksforgeeks.org/python-program-to-remove-nth-occurrence-of-the-given-word/)

```python
def RemoveIthWord(lst, word, N):
    newList = []
    count = 0

    for i in lst:
        if(i == word):
            count = count + 1
            if(count != N):
                newList.append(i)
        else:
            newList.append(i)

    return newList
```
```python
>>> RemoveIthWord(["geeks", "for", "geeks"], "geeks", 2)
['geeks', 'for']
>>> RemoveIthWord(["can", "you", "can", "a", "can", "?"], "can", 1)
['you', 'can', 'a', 'can', '?']
```

```q
RemoveIthWord:{[lst;wrd;i] lst (til count lst) except (sums lst~\:wrd)?i}
```
```q
q)RemoveIthWord[("geeks";"for";"geeks");"geeks";2]
"geeks"
"for"

q)RemoveIthWord[("can";"you";"can";"a";"can";"?");"can";1]
"you"
"can"
"a"
"can"
"?"
```

<big>:fontawesome-regular-comment:</big>
In q, `til count x` returns all the indexes of list `x`. (So `x til count x` is always `x`.)

`lst~\:wrd` flags the items of `lst` that match `wrd`.
We just need to find where the `i`th flag occurs and omit it from the indexes.


## [If item exists in a list](https://www.geeksforgeeks.org/python-ways-to-check-if-element-exists-in-list/)

```python
>>> 4 in [ 1, 6, 3, 5, 3, 4 ]
True
```
```q
q)4 in 1 6 3 5 3 4
1b
```

Similarly whether [a list is an item in a list of lists](https://www.geeksforgeeks.org/python-check-if-a-list-exists-in-given-list-of-lists/).

```python
>>> [1, 1, 1, 2] in [[1, 1, 1, 2], [2, 3, 4], [1, 2, 3], [4, 5, 6]]
True
```
```q
q)1 1 1 2 in (1 1 1 2; 2 3 4; 1 2 3; 4 5 6)
1b
```


## [Clear a list](https://www.geeksforgeeks.org/different-ways-to-clear-a-list-in-python/)

```python
>>> lst = [1, 2, 3]
>>> del lst[:]
>>> lst
[]
```
```q
q)lst:1 2 3  / initialize list
q)lst:0#lst  / take 0 items
q)lst
q)
```

<big>:fontawesome-regular-comment:</big>
Clearing a list means removing all its items while retaining its datatype. 
[`0#`](../../../ref/take.md) is perfect for this. 


## [Reverse a list](https://www.geeksforgeeks.org/python-reversing-list/)

```python
>>> [ele for ele in reversed([10, 11, 12, 13, 14, 15])]
[15, 14, 13, 12, 11, 10]
```

```q
q)reverse 10 11 12 13 14 15
15 14 13 12 11 10
```


## [Count occurrences of an item in a list](https://www.geeksforgeeks.org/python-count-occurrences-element-list/)

```python
>>> [8, 6, 8, 10, 8, 20, 10, 8, 8].count(8)
5
```
```q
q)sum 8 6 8 10 8 20 10 8 8 = 8
5i
```

<big>:fontawesome-regular-comment:</big>
Just as you were taught in school, `=` tests equality. Like other q operators, iteration is implicit, so below `8 6 8 10 8 20 10 8 8 = 8` returns a list of flags: `101010011b`. 

Which we sum. 


## [Second-largest number in a list](https://www.geeksforgeeks.org/python-program-to-find-second-largest-number-in-a-list/)

```python
>>> sorted([10, 20, 4, 45, 99])[-2]
45
```
```q
q)(desc 10 20 4 45 99)1
45
```


## [N largest items from a list](https://www.geeksforgeeks.org/python-program-to-find-n-largest-elements-from-a-list/)

```python
>>> sorted([4, 5, 1, 2, 9], reverse = True)[0:2]
[9, 5]
>>> sorted([81, 52, 45, 10, 3, 2, 96] , reverse = True)[0:3]
[96, 81, 52]
```
```q
q)2#desc 4 5 1 2 9
9 5
q)3#desc 81 52 45 10 3 2 96
96 81 52
```


## [Even numbers from a list](https://www.geeksforgeeks.org/python-program-to-print-even-numbers-in-a-list/)

```python
>>> [num for num in [2, 7, 5, 64, 14] if num % 2 == 0]
[2, 64, 14]
```
```q
q){x where 0=x mod 2} 2 7 5 64 14
2 64 14
```


## [Odd numbers in a range](https://www.geeksforgeeks.org/python-program-to-print-all-odd-numbers-in-a-range/)

```python
>>> [num for num in range(4,15) if num % 2]
[5, 7, 9, 11, 13]
```
```q
q)range:{x+til y-x-1}
q){x where x mod 2} range[4;15]
5 7 9 11 13 15
```


## [Count even and odd numbers in a list](https://www.geeksforgeeks.org/python-program-to-count-even-and-odd-numbers-in-a-list/)

```python
>>> lst = [10, 21, 4, 45, 66, 93, 11]

>>> odd = sum([num % 2 for num in lst])
>>> [len(lst)-odd, odd]
[3, 4]
```
```q
q)lst: 10 21 4 45 66 93 11

q)odd:sum lst mod 2
q)(count[lst]-odd),odd
3 4
```


## [Positive items of a list](https://www.geeksforgeeks.org/python-program-to-print-positive-numbers-in-a-list/)

```python
>>> [num for num in [12, -7, 5, 64, -14] if num>0]
[12, 5, 64]
```
```q
q){x where x>0} 12 -7 5 64 -14
12 5 64
```


## [Remove multiple items from a list](https://www.geeksforgeeks.org/remove-multiple-elements-from-a-list-in-python/)

The examples given in the linked page show two problems. 
The first is to remove from one list all items that are also items of another.

```python
>>> [item for item in [12, 15, 3, 10] if not item in [12, 3]]
[15, 10]
```

```q
q)12 15 3 10 except 12 3
15 10
```

The second is to remove items from a range of indexes.

```python
def removeRange(lst, bgn, end):
    del lst[bgn:end]
    return lst
```
```python
>>> removeRange([11, 5, 17, 18, 23, 50], 1, 5)
[11, 50]
```
```q
range:{x+til y-x-1}
removeRange:{x(til count x)except range[y;z-1]}
```

<big>:fontawesome-regular-comment:</big>
`til count x` gives all the indexes of x. (So `x til count x` is always `x`.)

```q
q)removeRange[11 5 17 18 23 50;1;5]
11 50
```


## [Remove empty tuples from a list](https://www.geeksforgeeks.org/python-remove-empty-tuples-list/)

```python
>>> tuples = [(), ('ram','15','8'), (), ('laxman', 'sita'), ('krishna', 'akbar', '45'), 
        ('', ''), ()]

>>> [t for t in tuples if t]
[('ram', '15', '8'), ('laxman', 'sita'), ('krishna', 'akbar', '45'), ('', '')]
```
```q
q)tuples:(();("ram";"15";"8");();("laxman";"sita");("krishna";"akbar";"45");("";"");())

q)tuples where 0<count each tuples
("ram";"15";"8")
("laxman";"sita")
("krishna";"akbar";"45")
("";"")
```


## [Duplicates from a list of integers](https://www.geeksforgeeks.org/python-program-print-duplicates-list-integers/)

```python
>>> lst = [10, 20, 30, 20, 20, 30, 40, 50, -20, 60, 60, -20, -20]

>>> frq = [lst.count(itm) for itm in lst]
>>> itms = dict(list(zip(lst,frq))).items()
>>> [itm[0] for itm in itms if itm[1]>1]
[20, 30, -20, 60]
```
```q
q)lst: 10 20 30 20 20 30 40 50 -20 60 60 -20 -20

q)where 1<count each group lst
20 30 -20 60
```

<big>:fontawesome-regular-comment:</big>
The q solution follows the Python: `group` returns a dictionary. Its keys are the unique values of the list, its values the indexes where they appear.

```q
q)group 10 20 30 20 20 30 40 50 -20 60 60 -20 -20
10 | ,0
20 | 1 3 4
30 | 2 5
40 | ,6
50 | ,7
-20| 8 11 12
60 | 9 10
```

`count each` replaces the values with their lengths; then `1<` with flags. 

```q
q)1<count each group 10 20 30 20 20 30 40 50 -20 60 60 -20 -20
10 | 0
20 | 1
30 | 1
40 | 0
50 | 0
-20| 1
60 | 1
```

Finally, `where`, applied to a dictionary of flags, returns the flagged indexes (keys).


## [Cumulative sum of a list](https://www.geeksforgeeks.org/python-program-to-find-cumulative-sum-of-a-list/)

```python
>>> import numpy as np
>>> np.cumsum([10, 20, 30, 40, 50])
array([ 10,  30,  60, 100, 150])
```
```q
q)sums 10 20 30 40 50
10 30 60 100 150
```


## [Break a list into chunks of size N](https://www.geeksforgeeks.org/break-list-chunks-size-n-python/)

```python
>>> lst = ['geeks','for','geeks','like','geeky','nerdy','geek','love','questions','words','life']

>>> n = 4
>>> [lst[i * n:(i + 1) * n] for i in range((len(lst) + n - 1) // n )]
[['geeks', 'for', 'geeks', 'like'], ['geeky', 'nerdy', 'geek', 'love'], ['questions', 'words', 'life']]
```
Q has a keyword for this.

```q
q)lst:("geeks";"for";"geeks";"like";"geeky";"nerdy";"geek")
q)lst,:("love";"questions";"words";"life")

q)4 cut lst
("geeks";"for";"geeks";"like")
("geeky";"nerdy";"geek";"love")
("questions";"words";"life")
```


## [Sort values of one list by values of another](https://www.geeksforgeeks.org/python-sort-values-first-list-using-second-list/)

```python
>>> list1 = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
>>> list2 = [ 0,   1,   1,    0,   1,   2,   2,   0,   1]

>>> [x for _, x in sorted(zip(list2,list1))]
['a', 'd', 'h', 'b', 'c', 'e', 'i', 'f', 'g']
```
```q
q)l1:"abcdefghi"
q)l2:0 1 1 0 1 2 2 0 1

q)l1 iasc l2
"adhbceifg"
```

<big>:fontawesome-regular-comment:</big>
Keyword `iasc` grades a list, returning the indexes that would put it in ascending order. 

But the list lengths must match:

```q
q)l3:"geeksforgeeks"
q)l4:0 1 10 1 2 2 0 1

q)(count[l4]#l3)iasc l4
"gkreesgfo"
```


## [Remove empty list from list](https://www.geeksforgeeks.org/python-remove-empty-list-from-list/)

```python
>>> lst = [5, 6, [], 3, [], [], 9]
>>> [itm for itm in lst if itm != []]
[5, 6, 3, 9]
```
```q
q)lst: (5; 6; (); 3; (); (); 9)
q)lst where not lst~\:()
5 6 3 9
```


## [Incremental range initialization in matrix](https://www.geeksforgeeks.org/python-incremental-range-initialization-in-matrix/)

```python
>>> r, c, rang = [4, 3, 5]
>>> [[rang * c * y + rang * x for x in range(c)] for y in range(r)]
[[0, 5, 10], [15, 20, 25], [30, 35, 40], [45, 50, 55]]
```
```q
q)rc:4 3; rang:5
q)rang*rc#til prd rc
0  5  10
15 20 25
30 35 40
45 50 55
```

<big>:fontawesome-regular-comment:</big>
The product of `4 3` is 12. `til` gives us the first 12 integers and `4 3#` arranges them as a 4×3 matrix. It remains only to multiply by 5.


## [Occurrence counter in list of records](https://www.geeksforgeeks.org/python-occurrence-counter-in-list-of-records/)

```python
>>> from collections import Counter
>>> lst = [('Gfg',1),('Gfg',2),('Gfg',3),('Gfg',1),('Gfg',2),('is',1),('is',2)]

>>> res = {}
>>> for key,val in lst:
...     res[key] = [val] if key not in res else res[key] + [val]
...
>>> {key: dict(Counter(val)) for key, val in res.items()}
{'Gfg': {1: 2, 2: 2, 3: 1}, 'is': {1: 1, 2: 1}}
```
```q
q)lst:((`Gfg;1); (`Gfg;2); (`Gfg;3); (`Gfg;1); (`Gfg;2); (`is;1); (`is;2))

q){key[g]!(count'')group each y value g:group x}. flip lst
Gfg| 1 2 3!2 2 1
is | 1 2!1 1
```

<big>:fontawesome-regular-comment:</big>
Flipping the list produces two lists: symbols and integers. 

```q
q)flip lst
Gfg Gfg Gfg Gfg Gfg is is
1   2   3   1   2   1  2
```

Passed by Apply (`.`), they appear in the lambda as `x` and `y` respectively. 
Grouping the symbols returns a dictionary. Its values are lists of indexes into `lst`.

```q
q){[x;y]group x}. flip lst
Gfg| 0 1 2 3 4
is | 5 6
```

Applying `y` (the list of integers) to these indexes gives us two lists of integers.

```q
q){y value group x}. flip lst
1 2 3 1 2
1 2
```

We use `(count'')group each` to get a frequency-count dictionary for each list.

```q
q){(count'')group each y value group x}. flip lst
1 2 3!2 2 1
1 2!1 1
```

It remains only to compose them as the values in a dictionary with the symbols as keys.


## [Group similar value list to dictionary](https://www.geeksforgeeks.org/python-group-similar-value-list-to-dictionary/)

```python
>>> l1 = [4, 4, 4, 5, 5, 6, 6, 6, 6]
>>> l2 = ['G', 'f', 'g', 'i', 's', 'b', 'e', 's', 't']

>>> {key : [l2[idx]
...     for idx in range(len(l2)) if l1[idx]== key]
...     for key in set(l1)}
{4: ['G', 'f', 'g'], 5: ['i', 's'], 6: ['b', 'e', 's', 't']}
```
```q
q)l1:4 4 4 5 5 6 6 6 6
q)l2:"Gfgisbest"

q)l2 group l1
4| "Gfg"
5| "is"
6| "best"
```

<big>:fontawesome-regular-comment:</big>
See [Duplicates from a list of integers](#duplicates-from-a-list-of-integers) for how `group` works.


## [Reverse sort matrix row by Kth column](https://www.geeksforgeeks.org/python-reverse-sort-matrix-row-by-kth-column/)

```python
>>> lst = [['Manjeet', 65], ['Akshat', 42], ['Akash', 38], ['Nikhil', 192]]

>>> sorted(lst, key = lambda ele: ele[1], reverse = True)
[['Nikhil', 192], ['Manjeet', 65], ['Akshat', 42], ['Akash', 38]]
```
```q
q)lst:((`Manjeet;65); (`Akshat;42); (`Akash;38); (`Nikhil;192))

q)lst idesc lst[;1]
`Nikhil  192
`Manjeet 65
`Akshat  42
`Akash   38
```

<big>:fontawesome-regular-comment:</big>
`lst` is a list of tuples, so `lst[;1]` is a list of the second element of each tuple.

```q
q)lst[;1]
65 42 38 192
```

`idesc` grades a list: returns the indexes that would put it into sorted order.

```q
q)idesc lst[;1]
3 0 1 2
```


## [Remove record if Nth column is K](https://www.geeksforgeeks.org/python-remove-record-if-nth-column-is-k/)

```python
>>> lst = [(5, 7), (6, 7, 8), (7, 8, 10), (7, 1)]

>>> [itm for itm in lst if itm[1] != 7]
[(7, 8, 10), (7, 1)]
```
```q
q)lst:((5 7); (6 7 8); (7 8 10); (7 1))

q)lst where lst[;1]<>7
7 8 10
7 1
```


## [Pairs with sum equal to K in tuple list](https://www.geeksforgeeks.org/python-pairs-with-sum-equal-to-k-in-tuple-list/)

```python
>>> prs = [(4, 5), (6, 7), (3, 6), (1, 2), (1, 8)]

>>> [pr for pr in prs if 9 == sum(pr)]
[(4, 5), (3, 6), (1, 8)]
```
```q
q)prs:((4 5); (6 7); (3 6); (1 2); (1 8))

q)prs where 9 = sum each prs
4 5
3 6
1 8
```


## [Merge consecutive empty strings](https://www.geeksforgeeks.org/python-merge-consecutive-empty-strings/)

```python
>>> lst = ['Gfg', '', '', '', 'is', '', '', 'best', '']

>>> [lst[i] for i in range(0, len(lst)-1) if (i==0)or(len(lst[i])>0)or(len(lst[i-1])>0)]
['Gfg', '', 'is', '', 'best']
```
```q
q)lst:("Gfg"; ""; ""; ""; "is"; ""; ""; "best")

q)lst where not(and)prior(count each lst)=0
"Gfg"
""
"is"
""
"best"
```

<big>:fontawesome-regular-comment:</big>
`(count each lst)=0` flags the empty strings. 
`(and)prior` flags empty strings preceded by another empty string.

A more efficient Python solution would also count the string lengths once only.

```python
>>> r = range(0, len(lst)-1)
>>> flags = [len(lst[i])>0 for i in r]
>>> [lst[i] for i in r if (i==0) or flags[i] or flags [i-1]]
['Gfg', '', 'is', '', 'best']
```


## [Numeric sort in mixed-pair string list](https://www.geeksforgeeks.org/python-numeric-sort-in-mixed-pair-string-list/)

```python
>>> lst = ["Manjeet 5", "Akshat 7", "Akash 6", "Nikhil 10"]

>>> sorted(lst, reverse = True, key = lambda ele: int(ele.split()[1]))
['Nikhil 10', 'Akshat 7', 'Akash 6', 'Manjeet 5']
```
```q
q)lst:("Manjeet 5";"Akshat 7"; "Akash 6"; "Nikhil 10")

q)lst idesc first(" I";" ")0: lst
"Nikhil 10"
"Akshat 7"
"Akash 6"
"Manjeet 5"
```

<big>:fontawesome-regular-comment:</big>
This form of the [File Text](../../../ref/file-text.md#load-csv) operator `0:` interprets delimited character strings, most commonly from CSVs. 


## [First even number in list](https://www.geeksforgeeks.org/python-first-even-number-in-list/)

```python
def firstEven(lst):
    for ele in lst:
        if not ele % 2:
            return ele
```
```python
>>> lst = [43, 9, 6, 72, 8, 11]
>>> firstEven(lst)
6
```
```q
q)lst:43 9 6 72 8 11
q)first lst where 0 = lst mod 2
6
```

<big>:fontawesome-regular-comment:</big>
The naïve q solution computes the modulo of each item in the list. 
This may be all right for a short list, but a long list wants an algorithm that stops at an even number.

Start with a lambda: `{lst[y],1+y}`. 
The reference to `y` tells us it is a binary function, with default argument names `x` and `y`. 
There is no reference to `x` so we know its result depends only on its second argument, `y`.
In fact, it returns another pair: the value of `lst` at `y`, and the next index, `y+1`. 
Projecting [Apply](../../../ref/apply.md) onto the lambda gives us a unary function that takes a pair as its argument.

```q
q) .[{lst[y],1+y};] 1 0
43 1
```

Using the [Do form of the Scan](../../../ref/accumulators.md#do) iterator to apply it twice

```q
q)2 .[{lst[y],1+y};]\1 0
1  0
43 1
9  2
```

we see the initial state (`1 0`) followed by the first two items of `lst` paired with their (origin-1) indexes.

The Do form of the iterator uses an integer to specify the number of iterations. In the [While form of the iterator](../../../ref/accumulators.md#while), we replace the integer with a test function. Iteration continues until the test function returns zero. 

```q
q){first[x]mod 2} .[{lst[y],1+y};]\1 0
1  0
43 1
9  2
6  3
```

The Over iterator performs the same computation as Scan, but returns only the last pair. From which we select the first item.

```q
q)first{first[x]mod 2} .[{lst[y],1+y};]/1 0
6
```


## [Storing elements greater than K as dictionary](https://www.geeksforgeeks.org/python-storing-elements-greater-than-k-as-dictionary/)

```python
>>> lst = [12, 44, 56, 34, 67, 98, 34]

>>> {idx: ele for idx, ele in enumerate(lst) if ele > 50}
{2: 56, 4: 67, 5: 98}
```
```q
q)lst: 12 44 56 34 67 98 34

q){i!x i:where x>50} lst
2| 56
4| 67
5| 98
```


## [Remove duplicate words from strings in list](https://www.geeksforgeeks.org/python-remove-duplicate-words-from-strings-in-list/)

```python
lst = ['gfg, best, gfg', 'I, am, I', 'two, two, three' ]

>>> [set(strs.split(", ")) for strs in lst]
[{'best', 'gfg'}, {'I', 'am'}, {'three', 'two'}]
```
```q
q)lst:("gfg, best, gfg"; "I, am, I"; "two, two, three")

q){distinct", "vs x}each lst
"gfg" "best"
,"I"  "am"
"two" "three"
```

<big>:fontawesome-regular-comment:</big>
`", "vs` splits a string by the delimiter `", "`; `distinct` returns the unique items of a list; `each` applies the lambda to each string.


## [Difference of list keeping duplicates](https://www.geeksforgeeks.org/python-difference-of-list-keeping-duplicates/)

```python
>>> L1 = [4, 5, 7, 4, 3]
>>> L2 = [7, 3, 4]

>>> [L1.pop(L1.index(idx)) for idx in L2]
>>> L1
[5, 4]
```
```q
q)L1: 4 5 7 4 3
q)L2: 7 3 4
q)L1 (til count L1) except L1?L2
5 4
```

<big>:fontawesome-regular-comment:</big>
`til count L1` returns all the indexes of `L1`. (So `L1 til count L1` would match `L1`.) `L1?L2` finds the first occurrences of the items of `L2` in `L1`, which get removed from the list of indexes of `L1.
`

## [Pairs with multiple similar values in dictionary](https://www.geeksforgeeks.org/python-pairs-with-multiple-similar-values-in-dictionary/)

```python
>>> lst = [{'Gfg' : 1, 'is' : 2}, {'Gfg' : 2, 'is' : 2}, {'Gfg' : 1, 'is' : 2}]

>>> [sub for sub in lst if len([ele for ele in lst if ele['Gfg'] == sub['Gfg']]) > 1]
[{'Gfg': 1, 'is': 2}, {'Gfg': 1, 'is': 2}]
```
```q
q)lst: ((`Gfg`is!1 2); (`Gfg`is!2 2); (`Gfg`is!1 2))

q)lst where lst in lst where (lst?lst)<>til count lst
Gfg is
------
1   2
1   2
```

<big>:fontawesome-regular-comment:</big>
`(x?x)<>til count x` flags the duplicate items of `x`. 
The complete expression returns them.

In q, a list of dictionaries with the same keys is a table.


## [Identify election winner](https://www.geeksforgeeks.org/dictionary-counter-python-find-winner-election/)

```python
>>> votes = ['john','johnny','jackie','johnny','john','jackie','jamie','jamie',
... 'john','johnny','jamie','johnny','john']

>>> from collections import Counter
>>> c = Counter(votes)
>>> m = max(c.values())
>>> winners = [n for n, v in c.items() if v == m]
>>> sorted([[n, len(n)] for n in winners], reverse=True)[0][0]
'johnny'
```

```q
q)votes:`john`johnny`jackie`johnny`john`jackie`jamie`jamie`john`johnny`jamie`johnny`john

q)ce:count each
q)first {x idesc ce x} where {x=max x} ce group string votes
"johnny"
```

<big>:fontawesome-regular-comment:</big>
The q solution follows the same strategy as the Python.
We group the votes by candidate and count them.

```q
q)ce group string votes
"john"  | 4
"johnny"| 4
"jackie"| 2
"jamie" | 3
```

Then `where {x=max x}` selects the keys with the maximum value.

```q
q)where {x=max x} ce group string votes
"john"
"johnny"
```

It remains only to sort the winners’ names in descending order of length and select the first.


## [Group anagrams](https://www.geeksforgeeks.org/print-anagrams-together-python-using-list-dictionary/)

```python
>>> s = 'cat dog tac god act'

>>> w = s.split(' ')
>>> a = [''.join(sorted(wrd)) for wrd in w]
>>> ' '.join([y for x,y in sorted(zip(a, w))])
'act cat tac dog god'
```
```q
q)s:"cat dog tac god act"

q)" " sv {x iasc asc each x} " " vs s
"cat tac act dog god"
```

<big>:fontawesome-regular-comment:</big>
In Python, `[y for x,y in sorted(zip(a, w))]` sorts the words by their alphabetized versions. In q, `{x iasc asc each x}` does it. In both solutions the rest of the code splits and reforms the input and output strings. 

The Python sort returns the anagrams in alpha order in each group. 
To achieve the same in q, suffix each alphabetized word with the original:

```q
q)" " sv {x iasc {asc[x],x} each x}" " vs s
"act cat tac dog god"
```


## [Size of largest subset of anagrams](https://www.geeksforgeeks.org/python-counter-find-size-largest-subset-anagram-words/)

```python
>>> words = ["ant", "magenta", "magnate", "tan", "gnamate"]

>>> from collections import Counter
>>> max(Counter([''.join(sorted(w)) for w in words]).values())
3
```
```q
q)words:string `ant`magenta`magnate`tan`gnamate

q)max count each group asc each words
3
```

<big>:fontawesome-regular-comment:</big>
The q solution implements the Python method. 
Sort each string: anagrams match. 

```q
q)asc each words
`s#"ant"
`s#"aaegmnt"
`s#"aaegmnt"
`s#"ant"
`s#"aaegmnt"
```

Group for a frequency count and find the maximum value.


---
:fontawesome-regular-hand-point-right:
[String examples](string.md)