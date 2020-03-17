---
title: Q versions of Python programming examples| Documentation for kdb+ and q
description: Python programming examples and their q equivalents
author: Stephen Taylor
date: March 2020
hero: <i class="fab fa-python"></i> Python programming examples in q
---
# List programs

From
<i class="fas fa-globe"></i>
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and the Python solution/s.


## [Interchange first and last elements in a list](https://www.geeksforgeeks.org/python-program-to-interchange-first-and-last-elements-in-a-list/)

```python
# Python3 program to swap first
# and last element of a list

# Swap function
def swapList(newList):

    newList[0], newList[-1] = newList[-1], newList[0]

    return newList

# Driver code
newList = [12, 35, 9, 56, 24]
print(swapList(newList))
```

`-1` is not an index in q, so we need the end index: `count[x]-1`.
Once we have that, functional [Amend](../../ref/amend.md) lets us specify the list, the indexes to amend, the function to apply (in this case Assign `:`) and the replacement values. Functional Amend allows us to modify lists without making a new copy – efficient for long ists.

```q
q){e:count[x]-1; @[x;0,e;:;x e,0]} 12 35 9 56 24
24 35 9 56 12
```


## [Swap two items in a list](https://www.geeksforgeeks.org/python-program-to-swap-two-elements-in-a-list/)

```python
# Python3 program to swap elements
# at given positions

# Swap function
def swapPositions(list, pos1, pos2):

    list[pos1], list[pos2] = list[pos2], list[pos1]
    return list

# Driver function
List = [23, 65, 19, 90]
pos1, pos2 = 1, 3

print(swapPositions(List, pos1-1, pos2-1))
```
```q
q){@[x;y,z;:;x z,y]}[23 65 19 90;1;3]
23 90 19 65
```


## [Remove Nth occurrence of the given word](https://www.geeksforgeeks.org/python-program-to-remove-nth-occurrence-of-the-given-word/)

```python
# Python3 program to remove Nth
# occurrence of the given word

# Function to remove Ith word
def RemoveIthWord(lst, word, N):
    newList = []
    count = 0

    # iterate the elements
    for i in lst:
        if(i == word):
            count = count + 1
            if(count != N):
                newList.append(i)
        else:
            newList.append(i)

    lst = newList

    if count == 0:
        print("Item not found")
    else:
        print("Updated list is: ", lst)

    return newList

# Driver code
list = ["geeks", "for", "geeks"]
word = "geeks"
N = 2

RemoveIthWord(list, word, N)
```

`til count x` returns all the indexes of list `x`. (So `x til count x` is always `x`.)

`lst~\:wrd` flags the items of `lst` that match `wrd`.
We just need to find where the `i`th flag occurs and omit it from the indexes.

```q
q)RemoveIthWord:{[lst;wrd;i]lst til[count lst] except sums[lst~\:wrd]?i}

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


## [If item exists in a list](https://www.geeksforgeeks.org/python-ways-to-check-if-element-exists-in-list/)

```python
# Python code to demonstrate
# checking of element existence
# using set() + in
# using sort() + bisect_left()
from bisect import bisect_left

# Initializing list
test_list_set = [ 1, 6, 3, 5, 3, 4 ]
test_list_bisect = [ 1, 6, 3, 5, 3, 4 ]

print("Checking if 4 exists in list ( using set() + in) : ")

# Checking if 4 exists in list
# using set() + in
test_list_set = set(test_list_set)
if 4 in test_list_set :
    print ("Element Exists")

print("Checking if 4 exists in list ( using sort() + bisect_left() ) : ")

# Checking if 4 exists in list
# using sort() + bisect_left()
test_list_bisect.sort()
if bisect_left(test_list_bisect, 4):
    print ("Element Exists")
```

Q is a vector programming language. It has a primitive for this.

```q
q)list: 1 6 3 5 3 4
q)4 in list
1b
```


## [Clear a list](https://www.geeksforgeeks.org/different-ways-to-clear-a-list-in-python/)

```python
# Python3 code to demonstrate
# clearing a list using
# del method

# Initializing lists
list1 = [1, 2, 3]
list2 = [5, 6, 7]

# Printing list1 before deleting
print ("List1 before deleting is : " + str(list1))

# deleting list1 using del
del list1[:]
print ("List1 after clearing using del : " + str(list1))


# Printing list2 before deleting
print ("List2 before deleting is : " + str(list2))

# deleting list using del
del list2[:]
print ("List2 after clearing using del : " + str(list2))
```

Clearing a list means removing all its items while retaining its datatype. 
[`0#`](../../ref/take.md) is perfect for this. 

```q
q)list:1 2 3  / initialize list
q)0#list      / take 0 items
q)
```


## [Reverse a list](https://www.geeksforgeeks.org/python-reversing-list/)

```python
# Reversing a list using reversed()
def Reverse(lst):
    return [ele for ele in reversed(lst)]

# Driver Code
lst = [10, 11, 12, 13, 14, 15]
print(Reverse(lst))
```

Q is a vector programming language. It has a primitive for this. 

```q
q)reverse each (10 11 12 13 14 15;4 5 6 7 8 9)
15 14 13 12 11 10
9  8  7  6  5  4
```

The two lists have the same count, and therefore constitute a 2-row matrix. 

<!--
## [Clone or copy a list](https://www.geeksforgeeks.org/python-cloning-copying-list/)

```python
# Python program to copy or clone a list
# Using the Slice Operator
def Cloning(li1):
    li_copy = li1[:]
    return li_copy

# Driver Code
li2 = Cloning(li1)
print("Original List:", li1)
print("After Cloning:", li2)
```
```q
q)show li2:li1:4 8 2 10 15 18
4 8 2 10 15 18
```
-->

## [Count occurrences of an item in a list](https://www.geeksforgeeks.org/python-count-occurrences-element-list/)

```python
# Python code to count the number of occurrences
def countX(lst, x):
    count = 0
    for ele in lst:
        if (ele == x):
            count = count + 1
    return count

# Driver Code
lst = [8, 6, 8, 10, 8, 20, 10, 8, 8]
x = 8
print('{} has occurred {} times'.format(x, countX(lst, x)))
```

Just as you were taught in school, `=` tests equality. Like other q operators, iteration is implicit, so below `8 6 8 10 8 20 10 8 8 = 8` returns a list of flags. Which we sum. Simple. 

```q
q)sum 8 6 8 10 8 20 10 8 8 = 8
5i
```

<!--0
## [Sum of items in a list](https://www.geeksforgeeks.org/python-program-to-find-sum-of-elements-in-list/)

```python
# Python program to find sum of elements in list

# creating a list
list1 = [11, 5, 17, 18, 23]

# using sum() function
total = sum(list1)

# printing total value
print("Sum of all elements in given list: ", total)
```
```q
q)sum 11 5 17 18 23
74
```


## [Multiply all numbers in a list](https://www.geeksforgeeks.org/python-multiply-numbers-list-3-different-ways/)

```python
# Python3 program to multiply all values in the
# list using numpy.prod()

import numpy
list1 = [1, 2, 3]
list2 = [3, 2, 4]

# using numpy.prod() to get the multiplications
result1 = numpy.prod(list1)
result2 = numpy.prod(list2)
print(result1)
print(result2)
```
```q
q)prd each (1 2 3;3 2 4)
6 24
```


## [Find smallest number in a list](https://www.geeksforgeeks.org/python-program-to-find-smallest-number-in-a-list/)

```python
# Python program to find smallest
# number in a list

# list of numbers
list1 = [10, 20, 1, 45, 99]


# printing the maximum element
print("Smallest element is:", min(list1))
```
```q
q)min 10 20 1 45 99
1
```


## [Find largest number in a list](https://www.geeksforgeeks.org/python-program-to-find-largest-number-in-a-list/)

```python
# Python program to find largest
# number in a list

# list of numbers
list1 = [10, 20, 4, 45, 99]


# printing the maximum element
print("Largest element is:", max(list1))

```
```q
q)max 10 20 4 45 99
99
```
-->

## [Second-largest number in a list](https://www.geeksforgeeks.org/python-program-to-find-second-largest-number-in-a-list/)

```python
# Python program to find largest
# number in a list

# list of numbers
list1 = [10, 20, 4, 45, 99]

# sorting the list
list1.sort()

# printing the second last element
print("Second largest element is:", list1[-2])
```
```q
q)(desc 10 20 4 45 99)1
45
```


## [N largest items from a list](https://www.geeksforgeeks.org/python-program-to-find-n-largest-elements-from-a-list/)

```python
# Python program to find N largest
# element from given list of integers

# Function returns N largest elements
def Nmaxelements(list1, N):
    final_list = []

    for i in range(0, N):
        max1 = 0

        for j in range(len(list1)):
            if list1[j] > max1:
                max1 = list1[j];

        list1.remove(max1);
        final_list.append(max1)

    print(final_list)

# Driver code
list1 = [2, 6, 41, 85, 0, 3, 7, 6, 10]
N = 2

# Calling the function
Nmaxelements(list1, N)
```
```q
q)2#desc 4 5 1 2 9
9 5
q)3#desc 81 52 45 10 3 2 96
96 81 52
```


## [Even numbers from a list](https://www.geeksforgeeks.org/python-program-to-print-even-numbers-in-a-list/)

```python
# Python program to print Even Numbers in a List

# list of numbers
list1 = [10, 21, 4, 45, 66, 93, 11]


# we can also print even no's using lambda exp.
even_nos = list(filter(lambda x: (x % 2 == 0), list1))

print("Even numbers in the list: ", even_nos)
```
```q
q){x where 0=x mod 2}10 21 4 45 66 93 11
10 4 66
```


<!--
## [Odd numbers from a list](https://www.geeksforgeeks.org/python-program-to-print-odd-numbers-in-a-list/)

```python
# Python program to print odd Numbers in a List

# list of numbers
list1 = [10, 21, 4, 45, 66, 93]

only_odd = [num for num in list1 if num % 2 == 1]

print(only_odd)
```
```q
q){x where x mod 2}10 21 4 45 66 93 11
21 45 93 11
```

## [All even numbers in a range](https://www.geeksforgeeks.org/python-program-to-print-all-even-numbers-in-a-range/)

```python
# Python program to print Even Numbers in given range

start, end = 4, 19

# iterating each number in list
for num in range(start, end + 1):

    # checking condition
    if num % 2 == 0:
        print(num, end = " ")

```
```q
q)rg:{x+til y-x-1}          / range
q){x where not x mod 2}rg[4;15]
4 6 8 10 12 14
q){x where not x mod 2}rg[8;11]
8 10
```
-->


## [Odd numbers in a range](https://www.geeksforgeeks.org/python-program-to-print-all-odd-numbers-in-a-range/)

```python
# Python program to print odd Numbers in given range

start, end = 4, 19

# iterating each number in list
for num in range(start, end + 1):

    # checking condition
    if num % 2 != 0:
        print(num, end = " ")
```
```q
q)rg:{x+til y-x-1}          / range
q){x where x mod 2}rg[4;15]
5 7 9 11 13 15
q){x where x mod 2}rg[3;11]
3 5 7 9 11
```


## [Count even and odd numbers in a list](https://www.geeksforgeeks.org/python-program-to-count-even-and-odd-numbers-in-a-list/)

```python
# Python program to print odd Numbers in a List

# list of numbers
list1 = [10, 21, 4, 45, 66, 93, 11]

only_odd = [num for num in list1 if num % 2 == 1]
odd_count = len(only_odd)

print("Even numbers in the list: ", len(list1) - odd_count)
print("Odd numbers in the list: ", odd_count)
```
```q
q){o,count[x]-o:sum x mod 2}10 21 4 45 66 93 11
4 3
```


## [Positive items of a list](https://www.geeksforgeeks.org/python-program-to-print-positive-numbers-in-a-list/)

```python
# Python program to print Positive Numbers in a List

# list of numbers
list1 = [-10, -21, -4, 45, -66, 93]

# using list comprehension
pos_nos = [num for num in list1 if num >= 0]

print("Positive numbers in the list: ", *pos_nos)
```
```q
q){x where x>0} 12 -7 5 64 -14
12 5 64
q){x where x>0} 12 14 -95 3
12 14 3
```


<!--
## [Negative numbers from a list](https://www.geeksforgeeks.org/python-program-to-print-negative-numbers-in-a-list/)

```python
# Python program to print negative Numbers in a List

# list of numbers
list1 = [-10, -21, -4, 45, -66, 93]

# using list comprehension
neg_nos = [num for num in list1 if num < 0]

print("Negative numbers in the list: ", *neg_nos)
```
```q
q){x where x<0} 12 -7 5 64 -14
-7 -14
q){x where x<0} 12 14 -95 3
,-95
```


## [Positive numbers in a range](https://www.geeksforgeeks.org/python-program-to-print-all-positive-numbers-in-a-range/)

```python
# Python program to print positive Numbers in given range

start, end = -4, 19

# iterating each number in list
for num in range(start, end + 1):

    # checking condition
    if num >= 0:
        print(num, end = " ")
```
```q
q)rg:{x+til y-x-1}          / range
q){x where x>=0}rg[-4;5]
0 1 2 3 4 5
q){x where x>=0}rg[-3;4]
0 1 2 3 4
```


## [Negative numbers in a range](https://www.geeksforgeeks.org/python-program-to-print-all-negative-numbers-in-a-range/)

```python
# Python program to print negative Numbers in given range

start, end = -4, 19

# iterating each number in list
for num in range(start, end + 1):

    # checking condition
    if num < 0:
        print(num, end = " ")

```
```q
q)rg:{x+til y-x-1}          / range
q){x where x<0}rg[-4;5]
-4 -3 -2 -1
q){x where x<0}rg[-3;4]
-3 -2 -1
```


## [Count positive and negative numbers in a list](https://www.geeksforgeeks.org/python-program-to-count-positive-and-negative-numbers-in-a-list/)

```python
# Python program to count positive and negative numbers in a List

# list of numbers
list1 = [10, -21, 4, -45, 66, -93, 1]

pos_count, neg_count = 0, 0

# iterating each number in list
for num in list1:

    # checking condition
    if num >= 0:
        pos_count += 1

    else:
        neg_count += 1

print("Positive numbers in the list: ", pos_count)
print("Negative numbers in the list: ", neg_count)
```
```q
q){p,count[x]-p:"j"$sum x>=0}2 -7 5 -64 -14
2 3
q){p,count[x]-p:"j"$sum x>=0} -12 14 95 3
3 1
```
-->

## [Remove multiple items from a list](https://www.geeksforgeeks.org/remove-multiple-elements-from-a-list-in-python/)

```python
# Python program to remove multiple
# elements from a list

# creating a list
list1 = [11, 5, 17, 18, 23, 50]

# removes elements from index 1 to 4
# i.e. 5, 17, 18, 23 will be deleted
del list1[1:5]

print(*list1)
```

The examples given in the linked page show two problems. 
The first is to remove from one list all items that are also items of another.

```q
q)12 15 3 10 except 12 3
15 10
```

The second is to remove items from a range of indexes.

```q
q)rg:{x+til y-x-1}          / range
q){x til[count x]except rg[y+1;z]-1}[11 5 17 18 23 50;1;5]
11 50
```


## [Remove empty tuples from a list](https://www.geeksforgeeks.org/python-remove-empty-tuples-list/)

```python
# Python program to remove empty tuples from a
# list of tuples function to remove empty tuples
# using list comprehension
def Remove(tuples):
    tuples = [t for t in tuples if t]
    return tuples

# Driver Code
tuples = [(), ('ram','15','8'), (), ('laxman', 'sita'),
        ('krishna', 'akbar', '45'), ('',''),()]
print(Remove(tuples))
```
```q
q)Remove:{x where(count each x)>0}
q)lst1:(();("ram";"15";"8");();("laxman";"sita");("krishna";"akbar";"45");("";"");())
q)lst2:(("";"";"8");("0";"00";"000");("birbal";"";"45");("";""))

q)Remove lst1
("ram";"15";"8")
("laxman";"sita")
("krishna";"akbar";"45")
("";"")

q)Remove lst2
("";"";"8")
("0";"00";"000")
("birbal";"";"45")
("";"")
("";"")
```


## [Duplicates from a list of integers](https://www.geeksforgeeks.org/python-program-print-duplicates-list-integers/)

```python
# Python program to print
# duplicates from a list
# of integers
def Repeat(x):
    _size = len(x)
    repeated = []
    for i in range(_size):
        k = i + 1
        for j in range(k, _size):
            if x[i] == x[j] and x[i] not in repeated:
                repeated.append(x[i])
    return repeated

# Driver Code
list1 = [10, 20, 30, 20, 20, 30, 40,
        50, -20, 60, 60, -20, -20]
print (Repeat(list1))

# This code is contributed
# by Sandeep_anand
```
```q
q){key[x]where(value x)>1}count each group 10 20 30 20 20 30 40 50 -20 60 60 -20 -20
20 30 -20 60
q){key[x]where(value x)>1}count each group -1 1 -1 8
,-1
```


## [Cumulative sum of a list](https://www.geeksforgeeks.org/python-program-to-find-cumulative-sum-of-a-list/)

```python
# Python code to get the Cumulative sum of a list
def Cumulative(lists):
    cu_list = []
    length = len(lists)
    cu_list = [sum(lists[0 + 1]) for x in range(0, length)]
    return cu_list

# Driver Code
lists = [10, 20, 30, 40, 50]
print (Cumulative(lists))
```

Q is a vector programming language. It has a keyword for cumulative sums.

```q
q)sums each (10 20 30 40 50; 4 10 15 18 20)
10 30 60 100 150
4  14 29 47  67
```


## [Break a list into chunks of size N](https://www.geeksforgeeks.org/break-list-chunks-size-n-python/)

```python
my_list = [1, 2, 3, 4, 5,
            6, 7, 8, 9]

# How many elements each
# list should have
n = 4

# using list comprehension
final = [my_list[i * n:(i + 1) * n] for i in range((len(my_list) + n - 1) // n )]
print (final)
```
Q is a vector programming language. It has a keyword for this.

```q
q)L:("geeks";"for";"geeks";"like";"geeky";"nerdy";"geek";"love";"questions";"words";"life")
q)5 cut L
("geeks";"for";"geeks";"like";"geeky")
("nerdy";"geek";"love";"questions";"words")
,"life"
```


## [Sort values of one list by values of another](https://www.geeksforgeeks.org/python-sort-values-first-list-using-second-list/)

```python
# Python program to sort
# one list using
# the other list

def sort_list(list1, list2):

    zipped_pairs = zip(list2, list1)

    z = [x for _, x in sorted(zipped_pairs)]

    return z


# driver code
x = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
y = [ 0, 1, 1, 0, 1, 2, 2, 0, 1]

print(sort_list(x, y))

x = ["g", "e", "e", "k", "s", "f", "o", "r", "g", "e", "e", "k", "s"]
y = [ 0, 1, 1, 0, 1, 2, 2, 0, 1]

print(sort_list(x, y))
```

Q is a vector programming language. Where the lists have the same count, a q keyword suffices.

```q
q)l1:"abcdefghi"
q)l2:0 1 1 0 1 2 2 0 1
q)l1 iasc l2
"adhbceifg"
```

Where the list counts differ, a little care must be taken.

```q
q)l3:"geeksforgeeks"
q)l4:0 1 10 1 2 2 0 1
q)(count[l4]#l3)iasc l4
"gkreesgfo"
```


<!--
## [Variables from list items](https://www.geeksforgeeks.org/python-construct-variables-of-list-elements/)

```python
# Python3 code to demonstrate
# Construct variables of list elements
# using dict() + zip()

# Initializing lists
test_list1 = ['gfg', 'is', 'best']
test_list2 = [1, 2, 3]

# printing original lists
print("The original list 1 is : " + str(test_list1))
print("The original list 2 is : " + str(test_list2))

# Construct variables of list elements
# using dict() + zip()
res = dict(zip(test_list1, test_list2))

# printing result
print ("Variable value 1 : " + str(res['gfg']))
print ("Variable value 2 : " + str(res['best']))
```
```q
q)d:`gfg`is`best!1 2 3
q)d`gfg`best
1 3
```
-->


## [Remove empty list from list](https://www.geeksforgeeks.org/python-remove-empty-list-from-list/)

```python
# Python3 code to demonstrate
# Remove empty List from List
# using list comprehension

# Initializing list
test_list = [5, 6, [], 3, [], [], 9]

# printing original list
print("The original list is : " + str(test_list))

# Remove empty List from List
# using list comprehension
res = [ele for ele in test_list if ele != []]

# printing result
print ("List after empty list removal : " + str(res))
```
```q
q){x where not x~\:()} (5; 6; (); 3; (); (); 9)
5 6 3 9
```


## [Incremental range initialization in matrix](https://www.geeksforgeeks.org/python-incremental-range-initialization-in-matrix/)

```python
# Python3 code to demonstrate
# Incremental Range Initialization in Matrix
# using list comprehension

# Initializing row
r = 4

# Initializing col
c = 3

# Initializing range
rang = 5

# Incremental Range Initialization in Matrix
# using list comprehension
res = [[rang * c * y + rang * x for x in range(c)] for y in range(r)]

# printing result
print ("Matrix after Initialization : " + str(res))
```
```q
q)5*{x#til prd x}4 3
0  5  10
15 20 25
30 35 40
45 50 55
```


## [Occurrence counter in list of records](https://www.geeksforgeeks.org/python-occurrence-counter-in-list-of-records/)

```python
# Python3 code to demonstrate
# Occurrence counter in List of Records
# using Counter() + loop
from collections import Counter

# Initializing list
test_list = [('Gfg', 1), ('Gfg', 2), ('Gfg', 3), ('Gfg', 1), ('Gfg', 2), ('is', 1), ('is', 2)]

# printing original list
print("The original list is : " + str(test_list))

# Occurrence counter in List of Records
# using Counter() + loop
res = {}
for key, val in test_list:
    res[key] = [val] if key not in res else res[key] + [val]

res = {key: dict(Counter(val)) for key, val in res.items()}

# printing result
print ("Mapped resultant dictionary : " + str(res))
```
```q
q)L:((`Gfg;1); (`Gfg;2); (`Gfg;3); (`Gfg;1); (`Gfg;2); (`is;1); (`is;2))
q){f:where differ x; x[f]!{count each group x}each f _ y}. flip L
Gfg| 1 2 3!2 2 1
is | 1 2!1 1
```


## [Group similar value list to dictionary](https://www.geeksforgeeks.org/python-group-similar-value-list-to-dictionary/)

```python
# Python3 code to demonstrate
# Group similar value list to dictionary
# using dictionary comprehension

# Initializing lists
test_list1 = [4, 4, 4, 5, 5, 6, 6, 6, 6]
test_list2 = ['G', 'f', 'g', 'i', 's', 'b', 'e', 's', 't']

# printing original lists
print("The original list 1 is : " + str(test_list1))
print("The original list 2 is : " + str(test_list2))

# Group similar value list to dictionary
# using dictionary comprehension
res = {key : [test_list2[idx]
    for idx in range(len(test_list2)) if test_list1[idx]== key]
    for key in set(test_list1)}

# printing result
print ("Mapped resultant dictionary : " + str(res))
```
```q
q)l1:4 4 4 5 5 6 6 6 6
q)l2:"Gfgisbest"
q){f:where differ x; x[f]!f cut y}[l1;l2]
4| "Gfg"
5| "is"
6| "best"
```


## [Reverse sort matrix row by Kth column](Reverse sort Matrix Row by Kth Column)

```python
# Python3 code to demonstrate
# Reverse sort Matrix Row by Kth Column
# using sorted() + lambda + reverse()

# Initializing list
test_list = [['Manjeet', 65], ['Akshat', 42], ['Akash', 38], ['Nikhil', 192]]

# printing original lists
print("The original list is : " + str(test_list))

# Initializing K
K = 1

# Reverse sort Matrix Row by Kth Column
# using sorted() + lambda + reverse()
res = sorted(test_list, key = lambda ele: ele[K], reverse = True)

# printing result
print ("List after performing sorting of matrix records : " + str(res))
```
```q
q)L:((`Manjeet;65); (`Akshat;42); (`Akash;38); (`Nikhil;192))
q)L idesc L[;1]
`Nikhil  192
`Manjeet 65
`Akshat  42
`Akash   38
```


## [Remove record if Nth column is K](https://www.geeksforgeeks.org/python-remove-record-if-nth-column-is-k/)

```python
# Python3 code to demonstrate
# Remove Record if Nth Column is K
# using list comprehension

# Initializing list
test_list = [(5, 7), (6, 7, 8), (7, 8, 10), (7, 1)]

# printing original list
print("The original list is : " + str(test_list))

# Initializing K
K = 7

# Initializing N
N = 1

# Remove Record if Nth Column is K
# using list comprehension
res = [sub for sub in test_list if sub[N] != K]

# printing result
print ("List after removal : " + str(res))
```
```q
q)L:((5 7); (6 7 8); (7 8 10); (7 1))
q)L where L[;1]<>7
7 8 10
7 1
```


## [Pairs with sum equal to K in tuple list](https://www.geeksforgeeks.org/python-pairs-with-sum-equal-to-k-in-tuple-list/)

```python
# Python3 code to demonstrate
# Pairs with Sum equal to K in tuple list
# using list comprehension

# Initializing list
test_list = [(4, 5), (6, 7), (3, 6), (1, 2), (1, 8)]

# printing original list
print("The original list is : " + str(test_list))

# Initializing K
K = 9

# Pairs with Sum equal to K in tuple list
# using list comprehension
res = [(ele[0], ele[1]) for ele in test_list if ele[0] + ele[1] == K]

# printing result
print ("List after extracting pairs equal to K : " + str(res))
```
```q
q)L:((4 5); (6 7); (3 6); (1 2); (1 8))
q)L where(sum each L)=9
4 5
3 6
1 8
```


## [Merge consecutive empty strings](https://www.geeksforgeeks.org/python-merge-consecutive-empty-strings/)

```python
# Python3 code to demonstrate
# Merge consecutive empty Strings
# using loop

# Initializing list
test_list = ['Gfg', '', '', '', 'is', '', '', 'best', '']

# printing original list
print("The original list is : " + str(test_list))

# Merge consecutive empty Strings
# using loop
count = 0
res = []
for ele in test_list:
    if ele =='':
        count += 1
        if (count % 2)== 0:
            res.append('')
            count = 0
    else:
        res.append(ele)

# printing result
print ("List after removal of consecutive empty strings : " + str(res))
```
```q
q)L:("Gfg"; ""; ""; ""; "is"; ""; ""; "best")
q)L where not(and)prior""~/:L
"Gfg"
""
"is"
""
"best"
```


## [Numeric sort in mixed pair string list](https://www.geeksforgeeks.org/python-numeric-sort-in-mixed-pair-string-list/)

```python
# Python3 code to demonstrate
# Numeric Sort in Mixed Pair String List
# using split() + sorted() + lambda

# Initializing list
test_list = ["Manjeet 5", "Akshat 7", "Akash 6", "Nikhil 10"]

# printing original list
print("The original list is : " + str(test_list))

# Numeric Sort in Mixed Pair String List
# using split() + sorted() + lambda
res = sorted(test_list, reverse = True, key = lambda ele: int(ele.split()[1]))

# printing result
print ("The reverse sorted numerics are : " + str(res))
```
```q
q)L:("Manjeet 5";"Akshat 7"; "Akash 6"; "Nikhil 10")
q)L idesc first(" I";" ")0:L
"Nikhil 10"
"Akshat 7"
"Akash 6"
"Manjeet 5"
```


## [First even number in list](https://www.geeksforgeeks.org/python-first-even-number-in-list/)

```python
# Python3 code to demonstrate
# First Even Number in List
# using loop

# Initializing list
test_list = [43, 9, 6, 72, 8, 11]

# printing original list
print("The original list is : " + str(test_list))

# First Even Number in List
# using loop
res = None
for ele in test_list:
    if not ele % 2 :
        res = ele
        break

# printing result
print ("The first even element in list is : " + str(res))
```
```q
q){first x where(x mod 2)=0}43 9 6 72 8 11
6
```


## [Storing elements greater than K as dictionary](https://www.geeksforgeeks.org/python-storing-elements-greater-than-k-as-dictionary/)

```python
# Python3 code to demonstrate
# Storing Elements Greater than K as Dictionary
# using dictionary comprehension

# Initializing list
test_list = [12, 44, 56, 34, 67, 98, 34]

# printing original list
print("The original list is : " + str(test_list))

# Initializing K
K = 50

# Storing Elements Greater than K as Dictionary
# using dictionary comprehension
res = {idx: ele for idx, ele in enumerate(test_list) if ele >= K}

# printing result
print ("The dictionary after storing elements : " + str(res))
```
```q
q)L:12 44 56 34 67 98 34
q){i!x i:where x>y}[L;50]
2| 56
4| 67
5| 98
```


## [Remove duplicate words from strings in list](https://www.geeksforgeeks.org/python-remove-duplicate-words-from-strings-in-list/)

```python
# Python3 code to demonstrate
# Remove duplicate words from Strings in List
# using list comprehension + set() + split()

# Initializing list
test_list = ['gfg, best, gfg', 'I, am, I', 'two, two, three' ]

# printing original list
print("The original list is : " + str(test_list))

# Remove duplicate words from Strings in List
# using list comprehension + set() + split()
res = [set(strs.split(", ")) for strs in test_list]

# printing result
print ("The list after duplicate words removal is : " + str(res))
```
```q
q)L:("gfg, best, gfg";"I, am, I";"two, two, three")
q){distinct", "vs x}each L
"gfg" "best"
,"I"  "am"
"two" "three"
```


## [Difference of list keeping duplicates](Difference of List keeping duplicates)

```python
# Python3 code to demonstrate
# Difference of List keeping duplicates
# using pop() + list comprehension + index()

# Initializing lists
test_list1 = [4, 5, 7, 4, 3]
test_list2 = [7, 3, 4]

# printing original lists
print("The original list 1 is : " + str(test_list1))
print("The original list 2 is : " + str(test_list2))

# Difference of List keeping duplicates
# using pop() + list comprehension + index()
[test_list1.pop(test_list1.index(idx)) for idx in test_list2]

# printing result
print ("List after performing difference : " + str(test_list1))
```
```q
q){distinct x except y except x where(x?x)<>til count x}[4 5 7 4 3;7 3 4]
4 5
```


## [Pairs with multiple similar values in dictionary](https://www.geeksforgeeks.org/python-pairs-with-multiple-similar-values-in-dictionary/)

```python
# Python3 code to demonstrate
# Pairs with multiple similar values in dictionary
# using list comprehension

# Initializing list
test_list = [{'Gfg' : 1, 'is' : 2}, {'Gfg' : 2, 'is' : 2}, {'Gfg' : 1, 'is' : 2}]

# printing original list
print("The original list is : " + str(test_list))

# Pairs with multiple similar values in dictionary
# using list comprehension
res = [sub for sub in test_list if len([ele for ele in test_list if ele['Gfg'] == sub['Gfg']]) > 1]

# printing result
print ("List after keeping dictionary with same key's value : " + str(res))
```
```q
q)L:((`Gfg`is!1 2); (`Gfg`is!2 2); (`Gfg`is!1 2))
q){x where x in x where(x?x)<>til count x}L
Gfg is
------
1   2
1   2
```


