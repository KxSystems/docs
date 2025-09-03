---
title: Signal | Reference | kdb+ and q documentation
description: Signal is a q operator that signals an error. 
author: Stephen Taylor
---
# `'` Signal




_Signal an error_

```syntax
'x
```

where `x` is a symbol atom or string, aborts evaluation and passes `x` to the interpreter as a string.

```q
q)0N!0;'`err;0N!1
0
'err
```

!!! info "Signal is part of q syntax. It is not an operator and cannot be iterated or projected."

:fontawesome-solid-book:
[`'` Quote overloads](overloads.md#quote)

The only way to detect a signal is to use [Trap](apply.md#trap).

```q
q)f:{@[{'x};x;{"trap:",x}]}
q)f`err
"trap:err"
```

Trap always receives a string regardless of the type of `x`.


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

At any point during execution, the behavior of _signal_ (`'`) is determined by the internal error-trap mode:

<div markdown="1" class="typewriter">
0   abort execution (set by [Trap or Trap At](apply.md#trap)) 
1   suspend execution and run the debugger
2   collect stack trace and abort (set by [.Q.trp](dotq.md#trp-extend-trap-at))
</div>

During abort, the stack is unwound as far as the nearest [trap at](apply.md#trap-at) (`@` or `.` or [`.Q.trp`](dotq.md#trp-extend-trap-at)). The error-trap mode is always initially set to 

```txt
1  for console input
0  for sync message processing
```

[`\e`](../basics/syscmds.md#e-error-trap-clients) sets the mode applied before async and HTTP callbacks run. Thus, `\e 1` will cause the relevant handlers to break into the debugger, while `\e 2` will dump the backtrace either to the server console (for async), or into the socket (for HTTP).
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

## Debugger break location

The signal operation breaks out of the stack frame of the current function and causes the debugger to break one level up in the stack (or not break in the debugger at all if the signalling function was invoked at the top level of the interpreter).

```q
q)f:{'`bad}
q)f[]
'bad
  [0]  f[]
       ^
q)g:{f[]}
q)g[]
'bad
  [2]  f:{'`bad}
          ^
  [1]  g:{f[]}
          ^
q)).z.s
{f[]}
```

This may make debugging functions problematic, since the parameters and local variables of the function are no longer available:

```q
q)f:{[x]a:1;if[x<a;'`bad]}
q)g:{f[x]}
q)g[0]
'bad
  [2]  f:{[x]a:1;if[x<a;'`bad]}
                        ^
  [1]  g:{f[x]}
          ^
q))a
'a
  [3]  a
       ^
```

To make it easier to debug a complex function, it is recommended to wrap the signal operator in a small inner function such that the up-one-level behavior is canceled out:

```q
q)f:{[x]a:1;if[x<a;{'x}`bad]}

q)g[0]
'bad
  [3]  f@:{'x}
           ^
  [2]  f:{[x]a:1;if[x<a;{'x}`bad]}
                        ^
q)).z.s
{[x]a:1;if[x<a;{'x}`bad]}
q))x
0
q))a
1
```

----
:fontawesome-solid-book:
[Trap, Trap At](apply.md#trap) 
<br>
:fontawesome-solid-book-open:
[Controlling evaluation](../basics/control.md),
[Debugging](../basics/debug.md),
[Error handling](../basics/errors.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.7 Return and Signal](/q4m3/10_Execution_Control/#1017-return-and-signal)
