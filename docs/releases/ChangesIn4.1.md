---
title: Changes in 4.1 | Releases | Documentation for kdb+ and the q programming language
description: Changes to V4.1 of kdb+ from the previous version
authors: [Charles Skelton, Simon Shanks, Michaela Woods]
date: [February 2024]
---
# Changes in 4.1

The README.txt of the current 4.1 release contains a full list of changes. Some of the highlights are listed below.

## Production release date

2024.02.13

## :fontawesome-solid-code: q Language Features for Enhanced Readability and Flexibility

### :fontawesome-solid-code: Dictionary Literal Syntax 

With dictionary literals, you can concisely define dictionaries. Compare 
```q
q)enlist[`aaa]!enlist 123 / 4.0 
aaa| 123 
```
 with 
```q
q)([aaa:123]) / 4.1 
aaa| 123 
```
This syntax follows rules consistent with list and table literal syntax.
```q
q)([0;1;2]) / implicit key names
x | 0
x1| 1
x2| 2
q)d:([a:101;b:]);d 102 / missing values create projections
a| 101
b| 102
q)d each`AA`BB`CC
a   b
------
101 AA
101 BB
101 CC
```
Similar to list literal syntax `(;..)`, omission of values results in projection
```q
q)([k1:;k2:])[1;"a"]
k1| 1
k2| "a"
```

### :fontawesome-solid-code: Pattern Matching

Assignment has been extended so the left-hand side of the colon (:) can now be a pattern. 
```q
q)a:1 / atom (old school) 
q)(b;c):(2;3) / list (nice!) 
q)([four:d]):`one`two`three`four`five!1 2 3 4 5 / dictionary (match a subset of keys) 
q)([]x2:e):([]1 2;3 4;5 6) / table (what?!) 
q)a,b,c,d,e 
1 2 3 4 5 6 
```
Before assigning any variables, q ensures that left and right values match. 
```q
q)(1b;;x):(1b;`anything;1 2 3) / empty patterns match anything 
q)x 
1 2 3 
```
Failure to match throws an error without assigning. 
```q
q)(1b;y):(0b;3 2 1) 
'match 
q)y 
'y 
```

### :fontawesome-solid-code: Type Checking

While we're checking patterns, we can also check types.
```q
q)(surname:`s):`simpson
q)(name:`s;age:`h):(`homer;38h)
q)(name:`s;age:`h):(`marge;36.5) / d'oh
'type
q)name,surname / woohoo!
`homer`simpson
```
kdb+ can check function parameters too.
```q
q)fluxCapacitor:{[(src:`j;dst:`j);speed:`f]$[speed<88;src;dst]}
q)fluxCapacitor[1955 1985]87.9
1955
q)fluxCapacitor[1955 1985]88
'type
q)fluxCapacitor[1955 1985]88.1 / Great Scott!
1985
```

### :fontawesome-solid-code: Filter Functions

We can extend this basic type checking to define our own 'filter functions' to run before assignment.
```q
q)tempCheck:{$[x<0;'"too cold";x>40;'"too hot";x]} / return the value (once we're happy)
q)c2f:{[x:tempCheck]32+1.8*x}
q)c2f -4.5
'too cold
q)c2f 42.8
'too hot
q)c2f 20 / just right
68f
```
We can use filter functions to change the values that we are assigning,
```q
q)(a;b:10+;c:100+):1 2 3
q)a,b,c
1 12 103
```
amend values at depth without assignment,
```q
q)addv:{([v:(;:x+;:(x*10)+)]):y}
q)addv[10;([k:`hello;v:1 2 3])]
k| `hello
v| 1 12 103
```
or even change the types,
```q
q)chkVals:{$[any null x:"J"$","vs x;'`badData;x]}
q)sumVals:{[x:chkVals]sum x}
q)sumVals "1,1,2,3,5,8"
20
q)sumVals "8,4,2,1,0.5"
'badData
```

## :fontawesome-solid-bolt: Peach/Parallel Processing Enhancements

[peach](../ref/each.md) enables the parallel execution of a function on multiple arguments. Significant enhancements have been made to augment its functionality:

1. Ability to nest peach statements. This means you can now apply peach within another peach, allowing for the implementation of more sophisticated and intricate parallelization strategies.

2. In previous versions, peach had certain limitations, particularly with other multithreaded primitives. The latest release eliminates these constraints, providing greater flexibility in designing parallel computations. Now, you can seamlessly integrate peach with other multithreaded operations, unlocking new possibilities for concurrent processing.

3. Use of a work-stealing algorithm. Work-stealing is an innovative technique in parallel computing, where idle processors intelligently acquire tasks from busy ones. This dynamic approach ensures a balanced distribution of tasks, leading to improved overall efficiency. This marks a departure from the previous method of pre-allocating chunks of work to each thread. The incorporation of a work-stealing algorithm translates to better utilization of CPU cores, enhancing overall computational efficiency.

In our own tests, we have seen these improvements lead to a significant reduction in processing times e.g.
```q
q)\s
8i
```
Before: kdb+ 4.0
```q
q)\t (inv peach)peach 2 4 1000 1000#8000000?1.
4406
```
After: kdb+ 4.1
```q
q)\t (inv peach)peach 2 4 1000 1000#8000000?1.
2035
```

## :fontawesome-solid-bolt: Unlimited IPC/Websocket Connections

The number of connections is now limited only by the operating system and protocol settings (system configurable).

In addition, the c-api function [sd1](../interfaces/capiref.md#sd1-set-function-on-loop) no longer imposes a limit of 1023 on the value of the descriptor submitted.

## :fontawesome-solid-bolt: HTTP Persistent Connections

kdb+ now has support for HTTP Persistent Connections via [.h.ka](../ref/doth.md#hka-http-keepalive), a feature designed to elevate the efficiency and responsiveness of your data interactions.

HTTP Persistent Connections enables multiple requests and responses to traverse over the same connection. This translates to reduced latency, optimized resource utilization, and an overall improvement in performance.

## :fontawesome-solid-bolt: Multithreaded Data Loading

The CSV load, fixed-width load ([0:](../ref/file-text.md)), and binary load ([1:](../ref/file-binary.md)) functionalities are now multithreaded. This enhancement improves performance and efficiency; it is particularly beneficial for handling large datasets across various data loading scenarios.

## :fontawesome-solid-bolt: Socket Performance

Users with a substantial number of connections can experience improved performance, thanks to significant enhancements in socket operations. Below is a comparison with version 4.0:

```q
q)h:hopen `:tcps://localhost:9999
```
Before: kdb+ 4.0
```q
q)\ts:10000 h”2+2"
1508 512
```
After: kdb+ 4.1
```q
q)\ts:10000 h”2+2"
285 512
```

## :fontawesome-solid-lock: Enhanced TLS Support and Updated OpenSSL

Enhanced TLS Support and Updated OpenSSL Support [feature](../kb/ssl.md) in our latest release.

Support for OpenSSL 1.0, 1.1.x, and 3.x, coupled with dynamic searching for OpenSSL libraries and TCP and UDS encryption, provides a robust solution for industries where data integrity and confidentiality are non-negotiable.

TLS messaging can now be utilized on threads other than the main thread. This allows for secure Inter-Process Communication (IPC) and HTTP operations in multithreaded input queue mode. 

HTTP client requests and [one-shot sync](../ref/hopen.md#one-shot-request) messages within secondary threads are facilitated through [peach](../ref/each.md).

## :fontawesome-solid-lock: More Algorithms for At-rest Compression

[Zstd](https://github.com/facebook/zstd) has been added to our [list](../kb/file-compression.md) of supported compression algorithms. The compression algorithms can also be used when [writing binary data](../ref/file-binary.md#compression) directly.

## :fontawesome-solid-triangle-exclamation: NUCs

We try to avoid introducing compatibility issues, and most of those that follow are a result of unifying behavior or tightening up loose cases.

### []a::e

[([]a::e)](../ref/overloads.md#colon-colon) now throws parse (previously was amend of global 'a' with implicit column name)

### Value inside select/exec

[value"..."](../ref/value.md) inside select/exec on the main thread previously used lambda's scope for locals; it now always uses the global scope, e.g.
```q
 q)a:0;{a:1;exec value"2*a"from([]``)}[]
 0
```

(This fixes a bug since 2.6.) 

### Dynamic Load

Loading shared libraries via [2:](../ref/dynamic-load.md) resolved to a canonical path prior to load via the OS, since v3.6 2018.08.24. This caused issues for libs whose run-time path was relative to a sym-link. It now resolves to an absolute path only, without resolving sym-links.

### Threads using subnormals

macOS/Microsoft Windows performance has been improved when using floating point calculations with subnormal numbers on threads created via multi-threaded input mode or secondary threads (rounds to zero).

### .z.o

[.z.o](../ref/dotz.md#zo-os-version) for l64arm build is now `l64arm`, previously `l64`.
.z.o for mac universal binary on arm returns `m64`, previously `m64arm`

### .Q.gc 

Added optional param (type long) to [.Q.gc](../ref/dotq.md#gc-garbage-collect) indicating how aggressively it should try to return memory to the OS.
```q
 q).Q.gc 0 / least aggressive
 q).Q.gc[] / most aggressive (continue to use this in the general case; currently matches level 2)
```

### .Q.xf and Q.Cf

Deprecated functions [.Q.Xf](../ref/dotq.md#xf-create-file) and [.Q.Cf](../ref/dotq.md#cf-create-empty-nested-char-file) have been removed. (Using resulting files could return file format errors since 3.6.)

### .Q.id

[.Q.id](../ref/dotq.md#id-sanitize) for atom now produces `a` when it contains single character that is not in [.Q.an](../ref/dotq.md#an-all-alphanumerics) (instead of empty sym) e.g
```q
q).Q.id`$"+"
`a  (previous version returned `)
```
.Q.id for atom changes are reflected in .Q.id for tables (as before, it was applied to each column name).
.Q.id for tables has additional logic to cater for duplicate col names after applying previously defined rules. Names are now appended with 1, 2, and so on, when matched against previous cols, e.g.
```q
q)cols .Q.id(`$("count+";"count*";"count1"))xcol([]1 2;3 4;5 6)
`count1`count11`count12  (previous version returned `count1`count1`count1)
q)cols .Q.id(`$("aa";"=";"+"))xcol([]1 2;3 4;5 6)
`aa`a`a1  (previous version returned `aa`1`1)
```
.Q.id now follows the same rule when the provided name begins with an underscore, as it does when it begins
with a numerical character. Previously this could produce an invalid column name.
```q
q).Q.id`$"_"
`a_
q)cols .Q.id(`$("3aa";"_aa";"_aa"))xcol([]1 2;3 4;5 6)
`a3aa`a_aa`a_aa1
```

### Block exit

kdb+ now blocks the ability to call the [exit](../ref/exit.md) command during [reval](../ref/eval.md#reval) or [-u](../basics/cmdline.md#-u-disable-syscmds) when the handle is a remote. `\\` was already blocked.

### Handles within peach

Using handles within [peach](../ref/each.md) is not supported, e.g.
```q
q)H:hopen each 4#4000;{x""}peach H
'nosocket
  [2]  {x""}
        ^
  [0]  H:hopen each 4#4000;{x""}peach H
                                ^
q))
```
[One-shot IPC requests](../ref/hopen.md#one-shot-request) can be used within peach instead.

### .z.W

[.z.W](../ref/dotz.md#zw-handles) now returns `handles!bytes` as `I!J`, instead of the former `handles!list` of individual msg sizes. Use `sum each .z.W` if writing code targetting 4.0 and 4.1.
