# $ Cast



_Convert to another datatype._

Syntax: `x$y`, `$[x;y]`

Where `x` is a lower-case letter, symbol or non-negative short atom (or list of such atoms), returns `y` cast according to `x`. A table of `x` values for _cast_:
```q
q)flip{(x;.Q.t x;key'[x$\:()])}5h$where" "<>20#.Q.t
1h  "b" `boolean
2h  "g" `guid
4h  "x" `byte
5h  "h" `short
6h  "i" `int
7h  "j" `long
8h  "e" `real
9h  "f" `float
10h "c" `char
11h "s" `symbol
12h "p" `timestamp
13h "m" `month
14h "d" `date
15h "z" `datetime
16h "n" `timespan
17h "u" `minute
18h "v" `second
19h "t" `time
```
Cast to integer:
```q
q)"i"$10
10i
q)(`int;"i";6h)$10
10 10 10i
```
Cast to boolean:
```q
q)1h$1 0 2
101b
```
Find parts of time:
```q
q)`hh`uu`ss$03:55:58.11
3 55 58i
q)`year`dd`mm`hh`uu`ss$2015.10.28D03:55:58
2015 28 10 3 55 58i
```

!!! Note "Casting string to symbol"
    When converting a string to a symbol, leading and trailing blanks are automatically trimmed:

        q)`$"   IBM   "
        `IBM

Identity:
```q
q)("*";0h)$1
10 10
q)("*";0h)$\:"2012-02-02"
"2012-02-02"
"2012-02-02"
```

!!! warning "To infinity and beyond!"

    Casting an infinity from a narrower to a wider datatype does not always return another infinity.  
    <div style="display: block; float: left; padding-right: 1em; width: 130px;" markdown="1">
    [![Buzz Lightyear](/img/earthrise.jpg)](https://www.nasa.gov/multimedia/imagegallery/image_feature_1400.html "Earthrise: NASA galleries")
    </div>
    <pre><code class="language-q">
    q)\`float$0Wh
    32767f
    </code></pre>
    Space rangers! The infinity corresponding to numeric `x` is `min 0#x`.

<i class="far fa-hand-point-right"></i> 
[dollar `$`](operators.md#dollar),
[Tok](tok.md), 
[Casting & encoding](../basics/casting.md)