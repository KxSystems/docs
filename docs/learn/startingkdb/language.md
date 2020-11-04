---
title: Q language – Starting kdb+ – Learn – kdb+ and q documentation
description: Introduction to the q programming language
keywords: kdb+, language, q, tutorial
---
# The q language




Q is the programming system for working with kdb+. This corresponds to SQL for traditional databases, but unlike SQL, q is a powerful programming language in its own right.

Q is an interpreted language. Q expressions can be entered and executed in the q console, or loaded from a q script, which is a text file with extension `.q`.

You need at least some familiarity with q to use kdb+. Try following the examples here in the q console interface. Also, ensure that you have installed the [example files](index.md#15-example-files).

The following pages will also be useful:

- [Reference card](../../ref/index.md)
- [Data Types](../../basics/datatypes.md)
- [System Commands](../../basics/syscmds.md)
- [Command Line options](../../basics/cmdline.md)


## Loading q

You load q by changing to the main q directory, then running the q executable. Note that you should not just click the q executable from the file explorer – this will load q but start in the wrong directory.

It is best to create a start-up batch file or script to do this, and there are examples in the `q/start` directory, see `q.bat` (Windows), `q.sh` (Linux) and `q.app` (macOS).

For example, the Windows `q.bat` is:

```dos
c:
cd \q
w32\q.exe %*
```

In Linux/macOS, it is best to call the q executable under [`rlwrap`](../../kb/faq-listbox.md#how-do-i-recall-and-edit-keyboard-input) to support line recall and edit. The Linux `q.sh` script is:

```bash
#!/bin/bash
cd ~/q
rlwrap l32/q "$@"
```


## First steps

Once q is loaded, you can enter expressions for execution:

```q
q)2 + 3
5
q)2 + 3 4 7
5 6 9
```

You can confirm that you are in the `QHOME` directory by calling a directory list command, e.g.

- in Windows:

```q
q)\dir *.q
...
"sp.q"
"trade.q"
...
```

- in Linux/macOS:
    <pre><code class="language-q">
    q)\ls *.q
    ...
    "sp.q"
    "trade.q"
    ...
    </code></pre>

    :fontawesome-regular-hand-point-right: [Command-line parameters](../../basics/cmdline.md) e.g.
    `$ q profile.q -p 5001`

    + loads script `profile.q` at startup. This can in turn load other scripts.
    + sets listening port to 5001

At any prompt, enter `\\` to exit q.


## Console modes

The usual prompt is `q)`. Sometimes a different prompt is given; you need to understand why this is, and how to return to the standard prompt.

1.  If a function is suspended, then the prompt has two or more `)`. In this case, enter a single `\` to remove one level of suspension, and repeat until the prompt becomes `q)`. For example:

    <pre><code class="language-q">
    q)f:{2+x}        / define function f
    q)f \`sym         / function call fails with symbol argument
    {2+x}            / and is left suspended
    'type
    +
    2
    \`sym
    q))\             / prompt becomes q)). Enter \ to return to usual prompt
    q)
    </code></pre>

2.  If there is no suspension, then a single `\` will toggle between q and k modes:

    <pre><code class="language-q">
    q)count each (1 2;"abc")    / q expression for length of each list item
    2 3
    q)\                         / toggle to k mode
      #:'(1 2;"abc")            / equivalent k expression
    2 3
      \                         / toggle back to q mode
    q)
    </code></pre>

3.  If you change namespace, then the prompt includes the namespace.  

    <pre><code class="language-q">
    q)\d .h                     / change to .h namespace
    q.h)\d .                    / change back to default namespace
    q)
    </code></pre>

    :fontawesome-regular-hand-point-right: 
    Basics: [System command `\d`](../../basics/syscmds.md#d-directory)


## Error messages

Error messages are terse. The format is a single quote, followed by error text:

```q
q)1 2 + 10 20 30             / cannot add 2 numbers to 3 numbers
'length
q)2 + "hello"                / cannot add number to character
'type
```

:fontawesome-regular-hand-point-right: 
Basics: [Errors](../../basics/errors.md)


## Introductory examples

To gain experience with the language, enter the following examples and explain the results. Also experiment with similar expressions.

```q
q)x:2 5 4 7 5
q)x
2 5 4 7 5
q)count x
5
q)8 # x
2 5 4 7 5 2 5 4
q)2 3 # x
2 5 4
7 5 2
q)sum x
23
q)sums x
2 7 11 18 23
q)distinct x
2 5 4 7
q)reverse x
5 7 4 5 2
q)x within 4 10
01111b
q)x where x within 4 10
5 4 7 5
q)y:(x;"abc")             / list of lists
q)y
2 5 4 7 5
"abc"
q)count y
2
q)count each y
5 3
```

The following is a function definition, where `x` represents the argument:

```q
q)f:{2 + 3 * x}
q)f 5
17
q)f til 5
2 5 8 11 14
```

Q makes essential use of a symbol datatype:

```q
q)a:`toronto        / symbol
q)b:"toronto"       / character string
q)count a
1
q)count b
7
q)a="o"
`type
q)b="o"
0101001b
q)a~b               / a is not the same as b
0b
q)a~`$b             / `$b converts b to symbol
1b
```


## Data structures

Q basic data structures are atoms (singletons) and lists. Other data structures like dictionaries and tables are built from lists. For example, a simple table is just a list of column names associated with a list of corresponding column values, each of which is a list.

```q
q)item:`nut                 / atom (singleton)

q)items:`nut`bolt`cam`cog   / list
q)sales: 6 8 0 3            / list
q)prices: 10 20 15 20       / list

q)(items;sales;prices)      / list of lists
nut bolt cam cog
6   8    0   3
10  20   15  20

q)dict:`items`sales`prices!(items;sales;prices) / dictionary
q)dict
items | nut bolt cam cog
sales | 6   8    0   3
prices| 10  20   15  20

q)tab:([]items;sales;prices)                   / table
q)tab
items sales prices
------------------
nut   6     10
bolt  8     20
cam   0     15
cog   3     20
```

Note that a table is a `flip` (transpose) of a dictionary:

```q
q)flip dict
items sales prices
------------------
nut   6     10
bolt  8     20
cam   0     15
cog   3     20
```

The table created above is an ordinary variable in the q workspace, and could be written to disk. In general, you create tables in memory and then write to disk.

Since it is a table, you can use SQL-like query expressions on it:

```q
q)select from tab where prices < 20
items sales prices
------------------
nut   6     10
cam   0     15
```

Since it is an ordinary variable, you can also index it and do other typical data manipulations:

```q
q)tab 1 3                 / index rows 1 and 3
items sales prices
------------------
bolt  8     20
cog   3     20

q)tab `sales              / index column sales
6 8 0 3

q)tab, tab                / join two copies
items sales prices
------------------
nut   6     10
bolt  8     20
cam   0     15
cog   3     20
nut   6     10
bolt  8     20
cam   0     15
cog   3     20
```

A _keyed table_ has one or more columns as keys:

```q
q)1!tab                   / keyed table
items| sales prices
-----| ------------
nut  | 6     10
bolt | 8     20
cam  | 0     15
cog  | 3     20
```


## Functions, operators, keywords, iterators

All functions take arguments on their right in brackets. Operators can also take arguments on left and right, as in `2+2` (infix syntax). [Iterators](../../ref/iterators.md) take [value](../../basics/glossary.md#applicable-value) arguments on their left (postfix syntax) and return derived functions. 

```q
q)sales * prices                 / operator: *
60 160 0 60
q)sum sales * prices             / keyword: sum
280
q)sumamt:{sum x*y}               / define lambda: sumamt
q)sumamt[sales;prices]
280

q)(sum sales*prices) % sum sales / calculate weighted average
16.47059
q)sales wavg prices              / keyword: wavg
16.47059

q)sales , prices                 / operator: , join lists
6 8 0 3 10 20 15 20
q)sales ,' prices                / iterator: ' join lists in pairs
6 10
8 20
0 15
3 20
```

Functions can apply to dictionaries and tables:

```q
q)-2 # tab
items sales prices
------------------
cam   0     15
cog   3     20
```

Functions can be used within queries:

```q
q)select items,sales,prices,amount:sales*prices from tab
items sales prices amount
-------------------------
nut   6     10     60
bolt  8     20     160
cam   0     15     0
cog   3     20     60
```


## Scripts

A q script is a plain text file with extension `.q`, which contains q expressions that are executed when loaded.

For example, load the script `sp.q` and display the `s` table that it defines:

```q
q)\l sp.q                                / load script

q)s                                      / display table s
s | name  status city
--| -------------------
s1| smith 20     london
s2| jones 10     paris
s3| blake 30     paris
s4| clark 20     london
s5| adams 30     athens
```

Within a script, a line that contains a single `/` starts a comment block. A line with a single `\` ends the comment block, or if none, exits the script.

A script can contain multi-line definitions. Any line that is indented is taken to be a continuation of the previous line. Blank lines, superfluous blanks, and lines that are comments (begin with `/`) are ignored in determining this. For example, if a script has contents:

```q
a:1 2

/ this is a comment line

 3
    + 4

b:"abc"
```

Then loading this script would define `a` and `b` as:

```q
q)a
5 6 7                / i.e. 1 2 3 + 4
q)b
"abc"
```

!!! warning "Multi-line function definitions"

    In scripts, indentation allows function definitions to span multiple lines. 

    <pre><code class="language-q">
    fn:{[x,y]
      a:x*2.5;
      b:x+til floor y;
      a & b}
    </code></pre>

    The convention entails that in a multi-line definition **the closing brace must also be indented**.
    It is less likely to get misplaced if suffixed to the last line.


## Q queries

Q queries are similar to SQL, though often much simpler.

```q
\l sp.q

q)select from p where weight=17
p | name color weight city
--| ------------------------
p2| bolt green 17 paris
p3| screw blue 17 rome
```

SQL statements can be entered, if prefixed with `s)`.

```q
q)s)select * from p where color in (red,green)  / SQL query
p | name  color weight city
--| -------------------------
p1| nut   red   12     london
p2| bolt  green 17     paris
p4| screw red   14     london
p6| cog   red   19     london
```

The q equivalent would be:

```q
q)select from p where color in `red`green
```

Similarly, compare:

```q
q)select distinct p,s.city from sp
s)select distinct sp.p,s.city from sp,s where sp.s=s.s
```

and

```q
q)select from sp where s.city=p.city
s)select sp.s,sp.p,sp.qty from s,p,sp where sp.s=s.s
    and sp.p=p.p and p.city=s.city
```

Note that the dot notation in q automatically references the appropriate table.

Q results can have lists in the rows.

```q
q)select qty by s from sp
s | qty
--| -----------------------
s1| 300 200 400 200 100 400
s2| 300 400
s3| ,200
s4| 100 200 300
```

`ungroup` will flatten the result.

```q
q)ungroup select qty by s from sp
s qty
------
s1 300
s1 200
s1 400
s1 200
...
```

Calculations can be performed on the intermediate results.

```q
q)select countqty:count qty,sumqty:sum qty by p from sp
p | countqty sumqty
--| ---------------
p1| 2        600
p2| 4        1000
p3| 1        400
p4| 2        500
p5| 2        500
p6| 1        100
```

