---
title: Shifts & scans
description: Shifts are powerful expressions for finding where the items of a list change in specific ways. Boolean shifts are commonly used to find where in a list the result of a test expression on its elements has changed. Shifts compare each list item to its neighbour, but scan results relate to the entire list – and can terminate quickly.
author: Stephen Taylor
keywords: idiom, kdb+, q, scan, shift
---
# Shifts & scans




## Shifts

Shifts are powerful expressions for finding where the items of a list change in specific ways. Boolean shifts are commonly used to find where in a list the result of a test expression on its elements has changed. 

```q
q)show x:1h$20?2
01110101001011010000b
```


### True following true

Syntax: `(&)prior x`

```q
q)(x;(&)prior x)
01110101001011010000b
00110000000001000000b
```


### True following false

Syntax: `(>)prior x`

```q
q)(x;(>)prior x)
01110101001011010000b
01000101001010010000b
```


### False following true

Syntax: `(<)prior x`

```q
q)(x;(<)prior x)
01110101001011010000b
00001010100100101000b
```


### False following false

Syntax: `not (|)prior x`

```q
q)(x;not (|)prior x)
01110101001011010000b
10000000010000000111b
```


### Changed or unchanged

Syntax: `differ x`

```q
q)(x;differ x)
01110101001011010000b
11001111101110111000b
q)(x;not differ x)
01110101001011010000b
00110000010001000111b
```

!!! tip "More than one"

    The above shifts also work on temporal and numeric values.
    


## Scans

Shifts compare each list item to its neighbour, but scan results relate to the entire list – and can terminate quickly.


### All false from first false

Syntax: `mins x`

<!-- k)&amp;\x -->
```q
q)"?"<>t:"http://example.com?foo=bar"
11111111111111111101111111b
q)mins "?"<>t
11111111111111111100000000b
q)t where mins "?"<>t
"http://example.com"
```


### All true from first true

Syntax: `maxs x`

<!-- k)|\x -->
```q
q)maxs t="?"
00000000000000000011111111b
q)t where maxs t="?"
"?foo=bar"
```


### Right to left

Scans traverse lists from left to right. Use `reverse` to traverse from right to left.

```q
q)f:"path/to/a/file.txt"
q)f="."
000000000000001000b
q)"."=reverse f
000100000000000000b
q)mins"."<>reverse f
111000000000000000b
q)f where reverse mins "."<>reverse f
"txt"
```


### Boolean finite-state machine (toggle state on false)

Syntax: `(=)scan x`

<!-- k)(=)\x -->
```q
q)(x;(=)scan x)
01110101001011010000b
00001100100111001010b
```

### Delimiters and what they embrace

Syntax: `x or(<>)scan x`
<!-- k)x|(~=)\x -->

```q
q)t:"gimme {liberty} or gimme {death}"
q){x or (<>)scan x} t in "{}"
00000011111111100000000001111111b
q)t where {x or (<>)scan x} t in "{}"
"{liberty}{death}"
```

### What delimiters embrace

Syntax: `(not x)and(<>)scan x`

<!-- k)(~x)&amp;(~=)\x -->
```q
q)t where {(not x) and (<>)scan x} t in "{}"
"libertydeath"
```

!!! tip "Beyond strings"

    The scan examples here use strings, but can readily be adapted to tests on numeric or temporal values. 

