---
hero: <i class="fa fa-share-alt"></i> Machine learning / embedPy
keywords: embedpy, foreign, kdb+, learning, machine, objects, python, q
---

# EmbedPy objects


## Foreign objects

At the lowest level, Python objects are represented in q as `foreign` objects, which contain pointers to objects in the Python memory space.

Foreign objects can be stored in variables just like any other q datatype, or as part of lists, dictionaries or tables. They will display as `foreign` when inspected in the q console or using the `string` (or `.Q.s`) representation. 

**Serialization** Kdb+ cannot serialize foreign objects, nor send them over IPC: they live in the embedded Python memory space. To pass these objects over IPC, first convert them to q.


## EmbedPy objects

Foreign objects cannot be directly operated on in q. Instead, Python objects are typically represented as `embedPy` objects, which wrap the underlying `foreign` objects. This provides the ability to get and set attributes, index, call or convert the underlying `foreign` object to a q.

Use `.p.wrap` to create an embedPy object from a foreign object.

```q
q)x
foreign
q)p:.p.wrap x
q)p           /how an embedPy object looks
{[f;x]embedPy[f;x]}[foreign]enlist
```

More commonly, embedPy objects are retrieved directly from Python using one of the following functions:

function    | argument                                         | example
------------|--------------------------------------------------|-----------------------
<code style="white-space: nowrap">.p.import</code> | symbol: name of a Python module or package, optional second argument is the name of an object within the module or package | <code style="white-space: nowrap">np:.p.import`numpy</code>
`.p.get`    | symbol: name of a Python variable in `__main__`  | ``v:.p.get`varName``
`.p.eval`   | string: Python code to evaluate                  | `x:.p.eval"1+1"`

**Side effects** As with other Python evaluation functions, `.p.eval` does not permit side effects.


## Converting data

Given `obj`, an embedPy object representing Python data, we can get the underlying data (as foreign or q) using

```q
obj`. / get data as foreign
obj`  / get data as q
```

e.g.

```q
q)x:.p.eval"(1,2,3)"
q)x
{[f;x]embedPy[f;x]}[foreign]enlist
q)x`.
foreign
q)x`
1 2 3
```


## `None` and identity

Python `None` maps to the q identity function `::` when converting from Python to q (and vice versa).

There is one important exception to this. 
When calling Python functions, methods or classes with a single q data argument, passing `::` will result in the Python object being called with _no_ arguments, rather than a single argument of `None`. See the section below on _Zero-argument calls_ for how to explicitly call a Python callable with a single `None` argument. 


## Getting attributes and properties

Given `obj`, an embedPy object representing a Python object, we can get an attribute or property directly using 

```q
obj`:attr         / equivalent to obj.attr in Python
obj`:attr1.attr2  / equivalent to obj.attr1.attr2 in Python
```

These expressions return embedPy objects, allowing users to chain operations together.  

```q
obj[`:attr1]`:attr2  / equivalent to obj.attr1.attr2 in Python
```

e.g.

```bash
$ cat class.p 
class obj:
    def __init__(self,x=0,y=0):
        self.x = x
        self.y = y
```

```q
q)\l class.p
q)obj:.p.eval"obj(2,3)"
q)obj[`:x]`
2
q)obj[`:y]`
3
```


## Setting attributes and properties

Given `obj`, an embedPy object representing a Python object, we can set an attribute or property directly using 

```q
obj[:;`:attr;val]  / equivalent to obj.attr=val in Python
```

e.g.

```q
q)obj[`:x]`
2
q)obj[`:y]`
3
q)obj[:;`:x;10]
q)obj[:;`:y;20]
q)obj[`:x]`
10
q)obj[`:y]`
20
```


## Indexing

Given `lst`, an embedPy object representing an indexable container object in Python, we can access the element at index `i` using

```q
lst[@;i]    / equivalent to lst[i] in Python
```

We can set the element at index `i` (to object `x`) using

```q
lst[=;i;x]  / equivalent to lst[i]=x in Python
```

These expressions return embedPy objects.

e.g.

```q
q)lst:.p.eval"[True,2,3.0,'four']"
q)lst[@;0]`
1b
q)lst[@;-1]`
"four"
q)lst'[@;;`]2 1 0 3
3f
2
1b
"four"
q)lst[=;0;0b]
q)lst[=;-1;`last]
q)lst`
0b
2
3f
"last"
```


## Getting methods

Given `obj`, an embedPy object representing a Python object, we can access a method directly using 

```q
obj`:method  / equivalent to obj.method in Python
```

This will return an embedPy object, _calling_ this object is described below.


## Function calls

EmbedPy objects representing callable Python functions or methods are callable by default with an `embedPy` return. They can be declared callable in q returning q or `foreign` using. 

-   `.p.qcallable`  (declare callable with q return)
-   `.p.pycallable` (declare callable with foreign return)


The result of each of these functions represents the same underlying Python function or method, but now callable in q.

e.g.

```q
q)np:.p.import`numpy
q)np`:arange
{[f;x]embedPy[f;x]}[foreign]enlist
q)arange:np`:arange                   / callable returning embedPy
q)arange 12
{[f;x]embedPy[f;x]}[foreign]enlist
q)arange[12]`
0 1 2 3 4 5 6 7 8 9 10 11
q)arange_py:.p.pycallable np`:arange / callable returning foreign
q)arange_py 12
foreign
q)arange_q:.p.qcallable np`:arange   / callable returning q
q)arange_q 12
0 1 2 3 4 5 6 7 8 9 10 11
```


## embedPy function API

Using the function API, embedPy objects can be called directly (returning embedPy) or declared callable returning q or `foreign` data.

Users explicitly specify the return type as q or foreign, the default is embedPy.  
Given `func`, an `embedPy` object representing a callable Python function or method, we can carry out the following operations:

```q
func                   / func is callable by default (returning embedPy)
func arg               / call func(arg) (returning embedPy)

func[<]                / declare func callable (returning q)
func[<]arg             / call func(arg) (returning q)
func[<;arg]            / equivalent

func[>]                / declare func callable (returning foreign)
func[>]arg             / call func(arg) (returning foreign)
func[>;arg]            / equivalent
```

**Chaining operations** Returning another embedPy object from a function or method call, allows users to chain together sequences of operations.  We can also chain these operations together with calls to `.p.import`, `.p.get` and `.p.eval`.


## embedPy examples

Some examples

```bash
$ cat test.p # used for tests
class obj:
    def __init__(self,x=0,y=0):
        self.x = x # attribute
        self.y = y # property (incrementing on get)
    @property
    def y(self):
        a=self.__y
        self.__y+=1
        return a
    @y.setter
    def y(self, y):
        self.__y = y
    def total(self):
        return self.x + self.y
```

```q
q)\l test.p
q)obj:.p.get`obj / obj is the *class* not an instance of the class
q)o:obj[]        / call obj with no arguments to get an instance
q)o[`:x]`
0
q)o[;`]each 5#`:x
0 0 0 0 0
q)o[:;`:x;10]
q)o[`:x]`
10
q)o[`:y]`
0
q)o[;`]each 5#`:y
1 2 3 4 5
q)o[:;`:y;10]
q)o[;`]each 5#`:y
10 11 12 13 14
q)tot:.p.qcallable o`:total
q)tot[]
25
q)tot[]
26
```
```q
q)np:.p.import`numpy
q)v:np[`:arange;12]
q)v`
0 1 2 3 4 5 6 7 8 9 10 11
q)v[`:mean;<][]
5.5
q)rs:v[`:reshape;<]
q)rs[3;4]
0 1 2  3 
4 5 6  7 
8 9 10 11
q)rs[2;6]
0 1 2 3 4  5 
6 7 8 9 10 11
q)np[`:arange;12][`:reshape;3;4]`
0 1 2  3 
4 5 6  7 
8 9 10 11
q)np[`:arange;12][`:reshape;3;4][`:T]`
0 4 8 
1 5 9 
2 6 10
3 7 11
```
```q
q)stdout:.p.import[`sys]`:stdout.write
q)stdout"hello\n";
hello
q)stderr:.p.import[`sys;`:stderr.write]
q)stderr"goodbye\n";
goodbye
```
```q
q)oarg:.p.eval"10"
q)oarg`
10
q)ofunc:.p.eval["lambda x:2+x";<]
q)ofunc 1
3
q)ofunc oarg
12
q)p)def add2(x,y):return x+y
q)add2:.p.get[`add2;<]
q)add2[1;oarg]
11
```

<!-- 
## Further examples 

Further examples can be found in the `examples` folder of the <i class="fab fa-github"></i> [KxSystems/embedPy](https://github.com/kxsystems/embedpy) repository. 

This includes an example of creating simple charts in Matplotlib either by running Python code in a kdb+ process, or importing the `matplotlib.pyplot` module into kdb+ and using functions from it in q code.
 --> 

## Setting Python variables

Variables can be set in Python `__main__` using `.p.set`

```q
q).p.set[`var1;42]
q).p.qeval"var1"
42
```



