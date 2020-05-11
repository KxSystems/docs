---
title: The q session | A tour of the q programming language | kdb+ and q documentation
author: Stephen Taylor
description: How to use the q session
date: February 2020
---
# The q session



The q session is a [read-evaluate-print loop](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop "Wikipedia").
It evaluates a q expression and prints the result.
You can use it as a calculator.

```q
q)sum 44.95 1032 107.15
1184.1
q)acos -1
3.141593
```

The q interpreter ignores your comments.

```q
q)2+2 3 4   / add atom to a vector
4 5 6
q)/ Pi is the arc-cosine of -1
q)pi:acos -1
q)pi
3.141593
```

Use [`show`](../../ref/show.md) to set and display a value in one expression.

```q
q)show pi:acos -1
3.141593
```


## Multiline expressions

When you key Enter, the interpreter evaluates what you just typed. 
There is no way in the session for you to write an expression or comment that spans multiple lines.

Scripts permit this.

:fontawesome-regular-hand-point-right:
[Scripts](scripts.md)

## System commands

You can also issue system commands.
For example, to see the current print precision:

```q
q)\P
7i
q)
```

A system command may print to the session, as above, but does not return a result that can be named. To do this, use the [`system`](../../ref/system.md) keyword.

```q
q)show p:system"P"
7i
```

System commands begin with a backslash. 
If what follows is not a q system command, it is passed to the operating system. 

```q
q)\ls -al ~/.
"total 1560"
"drwxr-xr-x+  87 sjt   staff    2784 21 Feb 10:02 ."
"drwxr-xr-x    9 root  admin     288 12 Feb 13:39 .."
"-r--------    1 sjt   staff       7 26 Feb  2018 .CFUserTextEncoding"
"-rw-r--r--@   1 sjt   staff   26628 20 Feb 14:43 .DS_Store"
..
```

!!! warning "Watch out for typos when issuing system commands. They may get executed in the OS."

:fontawesome-solid-book-open:
[System commands](../../basics/syscmds.md)

## Errors

If q cannot evaluate your expression it signals an error. 

```q
q)2+"a"
'type
  [0]  2+"a"
        ^
q)
```

The [error message](../../basics/errors.md) is terse.
If the expression is within a function, the function is suspended, which allows you to investigate the error in the context in which it is evaluated. 

```q
q){x+2} "xyz"
'type
  [1]  {x+2}
         ^
q))/ the extra ) indicates a suspended function

q))x                / x is the function argument
"xyz"
```

Use the Abort system command to cut the stack back one level.

```q
q))\
q)/ the single ) indicates the function is off the stack
q)/ x is now undefined 
q)                  
'x
  [0]  x
       ^
q)
```

:fontawesome-solid-book-open:
[Debugging](../../basics/debug.md),
[Error messages](../../basics/errors.md)


## Command-line options

The q session can be launched with parameters.
The most important is a filename. Q will run it as a [script](scripts.md).

```bash
$ cat hello.q
/
 title: hello-world script in q
 author: librarian@kx.com
 date: February 2020
\
1 "hello world";

exit 0
$
$ q hello.q
KDB+ 3.7t 2020.02.14 Copyright (C) 1993-2020 Kx Systems
m64/ 4()core 8192MB sjt mint.local 192.168.0.11 EXPIRE 2020.04.01 stephen@kx.com #55032

hello world
$
```

Other predefined parameters set the listening port, number of slave tasks allocated, and so on. 

:fontawesome-solid-book-open:
[Command-line options](../../basics/cmdline.md)

Any other parameters are for you to specify and use.

```q
$ q -foo 5432 -bar "quick brown fox"
KDB+ 3.7t 2020.02.14 Copyright (C) 1993-2020 Kx Systems
m64/ 4()core 8192MB sjt mint.local 192.168.0.11 EXPIRE 2020.04.01 stephen@kx.com #55032

q).Q.opt .z.x
foo| "5432"
bar| "quick brown fox"
```

:fontawesome-solid-book:
[`.Q` namespace](../../ref/dotq.md),
[`.z` namespace](../../ref/dotz.md)
<br>
:fontawesome-regular-hand-point-right:
[Scripts](scripts.md)



## Terminate

End your q session with the Terminate system command.

```q
q)\\
$
```