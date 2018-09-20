---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
keywords: call, function, kdb+, learning, machine, python, q
---

# Function calls


Python allows for calling functions with 

-   A variable number of arguments
-   A mixture of positional and keyword arguments
-   Implicit (default) arguments

All of these features are available through the embedPy function-call interface.  
Specifically:

-   Callable embedPy objects are variadic
-   Default arguments are applied where no explicit arguments are given
-   Individual keyword arguments are specified using the (infix) `pykw` operator
-   A list of positional arguments can be passed using `pyarglist` (like Python \*args)
-   A dictionary of keyword arguments can be passed using `pykwargs` (like Python \*\*kwargs)

**Keyword arguments last** We can combine positional arguments, lists of positional arguments, keyword arguments and a dictionary of keyword arguments. However, _all_ keyword arguments must always follow _any_ positional arguments. The dictionary of keyword arguments (if given) must be specified last.


## Example function calls

```q
q)p)def func(a=1,b=2,c=3,d=4):return (a,b,c,d,a*b*c*d)
q)qfunc:.p.get[`func;<] / callable, returning q
```

Positional arguments are entered directly.  
Function calling is variadic, so later arguments can be excluded.

```q
q)qfunc[2;2;2;2]   / all positional args specified
2 2 2 2 16
q)qfunc[2;2]       / first 2 positional args specified
2 2 3 4 48
q)qfunc[]          / no args specified
1 2 3 4 24
q)qfunc[2;2;2;2;2] / error if too many args specified
TypeError: func() takes from 0 to 4 positional arguments but 5 were given
'p.c:73 call pyerr
```

Individual keyword arguments can be specified using the `pykw` operator (applied infix).  
Any keyword arguments must follow positional arguments, but the order of keyword arguments does not matter.

```q
q)qfunc[`d pykw 1;`c pykw 2;`b pykw 3;`a pykw 4] / all keyword args specified
4 3 2 1 24
q)qfunc[1;2;`d pykw 3;`c pykw 4]   / mix of positional and keyword args
1 2 4 3 24
q)qfunc[`a pykw 2;`b pykw 2;2;2]   / error if positional args after keyword args
'keywords last
q)qfunc[`a pykw 2;`a pykw 2]       / error if duplicate keyword args
'dupnames
```

A list of positional arguments can be specified using `pyarglist` (similar to Python's \*args).  
Again, keyword arguments must follow positional arguments.

```q
q)qfunc[pyarglist 1 1 1 1]          / full positional list specified
1 1 1 1 1
q)qfunc[pyarglist 1 1]              / partial positional list specified
1 1 3 4 12
q)qfunc[1;1;pyarglist 2 2]          / mix of positional args and positional list
1 1 2 2 4
q)qfunc[pyarglist 1 1;`d pykw 5]    / mix of positional list and keyword args
1 1 3 5 15
q)qfunc[pyarglist til 10]           / error if too many args specified
TypeError: func() takes from 0 to 4 positional arguments but 10 were given
'p.c:73 call pyerr
q)qfunc[`a pykw 1;pyarglist 2 2 2]  / error if positional list after keyword args
'keywords last
```

A dictionary of keyword arguments can be specified using `pykwargs` (similar to Python's \*\*kwargs).  
If present, this argument must be the _last_ argument specified.

```q
q)qfunc[pykwargs`d`c`b`a!1 2 3 4]             / full keyword dict specified
4 3 2 1 24
q)qfunc[2;2;pykwargs`d`c!3 3]                 / mix of positional args and keyword dict
2 2 3 3 36
q)qfunc[`d pykw 1;`c pykw 2;pykwargs`a`b!3 4] / mix of keyword args and keyword dict
3 4 2 1 24
q)qfunc[pykwargs`d`c!3 3;2;2]                 / error if keyword dict not last   
'pykwargs last
q)qfunc[pykwargs`a`a!1 2]                     / error if duplicate keyword names
'dupnames
```

All 4 methods can be combined in a single function call, as long as the order follows the above rules.  

```q
q)qfunc[4;pyarglist enlist 3;`c pykw 2;pykwargs enlist[`d]!enlist 1]    
4 3 2 1 24
```


## Zero-argument calls

In Python these two calls are _not_ equivalent:

```python
func()       #call with no arguments
func(None)   #call with argument None
```

!!! warning "EmbedPy function called with `::` calls Python with no arguments"

    Although `::` in q corresponds to `None` in Python, if an embedPy function is called with `::` as its only argument, the corresponding Python function will be called with _no_ arguments.

To call a Python function with `None` as its sole argument, retrieve `None` as a foreign object in q and pass that as the argument.

```q
q)pynone:.p.eval"None"
q).p.eval["print";pynone];
None
```

python         | form                      | q
---------------|---------------------------|-----------------------
`func()`       | call with no arguments    | `func[]` or `func[::]`
`func(None)`   | call with argument `None` | `func[.p.eval"None"]`


!!! info "Q functions applied to empty argument lists"

    The _rank_ (number of arguments) of a q function is determined by its _signature_, 
    an optional list of arguments at the beginning of its definition. 
    If the signature is omitted, the default arguments are as many of 
    `x`, `y` and `z` as appear, and its rank is 1, 2, or 3. 

    If it has no signature, and does not refer to `x`, `y`, or `z`, it has rank 1. 
    It is implicitly unary. 
    If it is then applied to an empty argument list, the value of `x` defaults to `(::)`. 

    So `func[::]` is equivalent to `func[]` – and in Python to `func()`, not `func[None]`.


## Dictionary keys and values

Python dictionaries convert to q dictionaries, and vice versa.

```q
q)p)pyd={'one':1,'two':2,'three':3}
q)qd:.p.get`pyd
q)qd`
one  | 1
two  | 2
three| 3
q).p.eval["print"]qd;
{'one': 1, 'two': 2, 'three': 3}
```

Functions are also provided to retrieve the keys and values directly from an embedPy dictionary, without performing the conversion to a q dictionary. 

-   `.p.key` returns the keys
-   `.p.value` returns the values

In each case, the result is an embedPy object.

```q
q).p.key[qd]`
"one"
"two"
"three"
q).p.value[qd]`
1 2 3
```


