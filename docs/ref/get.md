# `get`




_Read or memory-map a kdb+ data file_

Syntax: `get x`, `get[x]`

Reads or memory maps kdb+ data file `x`. 
A type error is signalled if the file is not a kdb+ data file.

Used to map columns of databases in and out of memory when querying splayed databases, and can be used to read q log files etc.

```q
q)\l trade.q
q)`:NewTrade set trade                  / save trade data to file
`:NewTrade
q)t:get`:NewTrade                       / t is a copy of the table
q)`:SNewTrade/ set .Q.en[`:.;trade]     / save splayed table
`:SNewTrade/
q)s:get`:SNewTrade/                     / s has columns mapped on demand
```

!!! Note "`get` and `value`"

    `get` has several other uses. The function [`value`](value.md) is a synonym for `get`. By convention, it is used for other purposes. But the two are completely interchangeable.

    <pre><code class="language-q">
    q)value "2+3"
    5
    q)get "2+3"
    5
    </code></pre>

==FIXME: describe other uses.==


<i class="far fa-hand-point-right"></i>
[File system](../basics/files.md)
