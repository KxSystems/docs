---
title: Debugging in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Debugging in q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Appendix 5: Debugging in q




One of the joys of writing in any interpreted language is that debugging is far easier than in a compiled language. The reason is simple: an error stops execution and allows you to discover the values of variables and to go up the procedure calling stack.

Here is a recursive factorial program.

```q
q)myfact:{[n] $[n < 1; 1; n*myfact n-1 ]} 
q)myfact 6
720                 
q)myfact `q
'type
  [1]  myfact:{[n] $[n < 1; 1; n*myfact n-1 ]}
                       ^
q))
q))n
`q
q))\                    / abort       
q)n
'n
  [0]  n
       ^
```

When evaluation suspended, the failed operation was indicated.
The next prompt has an extra parenthesis to mark the suspension: `q))`.

The variable `n` is local to `myfac`: it has value only during evaluation.
The suspension makes it possible to see the most-local value of `n`.

The Abort system command `\` cleared the suspension.
The prompt reverted to `q)` and `n` no longer had a value.

There are more tools available for debugging.

<i class="fas fa-book-open"></i>
[Debugging](../../basics/debug.md)

---
<i class="far fa-hand-point-right"></i>
[Namespaces](namespace.md)