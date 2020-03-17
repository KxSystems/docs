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

The q versions focus on the calculation and set aside formatting as a distraction. The terse presentation offers some insight into how vector programmers actually think. 

`1+til 5` gives us the integers 1-5; `prd` their product.

```q
q)fac:{prd 1+til x}   / factorial
q)fac 5
120
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

Principal, rate and time are three numbers. The result is one hundredth of their product.

```q
q)(prd 10000 5 5)%100   / principal, rate, time
2500f
```

Iteration is implicit in most q operators. 
We can write a function of conformable lists. 
Here we have one rate for three principals and time periods.

```q
q)si:{[p;r;t] (p*r*t)%100}  /simple interest
q)si[1000 1500 1750;3;5 6 7]
150 270 367.5
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
q)ci:{[p;r;t] p*(1+r%100)xexp t}  / compound interest
q)ci[1200;5.4;2]
1333.099
```

Again, iteration through lists is implicit.

```q
q)ci[1200 1500 1800;5.4;2 2 3]
1333.099 1666.374 2107.63
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

`10 vs x` decodes base-10 integer `x` into a list of digits; `x xexp count x` raises them to the power of the length of the list. 

```q
q)isArmstrong:{x=sum{x xexp count x}{10 vs x}x}
q)isArmstrong each 153 120 1253 1634
1001b
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

Pi is the arc-cosine of -1. 

```q
q)acr:{x*x*acos -1}            / area of circle of radius x
q)acr 5
78.53982
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

Range is a useful construct.

```q
q)rg:{x+til y-x-1}          / range
q)rg[11;25]
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
```

The Python program overcomputes. It is not necessary to test division by all numbers from 2 to `val`. One can stop at the square root of `val`.

For each number in the list `x`, check its modulo for integers in the range (2, `sqrt last x`).
`x mod/:y` returns the modulo of `x` for each divisor in `y`.

```q
q){x where all 0<x mod/:rg[2;]"j"$sqrt last x}rg[11;25]
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
q)rg:{x+til y-x-1}          / range
q)isPrime:{(x>1)and all 0<x mod rg[2;]"j"$sqrt x}
q)isPrime each 11 15 1
100b
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

We can generate the Fibonacci series as a sequence of pairs: we do not need to retain the entire list.

```q
q)nf:{(x 1),sum x}
q)nf 0 1
1 1

q)Fibonacci:{last(x-2)nf/0 1}
q)Fibonacci 9
21
```

Above we see the `nf` applied with the [Do iterator `/`](../../ref/accumulators.md#do).


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

We already have `nf:{(x 1),sum x}` to generate pairs of the Fibonacci series. With a test function to check whether it is a multiple, we can apply it with the [While iterator `\`](../../ref/accumulators.md#while), and count how many iterations there were.

```q
q)findPosition:{[k;n]n*count {0<(x 1)mod y}[;k] nf\0 1}
q)findPosition'[2 4;3 5]  / 3rd and 5th ocurrences of multiples of 2 and 4
30
```

The binary function `{0<(x 1)mod y}` confirms that the second number of the latest Fibonacci pair `x` is not a multiple of `y`. 
By projecting it onto `k` we get a unary function for the While iterator. 


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

Casting a character to long int returns its ASCII code.

```q
q)"j"$"g"
103
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

Once again, implicit iteration in the q operators make looping unnecessary.

```q
q)squaresum:{"j"$(x*(x+1)%2)*(1+x*2)%3}
q)squaresum 4 5
30 55
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

Below, we use the functional conditional [Cond](../../ref/cond.md), then [Cast](../../ref/cast.md) the result to long and square it. Both Cond and Cast are overloads of `$`.

```q
sumOfSeries:{
  n:x+1;
  {x*x}"j"$$[x mod 2;n*x%2;x*n%2] }

q)sumOfSeries each 5 7
225 784
```

