# `'` Signal



_Signal an error._

Syntax: `'x`, `'[x]`

where `x` is a symbol atom or string, aborts evaluation and passes `x` to the interpreter as a string.

```q
q)0N!0;'`err;0N!1
0
'err
```

The only way to detect a signal is to use Trap.

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

<i class="far fa-hand-point-right"></i> 
[Debugging](../basics/debug.md),
[Error handling](../basics/errors.md), 
[Trap, Trap At](apply.md#trap)