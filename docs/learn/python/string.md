---
title: Q versions of Python string programming examples| Documentation for kdb+ and q
description: Python programming examples for strings and their q equivalents
author: Stephen Taylor
date: March 2020
hero: <i class="fab fa-python"></i> Python programming examples in q
---
# String programs

From
<i class="fas fa-globe"></i>
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and the Python solution/s.


## [Is string a palindrome?](https://www.geeksforgeeks.org/python-program-check-string-palindrome-not/)

```python
# function to check string is 
# palindrome or not 
def isPalindrome(str): 

    # Run loop from 0 to len/2 
    for i in xrange(0, len(str)/2): 
        if str[i] != str[len(str)-i-1]: 
            return False
    return True

# main function 
s = "malayalam"
ans = isPalindrome(s) 

if (ans): 
    print("Yes") 
else: 
    print("No") 
```

The q solution matches the definition of a palindrome – does the string match its reversal?

```q
q)isPalindrome:{x~reverse x}
q)isPalindrome each ("malayalam";"geeks")
10b
```


## [Reverse words in a string](https://www.geeksforgeeks.org/reverse-words-in-a-given-string/)

```python
// CPP program to reverse a string 
#include <stdio.h> 

// Function to reverse any sequence 
// starting with pointer begin and 
// ending with pointer end 
void reverse(char* begin, char* end) 
{ 
    char temp; 
    while (begin < end) { 
        temp = *begin; 
        *begin++ = *end; 
        *end-- = temp; 
    } 
} 

// Function to reverse words*/ 
void reverseWords(char* s) 
{ 
    char* word_begin = s; 

    // Word boundary 
    char* temp = s; 

    // Reversing individual words as 
    // explained in the first step 
    while (*temp) { 
        temp++; 
        if (*temp == '\0') { 
            reverse(word_begin, temp - 1); 
        } 
        else if (*temp == ' ') { 
            reverse(word_begin, temp - 1); 
            word_begin = temp + 1; 
        } 
    } 

    // Reverse the entire string 
    reverse(s, temp - 1); 
} 

// Driver Code 
int main() 
{ 
    char s[] = "i like this program very much"; 
    char* temp = s; 
    reverseWords(s); 
    printf("%s", s); 
    getchar(); 
    return 0; 
} 
```

Q is a vector language. Its keywords [`vs`](../../ref/vs.md) and [`sv`](../../ref/sv.md) split and join strings.

```q
q)reverseWords:{" "sv reverse" "vs x}
q)reverseWords"geeks quiz practice code"
"code practice quiz geeks"
q)reverseWords"getting good at coding needs a lot of practice"
"practice of lot a needs coding at good getting"
```


## [Remove `i`th character from string](https://www.geeksforgeeks.org/ways-to-remove-ith-character-from-string-in-python/)

```python
# Python code to demonstrate 
# method to remove i'th character 
# Naive Method 

# Initializing String 
test_str = "GeeksForGeeks"

# Printing original string 
print ("The original string is : " + test_str) 

# Removing char at pos 3 
# using loop 
new_str = "" 

for i in range(0, len(test_str)): 
    if i != 2: 
        new_str = new_str + test_str[i] 

# Printing string after removal 
print ("The string after removal of i'th character : " + new_str) 
```

In q, `til count x` returns all the indexes of list `x`.

```q
q){x(til count x)except y-1}["GeeksforGeeks";3]
"GeksforGeeks"
```


## [Is string a substring of another?](https://www.geeksforgeeks.org/python-check-substring-present-given-string/)

```python
# function to check if small string is 
# there in big string 
def check(string, sub_str): 
    if (string.find(sub_str) == -1): 
        print("NO") 
    else: 
        print("YES") 
            
# driver code 
string = "geeks for geeks"
sub_str ="geek"
check(string, sub_str) 
```

In q, the [`like`](../../ref/like.md) keyword provides basic pattern matching.

```q
q)"geeks for geeks" like/:("*geek*";"*geeks*")
11b
```


## [Even-length words in a string](https://www.geeksforgeeks.org/python-program-to-print-even-length-words-in-a-string/)

```python
# Python3 program to print 
# even length words in a string 

def printWords(s): 
    
    # split the string 
    s = s.split(' ') 
    
    # iterate in words of string 
    for word in s: 
        
        # if length is even 
        if len(word)%2==0: 
            print(word) 


# Driver Code 
s = "i am muskan"
printWords(s) 
```
```q
q)printWords:{{x where 0=(count each x)mod 2}" "vs x}

q)printWords "This is a python language"
"This"
"is"
"python"
"language"

q)printWords "i am muskan"
"am"
"muskan"
```


## [String contains all the vowels?](https://www.geeksforgeeks.org/python-program-to-accept-the-strings-which-contains-all-vowels/)

```python
# Python program to accept the strings 
# which contains all the vowels 

# Function for check if string 
# is accepted or not 
def check(string) : 

    # set() function convert "aeiou" 
    # string into set of characters 
    # i.e.vowels = {'a', 'e', 'i', 'o', 'u'} 
    vowels = set("aeiou") 

    # set() function convert empty 
    # dictionary into empty set 
    s = set({}) 

    # looping through each 
    # character of the string 
    for char in string : 

    # Check for the character is present inside 
    # the vowels set or not. If present, then 
    # add into the set s by using add method 
        if char in vowels : 
            s.add(char) 
        else: 
            pass
            
    # check the length of set s equal to length 
    # of vowels set or not. If equal, string is 
    # accepted otherwise not 
    if len(s) == len(vowels) : 
        print("Accepted") 
    else : 
        print("Not Accepted") 


# Driver code 
if __name__ == "__main__" : 
    
    string = "SEEquoiaL"

    # lower method of string convert 
    # every character into small letter 
    string = string.lower() 

    # calling function 
    check(string) 
```
```q
q)check:{all"aeiou"in lower x}
q)check "geeksforgeeks"
0b
q)check "ABeeIghiObhkUul"
1b
```


## [Count matching characters in two strings](https://www.geeksforgeeks.org/python-count-the-number-of-matching-characters-in-a-pair-of-string/)

```python
# Python code to count number of matching 
# characters in a pair of strings 

# count function 
def count(str1, str2): 
    c, j = 0, 0
    
    # loop executes till length of str1 and 
    # stores value of str1 character by character 
    # and stores in i at each iteration. 
    for i in str1:   
        
        # this will check if character extracted from 
        # str1 is present in str2 or not(str2.find(i) 
        # return -1 if not found otherwise return the 
        # starting occurrence index of that character 
        # in str2) and j == str1.find(i) is used to 
        # avoid the counting of the duplicate characters 
        # present in str1 found in str2 
        if str2.find(i)>= 0 and j == str1.find(i): 
            c += 1
        j += 1
    print ('No. of matching characters are : ', c) 

# Main function 
def main(): 
    str1 ='aabcddekll12@' # first string 
    str2 ='bb2211@55k' # second string 
    count(str1, str2) # calling count function 

# Driver Code 
if __name__=="__main__": 
    main() 
```
```q
q)cmc:{count distinct x where x in y}
q)cmc["aabcddekll12@";"bb22ll@55k"]
5
q)cmc["abcdef";"defghia"]
4
```

The q solution extends easily to a list of strings.

```q
q)cmcl:{count distinct{x where x in y}over x}
q)cmcl("abcdef";"defghia";"dag")
"ad"
```


## [Remove duplicates from a string](https://www.geeksforgeeks.org/remove-duplicates-given-string-python/)

```python
# Python3 program to remove duplicate character 
# from character array and prin sorted 
# order 
def removeDuplicate(str, n): 
    
    # Used as index in the modified string 
    index = 0
    
    # Traverse through all characters 
    for i in range(0, n): 
        
        # Check if str[i] is present before it 
        for j in range(0, i + 1): 
            if (str[i] == str[j]): 
                break
                
        # If not present, then add it to 
        # result. 
        if (j == i): 
            str[index] = str[i] 
            index += 1
            
    return "".join(str[:index]) 

# Driver code 
str= "geeksforgeeks"
n = len(str) 
print(removeDuplicate(list(str), n)) 

# This code is contributed by SHUBHAMSINGH10 

```

Q is a vector language. It has a keyword for this. 

```q
q)distinct "geeksforgeeks"
"geksfor"
```


## [String contains special characters?](https://www.geeksforgeeks.org/python-program-check-string-contains-special-character/)

```python
# Python program to check if a string 
# contains any special character 

# import required package 
import re 

# Function checks if the string 
# contains any special character 
def run(string): 

    # Make own character set and pass 
    # this as argument in compile method 
    regex = re.compile('[@_!#$%^&*()<>?/\|}{~:]') 
    
    # Pass the string in search 
    # method of regex object.    
    if(regex.search(string) == None): 
        print("String is accepted") 
        
    else: 
        print("String is not accepted.") 
    

# Driver Code 
if __name__ == '__main__' : 
    
    # Enter the string 
    string = "Geeks$For$Geeks"
    
    # calling run function 
    run(string) 
```
```q
q)sc:"[@_!#$%^&*()<>?/\\|}{~:]"   / special characters
q)not any sc in "Geeks$For$Geeks"
0b
q)not any sc in "Geeks For Geeks"
1b
```


## [Random strings until a given string is generated](https://www.geeksforgeeks.org/python-program-match-string-random-strings-length/)

```python
# Python program to generate and match 
# the string from all random strings 
# of same length 

# Importing string, random 
# and time modules 
import string 
import random 
import time 

# all possible characters including 
# lowercase, uppercase and special symbols 
possibleCharacters = string.ascii_lowercase + string.digits +
                    string.ascii_uppercase + ' ., !?;:'

# string to be generated 
t = "geek"

# To take input from user 
# t = input(str("Enter your target text: ")) 

attemptThis = ''.join(random.choice(possibleCharacters) 
                                for i in range(len(t))) 
attemptNext = '' 

completed = False
iteration = 0

# Iterate while completed is false 
while completed == False: 
    print(attemptThis) 
    
    attemptNext = '' 
    completed = True
    
    # Fix the index if matches with 
    # the strings to be generated 
    for i in range(len(t)): 
        if attemptThis[i] != t[i]: 
            completed = False
            attemptNext += random.choice(possibleCharacters) 
        else: 
            attemptNext += t[i] 
            
    # increment the iteration 
    iteration += 1
    attemptThis = attemptNext 
    time.sleep(0.1) 

# Driver Code 
print("Target matched after " +
    str(iteration) + " iterations") 
```

The q solution uses [`scan`](../../ref/over.md) to apply a unary lambda successively until the result stops changing. (See the [Converge](../../ref/accumulators.md#converge) iterator.) 

The lambda is defined as a binary, but projected on its first argument (the test string) makes it a unary function.

It finds where the strings do not match (`i`) and [replaces](../../ref) those characters with [random picks](../../ref/deal.md) from possible characters `pc`. 

The [`maxs`](../../ref/max.md) keyword ensures that characters are matched from the left. 
Removing it would speed convergence, as characters could be matched at any position. 

```q
q)show pc:.Q.a,.Q.A,"0123456789 ., !?;:"  / possible characters
"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ., !?;:"

q)/ Generate strings
q)s:{i:where maxs x<>y;@[y;i;:;count[i]?pc]}["GFG";]scan"   "

q)(5#s),("...";"..."),-10#s  / first five, last 10 strings
"   "
" qd"
"ZS2"
"z53"
"uFs"
"..."
"..."
"GF1"
"GFV"
"GFa"
"GFF"
"GFf"
"GF9"
"GF "
"GFy"
"GFZ"
"GFG"
q)count s  / count results, i.e. iterations
143
```


## [Split and join a string](https://www.geeksforgeeks.org/python-program-split-join-string/)

```python
# Python program to split a string and 
# join it using different delimiter 

def split_string(string): 

    # Split the string based on space delimiter 
    list_string = string.split(' ') 
    
    return list_string 

def join_string(list_string): 

    # Join the string based on '-' delimiter 
    string = '-'.join(list_string) 
    
    return string 

# Driver Function 
if __name__ == '__main__': 
    string = 'Geeks for Geeks'
    
    # Splitting a string 
    list_string = split_string(string) 
    print(list_string) 

    # Join list of strings into one 
    new_string = join_string(list_string) 
    print(new_string) 
```
Q is a vector language and has keywords for splitting and joining lists.

```q
q)" "vs"Geeks for geeks"
"Geeks"
"for"
"geeks"

q)" "sv" "vs"Geeks for geeks"
"Geeks for geeks"
```


## [String is a binary?](https://www.geeksforgeeks.org/python-check-if-a-given-string-is-binary-string-or-not/)

```python
# Python program to check 
# if a string is binary or not 

# function for checking the 
# string is accepted or not 
def check(string) : 

    # set function convert string 
    # into set of characters . 
    p = set(string) 

    # declare set of '0', '1' . 
    s = {'0', '1'} 

    # check set p is same as set s 
    # or set p contains only '0' 
    # or set p contains only '1' 
    # or not, if any one condition 
    # is true then string is accepted 
    # otherwise not . 
    if s == p or p == {'0'} or p == {'1'}: 
        print("Yes") 
    else : 
        print("No") 


        
# driver code 
if __name__ == "__main__" : 

    string = "101010000111"

    # function calling 
    check(string) 
```
```q
q){all x in "01"} each ("01010101010";"geeks101")
10b
```


## [Uncommon words from two strings](https://www.geeksforgeeks.org/python-program-to-find-uncommon-words-from-two-strings/)

```python
# Python3 program to find list of uncommon words 

# Function to return all uncommon words 
def UncommonWords(A, B): 

    # count will contain all the word counts 
    count = {} 
    
    # insert words of string A to hash 
    for word in A.split(): 
        count[word] = count.get(word, 0) + 1
    
    # insert words of string B to hash 
    for word in B.split(): 
        count[word] = count.get(word, 0) + 1

    # return required list of words 
    return [word for word in count if count[word] == 1] 

# Driver Code 
A = "Geeks for Geeks"
B = "Learning from Geeks for Geeks"

# Print required answer 
print(UncommonWords(A, B)) 
```
```q
UncommonWords:{
  wds:`$" "vs'(x;y);  / split each string to a word list
  w1s:{{key[x]where 1=value x}count each group x}each wds;  / words that occur once
  raze w1s{x where not x in y}'wds 1 0 / but not in the other string 
  }
```
```q
q)UncommonWords["Geeks for Geeks";"Learning from Geeks for Geeks"]
`Learning`from
q)UncommonWords["apple banana mango";"banana fruits mango"]
`apple`fruits
```


## [Permute a string](https://www.geeksforgeeks.org/permutations-of-a-given-string-using-stl/)

```python
# Function to find permutations of a given string 
from itertools import permutations 

def allPermutations(str): 
    
    # Get all permutations of string 'ABC' 
    permList = permutations(str) 

    # print all permutations 
    for perm in list(permList): 
        print (''.join(perm)) 
        
# Driver program 
if __name__ == "__main__": 
    str = 'ABC'
    allPermutations(str) 
```

We can define permutations of order $N$ recursively.
([`.z.s`](../../ref/dotz.md#zs-self) allows a lambda to refer to itself.)

```q
q)p:{$[x=2;(0 1;1 0);raze(til x)(rotate')\:(x-1),'.z.s x-1]}
q)p 2
0 1
1 0
q)p 3
2 0 1
2 1 0
0 1 2
1 0 2
1 2 0
0 2 1
q){x p count x}"ABC"  / permutations of ABC
"CAB"
"CBA"
"ABC"
"BAC"
"BCA"
"ACB"
```


## [URLs from string](https://www.geeksforgeeks.org/python-check-url-string/)

```python
# Python code to find the URL from an input string 
# Using the regular expression 
import re 

def Find(string): 
    # findall() has been used 
    # with valid conditions for urls in string 
    url = re.findall('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+] 
    |[!*\(\), ]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', string) 
    return url 
    
# Driver Code 
string = 'My Profile: https://auth.geeksforgeeks.org 
/ user / Chinmoy % 20Lenka / articles in
the portal of http://www.geeksforgeeks.org/' 
print("Urls: ", Find(string)) 
```

The Python solution relies on a non-trivial RegEx to match any URL. 
The q solution [looks for](../../ref/ss.md "string search") substring `http` and tests candidates to see whether they begin URLs.

Combining the iterators [Each Left and Each Right `\:/:`](../../ref/maps.md#each-left-and-each-right) allows us to test each of the candidate substrings in `c` against both `http://` and `https://`.

```q
findUrls:{
  begins:{y~count[y]#x};                            / x begins with y?
  c:(x ss "http")_x;                                / candidate substrings
  c:c where any c begins\:/:("http://";"https://"); / continue as URLs?
  {(x?" ")#x}each c }                               / take each up to space  

q)findUrls "My Profile: https://auth.geeksforgeeks.org/user/Chinmoy%20Lenka/articles in the portal of http://www.geeksforgeeks.org/"
"https://auth.geeksforgeeks.org/user/Chinmoy%20Lenka/articles"
"http://www.geeksforgeeks.org/"

q)findUrls "I am a blogger at https://geeksforgeeks.org"
"https://geeksforgeeks.org"
```


## [Rotate a string](https://www.geeksforgeeks.org/string-slicing-python-rotate-string/)

```python
# Function to rotate string left and right by d length 

def rotate(input,d): 

    # slice string in two parts for left and right 
    Lfirst = input[0 : d] 
    Lsecond = input[d :] 
    Rfirst = input[0 : len(input)-d] 
    Rsecond = input[len(input)-d : ] 

    # now concatenate two parts together 
    print "Left Rotation : ", (Lsecond + Lfirst) 
    print "Right Rotation : ", (Rsecond + Rfirst) 

# Driver program 
if __name__ == "__main__": 
    input = 'GeeksforGeeks'
    d=2
    rotate(input,d) 
```

Q is a vector language. It has a keyword for this. 
We use iterator [Each Left `\:`](../../ref/accumulators.md#each-left-and-each-right) to apply it to both test cases.

```q
q)2 -2 rotate\: "GeeksforGeeks"
"eksforGeeksGe"
"ksGeeksforGee"
```


## [Empty string by recursive deletion?](https://www.geeksforgeeks.org/string-slicing-python-check-string-can-become-empty-recursive-deletion/)

```python
# Function to check if a string can become empty 
# by recursively deleting a given sub-string 

def checkEmpty(input, pattern): 
    
    if len(input)== 0: 
        return 'false'

    while (len(input) != 0): 

        # find sub-string in main string 
        index = input.find(pattern) 
            
        # check if sub-string founded or not 
        if (index ==(-1)): 
            return 'false'
            
        # slice input string in two parts and concatenate 
        input = input[0:index] + input[index + len(pattern):]            

    return 'true'

# Driver program 
if __name__ == "__main__": 
    input ='GEEGEEKSKS'
    pattern ='GEEKS'
    print checkEmpty(input, pattern) 
```

The q solution uses the [`over`](../../ref/over.md) keyword to apply a unary string-replacement function successively to the string until the result stops changing.

([`ssr`](../../ref/ss.md#ssr) is a ternary function, but projected onto two arguments – `sub` and the empty string – it is a unary.)

It remains only to count the characters in the result of the last iteration. 

```q
q)checkEmpty:{[str;sub]0=count ssr[;sub;""] over str}
```

The [Left Each `\:`](../../ref/maps.md#left-each-and-right-each) iterator lets us try both our test cases.

```q
q)("GEEGEEKSSGEK";"GEEGEEKSKS") checkEmpty\: "GEEKS"
01b
```


## [Scrape and find ordered words](https://www.geeksforgeeks.org/scraping-and-finding-ordered-words-in-a-dictionary-using-python/)

```python
# Python program to find ordered words 
import requests 

# Scrapes the words from the URL below and stores 
# them in a list 
def getWords(): 

    # contains about 2500 words 
    url = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"
    fetchData = requests.get(url) 

    # extracts the content of the webpage 
    wordList = fetchData.content 

    # decodes the UTF-8 encoded text and splits the 
    # string to turn it into a list of words 
    wordList = wordList.decode("utf-8").split() 

    return wordList 


# function to determine whether a word is ordered or not 
def isOrdered(): 

    # fetching the wordList 
    collection = getWords() 

    # since the first few of the elements of the 
    # dictionary are numbers, getting rid of those 
    # numbers by slicing off the first 17 elements 
    collection = collection[16:] 
    word = '' 

    for word in collection: 
        result = 'Word is ordered'
        i = 0
        l = len(word) - 1

        if (len(word) < 3): # skips the 1 and 2 lettered strings 
            continue

        # traverses through all characters of the word in pairs 
        while i < l:         
            if (ord(word[i]) > ord(word[i+1])): 
                result = 'Word is not ordered'
                break
            else: 
                i += 1

        # only printing the ordered words 
        if (result == 'Word is ordered'): 
            print(word,': ',result) 


# execute isOrdered() function 
if __name__ == '__main__': 
    isOrdered() 
```

The q solution returns the ordered words found in the dictionary.

```q
q)count ud:system"curl http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
25104
q)count ow:`#'ud where{x~asc x}each lower ud
422
q)ow
"1st"
,"a"
"aaa"
"aaas"
"aau"
"abbe"
"abbey"
"abbot"
"abbott"
"abc"
"abe"
"abel"
"abet"
"abo"
"abort"
"ac"
"accent"
"accept"
"access"
"accost"
"ace"
"acm"
..
```


