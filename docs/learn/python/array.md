---
title: Q versions of Python programming examples| Documentation for kdb+ and q
description: Python programming examples and their q equivalents
author: Stephen Taylor
date: February 2020
hero: <i class="fab fa-python"></i> Python programming examples in q
---
# Array programs


From
<i class="fas fa-globe"></i>
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and the Python solution/s.


## [Sum of an array](https://www.geeksforgeeks.org/python-program-to-find-sum-of-array/)

```python
# Python 3 code to find sum 
# of elements in given array 
def _sum(arr,n): 
    
    # return sum using sum 
    # inbuilt sum() function 
    return(sum(arr)) 

# driver function 
arr=[] 
# input values to list 
arr = [12, 3, 4, 15] 

# calculating length of array 
n = len(arr) 

ans = _sum(arr,n) 

# display sum 
print (\'Sum of the array is \',ans) 

# This code is contributed by Himanshu Ranjan 
```
```q
q)sum 12 3 4 15
34
```


## [Largest item in an array](https://www.geeksforgeeks.org/python-program-to-find-largest-element-in-an-array/)

```python
# Python3 program to find maximum 
# in arr[] of size n 

# python function to find maximum 
# in arr[] of size n 
def largest(arr,n): 

    # Initialize maximum element 
    max = arr[0] 

    # Traverse array elements from second 
    # and compare every element with 
    # current max 
    for i in range(1, n): 
        if arr[i] > max: 
            max = arr[i] 
    return max

# Driver Code 
arr = [10, 324, 45, 90, 9808] 
n = len(arr) 
Ans = largest(arr,n) 
print ("Largest in given array is",Ans) 

# This code is contributed by Smitha Dinesh Semwal 
```
```q
q)max 10 324 45 90 9808
9808
```


## [Rotate an array](https://www.geeksforgeeks.org/python-program-for-program-for-array-rotation-2/)

```python
#Function to left rotate arr[] of size n by d 
def leftRotate(arr, d, n): 
    for i in range(gcd(d,n)): 
        
        # move i-th values of blocks 
        temp = arr[i] 
        j = i 
        while 1: 
            k = j + d 
            if k >= n: 
                k = k - n 
            if k == i: 
                break
            arr[j] = arr[k] 
            j = k 
        arr[j] = temp 

#UTILITY FUNCTIONS 
#function to print an array 
def printArray(arr, size): 
    for i in range(size): 
        print ("%d" % arr[i], end=" ") 

#Function to get gcd of a and b 
def gcd(a, b): 
    if b == 0: 
        return a; 
    else: 
        return gcd(b, a%b) 

# Driver program to test above functions 
arr = [1, 2, 3, 4, 5, 6, 7] 
leftRotate(arr, 2, 7) 
printArray(arr, 7) 

# This code is contributed by Shreyanshi Arun 
```
```q
q)2 rotate 1 2 3 4 5 6 7
3 4 5 6 7 1 2
```


## [Remainder of array multiplication divided by n](https://www.geeksforgeeks.org/python-program-for-find-reminder-of-array-multiplication-divided-by-n/)

```python
# Python3 program to 
# find remainder when 
# all array elements 
# are multiplied. 

# Find remainder of arr[0] * arr[1] 
# * .. * arr[n-1] 
def findremainder(arr, lens, n): 
    mul = 1

    # find the individual 
    # remainder and 
    # multiple with mul. 
    for i in range(lens): 
        mul = (mul * (arr[i] % n)) % n 
    
    return mul % n 

# Driven code 
arr = [ 100, 10, 5, 25, 35, 14 ] 
lens = len(arr) 
n = 11

# print the remainder 
# of after multiple 
# all the numbers 
print( findremainder(arr, lens, n)) 

# This code is contributed by "rishabh_jain". 
```
```q
q)(prd 100 10 5 25 35 14) mod 11        / naive solution
9
q){(x*y)mod 11}/[100 10 5 25 35 14]     / dry solution (avoids overflow)
9
```


## [Reconstruct array, replacing `arr[i]` with `(arr[i-1]+1)%M`](https://www.geeksforgeeks.org/reconstruct-the-array-by-replacing-arri-with-arri-11-m/)

```python
# Python implementation of the above approach 
def construct(n, m, a): 
    ind = 0

    # Finding the index which is not -1 
    for i in range(n): 
        if (a[i]!=-1): 
            ind = i 
            break

    # Calculating the values of the indexes ind-1 to 0 
    for i in range(ind-1, -1, -1): 
        if (a[i]==-1): 
            a[i]=(a[i + 1]-1 + m)% m 

    # Calculating the values of the indexes ind + 1 to n 
    for i in range(ind + 1, n): 
        if(a[i]==-1): 
            a[i]=(a[i-1]+1)% m 
    print(*a) 

# Driver code 
n, m = 6, 7
a =[5, -1, -1, 1, 2, 3] 
construct(n, m, a) 
```
```q
/ q implementation of the above approach
construct:{[v;M]
  i:where v=-1;                 / find targets in v
  f:{(1+x)mod z}[;;M];          / reduction fn
  v[i]:(v first[i]-1)f\v i;     / apply f with accumulator
  v }
```
```q
q)construct[5 -1 -1 1 2 3;7]
5 6 0 1 2 3
q)construct[5 -1 7 -1 9 0;10]
5 6 7 8 9 0
```


## [Is array monotonic?](https://www.geeksforgeeks.org/python-program-to-check-if-given-array-is-monotonic/)

```python
# Python3 program to find sum in Nth group 

# Check if given array is Monotonic 
def isMonotonic(A): 

    return (all(A[i] <= A[i + 1] for i in range(len(A) - 1)) or
            all(A[i] >= A[i + 1] for i in range(len(A) - 1))) 

# Driver program 
A = [6, 5, 4, 4] 

# Print required result 
print(isMonotonic(A)) 

# This code is written by 
# Sanjit_Prasad 
```
```q
q)isMonotonic:{x in(asc x;desc x)}  / match itself sorted up or down?

q)isMonotonic 6 5 4 4
1b
q)isMonotonic 6 5 3 4
0b
```

