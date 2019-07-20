---
title: Debugging
description: Facilities for debugging q programs
author: Stephen Taylor
keywords: debug, errors, kdb+, q, trap
---
# Debugging 






## Errors

Uncaught errors are printed as follows (without the comments). Since V3.5. 

```q
q)2+"hi"
'type           / error string
  [0]  2+"hi"   / stack frame index and source code
        ^       / caret indicates the primitive that failed
```

This will be augmented with file:line and function name, if such information is available.

```q
q)myfun"hi"    / myfun defined in test.q and loaded with \l
'type
  [1]  /kdb+3.5/test.q:5: myfun:{2+x} / note the full path name
                                  ^
```

Nested anonymous lambdas will inherit their enclosing function's name with the `@` suffix.

```q
q)f0:{{("hi";x+y)}[x*2;"there"]}
q)f0[2]
'type
  [2]  f0@:{("hi";x+y)}
                   ^
q)\
```


## Debugger

Usually when an error happens inside a lambda the execution is suspended and you enter the debugger, as indicated by the additional `)` following the normal
`q)` prompt.

```q
q)f:{g[x;2#y]}
q)g:{a:x*2;a+y}
q)f[3;"hello"]
'type
  [2]  g:{a:x*2;a+y}
                 ^
q))
```

The debug prompt allows operating on values defined in the local scope.

```q
q))a*4
24
```

You can use `` ` `` and `.` freely to navigate up and down the stack.

```q
q))` / up
  [1]  f:{g[x;2#y]}
          ^
q))`
  [0]  f[3;"hello"]
       ^
q)). / down
  [1]  f:{g[x;2#y]}
         ^
q))
```

In a debugger session, `.z.ex` and `.z.ey` are set to the failed primitive and its argument list.

```q
q)).z.ex
+
q)).z.ey
6
"he"
```


## Signal

`'err` will signal err from the deepest frame available, destroying it.

```q
q))'myerror
'myerror
  [1]  f:{g[x;2#y]}
          ^
q))
```


## Resume

When execution is suspended, `:e` resumes with `e` as the result of the failed operation. `e` defaults to null `::`. 

```q
q)read0`:test.q
"/ test script"
"a:b:0"
"func:{1+x}"
"a:func`a"
"b:1"
q)\l test.q
'type
  [3]  <full path to file>/test.q:3: func:{1+x}
                                            ^
q)):42 / result of 1+x
q)a
42
q)b
1
```

Note that resume does _not_ return from enclosing function

```q
q){0N!"x+1 is ",string x+1;x}`asd
'type
  [1]  {0N!"x+1 is ",string x+1;x}
                             ^
q)):17
"x+1 is 17"
`asd
```


## Abort

Use `\` to exit the debugger and abort execution.

```q
q))\
q)
```

Debuggers may nest if an expression entered into a debug prompt signals an error. Nesting level is indicated by appending further parentheses to the `q))` prompt. Each `\` exits a single debug level.

```q
q)){x+y}[a;y]
'type
  [5]  {x+y}
         ^
q)))x
6
q)))\          / exit the inner debugger
q))\           / exit the outer debugger
q)
```


## Backtrace

[`.Q.bt[]`](../ref/dotq.md#qbt-backtrace) will dump the backtrace to stdout at any point during execution or debug.

```q
q)f:{{.Q.bt[];x*2}x+1}
q)f 4
  [2]  f@:{.Q.bt[];x*2}
           ^
  [1]  f:{{.Q.bt[];x*2}x+1}
          ^
  [0]  f 4
       ^
10                   / (4+1)*2
q)g[3;"hello"]
'type
  [2]  g:{a:x*2;a+y}
                ^
q)).Q.bt[]
  [4]  .Q.bt[]
       ^
  [3]  (.Q.dbg)      / see note

  [2]  g:{a:x*2;a+y}
                ^
  [1]  f:{g[x;2#y]}
          ^
  [0]  f[3;"hello"]
       ^ 
```

!!! note "The debugger itself occupies a stack frame, but its source is hidden."

[`.Q.trp[f;x;g]`](../ref/dotq.md#qtrp-extend-trap) extends trap (`@[f;x;g]`) to collect backtrace. Along with the error string, `g` gets called with the backtrace object as a second argument. You can format it with `.Q.sbt` to make it legible.

```q
q)f:{`hello+x}
q)           / print the formatted backtrace and error string to stderr
q).Q.trp[f;2;{2@"error: ",x,"\nbacktrace:\n",.Q.sbt y;-1}]
error: type
backtrace:
  [2]  f:{`hello+x}
                ^
  [1]  (.Q.trp)

  [0]  .Q.trp[f;2;{2@"error: ",x,"\nbacktrace:\n",.Q.sbt y;-1}]
       ^
-1
q)
```

`.Q.trp` can be used for remote debugging.

```q
q)h:hopen`::5001   / f is defined on the remote
q)h"f `a"           
'type              / q's ipc protocol can only get the error string back
  [0]  h"f `a"
       ^
q)                 / a made up protocol: (0;result) or (1;backtrace string)
q)h".z.pg:{.Q.trp[(0;)@value@;x;{(1;.Q.sbt y)}]}"
q)h"f 3"
0                  / result
,9 9 9             
q)h"f `a"
1                  / failure
"  [4]  f@:{x*y}\n            ^\n  [3..
q)1@(h"f `a")1;    / output the backtrace string to stdout
  [4]  f@:{x*y}
            ^
  [3]  f:{{x*y}[x;3#x]}
          ^
  [2]  f `a
       ^
  [1]  (.Q.trp)

  [0]  .z.pg:{.Q.trp[(0;)@enlist value@;x;{(1;.Q.sbt y)}]}
              ^
```


## Error trap modes

At any point during execution, the behavior of Signal (`'`) is determined by the internal error trap mode:

mode | behavior
:---:|------------------------------------------------
0    | abort execution (set by Trap: `@` or `.`)
1    | suspend execution and run the debugger
2    | collect stack trace and abort (set by `.Q.trp`)

During abort, the stack is unwound up to the nearest trap (`@` or `.` or `.Q.trp`). The error-trap mode is always initially set to 1 for console input and to 0 for sync message processing.

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


!!! warning "Keywords"

    Q is an embedded domain-specific language. Many of its keywords are defined as lambdas or projections, and can suspend as described. 
    

## See also

<i class="far fa-hand-point-right"></i> 
[Display](../ref/display.md),
[`show`](../ref/show.md), 
_Q for Mortals 3:_ [§10.2 Debugging](/q4m3/10_Execution_Control/#102-debugging)
