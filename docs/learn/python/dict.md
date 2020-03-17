---
title: Q versions of Python dictionary programming examples| Documentation for kdb+ and q
description: Python programming examples for dictionaries and their q equivalents
author: Stephen Taylor
date: March 2020
hero: <i class="fab fa-python"></i> Python programming examples in q
---
# Dictionary programs

From
<i class="fas fa-globe"></i>
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and the Python solution/s.


## [Sort dictionary by keys or values](https://www.geeksforgeeks.org/python-sort-python-dictionaries-by-key-or-value/)

### Sort keys ascending

```python
# Function calling 
def dictionairy(): 
# Declare hash function  
key_value ={}    

# Initializing value 
key_value[2] = 56   
key_value[1] = 2
key_value[5] = 12
key_value[4] = 24
key_value[6] = 18   
key_value[3] = 323

print ("Task 1:-\n") 
print ("Keys are") 

# iterkeys() returns an iterator over the 
# dictionary’s keys. 
for i in sorted (key_value.keys()) : 
    print(i, end = " ") 

def main(): 
    # function calling 
    dictionairy()            
    
# Main function calling 
if __name__=="__main__":     
    main() 
```
```q
q)show d:2 1 4 5 6 3!64 69 23 65 34 76
2| 64
1| 69
4| 23
5| 65
6| 34
3| 76
q)asc key d
`s#1 2 3 4 5 6
```


### Sort entries ascending by key

```python
# function calling 
def dictionairy(): 

# Declaring the hash function    
key_value ={}    

# Initialize value 
key_value[2] = 56   
key_value[1] = 2
key_value[5] = 12
key_value[4] = 24
key_value[6] = 18   
key_value[3] = 323

print ("Task 2:-\nKeys and Values sorted in", 
            "alphabetical order by the key ") 

# sorted(key_value) returns an iterator over the 
# Dictionary’s value sorted in keys. 
for i in sorted (key_value) : 
    print ((i, key_value[i]), end =" ") 

def main(): 
    # function calling 
    dictionairy()            
    
# main function calling 
if __name__=="__main__":     
    main() 
```
```q
q)d:2 1 5 4 6 3!56 2 12 24 18 323
q){k!x k:asc key x} d
1| 2
2| 56
3| 323
4| 24
5| 12
6| 18
```


### Sort entries ascending by value

```python
# Function calling 
def dictionairy(): 

# Declaring hash function    
key_value ={}    

# Initializing the value 
key_value[2] = 56   
key_value[1] = 2
key_value[5] = 12
key_value[4] = 24
key_value[6] = 18   
key_value[3] = 323


print ("Task 3:-\nKeys and Values sorted", 
"in alphabetical order by the value") 

# Note that it will sort in lexicographical order 
# For mathematical way, change it to float 
print(sorted(key_value.items(), key =
            lambda kv:(kv[1], kv[0])))   

def main(): 
    # function calling 
    dictionairy()            
    
# main function calling 
if __name__=="__main__":     
    main() 
```
```q
q)asc d
1| 2
5| 12
6| 18
4| 24
2| 56
3| 323
```


## [Sum of values](https://www.geeksforgeeks.org/python-program-to-find-the-sum-of-all-items-in-a-dictionary/)

```python
# Python3 Program to find sum of 
# all items in a Dictionary 

# Function to print sum 
def returnSum(myDict): 
    
    sum = 0
    for i in myDict: 
        sum = sum + myDict[i] 
    
    return sum

# Driver Function 
dict = {'a': 100, 'b':200, 'c':300} 
print("Sum :", returnSum(dict)) 
```

Dictionaries are first-class objects in q, and keywords apply to their values.

```q
q)d:`a`b`c!100 200 300
q)sum d
600
```


## [Delete an entry](https://www.geeksforgeeks.org/python-ways-to-remove-a-key-from-dictionary/)

```python
# Python code to demonstrate 
# removal of dict. pair 
# using del 

# Initializing dictionary 
test_dict = {"Arushi" : 22, "Anuradha" : 21, "Mani" : 21, "Haritha" : 21} 

# Printing dictionary before removal 
print ("The dictionary before performing remove is : " + str(test_dict)) 

# Using del to remove a dict 
# removes Mani 
del test_dict['Mani'] 

# Printing dictionary after removal 
print ("The dictionary after remove is : " + str(test_dict)) 

# Using del to remove a dict 
# raises exception 
del test_dict['Manjeet'] 
```
```q
q)d:`Anuradha`Haritha`Arushi`Mani!21 21 22 21

q)delete Mani from d        / delete defined key
Anuradha| 21
Haritha | 21
Arushi  | 22

q)delete Manjeet from d     / delete undefined key
Anuradha| 21
Haritha | 21
Arushi  | 22
Mani    | 21
```


## [Sort list of dictionaries by value](https://www.geeksforgeeks.org/ways-sort-list-dictionaries-values-python-using-itemgetter/)

```python
# Python code demonstrate the working of sorted() 
# and itemgetter 

# importing "operator" for implementing itemgetter 
from operator import itemgetter 

# Initializing list of dictionaries 
lis = [{ "name" : "Nandini", "age" : 20}, 
{ "name" : "Manjeet", "age" : 20 }, 
{ "name" : "Nikhil" , "age" : 19 }] 

# using sorted and itemgetter to print list sorted by age 
print "The list printed sorting by age: "
print sorted(lis, key=itemgetter('age')) 

print ("\r") 

# using sorted and itemgetter to print list sorted by both age and name 
# notice that "Manjeet" now comes before "Nandini" 
print "The list printed sorting by age and name: "
print sorted(lis, key=itemgetter('age', 'name')) 

print ("\r") 

# using sorted and itemgetter to print list sorted by age in descending order 
print "The list printed sorting by age in descending order: "
print sorted(lis, key=itemgetter('age'),reverse = True) 
```

A list of q same-key dictionaries is a table.

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
# Python code to merge dict using update() method 
def Merge(dict1, dict2): 
    return(dict2.update(dict1)) 
    
# Driver code 
dict1 = {'a': 10, 'b': 8} 
dict2 = {'d': 6, 'c': 4} 

# This return None 
print(Merge(dict1, dict2)) 

# changes made in dict2 
print(dict2) 
```

The [Join](../../ref/join.md) operator in q has upsert semantics.

```q
q)(`a`b!10 8),`d`c!6 4
a| 10
b| 8
d| 6
c| 4
```


## [Grade calculator](https://www.geeksforgeeks.org/program-create-grade-calculator-in-python/)

```python
# Python code for the Grade 
# Calculator program in action 

# Creating a dictionary which 
# consists of the student name, 
# assignment result test results 
# and their respective lab results 

# 1. Jack's dictionary 
jack = { "name":"Jack Frost", 
        "assignment" : [80, 50, 40, 20], 
        "test" : [75, 75], 
        "lab" : [78.20, 77.20] 
    } 
        
# 2. James's dictionary 
james = { "name":"James Potter", 
        "assignment" : [82, 56, 44, 30], 
        "test" : [80, 80], 
        "lab" : [67.90, 78.72] 
        } 

# 3. Dylan's dictionary 
dylan = { "name" : "Dylan Rhodes", 
        "assignment" : [77, 82, 23, 39], 
        "test" : [78, 77], 
        "lab" : [80, 80] 
        } 
        
# 4. Jessica's dictionary 
jess = { "name" : "Jessica Stone", 
        "assignment" : [67, 55, 77, 21], 
        "test" : [40, 50], 
        "lab" : [69, 44.56] 
    } 
        
# 5. Tom's dictionary 
tom = { "name" : "Tom Hanks", 
        "assignment" : [29, 89, 60, 56], 
        "test" : [65, 56], 
        "lab" : [50, 40.6] 
    } 

# Function calculates average 
def get_average(marks): 
    total_sum = sum(marks) 
    total_sum = float(total_sum) 
    return total_sum / len(marks) 

# Function calculates total average 
def calculate_total_average(students): 
    assignment = get_average(students["assignment"]) 
    test = get_average(students["test"]) 
    lab = get_average(students["lab"]) 

    # Return the result based 
    # on weightage supplied 
    # 10 % from assignments 
    # 70 % from test 
    # 20 % from lab-works 
    return (0.1 * assignment +
            0.7 * test + 0.2 * lab) 


# Calculate letter grade of each student 
def assign_letter_grade(score): 
    if score >= 90: return "A"
    elif score >= 80: return "B"
    elif score >= 70: return "C"
    elif score >= 60: return "D"
    else : return "E"

# Function to calculate the total 
# average marks of the whole class 
def class_average_is(student_list): 
    result_list = [] 

    for student in student_list: 
        stud_avg = calculate_total_average(student) 
        result_list.append(stud_avg) 
        return get_average(result_list) 

# Student list consisting the 
# dictionary of all students 
students = [jack, james, dylan, jess, tom] 

# Iterate through the students list 
# and calculate their respective 
# average marks and letter grade 
for i in students : 
    print(i["name"]) 
    print("=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=") 
    print("Average marks of %s is : %s " %(i["name"], 
                        calculate_total_average(i))) 
                        
    print("Letter Grade of %s is : %s" %(i["name"], 
    assign_letter_grade(calculate_total_average(i)))) 
    
    print() 


# Calculate the average of whole class 
class_av = class_average_is(students) 

print( "Class Average is %s" %(class_av)) 
print("Letter Grade of the class is %s "
        %(assign_letter_grade(class_av))) 
```

Close readers will spot that the Python program output in the link displays the class median score, not the average. Shorter programs are easier to get right.

`script.q`:

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
```q
q)\l script.q
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


## [Identify election winner](https://www.geeksforgeeks.org/dictionary-counter-python-find-winner-election/)

```python
# Function to find winner of an election where votes 
# are represented as candidate names 
from collections import Counter 

def winner(input): 

    # convert list of candidates into dictionary 
    # output will be likes candidates = {'A':2, 'B':4} 
    votes = Counter(input) 
    
    # create another dictionary and it's key will 
    # be count of votes values will be name of 
    # candidates 
    dict = {} 

    for value in votes.values(): 

        # initialize empty list to each key to 
        # insert candidate names having same 
        # number of votes 
        dict[value] = [] 

    for (key,value) in votes.iteritems(): 
        dict[value].append(key) 

    # sort keys in descending order to get maximum 
    # value of votes 
    maxVote = sorted(dict.keys(),reverse=True)[0] 

    # check if more than 1 candidates have same 
    # number of votes. If yes, then sort the list 
    # first and print first element 
    if len(dict[maxVote])>1: 
        print sorted(dict[maxVote])[0] 
    else: 
        print dict[maxVote][0] 

# Driver program 
if __name__ == "__main__": 
    input =['john','johnny','jackie','johnny','john','jackie','jamie','jamie', 
'john','johnny','jamie','johnny','john'] 
    winner(input) 
```

The q solution does not need to test whether a tie needs breaking.

`{x idesc count each x}` sorts the winners by name length, even if there is only one.

```q
q)votes:`john`johnny`jackie`johnny`john`jackie`jamie`jamie`john`johnny`jamie`johnny`john
q)first{x idesc count each x}where{x=max x}count each group string votes
"johnny"
```


## [Group anagrams](https://www.geeksforgeeks.org/print-anagrams-together-python-using-list-dictionary/)

```python
# Function to return all anagrams together 
def allAnagram(input): 
    
    # empty dictionary which holds subsets 
    # of all anagrams together 
    dict = {} 

    # traverse list of strings 
    for strVal in input: 
        
        # sorted(iterable) method accepts any 
        # iterable and rerturns list of items 
        # in ascending order 
        key = ''.join(sorted(strVal)) 
        
        # now check if key exist in dictionary 
        # or not. If yes then simply append the 
        # strVal into the list of it's corresponding 
        # key. If not then map empty list onto 
        # key and then start appending values 
        if key in dict.keys(): 
            dict[key].append(strVal) 
        else: 
            dict[key] = [] 
            dict[key].append(strVal) 

    # traverse dictionary and concatenate values 
    # of keys together 
    output = "" 
    for key,value in dict.iteritems(): 
        output = output + ' '.join(value) + ' '

    return output 

# Driver function 
if __name__ == "__main__": 
    input=['cat', 'dog', 'tac', 'god', 'act'] 
    print allAnagram(input) 
```

Sorting each string produces common results for anagrams, by which `group` clusters them, and `raze` joins the clusters.

```q
q)w:`cat`dog`tac`god`act
q)raze group w!asc each string w
`cat`tac`act`dog`god
```


## [Size of largest subset of anagrams](https://www.geeksforgeeks.org/python-counter-find-size-largest-subset-anagram-words/)

```python
# Function to find the size of largest subset 
# of anagram words 
from collections import Counter 

def maxAnagramSize(input): 

    # split input string separated by space 
    input = input.split(" ") 

    # sort each string in given list of strings 
    for i in range(0,len(input)): 
        input[i]=''.join(sorted(input[i])) 

    # now create dictionary using counter method 
    # which will have strings as key and their 
    # frequencies as value 
    freqDict = Counter(input) 

    # get maximum value of frequency 
    print (max(freqDict.values())) 

# Driver program 
if __name__ == "__main__": 
    input = 'ant magenta magnate tan gnamate'
    maxAnagramSize(input) 
```
```q
q)maxAnagramSize:{max count each group asc each string x}
q)maxAnagramSize `ant`magenta`magnate`tan`gnamate
3
q)maxAnagramSize `cars`bikes`arcs`steer
2
```


## [Mirror characters in a string](https://www.geeksforgeeks.org/python-dictionary-find-mirror-characters-string/)

```python
# function to mirror characters of a string 

def mirrorChars(input,k): 

    # create dictionary 
    original = 'abcdefghijklmnopqrstuvwxyz'
    reverse = 'zyxwvutsrqponmlkjihgfedcba'
    dictChars = dict(zip(original,reverse)) 

    # separate out string after length k to change 
    # characters in mirror 
    prefix = input[0:k-1] 
    suffix = input[k-1:] 
    mirror = '' 

    # change into mirror 
    for i in range(0,len(suffix)): 
        mirror = mirror + dictChars[suffix[i]] 

    # concat prefix and mirrored part 
    print (prefix+mirror) 
        
# Driver program 
if __name__ == "__main__": 
    input = 'paradox'
    k = 3
    mirrorChars(input,k) 
```
```q
q)m:{x!reverse x}.Q.a  / mirror dictionary
q)mirrorChars:{@[x;where(til count x)>y-2;m]}

q)mirrorChars["paradox";3]
"paizwlc"
q)mirrorChars["pneumonia";6]
"pneumlmrz"
```


## [Count frequency](https://www.geeksforgeeks.org/counting-the-frequencies-in-a-list-using-dictionary-in-python/)

```python
# Python program to count the frequency of 
# elements in a list using a dictionary 

def CountFrequency(my_list): 

    # Creating an empty dictionary 
    freq = {} 
    for item in my_list: 
        if (item in freq): 
            freq[item] += 1
        else: 
            freq[item] = 1

    for key, value in freq.items(): 
        print ("% d : % d"%(key, value)) 

# Driver function 
if __name__ == "__main__": 
    my_list =[1, 1, 1, 5, 5, 3, 1, 3, 3, 1, 4, 4, 4, 2, 2, 2, 2] 

    CountFrequency(my_list) 
```
```q
q)count each group 1 1 1 5 5 3 1 3 3 1 4 4 4 2 2 2 2
1| 5
5| 2
3| 3
4| 3
2| 4
```


## [Tuples to dictionary](https://www.geeksforgeeks.org/python-convert-list-tuples-dictionary/)

```python
# Python code to convert into dictionary 

def Convert(tup, di): 
    for a, b in tup: 
        di.setdefault(a, []).append(b) 
    return di 
    
# Driver Code    
tups = [("akash", 10), ("gaurav", 12), ("anand", 14), 
    ("suraj", 20), ("akhil", 25), ("ashish", 30)] 
dictionary = {} 
print (Convert(tups, dictionary)) 
```

The problem is less general than its heading suggests: it is only to turn a list of pairs into a dictionary. In q, the general case, with tuples of unspecified length, is handled by [keyed tables](../../ref/enkey.md).

```q
q)show tups:(("akash";10);("gaurav";12);("anand";14);("suraj";20);("akhil";25);("ashish";30))
"akash"  10
"gaurav" 12
"anand"  14
"suraj"  20
"akhil"  25
"ashish" 30
q).[!]flip tups
"akash" | 10
"gaurav"| 12
"anand" | 14
"suraj" | 20
"akhil" | 25
"ashish"| 30
```


## [Find possible words](https://www.geeksforgeeks.org/possible-words-using-given-characters-python/)

```python
# Function to print words which can be created 
# using given set of characters 

def charCount(word): 
    dict = {} 
    for i in word: 
        dict[i] = dict.get(i, 0) + 1
    return dict

def possible_words(lwords, charSet): 
    for word in lwords: 
        flag = 1
        chars = charCount(word) 
        for key in chars: 
            if key not in charSet: 
                flag = 0
            else: 
                if charSet.count(key) != chars[key]: 
                    flag = 0
        if flag == 1: 
            print(word) 

if __name__ == "__main__": 
    input = ['goo', 'bat', 'me', 'eat', 'goal', 'boy', 'run'] 
    charSet = ['e', 'o', 'b', 'a', 'm', 'g', 'l'] 
    possible_words(input, charSet) 
```
```q
q)d:string`go`bat`me`eat`goal`boy`run           / dictionary
q)possible_words:{x where all each x in\:y}[d;]

q)possible_words "eobamgl"
"go"
"me"
"goal"
```

### Cheat at Scrabble

The `fr` column of our dictionary table for Scrabble contains for each word a frequency count of its letters. 

```q
q)tv:.Q.a!1 3 3 2 1 4 2 4 1 8 5 1 3 1 1 3 10 1 1 1 1 4 4 8 4 10  / Scrabble tile values
q)fc:{count each group x} / frequency count 

q)ud:system"curl http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
q)show dt:([]word:ud;fr:fc each ud;sc:{sum tv x}each ud) / dictionary table
word     fr                sc
-----------------------------
,"a"     (,"a")!,1         1
"aaa"    (,"a")!,3         3
"aaas"   "as"!3 1          4
"aarhus" "arhus"!2 1 1 1 1 9
"aaron"  "aron"!2 1 1 1    5
"aau"    "au"!2 1          3
"aba"    "ab"!2 1          5
..
```

To test a word, subtract its frequency count from the frequency count of the tiles on your rack.

```q
q)fc["eobmagl"]-fc "mangle"  / is "mangle" possible?
e| 0
o| 1
b| 1
m| 0
a| 0
g| 0
l| 0
n| -1
```

If no item is negative, the word is a candidate. It remains only to sort the candidates descending by score.

```q
q)cheat:{{x idesc x`sc}select word,sc from dt where fc[x]{all(x-y)>=0}/:fr}

q)cheat "eobmagl"
word     sc
-----------
"gamble" 11
"gambol" 11
"amble"  9
"blame"  9
"mabel"  9
"bagel"  8
"balm"   8

..
```