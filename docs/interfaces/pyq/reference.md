# ![PyQ](../img/pyq.png) Reference


<!-- This section is generated from the PyQ source code.  -->
You can access most of this material using pydoc or the built-in `help` method.

class `K`
: Proxies for kdb+ objects

namespace `q`
: A portal to kdb+

`pyq.kerr`
: alias of `error`


## class K

```python
>>> q('2005.01.01 2005.12.04')
k('2005.01.01 2005.12.04')
```
Iteration over simple lists produces Python objects
```python
>>> list(q("`a`b`c`d"))
['a', 'b', 'c', 'd']
```
Iteration over q tables produces q dictionaries
```python
>>> list(q("([]a:`x`y`z;b:1 2 3)"))
[k('`a`b!(`x;1)'), k('`a`b!(`y;2)'), k('`a`b!(`z;3)')]
```
Iteration over a q dictionary iterates over its key
```python
>>> list(q('`a`b!1 2'))
['a', 'b']
```
As a consequence, iteration over a keyed table is the same as iteration over its key table
```python
>>> list(q("([a:`x`y`z]b:1 2 3)"))
[k('(,`a)!,`x'), k('(,`a)!,`y'), k('(,`a)!,`z')]
```
Callbacks into Python
```python
>>> def f(x, y):
...     return x + y
>>> q('{[f]f(1;2)}', f)
k('3')
```

### Buffer protocol

The following session illustrates how the buffer protocol implemented by K objects can be used to write data from Python streams directly to kdb+.

Create a list of chars in kdb+
```python
>>> x = kp('xxxxxx')
```
Open a pair of file descriptors
```python
>>> r, w = os.pipe()
```
Write 6 bytes to the write end
```python
>>> os.write(w, b'abcdef')
6
```
Read from the read-end into `x`
```python
>>> f = os.fdopen(r, mode='rb')
>>> f.readinto(x)
6
```
Now `x` contains the bytes that were sent through the pipe
```python
>>> x
k('"abcdef"')
```
Close the descriptors and the stream
```python
>>> os.close(w); f.close()
```


### Low-level interface

The K type provides a set of low-level functions that are similar to the C API provided by the [k.h header](https://github.com/KxSystems/kdb/blob/master/c/c/k.h). 
The C API functions that return K objects in C are implemented as class methods that return instances of K type.

Atoms:
```python
>>> K._kb(True), K._kg(5), K._kh(42), K._ki(-3), K._kj(2**40)
(k('1b'), k('0x05'), k('42h'), k('-3i'), k('1099511627776'))

>>> K._ke(3.5), K._kf(1.0), K._kc(b'x'), K._ks('xyz')
(k('3.5e'), k('1f'), k('"x"'), k('`xyz'))

>>> K._kd(0), K._kz(0.0), K._kt(0)
(k('2000.01.01'), k('2000.01.01T00:00:00.000'), k('00:00:00.000'))
```
Tables and dictionaries:
```python
>>> x = K._xD(k('`a`b`c'), k('1 2 3')); x, K._xT(x)
(k('`a`b`c!1 2 3'), k('+`a`b`c!1 2 3'))
```
Keyed table:
```python
>>> t = K._xD(K._xT(K._xD(k(",`a"), k(",1 2 3"))),
...           K._xT(K._xD(k(",`b"), k(",10 20 30"))))
>>> K._ktd(t)
k('+`a`b!(1 2 3;10 20 30)')
```
K objects can be used in Python arithmetic expressions.
```python
>>> x, y, z = map(K, (1, 2, 3))
>>> print(x + y, x * y,
...       z/y, x|y, x&y, abs(-z))  
3 2 1.5 2 1 3
```
Mixing K objects with Python numbers is allowed.
```python
    >>> 1/q('1 2 4')
    k('1 0.5 0.25')
    >>> q.til(5)**2
    k('0 1 4 9 16f')
```


`__call__`
: Call self as a function

`__contains__`(*item*)
: membership test <pre><code class="language-python">
    &gt;&gt;&gt; 1 in q('1 2 3')
    True
    &gt;&gt;&gt; 'abc' not in q('(1;2.0;`abc)')
    False
    </code></pre>

`__eq__`(*other*)
: Test equality
<!-- Prism chokes on following code block when nested -->
```python
>>> K(1) == K(1)
True
>>> K(1) == None
False
```

`__float__()`

: Converts K scalars to Python float <pre><code class="language-python">
    &gt;&gt;&gt; [float(q(x)) for x in '1b 2h 3 4e `5 6.0 2000.01.08'.split()]
    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
    </code></pre>

`__get__`
: Return an attribute of instance, which is of type owner.

`__getattr__`(_a_)
: Table columns can be accessed via dot notation <pre><code class="language-python"> &gt;&gt;&gt; q("([]a:1 2 3; b:10 20 30)").a
    k('1 2 3')
    </code></pre>

`__getitem__`(_x_)
: Item from a list <pre><code class="language-python">
    &gt;&gt;&gt; k("10 20 30 40 50")[k("1 3")]
    k('20 40')
    &gt;&gt;&gt; k("\`a\`b\`c!1 2 3")['b']
    2
    </code></pre>

`__int__()`
: Converts K scalars to Python int<pre><code class="language-python">
    &gt;&gt;&gt; [int(q(x)) for x in '1b 2h 3 4e `5 6.0 2000.01.08'.split()]
    [1, 2, 3, 4, 5, 6, 7]
    </code></pre>

`exec`(*columns=()*, *by=()*, *where=()*, _\*\*kwds_*_)
: `exec` from self <pre><code class="language-python">
    &gt;&gt;&gt; t = q('([]a:1 2 3; b:10 20 30)')
    &gt;&gt;&gt; t.exec_('a', where='b > 10').show()
    2 3
    </code>

`keys()`
: Returns q(‘key’, self)

    Among other uses, enables interoperability between q and Python dicts. <pre><code class="language-python">
    &gt;&gt;&gt; from collections import OrderedDict
    &gt;&gt;&gt; OrderedDict(q('\`a\`b!1 2'))
    OrderedDict([('a', 1), ('b', 2)])
    &gt;&gt;&gt; d = {}; d.update(q('\`a\`b!1 2'))
    &gt;&gt;&gt; list(sorted(d.items()))
    [('a', 1), ('b', 2)]
    </code></pre>

`select`(*columns=()*, *by=()*, *where=()*, _\*\*kwds_)
: `select` from self <pre><code class="language-python">
    &gt;&gt;&gt; t = q('([]a:1 2 3; b:10 20 30)')
    &gt;&gt;&gt; t.select('a', where='b > 20').show()
    a
    -
    3
    </code>

`show`(_start=0, geometry=None, output=None_)
: Pretty-print data to the console

    (similar to q.show, but uses Python stdout by default) <pre><code class="language-python">
    &gt;&gt;&gt; x = q('([k:\`x\`y\`z]a:1 2 3;b:10 20 30)')
    &gt;&gt;&gt; x.show()  
    k| a b
    -| ----
    x| 1 10
    y| 2 20
    z| 3 30
    </code></pre>
    The first optional argument, `start` specifies the first row to be printed (negative means from the end) <pre><code class="language-python">
    &gt;&gt;&gt; x.show(2) 
    k| a b
    -| ----
    z| 3 30
    &gt;&gt;&gt; x.show(-2)  
    k| a b
    -| ----
    y| 2 20
    z| 3 30
    </code></pre>
    The geometry is the height and width of the console
    <pre><code class="language-python">
    &gt;&gt;&gt; x.show(geometry=[4, 6])
    k| a..
    -| -..
    x| 1..
    ..
    </code></pre>

`update`(_columns=(), by=(), where=(), \*\*kwds_)
: `update` from self <pre><code class="language-python">
    &gt;&gt;&gt; t = q('([]a:1 2 3; b:10 20 30)')
    &gt;&gt;&gt; t.update('a*2',
    ...          where='b > 20').show()  
    a b
    ----
    1 10
    2 20
    6 30
    </code></pre>


## namespace q

`pyq.q`


`q.__call__`(*m=None*, *\*args*)

: Execute q code.

    When called without arguments in an interactive session, `q()` presents a `q)` prompt where user can interact with kdb+ using q language commands.

    The first argument to that may be given to `q()` should be a string containing a q language expression. If that expression evaluates to a function, the arguments to this function can be provided as additional arguments to `q()`.

    For example, the following passes a list and a number to the q `?` (find) function: <pre><code class="language-python">
    &gt;&gt;&gt; q('?', [1, 2, 3], 2)
    k('1')
    </code></pre>



## K and q functions

K class | q namespace | q   | function
--------|-------------|-----|--------------------------------------------
<code class="nowrap">K.abs()</code> | <code class="nowrap">q.abs()</code> | [<code class="nowrap">abs</code>](/basics/arith-integer/#abs) | absolute value The `abs` function computes the absolute value of its argument. Null is returned if the argument is null.<br/>`>>> q.abs([-1, 0, 1, None])`<br/>`k('1 0 1 0N')`
<code class="nowrap">K.acos()</code> | <code class="nowrap">q.acos()</code> | [<code class="nowrap">acos</code>](/basics/trig/#acos) | arc cosine
<code class="nowrap">K.aj()</code> | <code class="nowrap">q.aj()</code> | [<code class="nowrap">aj</code>](/basics/joins/#aj-aj0-asof-join) | as-of join
<code class="nowrap">K.aj0()</code> | <code class="nowrap">q.aj0()</code> | [<code class="nowrap">aj</code>](/basics/joins/#aj-aj0-asof-join) | as-of join
<code class="nowrap">K.all()</code> | <code class="nowrap">q.all()</code> | [<code class="nowrap">all</code>](/basics/logic/#all) | all nonzero
<code class="nowrap">K.and_()</code> | <code class="nowrap">q.and_()</code> | [<code class="nowrap">and</code>](/basics/logic/#and-minimum) | and
<code class="nowrap">K.any()</code> | <code class="nowrap">q.any()</code> | [<code class="nowrap">any</code>](/basics/logic/#any) | any item is non-zero
<code class="nowrap">K.asc()</code> | <code class="nowrap">q.asc()</code> | [<code class="nowrap">asc</code>](/basics/sort/#asc) | ascending sort
<code class="nowrap">K.asin()</code> | <code class="nowrap">q.asin()</code> | [<code class="nowrap">asin</code>](/basics/trig/#asin) | arc sine
<code class="nowrap">K.asof()</code> | <code class="nowrap">q.asof()</code> | [<code class="nowrap">asof</code>](/basics/joins/#asof) | as-of operator
<code class="nowrap">K.atan()</code> | <code class="nowrap">q.atan()</code> | [<code class="nowrap">atan</code>](/basics/trig/#atan) | arc tangent
<code class="nowrap">K.attr()</code> | <code class="nowrap">q.attr()</code> | [<code class="nowrap">attr</code>](/basics/metadata/#attr) | attributes
<code class="nowrap">K.avg()</code> | <code class="nowrap">q.avg()</code> | [<code class="nowrap">avg</code>](/basics/stats-aggregates/#avg-average) | arithmetic mean
<code class="nowrap">K.avgs()</code> | <code class="nowrap">q.avgs()</code> | [<code class="nowrap">avgs</code>](/basics/stats-aggregates/#avgs-averages) | running averages
<code class="nowrap">K.bin()</code> | <code class="nowrap">q.bin()</code> | [<code class="nowrap">bin</code>](/basics/search/#bin-binr) | binary search
<code class="nowrap">K.binr()</code> | <code class="nowrap">q.binr()</code> | [<code class="nowrap">bin</code>](/basics/search/#bin-binr) | binary search
<code class="nowrap">K.ceiling()</code> | <code class="nowrap">q.ceiling()</code> | [<code class="nowrap">ceiling</code>](/basics/arith-integer/#ceiling) | lowest integer above
<code class="nowrap">K.cols()</code> | <code class="nowrap">q.cols()</code> | [<code class="nowrap">cols</code>](/basics/metadata/#cols) | column names of a table
<code class="nowrap">K.cor()</code> | <code class="nowrap">q.cor()</code> | [<code class="nowrap">cor</code>](/basics/stats-aggregates/#cor-correlation) | correlation
<code class="nowrap">K.cos()</code> | <code class="nowrap">q.cos()</code> | [<code class="nowrap">cos</code>](/basics/trig/#cos) | cosine
<code class="nowrap">K.count()</code> | <code class="nowrap">q.count()</code> | [<code class="nowrap">count</code>](/basics/lists/#count) | number of items
<code class="nowrap">K.cov()</code> | <code class="nowrap">q.cov()</code> | [<code class="nowrap">cov</code>](/basics/stats-aggregates/#cov-covariance) | statistical covariance
<code class="nowrap">K.cross()</code> | <code class="nowrap">q.cross()</code> | [<code class="nowrap">cross</code>](/basics/lists/#cross) | cross product
<code class="nowrap">K.csv()</code> | <code class="nowrap">q.csv()</code> | [<code class="nowrap">csv</code>](/basics/filewords/#csv) | comma delimiter
<code class="nowrap">K.cut()</code> | <code class="nowrap">q.cut()</code> | [<code class="nowrap">cut</code>](/basics/lists/#_-cut) | cut
<code class="nowrap">K.deltas()</code> | <code class="nowrap">q.deltas()</code> | [<code class="nowrap">deltas</code>](/basics/arith-integer/#deltas) | differences between consecutive pairs
<code class="nowrap">K.desc()</code> | <code class="nowrap">q.desc()</code> | [<code class="nowrap">desc</code>](/basics/sort/#desc) | descending sort
<code class="nowrap">K.dev()</code> | <code class="nowrap">q.dev()</code> | [<code class="nowrap">dev</code>](/basics/stats-aggregates/#dev-standard-deviation) | standard deviation
<code class="nowrap">K.differ()</code> | <code class="nowrap">q.differ()</code> | [<code class="nowrap">differ</code>](/basics/comparison/#differ) | flag differences in consecutive pairs
<code class="nowrap">K.distinct()</code> | <code class="nowrap">q.distinct()</code> | [<code class="nowrap">distinct</code>](/basics/search/#distinct) | unique items
<code class="nowrap">K.div()</code> | <code class="nowrap">q.div()</code> | [<code class="nowrap">div</code>](/basics/arith-integer/#div) | integer division
<code class="nowrap">K.dsave()</code> | <code class="nowrap">q.dsave()</code> | [<code class="nowrap">dsave</code>](/basics/filewords/#dsave) | save global tables to disk
<code class="nowrap">K.ej()</code> | <code class="nowrap">q.ej()</code> | [<code class="nowrap">ej</code>](/basics/joins/#ej-equi-join) | equi-join
<code class="nowrap">K.ema()</code> | <code class="nowrap">q.ema()</code> | [<code class="nowrap">ema</code>](/basics/stats-moving/#ema) | exponentially-weighted moving average
<code class="nowrap">K.ema()</code> | <code class="nowrap">q.ema()</code> | [<code class="nowrap">ema</code>](/basics/stats-moving/#ema) | exponentially-weighted moving average
<code class="nowrap">K.enlist()</code> | <code class="nowrap">q.enlist()</code> | [<code class="nowrap">enlist</code>](/basics/lists/#enlist) | arguments as a list
<code class="nowrap">K.eval()</code> | <code class="nowrap">q.eval()</code> | [<code class="nowrap">eval</code>](/basics/parsetrees/#eval) | evaluate a parse tree
<code class="nowrap">K.except_()</code> | <code class="nowrap">q.except_()</code> | [<code class="nowrap">except</code>](/basics/selection/#except) | left argument without items in right argument
<code class="nowrap">K.exp()</code> | <code class="nowrap">q.exp()</code> | [<code class="nowrap">exp</code>](/basics/arith-float/#exp) | power of e
<code class="nowrap">K.fby()</code> | <code class="nowrap">q.fby()</code> | [<code class="nowrap">fby</code>](/basics/qsql/#fby) | filter-by
<code class="nowrap">K.fills()</code> | <code class="nowrap">q.fills()</code> | [<code class="nowrap">fills</code>](/basics/lists/#fills) | forward-fill nulls
<code class="nowrap">K.first()</code> | <code class="nowrap">q.first()</code> | [<code class="nowrap">first</code>](/basics/selection/#first) | first item
<code class="nowrap">K.fkeys()</code> | <code class="nowrap">q.fkeys()</code> | [<code class="nowrap">fkeys</code>](/basics/metadata/#fkeys) | foreign-key columns mapped to their tables
<code class="nowrap">K.flip()</code> | <code class="nowrap">q.flip()</code> | [<code class="nowrap">flip</code>](/basics/lists/#flip) | transpose
<code class="nowrap">K.floor()</code> | <code class="nowrap">q.floor()</code> | [<code class="nowrap">floor</code>](/basics/arith-integer/#floor) | greatest integer less than argument
<code class="nowrap">K.get()</code> | <code class="nowrap">q.get()</code> | [<code class="nowrap">get</code>](/basics/dotz/#zpg-get) | get
<code class="nowrap">K.getenv()</code> | <code class="nowrap">q.getenv()</code> | [<code class="nowrap">getenv</code>](/basics/os/#getenv) | value of an environment variable
<code class="nowrap">K.group()</code> | <code class="nowrap">q.group()</code> | [<code class="nowrap">group</code>](/basics/dictsandtables/#group) | dictionary of distinct items
<code class="nowrap">K.gtime()</code> | <code class="nowrap">q.gtime()</code> | [<code class="nowrap">gtime</code>](/basics/os/#gtime) | UTC timestamp
<code class="nowrap">K.hclose()</code> | <code class="nowrap">q.hclose()</code> | [<code class="nowrap">hclose</code>](/basics/filewords/#hclose) | close a file or process
<code class="nowrap">K.hcount()</code> | <code class="nowrap">q.hcount()</code> | [<code class="nowrap">hcount</code>](/basics/filewords/#hcount) | size of a file
<code class="nowrap">K.hdel()</code> | <code class="nowrap">q.hdel()</code> | [<code class="nowrap">hdel</code>](/basics/filewords/#hdel) | delete a file
<code class="nowrap">K.hopen()</code> | <code class="nowrap">q.hopen()</code> | [<code class="nowrap">hopen</code>](/basics/filewords/#hopen) | open a file
<code class="nowrap">K.hsym()</code> | <code class="nowrap">q.hsym()</code> | [<code class="nowrap">hsym</code>](/basics/filewords/#hsym) | convert symbol to filename or IP address
<code class="nowrap">K.iasc()</code> | <code class="nowrap">q.iasc()</code> | [<code class="nowrap">iasc</code>](/basics/sort/#iasc) | indices of ascending sort
<code class="nowrap">K.idesc()</code> | <code class="nowrap">q.idesc()</code> | [<code class="nowrap">idesc</code>](/basics/sort/#idesc) | indices of descending sort
<code class="nowrap">K.ij()</code> | <code class="nowrap">q.ij()</code> | [<code class="nowrap">ij</code>](/basics/joins/#ij-ijf-inner-join) | inner join
<code class="nowrap">K.ijf()</code> | <code class="nowrap">q.ijf()</code> | [<code class="nowrap">ijf</code>](/basics/joins/#ij-ijf-inner-join) | The ijf function.
<code class="nowrap">K.in_()</code> | <code class="nowrap">q.in_()</code> | [<code class="nowrap">in</code>](/basics/search/#in) | membership
<code class="nowrap">K.insert()</code> | <code class="nowrap">q.insert()</code> | [<code class="nowrap">insert</code>](/basics/qsql/#insert) | append records to a table
<code class="nowrap">K.inter()</code> | <code class="nowrap">q.inter()</code> | [<code class="nowrap">inter</code>](/basics/selection/#inter) | items common to both arguments
<code class="nowrap">K.inv()</code> | <code class="nowrap">q.inv()</code> | [<code class="nowrap">inv</code>](/basics/matrixes/#inv) | matrix inverse
<code class="nowrap">K.key()</code> | <code class="nowrap">q.key()</code> | [<code class="nowrap">key</code>](/basics/dictsandtables/#key) | key
<code class="nowrap">K.keys()</code> | <code class="nowrap">q.keys()</code> | [<code class="nowrap">keys</code>](/basics/metadata/#keys) | names of a table’s columns
<code class="nowrap">K.last()</code> | <code class="nowrap">q.last()</code> | [<code class="nowrap">last</code>](/basics/selection/#last) | last item
<code class="nowrap">K.like()</code> | <code class="nowrap">q.like()</code> | [<code class="nowrap">like</code>](/basics/strings/#like) | pattern matching
<code class="nowrap">K.lj()</code> | <code class="nowrap">q.lj()</code> | [<code class="nowrap">lj</code>](/basics/joins/#lj-ljf-left-join) | left join
<code class="nowrap">K.ljf()</code> | <code class="nowrap">q.ljf()</code> | [<code class="nowrap">ljf</code>](/basics/joins/#lj-ljf-left-join) | left join
<code class="nowrap">K.load()</code> | <code class="nowrap">q.load()</code> | [<code class="nowrap">load</code>](/basics/filewords/#load) | load binary data
<code class="nowrap">K.log()</code> | <code class="nowrap">q.log()</code> | [<code class="nowrap">log</code>](/basics/arith-float/#log) | natural logarithm
<code class="nowrap">K.lower()</code> | <code class="nowrap">q.lower()</code> | [<code class="nowrap">lower</code>](/basics/strings/#lower) | lower case
<code class="nowrap">K.lsq()</code> | <code class="nowrap">q.lsq()</code> | [<code class="nowrap">lsq</code>](/basics/matrixes/#lsq) | least squares matrix divide
<code class="nowrap">K.ltime()</code> | <code class="nowrap">q.ltime()</code> | [<code class="nowrap">ltime</code>](/basics/os/#ltime) | local timestamp
<code class="nowrap">K.ltrim()</code> | <code class="nowrap">q.ltrim()</code> | [<code class="nowrap">ltrim</code>](/basics/strings/#ltrim) | function remove leading spaces
<code class="nowrap">K.mavg()</code> | <code class="nowrap">q.mavg()</code> | [<code class="nowrap">mavg</code>](/basics/stats-moving/#mavg) | moving average
<code class="nowrap">K.max()</code> | <code class="nowrap">q.max()</code> | [<code class="nowrap">max</code>](/basics/stats-aggregates/#max-maximum) | maximum
<code class="nowrap">K.maxs()</code> | <code class="nowrap">q.maxs()</code> | [<code class="nowrap">maxs</code>](/basics/stats-aggregates/#maxs-maximums) | maxima of preceding items
<code class="nowrap">K.mcount()</code> | <code class="nowrap">q.mcount()</code> | [<code class="nowrap">mcount</code>](/basics/stats-moving/#mcount) | moving count
<code class="nowrap">K.md5()</code> | <code class="nowrap">q.md5()</code> | [<code class="nowrap">md5</code>](/basics/strings/#md5) | MD5 hash
<code class="nowrap">K.mdev()</code> | <code class="nowrap">q.mdev()</code> | [<code class="nowrap">mdev</code>](/basics/stats-moving/#mdev) | moving deviation
<code class="nowrap">K.med()</code> | <code class="nowrap">q.med()</code> | [<code class="nowrap">med</code>](/basics/stats-aggregates/#med-median) | median
<code class="nowrap">K.meta()</code> | <code class="nowrap">q.meta()</code> | [<code class="nowrap">meta</code>](/basics/metadata/#meta) | metadata of a table
<code class="nowrap">K.min()</code> | <code class="nowrap">q.min()</code> | [<code class="nowrap">min</code>](/basics/stats-aggregates/#min-minimum) | minimum
<code class="nowrap">K.mins()</code> | <code class="nowrap">q.mins()</code> | [<code class="nowrap">mins</code>](/basics/stats-aggregates/#mins-minimums) | minimum of preceding items
<code class="nowrap">K.mmax()</code> | <code class="nowrap">q.mmax()</code> | [<code class="nowrap">mmax</code>](/basics/stats-moving/#mmax) | moving maxima
<code class="nowrap">K.mmin()</code> | <code class="nowrap">q.mmin()</code> | [<code class="nowrap">mmin</code>](/basics/stats-moving/#mmin) | moving minima
<code class="nowrap">K.mmu()</code> | <code class="nowrap">q.mmu()</code> | [<code class="nowrap">mmu</code>](/basics/matrixes/#mmu) | mmu
<code class="nowrap">K.mod()</code> | <code class="nowrap">q.mod()</code> | [<code class="nowrap">mod</code>](/basics/arith-integer/#mod) | remainder
<code class="nowrap">K.msum()</code> | <code class="nowrap">q.msum()</code> | [<code class="nowrap">msum</code>](/basics/stats-moving/#msum) | moving sum
<code class="nowrap">K.neg()</code> | <code class="nowrap">q.neg()</code> | [<code class="nowrap">neg</code>](/basics/arith-integer/#neg) | negate
<code class="nowrap">K.next()</code> | <code class="nowrap">q.next()</code> | [<code class="nowrap">next</code>](/basics/selection/#next) | next items
<code class="nowrap">K.not_()</code> | <code class="nowrap">q.not_()</code> | [<code class="nowrap">not</code>](/basics/comparison/#six-comparison-operators) | not
<code class="nowrap">K.null()</code> | <code class="nowrap">q.null()</code> | [<code class="nowrap">null</code>](/basics/unclassified/#null) | null
<code class="nowrap">K.or_()</code> | <code class="nowrap">q.or_()</code> | [<code class="nowrap">or</code>](/basics/logic/#or-maximum) | or
<code class="nowrap">K.parse()</code> | <code class="nowrap">q.parse()</code> | [<code class="nowrap">parse</code>](/basics/parsetrees/#parse) | parse a string
<code class="nowrap">K.peach()</code> | <code class="nowrap">q.peach()</code> | [<code class="nowrap">peach</code>](/basics/dotz/#zpd-peach-handles) | peach
<code class="nowrap">K.pj()</code> | <code class="nowrap">q.pj()</code> | [<code class="nowrap">pj</code>](/basics/joins/#pj-plus-join) | plus join
<code class="nowrap">K.prd()</code> | <code class="nowrap">q.prd()</code> | [<code class="nowrap">prd</code>](/basics/arith-float/#prd) | product
<code class="nowrap">K.prds()</code> | <code class="nowrap">q.prds()</code> | [<code class="nowrap">prds</code>](/basics/arith-float/#prds) | cumulative products
<code class="nowrap">K.prev()</code> | <code class="nowrap">q.prev()</code> | [<code class="nowrap">prev</code>](/basics/selection/#prev) | previous items
<code class="nowrap">K.prior()</code> | <code class="nowrap">q.prior()</code> | [<code class="nowrap">prior</code>](/basics/control/#prior) | prior
<code class="nowrap">K.rand()</code> | <code class="nowrap">q.rand()</code> | [<code class="nowrap">rand</code>](/basics/random/#rand) | random number
<code class="nowrap">K.rank()</code> | <code class="nowrap">q.rank()</code> | [<code class="nowrap">rank</code>](/basics/sort/#rank) | grade up
<code class="nowrap">K.ratios()</code> | <code class="nowrap">q.ratios()</code> | [<code class="nowrap">ratios</code>](/basics/arith-float/#ratios) | ratios of consecutive pairs
<code class="nowrap">K.raze()</code> | <code class="nowrap">q.raze()</code> | [<code class="nowrap">raze</code>](/basics/lists/#raze) | join items
<code class="nowrap">K.read0()</code> | <code class="nowrap">q.read0()</code> | [<code class="nowrap">read0</code>](/basics/filewords/#read0) | read file as lines
<code class="nowrap">K.read1()</code> | <code class="nowrap">q.read1()</code> | [<code class="nowrap">read1</code>](/basics/filewords/#read1) | read file as bytes
<code class="nowrap">K.reciprocal()</code> | <code class="nowrap">q.reciprocal()</code> | [<code class="nowrap">reciprocal</code>](/basics/arith-float/#reciprocal) | reciprocal of a number
<code class="nowrap">K.reval()</code> | <code class="nowrap">q.reval()</code> | [<code class="nowrap">reval</code>](/basics/parsetrees/#reval) | variation of eval
<code class="nowrap">K.reverse()</code> | <code class="nowrap">q.reverse()</code> | [<code class="nowrap">reverse</code>](/basics/lists/#reverse) | reverse the order of items
<code class="nowrap">K.rload()</code> | <code class="nowrap">q.rload()</code> | [<code class="nowrap">rload</code>](/basics/filewords/#rload) | load a splayed table
<code class="nowrap">K.rotate()</code> | <code class="nowrap">q.rotate()</code> | [<code class="nowrap">rotate</code>](/basics/lists/#rotate) | rotate items
<code class="nowrap">K.rsave()</code> | <code class="nowrap">q.rsave()</code> | [<code class="nowrap">rsave</code>](/basics/filewords/#rsave) | rsave
<code class="nowrap">K.rtrim()</code> | <code class="nowrap">q.rtrim()</code> | [<code class="nowrap">rtrim</code>](/basics/strings/#rtrim) | remove trailing spaces
<code class="nowrap">K.save()</code> | <code class="nowrap">q.save()</code> | [<code class="nowrap">save</code>](/basics/filewords/#save) | save global data to file
<code class="nowrap">K.scov()</code> | <code class="nowrap">q.scov()</code> | [<code class="nowrap">scov</code>](/basics/stats-aggregates/#scov-statistical-covariance) | statistical covariance
<code class="nowrap">K.scov()</code> | <code class="nowrap">q.scov()</code> | [<code class="nowrap">scov</code>](/basics/stats-aggregates/#scov-statistical-covariance) | statistical covariance
<code class="nowrap">K.sdev()</code> | <code class="nowrap">q.sdev()</code> | [<code class="nowrap">sdev</code>](/basics/stats-aggregates/#sdev-statistical-standard-deviation) | statistical standard deviation
<code class="nowrap">K.sdev()</code> | <code class="nowrap">q.sdev()</code> | [<code class="nowrap">sdev</code>](/basics/stats-aggregates/#sdev-statistical-standard-deviation) | statistical standard deviation
<code class="nowrap">K.set()</code> | <code class="nowrap">q.set()</code> | [<code class="nowrap">set</code>](/basics/dotz/#zps-set) | set
<code class="nowrap">K.setenv()</code> | <code class="nowrap">q.setenv()</code> | [<code class="nowrap">setenv</code>](/basics/os/#setenv) | set an environment variable
<code class="nowrap">K.show()</code> | <code class="nowrap">q.show()</code> | [<code class="nowrap">show</code>](/basics/devtools/#show) | format to the console
<code class="nowrap">K.signum()</code> | <code class="nowrap">q.signum()</code> | [<code class="nowrap">signum</code>](/basics/arith-integer/#signum) | sign of its argument/s
<code class="nowrap">K.sin()</code> | <code class="nowrap">q.sin()</code> | [<code class="nowrap">sin</code>](/basics/trig/#sin) | sine
<code class="nowrap">K.sqrt()</code> | <code class="nowrap">q.sqrt()</code> | [<code class="nowrap">sqrt</code>](/basics/arith-float/#sqrt) | square root
<code class="nowrap">K.ss()</code> | <code class="nowrap">q.ss()</code> | [<code class="nowrap">ss</code>](/basics/strings/#ss) | string search
<code class="nowrap">K.ssr()</code> | <code class="nowrap">q.ssr()</code> | [<code class="nowrap">ssr</code>](/basics/strings/#ssr) | string search and replace
<code class="nowrap">K.string()</code> | <code class="nowrap">q.string()</code> | [<code class="nowrap">string</code>](/basics/casting/#string) | cast to string
<code class="nowrap">K.sublist()</code> | <code class="nowrap">q.sublist()</code> | [<code class="nowrap">sublist</code>](/basics/selection/#sublist) | sublist of a list
<code class="nowrap">K.sum()</code> | <code class="nowrap">q.sum()</code> | [<code class="nowrap">sum</code>](/basics/arith-integer/#sum) | sum of a list
<code class="nowrap">K.sums()</code> | <code class="nowrap">q.sums()</code> | [<code class="nowrap">sums</code>](/basics/arith-integer/#sums) | cumulative sums of a list
<code class="nowrap">K.sv()</code> | <code class="nowrap">q.sv()</code> | [<code class="nowrap">sv</code>](/basics/lists/#sv) | consolidate
<code class="nowrap">K.svar()</code> | <code class="nowrap">q.svar()</code> | [<code class="nowrap">svar</code>](/basics/stats-aggregates/#svar-statistical-variance) | statistical variance
<code class="nowrap">K.svar()</code> | <code class="nowrap">q.svar()</code> | [<code class="nowrap">svar</code>](/basics/stats-aggregates/#svar-statistical-variance) | statistical variance
<code class="nowrap">K.system()</code> | <code class="nowrap">q.system()</code> | [<code class="nowrap">system</code>](/basics/syscmds) | system
<code class="nowrap">K.tables()</code> | <code class="nowrap">q.tables()</code> | [<code class="nowrap">tables</code>](/basics/metadata/#tables) | sorted list of tables
<code class="nowrap">K.tan()</code> | <code class="nowrap">q.tan()</code> | [<code class="nowrap">tan</code>](/basics/trig/#tan) | tangent
<code class="nowrap">K.til()</code> | <code class="nowrap">q.til()</code> | [<code class="nowrap">til</code>](/basics/arith-integer/#til) | integers up to x
<code class="nowrap">K.trim()</code> | <code class="nowrap">q.trim()</code> | [<code class="nowrap">trim</code>](/basics/strings/#trim) | remove leading and trailing spaces
<code class="nowrap">K.type()</code> | <code class="nowrap">q.type()</code> | [<code class="nowrap">type</code>](/basics/metadata/#type) | data type
<code class="nowrap">K.uj()</code> | <code class="nowrap">q.uj()</code> | [<code class="nowrap">uj</code>](/basics/joins/#uj-ujf-union-join) | union join
<code class="nowrap">K.ujf()</code> | <code class="nowrap">q.ujf()</code> | [<code class="nowrap">ujf</code>](/basics/joins/#uj-ujf-union-join) | The ujf function.
<code class="nowrap">K.ungroup()</code> | <code class="nowrap">q.ungroup()</code> | [<code class="nowrap">ungroup</code>](/basics/dictsandtables/#ungroup) | flattened table
<code class="nowrap">K.union()</code> | <code class="nowrap">q.union()</code> | [<code class="nowrap">union</code>](/basics/selection/#union) | distinct items of combination of two lists
<code class="nowrap">K.upper()</code> | <code class="nowrap">q.upper()</code> | [<code class="nowrap">upper</code>](/basics/strings/#upper) | upper-case
<code class="nowrap">K.upsert()</code> | <code class="nowrap">q.upsert()</code> | [<code class="nowrap">upsert</code>](/basics/qsql/#upsert) | add table records
<code class="nowrap">K.value()</code> | <code class="nowrap">q.value()</code> | [<code class="nowrap">value</code>](/basics/dotz/#zvs-value-set) | value
<code class="nowrap">K.var()</code> | <code class="nowrap">q.var()</code> | [<code class="nowrap">var</code>](/basics/stats-aggregates/#var-variance) | variance
<code class="nowrap">K.view()</code> | <code class="nowrap">q.view()</code> | [<code class="nowrap">view</code>](/basics/metadata/#view) | definition of a dependency
<code class="nowrap">K.views()</code> | <code class="nowrap">q.views()</code> | [<code class="nowrap">views</code>](/basics/environment/#views) | list of defined views
<code class="nowrap">K.vs()</code> | <code class="nowrap">q.vs()</code> | [<code class="nowrap">vs</code>](/basics/lists/#vs) | split
<code class="nowrap">K.wavg()</code> | <code class="nowrap">q.wavg()</code> | [<code class="nowrap">wavg</code>](/basics/stats-aggregates/#wavg-weighted-average) | weighted average
<code class="nowrap">K.where()</code> | <code class="nowrap">q.where()</code> | [<code class="nowrap">where</code>](/basics/selection/#where) | replicated items
<code class="nowrap">K.within()</code> | <code class="nowrap">q.within()</code> | [<code class="nowrap">within</code>](/basics/search/#within) | flag items within range
<code class="nowrap">K.wj()</code> | <code class="nowrap">q.wj()</code> | [<code class="nowrap">wj</code>](/basics/joins/#wj-wj1-window-join) | window join
<code class="nowrap">K.wj1()</code> | <code class="nowrap">q.wj1()</code> | [<code class="nowrap">wj1</code>](/basics/joins/#wj-wj1-window-join) | window join
<code class="nowrap">K.wsum()</code> | <code class="nowrap">q.wsum()</code> | [<code class="nowrap">wsum</code>](/basics/stats-aggregates/#wsum-weighted-sum) | weighted sum
<code class="nowrap">K.ww()</code> | <code class="nowrap">q.ww()</code> | [<code class="nowrap">ww</code>](/basics/stats-aggregates/#wsum-weighted-sum) | The ww function.
<code class="nowrap">K.xasc()</code> | <code class="nowrap">q.xasc()</code> | [<code class="nowrap">xasc</code>](/basics/dictsandtables/#xasc) | table sorted ascending by columns
<code class="nowrap">K.xbar()</code> | <code class="nowrap">q.xbar()</code> | [<code class="nowrap">xbar</code>](/basics/arith-integer/#xbar) | interval bar
<code class="nowrap">K.xcol()</code> | <code class="nowrap">q.xcol()</code> | [<code class="nowrap">xcol</code>](/basics/dictsandtables/#xcol) | rename table columns
<code class="nowrap">K.xcols()</code> | <code class="nowrap">q.xcols()</code> | [<code class="nowrap">xcols</code>](/basics/dictsandtables/#xcols) | re-order table columns
<code class="nowrap">K.xdesc()</code> | <code class="nowrap">q.xdesc()</code> | [<code class="nowrap">xdesc</code>](/basics/dictsandtables/#xdesc) | table sorted descending by columns
<code class="nowrap">K.xexp()</code> | <code class="nowrap">q.xexp()</code> | [<code class="nowrap">xexp</code>](/basics/arith-float/#xexp) | raised to a power
<code class="nowrap">K.xgroup()</code> | <code class="nowrap">q.xgroup()</code> | [<code class="nowrap">xgroup</code>](/basics/dictsandtables/#xgroup) | table grouped by keys
<code class="nowrap">K.xkey()</code> | <code class="nowrap">q.xkey()</code> | [<code class="nowrap">xkey</code>](/basics/dictsandtables/#xkey) | set primary keys of a table
<code class="nowrap">K.xlog()</code> | <code class="nowrap">q.xlog()</code> | [<code class="nowrap">xlog</code>](/basics/arith-float/#xlog) | base-x logarithm
<code class="nowrap">K.xprev()</code> | <code class="nowrap">q.xprev()</code> | [<code class="nowrap">xprev</code>](/basics/selection/#xprev) | previous items
<code class="nowrap">K.xrank()</code> | <code class="nowrap">q.xrank()</code> | [<code class="nowrap">xrank</code>](/basics/sort/#xrank) | items assigned to buckets


<!-- PyQ | q   | function
----|-----|---------------------------------
<code class="nowrap">q.abs()</code> | [<code class="nowrap">abs</code>](/basics/arith-integer#abs) | absolute value The `abs` function computes the absolute value of its argument. Null is returned if the argument is null.<br/>`>>> q.abs([-1, 0, 1, None])`<br/>`k('1 0 1 0N')`
<code class="nowrap">q.acos()</code> | [<code class="nowrap">acos</code>](/basics/trig#acos) | arc cosine
<code class="nowrap">q.aj()</code> | [<code class="nowrap">aj</code>](/basics/joins#aj-aj0-asof-join) | as-of join
<code class="nowrap">q.aj0()</code> | [<code class="nowrap">aj</code>](/basics/joins#aj-aj0-asof-join) | as-of join
<code class="nowrap">q.all()</code> | [<code class="nowrap">all</code>](/basics/logic#all) | all nonzero
<code class="nowrap">q.and_()</code> | [<code class="nowrap">and</code>](/basics/logic#and-minimum) | and
<code class="nowrap">q.any()</code> | [<code class="nowrap">any</code>](/basics/logic#any) | any item is non-zero
<code class="nowrap">q.asc()</code> | [<code class="nowrap">asc</code>](/basics/sort#asc) | ascending sort
<code class="nowrap">q.asin()</code> | [<code class="nowrap">asin</code>](/basics/trig#asin) | arc sine
<code class="nowrap">q.asof()</code> | [<code class="nowrap">asof</code>](/basics/joins#asof) | as-of operator
<code class="nowrap">q.atan()</code> | [<code class="nowrap">atan</code>](/basics/trig#atan) | arc tangent
<code class="nowrap">q.attr()</code> | [<code class="nowrap">attr</code>](/basics/metadata#attr) | attributes
<code class="nowrap">q.avg()</code> | [<code class="nowrap">avg</code>](/basics/stats-aggregates#avg-average) | arithmetic mean
<code class="nowrap">q.avgs()</code> | [<code class="nowrap">avgs</code>](/basics/stats-aggregates#avgs-averages) | running averages
<code class="nowrap">q.bin()</code> | [<code class="nowrap">bin</code>](/basics/search#bin-binr) | binary search
<code class="nowrap">q.binr()</code> | [<code class="nowrap">bin</code>](/basics/search#bin-binr) | binary search
<code class="nowrap">q.ceiling()</code> | [<code class="nowrap">ceiling</code>](/basics/arith-integer#ceiling) | lowest integer above
<code class="nowrap">q.cols()</code> | [<code class="nowrap">cols</code>](/basics/metadata#cols) | column names of a table
<code class="nowrap">q.cor()</code> | [<code class="nowrap">cor</code>](/basics/stats-aggregates#cor-correlation) | correlation
<code class="nowrap">q.cos()</code> | [<code class="nowrap">cos</code>](/basics/trig#cos) | cosine
<code class="nowrap">q.count()</code> | [<code class="nowrap">count</code>](/basics/lists#count) | number of items
<code class="nowrap">q.cov()</code> | [<code class="nowrap">cov</code>](/basics/stats-aggregates#cov-covariance) | statistical covariance
<code class="nowrap">q.cross()</code> | [<code class="nowrap">cross</code>](/basics/lists#cross) | cross product
<code class="nowrap">q.csv()</code> | [<code class="nowrap">csv</code>](/basics/filewords#csv) | comma delimiter
<code class="nowrap">q.cut()</code> | [<code class="nowrap">cut</code>](/basics/lists/#_-cut) | cut
<code class="nowrap">q.deltas()</code> | [<code class="nowrap">deltas</code>](/basics/arith-integer#deltas) | differences between consecutive pairs
<code class="nowrap">q.desc()</code> | [<code class="nowrap">desc</code>](/basics/sort#desc) | descending sort
<code class="nowrap">q.dev()</code> | [<code class="nowrap">dev</code>](/basics/stats-aggregates#dev-standard-deviation) | standard deviation
<code class="nowrap">q.differ()</code> | [<code class="nowrap">differ</code>](/basics/comparison#differ) | flag differences in consecutive pairs
<code class="nowrap">q.distinct()</code> | [<code class="nowrap">distinct</code>](/basics/search#distinct) | unique items
<code class="nowrap">q.div()</code> | [<code class="nowrap">div</code>](/basics/arith-integer#div) | integer division
<code class="nowrap">q.dsave()</code> | [<code class="nowrap">dsave</code>](/basics/filewords#dsave) | save global tables to disk
<code class="nowrap">q.ej()</code> | [<code class="nowrap">ej</code>](/basics/joins#ej-equi-join) | equi-join
<code class="nowrap">q.ema()</code> | [<code class="nowrap">ema</code>](/basics/stats-moving#ema) | exponentially-weighted moving average
<code class="nowrap">q.ema()</code> | [<code class="nowrap">ema</code>](/basics/stats-moving#ema) | exponentially-weighted moving average
<code class="nowrap">q.enlist()</code> | [<code class="nowrap">enlist</code>](/basics/lists#enlist) | arguments as a list
<code class="nowrap">q.eval()</code> | [<code class="nowrap">eval</code>](/basics/parsetrees#eval) | evaluate a parse tree
<code class="nowrap">q.except_()</code> | [<code class="nowrap">except</code>](/basics/selection#except) | left argument without items in right argument
<code class="nowrap">q.exp()</code> | [<code class="nowrap">exp</code>](/basics/arith-float#exp) | power of e
<code class="nowrap">q.fby()</code> | [<code class="nowrap">fby</code>](/basics/qsql#fby) | filter-by
<code class="nowrap">q.fills()</code> | [<code class="nowrap">fills</code>](/basics/lists#fills) | forward-fill nulls
<code class="nowrap">q.first()</code> | [<code class="nowrap">first</code>](/basics/selection#first) | first item
<code class="nowrap">q.fkeys()</code> | [<code class="nowrap">fkeys</code>](/basics/metadata#fkeys) | foreign-key columns mapped to their tables
<code class="nowrap">q.flip()</code> | [<code class="nowrap">flip</code>](/basics/lists#flip) | transpose
<code class="nowrap">q.floor()</code> | [<code class="nowrap">floor</code>](/basics/arith-integer#floor) | greatest integer less than argument
<code class="nowrap">q.get()</code> | [<code class="nowrap">get</code>](/basics/dotz#zpg-get) | get
<code class="nowrap">q.getenv()</code> | [<code class="nowrap">getenv</code>](/basics/os#getenv) | value of an environment variable
<code class="nowrap">q.group()</code> | [<code class="nowrap">group</code>](/basics/dictsandtables#group) | dictionary of distinct items
<code class="nowrap">q.gtime()</code> | [<code class="nowrap">gtime</code>](/basics/os#gtime) | UTC timestamp
<code class="nowrap">q.hclose()</code> | [<code class="nowrap">hclose</code>](/basics/filewords#hclose) | close a file or process
<code class="nowrap">q.hcount()</code> | [<code class="nowrap">hcount</code>](/basics/filewords#hcount) | size of a file
<code class="nowrap">q.hdel()</code> | [<code class="nowrap">hdel</code>](/basics/filewords#hdel) | delete a file
<code class="nowrap">q.hopen()</code> | [<code class="nowrap">hopen</code>](/basics/filewords#hopen) | open a file
<code class="nowrap">q.hsym()</code> | [<code class="nowrap">hsym</code>](/basics/filewords#hsym) | convert symbol to filename or IP address
<code class="nowrap">q.iasc()</code> | [<code class="nowrap">iasc</code>](/basics/sort#iasc) | indices of ascending sort
<code class="nowrap">q.idesc()</code> | [<code class="nowrap">idesc</code>](/basics/sort#idesc) | indices of descending sort
<code class="nowrap">q.ij()</code> | [<code class="nowrap">ij</code>](/basics/joins#ij-ijf-inner-join) | inner join
<code class="nowrap">q.ijf()</code> | [<code class="nowrap">ijf</code>](/basics/joins#ij-ijf-inner-join) | The ijf function.
<code class="nowrap">q.in_()</code> | [<code class="nowrap">in</code>](/basics/search#in) | membership
<code class="nowrap">q.insert()</code> | [<code class="nowrap">insert</code>](/basics/qsql#insert) | append records to a table
<code class="nowrap">q.inter()</code> | [<code class="nowrap">inter</code>](/basics/selection#inter) | items common to both arguments
<code class="nowrap">q.inv()</code> | [<code class="nowrap">inv</code>](/basics/matrixes#inv) | matrix inverse
<code class="nowrap">q.key()</code> | [<code class="nowrap">key</code>](/basics/dictsandtables#key) | key
<code class="nowrap">q.keys()</code> | [<code class="nowrap">keys</code>](/basics/metadata#keys) | names of a table’s columns
<code class="nowrap">q.last()</code> | [<code class="nowrap">last</code>](/basics/selection#last) | last item
<code class="nowrap">q.like()</code> | [<code class="nowrap">like</code>](/basics/strings#like) | pattern matching
<code class="nowrap">q.lj()</code> | [<code class="nowrap">lj</code>](/basics/joins#lj-ljf-left-join) | left join
<code class="nowrap">q.ljf()</code> | [<code class="nowrap">ljf</code>](/basics/joins#lj-ljf-left-join) | left join
<code class="nowrap">q.load()</code> | [<code class="nowrap">load</code>](/basics/filewords#load) | load binary data
<code class="nowrap">q.log()</code> | [<code class="nowrap">log</code>](/basics/arith-float#log) | natural logarithm
<code class="nowrap">q.lower()</code> | [<code class="nowrap">lower</code>](/basics/strings#lower) | lower case
<code class="nowrap">q.lsq()</code> | [<code class="nowrap">lsq</code>](/basics/matrixes#lsq) | least squares matrix divide
<code class="nowrap">q.ltime()</code> | [<code class="nowrap">ltime</code>](/basics/os#ltime) | local timestamp
<code class="nowrap">q.ltrim()</code> | [<code class="nowrap">ltrim</code>](/basics/strings#ltrim) | function remove leading spaces
<code class="nowrap">q.mavg()</code> | [<code class="nowrap">mavg</code>](/basics/stats-moving#mavg) | moving average
<code class="nowrap">q.max()</code> | [<code class="nowrap">max</code>](/basics/stats-aggregates#max-maximum) | maximum
<code class="nowrap">q.maxs()</code> | [<code class="nowrap">maxs</code>](/basics/stats-aggregates#maxs-maximums) | maxima of preceding items
<code class="nowrap">q.mcount()</code> | [<code class="nowrap">mcount</code>](/basics/stats-moving#mcount) | moving count
<code class="nowrap">q.md5()</code> | [<code class="nowrap">md5</code>](/basics/strings#md5) | MD5 hash
<code class="nowrap">q.mdev()</code> | [<code class="nowrap">mdev</code>](/basics/stats-moving#mdev) | moving deviation
<code class="nowrap">q.med()</code> | [<code class="nowrap">med</code>](/basics/stats-aggregates#med-median) | median
<code class="nowrap">q.meta()</code> | [<code class="nowrap">meta</code>](/basics/metadata#meta) | metadata of a table
<code class="nowrap">q.min()</code> | [<code class="nowrap">min</code>](/basics/stats-aggregates#min-minimum) | minimum
<code class="nowrap">q.mins()</code> | [<code class="nowrap">mins</code>](/basics/stats-aggregates#mins-minimums) | minimum of preceding items
<code class="nowrap">q.mmax()</code> | [<code class="nowrap">mmax</code>](/basics/stats-moving#mmax) | moving maxima
<code class="nowrap">q.mmin()</code> | [<code class="nowrap">mmin</code>](/basics/stats-moving#mmin) | moving minima
<code class="nowrap">q.mmu()</code> | [<code class="nowrap">mmu</code>](/basics/matrixes#mmu) | mmu
<code class="nowrap">q.mod()</code> | [<code class="nowrap">mod</code>](/basics/arith-integer#mod) | remainder
<code class="nowrap">q.msum()</code> | [<code class="nowrap">msum</code>](/basics/stats-moving#msum) | moving sum
<code class="nowrap">q.neg()</code> | [<code class="nowrap">neg</code>](/basics/arith-integer#neg) | negate
<code class="nowrap">q.next()</code> | [<code class="nowrap">next</code>](/basics/selection#next) | next items
<code class="nowrap">q.not_()</code> | [<code class="nowrap">not</code>](/basics/comparison#six-comparison-operators) | not
<code class="nowrap">q.null()</code> | [<code class="nowrap">null</code>](/basics/unclassified#null) | null
<code class="nowrap">q.or_()</code> | [<code class="nowrap">or</code>](/basics/logic#or-maximum) | or
<code class="nowrap">q.parse()</code> | [<code class="nowrap">parse</code>](/basics/parsetrees#parse) | parse a string
<code class="nowrap">q.peach()</code> | [<code class="nowrap">peach</code>](/basics/dotz#zpd-peach-handles) | peach
<code class="nowrap">q.pj()</code> | [<code class="nowrap">pj</code>](/basics/joins#pj-plus-join) | plus join
<code class="nowrap">q.prd()</code> | [<code class="nowrap">prd</code>](/basics/arith-float#prd) | product
<code class="nowrap">q.prds()</code> | [<code class="nowrap">prds</code>](/basics/arith-float#prds) | cumulative products
<code class="nowrap">q.prev()</code> | [<code class="nowrap">prev</code>](/basics/selection#prev) | previous items
<code class="nowrap">q.prior()</code> | [<code class="nowrap">prior</code>](/basics/control#prior) | prior
<code class="nowrap">q.rand()</code> | [<code class="nowrap">rand</code>](/basics/random#rand) | random number
<code class="nowrap">q.rank()</code> | [<code class="nowrap">rank</code>](/basics/sort#rank) | grade up
<code class="nowrap">q.ratios()</code> | [<code class="nowrap">ratios</code>](/basics/arith-float#ratios) | ratios of consecutive pairs
<code class="nowrap">q.raze()</code> | [<code class="nowrap">raze</code>](/basics/lists#raze) | join items
<code class="nowrap">q.read0()</code> | [<code class="nowrap">read0</code>](/basics/filewords#read0) | read file as lines
<code class="nowrap">q.read1()</code> | [<code class="nowrap">read1</code>](/basics/filewords#read1) | read file as bytes
<code class="nowrap">q.reciprocal()</code> | [<code class="nowrap">reciprocal</code>](/basics/arith-float#reciprocal) | reciprocal of a number
<code class="nowrap">q.reval()</code> | [<code class="nowrap">reval</code>](/basics/parsetrees#reval) | variation of eval
<code class="nowrap">q.reverse()</code> | [<code class="nowrap">reverse</code>](/basics/lists#reverse) | reverse the order of items
<code class="nowrap">q.rload()</code> | [<code class="nowrap">rload</code>](/basics/filewords#rload) | load a splayed table
<code class="nowrap">q.rotate()</code> | [<code class="nowrap">rotate</code>](/basics/lists#rotate) | rotate items
<code class="nowrap">q.rsave()</code> | [<code class="nowrap">rsave</code>](/basics/filewords#rsave) | rsave
<code class="nowrap">q.rtrim()</code> | [<code class="nowrap">rtrim</code>](/basics/strings#rtrim) | remove trailing spaces
<code class="nowrap">q.save()</code> | [<code class="nowrap">save</code>](/basics/filewords#save) | save global data to file
<code class="nowrap">q.scov()</code> | [<code class="nowrap">scov</code>](/basics/stats-aggregates#scov-statistical-covariance) | statistical covariance
<code class="nowrap">q.scov()</code> | [<code class="nowrap">scov</code>](/basics/stats-aggregates#scov-statistical-covariance) | statistical covariance
<code class="nowrap">q.sdev()</code> | [<code class="nowrap">sdev</code>](/basics/stats-aggregates#sdev-statistical-standard-deviation) | statistical standard deviation
<code class="nowrap">q.sdev()</code> | [<code class="nowrap">sdev</code>](/basics/stats-aggregates#sdev-statistical-standard-deviation) | statistical standard deviation
<code class="nowrap">q.set()</code> | [<code class="nowrap">set</code>](/basics/dotz#zps-set) | set
<code class="nowrap">q.setenv()</code> | [<code class="nowrap">setenv</code>](/basics/os#setenv) | set an environment variable
<code class="nowrap">q.show()</code> | [<code class="nowrap">show</code>](/basics/devtools#show) | format to the console
<code class="nowrap">q.signum()</code> | [<code class="nowrap">signum</code>](/basics/arith-integer#signum) | sign of its argument/s
<code class="nowrap">q.sin()</code> | [<code class="nowrap">sin</code>](/basics/trig#sin) | sine
<code class="nowrap">q.sqrt()</code> | [<code class="nowrap">sqrt</code>](/basics/arith-float#sqrt) | square root
<code class="nowrap">q.ss()</code> | [<code class="nowrap">ss</code>](/basics/strings#ss) | string search
<code class="nowrap">q.ssr()</code> | [<code class="nowrap">ssr</code>](/basics/strings#ssr) | string search and replace
<code class="nowrap">q.string()</code> | [<code class="nowrap">string</code>](/basics/casting#string) | cast to string
<code class="nowrap">q.sublist()</code> | [<code class="nowrap">sublist</code>](/basics/selection#sublist) | sublist of a list
<code class="nowrap">q.sum()</code> | [<code class="nowrap">sum</code>](/basics/arith-integer#sum) | sum of a list
<code class="nowrap">q.sums()</code> | [<code class="nowrap">sums</code>](/basics/arith-integer#sums) | cumulative sums of a list
<code class="nowrap">q.sv()</code> | [<code class="nowrap">sv</code>](/basics/lists#sv) | consolidate
<code class="nowrap">q.svar()</code> | [<code class="nowrap">svar</code>](/basics/stats-aggregates#svar-statistical-variance) | statistical variance
<code class="nowrap">q.svar()</code> | [<code class="nowrap">svar</code>](/basics/stats-aggregates#svar-statistical-variance) | statistical variance
<code class="nowrap">q.system()</code> | [<code class="nowrap">system</code>](/basics/syscmds) | system
<code class="nowrap">q.tables()</code> | [<code class="nowrap">tables</code>](/basics/metadata#tables) | sorted list of tables
<code class="nowrap">q.tan()</code> | [<code class="nowrap">tan</code>](/basics/trig#tan) | tangent
<code class="nowrap">q.til()</code> | [<code class="nowrap">til</code>](/basics/arith-integer#til) | integers up to x
<code class="nowrap">q.trim()</code> | [<code class="nowrap">trim</code>](/basics/strings#trim) | remove leading and trailing spaces
<code class="nowrap">q.type()</code> | [<code class="nowrap">type</code>](/basics/metadata#type) | data type
<code class="nowrap">q.uj()</code> | [<code class="nowrap">uj</code>](/basics/joins#uj-ujf-union-join) | union join
<code class="nowrap">q.ujf()</code> | [<code class="nowrap">ujf</code>](/basics/joins#uj-ujf-union-join) | The ujf function.
<code class="nowrap">q.ungroup()</code> | [<code class="nowrap">ungroup</code>](/basics/dictsandtables#ungroup) | flattened table
<code class="nowrap">q.union()</code> | [<code class="nowrap">union</code>](/basics/selection#union) | distinct items of combination of two lists
<code class="nowrap">q.upper()</code> | [<code class="nowrap">upper</code>](/basics/strings#upper) | upper-case
<code class="nowrap">q.upsert()</code> | [<code class="nowrap">upsert</code>](/basics/qsql#upsert) | add table records
<code class="nowrap">q.value()</code> | [<code class="nowrap">value</code>](/basics/dotz#zvs-value-set) | value
<code class="nowrap">q.var()</code> | [<code class="nowrap">var</code>](/basics/stats-aggregates#var-variance) | variance
<code class="nowrap">q.view()</code> | [<code class="nowrap">view</code>](/basics/metadata#view) | definition of a dependency
<code class="nowrap">q.views()</code> | [<code class="nowrap">views</code>](/basics/environment#views) | list of defined views
<code class="nowrap">q.vs()</code> | [<code class="nowrap">vs</code>](/basics/lists#vs) | split
<code class="nowrap">q.wavg()</code> | [<code class="nowrap">wavg</code>](/basics/stats-aggregates#wavg-weighted-average) | weighted average
<code class="nowrap">q.where()</code> | [<code class="nowrap">where</code>](/basics/selection#where) | replicated items
<code class="nowrap">q.within()</code> | [<code class="nowrap">within</code>](/basics/search#within) | flag items within range
<code class="nowrap">q.wj()</code> | [<code class="nowrap">wj</code>](/basics/joins#wj-wj1-window-join) | window join
<code class="nowrap">q.wj1()</code> | [<code class="nowrap">wj1</code>](/basics/joins#wj-wj1-window-join) | window join
<code class="nowrap">q.wsum()</code> | [<code class="nowrap">wsum</code>](/basics/stats-aggregates#wsum-weighted-sum) | weighted sum
<code class="nowrap">q.ww()</code> | [<code class="nowrap">ww</code>](/basics/stats-aggregates#wsum-weighted-sum) | The ww function.
<code class="nowrap">q.xasc()</code> | [<code class="nowrap">xasc</code>](/basics/dictsandtables#xasc) | table sorted ascending by columns
<code class="nowrap">q.xbar()</code> | [<code class="nowrap">xbar</code>](/basics/arith-integer#xbar) | interval bar
<code class="nowrap">q.xcol()</code> | [<code class="nowrap">xcol</code>](/basics/dictsandtables#xcol) | rename table columns
<code class="nowrap">q.xcols()</code> | [<code class="nowrap">xcols</code>](/basics/dictsandtables#xcols) | re-order table columns
<code class="nowrap">q.xdesc()</code> | [<code class="nowrap">xdesc</code>](/basics/dictsandtables#xdesc) | table sorted descending by columns
<code class="nowrap">q.xexp()</code> | [<code class="nowrap">xexp</code>](/basics/arith-float#xexp) | raised to a power
<code class="nowrap">q.xgroup()</code> | [<code class="nowrap">xgroup</code>](/basics/dictsandtables#xgroup) | table grouped by keys
<code class="nowrap">q.xkey()</code> | [<code class="nowrap">xkey</code>](/basics/dictsandtables#xkey) | set primary keys of a table
<code class="nowrap">q.xlog()</code> | [<code class="nowrap">xlog</code>](/basics/arith-float#xlog) | base-x logarithm
<code class="nowrap">q.xprev()</code> | [<code class="nowrap">xprev</code>](/basics/selection#xprev) | previous items
<code class="nowrap">q.xrank()</code> | [<code class="nowrap">xrank</code>](/basics/sort#xrank) | items assigned to buckets
 <code class="nowrap">pyq.kerr</code> |   | alias of `error`
 -->

