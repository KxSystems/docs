---
title: Q versions of Python dictionary programming examples| Documentation for kdb+ and q
description: Python programming examples for dictionaries and their q equivalents
author: Stephen Taylor
date: March 2020
---
# Dictionary programs

From
:fontawesome-solid-globe:
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and Python solutions.


## [Sort dictionary by keys or values](https://www.geeksforgeeks.org/python-sort-python-dictionaries-by-key-or-value/)


### Sort keys ascending

```python
>>> kv = {2:'56', 1:'2', 5:'12', 4:'24', 6:'18', 3:'323'}

>>> sorted(kv.keys())
[1, 2, 3, 4, 5, 6]
```
```q
q)kv:2 1 4 5 6 3!64 69 23 65 34 76

q)asc key kv
`s#1 2 3 4 5 6
```

<big>:fontawesome-regular-comment:</big>
A dictionary is a mapping between two lists: the keys and the values. 
Keys are commonly of the same datatype; as are values. 
So most dictionaries are a mapping between two vectors. (Homogenous lists.)
Above, dictionary `kv` is formed from two vectors by the [Dict](../../../ref/dict.md) operator `!`. 

A list of key-value pairs can be flipped into two lists, and passed to `(!).` to form a dictionary. 

```q
q)(!).flip(2 56;1 2;5 12;4 24;6 18;3 323)
2| 56
1| 2
5| 12
4| 24
6| 18
3| 323
```


### Sort entries ascending by key

```python
>>> [[k, kv[k]] for k in sorted(kv.keys())]
[[1, 2], [2, 56], [3, 323], [4, 24], [5, 12], [6, 18]]
```
```q
q)k!kv k:asc key kv
1| 2
2| 56
3| 323
4| 24
5| 12
6| 18
```


### Sort entries ascending by value

```python
>>> sorted(kv.items(), key = lambda x:(x[1], x[0]))
[(1, 2), (5, 12), (6, 18), (4, 24), (2, 56), (3, 323)]
```
```q
q)asc kv
1| 2
5| 12
6| 18
4| 24
2| 56
3| 323
```

<big>:fontawesome-regular-comment:</big>
The value of `kv` is the dictionary’s values.

```q
q)value kv
56 2 12 24 18 323
```

So an ascending sort of the dictionary returns it in ascending order of values.


## [Sum of values](https://www.geeksforgeeks.org/python-program-to-find-the-sum-of-all-items-in-a-dictionary/)

```python
>>> d = {'a': 100, 'b':200, 'c':300}

>>> sum([v for k, v in d.items()])
600
```

Dictionaries are first-class objects in q, and keywords apply to their values.

```q
q)d:`a`b`c!100 200 300

q)sum d
600
```


## [Delete an entry](https://www.geeksforgeeks.org/python-ways-to-remove-a-key-from-dictionary/)

```python
>>> d = {"Arushi" : 22, "Anuradha" : 21, "Mani" : 21, "Haritha" : 21}

>>> # functional removal
>>> {key:val for key, val in d.items() if key != 'Mani'}
{'Arushi': 22, 'Anuradha': 21, 'Haritha': 21}

>>> # removal in place
>>> del d['Mani']
>>> d
{'Arushi': 22, 'Anuradha': 21, 'Haritha': 21}
```
```q
q)d:`Anuradha`Haritha`Arushi`Mani!21 21 22 21

q)delete Mani from d        / functional removal
Anuradha| 21
Haritha | 21
Arushi  | 22

q)delete Haritha from `d    / removal in place
`d
q)d
Anuradha| 21
Arushi  | 22
Mani    | 21
```

<big>:fontawesome-regular-comment:</big>
Removal in place in q is effectively restricted to global tables.
Within functions, use functional methods.


## [Sort list of dictionaries by value](https://www.geeksforgeeks.org/ways-sort-list-dictionaries-values-python-using-itemgetter/)

```python
>>> lis = [{ "name" : "Nandini", "age" : 20},
... { "name" : "Manjeet", "age" : 20 },
... { "name" : "Nikhil" , "age" : 19 }]
>>>
>>> sorted(lis, key=itemgetter('age', 'name'))
[{'name': 'Nikhil', 'age': 19}, {'name': 'Manjeet', 'age': 20}, {'name': 'Nandini', 'age': 20}]
>>> sorted(lis, key=itemgetter('age'),reverse = True)
[{'name': 'Nandini', 'age': 20}, {'name': 'Manjeet', 'age': 20}, {'name': 'Nikhil', 'age': 19}]
```

<big>:fontawesome-regular-comment:</big>
A list of q same-key dictionaries is… a table.

```q
q)show lis:(`name`age!(`Nandini;20); `name`age!(`Manjeet;20); `name`age!(`Nikhil;19))
name    age
-----------
Nandini 20
Manjeet 20
Nikhil  19
```

```q
q)lis iasc lis`age              / sort ascending by age
name    age
-----------
Nikhil  19
Nandini 20
Manjeet 20

q)lis{x iasc x y}/`name`age     / sort by name within age
name    age
-----------
Nikhil  19
Manjeet 20
Nandini 20
```


## [Merge two dictionaries](https://www.geeksforgeeks.org/python-merging-two-dictionaries/)

```python
def merge(dict1, dict2):
    d = {}
    d.update(dict1)
    d.update(dict2)
    return d
```
```python
>>> d1 = {'a': 10, 'b': 8, 'c': 42}
>>> d2 = {'d': 6, 'c': 4}

>>> merge(d1, d2)
{'a': 10, 'b': 8, 'c': 4, 'd': 6}
```

The [Join](../../../ref/join.md) operator (`,`) in q has upsert semantics.

```q
q)d1:`a`b`c!10 8 42
q)d2:`d`c!6 4

q)d1,d2
a| 10
b| 8
c| 4
d| 6
```


## [Grade calculator](https://www.geeksforgeeks.org/program-create-grade-calculator-in-python/)

`grades.py`

```python
jack = { "name":"Jack Frost",
        "assignment" : [80, 50, 40, 20],
        "test" : [75, 75],
        "lab" : [78.20, 77.20]
    }

james = { "name":"James Potter",
        "assignment" : [82, 56, 44, 30],
        "test" : [80, 80],
        "lab" : [67.90, 78.72]
        }

dylan = { "name" : "Dylan Rhodes",
        "assignment" : [77, 82, 23, 39],
        "test" : [78, 77],
        "lab" : [80, 80]
        }

jess = { "name" : "Jessica Stone",
        "assignment" : [67, 55, 77, 21],
        "test" : [40, 50],
        "lab" : [69, 44.56]
    }

tom = { "name" : "Tom Hanks",
        "assignment" : [29, 89, 60, 56],
        "test" : [65, 56],
        "lab" : [50, 40.6]
    }

def get_average(marks):
    total_sum = sum(marks)
    total_sum = float(total_sum)
    return total_sum / len(marks)

def calculate_total_average(students):
    assignment = get_average(students["assignment"])
    test = get_average(students["test"])
    lab = get_average(students["lab"])

    # Result based on weightings
    return (0.1 * assignment +
            0.7 * test + 0.2 * lab)

def assign_letter_grade(score):
    if   score >= 90: return "A"
    elif score >= 80: return "B"
    elif score >= 70: return "C"
    elif score >= 60: return "D"
    else : return "E"

def class_average_is(student_list):
    result_list = []

    for student in student_list:
        stud_avg = calculate_total_average(student)
        result_list.append(stud_avg)
        return get_average(result_list)

students = [jack, james, dylan, jess, tom]

for i in students :
    print(i["name"])
    print("=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=")
    print("Average marks of %s is : %s " %(i["name"],
                        calculate_total_average(i)))

    print("Letter Grade of %s is : %s" %(i["name"],
    assign_letter_grade(calculate_total_average(i))))

    print()

class_av = class_average_is(students)

print( "Class Average is %s" %(class_av))
print("Letter Grade of the class is %s "
        %(assign_letter_grade(class_av)))
```
```txt
$ python3 grades.py
Jack Frost
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
Average marks of Jack Frost is : 72.79
Letter Grade of Jack Frost is : C

James Potter
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
Average marks of James Potter is : 75.962
Letter Grade of James Potter is : C

Dylan Rhodes
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
Average marks of Dylan Rhodes is : 75.775
Letter Grade of Dylan Rhodes is : C

Jessica Stone
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
Average marks of Jessica Stone is : 48.356
Letter Grade of Jessica Stone is : E

Tom Hanks
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
Average marks of Tom Hanks is : 57.26
Letter Grade of Tom Hanks is : E

Class Average is 72.79
Letter Grade of the class is C
```

!!! warning "Median not average"

    The output above displays the class median score and letter grade, not the average. Oops.

    Shorter programs are easier to get right.

`grades.q`

```q
/ grade calculator
students:flip`name`assignment`test`lab!flip(
  (`JackFrost;    80 50 40 20; 75 75; 78.20 77.20);
  (`JamesPotter;  82 56 44 30; 80 80; 67.90 78.72);
  (`DylanRhodes;  77 82 23 39; 78 77; 80 80);
  (`JessicaStone; 67 55 77 21; 40 50; 69 44.56);
  (`TomHanks;     29 89 60 56; 65 56; 50 40.6)
  )

students[`mark]:sum .1 .7 .2*(avg'')students `assignment`test`lab
lg:{"EDCBA"sum 60 70 80 90<\:x}  / letter grade from mark
update letter:lg mark from `students;

show students
"Class average: ",string ca:avg students`mark
"Class letter grade: ",lg ca
```
```txt
q)\l grades.q
name         assignment  test  lab        mark   letter
-------------------------------------------------------
JackFrost    80 50 40 20 75 75 78.2 77.2  72.79  C
JamesPotter  82 56 44 30 80 80 67.9 78.72 75.962 C
DylanRhodes  77 82 23 39 78 77 80   80    75.775 C
JessicaStone 67 55 77 21 40 50 69   44.56 48.356 E
TomHanks     29 89 60 56 65 56 50   40.6  57.26  E
"Class average: 66.0286"
"Class letter grade: D"
```


## [Mirror characters in a string](https://www.geeksforgeeks.org/python-dictionary-find-mirror-characters-string/)

```python
def mirrorChars(s, k):
    original = 'abcdefghijklmnopqrstuvwxyz'
    reverse  = 'zyxwvutsrqponmlkjihgfedcba'
    m = dict(zip(original,reverse))

    lst = list(s)
    ti = range(k-1, len(lst))
    for i in ti: lst[i] = m[lst[i]]
    return ''.join(lst)
```
```python
>>> mirrorChars('paradox', 3)
'paizwlc'
```
```q
mirrorChars:{[s;k]
  m:{x!reverse x}.Q.a;      / mirror dictionary
  ti:(k-1)_ til count s;    / target indexes
  @[s;ti;m] }
```
```q
q)mirrorChars["paradox";3]
"paizwlc"
```

<big>:fontawesome-regular-comment:</big>
Python and q solutions implement the same strategy:

-   write a mirror dictionary `m`
-   identify the indexes to be targeted `ti`
-   replace the characters at those indexes with their mirrors

The Python has the further steps of converting the string to a list and back again.



## [Count frequency](https://www.geeksforgeeks.org/counting-the-frequencies-in-a-list-using-dictionary-in-python/)

```python
>>> lst = ([1, 1, 1, 5, 5, 3, 1, 3, 3, 1, 4, 4, 4, 2, 2, 2, 2])

>>> from collections import Counter
>>> Counter(lst)
Counter({1: 5, 2: 4, 3: 3, 4: 3, 5: 2})
```
```q
q)lst:1 1 1 5 5 3 1 3 3 1 4 4 4 2 2 2 2

q)count each group lst
1| 5
5| 2
3| 3
4| 3
2| 4
```


## [Tuples to dictionary](https://www.geeksforgeeks.org/python-convert-list-tuples-dictionary/)

```python
>>> tups = [("akash", 10), ("gaurav", 12), ("anand", 14), ("suraj", 20), 
... ("akhil", 25), ("ashish", 30)]

>>> {t[0]:t[1] for t in tups}
{'akash': 10, 'gaurav': 12, 'anand': 14, 'suraj': 20, 'akhil': 25, 'ashish': 30}
```
```q
q)tups:(("akash";10);("gaurav";12);("anand";14);("suraj";20);("akhil";25);("ashish";30))

q)(!).flip tups
"akash" | 10
"gaurav"| 12
"anand" | 14
"suraj" | 20
"akhil" | 25
"ashish"| 30
```

<big>:fontawesome-regular-comment:</big>
Here we flip the tuples to get two lists, which we pass to [Apply](../../../ref/apply.md) (`.`) as the arguments to [Dict](../../../ref/dict.md) (`!`).

The heading suggests a more general problem than turning a list of pairs into a dictionary. In q, the general case, with tuples of unspecified length, is handled by [keyed tables](../../../ref/enkey.md).


