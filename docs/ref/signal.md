---
title: Signal
description: Signal is a q operator that signals an error. 
author: Stephen Taylor
keywords: error, exception, kdb+, message, q, signal
---
# `'` Signal




_Signal an error_

Syntax: `'x`

where `x` is a symbol atom or string, aborts evaluation and passes `x` to the interpreter as a string.

```q
q)0N!0;'`err;0N!1
0
'err
```

The only way to detect a signal is to use [Trap](apply.md#trap).

```q
q)f:{@[{'x};x;{"trap:",x}]}
q)f`err
"trap:err"
```

Trap always receives a string regardless of the type of `x`.

!!! warning "Bracket notation"

    The quote glyph is [overloaded](overloads.md#quote). 
    This makes Signal an exception to the rule that all functions can be applied with bracket notation. 
    The form `'[x]` returns a projection of the iterator [Each](maps.md#each).


## Restrictions

```q
q)f 1         / signals a type error indicating ' will not signal a number
"trap:stype"
q)f"a"        /q will not signal a char
"trap:stype"
```

Using an undefined word signals the word as an error:

```q
q)'word
'word
```

which is indistinguishable from

```q
q)word
'word
```


## Error-trap modes

At any point during execution, the behaviour of _signal_ (`'`) is determined by the internal error-trap mode:

mode | behavior
:---:|------------------------------------------------
0    | abort execution (set by _trap_ `@` or `.`)
1    | suspend execution and run the debugger
2    | collect stack trace and abort (set by `.Q.trp`)

During abort, the stack is unwound up to the nearest [trap](apply.md#trap) (`@` or `.` or [`.Q.trp`](dotq.md#qtrp-extend-trap)). The error-trap mode is always initially set to 

-   1 for console input
-   0 for sync message processing

`\e` sets the mode applied before async and HTTP callbacks run. Thus, `\e 1` will cause the relevant handlers to break into the debugger, while `\e 2` will dump the backtrace either to the server console (for async), or into the socket (for HTTP).
```q
q)\e 2
q)'type             / incoming async msg signals 'type
  [2]  f@:{x*y}
            ^
  [1]  f:{{x*y}[x;3#x]}
          ^
  [0]  f `a
       ^
q)\e 1
q)'type             
  [2]  f@:{x*y}
            ^
q))                 / the server is suspended in a debug session
```



<i class="far fa-hand-point-right"></i> 
[Trap, Trap At](apply.md#trap)  
Basics: [Control](../basics/control.md),
[Debugging](../basics/debug.md),
[Error handling](../basics/errors.md)