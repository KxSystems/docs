---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
keywords: help, kdb+, learning, machine, print, python, q, stdout, string
---

# Printing and help


`.p.repr` returns the string representation of a Python object, embedPy or foreign.
This representation can be printed to stdout using `.p.print`.

```q
q)x:.p.eval"{'a':1,'b':2}"
q).p.repr x
"{'a': 1, 'b': 2}"
q).p.print x
{'a': 1, 'b': 2}
```

`.p.helpstr` returns the string representation of Python’s _help_ for a Python object, embedPy or foreign. 
Python interactive help for an object is accessed using `.p.help`.

```q
q)n:.p.eval"42"
q).p.helpstr n
"int(x=0) -> integer\nint(x, base=10) -> integer\n\nConvert a number or strin..
q).p.help n / interactive help
```


## Aliases in the root

For convenience, `p.q` defines `print` and `help` in the default namespace of q, as aliases for `.p.print` and `.p.help`. To prevent this, comment out the relevant code in `p.q` before loading.

```q
{@[`.;x;:;get x]}each`help`print; / comment to remove from global namespace
```


