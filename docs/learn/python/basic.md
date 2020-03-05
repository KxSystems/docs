---
title: Q versions of Python programming examples| Documentation for kdb+ and q
description: Python programming examples and their q equivalents
author: Stephen Taylor
date: February 2020
hero: <i class="fab fa-python"></i> Python programming examples in q
---
# Basic programs

From
<i class="fas fa-globe"></i>
GeeksforGeeks [Python Programming Examples](https://www.geeksforgeeks.org/python-programming-examples/)

Follow links to the originals for more details on the problem and the Python solution/s.


### [Add two numbers](https://www.geeksforgeeks.org/python-program-to-add-two-numbers/)

```python
# Python3 program to add two numbers

num1 = 15
num2 = 12

# Adding two nos
sum = num1 + num2

# printing values
print("Sum of {0} and {1} is {2}" .format(num1, num2, sum))
```
```q
q:n:15 12  / two numbers
q){"Sum of ",x," and ",y," is ",z) . string n,sum n
"Sum of 15 and 12 is 27"
```


### [Factorial of a number](https://www.geeksforgeeks.org/python-program-for-factorial-of-a-number/)

```python
# Python 3 program to find
# factorial of given number
def factorial(n):

    # single line to find factorial
    return 1 if (n==1 or n==0) else n * factorial(n - 1);

# Driver Code
num = 5;
print("Factorial of",num,"is",
factorial(num))

# This code is contributed by Smitha Dinesh Semwal
```
```q
q){"Factorial of ",x," is ",y}. string{x,prd 1+til x}5
"Factorial of 5 is 120"
```


### [Simple interest](https://www.geeksforgeeks.org/python-program-for-simple-interest/)

```python
# Python3 program to find simple interest
# for given principal amount, time and
# rate of interest.

# We can change values here for
# different inputs
P = 1
R = 1
T = 1

# Calculates simple interest
SI = (P * R * T) / 100

# Print the resultant value of SI
print("simple interest is", SI)

# This code is contributed by Azkia Anam.
```
```q
q)prt:1 1 1  / principal, rate, time
q)"simple interest is ",string prd[prt]%100
"simple interest is 0.01"
```


### [Compound interest](https://www.geeksforgeeks.org/python-program-for-compound-interest/)

```python
# Python3 program to find compound
# interest for given values.

def compound_interest(principle, rate, time):

    # Calculates compound interest
    CI = principle * (pow((1 + rate / 100), time))
    print("Compound interest is", CI)

# Driver Code
compound_interest(10000, 10.25, 5)

# This code is contributed by Abhishek Agrawal.
```
```q
compound_interest:{[p;r;t]
  "compound interest is ",string{p*(1+r%100)xexp t }

q)compound_interest[10000;10.25;5]
"compound interest is 16288.95"
```


### [Armstrong number](https://www.geeksforgeeks.org/python-program-to-check-armstrong-number/)

```python
# Python program to determine whether the number is
# Armstrong number or not

# Function to calculate x raised to the power y
def power(x, y):
    if y==0:
        return 1
    if y%2==0:
        return power(x, y/2)*power(x, y/2)
    return x*power(x, y/2)*power(x, y/2)

# Function to calculate order of the number
def order(x):

    # variable to store of the number
    n = 0
    while (x!=0):
        n = n+1
        x = x/10
    return n

# Function to check whether the given number is
# Armstrong number or not
def isArmstrong (x):
    n = order(x)
    temp = x
    sum1 = 0
    while (temp!=0):
        r = temp%10
        sum1 = sum1 + power(r, n)
        temp = temp/10

    # If condition satisfies
    return (sum1 == x)


# Driver Program
x = 153
print(isArmstrong(x))
x = 1253
print(isArmstrong(x))
```
```q
isArmstrong:{x=sum{x xexp count x}{10 vs x}x}

q)isArmstrong each 153 1253
10b
```


### [Area of a circle](https://www.geeksforgeeks.org/python-program-for-program-to-find-area-of-a-circle/)

```python
# Python program to find Area of a circle

def findArea(r):
    PI = 3.142
    return PI * (r*r);

# Driver method
print("Area is %.6f" % findArea(5));

# This code is contributed by Chinmoy Lenka
```
```q
findArea:{(acos -1)*x*x}            / Pi is arc-cosine of -1

q)"Area is ",string findArea 5
"Area is 78.53982"
```


### [Prime numbers in an interval](https://www.geeksforgeeks.org/python-program-to-print-all-prime-numbers-in-an-interval/)

```python
# Python program to print all
# prime number in an interval

start = 11
end = 25

for val in range(start, end + 1):

# If num is divisible by any number
# between 2 and val, it is not prime
if val > 1:
    for n in range(2, val):
        if (val % n) == 0:
            break
    else:
        print(val)
```
```q
q)r:{x _ til y+1}[11;25]  / range
q){x where all{x<>floor x}x%\:/:1_1+til"j"$sqrt last x}r
11 13 17 19 23
```


### [Whether a number is prime](https://www.geeksforgeeks.org/python-program-to-check-whether-a-number-is-prime-or-not/)

```python
# A optimized school method based
# Python3 program to check
# if a number is prime


def isPrime(n) :

    # Corner cases
    if (n <= 1) :
        return False
    if (n <= 3) :
        return True

    # This is checked so that we can skip
    # middle five numbers in below loop
    if (n % 2 == 0 or n % 3 == 0) :
        return False

    i = 5
    while(i * i <= n) :
        if (n % i == 0 or n % (i + 2) == 0) :
            return False
        i = i + 6

    return True


# Driver Program
if (isPrime(11)) :
    print(" true")
else :
    print(" false")

if(isPrime(15)) :
    print(" true")
else :
    print(" false")


# This code is contributed
# by Nikita Tiwari.
```
```q
isPrime:{
  isInt:{x=floor x};            / is integer
  d:1_1+til ceiling sqrt x;     / divisors
  `true`false any isInt x%d }

q)isPrime each 11 15
`true`false
```


### [Nth Fibonacci number](https://www.geeksforgeeks.org/python-program-for-n-th-fibonacci-number/)

```python
# Function for nth Fibonacci number

def Fibonacci(n):
    if n<0:
        print("Incorrect input")
    # First Fibonacci number is 0
    elif n==1:
        return 0
    # Second Fibonacci number is 1
    elif n==2:
        return 1
    else:
        return Fibonacci(n-1)+Fibonacci(n-2)

# Driver Program

print(Fibonacci(9))

#This code is contributed by Saket Modi
```
```q
Fibonacci:{last(x-2){last[x],sum -2#x}/0 1}

q)Fibonacci 9
21
```


### [Whether a Fibonacci number](https://www.geeksforgeeks.org/python-program-for-how-to-check-if-a-given-number-is-fibonacci-number/)

```python
# python program to check if x is a perfect square
import math

# A utility function that returns true if x is perfect square
def isPerfectSquare(x):
    s = int(math.sqrt(x))
    return s*s == x

# Returns true if n is a Fibinacci Number, else false
def isFibonacci(n):

    # n is Fibinacci if one of 5*n*n + 4 or 5*n*n - 4 or both
    # is a perferct square
    return isPerfectSquare(5*n*n + 4) or isPerfectSquare(5*n*n - 4)

# A utility function to test above functions
for i in range(1,11):
    if (isFibonacci(i) == True):
        print i,"is a Fibonacci Number"
    else:
        print i,"is a not Fibonacci Number "
```
```q
isPerfectSquare:{x={x*x}"j"$sqrt x}
isFibonacci:{.[or]isPerfectSquare flip 4 -4+/:5*x*x}

q}show n:1+til 10                           / first ten integers
1 2 3 4 5 6 7 8 9 10
q)isFibonacci n                             / are they Fibonacci numbers?
1110100100b
```


### [Nth multiple of a Fibonacci number](https://www.geeksforgeeks.org/python-program-for-nth-multiple-of-a-number-in-fibonacci-series/)

```python
# Python Program to find position of n\'th multiple
# of a mumber k in Fibonacci Series

def findPosition(k, n):
    f1 = 0
    f2 = 1
    i =2;
    while i!=0:
        f3 = f1 + f2;
        f1 = f2;
        f2 = f3;

        if f2%k == 0:
            return n*i

        i+=1

    return


# Multiple no.
n = 5;
# Number of whose multiple we are finding
k = 4;

print("Position of n\'th multiple of k in"
                "Fibonacci Seires is", findPosition(k,n));

# Code contributed by Mohit Gupta_OMG
```
```q
findPosition:{[k;n]
  ii:{x=floor x};                           / is integer?
  im:{ii y%x};                              / is y multiple of x?
  nf:{last[x],sum x};                       / next Fibonacci pair
  n*count{not im[x]last y}[k;]nf\0 1 }

q)"Position of 5th multiple of 4 in Fibonacci series is ",string findPosition[4;5]
"Position of 5th multiple of 4 in Fibonacci series is 30"
```


### [ASCII value of a character](https://www.geeksforgeeks.org/program-print-ascii-value-character/)

```python
# Python program to print
# ASCII Value of Character

# In c we can assign different
# characters of which we want ASCII value

c = 'g'
# print the ASCII value of assigned character in c
print("The ASCII value of '" + c + "' is", ord(c))
```
```q
q){"The ASCII value of ",x," is ",string"j"$x}"g"
"The ASCII value of g is 103"
```


### [Sum of squares of first N natural numbers](https://www.geeksforgeeks.org/python-program-for-sum-of-squares-of-first-n-natural-numbers/)

```python
# Python Program to find sum of square of first
# n natural numbers. This program avoids
# overflow upto some extent for large value
# of n.y

def squaresum(n):
    return (n * (n + 1) / 2) * (2 * n + 1) / 3

# main()
n = 4
print(squaresum(n));

# Code Contributed by Mohit Gupta_OMG <(0_o)>
```
```q
q)squaresum:{"j"$(x*(x+1)%2)*(1+x*2)%3}
q)squaresum 4
30
```


### [Cube sum of first N natural numbers](https://www.geeksforgeeks.org/python-program-for-program-for-cube-sum-of-first-n-natural-numbers/)

```python
# Efficient Python program to find sum of cubes
# of first n natural numbers that avoids
# overflow if result is going to be withing
# limits.

# Returns the sum of series
def sumOfSeries(n):
    x = 0
    if n % 2 == 0 :
        x = (n/2) * (n+1)
    else:
        x = ((n + 1) / 2) * n

    return (int)(x * x)


# Driver Function
n = 5
print(sumOfSeries(n))

# Code Contributed by Mohit Gupta_OMG <(0_o)>
```
```q
sumOfSeries:{
  n:x+1;
  {x*x}"j"$$[x mod 2;n*x%2;x*n%2] }

q)sumOfSeries 5
225
```

