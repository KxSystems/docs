---
title: The .j namespace – Reference – kdb+ and q documentation
description: the .j namespace contains objects useful for converting between JSON and and q dictionaries.
author: Stephen Taylor
keywords: json, kdb+, markup, q
---
# :fontawesome-brands-js: The `.j` namespace


_JSON serialization_

<pre markdown="1" class="language-txt">
[.j.j   serialize](#jj-serialize)                [.j.k   deserialize](#jk-deserialize)
[.j.jd  serialize infinity](#jjd-serialize-infinity)
</pre>

The `.j` [namespace](../basics/namespaces.md) contains functions for converting between JSON and q dictionaries.

??? warning "The `.j` namespace is reserved for use by Kx, as are all single-letter namespaces."

    Consider all undocumented functions in the namespace as its private API – and do not use them.


## `.j.j` (serialize)

Syntax: `.j.j x`

Where `x` is a K object, returns a string representing it in JSON.


## `.j.jd` (serialize infinity)

Syntax: `.j.jd (x;d)`

Where

-   `x` is a K object
-   `d` is a dictionary

returns the result of `.j.j` unless ``d`null0w``, in which case `0w` and `-0w` are mapped to `inf` and `-inf` respectively.
(Since V3.6 2018.12.06.)

```q
q).j.j -0w 0 1 2 3 0w
"[-inf,0,1,2,3,inf]"
q).j.jd(-0w 0 1 2 3 0w;()!())
"[-inf,0,1,2,3,inf]"
q).j.jd(-0w 0 1 2 3 0w;(!). 1#'`null0w,1b)
"[null,0,1,2,3,null]"
```



## `.j.k` (deserialize)

Syntax: `.j.k x`

Where `x` is a string containing JSON, returns a K object.

```q
q).j.k 0N!.j.j `a`b!(0 1;("hello";"world"))        / dictionary
"{\"a\":[0,1],\"b\":[\"hello\",\"world\"]}"
a| 0       1
b| "hello" "world"
q).j.k 0N!.j.j ([]a:1 2;b:`Greetings`Earthlings)   / table
"[{\"a\":1,\"b\":\"Greetings\"},{\"a\":2,\"b\":\"Earthlings\"}]"
a b
--------------
1 "Greetings"
2 "Earthlings"
```

!!! warning "Type conversions"

    Note from the above examples that serialization and deserialization to and from JSON may not preserve q datatype.