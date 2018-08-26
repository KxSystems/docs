After [Eugene McDonnell’s](https://en.wikipedia.org/wiki/Eugene_McDonnell) k idiom list for k2 – the original version can be found [here](http://kx.com/technical/contribs/eugene/kidioms.html).

For each idiom the layout is first the original k code is displayed, followed by the equivalent q code (prefixed by `q`) ).

## 1. Ascending ordinals (ranking, shareable)
```k
   x:11 17 12 13 13 13 13 18
   x[<x]?/:x
0 6 1 2 2 2 2 7
```
```q
q)x[iasc x] ?/: x
0 6 1 2 2 2 2 7
q)x[iasc x]?x
0 6 1 2 2 2 2 7
q)asc[x]?x
0 6 1 2 2 2 2 7
/k)<x
/q)iasc x
/?/: find eachright
```


## 2. Max scan `x` partition `y`
```k
   x:1 1 0 0 0 1 0 0 1 1
   y:3 4 8 2 5 6 9 4 5 4
   ,/|\'(&x)_ y
3 4 8 8 8 6 9 9 5 4
```
```q
q)x:1 1 0 0 0 1 0 0 1 1
q)y:3 4 8 2 5 6 9 4 5 4
q)raze maxs each (where x)_y
3 4 8 8 8 6 9 9 5 4
```


## 3. Min scan `x` partitions `y`
```k
   x:1 1 0 0 0 1 0 0 1 1
   y:3 4 8 2 5 6 9 4 5 4
   ,/&\'(&x)_ y
3 4 4 2 2 6 6 4 5 4
```
```q
q)x:1 1 0 0 0 1 0 0 1 1
q)y:3 4 8 2 5 6 9 4 5 4
q)raze mins each (where x)_y
3 4 4 2 2 6 6 4 5 4
```


## 4. Are `x` and `y`permutations of each other?
```k
   x:15 16 13 18 14 11 12
   y:15 16 13 19 14 11 12
   x[<x]~y[<y]
0
   y:15 16 13 14 18 12 11
   x[<x]~y[<y]
1
```
```q
q)x:15 16 13 18 14 11 12
q)y:15 16 13 19 14 11 12
q)(asc x)~asc y
0b
q)y:15 16 13 14 18 12 11
q)(asc x)~asc y
1b
```


## 5. Sort subvectors ascending

### 5a. Sort ascending
```k
   sa:{x[<x]}
   sa 30 10 40 20
10 20 30 40
   sa"popfly"
"floppy"
```
```q
q)sa:{asc x}
q)sa 30 10 40 20
`s#10 20 30 40
q)sa"popfly"
`s#"floppy"
```


### 5b. Indices from lengths
```k
   il:{(#x)#+\0,x}
   il 4 3
0 4
   x:10 30 20 50 60 40 5
   y:4 3
   ,/sa'(il y)_ x
10 20 30 50 5 40 60
```
```q
q)x:10 30 20 50 60 40 5
q)y:4 3
q)il:{(count x)#sums 0,x}
q)il 4 3
0 4
q)raze sa each (il y) _ x
10 20 30 50 5 40 60
```


##6. Subvector minima
```k
   x:1 1 0 0 0 1 1 0 0 1
   y:3 4 8 2 5 6 9 4 5 4
   &/'(&x)_ y
3 2 6 4 4
```
```q
q)x:1 1 0 0 0 1 1 0 0 1
q)y:3 4 8 2 5 6 9 4 5 4
q)min each (where x)_y
3 2 6 4 4
```


## 7. Subvector grade up (see 15 for down)
```k
   x:1 0 0 1 0 0 1 0
   y:14 12 18 16 13 15 11 17
   {,/x+'<:'x _ y}[&x;y]
1 0 2 4 3 5 6 7
```
```q
q)x:1 0 0 1 0 0 1 0
q)y:14 12 18 16 13 15 11 17
q){raze x +' iasc each x _ y}[where x; y]
1 0 2 4 5 3 6 7
```


## 8. Sort rows ascending
```k
   x: 3 5 _draw 10
   x
(6 3 3 9 7
9 4 4 7 9
9 4 7 8 9)
   sa'x
(3 3 6 7 9
4 4 7 9 9
4 7 8 9 9)
```
```q
q)sa:{asc x}
q)x:(6 3 3 9 7;9 4 4 7 9;9 4 7 8 9)
q)sa each x
3 3 6 7 9
4 4 7 9 9
4 7 8 9 9
```


##9. See 8


## 10. Replicate at depth; add new dimension y-fold after dimension `x` of array `z`

### 10a. Depth (`n` is depth at which to apply `f`)
```k
   d:{[n;f]:[n;_f[n-1;f]';f]}
   h:{d[x;y#,:]z}
   z:2 5#"abcdefghij"
   z
("abcde"
"fghij")
   q:h[0;3;z]
   ^q
3 2 5
   q
(("abcde"
"fghij")
("abcde"
"fghij")
("abcde"
"fghij"))
   r:h[1;3;z]
   ^r
2 3 5
   r
(("abcde"
"abcde"
"abcde")
("fghij"
"fghij"
"fghij"))
   s:h[2;3;z]
   ^s
2 5 3
   s
(("aaa"
"bbb"
"ccc"
"ddd"
"eee")
("fff"
"ggg"
"hhh"
"iii"
"jjj"))
```
```q
q)d:{[n;f] $[n;d[n-1;f]';f]}
q)h:{d[x;y#,:]z}
q)z:2 5#"abcdefghij"
q)z
"abcde"
"fghij"
q)q:h[0;3;z]
"abcde" "fghij"
"abcde" "fghij"
"abcde" "fghij"
q)r:h[1;3;z]
q)r
"abcde" "abcde" "abcde"
"fghij" "fghij" "fghij"
q)s:h[2;3;z]
q)s
"aaa" "bbb" "ccc" "ddd" "eee"
"fff" "ggg" "hhh" "iii" "jjj"
```


## 11. Merge `x`, `y`, `z`, under control of `g` (mesh)
```k
   x:"abcd"
   y:"123456789"
   z:"zz"
   g:15 _draw 3
   g
1 0 1 1 2 1 2 1 1 0 1 0 1 0 1
   (x,y,z)[<<g]
"1a23z4z56b7c8d9"
```
```q
q)x:"abcd"
q)y:"123456789"
q)z:"zz"
q)g:1 0 1 1 2 1 2 1 1 0 1 0 1 0 1
q)(x,y,z)rank g
"1a23z4z56b7c8d9"
q)k)(x,y,z)[<<g]
"1a23z4z56b7c8d9"
/Note k's ^ or shape is missing in q?
```


## 12. See 11


##13. Ascending ordinals (ranking, all different)
```k
   x:15 16 13 18 15 12 13
   <<x
3 5 1 6 4 0 2
```
```q
q)x:15 16 13 18 15 12 13
q)rank x
3 5 1 6 4 0 2
```


## 14. Subvector maxima
```k
   x:1 1 0 0 0 1 1 0 0 1
   y:3 4 8 2 5 6 9 4 5 4
   |/'(&x)_ y
3 8 6 9 4
```
```q
q)x:1 1 0 0 0 1 1 0 0 1
q)y:3 4 8 2 5 6 9 4 5 4
q)max each (where x) _ y
3 8 6 9 4
```


## 15. Subvector grade down (see 7 for up)
```
   x:1 0 0 1 0 0 1 0
   y:14 12 18 15 13 16 11 17
   {,/x+'>:'x _ y}[&x;y]
2 0 1 5 3 4 7 6
```
```q
q)x:1 0 0 1 0 0 1 0
q)y:14 12 18 15 13 16 11 17
q){raze x +' idesc each x _ y}[where x;y]
2 0 1 5 3 4 7 6
```


## 16. Merge `x` and `y` by `g`
```k
   x:5 9 8 7 4 3
   y:10 20 30 40
   g:1 0 1 1 0 0 1 0 1 1
   (x,y)[<>g]
5 10 9 8 20 30 7 40 4 3
```
```q
q)x:5 9 8 7 4 3
q)y:10 20 30 40
q)g:1 0 1 1 0 0 1 0 1 1
q)(x,y)[iasc idesc g]
5 10 9 8 20 30 7 40 4 3
```


## 17. Descending ordinals (ranking, all different)
```k
   x:15 16 13 18 14 11 12
   <>x
2 1 4 0 3 6 5
```
```q
q)x:15 16 13 18 14 11 12
q)iasc idesc x
2 1 4 0 3 6 5
```


## 18. Sort ascending by internal alphabet
```k
   w:("once";"more";"into")
   w
("once"
"more"
"into"")
   w[<`$w]
("into"
"more"
"once")
```
```q
q)w:("once";"more";"into")
q)w[iasc `$w]
"into"
"more"
"once"
q)string asc `$w
"into"
"more"
"once"
```


## 19. Sort character matrix ascending
```k
   m:("scion";"icons";"coins")
   m
("scion"
"icons"
"coins")
   m[<m]
("coins"
"icons"
"scion")
```
```q
q)m:("scion";"icons";"coins")
q)m[iasc m]
"coins"
"icons"
"scion"
```


## 20. Is `x` a permutation?
```k
   x:7 _draw -7
   x
0 5 1 6 4 3 2
   x~<<x
1
   x:7 _draw 7
   x
4 3 3 6 0 5 4
   x~<<x
0
```
```q
q)x:4 0 2 1 5 3 6
q)x~rank x
1b
q)x:4 3 3 6 0 5 4
q)x~rank x
0b
```


## 21. Rotate infixes of `y` determined by boolean `x` to the left one place

       y:"abcdefghij"
       x:1 0 1 0 0 1 1 0 0 0
       y[<x++\x]
    "badecfhijg"

    q)y[iasc x + sums x]
    "badecfhijg"



## 22. Index of first occurrence of minimum of `x`

       x:5+13 _draw 10
       x
    14 12 10 9 6 12 6 11 8 12 6 13 6
       *<x
    4
       x?&/x
    4

    q)first iasc x
    4
    q)x?min x
    4



## 23. Index of first occurrence of maximum of `x`

       x:5+13 _draw 10
       x
    11 10 8 8 8 7 5 9 12 12 10 12 8
       x?|/x
    8
       *>x
    8

    q)x?max x
    8
    q)first idesc x
    8



## 24. Median

       x:10 _draw 100
       x
    61 20 51 12 31 51 29 35 17 89
       x@<x
    12 17 20 29 31 35 51 51 61 89
       .5*+/x@(<x)@(-_t;_-t:.5*1-#x)
    33f

    q).5*sum over x[(iasc x) (neg floor t;floor neg t:.5*1-count x)]
    33f



## 25. Doubling quotes

       f:{_ssr[x;"\"";"\"\""]}
       a:"Did he say, \"Hello\"?"
       f a
    "Did he say, \"\"Hello\"\"?"

    q)f:{ssr[x;"\"";"\"\""]}
    q)a:"Did he say, \"Hello\"?"
    q)f a
    "Did he say, \"\"Hello\"\"?"
    q)ssr[a;"\"";2#] /alternative solution emphasizing doubling
    "Did he say, \"\"Hello\"\"?"



## 26. Insert `y` `"*"` after “=” in `x`

       x:"abc=,d=,fgh="
       g:&x="="
       g
    3 6 11
       y:5
       (x,"*")[(#x)&<(!#x),(y*#g)#g]
    "abc=*****,d=*****,fgh=*****"

    q)(x,"*")[(count x)&iasc (til count x),(y*count g)#g]
    "abc=*****,d=*****,fgh=*****"



## 27. Insert 0 after indices `y` of `x`

       x:"abc,def,gh"
       y:(&x=","),#x
       y
    3 7 10
       <(!#x),y
    0 1 2 3 10 4 5 6 7 11 8 9 12
       #x
    10
       (#x)><(!#x),y
    1 1 1 1 0 1 1 1 1 0 1 1 0

    q)(count x)>(iasc (til count x),y)
    1111011110110b



## 28. Insert `g` elements `h` after indices `y` of `x`

       x:"abcd=,def=,gh="
       y:&x="="
       y
    4 9 13
       g:4
       h:"x"
       a:g*#y
       a
    12
       a#y
    4 9 13 4 9 13 4 9 13 4 9 13
       (x,a#h)[<(!#x),a#y]
    "abcd=xxxx,def=xxxx,gh=xxxx"

    q)(x,a#h)[iasc (til count x),a#y]
    "abcd=xxxx,def=xxxx,gh=xxxx"



## 29. Insert `g` elements `h` before indices `y` of `x`

       x:"1234,234,34"
       y:0 5 9
       g:5
       h:"*"
       a:g*#y
       ((a#h),x)[<(a#y),!#x]
    "*****1234,*****234,*****34"

    q)((a#h),x)[iasc (a#y),til count x]
    "*****1234,*****234,*****34"



## 30. Grade up `x` according to key `y`

       x:"fig lime"
       y:" abcdefghijklmn"
       y?/:x
    6 9 7 0 12 9 13 5
       <y?/:x
    3 7 0 2 1 5 4 6
       x[3 7 0 2 1 5 4 6]
    " efgiilm"

    q)x[iasc y?/:x]
    " efgiilm"



## 31. Merge

       x:"egg"
       y:"mrin"
       g:1 0 1 0 1 1 0
       (x,y)[<<g]
    "merging"

    q)(x,y)[rank g]
    "merging"



## 32. Sort ascending indices `x` according to data `y`

       x:2 3 4 5 0 1 8 7 6
       y:79 74 78 76 77 75 73 72 71
       x[<y[x]]
    8 7 6 1 5 3 4 2 0

    q)x[iasc y[x]]
    8 7 6 1 5 3 4 2 0



## 33. Sort matrix `x` on column `y`

       x:5 6 _draw 100
       x
    (37 41 41 72 60 0
    91 59 5 19 17 26
    24 90 28 63 42 56
    75 67 45 14 38 49
    85 11 23 61 64 44)
       y:2
       x[;y]
    41 5 28 45 23
       <x[;y]
    1 4 2 0 3
       x[<x[;y];]
    (91 59 5 19 17 26
    85 11 23 61 64 44
    24 90 28 63 42 56
    37 41 41 72 60 0
    75 67 45 14 38 49)

    q)x[iasc x[;y]]
    91 59 5  19 17 26
    85 11 23 61 64 44
    24 90 28 63 42 56
    37 41 41 72 60 0
    75 67 45 14 38 49



## 34. Choose grading direction

       x:10 _draw 100
       x
    30 45 97 77 35 49 87 82 79 8
       y:1
       <x*1 -1[y]
    2 6 7 8 3 5 1 4 0 9
       y:0
       <x*1 -1[y]
    9 0 4 1 5 3 8 7 6 2

    q)iasc x*1 -1[1]
    2 6 7 8 3 5 1 4 0 9
    q)iasc x*1 -1[0]
    9 0 4 1 5 3 8 7 6 2
    /q)parse "x*1 -1[1]"
    /*
    /`x
    /(1 -1;1)
    /q)parse "iasc x*1 -1[0]"
    /<:
    /(*;`x;(1 -1;0))
    /
    /1 -1[0] is 1 and 1 -1[1] is -1 or (1;-1)[0] and (1;-1)[1]



## 35. Sort ascending

       x:10 _draw 100
       x
    84 63 31 42 95 58 9 37 84 39
       <x
    6 2 7 9 3 5 1 0 8 4
       x[<x]
    9 31 37 39 42 58 63 84 84 95

    q)iasc x
    6 2 7 9 3 5 1 0 8 4
    q)x[iasc x]
    9 31 37 39 42 58 63 84 84 95
    q)asc x
    `s#9 31 37 39 42 58 63 84 84 95



## 36. Sort `y` on `x`

       x:6 _draw 10
       y:6 _draw 20
       x
    9 2 3 1 9 3
       y
    7 8 17 11 16 6
       y[<x]
    11 8 17 6 7 16

    q)y[iasc x]
    11 8 17 6 7 16



## 37. Invert permutation (the inverse puts `y` in ascending order)

       x: 7 _draw -7
       x
    5 3 2 0 6 4 1
       <x
    3 6 2 1 5 0 4
    check:
       x[<x]
    0 1 2 3 4 5 6

    q)iasc x
    3 6 2 1 5 0 4
    q)x[iasc x]
    0 1 2 3 4 5 6



## 38. Sort matrix descending

       x:5 6 _draw 3
       x
    (0 0 0 1 0 1
    1 0 2 2 0 1
    0 2 1 1 1 1
    0 0 0 1 1 2
    1 2 2 0 2 1)
       x[<x]
    (0 0 0 1 0 1
    0 0 0 1 1 2
    0 2 1 1 1 1
    1 0 2 2 0 1
    1 2 2 0 2 1)

    q)x[iasc x]
    0 0 0 1 0 1
    0 0 0 1 1 2
    0 2 1 1 1 1
    1 0 2 2 0 1
    1 2 2 0 2 1
       y:"abcde"[5 6 _draw 5]
       y
    ("dcdbed"
    "aaaaab"
    "dcdbdc"
    "baaace"
    "eedbec")
       y[<y]
    ("aaaaab"
    "baaace"
    "dcdbdc"
    "dcdbed"
    "eedbec")



## 39. Reverse infixes in `x` of lengths `y`

       x:11+!8
       x
    11 12 13 14 15 16 17 18
       y:3 3 2
       x[|>+\(!#x)_lin il y]
    13 12 11 16 15 14 18 17

    q)il:{(count x)#sums 0,x}
    q)x:11+til 8
    q)y:3 3 2
    q)x[reverse idesc  sums(til count x) in il y]
    13 12 11 16 15 14 18 17



## 40. Reverse infixes in `x` starting at indices `y`

       x:1 0 1 0 0 1 0 0 0 1
       y:1 2 3 4 5 6 7 8 9 10
       +\x
    1 1 2 2 2 3 3 3 3 4
       >+\x
    9 5 6 7 8 2 3 4 0 1
       |>+\x
    1 0 4 3 2 8 7 6 5 9
       y[|>+\x]
    2 1 5 4 3 9 8 7 6 10

    q)y[reverse idesc sums x]
    2 1 5 4 3 9 8 7 6 10



## 41. Indices of ones in boolean vector `x`

       x:0 0 1 0 1 0 0 0 1 0
       &x
    2 4 8

    q)where x
    2 4 8



## 42. Move all blanks to end of text

       x:" sign if i cant "
       x[<" "=x]
    "significant "

    q)x[iasc " "=x]
    "significant     "



## 43. Move elements of `x` with characteristic `y` to beginning

       x:"mjinase"
       y:0 1 0 0 1 1 0
       x[>y]
    "jasmine"

    q)x[idesc y]
    "jasmine"



## 44. Sort descending

       x:8 _draw 10
       x
    3 5 0 4 5 2 4 5
       x[>x]
    5 5 5 4 4 3 2 0

    q)x[idesc x]
    5 5 5 4 4 3 2 0
    q)desc x
    5 5 5 4 4 3 2 0



## 45. Binary representation of positive integer

       x:16
       2 _vs x
    1 0 0 0 0
       x:20
       2 _vs x
    1 0 1 0 0

    /q has sv but not vs?
    /q)2 sv 1 0 0 0 0
    /16
    /not quite the same
    q)0b vs 16
    00000000000000000000000000010000b
    q)0b vs 16h
    0000000000010000b
    q)0x0 vs 16
    0x00000010
    q)0x0 vs 16h
    0x0010



## 46. Transposed formatted integers 1 through `x`

       x:15
       q:10 _vs 1+!x
       q
    (0 0 0 0 0 0 0 0 0 1 1 1 1 1 1
    1 2 3 4 5 6 7 8 9 0 1 2 3 4 5)
       "0123456789"[q]
    ("000000000111111"
    "123456789012345")



## 47. Polynomial with roots `x`

       x:1 -6 8
       {(x,0)-y*0,x}/1,x
    1 -3 -46 48

    q){(x,0)-y*0,x} over 1,x
    1 -3 -46 48

       x:2 4
       {(x,0)-y*0,x}/1,x
    1 -6 8
       x:1 2
       {(x,0)-y*0,x}/1,x
    1 -3 2
       x:1 2 3
       {(x,0)-y*0,x}/1,x
    1 -6 11 -6

    q)x:2 4
    q){(x,0)-y*0,x} over 1,x
    1 -6 8
    q)x:1 2
    q){(x,0)-y*0,x} over 1,x
    1 -3 2
    q)x:1 2 3
    q){(x,0)-y*0,x} over 1,x
    1 -6 11 -6
    /monadic adverb '/' should be spelled out as 'over'



## 48. Saddle-point indices

       x:(4 2 4 4 2 4
    > 5 3 5 5 3 5
    > 4 2 4 4 2 4
    > 1 2 4 4 2 4
    > 5 3 5 5 3 5
    > 4 2 4 4 2 4)

### 48a. Row minimum

       rn:{x='&/'x}
       rn x
    (0 1 0 0 1 0
    0 1 0 0 1 0
    0 1 0 0 1 0
    1 0 0 0 0 0
    0 1 0 0 1 0
    0 1 0 0 1 0)

    q)rn:{x=' min each x}
    q)rn x
    010010b
    010010b
    010010b
    100000b
    010010b
    010010b

### 48b. Column maximum

       cx:{x=\:|/x}
       cx x
    (0 0 0 0 0 0
    1 1 1 1 1 1
    0 0 0 0 0 0
    0 0 0 0 0 0
    1 1 1 1 1 1
    0 0 0 0 0 0)

    q)cx:{x=\:max x}
    q)cx x
    000000b
    111111b
    000000b
    000000b
    111111b
    000000b

### 48c. Minmax of rows and columns

       minmax:{(rn x)&(cx x)}
       minmax x
    (0 0 0 0 0 0
    0 1 0 0 1 0
    0 0 0 0 0 0
    0 0 0 0 0 0
    0 1 0 0 1 0
    0 0 0 0 0 0)

    q)minmax:{(rn x)&(cx x)}
    q)minmax x
    000000b
    010010b
    000000b
    000000b
    010010b
    000000b

### 48d. locate 1s in ravel of Boolean matrix

       ones:{&,/minmax x}
       ones x
    7 10 25 28

    q)ones:{where raze minmax x}
    q)ones x
    7 10 25 28

### 48e. Saddle-point indices

       sp:{(^x) _vs ones x}
       sp x
    (1 1 4 4
    1 4 1 4)
    /vs is missing (see above)



## 49. Hexadecimal from decimal

       hex:"0123456789abcdef"
       hd:{+hex[16 _vs x]}
       x:10 12 19 1 28 100
       hd x
    ("0a"
    "0c"
    "13"
    "01"
    "1c"
    "64")
       y:10 12 19 1 28 300
       hd y
    ("00a"
    "00c"
    "013"
    "001"
    "01c"
    "12c")

    /not quite the same
    q)hd:{hex[16 vs/:x]}
    q)hd 10
    ,"a"
    q)hd 20
    "14"
    q)x:10 12 19 1 28 100
    q)hd x
    ,"a"
    ,"c"
    "13"
    ,"1"
    "1c"
    "64"
    q)y:10 12 19 1 28 300
    q)hd y
    ,"a"
    ,"c"
    "13"
    ,"1"
    "1c"
    "12c"



## 50. Connectivity list from connectivity matrix

       m:(1 0 1;1 0 1)
       m
    (1 0 1
    1 0 1)
       ,/m
    1 0 1 1 0 1
       &,/m
    0 2 3 5
       (^m)_vs &,/m
    (0 0 1 1
    0 2 0 2)
       lm:{(^x)_vs &,/x}
       lm m
    (0 0 1 1
    0 2 0 2)



## 51. Indices

       ix:{(^x)_vs!*/^x}
       ix[!6]
    ,0 1 2 3 4 5
       ix[2 3#!6]
    (0 0 0 1 1 1
    0 1 2 0 1 2)
       ix[2 3 2#!12]
    (0 0 0 0 0 0 1 1 1 1 1 1
    0 0 1 1 2 2 0 0 1 1 2 2
    0 1 0 1 0 1 0 1 0 1 0 1)



## 52. Truth table of order `x`

       tt:{2 _vs !_2^x}
       tt 1
    ,0 1
       tt 2
    (0 0 1 1
    0 1 0 1)
       tt 3
    (0 0 0 0 1 1 1 1
    0 0 1 1 0 0 1 1
    0 1 0 1 0 1 0 1)



## 53. Decimal digits from integer

       dd:{10 _vs x}
       dd 2001
    2 0 0 1
       dd 123456789
    1 2 3 4 5 6 7 8 9

    /not quite the same
    q){("i"$string x)-48} 2001  /C. Skelton.
    2 0 0 1
    q){("i"$string x)-48} 1234567890
    1 2 3 4 5 6 7 8 9 0



## 54. Represent `x` in base `y`

       x:256
       y:16
       y _vs x
    1 0 0
       x:36
       y:2
       y _vs x
    1 0 0 1 0 0
       x:123
       y:10
       y _vs x
    1 2 3

    q)0x0 vs 256
    0x00000100
    q)0b vs 36
    00000000000000000000000000100100b
    q)0b vs 36h
    0000000000100100b



## 55. Indices in `x` containing elements in `y`

       x:(3 7 8;2 5 9)
       y:(3 1 6;8 9 2)
       (^x)_vs &(,/x) _lin\: ,/y
    (0 0 1 1
    0 2 0 2)



## 56. Hexadecimal from decimal characters

       hex:"0123456789abcdef"
       x:" abcdef"
       _ic x
    32 97 98 99 100 101 102
    q)"i"$x
    32 97 98 99 100 101 102
       16 _vs _ic x
    (2 6 6 6 6 6 6
    0 1 2 3 4 5 6)
       hex[16 _vs _ic x]
    ("2666666"
    "0123456")
       +hex[16 _vs _ic x]
    ("20"
    "61"
    "62"
    "63"
    "64"
    "65"
    "66")
       " ",'+hex[16 _vs _ic x]
    (" 20"
    " 61"
    " 62"
    " 63"
    " 64"
    " 65"
    " 66")
       ,/" ",'+hex[16 _vs _ic x]
    " 20 61 62 63 64 65 66"

    q)16 vs/: "i"$x
    2 0
    6 1
    6 2
    6 3
    6 4
    6 5
    6 6
    q)hex[16 vs/: "i"$x]
    "20"
    "61"
    "62"
    "63"
    "64"
    "65"
    "66"
    q)" ",'hex[16 vs/: "i"$x]
    " 20"
    " 61"
    " 62"
    " 63"
    " 64"
    " 65"
    " 66"
    q)raze " ",'hex[16 vs/: "i"$x]
    " 20 61 62 63 64 65 66"
       x:"GOLDEN"
       ,/" ",'+hex[16 _vs _ic x]
    "47 4f 4c 44 45 4e"
    q)raze " ",'hex[16 vs/: "i"$x]
    " 47 4f 4c 44 45 4e"



## 57. Vector from date

       _t
    -1155413254
       _gtime _t
    19980522 35236
       *_gtime _t
    19980522
       100000 100 100 _vs *_gtime _t
    1998 5 22

    /not quite the same as above
    q)dt:gtime .z.Z
    q)(dt.year;dt.mm;dt.dd)
    2007 7 21



## 58. Pair each element of `!x` with each element of `!y`

       x:3
       y:4
    (x,y)_vs !x*y
    (0 0 0 0 1 1 1 1 2 2 2 2
    0 1 2 3 0 1 2 3 0 1 2 3)



## 59. Truth table of order `x` (see 52)



## 60. Truth table of order `x` (see 52)



## 61. Cyclic counter, repeating 1 through `n`

       x:1+!10
       y:8
       1+x!y
    2 3 4 5 6 7 8 1 2 3

    q)x:1+til 10
    q)y:8
    q)1+x mod y
    2 3 4 5 6 7 8 1 2 3



## 62. Integer and fractional parts of positive `x`

       x:12.3 23.4 5.33 8.999
       if:{(_ x),'x-_ x}
       if x
    ((12;0.3)
    (23;0.4)
    (5;0.33)
    (8;0.999))

    q)iif:{(floor x),'x-floor x}
    q)iif x
    12 0.3
    23 0.4
    5  0.33
    8  0.999
    /if is an iffy name



## 63. Represent `x` in radix 10 100 1000

       x:123456
       10 100 1000 _vs x
    1 23 456
       x:123456789
       10 100 1000 _vs x
    4 56 789



## 64. Represent integer time hhmmss as character time, items separated by colons

       x:_ltime _t
       x
    45628
       q:2 _ $ 1000 _sv 100 _vs 1000000 + x
       q
    "04056028"
       @[q;2 5;:;":"]
    "04:56:28"

    /not quite the same as above
    q)dt:.z.Z                                                                       q)dt.time
    00:38:25.148
    q)string dt.time
    "00:38:25.148"



## 65. Represent integer date in form yyyymmdd as character date, parts separated by “/”

       x:*_ltime _t
       x
    19980521
       1000 _sv 10000 100 100 _vs x
    1998005021
       q:$1000 _sv 10000 100 100 _vs x
       q
    "1998005021"
       @[q;4 7;:;"/"]
    "1998/05/21"

    /not quite the same as above
    q)@[s;(s:string "d"$.z.Z)ss".";:;"/"]
    "2007/07/21"
    q)s
    "2007.07.21"



## 66. Selection by encoded list

       x:1 0 1
       "abcdefgh"[2 _sv x]
    "f"
       x:0 0 0
       "abcdefgh"[2 _sv x]
    "a"
       x:1 1 1
       "abcdefgh"[2 _sv x]
    "h"

    q)"abcdefgh"[2 sv x]



## 67. Extrapolated value of abscissa `x` and ordinate `y` at `g`

       x:-1 0 1
       y:1 0 1.0 / y ~ x^2
       g:10
       |!#x
    2 1 0
       x^/:|!#x
    (1 0 1.0
    -1 0 1.0
    1 1 1.0)
       y _lsq x^/:|!#x
    1 0 4.440892e-016
       g _sv y _lsq x^/:|!#x
    100.0
       g:5
       g _sv y _lsq x^/:|!#x
    25.0

    q)x:-1 0 1
    q)y:1 0 1.0 / y ~ x^2
    q)g:10
    q)reverse key count x
    2 1 0
    q)x xexp/: reverse key count x
    1  0 1
    -1 0 1
    1  1 1
    q)(enlist y) lsq x xexp/: reverse key count x
    1 0 4.440892e-16
    q)g sv raze(enlist y) lsq x xexp/: reverse key count x
    100f
    q)g:5
    q)g sv raze(enlist y) lsq x xexp/: reverse key count x
    25f



## 68. Not relevant



## 69. Value of ascending polynomial coefficients `y` at points `x`

       x:-1 0 2
       y: 4 0 5 1
       x _sv\: y
    -8 1 43

    q)x sv\:y
    -8 1 43



## 70. Remove duplicate rows

       x:("to"
    "be"
    "or"
    "not"
    "to"
    "be")
       ?x
    ("to"
    "be"
    "or"
    "not")

    q)distinct x
    "to"
    "be"
    "or"
    "not"



## 71. Connectivity matrix from connectivity list

       y
    (0 1
    0 2
    1 0
    1 2
    2 2)
       x
    3
       x _sv/:y
    1 2 3 5 8
       (!9)_lin x _sv/:y
    0 1 1 1 0 1 0 0 1
       (x,x)#(!x*x)_lin x _sv/:y
    (0 1 1
    1 0 1
    0 0 1)

    q)y:(0 1;0 2;1 0;1 2;2 2)
    q)x:3
    q)x sv/:y
    1 2 3 5 8
    q)(til 9)in x sv/:y
    011101001b



## 72. Encode date as integer

       x:*_ltime _t
       x
    19980522

    q)s:string "d"$.z.Z
    q)s
    "2007.07.21"
    q)s[where not s="."]
    "20070721"
    q)"i"$s[where not s="."]
    50 48 48 55 48 55 50 49
    q)"I"$s[where not s="."]
    20070721



## 73. Remove trailing blanks

       x:"trailing blanks "

<span id="73a">73a</span>. negative count of trailing blanks

       nctb:{-+/&\|" "=x}
       nctb x
    -4
       rtb:{(nctb x)_ x}
       rtb x
    "trailing blanks"

    q)x:"trailing blanks    "
    q)nctb:{neg sum mins reverse " "=x}
    q)nctb x
    -4
    q)rtb:{(nctb x)_x}
    q)rtb x
    "trailing blanks"



## 74. Number of days in month `x` of Gregorian year `y` (ly from 463)

       x:1
       :[2=x
    > 28+ly y
    > (0,12#7#31 30)[x]]
    31
       x:2
       :[2=x
    > 28+ly y
    > (0,12#7#31 30)[x]]
    29

    q)ly:{(sum 0=x mod/:4 100 400)mod 2}
    q)x:1
    q)$[2=x;28+ly y;(0,12#7#31 30)[x]]
    31
    q)x:2
    q)$[2=x;28+ly y;(0,12#7#31 30)[x]]
    29



## 75. Decimal from hexadecimal

       x:("ff";"a9";"8ac";"ffff")
       x
    ("ff"
    "a9"
    "8ac"
    "ffff")
       "0123456789abcdef"?/:"ff"
    15 15
       "0123456789abcdef"?/:/:x
    (15 15
    10 9
    8 10 12
    15 15 15 15)
       16 _sv/: "0123456789abcdef"?/:/:x
    255 169 2220 65535

    /not quite the same
    q)16 sv'hex?/:x
    255 169 2220 65535



## 76. Justify right

      x:"trailing blanks "

<span id="76a">76a</span>. negative count of trailing blanks

       nctb:{-+/&\|" "=x}
       nctb x
    -4
       rj:{(nctb x)!x}
       rj x
    " trailing blanks"
       x:("a ";"bc ";"d e ";"fg h ";"ij kl ";"mnopqr")
       x
    ("a "
    "bc "
    "d e "
    "fg h "
    "ij kl "
    "mnopqr")
       rj'x
    (" a"
    " bc"
    " d e"
    " fg h"
    " ij kl"
    "mnopqr")

    q)nctb:{neg sum mins reverse " "=x}
    q)rj:{(nctb x)rotate x}
    q)x:"trailing blanks    "
    q)rj x
    "    trailing blanks"
    q)x:("a ";"bc ";"d e ";"fg h ";"ij kl ";"mnopqr")
    q)x
    "a "
    "bc "
    "d e "
    "fg h "
    "ij kl "
    "mnopqr"
    q)rj'x
    ''
    q)rj'[x]
    " a"
    " bc"
    " d e"
    " fg h"
    " ij kl"
    "mnopqr"



## 77. Present value of cash flows `c` at times `t` and discount rate `d`

Example: a 3-year bond with an annual 10% coupon and discount rate of 0.9
```k
   pv:{[c;t;d]+/c*d^t}
   c:0.1 0.1 1.1
   t:1 2 3
   d:0.9
   pv[c;t;d]
0.9729
It is better to use current prices to derive a discount function
   pv:{[c;t;d]+/c*d[t]}
   pv[c;t;{[t] 0.9^t}]
0.9729
It is even more efficient to use the discount values directly
   d: 0.9^0 1 2 3
   d
1 0.9 0.81 0.729
   pv[c;t;d]
0.9729
```
```q
q)c:0.1 0.1 1.1
q)t:1 2 3
q)d:0.9
q){[c;t;d]sum c*d xexp t}
q)pv[c;t;d]
0.9729
```


## 78. Number from alphanumeric

       x:"1998 51"
    <span id="   ">   </span>. x
    1998 51
       3 + . x
    2001 54

    q)parse x
    1998 51
    q)3+parse x
    2001 54



## 79. Index (1-origin) of first non-blank, counting from rear

       x:"blanks at end "
       (" "=x)
    0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 1
       (" "=x) _sv 1
    4



## 80. Scattered indexing

       x:2 3 4# _ci 97+!24
       x
    (("abcd"
    "efgh"
    "ijkl")
    ("mnop"
    "qrst"
    "uvwx"))
       x ./:(0 0 0;1 1 3;1 2 2)
    "atw"



## 81. Raveled index from general index

       x:2 3 4# _ci 97+!24
       x[1;1;3]
    "t"
       x
    2 3 4
       2 3 4 _sv 1 1 3
    19
       ,//x
    "abcdefghijklmnopqrstuvwx"
       (,//x)[19]
    "t"



## 82. Future value of cash flows `x` at interest rate `y`

       x:10 15 20 25
       y:5
       +/x*(1+y%100)^|!#x
    74.11375
       fv:{+/x*(1+y%100)^|!#x}
       fv[x;y]
    74.11375

    q)sum x*xexp[1+y%100;reverse til count x]
    74.11375
    q)sum x*(1+y%100)xexp(reverse til count x)
    74.11375
    q)fv:{sum x*(1+y%100)xexp(reverse til count x)}
    q)fv[x;y]
    74.11375



## 83. See 69



## 84. Scalar from boolean vector

       x:1 0 0 1 1 1 0 1
       2 _sv x
    157

    q)2 sv x
    157



## 85. Is matrix `x` antisymmetric

       x:( 0 -7 1
    7 0 -4
    -1 4 0)
       x~-+x
    1

    q)x~neg flip x
    1b



## 86. Is matrix `x` symmetric

       x:(0 4 7 1
    4 8 6 4
    7 6 2 0
    1 4 0 6)
       x~+x
    1

    q)x~flip x
    1b

       x:4 4 _draw 10
       x
    (6 6 3 3
    9 7 9 4
    4 7 9 9
    4 7 8 9)
       x~+x
    0

    q)x~flip x
    0b



## 87. Number of decimals (maximum 7)

       nd:{:[1=#x;0;-2+#x]}
       ff:{$x-_ x}
       ff 6.567
    "0.567"
       nd ff 1.234
    3
       nd ff 1234
    0
    nd ff 78.1234567
    7
    nd ff 78.12345678
    7
    "0.1234568"

    q)nd:{$[1=count x;0;-2+count x]}
    q)ff:{string x-floor x}
    q)ff 6.567
    "0.567"
    q)nd ff 1.234
    3
    q)nd ff 1234
    0
    q)nd ff 78.1234567
    7
    q)nd ff 78.12345678
    7



## 88. Name variable according to `x`

       x:"test"
       y:2 3#!6
    . "var",($x),":y"
    vartest
    (0 1 2
    3 4 5)

    q)eval parse "var",x,":y"
    0 1 2
    3 4 5

       x:123
    . "var",($x),":y"
    var123
    (0 1 2
    3 4 5)

    q)eval parse "var",(string x),":y"
    0 1 2
    3 4 5



## 93. Numbers from alphanumeric matrix

       x:4 3#" 1 12 0.5"
       x
    (" 1"
    " 12"
    " "
    "0.5")
       x=" "
    (1 1 0
    1 0 0
    1 1 1
    0 0 0)
    &/'x=" "
    0 0 1 0
    &&/'x=" "
    ,2
       z:.:'x
       z
    (1;12;;0.5)
       @[z;,2;:;0]
    (1;12;0;0.5)
    Putting it all together
       @[.:'x;&&/'x=" ";:;0]
    (1;12;0;0.5)
    q)x:4 3#"  1 12   0.5"
    q)x
    "  1"
    " 12"
    "   "
    "0.5"

    q)x=" "
    110b
    100b
    111b
    000b
    q)min each x=" "
    0010b
    q)
    q)where min each x=" "
    ,2
    q)z:.:'x
    ''
    q)z:parse x
    'type
    q)z:parse each x
    q)z
    1
    12
    ::
    0.5
    q)@[z;,2;:;0]
    ',
    q)@[z;enlist 2;:;0]
    1
    12
    0
    0.5
    q)@[parse each x;where min each x=" ";:;0]
    1
    12
    0
    0.5
    But there may be no all-blank rows
       y=:4 3#" 1 123450.5"
       y
    (" 1"
    " 12"
    "345"
    "0.5")
    @[.:'y;&&/'y=" ";:;0]
    (1;12;345;0.5)
    na:{@[.:'x;&&/'x=" ";:;0]}
    q)y:4 3#"  1 123450.5"
    q)y
    "  1"
    " 12"
    "345"
    "0.5"
    q)@[parse each y;where min each y=" ";:;0]
    1
    12
    345
    0.5
    q)na:{@[parse each x;where min each x=" ";:;0]}
    q)na y
    1
    12
    345
    0.5



## 94. Number from alphanumeric `x`, default `y`

       x:""
       y:"-1"
       .((x~"")#"y"),x
    "-1"
       x:"234.5"
       .((x~"")#"y"),x
    234.5

    q)na:{[x;y]$[x~"";parse y;parse x]}
    q)na["";"-1"]
    -1
    q)na["123";"-1"]
    123



## 95. Numeric from proper alphanumeric nonnegative integer

       x:"123 438"
       d:"0123456789"
       1 _ . "0 ",((#x)*&/x _lin d)#x
    123 438
       x:"123 45a 789"
       1 _ . "0 ",((#x)*&/x _lin d)#x
    0

    q)x:"123 438"
    q)eval parse each  " "vs x
    123 438



## 96. Conditional execution

       @[+/;!6;:]
    0 15

    q)@[sum;til 6;:]
    15
    q)@[+/;til 6;:]
    15

    /XXX difference between k4/q and older k?
    @[+/;"abc";:]
    (1;"type")



## 98. Execute rows of character matrix

       x1:4
       x2:9
       x:2 5#"y1:x1y2:x2"
       x
    ("y1:x1"
    "y2:x2")
       .:'x
    (;)
       y1
    4
       y2
    9

    q)x1:4
    q)x2:9
    q)x:2 5#"y1:x1y2:x2"
    q)x
    "y1:x1"
    "y2:x2"
    q)parse each x
    : `y1 `x1
    : `y2 `x2
    q)eval parse each x
    ': Bad file descriptor
    q)eval each parse each x
    4 9



## 99. Numeric vector from evaluating rows of character matrix

       x:2 5#"1+2 41+3 6"
       x
    ("1+2 4"
    "1+3 6")
       .:'x
    (3 5
    4 7)

    q)parse each x
    + 1 2 4
    + 1 3 6
    q)eval each parse each x
    3 5
    4 7
    ,/.:'x
    3 5 4 7
    q)raze eval each parse each x
    3 5 4 7



## 100. Indexing arbitrary rank array

       x:2 3 4 5# ! 120
       x[1]
    ((60 61 62 63 64
    65 66 67 68 69
    70 71 72 73 74
    75 76 77 78 79)
    (80 81 82 83 84
    85 86 87 88 89
    90 91 92 93 94
    95 96 97 98 99)
    (100 101 102 103 104
    105 106 107 108 109
    110 111 112 113 114
    115 116 117 118 119))
       x[0;0]
    (0 1 2 3 4
    5 6 7 8 9
    10 11 12 13 14
    15 16 17 18 19)
       x[0;0;0]
    0 1 2 3 4
       x[0;0;0;0]
    0



## 101. Sum numbers in character matrix

       x:$!5
       x
    (,"0"
    ,"1"
    ,"2"
    ,"3"
    ,"4")
    +/ .:' x
    10

    q)sum parse each x
    10



## 104. Date ascending format

    1 _ ,/".",/:$|.:'0 4 6 _ $* _ltime _t
    "25.5.1998"

    /not quite the same as above
    q)raze string each(dt.dd;".";dt.mm;".";dt.year)
    "21.7.2007"
    q)raze string each(dt.year;".";dt.mm;".";dt.dd)
    "2007.7.21"



## 105. Current time of 12-hour clock (AM & PM)

       y:_t
       y
    -1155069892
       x:*|_ltime y
       x
    201508
    hms:{1 _,/":",/:1 _'$100+100 _vs x!120000}
    hms x
    "08:15:08"
    ap:{"AP"[115959<x],"M"}
    ap x
    "PM"
    hm:{{(hms x)," ",ap x}[*|_ltime x]}
    Ordinarily one would use _t as the argument to hm
    hm x
    "08:15:08 PM"

    q)a:01:58:57
    q)p:13:59:59
    q)hm:{raze string (x;x-12*3600)[11:59:59<x]," ",("AP"[11:59:59<x],"M")}
    q)hm a
    "01:58:57 AM"
    q)hm p
    "01:59:59 PM"



## 106. Leading zeros for positive integers `x` in field width `y`

       x:10 _draw 40
       x
    37 36 17 38 29 4 31 12 35 25
       z:$:'x+(y-1){x*10}/10
       z
    ("1037"
    "1036"
    "1017"
    "1038"
    "1029"
    "1004"
    "1031"
    "1012"
    "1035"
    "1025")
    u:1 _/: z
    u
    ("037"
    "036"
    "017"
    "038"
    "029"
    "004"
    "031"
    "012"
    "035"
    "025")

    q)x:37 36 17 38 29 4 31 12 35 25
    q)z:string each x+(y-1){x*10}/10
    q)u:1_/:z
    q)u
    "037"
    "036"
    "017"
    "038"
    "029"
    "004"
    "031"
    "012"
    "035"
    "025"



## 107. Current date, American

       x:*_ltime _t
       x
    19980526
       10000 100 100 _vs x
    1998 5 26
       1!10000 100 100 _vs x
    5 26 1998
       $1!10000 100 100 _vs x
    (,"5"
    "26"
    "1998")
       " ",/:$1!10000 100 100 _vs x
    (" 5"
    " 26"
    " 1998")
       ,/" ",/:$1!10000 100 100 _vs x
    " 5 26 1998"
       1 _ ,/" ",/:$1!10000 100 100 _vs x
    "5 26 1998"
       "0123456789 "?/:1 _ ,/" ",/:$1!10000 100 100 _vs x
    5 10 2 6 10 1 9 9 8
       d:"0123456789"
       e:d,"/"
       b:10000 100 100
       k:{1 _ x}
       s:" "
       e[d?/:k ,/s,/:$1!b _vs x]
    "5/26/1998"
       da:{e[d?/:k,/s,/:$1!b _vs x]}
       da[*_ltime _t]
    "5/26/1998"

    /not quite the same as above
    q)raze string (dt.mm;"/";dt.dd;"/";dt.year)
    "7/21/2007"



## 111. Count of format of `x`

       cf:{#$x}
       cf 12.345
    6
       cf -1
    2
       cf 1e-12
    6
       $1e-12
    "1e-012"

    q)cf:{count string x}
    q)cf 12.345
    6
    q)cf -1
    2
    q)cf 1e-12
    5
    q)string 1e-12
    "1e-12"

<span id="115, 116, 117">115, 116, 117</span>. case structure

    :[c0;t0;f]
    :[c0;t0;c1;t1;f]
    :[c0;t0;c1;t1;c2;t2;f]
    :[c0;t0;c1;t1;c2;t2;c3;t3;f]
    et cetera
    In the first case, if c0 is nonzero, the result is t0; otherwise f.
    In all cases, the result is the tn corresponding to the first nonzero cn.
    If none of the cn are nonzero the result is f.



## 121. `y`-shaped array of numbers from `x[0]` to `x[1]-1`

       x:4 9
       y:3 4
    (*x)+y _draw --/x
    (5 8 7 4
    8 7 5 8
    8 7 7 5)



## 122. `y` objects selected with replacement from `!x` (roll)

       y:3 5
       x:7
       y _draw x
    (6 2 1 2 2
    4 4 6 3 0
    6 3 4 5 1)
    q)3 5#7?7
    5 1 2 1 2
    0 3 5 1 2
    1 2 0 3 5



## 123. `y` objects selected without replacement from `!x` (deal)

       y:2 3
       x:7
       y _draw -x
    (1 6 4
    3 5 2)
    6 _draw -6
    3 0 1 5 4 2

### 123.a Normal deviates (from interval (0,1))

       \p 4
       x:4
       x _draw 0
    0.8683 0.5104 0.968 0.9831

    q)\P 4
    q)4?1.
    0.7418 0.007865 0.4953 0.1869



## 124. Predicted values of exponential fit

       x:64 70 77 82 92
       y:56 60 66 70 78
       a:x^/:0 1
       a
    (1 1 1 1 1.0
    64 70 77 82 92.0)
       _log[y]
    4 4.1 4.2 4.2 4.4
       _lsq[_log[y];a]
    3.3 0.012
       _exp[_mul[+a;_lsq[_log[y];a]]]
    56 60 66 70 78.0

    q)x:64 70 77 82 92
    q)y:56 60 66 70 78
    q)a:x xexp/:0 1
    q)a
    1  1  1  1  1
    64 70 77 82 92
    q)log y
    4.025352 4.094345 4.189655 4.248495 4.356709
    q)lsq[enlist log y;a]
    3.261029 0.01197249
    q)
    q)exp[flip mmu[flip a;flip lsq[enlist log y;a]]]
    56.10745 60.28622 65.55641 69.60062 78.45289



## 125. Predicted values of best linear fit (least squares)

       x:64 70 77 82 92 107 125 143 165 189f
       y:56 60 66 70 78  88 102 118 136 155f
       a:x^/:0 1
       a
    (1 1 1 1 1 1 1 1 1 1.0
    64 70 77 82 92 107 125 143 165 189.0)
       _mul[+a;_lsq[y;a]]
    55.32371 60.08021 65.62945 69.59319 77.52068 89.41191 103.6814 117.9509 135.3913 154.4173
    / This can also be written in infix form
    (+a) _mul (y _lsq a)
    55.32371 60.08021 65.62945 69.59319 77.52068 89.41191 103.6814 117.9509 135.3913 154.4173

    q)a:x xexp/:0 1
    q)flip mmu[flip a;flip lsq[enlist y;a]]
    55.32371 60.08021 65.62945 69.59319 77.52068 89.41191 103.6814 117.9509 135.3913 154.4173
    q)flip (flip a) flip mmu (enlist y) lsq a
    55.32371 60.08021 65.62945 69.59319 77.52068 89.41191 103.6814 117.9509 135.3913 154.4173



## 126. `g`-degree polynomial fit of points (`x`,`y`)

       x:64 70 77 82 92 107 125 143 165 189
       y:(5*x^3)+(-1*x^2)+(4*x)+182
       y
    1307062 1710562 2277226 2750626 3885526 6114376 9750682 1.460134e+007 2.243424e+007 3.372156e+007
       | _lsq[y;x^/:!g+1]
    5 -1 4 182.0
       |(y _lsq x^/:!g+1)
    5 -1 4 182.0

    q)g:3
    q)x:64 70 77 82 92 107 125 143 165 189
    q)y:(5*x xexp 3)+(-1*x xexp 2)+(4*x)+182
    q)y
    1307062 1710562 2277226 2750626 3885526 6114376 9750682 1.460134e+07 2.243424..
    q)reverse raze(enlist y) lsq x xexp/:til g+1
    5 -1 4 182f



## 127. Coefficients of exponential fit of points (`x`,`y`)

       x:64 70 77 82 92 107 125 143 165 189
       y:56 60 66 70 78 88 102 118 136 155
       a: _lsq[_log[y];x^/:0 1]
       a
    3.563398 0.00817742
    a[0]: _exp[a[0]]
    a
    35.2829 0.00817742
    a[0]*_exp[x*a[1]]
    59.54624 62.54071 66.22511 68.98898 74.86758 84.63791 98.05964 113.6098 136.0024 165.4933
       y
    56 60 66 70 78 88 102 118 136 155.0

    q)x:64 70 77 82 92 107 125 143 165 189
    q)y:56 60 66 70 78 88 102 118 136 155
    q)a:lsq[enlist log y;x xexp/:0 1]
    q)a
    3.563398 0.00817742
    q)a[0]:exp[a[0]]
    q)a
    35.2829 0.00817742
    q)a[0]*exp[x*a[1]]
    59.54624 62.54071 66.22511 68.98898 74.86758 84.63791 98.05964 113.6098 136.0..
    q)y
    56 60 66 70 78 88 102 118 136 155



## 128. Coefficients of best linear fit of points (`x`,`y`) (least squares)

       x:64 70 77 82 92 107 125 143 165 189f
       y:56 60 66 70 78  88 102 118 136 155f
       z:_lsq[y;x^/:0 1]
       z
    4.587803 0.7927486
       z[0]+z[1]*x / should be y, approximately
    55.32371 60.08021 65.62945 69.59319 77.52068 89.41191 103.6814 117.9509 135.3913 154.4173

    q)z:lsq[enlist y;x xexp/:0 1]
    q)z
    4.587803 0.7927486



## 129. Arctangent `y%x`

       x:_sqrt[3]
       y:1
       _atan[y%x]
    0.5235988



## 131. Complementary angle (arccos sin `x`)

       x:0.25
       _acos[_sin x]
    1.320796
       x+_acos[_sin x] / should be 0.5*pi, approximately
    1.570796
       2*x+_acos[_sin x]
    3.141593



## 132. Rotation matrix for angle `x` (in radians) counter-clockwise

       ((_cos[x];-_sin[x]);(_sin[x];_cos[x]))
    (0.9689124 -0.247404
    0.247404 0.9689124)

    q)x:0.25
    q)((cos x;neg sin x);(sin x;cos x))
    0.9689124 -0.247404
    0.247404  0.9689124



## 133. Degrees from radians

       x:0.5
       57.295779513082323*x
    28.64789

    q)x:0.5
    q)57.295779513082323*x
    28.64789



## 134. Radians from degrees

       x:0.5
       z:57.295779513082323*x
       z
    28.64789
       0.017453292519943295*z
    0.5

    q)x:0.5
    q)z:57.295779513082323*x
    q)z
    28.64789
    q)0.017453292519943295*z
    0.5



## 135. Number of permutations of `n` objects taken `k` at a time

       fac:{[n]:[n>1; n * _f[n-1];1]}
       bin:{[n;k]fac[n]%fac[n-k]*fac[k]}
       pn:{[n;k]fac[k]*bin[n;k]}
       pn[5;3]
    60.0

    q)fac:{[n]$[n>1;n*fac[n-1];1]}
    q)binn:{[n;k]fac[n]%fac[n-k]*fac[k]}
    q)pn:{[n;k]fac[k]*binn[n;k]}
    q)pn[5;3]
    60f



## 136. Pascal's triangle of order `x` (binomial coefficients) 

<i class="far fa-hand-point-right"></i> 1007



## 137. Taylor series with coefficients `y`at point `x`

       x:3
       y:1 1 1
       a:!#y
       +/y*(x^a)%fac'[a]
    8.5
       y:30#1
       x:1
       a:!#y
       +/y*(x^a)%fac'[a]
    2.7182818308537429

    q)fac:{[n]$[n>1;n*fac[n-1];1]}
    q)x:3
    q)y:1 1 1
    q)a:til count y
    q)sum y*(x xexp a)%fac each a
    8.5
    q)y:30#1
    q)x:1
    q)a:til count y
    q)sum y*(x xexp a)%fac each a
    2.718282



## 139. Beta function

See gamma in appendix Beta:{((gamma x)\*gamma y)%gamma\[x+y\]}



## 142. Number of combinations of `n` objects taken `k` at a time

       fac:{[n]:[n>1; n * _f[n-1];1]}
       bin:{[n;k]fac[n]%fac[n-k]*fac[k]}
       bin[12;7]
    792.0
       bin[10;4]
    210.0

    q)fac:{[n]$[n>1;n*fac[n-1];1]}
    q)bin:{[n;k]fac[n]%fac[n-k]*fac[k]}
    'bin
    q)binn:{[n;k]fac[n]%fac[n-k]*fac[k]}
    q)binn[12;7]
    792f
    q)binn[10;4]
    210f



## 143. Indices of distinct items

       x:"ajhajhja"
       =x
    (0 3 7
    1 4 6
    2 5)

    q)group x
    a| 0 3 7
    j| 1 4 6
    h| 2 5
    q)value group x
    0 3 7
    1 4 6
    2 5



## 144. Histogram

       x:13 _draw 12
       x
    8 3 11 9 9 4 6 6 3 3 9 7 9
       h:{@[&1+|/x;x;+;1]}
       b:h[x]
       b
    0 0 0 3 1 0 2 1 1 4 0 1
       c:(1+|/b)-b
       c
    5 5 5 2 4 5 3 4 4 1 5 4
       d:|+(b#\:1),'(c#\:0)
       d
    (0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 1 0 0
    0 0 0 1 0 0 0 0 0 1 0 0
    0 0 0 1 0 0 1 0 0 1 0 0
    0 0 0 1 1 0 1 1 1 1 0 1)
       " *"[d]
    (" "
    " * "
    " * * "
    " * * * "
    " ** **** *")

    q)x:8 3 11 9 9 4 6 6 3 3 9 7 9
    q)h:{@[(1+max x)#0;x;+;1]}
    q)h x
    0 0 0 3 1 0 2 1 1 4 0 1
    q)b:h x
    q)c:(1+max b)-b
    q)c
    5 5 5 2 4 5 3 4 4 1 5 4
    q)d:reverse flip(b#\:1),'(c#\:0)
    q)d
    0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 1 0 0
    0 0 0 1 0 0 0 0 0 1 0 0
    0 0 0 1 0 0 1 0 0 1 0 0
    0 0 0 1 1 0 1 1 1 1 0 1
    q)" *"[d]
    "            "
    "         *  "
    "   *     *  "
    "   *  *  *  "
    "   ** **** *"



## 145. Count of `x` between endpoints (`l`,`h`)

       x:5 5 _draw 100
       l:10
       h:80
       x
    (66 8 6 4 86
    82 91 52 53 89
    43 0 62 3 17
    0 26 81 2 12
    37 41 41 72 60)
       xl:x>l
       xl
    (1 0 0 0 1
    1 1 1 1 1
    1 0 1 0 1
    0 1 1 0 1
    1 1 1 1 1)
       xh:x<h
       xh
    (1 1 1 1 0
    0 0 1 1 0
    1 1 1 1 1
    1 1 0 1 1
    1 1 1 1 1)
       xbetween:xl&xh
       xbetween
    (1 0 0 0 0
    0 0 1 1 0
    1 0 1 0 1
    0 1 0 0 1
    1 1 1 1 1)
       +/'xbetween
    1 2 3 2 5

    q)x:(66 8 6 4 86;82 91 52 53 89;43 0 62 3 17;0 26 81 2 12;37 41 41 72 60)
    q)l:10
    q)h:80
    q)xl:x>l
    q)xl
    10001b
    11111b
    10101b
    01101b
    11111b
    q)xh:x<h
    q)xh
    11110b
    00110b
    11111b
    11011b
    11111b
    q)xbetween:xl&xh
    q)xbetween
    10000b
    00110b
    10101b
    01001b
    11111b
    q)sum each xbetween
    1 2 3 2 5



## 146. Compound interest for principals `y` at percentages `g` for periods `x`

       x:1 2 3 4
       y:1 2 3 4
       g:0.5 1 1.5 2
       z:y*\:(1+g%100)^\:x
       \p 5
       z
    ((1.005 1.01 1.0151 1.0202
    1.01 1.0201 1.0303 1.0406
    1.015 1.0302 1.0457 1.0614
    1.02 1.0404 1.0612 1.0824)
    (2.01 2.02 2.0302 2.0403
    2.02 2.0402 2.0606 2.0812
    2.03 2.0604 2.0914 2.1227
    2.04 2.0808 2.1224 2.1649)
    (3.015 3.0301 3.0452 3.0605
    3.03 3.0603 3.0909 3.1218
    3.045 3.0907 3.137 3.1841
    3.06 3.1212 3.1836 3.2473)
    (4.02 4.0401 4.0603 4.0806
    4.04 4.0804 4.1212 4.1624
    4.06 4.1209 4.1827 4.2455
    4.08 4.1616 4.2448 4.3297))

    q)x:1 2 3 4
    q)y:1 2 3 4
    q)g:0.5 1 1.5 2
    q)z:y*\:(1+g%100)xexp\:x
    q)\P 5
    q)z
    1.005 1.01   1.0151 1.0202 1.01  1.0201 1.0303 1.0406 1.015 1.0302 1.0457 1.0..
    2.01 2.02   2.0302 2.0403  2.02 2.0402 2.0606 2.0812  2.03 2.0604 2.0914 2.12..
    3.015 3.0301 3.0452 3.0605 3.03  3.0603 3.0909 3.1218 3.045 3.0907 3.137  3.1..
    4.02 4.0401 4.0603 4.0806  4.04 4.0804 4.1212 4.1624  4.06 4.1209 4.1827 4.24..



## 147. Locations of string `x` in string `y` (including overlaps)

       x:"**"
       y:"*abcugj**jy***kmhix**12"
    ss:{z[&y[z+\:!#x]~\:x]}
    ss[x;y;&((1-#x)_ y)=*x]
    7 11 12 19
       y[7 11 12 19+\:0 1]
    ("**"
    "**"
    "**"
    "**")

    q)x:"**"
    q)y:"*abcugj**jy***kmhix**12"
    q)sss:{z[where y[z+\:til count x]~\:x]}
    q)sss[x;y;where ((1-count x)_y)=first x]
    7 11 12 19
    q)y[7 11 12 19+\:0 1]
    "**"
    "**"
    "**"
    "**"



## 148. Node matrix from connection matrix (inverse to 157)

       x:( 1 1 0 0 0
    > 0 -1 0 1 1
    > -1 0 1 -1 0
    > 0 0 -1 0 -1)
    Each column in matrix x represents a path between 2 nodes:
    From node 0 to node 2
    From node 0 to node 1
    From node 2 to node 3
    From node 1 to node 2
    From node 1 to node 3
       a:1 -1=\:x
       a
    ((1 1 0 0 0
    0 0 0 1 1
    0 0 1 0 0
    0 0 0 0 0)
    (0 0 0 0 0
    0 1 0 0 0
    1 0 0 1 0
    0 0 1 0 1))
       b:_mul[a;!#x]
       b
    (0 0 2 1 1
    2 1 3 2 3)
       nc:{_mul[1 -1=\:x;!#x]}
       nc x
    (0 0 2 1 1
    2 1 3 2 3)



## 149. Number of decimals in `x`, maximum `y`

    nd:{+/~0=(-_-x*10^y)!/:-_-(10^y)*10^-!y+1}
       x:1.4321 1.21 10
       y:3
       nd[x;y]
    3 2 0
       10^-!y+1
    1 0.1 0.01 0.001
       -_-(10^y)*10^-!y+1
    1000 100 10 1
       -_-x*10^y
    1433 1210 10000
       (-_-x*10^y)!/:-_-(10^y)*10^-!y+1
    (433 210 0
    33 10 0
    3 0 0
    0 0 0)
       ~0=(-_-x*10^y)!/:-_-(10^y)*10^-!y+1
    (1 1 0
    1 1 0
    1 0 0
    0 0 0)
       +/~0=(-_-x*10^y)!/:-_-(10^y)*10^-!y+1
    3 2 0

    q)nd:{sum not 0=(neg floor neg x*10 xexp y)mod/:neg floor neg(10 xexp y)*10 xexp neg til y+1}
    q)x:1.4321 1.21 10
    q)y:3
    q)nd[x;y]
    3 2 0



## 150. Sum items of `x` given by `y`

       x:_log[1+!5]
       x
    0 0.6931472 1.098612 1.386294 1.609438
       y:1 4 1 4 1
       a:=y
    a
    (0 2 4
    1 3)
       +/'x[a]
    2.70805 2.079442
       +/x[0 2 4]
    2.70805
       +/x[1 3]
    2.079442
       +/'x[=y]
    2.70805 2.079442

    q)a:value group y
    q)a
    0 2 4
    1 3
    q)sum each x[a]
    2.70805 2.079442
    q)sum x[0 2 4]
    2.70805
    q)sum x[1 3]
    2.079442
    q)sum each x[value group y]
    2.70805 2.079442



## 151. Efficient execution of `f x` where `x` has repeated values
```q
    fx:{[f;x](f'x)(x?:)?/:x}
```
The phrase `x?:` is the same as `x:?x`, which means `x` is assigned the unique elements of `x`. The phrase `a?/:b` means: find each item of `b` in `a`. So `(x?:)?/:x` says: find each item of `x` in the list of unique items of `x` (and while you’re at it, reassign `x` to that list of unique items of `x`). The result is the list of indices of the original list `x` into the unique items of `x`.
```k
   x:1 2 3 2 3 2 1
   ?x
1 2 3
   (?x)?/:x
0 1 2 1 2 1 0
   (x?:)?/:x
0 1 2 1 2 1 0
```
This works because k’s order of execution is right-to-left. The original value of `x` is ‘captured’ before the `x?:` reassigns it.
```k
   x
1 2 3
f:{10*x}
f'x
10 20 30
```
The last bit is simply indexing:
```k
  (f'x)[0 1 2 1 2 1 0]
  10 20 30 20 30 20 10
```
But k allows you to leave out the brackets:
```k
(f'x)0 1 2 1 2 1 0
10 20 30 20 30 20 10
```
So the whole thing is
```k
(f'x)(x?:)?/:x
```
```q
q)x:1 2 3 2 3 2 1
q)(u:distinct x)?x
0 1 2 1 2 1 0
q)u
1 2 3
q)f:{10*x}
q)f u
10 20 30
q)f u 0 1 2 1 2 1 0
10 20 30 20 30 20 10
q)f[u](u:distinct x)?x
10 20 30 20 30 20 10
q).Q.fu
k){[f;x]$[0>@x;f x;f[u](u:?x)?x]}
```


## 152. Sum items of `y` according by ordered codes `g` in `x`

       y:1+!20
       y
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
       z:";;abcde"
       x:z[20 _draw #z]
       x
    "dcbbbaceeaeccbecbaea"
       xz:z,x
       yz:(&#z),y
       xz
    "abcdedcbbbaceeaeccbecbaea"
       yz
    0 0 0 0 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
       +/'yz[=xz]
    54 43 50 1 62
       sc:{+/'((&#z),y)[=z,x]}
       sc[x;y;z]
    54 43 50 1 62

    q)y:1+til 20
    q)z:"abcde"
    q)x:"dcbbbaceeaeccbecbaea"
    q)xz:z,x
    q)yz:((count z)#0),y
    q)yz
    0 0 0 0 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
    q)xz
    "abcdedcbbbaceeaeccbecbaea"
    q)sum each yz[group xz]
    a| 54
    b| 43
    c| 50
       d| 1
    e| 62
    q)sum each yz[value group xz]
    54 43 50 1 62
    q)sc:{sum each(((count z)#0),y)[value group z,x]}
    q)sc[x;y;z]
    54 43 50 1 62



## 153. Index of rows of `y` in corresponding rows of `x`

       x:1+3 4# !12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       y:(1 0 3 0
    > 0 6 0 8
    > 9 0 0 12)
       x ?/:'y
    (0 4 2 4
    4 1 4 3
    0 4 4 3)

    q)x:1+3 4#til 12
    q)x
    1 2  3  4
    5 6  7  8
    9 10 11 12
    q)y:(1 0 3 0;0 6 0 8;9 0 0 12)
    q)x ?/:'y
    0 4 2 4
    4 1 4 3
    0 4 4 3
    /same as x?'y
    /column by column find



## 154. Range (nub; remove duplicate items)

       x:"wirlsisl"
       ?x
    "wirls"
       ?(1 2 3;4 5;1 2 3;4 5;1 2 3)
    (1 2 3
    4 5)

    q)distinct x
    "wirls"
    q)distinct (1 2 3;4 5;1 2 3;4 5;1 2 3)
    1 2 3
    4 5



## 155. Greatest common divisor of list `x`

       gcd:{*|1+&&/'0=x!/:1+!&/x}
       x:6 9 12
       gcd x
    3
    &/x
    6
    !&/x
    0 1 2 3 4 5
    1+!&/x
    1 2 3 4 5 6
       x!/:1+!&/x
    (0 0 0
    0 1 0
    0 0 0
    2 1 0
    1 4 2
    0 3 0)
    0=x!/:1+!&/x
    (1 1 1
    1 0 1
    1 1 1
    0 0 1
    0 0 0
    1 0 1)
    &/'0=x!/:1+!&/x
    1 0 1 0 0 0
    &&/'0=x!/:1+!&/x
    0 2
    *|1+&&/'0=x!/:1+!&/x
    3

    q)x:6 9 12
    q)gcd:{last 1+where min each 0=x mod/:1+til min x}
    q)gcd x
    3



## 156. Classify `y` into `x` classes between min and max `y`

       x:10
       y:260 416 18 27 265 336 4
    normalize y so minimum value is 0
       sm:{x-&/x}
       sm[y]
    256 412 14 23 261 332 0
    normalize again so values are in range 0 le y and y lt x
       nr:{y*x%|/y}
       nr[x;sm[y]]
    6.21 10 0.34 0.558 6.33 8.06 0
    compare against interior range boundaries, 1+!x-1
       ~nr[x;sm[y]]</:1+!x-1
    (1 1 0 0 1 1 0
    1 1 0 0 1 1 0
    1 1 0 0 1 1 0
    1 1 0 0 1 1 0
    1 1 0 0 1 1 0
    1 1 0 0 1 1 0
    0 1 0 0 0 1 0
    0 1 0 0 0 1 0
    0 1 0 0 0 0 0)
    count the number of boundaries passed by each
       +/~nr[x;sm[y]]</:1+!x-1
    6 9 0 0 6 8 0

    q)sm:{x-min x}
    q)sm y
    256 412 14 23 261 332 0
    q)nr:{y*x%max y}
    q)nr[x;sm[y]]
    6.213592 10 0.3398058 0.5582524 6.334951 8.058252 0
    q)
    q)not nr[x;sm[y]]</:1+til x-1
    1100110b
    1100110b
    1100110b
    1100110b
    1100110b
    1100110b
    0100010b
    0100010b
    0100000b
    q)sum not nr[x;sm[y]]</:1+til x-1
    6 9 0 0 6 8 0



## 157. Connection matrix from node matrix (inverse to 148)

Node matrix top and bottom rows give from- and to-nodes

       x: (0 0 2 1 1
    2 1 3 2 3)
    enumerate count of range
       !#?,/x
    0 1 2 3
    where is x equal to each of it
       x=/:!#?,/x
    ((1 1 0 0 0
    0 0 0 0 0)
    (0 0 0 1 1
    0 1 0 0 0)
    (0 0 1 0 0
    1 0 0 1 0)
    (0 0 0 0 0
    0 0 1 0 1))
    subtract "to" matrix from "from" matrix
       -/'x=/:!#?,/x
    (1 1 0 0 0
    0 -1 0 1 1
    -1 0 1 -1 0
    0 0 -1 0 -1)

    q)x:(0 0 2 1 1;2 1 3 2 3)
    q)key count distinct raze x
    0 1 2 3
    q)x=/:key count distinct raze x
    11000b 00000b
    00011b 01000b
    00100b 10010b
    00000b 00101b
    q)-/'[x=/:key count distinct raze x]
    1  1  0  0  0
    0  -1 0  1  1
    -1 0  1  -1 0
    0  0  -1 0  -1



## 158. See 20



## 159. Is range of `x` 1 (are all items of `x` equal)

       x:1 1 1 1 1
       1=#?x
    1
       y:1 1 0 1 1
       1=#?y
    0

    q)1=count distinct x
    1b
    q)1=count distinct y
    0b



## 160. Move blanks in `x` to end of list

       x:"sign if i cant"
       x[<x=" "]
    "significant "
       be:{x[<x=" "]}
       y:("yo ho ho"
    "and a bottle"
    "of rum")
       be'[y]
    ("yohoho "
    "andabottle "
    "ofrum ")

    q)x:"sign if i cant"
    q)x[iasc x=" "]
    "significant   "
    q)be:{x[iasc x=" "]}
    q)y:("yo ho ho";"and a bottle";"of rum")
    q)be'[y]
    "yohoho  "
    "andabottle  "
    "ofrum "



## 161. Is `y` upper triangular

       x:(1 0 0 1
    > 0 2 1 0
    > 0 0 1 2
    > 0 0 0 0)
       slt:{(!x)>\:!x}
       slt[#x]
    (0 0 0 0
    1 0 0 0
    1 1 0 0
    1 1 1 0)
       x*slt[#x]
    (0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0)
       zm:{(x,x)#0}
       zm[#x]
    (0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0)
       iut:{zm[#x]~x*slt[#x]}
       iut x
    1
       +x
    (1 0 0 0
    0 2 0 0
    0 1 1 0
    1 0 2 0)
       iut[+x]
    0

    q)x:(1 0 0 1;0 2 1 0;0 0 1 2;0 0 0 0)
    q)x
    1 0 0 1
    0 2 1 0
    0 0 1 2
    0 0 0 0
    q)slt:{(key x)>\:key x}
    q)slt[count x]
    0000b
    1000b
    1100b
    1110b
    q)x*slt[count x]
    0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0
    q)zm:{(x,x)#0}
    q)zm[count x]
    0 0 0 0
    0 0 0 0
    0 0 0 0
    0 0 0 0
    q)iut:{zm[count x]~x*slt[count x]}
    q)iut x
    1b
    q)flip x
    1 0 0 0
    0 2 0 0
    0 1 1 0
    1 0 2 0
    q)iut[flip x]
    0b



## 162. Is `x` lower triangular

       x:(1 0 0 0
    0 2 0 0
    0 1 1 0
    1 0 2 0)
       sut:{(!x)<\:!x}
       sut[#x]
    (0 1 1 1
    0 0 1 1
    0 0 0 1
    0 0 0 0)
       ilt:{zm[#x]~x*sut[#x]}
       ilt[x]
    1
       ilt[+x]
    0

    q)x:(1 0 0 0;0 2 0 0;0 1 1 0;1 0 2 0)
    q)x
    1 0 0 0
    0 2 0 0
    0 1 1 0
    1 0 2 0
    q)
    q)sut:{(key x)<\:key x}
    q)sut[count x]
    0111b
    0011b
    0001b
    0000b
    q)zm:{(x,x)#0}
    q)ilt:{zm[count x]~x*sut[count x]}
    q)ilt[x]
    1b
    q)ilt[flip x]
    0b



## 163. Polynomial product

       x:1 2 1
       y:1 3 3 1
       y*/:x
    (1 3 3 1
    2 6 6 2
    1 3 3 1)
       1 _'zm[#x]
    (0 0
    0 0
    0 0)
       (1 _'zm[#x]),'y*/:x
    (0 0 1 3 3 1
    0 0 2 6 6 2
    0 0 1 3 3 1)
       (!#x)!'(1 _'zm[#x]),'y*/:x
    (0 0 1 3 3 1
    0 2 6 6 2 0
    1 3 3 1 0 0)
       +/(!#x)!'(1 _'zm[#x]),'y*/:x
    1 5 10 10 5 1
       pm:{+/(!#x)!'(1 _'zm[#x]),'y*/:x}
       pm[x;y]
    1 5 10 10 5 1

    q)pm:{sum(key count x)rotate ' (1 _ 'zm[count x]),'y*/:x}
    q)pm[x;y]
    1 5 10 10 5 1



## 164. Divisors

       x:363
       dv:{&0=x!/:!1+x}
       dv[x]
    1 3 11 33 121 363
       dv 365
    1 5 73 365
       dv 367
    1 367
       dv'[1 2 3 4 5 6 7 8 9 10]
    (,1
    1 2
    1 3
    1 2 4
    1 5
    1 2 3 6
    1 7
    1 2 4 8
    1 3 9
    1 2 5 10)

    q)dv:{where 0=x mod/:key 1+x}
    q)x:363
    q)dv x
    1 3 11 33 121 363
    q)x:365
    q)dv x
    1 5 73 365
    q)dv 367
    1 367
    q)dv'[1 2 3 4 5 6 7 8 9 10]
    ,1
    1 2
    1 3
    1 2 4
    1 5
    1 2 3 6
    1 7
    1 2 4 8
    1 3 9
    1 2 5 10



## 165. List of `x` zeros preceded by (`y-x`) ones

       x:5
       y:9
       zo:{((y-x)#1),&x}
       zo[x;y]
    1 1 1 1 0 0 0 0 0

    q)x:5
    q)y:9
    q)zo:{((y-x)#1),x#0}
    q)zo[x;y]
    1 1 1 1 0 0 0 0 0



## 166. Barchart of integer list `x`, down the page

       x:2 5 7 4 9 3 6
       xl:{(x#1),&y-x}
    " X"[|+xl\:[x;|/x]]
    (" X "
    " X "
    " X X "
    " X X X"
    " XX X X"
    " XXXX X"
    " XXXXXX"
    "XXXXXXX"
    "XXXXXXX")

    q)x:2 5 7 4 9 3 6
    q)xl:{(x#1),(y-x)#0}
    q)" X"[reverse flip xl\:[x;max x]]
    "    X  "
    "    X  "
    "  X X  "
    "  X X X"
    " XX X X"
    " XXXX X"
    " XXXXXX"
    "XXXXXXX"
    "XXXXXXX"
    bd:{" X"[|+xl\:[x;|/x]]}
    bd[x]
    (" X "
    " X "
    " X X "
    " X X X"
    " XX X X"
    " XXXX X"
    " XXXXXX"
    "XXXXXXX"
    "XXXXXXX")
    q)x:2 5 7 4 9 3 6
    q)xl:{(x#1),(y-x)#0}
    q)" X"[reverse flip xl\:[x;max x]]
    "    X  "
    "    X  "
    "  X X  "
    "  X X X"
    " XX X X"
    " XXXX X"
    " XXXXXX"
    "XXXXXXX"
    "XXXXXXX"



## 167. List of `x` ones preceded by (`y-x`) xeros

       x:3
       y:9
       xr:{(&y-x),x#1}
       xr[x;y]
    0 0 0 0 0 0 1 1 1
       x:2 5 7 4 9 3 6
       xr\:[x;y]
    (0 0 0 0 0 0 0 1 1
    0 0 0 0 1 1 1 1 1
    0 0 1 1 1 1 1 1 1
    0 0 0 0 0 1 1 1 1
    1 1 1 1 1 1 1 1 1
    0 0 0 0 0 0 1 1 1
    0 0 0 1 1 1 1 1 1)

    q)xr:{((y-x)#0),x#1}
    q)xr[x;y]
    0 0 0 0 0 0 1 1 1
    q)x:2 5 7 4 9 3 6
    q)xr\:[x;y]
    0 0 0 0 0 0 0 1 1
    0 0 0 0 1 1 1 1 1
    0 0 1 1 1 1 1 1 1
    0 0 0 0 0 1 1 1 1
    1 1 1 1 1 1 1 1 1
    0 0 0 0 0 0 1 1 1
    0 0 0 1 1 1 1 1 1



## 168. List of `x` zeros followed by (`y-x`) ones

       x:3
       y:9
    (&x),(y-x)#1
    0 0 0 1 1 1 1 1 1
       zl:{(&x),(y-x)#1}
       zl[x;y]
    0 0 0 1 1 1 1 1 1
       x:2 5 7 4 9 3 6
       zl\:[x;y]
       x:2 5 7 4 9 3 6
       zl\:[x;y]
    (0 0 1 1 1 1 1 1 1
    0 0 0 0 0 1 1 1 1
    0 0 0 0 0 0 0 1 1
    0 0 0 0 1 1 1 1 1
    0 0 0 0 0 0 0 0 0
    0 0 0 1 1 1 1 1 1
    0 0 0 0 0 0 1 1 1)

    q)x:3
    q)y:9
    q)(x#0),(y-x)#1
    0 0 0 1 1 1 1 1 1
    q)zl:{(x#0),(y-x)#1}
    q)zl[x;y]
    0 0 0 1 1 1 1 1 1
    q)x:2 5 7 4 9 3 6
    q)zl\:[x;y]
    0 0 1 1 1 1 1 1 1
    0 0 0 0 0 1 1 1 1
    0 0 0 0 0 0 0 1 1
    0 0 0 0 1 1 1 1 1
    0 0 0 0 0 0 0 0 0
    0 0 0 1 1 1 1 1 1
    0 0 0 0 0 0 1 1 1



## 169. See 172



## 170. Horizontal barchart of `x` with maximum `z`, normalized to length `y`

       x:4
       y:5
       z:10
       ad:{_ x*y%z}
       ad[2;5;10]
    1
       ad[23;50;80]
    14
       x:2 8 5 6 3 1 7 7 10 4
       xl:{(x#1),&y-x}
       xl\:[ad[x;y;z];y]
    (1 0 0 0 0
    1 1 1 1 0
    1 1 0 0 0
    1 1 1 0 0
    1 0 0 0 0
    0 0 0 0 0
    1 1 1 0 0
    1 1 1 0 0
    1 1 1 1 1
    1 1 0 0 0)
       " X"[xl\:[ad[x;y;z];y]]
    ("X "
    "XXXX "
    "XX "
    "XXX "
    "X "
    " "
    "XXX "
    "XXX "
    "XXXXX"
    "XX ")

    q)x:2 8 5 6 3 1 7 7 10 4
    q)xl:{(x#1),((y-x)#0)}
    q)ad:{floor x*y%z}
    q)ad[2;5;10]
    1
    q)ad[23;50;80]
    14
    q)y:5
    q)z:10
    q)xl\:[ad[x;y;z];y]
    1 0 0 0 0
    1 1 1 1 0
    1 1 0 0 0
    1 1 1 0 0
    1 0 0 0 0
    0 0 0 0 0
    1 1 1 0 0
    1 1 1 0 0
    1 1 1 1 1
    1 1 0 0 0
    q)" X"[xl\:[ad[x;y;z];y]]
    "X    "
    "XXXX "
    "XX   "
    "XXX  "
    "X    "
    "     "
    "XXX  "
    "XXX  "
    "XXXXX"
    "XX   "



## 171. Horizontal barchart of integer values `x`

Compare `bh` here with `xl` in 172.

       bh:{@[&y;!x;:;1]}
       " X"[bh\:[x;|/x]]
    ("XX "
    "XXXXXXXX "
    "XXXXX "
    "XXXXXX "
    "XXX "
    "X "
    "XXXXXXX "
    "XXXXXXX "
    "XXXXXXXXXX"
    "XXXX ")

    q)bh:{@[y#0;til x;:;1]}
    q)" X"[bh\:[x;max x]]
    "XX        "
    "XXXXXXXX  "
    "XXXXX     "
    "XXXXXX    "
    "XXX       "
    "X         "
    "XXXXXXX   "
    "XXXXXXX   "
    "XXXXXXXXXX"
    "XXXX      "



## 172. List of `x` ones followed by (`y-x`) zeros

       x:5
       y:9
       (x#1),&(y-x)
    1 1 1 1 1 0 0 0 0
       xl:{(x#1),&y-x}
       xl[x;y]
    1 1 1 1 1 0 0 0 0
       x:2 5 7 4 9 3 6
       xl\:[x;y]
    (1 1 0 0 0 0 0 0 0
    1 1 1 1 1 0 0 0 0
    1 1 1 1 1 1 1 0 0
    1 1 1 1 0 0 0 0 0
    1 1 1 1 1 1 1 1 1
    1 1 1 0 0 0 0 0 0
    1 1 1 1 1 1 0 0 0)

    q)x:5
    q)y:9
    q)(x#1),(y-x)#0
    1 1 1 1 1 0 0 0 0
    q)xl:{(x#1),(y-x)#0}
    q)xl[x;y]
    1 1 1 1 1 0 0 0 0
    q)xl\:[x;y]
    1 1 1 1 1 0 0 0 0
    q)x:2 5 7 4 9 3 6
    q)xl\:[x;y]
    1 1 0 0 0 0 0 0 0
    1 1 1 1 1 0 0 0 0
    1 1 1 1 1 1 1 0 0
    1 1 1 1 0 0 0 0 0
    1 1 1 1 1 1 1 1 1
    1 1 1 0 0 0 0 0 0
    1 1 1 1 1 1 0 0 0



## 173. Assign `x` to one of `y` classes of width `h`, starting with `g`

       f:{[x;y;g;h] -1+ -1 _ #:'=(1+!y),-_-(x-g)%h}
       x:32 56 36 48 36 24 28 44 52 32
       y:4
       h:10
       g:10
    f[x;y;g;h]
    0 2 4 2



## 174. Move `x` into first quadrant

       sm:{x-&/x}
       x:(1 6 4;3 4 7;7 8 6)
       sm'[x]
    (0 5 3
    0 1 4
    1 2 0)

    q)sm:{x-min x}
    q)x:(1 6 4;3 4 7;7 8 6)
    q)sm'[x]
    0 5 3
    0 1 4
    1 2 0



## 175. Primes to `n`

       n:10
       x:1+!n
       x
    1 2 3 4 5 6 7 8 9 10
       x!/:x:1+!n
    (0 0 0 0 0 0 0 0 0 0
    1 0 1 0 1 0 1 0 1 0
    1 2 0 1 2 0 1 2 0 1
    1 2 3 0 1 2 3 0 1 2
    1 2 3 4 0 1 2 3 4 0
    1 2 3 4 5 0 1 2 3 4
    1 2 3 4 5 6 0 1 2 3
    1 2 3 4 5 6 7 0 1 2
    1 2 3 4 5 6 7 8 0 1
    1 2 3 4 5 6 7 8 9 0)
       +/0=x!/:x:1+!n
    1 2 2 3 2 4 2 4 3 4
       2=+/0=x!/:x:1+!n
    0 1 1 0 1 0 1 0 0 0
       &0,2=+/0=x!/:x:1+!n
    2 3 5 7
       pn:{[n]&0,2=+/0={x!/:x}1+!n}
       pn 30
    2 3 5 7 11 13 17 19 23 29

    q)n:10
    q)x:1+til n
    q)x
    1 2 3 4 5 6 7 8 9 10
    q)x mod/:x:1+til n
    0 0 0 0 0 0 0 0 0 0
    1 0 1 0 1 0 1 0 1 0
    1 2 0 1 2 0 1 2 0 1
    1 2 3 0 1 2 3 0 1 2
    1 2 3 4 0 1 2 3 4 0
    1 2 3 4 5 0 1 2 3 4
    1 2 3 4 5 6 0 1 2 3
    1 2 3 4 5 6 7 0 1 2
    1 2 3 4 5 6 7 8 0 1
    1 2 3 4 5 6 7 8 9 0
    q)sum 0=x mod/:x:1+til n
    1 2 2 3 2 4 2 4 3 4
    q)2=sum 0=x mod/:x:1+til n
    0110101000b
    q)0b,2=sum 0=x mod/:x:1+til n
    00110101000b
    q)where 0b,2=sum 0=x mod/:x:1+til n
    2 3 5 7
    q)pn:{[n]where 0b,2=sum 0=x mod/:x:1+til n}
    q)pn 30
    2 3 5 7 11 13 17 19 23 29
    /classic:
    /q)p:{x[where not (x in distinct raze x*/:\:x:2_ key x)]}
    /q)p 10
    /2 3 5 7
    /q)p 30
    /2 3 5 7 11 13 17 19 23 29



## 177. Ordinal of word in `x` pointed at by `y`

       ow:{+/~y<1+&x=" "}
       x:"ordinal of word in x pointed at by y"
    ow[x;5]
    0
    ow[x;6]
    0
    ow[x;7]
    0
    ow[x;8]
    1
    ow[x;26]
    5

    q)ow:{sum not y<1+where x=" "}
    q)x:"ordinal of word in x pointed at by y"
    q)ow[x;5]
    0
    q)ow[x;6]
    0
    q)ow[x;7]
    0
    q)ow[x;8]
    1
    q)ow[x;26]
    5



## 177. Indices of start of string `x` in string `y`

       x:"st"
       y:"indices of start of string x in string y"
       y _ss x
    11 20 32

    q)y ss x
    11 20 32



## 178. Index of first occurrence of string `x` in string `y`

       x:"st"
       y:"index of first occurrence of string x in string y"
       *y _ss x
    12

    q)first y ss x
    12



## 179. Contour levels `y` at points with altitude `x`

       cl:{y[-1++/~y>x]}
       y:-100 0 10 100 1000 10000
       cl[-5;y]
    -100
       cl[0;y]
    0
       cl[99;y]
    10
       cl[9;y]
    0
       cl[10;y]
    10

    q)cl:{y[-1+sum not y>x]}
    q)y:-100 0 10 100 1000 10000
    q)cl[-5;y]
    -100
    q)cl[0;y]
    0
    q)cl[99;y]
    10
    q)cl[9;y]
    0
    q)cl[10;y]
    10



## 180. Is `x` in range \[y)

       hc:{1 0~/:~x<\:y}
       x:19 20 21 39 40 41
       y:20 40
       ~x<\:y
    (0 0
    1 0
    1 0
    1 0
    1 1
    1 1)
       hc[x;y]
    0 1 1 1 0 0

    q)x:19 20 21 39 40 41
    q)y:20 40
    q)not x<\:y
    00b
    10b
    10b
    10b
    11b
    11b
    q)hc:{10b~/:not x<\:y}
    q)hc[x;y]
    011100b



## 181. Which class of `y` `x` belongs to

       cl:{-1++/x>/:y}
       x:87 9 931 7 27 92 654 1416 7 911
       y:0 50 100 1000
       +/x>/:y
    2 1 3 1 1 2 3 4 1 3
       -1++/x>/:y
    1 0 2 0 0 1 2 3 0 2
    cl[x;y]
    1 0 2 0 0 1 2 3 0 2

    q)cl:{-1+sum x>/:y}
    q)x:87 9 931 7 27 92 654 1416 7 911
    q)y:0 50 100 1000
    q)sum x>/:y
    2 1 3 1 1 2 3 4 1 3
    q)x>/:y
    1111111111b
    1010011101b
    0010001101b
    0000000100b
    q)-1 sum x>/:y
    'type
    q)-1+ sum x>/:y
    1 0 2 0 0 1 2 3 0 2
    q)cl[x;y]
    1 0 2 0 0 1 2 3 0 2



## 182. Indices of consecutive repeated elements

       x:"aaabccccdeee"
       =x
    (0 1 2
    ,3
    4 5 6 7
    ,8
    9 10 11)
       #:'=x
    3 1 4 1 3
       &1<#:'=x
    0 2 4
       {x[&1<#:'x]}=x
    (0 1 2
    4 5 6 7
    9 10 11)
       re:{{x[&1<#:'x]}[=x]}
       re x
    (0 1 2
    4 5 6 7
    9 10 11)

    q)group x
    a| 0 1 2
    b| ,3
    c| 4 5 6 7
       d| ,8
    e| 9 10 11
    q)count group x
    5
    q)count each group x
    a| 3
    b| 1
    c| 4
    d| 1
    e| 3
    q)where 1<count each group x
    "ace"
    q)value 1<count each group x
    10101b
    q)where value 1<count each group x
    0 2 4



## 183. Maximum table

       x:!10
       x&\:x
    (0 0 0 0 0 0 0 0 0 0
    0 1 1 1 1 1 1 1 1 1
    0 1 2 2 2 2 2 2 2 2
    0 1 2 3 3 3 3 3 3 3
    0 1 2 3 4 4 4 4 4 4
    0 1 2 3 4 5 5 5 5 5
    0 1 2 3 4 5 6 6 6 6
    0 1 2 3 4 5 6 7 7 7
    0 1 2 3 4 5 6 7 8 8
    0 1 2 3 4 5 6 7 8 9)

    q)x:key 10
    q)x&\:x
    0 0 0 0 0 0 0 0 0 0
    0 1 1 1 1 1 1 1 1 1
    0 1 2 2 2 2 2 2 2 2
    0 1 2 3 3 3 3 3 3 3
    0 1 2 3 4 4 4 4 4 4
    0 1 2 3 4 5 5 5 5 5
    0 1 2 3 4 5 6 6 6 6
    0 1 2 3 4 5 6 7 7 7
    0 1 2 3 4 5 6 7 8 8
    0 1 2 3 4 5 6 7 8 9



## 184. Right-justify fields `x` of length `y` to length `g`

       x:"abcdefghij"
       y:2 3 4 1
       g:5
       a:+\0,-1_ y
       a
    0 2 5 9
       a _ x
    ("ab"
    "cde"
    "fghi"
    ,"j")
       (g#" "),/:a _ x
    (" ab"
    " cde"
    " fghi"
    " j")
       b:(-g)#/:(g#" "),/:a _ x
       b
    (" ab"
    " cde"
    " fghi"
    " j")
       ,/b
       rj:{[x;y;g],/(-g)#/:(g#" "),/:(+\0,-1 _ y) _ x}
       rj[x;y;g]
    " ab cde fghi j"

    q)x:"abcdefghij"
    q)y:2 3 4 1
    q)g:5
    q)a:sums 0,-1_y
    q)a
    0 2 5 9
    q)a _ x
    "ab"
    "cde"
    "fghi"
    ,"j"
    q)(g#" "),/:a _ x
    "     ab"
    "     cde"
    "     fghi"
    "     j"
    q)b:(neg g)#/:(g#" "),/:a _ x
    q)b
    "   ab"
    "  cde"
    " fghi"
    "    j"
    q)raze b
    "   ab  cde fghi    j"
    q)rj:{[x;y;g]raze(neg g)#/:(g#" "),/:(sums 0,-1_y) _ x}
    q)rj[x;y;g]
    "   ab  cde fghi    j"



## 185. Left-justify fields `x` of length `y` to length `g`

       x:"abcdefghij"
       y:2 3 4 1
       g:5
       a:+\0,-1_ y
       a
    0 2 5 9
       a _ x
    ("ab"
    "cde"
    "fghi"
    ,"j")
       ((:+\0,-1_ y) _ x),\:g#" "
    ("ab "
    "cde "
    "fghi "
    "j ")
       g#/:((:+\0,-1_ y) _ x),\:g#" "
    ("ab "
    "cde "
    "fghi "
    "j ")
       lj:{[x;y;g],/g#/L :+\0,-1_ y ),\:g#" " }
       rj[x;y;g]
    " ab cde fghi j"
       lj:{[x;y;g],/g#/:((+\0,-1 _ y)_ x),\:g#" "}
       lj[x;y;g]
    "ab cde fghi j "

    q)x:"abcdefghij"
    q)y:2 3 4 1
    q)g:5
    q)a:sums 0,-1_y
    q)a
    0 2 5 9
    q)a _ x
    "ab"
    "cde"
    "fghi"
    ,"j"
    q)((sums 0,-1_y)_x),\:g#" "
    "ab     "
    "cde     "
    "fghi     "
    "j     "
    q)g#/:((sums 0,-1_y)_x),\:g#" "
    "ab   "
    "cde  "
    "fghi "
    "j    "
    q)lj:{[x;y;g]raze g#/:((sums 0,-1_y)_x),\:g#" "}
    'lj
    /lj is a reserved word
    q)ljust:{[x;y;g]raze g#/:((sums 0,-1_y)_x),\:g#" "}
    q)ljust[x;y;g]
    "ab   cde  fghi j    "



## 186. Annuity coefficient for `x` periods at interest rate `y`%

       x:10 15 20 25
       y:8 9 10 15
       +1-(1+y%100)^\:-x
    (0.537 0.578 0.614 0.753
    0.685 0.725 0.761 0.877
    0.785 0.822 0.851 0.939
    0.854 0.884 0.908 0.97)
       ac:{(y%100)%/:+1-(1+y%100)^\:-x}
       ac[x;y]
    (0.149 0.156 0.163 0.199
    0.117 0.124 0.131 0.171
    0.102 0.11 0.117 0.16
    0.0937 0.102 0.11 0.155)

    q)x:10 15 20 25
    q)y:8 9 10 15
    q)flip 1-xexp\:[(1+y%100);neg x]
    0.5368065 0.5775892 0.6144567 0.7528153
    0.6847583 0.725462  0.760608  0.8771055
    0.7854518 0.8215691 0.8513564 0.9388997
    0.8539821 0.8840322 0.907704  0.9696224
    q)\P 3
    q)flip 1-xexp\:[(1+y%100);neg x]
    0.537 0.578 0.614 0.753
    0.685 0.725 0.761 0.877
    0.785 0.822 0.851 0.939
    0.854 0.884 0.908 0.97
    q)ac:{(y%100)%/:flip 1-xexp\:[(1+y%100);neg x]}
    q)ac[x;y]
    0.149  0.156 0.163 0.199
    0.117  0.124 0.131 0.171
    0.102  0.11  0.117 0.16
    0.0937 0.102 0.11  0.155



## 187. Direct matrix product

       x:1+3 2# !6
       y:1+2 4#!8
       +:'x*\:\:y
       +:'x*\:\:y
    (((1 2 3 4
    2 4 6 8)
    (5 6 7 8
    10 12 14 16))
    ((3 6 9 12
    4 8 12 16)
    (15 18 21 24
    20 24 28 32))
    ((5 10 15 20
    6 12 18 24)
    (25 30 35 40
    30 36 42 48)))
       dp:{+:'x*\:\:y}

    q)x:1+3 2#til 6
    q)y:1+2 4#til 8
    q)+:'[x*\:\:y]
    1 2 3 4     2 4 6 8     5  6  7  8  10 12 14 16
    3 6 9  12   4 8 12 16   15 18 21 24 20 24 28 32
    5 10 15 20  6 12 18 24  25 30 35 40 30 36 42 48
    q)dp:{+:'[x*\:\:y]}



## 188. Shur product

       x
    (1 2
    3 4
    5 6)
    a   y
    (1 2 3 4
    5 6 7 8)
       ((*|^x)#x)*(*^y)#'y
    (1 4
    15 24)



## 189. Add `x` to each row of `y`

       x:1+!4
       y:3 4#2+!12
       y
    (2 3 4 5
    6 7 8 9
    10 11 12 13)
       x+/:y
    (3 5 7 9
    7 9 11 13
    11 13 15 17)

    q)x:1+til 4
    q)y:3 4#2+til 12
    q)y
    2  3  4  5
    6  7  8  9
    10 11 12 13
    q)x+/:y
    3  5  7  9
    7  9  11 13
    11 13 15 17



## 190. See 189



## 191. Shur sum

       x
    (1 2
    3 4
    5 6)
       y
    (1 2 3 4
    5 6 7 8)
    ((*|^x)#x)+(*^y)#'y
    (2 4
    8 10)



## 192. Add `x` to each column of `y`

       x:1+!2
       x
    1 2
       y:2 5#3+!10
       y
    (3 4 5 6 7
    8 9 10 11 12)
       x+'y
    (4 5 6 7 8
    10 11 12 13 14)

    q)x:1+til 2
    q)y:2 5#3+til 10
    q)x+'y
    4  5  6  7  8
    10 11 12 13 14



## 193. See 192



## 195. Upper triangular matrix of order `x`

       x:5
       {~x>\:x}!x
    (1 1 1 1 1
    0 1 1 1 1
    0 0 1 1 1
    0 0 0 1 1
    0 0 0 0 1)
       ut:{{~x>\:x}[!x]}
       ut 5
    (1 1 1 1 1
    0 1 1 1 1
    0 0 1 1 1
    0 0 0 1 1
    0 0 0 0 1)

    q){not x>\:x} til x
    11111b
    01111b
    00111b
    00011b
    00001b
    q)ut:{{not x>\:x}til x}
    q)ut 5
    11111b
    01111b
    00111b
    00011b
    00001b



## 196. Lower triangular matrix of order ``x``

       lt:{{~x<\:x}[!x]}
       lt 5
    (1 0 0 0 0
    1 1 0 0 0
    1 1 1 0 0
    1 1 1 1 0
    1 1 1 1 1)

    q)lt:{{not x<\:x}til x}
    q)lt 5
    10000b
    11000b
    11100b
    11110b
    11111b



## 197. Identity matrix of order `x`

       id:{(x,x)#1,x#0}
       id 5
    (1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0
    0 0 0 1 0
    0 0 0 0 1)
    q)id:{(x,x)#1,x#0}
    q)id 5
    1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0
    0 0 0 1 0
    0 0 0 0 1
    /(5,5) syntax needs further study
    q)(5;5)#1,5#0
    1 0 0 0 0
    0 1 0 0 0
    0 0 1 0 0
    0 0 0 1 0
    0 0 0 0 1



## 198. Hilbert matrix of order `x`

       hm:{%1+(!x)+/:!x}
       hm 5
    (1 0.5 0.333 0.25 0.2
    0.5 0.333 0.25 0.2 0.167
    0.333 0.25 0.2 0.167 0.143
    0.25 0.2 0.167 0.143 0.125
    0.2 0.167 0.143 0.125 0.111)

    q)hm:{reciprocal 1+(til x)+/:til x}
    q)hm 5
    1         0.5       0.3333333 0.25      0.2
    0.5       0.3333333 0.25      0.2       0.1666667
    0.3333333 0.25      0.2       0.1666667 0.1428571
    0.25      0.2       0.1666667 0.1428571 0.125
    0.2       0.1666667 0.1428571 0.125     0.1111111



## 199. Multiplication table of order `x`

       mt:{{x*\:x}[1+!x]}
       mt 5
    (1 2 3 4 5
    2 4 6 8 10
    3 6 9 12 15
    4 8 12 16 20
    5 10 15 20 25)

    q)mt:{{x*\:x}[1+til x]}
    q)mt 5
    1 2  3  4  5
    2 4  6  8  10
    3 6  9  12 15
    4 8  12 16 20
    5 10 15 20 25



## 200. Replicating a dimension of rank-3 array `x` `y`-fold

       x:2 3 3#1+!18
       y:3
       x[;,/(y#1)*\:!(^x)[1];]
    ((1 2 3
    4 5 6
    7 8 9
    1 2 3
    4 5 6
    7 8 9
    1 2 3
    4 5 6
    7 8 9)
    (10 11 12
    13 14 15
    16 17 18
    10 11 12
    13 14 15
    16 17 18
    10 11 12
    13 14 15
    16 17 18))



## 201. Moving index `y`-wide for `x`

       x:"abcdef"
       y:3
       (!(#x)-y-1)+\:y
    3 4 5 6

    q)x:"abcdef"
    q)y:3
    q)(til (count x)-y-1)+\:y
    3 4 5 6



## 202. Indices of infixes of length `y`

       x:4+!5
       x
    4 5 6 7 8
       y:3
       x+\:!y
    (4 5 6
    5 6 7
    6 7 8
    7 8 9
    8 9 10)

    q)x:4+til 5
    q)y:3
    q)x+\:til 3
    4 5 6
    5 6 7
    6 7 8
    7 8 9
    8 9 10



## 203. One-column matrix from numeric list

       x:7 _draw 100
       x
    34 31 51 29 35 17 89
    +,x
    (,34
    ,31
    ,51
    ,29
    ,35
    ,17
    ,89)

    q)x:34 31 51 29 35 17 89
    q)flip,x
    +:
    34
    31
    51
    29
    35
    17
    89



## 204. Numeric array and its negative

       x:3+3 4# !12
       x
    (3 4 5 6
    7 8 9 10
    11 12 13 14)
       x,''-x
    ((3 -3
    4 -4
    5 -5
    6 -6)
    (7 -7
    8 -8
    9 -9
    10 -10)
    (11 -11
    12 -12
    13 -13
    14 -14))

    q)x:3+3 4#til 12
    q)x,''neg x
    3 -3   4 -4   5 -5   6 -6
    7  -7  8  -8  9  -9  10 -10
    11 -11 12 -12 13 -13 14 -14



## 205. Remove trailing blank rows

       x:+5 9#"abc de "
       x
    ("aaaaa"
    "bbbbb"
    "ccccc"
    " "
    "ddddd"
    "eeeee"
    " "
    " "
    " ")
       x~\:(#+x)#" "
    0 0 0 1 0 0 1 1 1
       ~x~\:(#+x)#" "
    1 1 1 0 1 1 0 0 0
       ||\|~x~\:(#+x)#" "
    1 1 1 1 1 1 0 0 0
       &||\|~x~\:(#+x)#" "
    0 1 2 3 4 5
       rtr:{x[&||\|~x~\:(#+x)#" "]}
       rtr[x]
    ("aaaaa"
    "bbbbb"
    "ccccc"
    " "
    "ddddd"
    "eeeee")

    q)x:flip 5 9#"abc de   "
    q)x
    "aaaaa"
    "bbbbb"
    "ccccc"
    "     "
    "ddddd"
    "eeeee"
    "     "
    "     "
    "     "
    q)x~\:(count flip x)#" "
    000100111b
    q)not x~\:(count flip x)#" "
    111011000b
    q)reverse maxs reverse not  x~\:(count flip x)#" "
    111111000b
    q)where reverse maxs reverse not  x~\:(count flip x)#" "
    0 1 2 3 4 5
    q)rtr:{x[where reverse maxs reverse not  x~\:(count flip x)#" "]}
    q)rtr x
    "aaaaa"
    "bbbbb"
    "ccccc"
    "     "
    "ddddd"
    "eeeee"



## 206. Remove duplicate rows

       x:("abc"
    "def"
    "abc"
    "ghi"
    "jkl"
    "abc"
    "ghi"
    "abc")
       ?x
    ("abc"
    "def"
    "ghi"
    "jkl")

    q)x:("abc";"def";"abc";"ghi";"jkl";"abc";"ghi";"abc")
    q)distinct x
    "abc"
    "def"
    "ghi"
    "jkl"



## 207. Indices in matrix `x` of rows of matrix `y`

       x:+3 8#"abcdefgh"
       x
    ("aaa"
    "bbb"
    "ccc"
    "ddd"
    "eee"
    "fff"
    "ggg"
    "hhh")
       y:+3 4#"afmc"
       y
    ("aaa"
    "fff"
    "mmm"
    "ccc")
       x?/:y
    0 5 8 2

    q)x:flip 3 8#"abcdefgh"
    q)x
    "aaa"
    "bbb"
    "ccc"
    "ddd"
    "eee"
    "fff"
    "ggg"
    "hhh"

    q)y:flip 3 4#"afmc"
    q)y
    "aaa"
    "fff"
    "mmm"
    "ccc"
    q)x?/:y
    0 5 8 2



## 208. See 206



## 209. Remove trailing blank columns

       x:3 9#"abc de "
       x
    ("abc de "
    "abc de "
    "abc de ")
       +rtr[+x]
    ("abc de"
    "abc de"
    "abc de")

    q)rtr:{x[where reverse maxs reverse not  x~\:(count flip x)#" "]}
    q)x:3 9#"abc de   "
    q)x
    "abc de   "
    "abc de   "
    "abc de   "
    q)rtr x
    "abc de   "
    "abc de   "
    "abc de   "
    q)rtr flip x
    "aaa"
    "bbb"
    "ccc"
    "   "
    "ddd"
    "eee"
    q)flip rtr flip x
    "abc de"
    "abc de"
    "abc de"



## 210. Remove leading blank columns

       x:3 9#" ed cba"
       x
    (" ed cba"
    " ed cba"
    " ed cba")
       +|rtr[|+x]
    ("ed cba"
    "ed cba"
    "ed cba")

    q)rtr:{x[where reverse maxs reverse not  x~\:(count flip x)#" "]}
    q)x:3 9#"   ed cha"
    q)x
    "   ed cha"
    "   ed cha"
    "   ed cha"
    q)flip reverse rtr[reverse flip x]
    "ed cha"
    "ed cha"
    "ed cha"



## 211. Remove leading blank rows

       x:|+3 9#"abc de "
       x
    (" "
    " "
    " "
    "eee"
    "ddd"
    " "
    "ccc"
    "bbb"
    "aaa")
    |rtr[|x]
    ("eee"
    "ddd"
    " "
    "ccc"
    "bbb"
    "aaa")

    q)rtr:{x[where reverse maxs reverse not  x~\:(count flip x)#" "]}
    q)x:reverse flip 3 9#"abc de   "
    q)x
    "   "
    "   "
    "   "
    "eee"
    "ddd"
    "   "
    "ccc"
    "bbb"
    "aaa"
    q)reverse rtr[reverse x]
    "eee"
    "ddd"
    "   "
    "ccc"
    "bbb"
    "aaa"



## 213. Maxima of infixes of `x` specified by boolean list `y`

       x:-17 7 30 12 5 2 -5 6 -3 -19
       y:10#1 1 0
       y
    1 1 0 1 1 0 1 1 0 1
       |/x[&y]
    12

    q)x:-17 7 30 12 5 2 -5 6 -3 -19
    q)y:10#1 1 0
    q)y
    1 1 0 1 1 0 1 1 0 1
    q)max x[where y]
    12



## 214. See 159



## 215. See 159



## 216. Rows of matrix `x` starting with `y`

       x:("sit";"sat";"sin";"tin")
       x
    ("sit"
    "sat"
    "sin"
    "tin")
       y:"si"
       y _lin/:x
    (1 1
    1 0
    1 1
    0 1)
       &/'y _lin/:x
    1 0 1 0
       &&/'y _lin/:x
    0 2
       rb:{x[&&/'y _lin/:x]}
      rb[x;y]
    ("sit"
    "sin")

    q)x:("sit";"sat";"sin";"tin")
    q)y:"si"
    q)y in/:x
    11b
    10b
    11b
    01b
    q)min'[y in/:x]
    1010b
    q)where min'[y in/:x]
    0 2
    q)rb:{x[where min'[y in/:x]]}
    q)rb[x;y]
    "sit"
    "sin"



## 217. Index of last nonblank in string

       x:("love's not "
    "time's fool "
    "though rosy ")
       ln:{*|&~" "=x}
       ln'x
    9 10 10

    q)x:("love's not ";"time's fool ";"though rosy ")
    q)ln:{last where not " "=x}
    q)ln'[x]
    9 10 10



## 218. Single blank row from multiple

       s:" a bc def g"
       a:~s=" "
       a
    0 0 1 0 1 1 0 0 1 1 1 0 0 0 0 1
       b:~a
       b
    1 1 0 1 0 0 1 1 0 0 0 1 1 1 1 0
       c:>':0,b
       c
    1 0 0 1 0 0 1 0 0 0 0 1 0 0 0 0
       d:a|c
       d
    1 0 1 1 1 1 1 0 1 1 1 1 0 0 0 1
       e:&d
       e
    0 2 3 4 5 6 8 9 10 11 15
       s[e]
    " a bc def g"
       x:+3 10#"a b c d"
       x
    ("aaa"
    " "
    " "
    "bbb"
    " "
    "ccc"
    " "
    " "
    " "
    "ddd")
       a:x~\:(#+x)#" "
       a
    0 1 1 0 1 0 1 1 1 0
       b:~a
       c:>':0,a
       c
    0 1 0 0 1 0 1 0 0 0
       d:b|c
       d
    1 1 0 1 1 1 1 0 0 1
       e:&d
       e
    0 1 3 4 5 6 9
       x[e]
    ("aaa"
    " "
    "bbb"
    " "
    "ccc"
    " "
    "ddd")
       rs:{x[{&(~x)|xf[x]}x~\:(#+x)#" "]}
       rs x
    ("aaa"
    " "
    "bbb"
    " "
    "ccc"
    " "
    "ddd")

    q)s:"  a bc  def    g"
    q)a:not s=" "
    q)a
    0010110011100001b
    q)b:not a
    /q)c:>':[0b,b]
    /q)c
    /01001001000010000b
    q)b
    1101001100011110b
    q)c:>':[b]
    q)c
    1001001000010000b
    q)d:a|c
    q)d
    1011111011110001b
    q)e:where d
    q)e
    0 2 3 4 5 6 8 9 10 11 15
    q)s[e]
    " a bc def g"
    q)x:flip 3 10#"a  b  c  d"
    q)x
    "aaa"
    "   "
    "   "
    "bbb"
    "   "
    "   "
    "ccc"
    "   "
    "   "
    "ddd"
    q)a:x~\:(count flip x)#" "
    q)a
    0110110110b
    q)b:not a
    q)c:>':[a]
    q)c
    0100100100b
    q)d:b|c
    q)d
    1101101101b
    q)e:where d
    q)x[e]
    "aaa"
    "   "
    "bbb"
    "   "
    "ccc"
    "   "
    "ddd"



## 219. See 147



## 220. Remove duplicate blank columns

       x:3 9#"a b c d"
       x
    ("a b c d"
    "a b c d"
    "a b c d")
    +rs[+x]
    ("a b c d"
    "a b c d"
    "a b c d")



## 221. Is `x` an integer in interval \[ `g`,`h` )

       g:6
       h:12
       x:18
       (x=_ x)&(~x<g)&(x<h)
    0
       x:7
       (x=_ x)&(~x<g)&(x<h)
    1
       x:7.1
       (x=_ x)&(~x<g)&(x<h)
    0

    q)g:6
    q)h:12
    q)x:18
    q)
    q)(x=floor x)&(not x<g)&(x<h)
    0b
    q)x:7
    q)(x=floor x)&(not x<g)&(x<h)
    1b
    q)x:7.1
    q)(x=floor x)&(not x<g)&(x<h)
    0b



## 222. Maximum of `x` with weights `y`

       x:1 2 3 4 5
       y:5 4 3 2 1
       |/x*y
    9

    q)x:1 2 3 4 5
    q)y:5 4 3 2 1
    q)max x*y
    9



## 223. Minimum of `x` with weights `y`

       x:1 2 3 4 5
       y:5 4 3 2 1
       &/x*y
    5

    q)x:1 2 3 4 5
    q)y:5 4 3 2 1
    q)min x*y
    5



## 224. Extend distance table to next leg

       x:( 0 50 80 20 999
    > 50 0 20 40 30
    > 80 20 0 999 30
    > 20 40 999 0 10
    > 999 30 30 10 0)
    notice x[0;2] is 80 while x[0;1]+x[1;2] is 70
       x(&/+)\:x
    (0 50 70 20 30
    50 0 20 40 30
    70 20 0 40 30
    20 40 40 0 10
    30 30 30 10 0)



## 225. Remove blank rows

       x:("aaa"
    > "bbb"
    > " "
    > "ccc"
    > " ")
       x _dv " "
    ("aaa"
    "bbb"
    "ccc")



## 226. Remove blank columns

       x:+4 4#"xxxx hhhh ii"
       x
    ("x h "
    "x h "
    "x hi"
    "x hi")
       +(+x)_dv " "
    ("xh "
    "xh "
    "xhi"
    "xhi")



## 227. See 69



## 228. Is `y` a row of x

       x:("xxx";"yyy";"zzz";"yyy")
       x?"yyy"
    1

    q)x?"yyy"
    1



## 229. See 228



## 230. Extend a transitive binary relation

       x:(0 1 0 0
    > 0 0 1 1
    > 1 0 0 0
    > 0 0 1 0)
       x(|/&)\:x
    (0 0 1 1
    1 0 1 0
    0 1 0 0
    1 0 0 0)

    q)x:(0 1 0 0;0 0 1 1;1 0 0 0;0 0 1 0)
    q)x(|/&)\:x
    '/
    q)x(|/[&])\:x
    0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0
    0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0



## 231. Which rows of `x` contain elements different from `y`

       x:("aaa";"bbb";"ooo";"pop")
       y:"o"
       ~x=y
    (1 1 1
    1 1 1
    0 0 0
    1 0 1)
       |/'~x=y
    1 1 0 1

    q)x:("aaa";"bbb";"ooo";"pop")
    q)y:"o"
    q)not  x=y
    111b
    111b
    000b
    101b
    q)max each not x=y
    1101b



## 232. Is `y` a row of x

       x:("aaa"
    "bbb"
    "ooo"
    "ppp"
    "kkk")
       y:"ooo"
       y _in x
    1

    q)y in x
    1b



## 233. Is x within range \[ `y`)

       x:9
       y:(1 9
    > 9 16
    > 5 7
    > 8 20
    > 6 10)
       x<'y
    (0 0
    0 1
    0 0
    0 1
    0 1)
       </'x<y
    0 1 0 1 1
       x(</<)/:y
    0 1 0 1 1

    q)x:9
    q)y:(1 9;9 16;5 7;8 20;6 10)
    q)x<'y
    00b
    01b
    00b
    01b
    01b
    q)</'[x<y]
    01011b
    /x(</<)/:y needs more work



## 234. Is `x` within the range ( `y`\]

       ~x>'y
    (0 1
    1 1
    0 0
    0 1
    0 1)
       </'~x>'y
    1 0 0 1 1

    q)x:9
    q)y:(1 9;9 16;5 7;8 20;6 10)
    q)not x>'y
    01b
    11b
    00b
    01b
    01b
    q)</'[not x>'y]
    10011b



## 235. See 234



## 236. Number of occurrences of `x` in `y`

       y:3+7 _draw 6
       y
    6 4 7 7 6 6 4
       x:7
       +/x=y
    2
       x(+/=)/:y
    0 0 1 1 0 0 0



## 237. Average (mean) of `x` weighted by `y`

       y:78 80 90 88 72
       x:20 15 20 22 19
       x*y
    1560 1200 1800 1936 1368
       +/x*y
    7864
       (+/x*y)%#x
    1572.8

    q)y:78 80 90 88 72
    q)x:20 15 20 22 19
    q)x*y
    1560 1200 1800 1936 1368
    q)sum x*y
    7864
    q)(sum x*y)%count x
    1572.8



## 239. Sum reciprocal series

       x:10 9 10 7 8
       y:80 63 70 63 64
       +/y%x
    39.0

    q)x:10 9 10 7 8
    q)y:80 63 70 63 64
    q)sum y%x
    39f



## 240. Matrix product

       x:(1 2 3
    > 4 5 6)
       y:(1 2
    > 3 4
    > 5 6)
       x _mul y
    (22 28
    49 64)
       x(+/*)\:y
    (22 28
    49 64)

    q)x:(1 2 3;4 5 6)
    q)y:(1 2;3 4;5 6)
    q)fx:`float$x
    q)fy:`float$y
    q)fx$fy
    22 28
    49 64
    q)fx mmu fy
    22 28
    49 64



## 241. Sum over subsets of `x` specified by `y`

       x:1+3 4# !12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       y:4 3#1 0
       y
    (1 0 1
    0 1 0
    1 0 1
    0 1 0)
       x _mul y
    (4 6 4
    12 14 12
    20 22 20)

    q)x:1+3 4#til 12
    q)y:4 3#1 0
    q)y
    1 0 1
    0 1 0
    1 0 1
    0 1 0
    q)fx:`float$x
    q)fy:`float$y
    q)x mmu y
    'length
    q)x
    1 2  3  4
    5 6  7  8
    9 10 11 12
    q)fx mmu fy
    4  6  4
    12 14 12
    20 22 20
    /It's annoying that mmu returns 'length when it should say 'type.



## 242. Sum squares of x

       x:1 2 3 4 5
       +/x*x
    55

    q)sum x*x
    55



## 243. Dot product of vectors

       x:1 2 3 4 5
       y:10 20 30 40 50
       +/x*y
    550

    q)sum x*y
    550



## 244. Product over subsets of `x` specified by `y`

       x:1+3 4#! 12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       y:4 3#1 0
       y
    (1 0 1
    0 1 0
    1 0 1
    0 1 0
       x (*/^)\:y
    (3 8 3.0
    35 48 35.0
    99 120 99.0)



## 245. Randomize the random seed

       _t
    -1154371779
       \r -1154371779
       \r
    -1154371779

    q)\S
    -314159
    q)\S -1154371779
    q)\S
    -1154371779



## 246. See 242



## 247. Interlace `x[i]#1` and `y[i]#0`

       x:1 3
       y:2 4
       a:,/+(x;y)
       a
    1 2 3 4
       b:(#x,y)#1 0
       b
    1 0 1 0
       c:a#'b
       c
    (,1
    0 0
    1 1 1
    0 0 0 0)
       d:,/c
       d
    1 0 0 1 1 1 0 0 0 0
       ,/(,/+(x;y))#'(#x,y)#1 0
    1 0 0 1 1 1 0 0 0 0

    q)x:1 3
    q)y:2 4
    q)a:raze flip(x;y)
    q)a
    1 2 3 4
    q)b(count x,y)#1 0
    'b
    q)b:(count x,y)#1 0
    q)b
    1 0 1 0
    q)c:a#'b
    q)c
    ,1
    0 0
    1 1 1
    0 0 0 0
    q)d:raze  c
    q)d
    1 0 0 1 1 1 0 0 0 0
    q)raze(raze flip(x;y))#'(count x,y)#1 0
    1 0 0 1 1 1 0 0 0 0



## 248. Center text `x` in line of width `y`

       x:"1234567890"
       y:16
       a:y#x,y#" "
       a
    "1234567890 "
       b:_ -0.5*y-#x
       b
    3
       c:b!a
       c
    " 1234567890 "
       ct:{(_ -0.5*y-#x)!y#x,y#" "}
       ct[x;y]
    " 1234567890 "
       p:("1234567890";"1234";"123456";"1234567890123456")
       p
    ("1234567890"
    "1234"
    "123456"
    "1234567890123456")
       ct\:[p;y]
    (" 1234567890 "
    " 1234 "
    " 123456 "
    "1234567890123456")

    q)x:"1234567890"
    q)y:16
    q)a:y#x,y#" "
    q)a
    "1234567890      "
    q)b:_ -0.5*y-#x
    '
    q)b:_ -0.5*y-count x
    '
    q)b:_ neg 0.5*y-count x
    '
    q)b:floor neg 0.5*y-count x
    q)b
    -3
    q)b:floor (neg 0.5)*y-count x
    q)b
    -3
    q)b:floor 0.5*y-count x
    q)b
    3



## 249. Offset enumeration

       x:10
       y:3
       x+!y
    10 11 12
       oi:{x+!y}
       oi[x;y]
    10 11 12
       x:10 20 30
       y:3 4 2
       oi'[x;y]
    (10 11 12
    20 21 22 23
    30 31)
       ,/oi'[x;y]
    10 11 12 20 21 22 23 30 31

    q)x:10
    q)y:3
    q)x+til y
    10 11 12
    q)oi:{x+til y}
    q)x:10 20 30
    q)y:3 4 2
    q)oi'[x;y]
    10 11 12
    20 21 22 23
    30 31
    q)raze oi'[x;y]
    10 11 12 20 21 22 23 30 31



## 250. Replicate `y` `x` times

       x:3
       y:10
       x#y
    10 10 10
       rp:{x#y}
       rp[x;y]
    10 10 10
       x:3 4 2
       y:10 20 30
       rp'[x;y]
    (10 10 10
    20 20 20 20
    30 30)
       ,/rp'[x;y]
    10 10 10 20 20 20 20 30 30

    q)x:3
    q)y:10
    q)x#y
    10 10 10
    q)rp:{x#y}
    q)rp[x;y]
    10 10 10
    q)x:3 4 2
    q)y:10 20 30
    q)rp'[x;y]
    10 10 10
    20 20 20 20
    30 30
    q)raze rp'[x;y]
    10 10 10 20 20 20 20 30 30



## 251. See 250



## 252. `x` alternate takes of 1s and 0s

       x:1 2 3 4 5
       b:(#x)#1 0
       b
    1 0 1 0 1
       c:x#'b
       c
    (,1
    0 0
    1 1 1
    0 0 0 0
    1 1 1 1 1)
       d:,/c
       d
    1 0 0 1 1 1 0 0 0 0 1 1 1 1 1
       ,/x#'(#x)#1 0
    1 0 0 1 1 1 0 0 0 0 1 1 1 1 1

    q)x:1 2 3 4 5
    q)b:(count x)#1 0
    q)b
    1 0 1 0 1
    q)c:x#'b
    q)c
    ,1
    0 0
    1 1 1
    0 0 0 0
    1 1 1 1 1
    q)d:raze c
    q)d
    1 0 0 1 1 1 0 0 0 0 1 1 1 1 1
    q)raze x#'(count x)#1 0
    1 0 0 1 1 1 0 0 0 0 1 1 1 1 1



## 253. See 250



## 254. Running parity of infixes of `y` indicated by `x`

       x:1 0 0 0 0 1 0 0 0 0 1 0 0 0
       y:1 0 0 1 1 1 0 0 1 0 1 1 0 0
       a:&x
       a
    0 5 10
       b:a _ y
       b
    (1 0 0 1 1
    1 0 0 1 0
    1 1 0 0)
       c:(+\'b)!\:2
       c
    (1 1 1 0 1
    1 1 1 0 0
    1 0 0 0)
       d:,/c
       d
    1 1 1 0 1 1 1 1 0 0 1 0 0 0



## 255. Running sum of infixes of `y` indicated by `x`

         x:1 0 0 0 1 0 0 0 1
       y:1 2 3 4 5 6 7 8 9
       a:&x
       a
    0 4 8
       b:a _ y
       b
    (1 2 3 4
    5 6 7 8
    ,9)
       c:+\'b
       c
    (1 3 6 10
    5 11 18 26
    ,9)
       d:,/c
       d
    1 3 6 10 5 11 18 26 9
       rs:{,/+\'(&x)_ y}
       rs[x;y]
    1 3 6 10 5 11 18 26 9

    q)x:1 0 0 0 1 0 0 0 1
    q)y:1 2 3 4 5 6 7 8 9
    q)a:where x
    q)
    q)a
    0 4 8
    q)b:a _ y
    q)b
    1 2 3 4
    5 6 7 8
    ,9
    q)c:sums each b
    q)c
    1 3 6 10
    5 11 18 26
    ,9
    q)d:raze b
    q)d
    1 2 3 4 5 6 7 8 9
    q)d:raze c
    q)d
    1 3 6 10 5 11 18 26 9
    q)rs:{raze sums each (where x) _ y}
    q)rs[x;y]
    1 3 6 10 5 11 18 26 9



## 256. Groups of 1s in `y` pointed at by `x`

       y
    0 0 0 1 1 1 1 1 1 0 0 1 1 1 1 1
       x
    0 0 0 1 0 0 0 0 1 0 0 1 0 0 0 1
       a:+\>':0,y
       a
    0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2
       y&a=|\x*a
    0 0 0 1 1 1 1 1 1 0 0 1 1 1 1 1

    q)y:0 0 0 1 1 1 1 1 1 0 0 1 1 1 1 1
    q)x:0 0 0 1 0 0 0 0 1 0 0 1 0 0 0 1
    q)a:sums >':[y]
    q)a
    1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3
    q)a:sums >':[0,y]
    q)a
    1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3
    q)a:+\>':[0,y]
    '\
    q)a:sums >':[0,y]
    q)a:sums >':[y]
    q)a
    1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3
    q)a-1
    0 0 0 1 1 1 1 1 1 1 1 2 2 2 2 2
    q)a:a-1
    q)y&a=maxs x*a
    0 0 0 1 1 1 1 1 1 0 0 1 1 1 1 1



## 257. Sums of infixes of `x` determined by lengths `y`

       x:1+!10
       x
    1 2 3 4 5 6 7 8 9 10
       y:2 3 2 3
       a:+\0,-1 _ y
       a
    0 2 5 7
       a _ x
    (1 2
    3 4 5
    6 7
    8 9 10)
       +/'a _ x
    3 12 13 27

    q)x:1+til 10
    q)y:2 3 2 3
    q)a:sums 0,-1 _ y
    q)a
    0 2 5 7
    q)a _ x
    1 2
    3 4 5
    6 7
    8 9 10
    q)sum each a _ x
    3 12 13 27



## 259. Removing leading and trailing blanks

       x:" abcd e fg "
       a:~x=" "
       a
    0 0 0 1 1 1 1 0 1 0 0 1 1 0 0 0
       (|\a)&(||\|a)
    0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0
       &(|\a)&(||\|a)
    3 4 5 6 7 8 9 10 11 12
       x[&(|\a)&(||\|a)]
    "abcd e fg"
       lt:{x[&(|\a)&||\|a:~x=" "]}
       lt x
    "abcd e fg"

    q)x:" abcd e fg "
    q)x:"   abcd e  fg   "
    q)a:not x=" "
    q)a
    0001111010011000b
    q)(maxs a) and reverse maxs reverse a
    0001111111111000b
    q)where (maxs a) and reverse maxs reverse a
    3 4 5 6 7 8 9 10 11 12
    q)x[where (maxs a) and reverse maxs reverse a]
    "abcd e  fg"
    q)lt:{x[where (maxs a) and reverse maxs reverse a]}
    q)lt x
    "abcd e  fg"



## 260. First 10 figurate numbers of order `x`

       fg:{x+\/10#1}
       fg 0
    1 1 1 1 1 1 1 1 1 1
       fg 1
    1 2 3 4 5 6 7 8 9 10
       fg 2
    1 3 6 10 15 21 28 36 45 55
       fg 3
    1 4 10 20 35 56 84 120 165 220
       fg 4
    1 5 15 35 70 126 210 330 495 715

    q)fg:{x+\/10#1}
    q)fg 0
    1 1 1 1 1 1 1 1 1 1
    q)fg 1
    1 2 3 4 5 6 7 8 9 10
    q)fg 2
    1 3 6 10 15 21 28 36 45 55
    q)fg 3
    1 4 10 20 35 56 84 120 165 220
    q)fg 4
    1 5 15 35 70 126 210 330 495 715



## 261. First group of 1s

       x:1 1 1 0 1 0 1
       x&&\x=|\x
    1 1 1 0 0 0 0
       x:0 0 0 1 1 0 1
       x&&\x=|\x
    0 0 0 1 1 0 0
       x:0 1 0 1 0 1 0
       x&&\x=|\x
    0 1 0 0 0 0 0



## 262. Value of saddle point (see 48)

       x:(5 4 6 4 12 5
    > 16 2 4 5 16 18
    > 8 18 7 12 16 11
    > 20 17 16 14 16 20
    > 16 8 12 9 17 13)
       rn:{x='&/'x}
       cx:{x=\:|/x}
       minmax:{(rn x)&(cx x)}
       minmax x
    (0 0 0 0 0 0
    0 0 0 0 0 0
    0 0 0 0 0 0
    0 0 0 1 0 0
    0 0 0 0 0 0)
       ones:{&,/minmax x}
       ones x
    ,21
       (,/x)[ones[x]]
    ,14

    q)x:(5 4 6 4 12 5;16 2 4 5 16 18;8 18 7 12 16 11;20 17 16 14 16 20;16 8 12 9 17 13)
    q)rn:{x=' min each x}
    q)cx:{x=\:max x}
    q)minmax:{(rn x)&(cx x)}
    q)minmax x
    (000000b;000000b;000000b;000100b;000000b)
    q)ones:{where raze minmax x}
    q)ones x
    ,21
    q)(raze x)[ones[x]]
    ,14



## 264. Insert `x[i]` blanks after `y[g[i]]`

    b:(0,g)_ y
    b
    ("ab"
    "cd"
    "ef"
    ,"g")
    c:b,'(x,0)#\:" "
    c
    ("ab "
    "cd "
    "ef "
    ,"g")
    ,/c
    "ab cd ef g"
    ib:{[x;y;g],/((0,g)_ y),'(x,0)#\:" "}
    ib[x;y;g]
    "ab cd ef g"



## 265. Insert `x[i]` zeroes after i-th infix of `y`

       y:0 0 1 0 1 0 1 1
       x:1 2 2 1
       &y
    2 4 6 7
       a:@[&#y;&y;:;x]
       a
    0 0 1 0 2 0 2 1
       b:1+a
       b
    1 1 2 1 3 1 3 2
       d:(!(#y)++/x)
       d
    0 1 2 3 4 5 6 7 8 9 10 11 12 13
       d:(1_!(#y)++/x)
       d
    1 2 3 4 5 6 7 8 9 10 11 12 13 14
       d _lin c
    1 1 0 1 1 0 0 1 1 0 0 1 0 1



## 266. Remove trailing blanks

       x:" phrase 266 "
       a:~x=" "
       a
    0 0 1 1 1 1 1 1 0 1 1 1 0 0 0
       b:||\|a
       b
    1 1 1 1 1 1 1 1 1 1 1 1 0 0 0
       x[&b]
    " phrase 266"

    q)x:"  phrase 266   "
    q)a:not x=" "
    q)b:reverse maxs reverse a
    q)b
    111111111111000b
    q)x[where b]
    "  phrase 266"



## 267. Remove leading blanks

       x:" phrase 267 "
       a:~x=" "
       a
    0 0 1 1 1 1 1 1 0 1 1 1 0 0
       b:|\a
       b
    0 0 1 1 1 1 1 1 1 1 1 1 1 1
       x[&b]
    "phrase 267 "

    q)x[where b]
    "  phrase 266"
    q)x:"  phrase 266   "
    q)b:maxs a
    q)b
    001111111111111b
    q)x[where b]
    "phrase 266   "



## 268. Is `x` in ascending order

       x:2 5 7 9 6 8 3
       x~x[<x]
    0
       x:0 1 1 1 7 8 9
       x~x[<x]
    1

    q)x:2 5 7 9 6 8 3
    q)x~x[iasc x]
    0b
    q)x:0 1 1 1 7 8 9
    q)x~x[iasc x]
    1b



## 269. See 248



## 270. See 268



## 271. Slight variation of 264



## 272. See 266



## 273. Join scalar to each list item

       x:"a"
       y:"01234"
       x,/:y
    ("a0"
    "a1"
    "a2"
    "a3"
    "a4")
       x:("01234";"56789")
       y:("abcde";"fghij")
       x,y
    ("01234"
    "56789"
    "abcde"
    "fghij")
       x,'y
    ("01234abcde"
    "56789fghij")

    q)x:"a"
    q)y:"01234"
    q)x,/:y
    "a0"
    "a1"
    "a2"
    "a3"
    "a4"
    q)x:("01234";"56789")
    q)y:("abcde";"fghij")
    q)x,y
    "01234"
    "56789"
    "abcde"
    "fghij"
    q)x,'y
    "01234abcde"
    "56789fghij"



## 274. See 273



## 275. See 76



## 276. See 185



## 277. End indicators from lengths

       x:1 2 3 4 5
       +\x
    1 3 6 10 15
       -1++\x
    0 2 5 9 14
       +/x
    15
       @[&+/x;-1++\x;:;1]
    1 0 1 0 0 1 0 0 0 1 0 0 0 0 1

    q)x:1 2 3 4 5
    q)sums x
    1 3 6 10 15
    q)-1+sums x
    0 2 5 9 14
    q)sum x
    15
    q)@[(sum x)#0;-1+sums x;:;1]
    1 0 1 0 0 1 0 0 0 1 0 0 0 0 1



## 278. Start indicators from lengths

       x:1 2 3 4 5
       (!+/x) _lin\: +\0,x
    1 1 0 1 0 0 1 0 0 0 1 0 0 0 0

    q)x:1 2 3 4 5
    q)(til sum x) in\: sums 0,x
    110100100010000b



## 279. Variation of 265



## 280. See 41



## 281. Value of Taylor series with coefficients `y` at `x`

         x:12
       y:7 5 6 6
       1+!-1+#y
    1 2 3
       1.0,x%1+!-1+#y
    1 12 6 4.0
       *\1.0,x%1+!-1+#y
    1 12 72 288.0
       y**\1.0,x%1+!-1+#y
    7 60 432 1728.0
       +/y**\1.0,x%1+!-1+#y
    2227.0

    q)x:12
    q)y:7 5 6 6
    q)1+til -1+count y
    1 2 3
    q)1+til -1+count y
    1 2 3
    q)1.0,x%(1+til -1 +count y)
    1 12 6 4f
    q)prds 1.0,x%(1+til -1 +count y)
    1 12 72 288f
    q)y*prds 1.0,x%(1+til -1 +count y)
    7 60 432 1728f
    q)sum y*prds 1.0,x%(1+til -1 +count y)
    2227f



## 282. Index of first blank

       x:"ab c d"
       x?" "
    2
       x:("ab c d";" a bc";"abcd ")
       x
    ("ab c d"
    " a bc"
    "abcd ")
       x?\:" "
    2 0 4

    q)x:"ab c d"
    q)x?" "
    2
    q)x:("ab c d";" a bc";"abcd ")
    q)x
    "ab c d"
    " a bc"
    "abcd "
    q)x?\:" "
    2 0 4



## 283. Locate field `y` of fields beginning with first of `x`

       x:"abcabbbaccccaddd"
       y:2
       y=+\x=*x
    0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0
       x[&y=+\x=*x]
    "abbb"
       y:4
       x[&y=+\x=*x]
    "addd"

    q)x:"abcabbbaccccaddd"
    q)y:2
    q)y=sums x=first x
    0001111000000000b
    q)x[where y=sums x=first x]
    "abbb"
    q)y:4
    q)x[where y=sums x=first x]
    "addd"



## 284. Sum items of `x` marked by `y`

       x:1 2 3 4 5 6 7
       y:1 1 1 2 2 3 3
       =y
    (0 1 2
    3 4
    5 6)
       x[=y]
    (1 2 3
    4 5
    6 7)
       +/'x[=y]
    6 9 13
       y:1 2 1 3 3 2 1
       +/'x[=y]
    11 8 9

    q)x:1 2 3 4 5 6 7
    q)y:1 1 1 2 2 3 3
    q)group y
    1| 0 1 2
    2| 3 4
    3| 5 6
    q)x[group y]
    1| 1 2 3
    2| 4 5
    3| 6 7
    q)sum each x[group y]
    1| 6
    2| 9
    3| 13
    q)y:1 2 1 3 3 2 1
    q)sum each x[group y]
    1| 11
    2| 8
    3| 9
    q)value group y
    0 2 6
    1 5
    3 4
    q)value x[group y]
    1 3 7
    2 6
    4 5
    q)value sum each x[group y]
    11 8 9



## 285. Moving sum

       y:3
       x:1 2 3 4 5
       +\x
    1 3 6 10 15
       (-y)
    -3
       (-y)_ a:+\x
    1 3
       0,(-y)_ a
    0 1 3
       (y-1)_ a
    6 10 15
       ((y-1)_ a)-0,(-y)_ a
    6 9 12
       ms:{((y-1)_ a)-0,(-y)_ a:+\x}
       ms[x;y]
    6 9 12

    q)y:3
    q)x:1 2 3 4 5
    q)sums x
    1 3 6 10 15
    q)neg y
    -3
    q)neg y _ a:sums x
    -10 -15
    q)
    q)(neg y) _ a:sums x
    1 3
    q)0,(neg y)_a
    0 1 3
    q)(y-1)_a
    6 10 15
    q)((y-1)_a)-0,(neg y)_ a
    6 9 12
    q)ms:{((y-1)_a)-0,(neg y)_ a:sums x}
    q)ms[x;y]
    6 9 12



## 286. FIFO stock `y` decremented with `x` units

       x:5
       y:1 2 3 4 5
       (+\y)-x
    -4 -2 1 5 10
       g:0|(+\y)-x
       g
    0 0 1 5 10
       -':0,g
    0 0 1 4 5
       ff:{-':0,0|(+\y)-x}
       ff[x;y]
    0 0 1 4 5

    q)(sums y)
    1 3 6 10 15
    q)(sums y)-x
    -4 -2 1 5 10
    q)g:0|(sums y)-x
    q)g
    0 0 1 5 10
    q)deltas 0,g
    0 0 0 1 4 5
    q)1_ deltas 0,g
    0 0 1 4 5
    q)ff:{1_deltas 0,0|(sums y)-x}
    q)ff[x;y]
    0 0 1 4 5



## 289. Or-scan of infixes of `y` indicated by `x`

       y:1 0 0 1 0 1 0 0
       x:1 0 1 0 0 0 1 0
       a:&x
       b:a _ y
       b
    (1 0
    0 1 0 1
    0 0)
       c:|\'b
       c
    (1 1
    0 1 1 1
    0 0)
       ,/c
    1 1 0 1 1 1 0 0

    q)y:1 0 0 1 0 1 0 0
    q)x:1 0 1 0 0 0 1 0
    q)a:where x
    q)a
    0 2 6
    q)b:a _ y
    q)b
    1 0
    0 1 0 1
    0 0
    q)c:max each b
    q)c
    1 1 0
    q)c:maxs each b
    q)c
    1 1
    0 1 1 1
    0 0
    q)raze c
    1 1 0 1 1 1 0 0



## 290. And-scan of infixes of `y` indicated by `x`

       y:1 0 0 1 0 1 0 0
       x:1 0 1 0 0 0 1 0
       a:&x
       b:a _ y
       b
    (1 0
    0 1 0 1
    0 0)
       c:&\'b
       c
    (1 0
    0 0 0 0
    0 0)
       ,/c
    1 0 0 0 0 0 0 0

    q)y:1 0 0 1 0 1 0 0
    q)x:1 0 1 0 0 0 1 0
    q)a:where x
    q)b:a _ y
    q)b
    1 0
    0 1 0 1
    0 0
    q)c:mins each b
    q)c
    1 0
    0 0 0 0
    0 0
    q)raze c
    1 0 0 0 0 0 0 0



## 291. Sums of infixes of `y` indicated by `x`

       y:1 2 3 4 5
       x:1 0 1 0 1
       a:&x
       b:a _ y
       b
    (1 2
    3 4
    ,5)
       c:+/'b
       c
    3 7 5

    q)y:1 2 3 4 5
    q)x:1 0 1 0 1
    q)a:where x
    q)b:a _ y
    q)b
    1 2
    3 4
    ,5
    q)c:sum each b
    q)c
    3 7 5



## 292. Groups of 1s in `y` pointed to by `x`

       y:1 1 1 0 0 1 1
       x:0 1 0 1 0 0 0
       -1 _ 0,y
    0 1 1 1 0 0 1
       +\y>-1 _ 0,y
    1 1 1 1 1 2 2
       x&y
    0 1 0 0 0 0 0
       a:+\y>-1 _ 0,y
       a
    1 1 1 1 1 2 2
       a[&x&y]
    ,1
       a _lin ,1
    1 1 1 1 1 0 0
       y&a _lin ,1
    1 1 1 0 0 0 0
       go:{y&a _lin(a:+\y>-1 _ 0,y)[&x&y]}
       go[x;y]
    1 1 1 0 0 0 0

    q)y:1 1 1 0 0 1 1
    q)x:0 1 0 1 0 0 0
    q)-1 _ 0,y
    0 1 1 1 0 0 1
    q)sums y > -1 _ 0,y
    1 1 1 1 1 2 2
    q)y > -1 _ 0,y
    1000010b
    q)x&y
    0 1 0 0 0 0 0
    q)a:sums y > -1 _ 0,y
    q)a
    1 1 1 1 1 2 2
    q)a[where x&y]
    ,1



## 293. Locate quotes and text between them

       x:"abc\"de\"f"
       #x
    8
       a:x="\""
       a
    0 0 0 1 0 0 1 0
       b:&a
       b
    3 6
       c:(*b)+!1+--/b
       c
    3 4 5 6
       @[&#x;c;:;1]
    0 0 0 1 1 1 1 0

    q)x:"abc\"de\"f"
    q)count x
    8
    q)a:x="\""
    q)a
    00010010b
    q)b:where a
    q)b
    3 6
    q)c:(first b)+til 1+ neg -/[b]
    q)c
    3 4 5 6
    q)@[(count x)#0;c;:;1]
    0 0 0 1 1 1 1 0



## 294. Locate text between quotes

       x:"abc\"de\"f"
       #x
    8
       a:x="\""
       a
    0 0 0 1 0 0 1 0
       b:&a
       b
    3 6
       c:b+1 -1
       c
    4 5
       d:(*c)+!1+--/c
       d
    4 5
       @[&#x;d;:;1]
    0 0 0 0 1 1 0 0 c

    q)x:"abc\"de\"f"
    q)count x
    8
    q)a:x="\""
    q)a
    00010010b
    q)b:where a
    q)b
    3 6
    q)c:b+1 -1
    q)c
    4 5
    q)d:(first c)+til 1+neg -/[c]
    q)d
    4 5
    q)@[(count x)#0;d;:;1]
    0 0 0 0 1 1 0 0



## 295. Depth of parentheses

       x:"a(b((c)de)f)g(h)"
       dp:{+\("("=x)--1 _ 0,")"=x}
       dp x
    0 1 1 2 3 3 3 2 2 2 1 1 0 1 1 1
       x:"a(b((cde)f)g(ki)"
       dp x
    0 1 1 2 3 3 3 3 3 2 2 1 2 2 2 2
       x:"ab((c)de)f)g(ki)"
       dp x
    0 0 1 2 2 2 1 1 1 0 0 -1 0 0 0 0
       x:"a(b((c)de)f)g(h)"
       dp x
    0 1 1 2 3 3 3 2 2 2 1 1 0 1 1 1

    q)x:"a(b((c)de)f)g(h)"
    q)dp:{sums ("("=x)- -1_ 0,")"=x}
    q)dp x
    0 1 1 2 3 3 3 2 2 2 1 1 0 1 1 1
    q)x:"a(b((cde)f)g(ki)"
    q)dp x
    0 1 1 2 3 3 3 3 3 2 2 1 2 2 2 2
    q)x:"ab((c)de)f)g(ki)"
    q)dp x
    0 0 1 2 2 2 1 1 1 0 0 -1 0 0 0 0
    q)x:"a(b((c)de)f)g(h)"
    q)dp x
    0 1 1 2 3 3 3 2 2 2 1 1 0 1 1 1



## 296. Starting positions of infixes from lengths `x`

       x:2 3 1 5
       +\-1 _ 0,x
    0 2 5 6
       sl:{+\-1 _ 0,x}
       sl[x]
    0 2 5 6

    q)x:2 3 1 5
    q)sums -1 _0,x
    0 2 5 6
    q)sl:{sums -1 _ 0,x}
    q)sl x
    0 2 5 6



## 297. Spread marked field heads right

       x:"abcdef"
       y:1 1 0 0 1 0
       a:&y
       a
    0 1 4
       b:#:'a _ x
       b
    1 3 2
       c:b#'a
       c
    (,0
    1 1 1
    4 4)
       d:,/c
       d
    0 1 1 1 4 4
       x[d]
    "abbbee"
       x[,/(#:'a _ x)#'a:&y]
    "abbbee"
       sh:{x[,/(#:'a _ x)#'a:&y]}
       sh[x;y]
    "abbbee"

    q)x:"abcdef"
    q)y:1 1 0 0 1 0
    q)a:where y
    q)a
    0 1 4
    q)a _ x
    ,"a"
    "bcd"
    "ef"
    q)count a _ x
    3
    q)count each a _ x
    1 3 2
    q)
    q)b:count each a _ x
    q)c:b#'a
    q)c
    ,0
    1 1 1
    4 4
    q)d:raze c
    q)d
    0 1 1 1 4 4
    q)x[d]
    "abbbee"
    q)x[raze(count each a _ x)$'a:where y]
    'type
    q)x[raze(count each a _ x)#'a:where y]
    "abbbee"
    q)sh:{x[raze(count each a _ x)#'a:where y]}
    q)sh[x;y]
    "abbbee"



## 298. See 266



## 299. See 267



## 300. Gth infix of `y` marked by `x`

       x:1 0 0 1 0 1 0 0 0 1 0
       y:"abcdefghijk"
       g:2
       a:&x
       a
    0 3 5 9
       b:a _ x
       b
    ("abc"
    "de"
    "fghi"
    "jk")
    b[g]
    "fghi"
    ((&x)_ y)[g]
    "fghi"

    q)x:1 0 0 1 0 1 0 0 0 1 0
    q)y:"abcdefghijk"
    q)a:where x
    q)a
    0 3 5 9
    q)b:a _ y   /original says x but must be y
    q)b
    "abc"
    "de"
    "fghi"
    "jk"
    q)b 2
    "fghi"
    q)((where x)_ y)[g]
    "fghi"



## 301. Alternating sum series

       x:1+!10
       x
    1 2 3 4 5 6 7 8 9 10
       a:((#x)#1 -1)
       a
    1 -1 1 -1 1 -1 1 -1 1 -1
       b:x*a
       +\b
    1 -1 2 -2 3 -3 4 -4 5 -5
       as:{+\x*(#x)#1 -1}
       as[x]
    1 -1 2 -2 3 -3 4 -4 5 -5

    q)x:1+til 10
    q)x
    1 2 3 4 5 6 7 8 9 10
    q)a:((count x)#1 -1)
    q)a
    1 -1 1 -1 1 -1 1 -1 1 -1
    q)b:x*a
    q)b
    1 -2 3 -4 5 -6 7 -8 9 -10
    q)sums b
    1 -1 2 -2 3 -3 4 -4 5 -5
    q)as:{sums x*(count x)#1 -1}
    q)as[x]
    1 -1 2 -2 3 -3 4 -4 5 -5



## 302. `x` first triangular numbers

       x:6
       +\!x
    0 1 3 6 10 15

    q)x:6
    q)sums til x
    0 1 3 6 10 15



## 303. Smearing 1s between pairs of 1s

       x:0 1 0 0 1 0 1 0 1 0 1 1 0
       a:(+\x)!2
       a
    1 1 1 0 0 0 0 1 1 0 0
       x|a
    1 1 1 1 0 0 0 1 1 1 0
       x|(+\x)!2
    1 1 1 1 0 0 0 1 1 1 0

    q)x:0 1 0 0 1 0 1 0 1 0 1 1 0
    q)a:(sums x)mod 2
    q)a
    0 1 1 1 0 0 1 1 0 0 1 0 0
    q)x or a
    0 1 1 1 1 0 1 1 1 0 1 1 0
    q)x|a
    0 1 1 1 1 0 1 1 1 0 1 1 0
    q)x|(sums x)mod 2
    0 1 1 1 1 0 1 1 1 0 1 1 0



## 304. Invert 0s following 1st 1

       x:0 0 1 0 0 1 1
       |\x
    0 0 1 1 1 1 1

    q)x:0 0 1 0 0 1 1
    q)maxs x
    0 0 1 1 1 1 1



## 305. Invert fields marked by pairs of 1s

       x:1 0 1 0 0 1 0 0 1
       a:(+\x)!2
       a
    1 1 0 0 0 1 1 1 0
       ~x
    0 1 0 1 1 0 1 1 0
       (~x)&a
    0 1 0 0 0 0 1 1 0
       (~x)&(+\x)!2
    0 1 0 0 0 0 1 1 0

    q)x:1 0 1 0 0 1 0 0 1
    q)a:(sums x)mod 2
    q)a
    1 1 0 0 0 1 1 1 0
    q)not x
    010110110b
    q)(not x)&a
    0 1 0 0 0 0 1 1 0
    q)(not x)&(sums x)mod 2
    0 1 0 0 0 0 1 1 0



## 306. Invert all 1s after 1st 0

       x:1 1 0 1 0 1 0
       &\x
    1 1 0 0 0 0 0

    q)x:1 1 0 1 0 1 0
    q)mins x
    1 1 0 0 0 0 0



## 307. Invert all 1s after 1st 1
```k
   x:0 0 1 1 0 1
   &#x
0 0 0 0 0 0
   x?1
2
@[&#x;x?1;:;1]
0 0 1 0 0 0
```
```q
q)x:0 0 1 1 0 1 
q)(count x)\#x 0 0 1 1 0 1 
q)(count x)\#0 0 0 0 0 0 0 
q)x?1 2 q)@\[(count x)\#0;x?1;:;1\] 0 0 1 0 0 0 
```


## 308. Invert all 0s after 1st 0

       x:1 0 0 1 1 0
       a:x?0
       a
    1
       !#x
    0 1 2 3 4 5
       b:(a+1)_!#x
       b
    2 3 4 5
       @[x;b;:;1]
    1 0 1 1 1 1
       @[x;(1+x?0)_!#x;:;1]
    1 0 1 1 1 1

    q)x:1 0 0 1 1 0
    q)a:x?0
    q)a
    1
    q)til count x
    0 1 2 3 4 5
    q)b:(a+1)_til count x
    q)b
    2 3 4 5
    q)@[x;b;:;1]
    1 0 1 1 1 1
    q)@[x;(1+x?0)_til count x;:;1]
    1 0 1 1 1 1



## 309. Running parity

       x:0 1 1 1 1 0 1 0 0
       (+\x)!2
    0 1 0 1 0 0 1 1 1

    q)x:0 1 1 1 1 0 1 0 0
    q)(sums x)mod 2
    0 1 0 1 0 0 1 1 1



## 310. Running sum

       x:1 20 300 4000
    +\x
    1 21 321 4321

    q)sums x
    1 21 321 4321



## 311. See 159



## 312. Maximum separation of items of `x`

       x:10+7 _draw 9
       x
    17 14 14 17 14 17 18
       (|/x)-(&/x)
    4

    q)x:17 14 14 17 14 17 18
    q)(max x)-min x
    4



## 313. Value of two-by-two determinant

       det: {-/y*|x}
       x:(13 21;34 55)
       x
    (13 21
    34 55)
       (13 * 55) - (34 * 21)
    1
       13 21 * 55 34
    715 714
       -/13 21 * 55 34
    1
       det x
    ,1

    q)det:{-/[x[0]*reverse x[1]]}



## 314. See 313



## 315. See 159



## 316. See 159



## 317. See 159



## 318. Area of triangle with sides `x` (Heron's rule)

       x:3 4 5
       hr:{(*/(+/x%2)-0,x)^0.5}
       hr[x]
    6.0

    q)hr:{sqrt (prd (sum x%2)-0,x)}
    q)hr x
    6f



## 319. Standard deviation

       x:44 77 48 24 28 36 17 49 90 91
    std:{((+/(x-(+/x)%#x)^2)%#x)^0.5}
    std[x]
    25.48411

    q)std:{mean:sum x%count x; sqr:{x*x}; sqrt sum sqr[x-mean]%count x}
    q)std x
    25.48411



## 320. Variance (dispersion)

       x:44 77 48 24 28 36 17 49 90 91.0
       var:{(+/(x-(+/x)%#x)^2)%#x}
       var[x]
    649.44
    (var[x])^0.5
    25.48411

    q)x:44 77 48 24 28 36 17 49 90 91.0
    q)var x
    649.44
    q)var
    k){avg[x*x]-a*a:avg x:"f"$x}
    q)varr:{mean:sum x%count x; sqr:{x*x}; sum sqr[x-mean]%count x}
    q)varr x
    649.44



## 321. `y`-th moment of `x`

       x:44 77 48 24 28 36 17 49
       ym:{(+/(x-(+/x)%#x)^y)%#x}
       ym[x;2]
    309.23
       ym[x;0]
    1.0
       ym[x;1]
    4.4409e-016
       ym[x;3]
    3889.9

    q)x:44 77 48 24 28 36 17 49
    q)ym:{(sum(x-sum x%count x)xexp y)%count x}
    q)ym[x;2]
    309.2344
    q)ym[x;0]
    1f
    q)ym[x;1]
    4.440892e-16
    q)ym[x;3]
    3889.934



## 322.



## 323. See 248



## 324. See 159



## 325. Average (mean)

       av:{(+/x)%#x}
       av[1 10 100]
    37.0

    q)av:{(sum x)%count x}
    q)av[1 10 100]
    37f



## 326. See 325



## 327. See 70



## 328. Number of items

       #"abcd"
    4
       #(1;2 3;4 5 6)
    3
       #2 3 4#!24
    2

    q)count "abcd"
    4
    q)count(1;2 3;4 5 6)
    3
    q)count 2 3 4#til 24
    'length



## 329. Mask from positive integers in x`

       x:-5+7 _draw 10
       x
    2 3 3 -2 4 4 -1
       (!1+|/x) _lin x
    0 0 1 1 1

    q)x:2 3 3 -2 4 4 -1
    q)(til 1+max x) in x
    00111b



## 330. Index of 1st occurrence of maximum item of `x`

       x:5 3 7 0 5 7 2
       x?|/x
    2

    q)x:5 3 7 0 5 7 2
    q)x?max x
    2



## 331. Identity for floating point maximum, negative infinity `-0i`

    -1e100|-0i
    -1e+100
    identity for integer maximum, negative infinity -0I
    -123456789|-0I

    q)-1e100|-0w
    -1e+100
    q)-1e100|-0W
    -2.147484e+09
    q)-123456789|-0w
    -1.234568e+08
    q)-123456789|-0W
    -123456789



## 332. See 326



## 333. Quick membership for non-negative integers

       x:5 3 7 2
       y:8 5 2 6 1 9
       &1+|/x,y
    0 0 0 0 0 0 0 0 0 0
       a:&1+|/x,y
       @[a;y;:;1]
    0 1 1 0 0 1 1 0 1 1
       (@[a;y;:;1])[x]
    1 0 0 1
       @[&1+|/x,y;y;:;1][x]
    1 0 0 1

    q)x:5 3 7 2
    q)y:8 5 2 6 1 9
    q)max x,y
    9
    q)(1+max x,y)#0
    0 0 0 0 0 0 0 0 0 0
    q)a:(1+max x,y)#0
    q)a
    0 0 0 0 0 0 0 0 0 0
    q)@[a;y;:;1]
    0 1 1 0 0 1 1 0 1 1
    q)(@[a;y;:;1])[x]
    1 0 0 1
    q)@[(1+max x,y)#0;y;:;1][x]
    1 0 0 1



## 334. Non-negative maximum

       x:1 2 3 4 5
       |/x,0
    5
       x:-1 -2 -3 -4 -5
       |/x,0
    0
       x:!0
       x
       !0
       |/x,0
    0

    q)x:0n
    q)max x,0
    0f
    /XXX doublecheck



## 335. Maximum

       x:5 3 7 2
       |/x
    7

    q)max x
    7



## 336. Index of first occurrence of minimum

       x:5 3 7 2 5 3
       x?&/x
    3

    q)x?min x
    3



## 337. Identity for floating point minimum, positive infinity `0i`

       1e100&0i
    1e+100
    identity for integer minimum, positive infinity 0I
       123456789&0I
    123456789

    q)1e100&0w
    1e+100
    q)1e100&0W
    2.147484e+09
    q)123456789&0w
    1.234568e+08
    q)123456789&0W
    123456789



## 338. Locate first occurrence in `x` of an item of `y`

       x:"abcdef"
       y:"dbf"
       &/x?/:y
    1
       x[1]
    "b"

    q)x:"abcdef"
    q)y:"dbf"
    q)min x?/:y
    1
    q)x[1]
    "b"



## 339. Minimum

       x:5 3 7 2
       &/x
    2

    q)min x
    2



## 340. See 159



## 341. See 159



## 342. Arabic from Roman number

       x:"MCMIX"
       "MDCLXVI"?/:x
    0 2 0 6 4
       a:0,1000 500 100 50 10 5 1["MDCLXVI"?/:x]
       a
    0 1000 100 1000 1 10
       a<1!a
    1 0 1 0 1 0
       _ a*-1^a<1!a
    0 1000 -100 1000 -1 10
       +/_ a*-1^a<1!a
    1909
       ar:{+/_ a*-1^a<1!a:0,1000 500 100 50 10 5 1["MDCLXVI"?/:x]}
       ar[x]
    1909

    q)x:"MCMIX"
    q)"MDCLXVI"?/:x
    0 2 0 6 4
    q)a:0,1000 500 100 50 10 5 1["MDCLXVI"?/:x]
    q)a
    0 1000 100 1000 1 10
    q)a<1 rotate a
    101010b
    q)floor a*-1 xexp a<1 rotate a
    0 1000 -100 1000 -1 10
    q)sum floor a*-1 xexp a<1 rotate a
    1909
    q)ar:{sum floor a*-1 xexp a<1 rotate a:0,1000 500 100 50 10 5 1["MDCLXVI"?/:x]}
    q)ar[x]
    1909



## 343. See 159



## 344. Pairwise match

        x:("123";"123";"45";"45")
       x
    ("123"
    "123"
    "45"
    "45")
       ~':x
    1 0 1
       (~':x),0
    1 0 1 0
       pm:{(~':x),0}
       pm 1 1 1 1 2 2 3 4 4 4
    1 1 1 0 1 0 0 1 1 0

    q)x:("123";"123";"45";"45")
    q)x
    "123"
    "123"
    "45"
    "45"
    q)~':[x]
    0101b
    q)~':[x],0b
    01010b
    q)(~':[x]),0b
    01010b
    q)k)(~':[x]),0b
    01010b
    q)pm:{1 _ (~':[x]),0b}
    q)pm 1 1 1 1 2 2 3 4 4 4
    1110100110b
    /each prior is different in k4/q?



## 345. Do ranges of `x` and `y` match

       x:1 2 3
       y:3 2 1 1
    a:?x
       x
    1 2 3
       a
    1 2 3
       b:?y
       b
    3 2 1
       a[<a]~b[<b]
    1
       om:{x[<x]~y[<y]}
       om[?x;?y]
    1
       om[?"bca";?"cabba"]
    1



## 346. See 20



## 347. See 159



## 348. Do `x` and `y` have items in common

       x:"aba"
       y:"cdeac"
       x _lin\: y
    1 0 1
       |/x _lin\: y
    1
       y:"edge"
       |/x _lin\: y
    0

    q)x:"aba"
    q)y:"cdeac"
    q)x in\:y
    101b
    q)max x in\:y
    1b
    q)y:"edge"
    q)max x in\:y
    0b



## 349. See 159'



## 350. Is `x` 1s and 0s only (Boolean)

       x:0 1 0 1
       &/x _lin\:0 1
    1
       x:1 1 1 1
       &/x _lin\:0 1
    1
       x:1 0 1 2
       &/x _lin\:0 1
    0

    q)x:0 1 0 1
    q)min x in\:0 1
    1b
    q)x:1 1 1 1
    q)min x in\:0 1
    1b
    q)x:1 0 1 2
    q)min x in\:0 1
    0b



## 351. Is `x` a subset of `y`

       x:"abgk"
       y:"abcdefghijkl"
       &/x _lin\:y
    1
       x:"abgx"
       &/x _lin\:y
    0

    q)x:"abgk"
    q)y:"abcdefghijkl"
    q)min x in\:y
    1b
    q)x:"abgx"
    q)min x in\:y
    0b



## 352. See 159



## 353. Are items unique

         x:"abcdefg"
       (#x)=(#?x)
    1
       x:"abcdefa"
       (#x)=(#?x)
    0

    q)x:"abcdefg"
    q)(count x)=(count distinct x)
    1b
    q)x:"abcdefa"
    q)(count x)=(count distinct x)
    0b



## 354. See 159



## 355. None

       x:&7
       x
    0 0 0 0 0 0 0
       ~|/x
    1
       x:7#0 1
       x
    0 1 0 1 0 1 0
       ~|/x
    0

    q)x:7#0
    q)not max x
    1b
    q)x:7#0 1
    q)x
    0 1 0 1 0 1 0
    q)not max x
    0b



## 356. Any

       x:&7
       |/x
    0
       x:7#0 1
       |/x
    1

    q)x:7#0
    q)max x
    0
    q)any x
    0
    q)x:7#0 1
    q)max x
    1
    q)any x
    1



## 357. Does `x` match `y`

       x:("abc";`sy;1 3 -7)
       y:("abc";`sy;1 3 -7)
       x~y
    1
       x:1 2 3
       y:1 4 3
       x~y
    0

    q)x:("abc";`sy;1 3 -7)
    q)y:("abc";`sy;1 3 -7)
    q)x~y
    1b
    q)x:1 2 3
    q)y:1 4 3
    q)x~y
    0b



## 358. See 159



## 359. Locate blank rows

       x:+5 6#"a bc d"
       x
    ("aaaaa"
    " "
    "bbbbb"
    "ccccc"
    " "
    "ddddd")
       x~\:(#+x)#" "
    0 1 0 0 1 0

    q)x:flip 5 6#"a bc d"
    q)x
    "aaaaa"
    "     "
    "bbbbb"
    "ccccc"
    "     "
    "ddddd"
    q)x~\:(count flip x)#" "
    010010b



## 360. All

       x:1 1 0 1
       &/x
    0
       x:1 1 1 1
       &/x
    1
       x:0 0 0 0
       &/x
    0

    q)x:1 1 0 1
    q)min x
    0
    q)all x
    0
    q)x:1 1 1 1
    q)min x
    1
    q)all x
    1
    q)x:0 0 0 0
    q)min x
    0
    a)all x
    0



## 361. Parity

       x:2 _vs !8
       x
    (0 0 0 0 1 1 1 1
    0 0 1 1 0 0 1 1
    0 1 0 1 0 1 0 1)
       (+/x)!2
    0 1 1 0 1 0 0 1



## 362. Count of occurrences of `x` in `y`

         x:"q"
       y:"quaquaqua"
       +/x=y
    3

    q)x:"q"
    q)y:"quaquaqua"
    q)sum x=y
    3



## 363. Solve quadratic

       qu:{(q%x),(z%q:qq[x;y;z])}
       qq:{-0.5*y+sg[y]*ds[x;y;z]}
       ds:{_sqrt[(y*y)-(4*x*z)]}
       sg:{(x>0)-(x<0)}
       a:1
       b:-1e30
       c:1
       sg[b]
    -1
       ds[a;b;c]
    1e+030
       qq[a;b;c]
    1e+030
       qu[a;b;c]
    1e+030 1e-030
       qu[1;-8;15]
    5 3.0

    q)qu:{(q%x),(z%q:qq[x;y;z])}
    q)qq:{-0.5*y+sg[y]*ds[x;y;z]}
    q)ds:{sqrt[(y*y)-(4*x*z)]}
    q)sg:{(x>0)-(x<0)}   /or use the builtin signum
    q)a:1
    q)b:-1e30
    q)c:1
    q)sg[b]
    -1
    q)ds[a;b;c]
    1e+30
    q)qq[a;b;c]
    1e+30
    q)qu[a;b;c]
    1e+30 1e-30
    q)qu[1;-8;15]
    5 3f



## 364. See 325



## 365. See 325



## 366. Count of scalars

       cs:{#,//x}
       cs[1]
    1
       cs[1 2]
    2
       cs[(1 2;3 4 5)]
    5
       cs[(1 2;(3 4;5))]
    5
       cs[("ab";("cd";"efg"))]
    7
       cs[!0]
    0

    q)cs:{count raze over x}
    q)cs 1
    1
    q)cs[1 2]
    2
    q)cs[(1 2;3 4 5)]
    5
    q)cs[(1 2;(3 4;5))]
    5
    q)cs[("ab";("cd";"efg"))]
    7
    q)cs[til 0]
    0



## 367. Alternating product

       x:1 2 3 4 5
       a:(#x)#1 -1
       a
    1 -1 1 -1 1
       */x^a
    1.875

    q)x:1 2 3 4 5
    q)a:(count x)#1 -1
    q)a
    1 -1 1 -1 1
    q)prd xexp[x;a]
    1.875
    q)xexp[x;a]
    1 0.5 3 0.25 5



## 368. Product

       x:1 2 3 4 5
       */x
    120

    q)x:1 2 3 4 5
    q)prd x
    120



## 369. Alternating sum

       x:1+!10
       x
    1 2 3 4 5 6 7 8 9 10
       a:((#x)#1 -1)
       a
    1 -1 1 -1 1 -1 1 -1 1 -1
       b:x*a
       +/b
    -5
       +/x*(#x)#1 -1
    -5

    q)x:1+til 10
    q)x
    1 2 3 4 5 6 7 8 9 10
    q)a:((count x)#1 -1)
    q)b:x*a
    q)sum b
    -5
    q)sum x*(count x)#1 -1
    -5



## 370. Count of 1s in Boolean list

       x:1 0 0 1 0 1 1
       +/x
    4

    q)x:1 0 0 1 0 1 1
    q)sum x
    4



## 371. Scalar from 1-item list

       x:,5
       x
    ,5
       +/x
    5
       a:,"a"
       a
    ,"a"
       +/a
    type error
       +/a
    > \
       a[0]
    "a"

    q)x:enlist 5
    q)x
    ,5
    q)sum x
    5
    q)a:enlist "a"
    q)a
    ,"a"
    q)sum a
    'type
    q)a[0]
    "a"



## 372. Sum columns of matrix

       x:1+3 4# !12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       +/x
    15 18 21 24

    q)x:1+3 4#til 12
    q)x
    1 2  3  4
    5 6  7  8
    9 10 11 12
    q)sum x
    15 18 21 24



## 373. Sum rows of matrix

       x:1+3 4# !12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       +/'x
    10 26 42

    q)x:1+3 4#til 12
    q)x
    1 2  3  4
    5 6  7  8
    9 10 11 12
    q)sum each x
    10 26 42



## 374. Sum

       x:1 2 3 4 5
       +/x
    15

    q)x:1 2 3 4 5
    q)sum x
    15



## 375. Insert row `x` in matrix `y` after row `g`

       y:4 3#1+!12
       y
    (1 2 3
    4 5 6
    7 8 9
    10 11 12)
       x:13 14 15
       g:2
       a:y,,x
       a
    (1 2 3
    4 5 6
    7 8 9
    10 11 12
    13 14 15)
       b:<(!#y),g
       b
    0 1 2 4 3
       a[b]
    (1 2 3
    4 5 6
    7 8 9
    13 14 15
    10 11 12)
       (y,,x)[<(!#y),g]
    (1 2 3
    4 5 6
    7 8 9
    13 14 15
    10 11 12)

    q)y:4 3#1+til 12
    q)y
    1  2  3
    4  5  6
    7  8  9
    10 11 12
    q)x:13 14 15
    q)g:2
    q)a:y,enlist x
    q)a
    1  2  3
    4  5  6
    7  8  9
    10 11 12
    13 14 15
    q)b:iasc(til count y),g
    q)b
    0 1 2 4 3
    q)a[b]
    1  2  3
    4  5  6
    7  8  9
    13 14 15
    10 11 12
    q)(y,enlist x)[iasc(til count y),g]
    1  2  3
    4  5  6
    7  8  9
    13 14 15
    10 11 12



## 376. Append `y` at the bottom of matrix `x`

       x:4 3#1+!12
       x
    (1 2 3
    4 5 6
    7 8 9
    10 11 12)
       y:13 14 15
       x,,y
    (1 2 3
    4 5 6
    7 8 9
    10 11 12
    13 14 15)

    q)x:4 3#1+til 12
    q)x
    1  2  3
    4  5  6
    7  8  9
    10 11 12

    q)y:13 14 15
    q)x,enlist y
    1  2  3
    4  5  6
    7  8  9
    10 11 12
    13 14 15



## 377. Fill `x` to length `y` with `x`’s last item

       x:"quiz"
       y:9
       a:(!y)&-1+#x
       a
    0 1 2 3 3 3 3 3 3
       x[a]
    "quizzzzzz"
       x[(!y)&-1+#x]
    "quizzzzzz"
    or, an alternative way:
       y#x,y#*|x
    "quizzzzzz"

    q)x:"quiz"
    q)y:9
    q)a:(til y)&-1+count x
    q)a
    0 1 2 3 3 3 3 3 3
    q)x[a]
    "quizzzzzz"
    q)x[(til y)&-1+count x]
    "quizzzzzz"
    q)y#x,y#last  x
    "quizzzzzz"


## 378. \[omitted\]



## 379. Remove leading, multiple and trailing `y`s from `x`

       x:0 0 1 2 0 0 3 4 0 5 0 0 0
       y:0
       a:x=y
       b:~a&1!a
       a
    1 1 0 0 1 1 0 0 1 0 1 1 1
       b
    0 1 1 1 0 1 1 1 1 1 0 0 0
       x[&b]
    0 1 2 0 3 4 0 5
       a[0]_ x[&b]
    1 2 0 3 4 0 5

    q)x:0 0 1 2 0 0 3 4 0 5 0 0 0
    q)y:0
    q)a:x=y
    q)b:not a&1 rotate a
    q)b
    0111011111000b
    q)a
    1100110010111b
    q)x[where b]
    0 1 2 0 3 4 0 5
    q)a[0]_ x[where b]
    1 2 0 3 4 0 5



## 380. Change items of `x` with value `y[0]` to `y[1]`

       x:"abcde"[15 _draw 5]
       x
    "ddaeecadbbcbedc"
       y:"d "
       @[x;&x=*y;:;*|y]
    " aeeca bbcbe c"

    q)x:"ddaeecadbbcbedc"
    q)y:"d "
    q)@[x;where x=first y;:;last y]
    "  aeeca bbcbe c"



## 381. Invert all but 1st 1 in group of 1s

       x:0 0 1 1 1 0 1 1 0 1
       x>-1 _ 0,x
    0 0 1 0 0 0 1 0 0 1
       m381:{x>-1 _ 0,x}
       m381[x]
    0 0 1 0 0 0 1 0 0 1

    q)x:"ddaeecadbbcbedc"
    q)y:x:0 0 1 1 1 0 1 1 0 1
    q)x
    0 0 1 1 1 0 1 1 0 1
    q)x>-1 _ 0,x
    0010001001b
    q)m381:{x>-1 _ 0,x}
    q)m381[x]
    0010001001b



## 382. Insert `y` in `x` after index `g`

       x:1 2 3
       y:10*1+!7
       y
    10 20 30 40 50 60 70
       g:3
       ((g+1)#y),x,(g+1)_ y
    10 20 30 40 1 2 3 50 60 70

    q)x:1 2 3
    q)y:10*1+til 7
    q)y
    10 20 30 40 50 60 70
    q)g:3
    q)((g+1)#y),x,(g+1)_ y
    10 20 30 40 1 2 3 50 60 70



## 383. Pairwise difference

       x:9 3 5 2 0
       --':x
    6 -2 3 2

    q)deltas x
    9 -6 2 -3 -2
    q)1_ deltas x
    -6 2 -3 -2
    q)1_ neg deltas x
    6 -2 3 2



## 384. Drop 1st, postpend 0

       x:3 4 5 6
       1 _ x,0
    4 5 6 0

    q)x:3 4 5 6
    q)1_ x,0
    4 5 6 0



## 385. Drop last, prepend 0

       x:3 4 5 6
       -1 _ 0,x
    0 3 4 5

    q)x:3 4 5 6
    q)-1 _ 0,x
    0 3 4 5



## 386. Shift `x` right `y`, fill 0

       x:1+!12
       x
    1 2 3 4 5 6 7 8 9 10 11 12
       y:3
       @[(-y)!x;!y;:;0]
    0 0 0 1 2 3 4 5 6 7 8 9

    q)x:1+til 12
    q)y:3
    q)@[(neg y) mod  x; til y;:;0]
    0 0 0 1 2 3 4 5 6 7 8 9



## 387. Shift `x` left y, fill 0

       x:1+!12
       x
    1 2 3 4 5 6 7 8 9 10 11 12
       y:3
       @[y!x;((#x)-y)+!y;:;0]
    4 5 6 7 8 9 10 11 12 0 0 0

    q)x:1+til 12
    q)y:3
    q)@[y rotate x;((count x)-y)+til y;:;0]
    4 5 6 7 8 9 10 11 12 0 0 0



## 388. Drop `y` rows from top of matrix `x`

       x:6 3# !18
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11
    12 13 14
    15 16 17)
       y:2
       y _ x
    (6 7 8
    9 10 11
    12 13 14
    15 16 17)

    q)x:6 3#til 18
    q)x
    0  1  2
    3  4  5
    6  7  8
    9  10 11
    12 13 14
    15 16 17
    q)y:2
    q)y _ x
    6  7  8
    9  10 11
    12 13 14
    15 16 17



## 389. Playing order of `x` ranked players

       i:{1+2_sv'+|tt[-_-log2[x]]}
       j:{@[x;&x>y;:;0]}
       k:{j[i[x];x]}
       x:6
       i[x]
    1 5 3 7 2 6 4 8
       j[i[x];x]
    1 5 3 0 2 6 4 0
       k[x]
    1 5 3 0 2 6 4 0



## 390. Conform table `x` rows to list `y`

       f390:{@[((1 0*+/^y)|^x)#0;!#x;:;x]}
       x:3 3#1+!9
       y:1 2 3 4
       f390[x;y]
    (1 2 3
    4 5 6
    7 8 9
    0 0 0)



## 391. Conform table `y` columns to list `y`

       x:4 2 # 9
       y:5#8
       a:((0 1*+/^y)|^x)#0
       a
    (0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0)
       a[;!(^x)[1]]:x
       a
    (9 9 0 0 0
    9 9 0 0 0
    9 9 0 0 0
    9 9 0 0 0)



## 392. Matrix from scalar or vector

       x:4
       x
       !0
       (1+~#^x),:/x
       ,,4
       (1+~#^x),:/x
    1 1
       x:7 8
       (1+~#^x),:/x:7 8
    1 2



## 393. See 248

## 394. \[deferred\]

## 395. \[deferred\]



## 396. Remove columns `y` from `x`

       y
    ((1 2 3 4
    5 6 7 8
    9 10 11 12)
    (13 14 15 16
    17 18 19 20
    21 22 23 24))
       y _di\:\: 0 2
    ((2 4
    6 8
    10 12)
    (14 16
    18 20
    22 24))



## 397. See 73



## 398. Diagonals from columns

    x:(1 2 3 4 5
    6 7 8 9 10
    11 12 13 14 15
    16 17 18 19 20
    21 22 23 24 25)
    (-!5)!'x
    (1 2 3 4 5
    10 6 7 8 9
    14 15 11 12 13
    18 19 20 16 17
    22 23 24 25 21)
    q)x:5 5#1+til 25
    q)x
    1  2  3  4  5
    6  7  8  9  10
    11 12 13 14 15
    16 17 18 19 20
    21 22 23 24 25

    q)(neg til 5)rotate' x
    1  2  3  4  5
    10 6  7  8  9
    14 15 11 12 13
    18 19 20 16 17
    22 23 24 25 21



## 399. Columns from diagonals

          x
    (1 2 3 4 5
    10 6 7 8 9
    14 15 11 12 13
    18 19 20 16 17
    22 23 24 25 21)
       (!5)!'x
    (1 2 3 4 5
    6 7 8 9 10
    11 12 13 14 15
    16 17 18 19 20
    21 22 23 24 25)

    q)x:(1 2 3 4 5;10 6 7 8 9;14 15 11 12 13;18 19 20 16 17;22 23 24 25 21)
    q)(til 5)rotate'x
    1  2  3  4  5
    6  7  8  9  10
    11 12 13 14 15
    16 17 18 19 20
    21 22 23 24 25


## 400. \[deferred\]



## 401. First word in string `x`

       x:"twas brillig and the slith"
       x?" "
    4
       (x?" ")#x
    "twas"
       fw:{(x?" ")#x}
       fw x
    "twas"

    q)x:"twas brillig and the slith"
    q)x?" "
    4
    q)(x?" ")#x
    "twas"
    q)fw:{(x?" ")#x}
    q)fw x
    "twas"



## 402. See 392


## 403. \[omitted\]



## 404. End points for `x` fields of length `y`

       x:5
       y:3
       @[&x*y;(y-1)+y*!x;:;1]
    0 0 1 0 0 1 0 0 1 0 0 1 0 0 1

    q)x:5
    q)y:3
    q)@[(x*y)#0;(y-1)+y*til x;:;1]
    0 0 1 0 0 1 0 0 1 0 0 1 0 0 1



## 405. Start points for `x` fields of length `y`

       x:5
       y:3
       @[&x*y;y*!x;:;1]
    1 0 0 1 0 0 1 0 0 1 0 0 1 0 0

    q)x:5
    q)y:3
    q)@[(x*y)#0;y*til x;:;1]
    1 0 0 1 0 0 1 0 0 1 0 0 1 0 0



## 406. Add `y` to last item of x

       x:1 2 3 4 5
       y:100
       @[x;-1+#x;+;y]
    1 2 3 4 105

    q)x:1 2 3 4 5
    q)y:100
    q)@[x;-1+count x;+;y]
    1 2 3 4 105



## 407. Vector length `y` of `x` 1s, the rest 0s

       x:5
       y:12
       @[&12;!x;:;1]
    1 1 1 1 1 0 0 0 0 0 0 0

    q)x:5
    q)x:12
    q)@[12#0;til x;:;1]
    1 1 1 1 1 0 0 0 0 0 0 0



## 408. Initial empty row to start matrix of `x` columns

       x:15
       ,&x
    ,0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
       ,1.0*&x
    ,0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.0
       ,x#" "
    ," "

    q)x:15
    q)enlist x#0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    q)enlist 1.0*x#0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    q)enlist x#" "
    "               "


## 409. \[omitted\]



## 410. Number of columns in matrix `x`

       x:2 7#" "
       x
    2 7
       *|^x
    7

    /not quite the same
    q)x:2 7#" "
    q)count x
    2
    q)count each x
    7 7
    q)(count;first count each)@\:x
    2 7



## 411. Number of rows in matrix `x`

       x:2 7#" "
       x
    2 7
       #x
    2

    /not quite the same
    q)x:2 7#" "
    q)count x
    2
    q)count each x
    7 7
    q)(count;first count each)@\:x
    2 7



## 412. See 184



## 413. Omitted



## 414. Ending indices from field lengths

       x:4 7 13 15 20
       (1+*x),-':x
    5 3 6 2 5

    q)x:4 7 13 15 20
    q)(1+first x),-':[x]
    5 4 3 6 2 5



## 415. Lengths of infixes of 1 in `x`

       x:0 0 1 1 1 0 0 1 1 1 1 0 1
       a:<':0,x,0
       b:>':0,x,0
       a
    0 0 0 0 0 1 0 0 0 0 0 1 0 1
       b
    0 0 1 0 0 0 0 1 0 0 0 0 1 0
       &a
    5 11 13
       &b
    2 7 12
       (&a)-(&b)
    3 4 1
       (&<':0,x,0)-&>':0,x,0
    3 4 1
       m415:{(&<':0,x,0)-&>':0,x,0}

    q)x:0 0 1 1 1 0 0 1 1 1 1 0 1
    q)a:<':[0,x,0]
    q)b:>':[0,x,0]
    q)a
    000000100000101b
    q)b
    100100001000010b
    q)a:1_a
    q)b:1_b
    q)a
    00000100000101b
    q)b
    00100001000010b
    q)where a
    5 11 13
    q)where b
    2 7 12
    q)(where a)-(where b)
    3 4 1
    q)m415:{(where 1_<':[0,x,0])-(where 1_>':[0,x,0])}
    q)m415 x
    3 4 1



## 416. Omitted



## 417. End points of equal infixes

       x:"baackkkegtt"
       (~(1 _ x)=-1 _ x),1
    1 0 1 1 0 0 1 1 1 0 1

    q)x:"baackkkegtt"
    q)(not(1 _ x)=-1 _ x),1b
    10110011101b



## 418. Starting indices of equal item infix

       x:"baackkkegtt"
       1,~(1 _ x)=-1 _ x
    1 1 0 1 1 0 0 1 1 1 0

    q)x:"baackkkegtt"
    q)(not (1 _ x)=-1 _ x),1b
    10110011101b



## 419. Pairwise ratios

       x:2 10 50 100
       %':x
    5 5 2.0

    q)ratios x
    2 5 5 2f
    q)1_ratios x
    5 5 2f



## 420. See 383



## 421. Deferred



## 422. See 154



## 423. Lengths from start indicator

       x:1 0 1 0 0 1 0 0 0 1 0
       &x,1
    0 2 5 9 11
       -':&x,1
    2 3 4 2

    q)1_deltas where x,1
    2 3 4 2



## 424. Single blank from multiples

       x:"a b c d"
       x[&a|1 _ 1!1,a:~" "=x]
    "a b c d"

    q)x:"a    b       c    d"
    q)x[where a|1 _ 1 rotate 1b,a:not " "=x]
    "a b c d"



## 425. See 380



## 426. Change all multiple infixes of `y` in `x` to single

       x:"bccbceekl"
       y:"c"
       x[&a|-1 _ 1,a:~x=y]
    "bcbceekl"

    q)x:"bccbceekl"
    q)y:"c"
    q)x[where a|-1 _ 1b,a:not x=y]
    "bcbceekl"



## 427. Deferred



## 428. See 73



## 429. Matrix with diagonal `x`

       x:5 9 6 7 2
       (2##x)#,/x,'(2##x)#0
    (5 0 0 0 0
    0 9 0 0 0
    0 0 6 0 0
    0 0 0 7 0
    0 0 0 0 2)

    q)x:5 9 6 7 2
    q)(2#count x)#raze x,'(2#count x)#0
    5 0 0 0 0
    0 9 0 0 0
    0 0 6 0 0
    0 0 0 7 0
    0 0 0 0 2



## 430. Polynomial derivative

       x:1 2 3 4 5
       -1 _ x*|!#x
    4 6 6 4

    q)x:1 2 3 4 5
    q)-1 _ x*reverse til count x
    4 6 6 4



## 431. Does item differ from next one

       x:"ceefffmeksc"
       (~=':x),1
    1 0 1 0 0 1 1 1 1 1 1

    q)x:"ceefffmeksc"
    q)1_ differ x
    1010011111b



## 432. Does item differ from previous one

       x:"ceefffmeksc"
       1,~=':x
    1 1 0 1 0 0 1 1 1 1 1

    q)differ x
    11010011111b



## 433. Replace last item of `x` with `y`

       x:"abbccdefcdab"
       y:"t"
       @[x;-1+#x;:;y]
    "abbccdefcdat"

    q)x:"abbccdefcdab"
    q)y:"t"
    q)@[x;-1+count x;:;y]
    "abbccdefcdat"



## 434. Replace first item of `x` with `y`

       x:"abbccdefcdab"
       y:"t"
       @[x;0;:;y]
    "tbbccdefcdab"

    q)x:"abbccdefcdab"
    q)y:"t"
    q)@[x;0;:;y]
    "tbbccdefcdab"

<span id="435">435</span>. \[deferred\]

<span id="436">436</span>. \[deferred\]



## 437. Remove leading zeros

       x:"00002345600345000"
    ((x="0")?0)_ x
    "2345600345000"

    q)x:"00002345600345000"
    q)((x="0")?0b) _ x
    "2345600345000"



## 438. Index of 1st 1 following index `y` in `x`

       x:1 0 0 1 1 0 1 1 0
       y:3
       y+(y _ x)?1
    3
       y+((y+1)_ x)?1
    3
    (y+1)+((y+1)_ x)?1
    4
    / a more K-like alternative
       &x
    0 3 4 6 7
       y<&x
    0 0 1 1 1
       (&x)[*&y<&x]
    4

    q)x:1 0 0 1 1 0 1 1 0
    q)y:3
    q)y+(y _ x)?1
    3
    q)y+((y+1)_ x)?1
    3
    q)(y+1)+((y+1)_ x)?1
    4
    q)where x
    0 3 4 6 7
    q)y<where x
    00111b
    q)(where x)[first where y<where x]
    4



## 439. Last 1s in groups of 1s

       x:0 1 1 0 1 1 1 0 0 1
       x>1 _ x,0
    0 0 1 0 0 0 1 0 0 1

    q)x:0 1 1 0 1 1 1 0 0 1
    q)x>1 _ x,0
    0010001001b



## 440. 1st 1 in groups of 1s

       x:0 1 1 0 1 1 1 0 0 1
       x>1 _ x,0
    0 0 1 0 0 0 1 0 0 1

    q)x:0 1 1 0 1 1 1 0 0 1
    q)x>1 _ x,0
    0010001001b
    /440=439?



## 441. Comma-separated list from table

       x:("Swift";"Austen";"Dickens")
       x
    ("Swift"
    "Austen"
    "Dickens")
    ",",'x
    (",Swift"
    ",Austen"
    ",Dickens")
       ,/",",'x
    ",Swift,Austen,Dickens"
       1 _ ,/",",'x
    "Swift,Austen,Dickens"

    q)x:("Swift";"Austen";"Dickens")
    q)",",x
    ","
    "Swift"
    "Austen"
    "Dickens"
    q)",",'x
    ",Swift"
    ",Austen"
    ",Dickens"
    q)raze ",",'x
    ",Swift,Austen,Dickens"
    q)1_ raze ",",'x
    "Swift,Austen,Dickens"



## 442. 1st difference

       x:+\1 2 3 4 5
       x
    1 3 6 10 15
       -':x
    2 3 4 5
       (*x),(-':x)
    1 2 3 4 5

    q)x:sums 1 2 3 4 5
    q)deltas x
    1 2 3 4 5



## 443. Drop first `y` columns from matrix `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       y:2
       y _ x
    (6 7 8
    9 10 11)

    q)x:4 3#til 12
    q)y:2
    q)y _ x
    6 7  8
    9 10 11



## 444. Drop first `y` rows from matrix `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       y:2
       y _' x
    (,2
    ,5
    ,8
    ,11)

    q)x:4 3#til 12
    q)y:2
    q)y _ 'x
    2
    5
    8
    11



## 445. Number of columns in matrix `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       *|^x
    3



## 446. Number of rows in matrix `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       #x
    4
    q)x
    0 1  2
    3 4  5
    6 7  8
    9 10 11

    q)x:4 3#til 12
    q)count x
    4



## 447. Conditional drop of `y` items from array `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       g:0
    (y*g) _ x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       g:1
    (y*g) _ x
    (6 7 8
    9 10 11)

    q)x:4 3#til 12
    q)g:0
    q)y:2
    q)(y*g)_ x
    0 1  2
    3 4  5
    6 7  8
    9 10 11
    q)g:1
    q)(y*g)_ x
    6 7  8
    9 10 11



## 448. Conditional drop of last item of array `x`

       x:4 3# !12
       x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       y:0
       (-y) _ x
    (0 1 2
    3 4 5
    6 7 8
    9 10 11)
       y:1
       (-y) _ x
    (0 1 2
    3 4 5
    6 7 8)

    q)x:4 3#til 12
    q)x
    0 1  2
    3 4  5
    6 7  8
    9 10 11
    q)y:0
    q)(neg y)_x
    0 1  2
    3 4  5
    6 7  8
    9 10 11
    q)y:1
    q)(neg y)_x
    0 1 2
    3 4 5
    6 7 8



## 449. Limiting `x` between `l` and `h`, inclusive

       x: 5 6 _draw 100
       x
    (58 9 37 84 39 99
    60 30 45 97 77 35
    49 87 82 79 8 30
    46 61 20 51 12 34
    31 51 29 35 17 89)
       l:30
       h:70
       l|h&x
    (58 30 37 70 39 70
    60 30 45 70 70 35
    49 70 70 70 30 30
    46 61 30 51 30 34
    31 51 30 35 30 70)

    q)x:(58 9 37 84 39 99;60 30 45 97 77 35;49 87 82 79 8 30;46 61 20 51 12 34;31 51 29 35 17 89)
    q)l:30
    q)h:70
    q)l|h&x
    58 30 37 70 39 70
    60 30 45 70 70 35
    49 70 70 70 30 30
    46 61 30 51 30 34
    31 51 30 35 30 70



## 450. Arithmetic precision of system in decimals

       log10:{(_log x)%_log 10}
       log10 3
    0.47712125471966244
       _ _abs log10 _abs 1-3*%3
    0I
    This indicates that the precision is infinite (which isn't true)
    and is a consequence of
    3*%3
    1.0

    q)log10:{(log x)%log 10}
    q)log10 3
    0.4771213
    q)\P 17
    q)log10 3
    0.47712125471966238
    q)\P 0
    q)log10 3
    0.47712125471966238
    q)abs log10 abs 1-3*reciprocal 3
    0w
    q)floor abs log10 abs 1-3*reciprocal 3
    0W



## 451. Arithmetic progression from `x` to `y` with step ``g``

       ap:{[x;y;g]x+g*!1+_(y-x)%g}
       ap[3;20;5]
    3 8 13 18
       ap[3;-20;-5]
    3 -2 -7 -12 -17

    q)ap:{[x;y;g]x+g*til 1+ floor (y-x)%g}
    q)ap[3;20;5]
    3 8 13 18
    q)ap[3;-20;-5]
    3 -2 -7 -12 -17



## 452. Number of positions in integer `x`

       dp:{1+(x<0)+_ log10[_abs[x+0=x]]}
       dp 1234
    4
       dp -1234
    5
       dp 0
    1
       dp 1
    1
       dp 7
    1
       dp 12345678
    8

    q)log10:{(log x)%log 10}
    q)dp:{1+(x<0)+floor log10[abs[x+0=x]]}
    q)dp 1234
    4
    q)dp -1234
    5
    q)dp 0
    1
    q)dp 7
    1
    q)dp 12345678
    8



## 453. Round to nearest even integer

       re:{_ x+~1>x!2}
       x:0.9 1 2.5 3.1 -0.2 -1.9
       re x
    0 2 2 4 0 -2

    q)re:{floor x+not 1>x mod 2}
    q)x:0.9 1 2.5 3.1 -0.2 -1.9
    q)re x
    0 2 2 4 0 -2



## 454. Rounding, but to nearest even integer if fractional part is 0.5

       rn:{_ x+0.5*~0.5=x!2}
       x:23.6 40.5 3.2 -14.02 3.5 4.5
       rn x
    24 40 3 -14 4 4

    q)rn:{floor x+0.5*not 0.5=x mod 2}
    q)x:23.6 40.5 3.2 -14.02 3.5 4.5
    q)rn x
    24 40 3 -14 4 4



## 455. Number of digit positions in `x`

       nd:{1+_ log10(x=0)+x*1 -10[x<0]}
       x:4 678 -21 -10854
       nd x
    1 3 3 6

    q)nd:{1+floor log10(x=0)+x*1 -10[x<0]}
    q)x:4 678 -21 -10854
    q)nd x
    1 3 3 6



## 456. Number of digits in nonnegative integer `x`

       np:{1+_ log10 x+0=x}
       x:0 13 523 16008
       np x
    1 2 3 5

    q)np:{1+floor log10 x+0=x}
    q)x:0 13 523 16008
    q)np x
    1 2 3 5



## 457. Is `x` integral

       ii:{x=_ x}
       x:67 -120 3.83 -5.5
       ii x
    1 1 0 0

    q)ii:{x=floor x}
    q)x:67 -120 3.83 -5.5
    q)ii x
    1100b


## 458. \[omitted\]



## 459. Leading digit of numeric code abbb

       ld:{_ x%1000}
       x:6 _draw 10000
       x
    1319 8629 6581 6988 790 9045
       ld x
    1 8 6 6 0 9

    q)ld:{floor x%1000}
    q)x:1319 8629 6581 6988 790 9045
    q)ld x
    1 8 6 6 0 9



## 460. Round `y` to `x` decimals

       rn:{(10^-x)*_ 0.5+y*10^x}
       y:3.3256789
       x:3
       rn[x;y]
    3.326

    q)rn:{xexp[10;neg x]*`long$y*xexp[10;x]}
    q)y:3.3256789
    q)x:3
    q)rn[x;y]
    3.3259999999999978
    q)\P 7
    q)rn[x;y]
    3.326
    q)rn[2;123123123123.123123]
    123123123123.12



## 461. Round to nearest hundredth

       rh:{0.01*_0.5+x*100}
       x:3.1414 2.71828 -12.66666
       rh x
    3.14 2.72 -12.67

    q)rh:{0.01*floor 0.5+x*100}
    q)x:3.1414 2.71828 -12.66666
    q)rh x
    3.14 2.72 -12.67



## 462. Round to nearest integer

       ri:{_0.5+x}
       x:4.5 3.21 80.9 -2.4 -9.6
       ri x
    5 3 81 -2 -10

    q)ri:{floor 0.5+x}
    q)x:4.5 3.21 80.9 -2.4 -9.6
    q)ri x
    5 3 81 -2 -10



## 463. Is `x` a leap year

       ly:{(+/0=x!/:4 100 400)!2}
       x:1900 1901 1904 2000
       ly x
    0 0 1 1

    q)ly:{(sum 0=x mod/:4 100 400)mod 2}
    q)x:1900 1901 1904 2000
    q)ly x
    0 0 1 1



## 464. Framing character matrix `x`

       x:4 4#"abcdefghijklmnop"
       x
    ("abcd"
    "efgh"
    "ijkl"
    "mnop")
       +"-",'(+"|",'x,'"|"),'"-"
    ("------"
    "|abcd|"
    "|efgh|"
    "|ijkl|"
    "|mnop|"
    "------")

    q)x:4 4#"abcdefghijklmnop"
    q)x
    "abcd"
    "efgh"
    "ijkl"
    "mnop"
    q)flip"-",'(flip"|",'x,'"|"),'"-"
    "------"
    "|abcd|"
    "|efgh|"
    "|ijkl|"
    "|mnop|"
    "------"



## 465. Magnitude of fractional part

       x:6.13 -6.13
       _abs[x]!1
    0.13 0.13

    q)abs[x] mod floor abs x
    0.13 0.13



## 466. Remove every `y`-th item of `x`

       x:4+!10
       x
    4 5 6 7 8 9 10 11 12 13
       y:3
       !#x
    0 1 2 3 4 5 6 7 8 9
       (!#x)!y
    0 1 2 0 1 2 0 1 2 0
       ~0=(!#x)!y
    0 1 1 0 1 1 0 1 1 0
       &~0=(!#x)!y
    1 2 4 5 7 8
       x[&~0=(!#x)!y]
    5 6 8 9 11 12

    q)x:4+til 10
    q)x
    4 5 6 7 8 9 10 11 12 13
    q)y:3
    q)til count x
    0 1 2 3 4 5 6 7 8 9
    q)(til count x)mod y
    0 1 2 0 1 2 0 1 2 0
    q)0=(til count x)mod y
    1001001001b
    q)not 0=(til count x)mod y
    0110110110b
    q)where not 0=(til count x)mod y
    1 2 4 5 7 8
    q)x[where not 0=(til count x)mod y]
    5 6 8 9 11 12



## 467. Select every `y`-th item of `y`

       x:4+!10
       x
    4 5 6 7 8 9 10 11 12 13
       y:3
       !#x
    0 1 2 3 4 5 6 7 8 9
       (!#x)!y
    0 1 2 0 1 2 0 1 2 0
       0=(!#x)!y
    1 0 0 1 0 0 1 0 0 1
       &0=(!#x)!y
    0 3 6 9
       x[&0=(!#x)!y]
    4 7 10 13

    q)x:4+til 10
    q)x
    4 5 6 7 8 9 10 11 12 13
    q)y:3
    q)til count x
    0 1 2 3 4 5 6 7 8 9
    q)(til count x)mod y
    0 1 2 0 1 2 0 1 2 0
    q)0=(til count x)mod y
    1001001001b
    q)where 0=(til count x)mod y
    0 3 6 9
    q)x[where 0=(til count x)mod y]
    4 7 10 13



## 468. See `dv` in 164



## 469. Remove every second item

       x:"abcdefghijklmn"
       (!#x)!2
    0 1 0 1 0 1 0 1 0 1 0 1 0 1
       &(!#x)!2
    1 3 5 7 9 11 13
       x[&(!#x)!2]
    "bdfhjln"

    q)x:"abcdefghijklmn"
    q)(til count x)mod 2
    0 1 0 1 0 1 0 1 0 1 0 1 0 1
    q)where (til count x)mod 2
    1 3 5 7 9 11 13
    q)x[where (til count x)mod 2]
    "bdfhjln"



## 470. Items of `x` divisible by `y`

       x:10 _draw 100
       x
    95 33 64 10 78 1 47 20 92 95
       y:4
       x!y
    3 1 0 2 2 1 3 0 0 3
       0=x!y
    0 0 1 0 0 0 0 1 1 0
       &0=x!y
    2 7 8
       x[&0=x!y]
    64 20 92

    q)x:95 33 64 10 78 1 47 20 92 95
    q)y:4
    q)x mod y
    3 1 0 2 2 1 3 0 0 3
    q)0=x mod y
    0010000110b
    q)where 0=x mod y
    2 7 8
    q)x[where 0=x mod y]
    64 20 92



## 471. Index of first occurrence of `g` in `x` (circularly) after `y`

       x: 15 _draw 10
       x
    6 6 0 0 8 9 8 1 0 2 9 4 6 3 5
       g:0 6 5
       y:9
       (y+(y!x)?g)!#x
    9
       (y+(y!x)?/:g)!#x
    2 12 14

    /not quite the same
    q)x:6 6 0 0 8 9 8 1 0 2 9 4 6 3 5
    q)g:0 6 5
    q)y:9
    q)(y+(y rotate x)?g)mod count x
    2 12 14



## 472. Omitted



## 473. Is `x` even

       x:1 2 3 4 5
       ~x!2
    0 1 0 1 0

    q)x:1 2 3 4 5
    q)not x mod 2
    01010b



## 474. Round `x` to zero if magnitude less than `y`

       x:1e-4 -1e-8 -1e-12 1e-16
       x*~y>_abs x
    0.0001 -1e-008 0 0

    q)x:1e-4 -1e-8 -1e-12 1e-16
    q)y:1e-9
    q)x*not y>abs x
    0.0001 -1e-08 -0 0
    q)y>abs x
    0011b
    q)not y>abs x
    1100b
    q)x*not y>abs x
    0.0001 -1e-08 -0 0
    /y is unspecified and arbitrarily defined
    /need to explain -0.



## 475. Increase absolute value without sign change

       x:0 -1 2 -3 4 -5
       sg:{(x>0)-(x<0)}
       y:10
       (sg x)*y+_abs x /problem with x=0
    0 -11 12 -13 14 -15.0

    q)x:0 -1 2 -3 4 -5
    q)sg:{(x>0)-(x<0)}  /or use the builtin signum
    q)y:10
    q)(sg x)*y+abs x /problem with x=0
    0 -11 12 -13 14 -15



## 476. Fractional part with sign

       x:0.2 2.3 -0.2 -1.8 0 5 -7
       (sg x)*(_abs x)!1
    0.2 0.3 -0.2 -0.8 0 0 0

    q)sg:{(x>0)-(x<0)}      /or use the builtin signum
    q)x:0.2 2.3 -0.2 -1.8 0 5 -7
    q)(sg x)*(abs x)mod 1
    0.2 0.3 -0.2 -0.8 0 0 -0



## 477. Square `x` retaining sign

       x:0 -1 2 -3 4
       x*_abs x
    0 -1 4 -9 16.0

    q)x:0 -1 2 -3 4
    q)x*abs x
    0 -1 4 -9 16



## 478. Fractional part

       x:0 1 -2 3.4 -5.6 -6.1
       x!1
    0 0 0 0.4 0.4 0.9

    q)x:0 1 -2 3.4 -5.6 -6.1
    q)x mod 1
    0 0 0 0.4 0.4 0.9



## 479. Last part of abbb

       x:1234 5678 9012 345 6789
       x!1000
    234 678 12 345 789

    q)x:1234 5678 9012 345 6789
    q)x mod 1000
    234 678 12 345 789



## 480. Replace items of `x` in `y` by 0

       x:1 2 3 4 5
       y:2 4
       x _lin y
    0 1 0 1 0
       x*~x _lin y
    1 0 3 0 5

    q)x:1 2 3 4 5
    q)y:2 4
    q)x in y
    01010b
    q)x*not x in y
    1 0 3 0 5

## 481. Replace items of `x` not in `y` by 0

       x:1 2 3 4 5
       y:2 4
       x _lin y
    0 1 0 1 0
       x*x _lin y
    0 2 0 4 0

    q)x:1 2 3 4 5
    q)y:2 4
    q)x in y
    01010b
    q)x*x in y
    0 2 0 4 0



## 482. Merge `x` any under control of `g`

       x:1 2 3 4 5
       y:100 200 300 400 500
       g:1 0 0 1 1 0 1 0 0 1
       (x,y)[<<g]
    100 1 2 200 300 3 400 4 5 500

    q)x:1 2 3 4 5
    q)y:100 200 300 400 500
    q)g:1 0 0 1 1 0 1 0 0 1
    q)(x,y)[rank g]
    100 1 2 200 300 3 400 4 5 500



## 483. See 481



## 484. Right-to-left scan

       x:1 2 3 4 5
       |+\|x
    15 14 12 9 5

    q)x:1 2 3 4 5
    q)reverse sums reverse x
    15 14 12 9 5



## 485. Append empty row on matrix

       x:("ab";"cd";"ef")
       x
    ("ab"
    "cd"
    "ef")
       x,,(*|^x)#" "
    ("ab"
    "cd"
    "ef"
    " ")


## 486. \[omitted\]



## 487. Insert empty row in `x` after row `y`

       x:("ab";"cd";"ef")
       x
    ("ab"
    "cd"
    "ef")
       y:1
       a:x,,(*|^x)#" "
       a
    ("ab"
    "cd"
    "ef"
    " ")
       b:<(!#x),y
       b
    0 1 3 2
       a[b]
    ("ab"
    "cd"
    " "
    "ef")
       (x,,(*|^x)#" ")[<(!#x),y]
    ("ab"
    "cd"
    " "
    "ef")



## 488. Omitted



## 489. Make string `y` into table guided by marker `x`

       y:"eachwordinarow"
       x:1 0 0 0 1 0 0 0 1 0 1 1 0 0
       a:&x
       a
    0 4 8 10 11
       b:a _ y
       b
    ("each"
    "word"
    "in"
    ,"a"
    "row")
       (&x)_ y
    ("each"
    "word"
    "in"
    ,"a"
    "row")

    q)y:"eachwordinarow"
    q)x:1 0 0 0 1 0 0 0 1 0 1 1 0 0
    q)a:where x
    q)a
    0 4 8 10 11
    q)b:a _ y
    q)b
    "each"
    "word"
    "in"
    ,"a"
    "row"
    q)(where x) _ y
    "each"
    "word"
    "in"
    ,"a"
    "row"



## 490. Insert spaces in text

       x:"wider"
       a:+,x
       a
    (,"w"
    ,"i"
    ,"d"
    ,"e"
    ,"r")
       b:a,'" "
       b
    ("w "
    "i "
    "d "
    "e "
    "r ")
       ,/b
    "w i d e r "
       ,/(+,x),'" "
    "w i d e r "

    q)x:"wider"
    q)a:flip enlist x
    q)a
    ,"w"
    ,"i"
    ,"d"
    ,"e"
    ,"r"
    q)b:a,'" "
    q)b
    "w "
    "i "
    "d "
    "e "
    "r "
    q)raze b
    "w i d e r "
    q)raze(flip enlist x),'" "
    "w i d e r "



## 491. Or-reduce infixes of `y` marked by `x`

       x:1 0 0 1 0 0 0 1 0 0 0 0
       y:0 0 0 0 1 0 0 0 0 0 1 0
       a:(&x)_ y
       a
    (0 0 0
    0 1 0 0
    0 0 0 1 0)
       |/'a
    0 1 1

    q)x:1 0 0 1 0 0 0 1 0 0 0 0
    q)y:0 0 0 0 1 0 0 0 0 0 1 0
    q)a:(where x)_y
    q)a
    0 0 0
    0 1 0 0
    0 0 0 1 0
    q)max'[a]
    0 1 1



## 492. And-reduce infixes of `y` marked by `x`

       x:1 0 0 1 0 0 0 1 0 0 0 0
       y:0 1 1 1 1 1 1 1 1 1 1 0
       (&x)_ y
    (0 1 1
    1 1 1 1
    1 1 1 1 0)
       &/'(&x)_ y
    0 1 0

    q)x:1 0 0 1 0 0 0 1 0 0 0 0
    q)y:0 1 1 1 1 1 1 1 1 1 1 0
    q)(where x)_y
    0 1 1
    1 1 1 1
    1 1 1 1 0
    q)min'[(where x)_y]
    0 1 0



## 493. Choose `x` or `y` depending on boolean `g`

       x:"abcdef"
       y:"xyz"
       g:0
       :[g;x;y]
    "xyz"
       g:1
       :[g;x;y]
    "abcdef"

    q)x:"abcdef"
    q)y:"xyz"
    q)g:0
    q)$[g;x;y]
    "xyz"
    q)g:1
    q)$[g;x;y]
    "abcdef"



## 494. See 424



## 495. Indices of all occurrences of `y` in `x`

       x:"abcdefgab"
       y:"afc*"
       x _lin y
    1 0 1 0 0 1 0 1 0
       &x _lin y
    0 2 5 7

    q)x:"abcdefgab"
    q)y:"afc*"
    q)x in y
    101001010b
    q)where x in y
    0 2 5 7



## 496. Remove punctuation characters

       x:"oh! no, stop it. you will?"
       y:",;:.!?"
       x _dvl y
    "oh no stop it you will"

    /not quite the same
    q)x[where not x in y]
    "oh no stop it you will"



## 497. Set union

       x:"12345"
       y:"4567890"
       y,x[&~x _lin y]
    "4567890123"

    q)x:"12345"
    q)y:"4567890"
    q)y,x[where not x in y]
    "4567890123"



## 498. Set difference

       x:"12345"
       y:"4567890"
       x _dvl y
    "123"

    q)x:"12345"
    q)y:"4567890"
    q)x[where not x in y]
    "123"



## 499. Rows of `y` starting with item of `x`

       x:("abcd";"efgh";"ijkl";"mnop")
       x
    ("abcd"
    "efgh"
    "ijkl"
    "mnop")
       y:"ai"
       x[;0] _lin y
    1 0 1 0
       &x[;0] _lin y
    0 2
       x[&x[;0] _lin y]
    ("abcd"
    "ijkl")

    q)x:("abcd";"efgh";"ijkl";"mnop")
    q)x
    "abcd"
    "efgh"
    "ijkl"
    "mnop"
    q)y:"ai"
    q)x[;0] in y
    1010b
    q)where x[;0] in y
    0 2
    q)x[where x[;0] in y]
    "abcd"
    "ijkl"



## 500. Set intersection

       x:"abcdefghijxyz"
       y:"yacqwopzbx"
       x[&x _lin y]
    "abcxyz"

    q)x:"abcdefghijxyz"
    q)y:"yacqwopzbx"
    q)x[where x in y]
    "abcxyz"


## 501. See 154



## 502. Deferred



## 503. Indices of all occurrences of `y` in x

       x:"abcdeabc"
       y:"a"
       &x=y
    0 5

    q)x:"abcdeabc"
    q)y:"a"
    q)where x=y
    0 5



## 504. Replace items of `y` satisfying `x` with g

       x:1 0 0 0 1 0 1 1 0 1
       y:"abcdefghij"
       g:" "
       @[y;&x;:;g]
    " bcd f i "

    q)x:1 0 0 0 1 0 1 1 0 1
    q)y:"abcdefghij"
    q)g:" "
    q)@[y;where x;:;g]
    " bcd f  i "



## 505. See 154



## 506. See 41



## 507. Insert blank in `y` after mark in `x`

       x:1 0 0 0 0 1 0 0
       y:"abcdefgh"
       x#\:" "
    (," "
    ""
    ""
    ""
    ""
    ," "
    ""
    "")
       y,' x#\:" "
    ("a "
    ,"b"
    ,"c"
    ,"d"
    ,"e"
    "f "
    ,"g"
    ,"h")
       ,/ y,' x#\:" "
    "a bcdef gh"

    q)x:1 0 0 0 0 1 0 0
    q)y:"abcdefgh"
    q)x#\:" "
    ," "
    ""
    ""
    ""
    ""
    ," "
    ""
    ""
    q)y,' x#\:" "
    "a "
    ,"b"
    ,"c"
    ,"d"
    ,"e"
    "f "
    ,"g"
    ,"h"
    q)raze y,' x#\:" "
    "a bcdef gh"



## 508. Conditional text

       x:0
       ,/((~x)#'"in"),"correct"
    "incorrect"
       x:1
       ,/((~x)#'"in"),"correct"
    "correct"

    q)x:0
    q)raze((not x)#'"in"),"correct"
    "incorrect"
    q)x:1
    q)raze((not x)#'"in"),"correct"
    "correct"



## 509. Remove `y` from `x`

       x:"abcdeabc"
       y:"a"
       x _dv y
    "bcdebc"

    q)x:"abcdeabc"
    q)y:"a"
    q)x[where not  x in y]
    "bcdebc"



## 510. Remove blanks

       x:" bcde bc"
       x _dv " "
    "bcdebc"

    q)y:" "
    q)x:" bcde bc"
    q)x[where not  x in y]
    "bcdebc"



## 511. Apply `f` over all of `x`

       x:2 3 4#1+!24
       x
    ((1 2 3 4
    5 6 7 8
    9 10 11 12)
    (13 14 15 16
    17 18 19 20
    21 22 23 24))
       +//x
    300
       ao:{[f;x]f//x}
       ao[+;x]
    300
       ao[*;1.0*x]
    6.204484e+023
       ao[+;-x]
    -300



## 512. Select items of `x` according to markers in `y`

       x:2 3 4#1+!24
       x
    ((1 2 3 4
    5 6 7 8
    9 10 11 12)
    (13 14 15 16
    17 18 19 20
    21 22 23 24))
       y:1 0 0 1
       x[;;&y]
    ((1 4
    5 8
    9 12)
    (13 16
    17 20
    21 24))



## 513. Empty matrix

       x:,!0
       x
    ,!0
       x
    1 0



## 514. Apply to dimension 1 function defined on dimension 0

       x:3 4#1+!12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       +/x
    15 18 21 24
       +/'x
    10 26 42

    q)sum x
    15 18 21 24
    q)sum each x
    10 26 42



## 515. Deferred



## 516. Multiply each column of `x` by `y`

       x:(1 2 3 4 5 6
    7 8 9 10 11 12)
       y:10 100
       x*y
    (10 20 30 40 50 60
    700 800 900 1000 1100 1200)
       y*x
    (10 20 30 40 50 60
    700 800 900 1000 1100 1200)

    q)x:(1 2 3 4 5 6;7 8 9 10 11 12)
    q)y:10 100
    q)x*y
    10  20  30  40   50   60
    700 800 900 1000 1100 1200
    q)y*x
    10  20  30  40   50   60
    700 800 900 1000 1100 1200



## 517. Deferred



## 518. Transpose matrix `x` on condition `y`

       x:2 3# !6
       x
    (0 1 2
    3 4 5)
       y:1
       y +:/x
    (0 3
    1 4
    2 5)
       y:0
       y +:/x
    (0 1 2
    3 4 5)

    q)x:2 3#til 6
    q)x
    0 1 2
    3 4 5
    q)y:1
    q)y +:/x
    0 3
    1 4
    2 5
    q)y:0
    q)y+:/x
    0 1 2
    3 4 5



## 519. See 85



## 520. See 86



## 521. Matrix with `x` columns `y`

       x:4
       y:"abc"
       x#'y
    ("aaaa"
    "bbbb"
    "cccc")

    q)x:4
    q)y:"abc"
    q)x#'y
    "aaaa"
    "bbbb"
    "cccc"



## 522. See 80



## 523. Deferred



## 524. Deferred



## 525. Main diagonal

       x:(1 2 3 4
    5 6 7 8
    9 10 11 12)
       y:2#'!#x
       y
    (0 0
    1 1
    2 2)
       x ./: y
    1 6 11



## 526. See 525



## 527. Transpose planes of three-dimensional `x`

       x:2 2 2# !8
       x
    ((0 1
    2 3)
    (4 5
    6 7))
       +:'x
    ((0 2
    1 3)
    (4 6
    5 7))



## 528. Vector (cross) product

       x:2 8 5 6 3 1 7 7 10 4
       y:6 9 1 1 6 7 1 4 1 5
       ((1!x)*-1!y)-(-1!x)*1!y
    4 28 46 -27 -41 39 45 3 -19 -58

    q)x:2 8 5 6 3 1 7 7 10 4
    q)y:6 9 1 1 6 7 1 4 1 5
    q)((1 rotate x)*-1 rotate y)-(-1 rotate x)*1 rotate y
    4 28 46 -27 -41 39 45 3 -19 -58



## 529. Markers for `x` at `y`

       x:"abcdefghijklmn"
       y:3 7 9
       @[&#x;y;:;1]
    0 0 0 1 0 0 0 1 0 1 0 0 0 0

    q)x:"abcdefghijklmn"
    q)y:3 7 9
    q)@[(count x)#0;y;:;1]
    0 0 0 1 0 0 0 1 0 1 0 0 0 0



## 530. Index of last occurrence of `y` in `x`

       x:10 _draw 5
       x
    3 0 4 3 1 4 4 3 3 1
       y:4
       *|&x=y
    6
       y:3
       *|&x=y
    8

    q)x:3 0 4 3 1 4 4 3 3 1
    q)y:4
    q)last  where x=y
    6
    q)y:3
    q)last where x=y
    8



## 531. Replace each item of `y` with index of its last occurrence

       x:"aabbbcccc"
       y:x,"ddd"
       x
    "aabbbcccc"
       y
    "aabbbccccddd"
       (|x)?/:y
    7 7 4 4 4 0 0 0 0 9 9 9
       #x
    9
       (#x)-(|x)?/:y
    2 2 5 5 5 9 9 9 9 0 0 0
       0|-1+(#x)-(|x)?/:y
    1 1 4 4 4 8 8 8 8 0 0 0

    q)x:"aabbbcccc"
    q)y:x,"ddd"
    q)x
    "aabbbcccc"
    q)y
    "aabbbccccddd"
    q)(reverse x)?/:y
    7 7 4 4 4 0 0 0 0 9 9 9
    q)count x
    9
    q)(count x)-(reverse x)?/:y
    2 2 5 5 5 9 9 9 9 0 0 0
    q)0|-1+(count x)-(reverse x)?/:y
    1 1 4 4 4 8 8 8 8 0 0 0



## 532. Index of last occurrence of `y` in `x`, counted from the rear

       x:8 4 9 1 5 7
       y:8 2 3 4 9 5 7 1 10 6 8 2
       (|x)?/:y
    5 6 6 4 3 1 0 2 6 6 5 6

    q)x:8 4 9 1 5 7
    q)y:8 2 3 4 9 5 7 1 10 6 8 2
    q)(reverse x)?/:y
    5 6 6 4 3 1 0 2 6 6 5 6



## 533. Reverse `x` on condition `y`

       x:1 2 3 4 5
       y:0
       y |:/x
    1 2 3 4 5
       y:1
       y |:/x
    5 4 3 2 1



## 534. See 203



## 535. Avoiding parentheses using reverse

       x:1 2 3 4 5
       (#x),1
    5 1
       |1,#x
    5 1

    q)x:1 2 3 4 5
    q)(count x),1
    5 1
    q)reverse 1,count x
    5 1



## 536. Rotate rows left

       x:3 4#1+!12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       1!'x
    (2 3 4 1
    6 7 8 5
    10 11 12 9)

    q)x:3 4#1+til 12
    q)1 rotate 'x
    2  3  4  1
    6  7  8  5
    10 11 12 9



## 537. Rotate rows right

       x:3 4#1+!12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       -1!'x
    (4 1 2 3
    8 5 6 7
    12 9 10 11)

    q)x:3 4#1+til 12
    q)-1 rotate 'x
    4  1 2  3
    8  5 6  7
    12 9 10 11



## 538. Insert 0 in list of ones `x` after indices `y`

       x:1 1 1 1 1 1 1 1 1 1
       y
    1 3 7
       +,x
    (,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1
    ,1)
       @[+,x;y;{x,0}]
    (,1
    1 0
    ,1
    1 0
    ,1
    ,1
    ,1
    1 0
    ,1
    ,1)
       ,/@[+,x;y;{x,0}]
    1 1 0 1 1 0 1 1 1 1 0 1 1

    q)x:1 1 1 1 1 1 1 1 1 1
    q)y:1 3 7
    q)flip enlist x
    1
    1
    1
    1
    1
    1
    1
    1
    1
    1
    q)@[flip enlist x;y;{x,0}]
    ,1
    1 0
    ,1
    1 0
    ,1
    ,1
    ,1
    1 0
    ,1
    ,1
    q)raze @[flip enlist x;y;{x,0}]
    1 1 0 1 1 0 1 1 1 1 0 1 1



## 539. Boolean vector of length `y` with zeros in locations ``x``

       x:2 3 4 8
       y:10
       method A
       ~(!y) _lin x
    1 1 0 0 0 1 1 1 0 1
       method B
       ~@[&y;x;:;1]
    1 1 0 0 0 1 1 1 0 1

    q)x:2 3 4 8
    q)y:10
    q)not @[y#0;x;:;1]
    1100011101b



## 540. Markers in Boolean vector of length `x` at indices `y`

       x:10
       y:1 3 7
       method A
      (!x) _lin y
    0 1 0 1 0 0 0 1 0 0
       method B
       @[&x;y;:;1]
    0 1 0 1 0 0 0 1 0 0

    q)x:10
    q)y:1 3 7
    q)@[x#0;y;:;1]
    0 1 0 1 0 0 0 1 0 0



## 541. Omitted



## 542. Omitted



## 543. See 540



## 544. Do `x` and `y` match

       x~y

    q)x~y



## 545. Zero items of `y` not in `x`

       y: 2 3 4 5 6 7 8 9 10 11
       x:2 3 5 7 11
       y _lin x
    1 1 0 1 0 1 0 0 0 1
       y*y _lin x
    2 3 0 5 0 7 0 0 0 11

    q)y: 2 3 4 5 6 7 8 9 10 11
    q)x:2 3 5 7 11
    q)y in x
    1101010001b
    q)y*y in x
    2 3 0 5 0 7 0 0 0 11



## 546. Is count of atoms 1 

Uses `cs` from 366

       cs:({#,//x}
       co:{1=cs[x]}
       co[35]
    1
       co[,35]
    1
       co[1 1#35]
    1
       co[1 1 1#35]
    1
       co[1 2]
    0
       co[!0]
    0

    q)cs:{count raze over x}
    q)co:{1=cs[x]}
    q)co[35]
    1b
    q)co[enlist 35]
    1b
    q)co[1 1#35]
    1b
    q)co[1 2]
    0b
    q)co[til 0]
    0b



## 547. Is `x` vector

       iv:{1=#^x}
       iv[0]
    0
       iv[1 2]
    1
       iv[(1;2)]
    1
       iv[(1 2;3 4)]
    0
       iv[2 3#!6]
    0
       iv[!0]
    1



## 548. Test if empty

       ie:{0 _in ^x}
       ie 7
    0
       ie 8 9
    0
       ie 2 3#6
    0
       ie (1 0#5)
    1



## 549. Alphabetic comparison (depends on storage values)

       "a"<"b"
    1
       "a">"b"
    0
       _ic";"
    59
       _ic"/"
    47
       ";"<"/"
    0

    q)"a"<"b"
    1b
    q)"a">"b"
    0b
    q)"i"$";"
    59
    q)`int$"/"
    47
    q)";"<"/"
    0b



## 550. See 37



## 551. Index of first differing item of `x` and `y`

       x:3 1 4 1 6 0
       y:3 1 4 1 5 9
       (~x=y)?1
    4

    q)(not x=y)?1b
    4



## 552. Which items of `x` are not in `y`

       x:2 3 4 5 6 7 8 9 10 11
       y:2 3 5 7 11
       ~x _lin y
    0 0 1 0 1 0 1 1 1 0

    q)x:2 3 4 5 6 7 8 9 10 11
    q)y:2 3 5 7 11
    q)not x in y
    0010101110b



## 553. See 37



## 554. Select from g based on index of `x` in `y`

       g:("William Shakespeare"
    > "John Milton"
    > "Jonathan Swift"
    > "Jane Austen"
    > "John Keats"
    > "Charles Dickens")
       y:1564 1608 1667 1775 1795 1812
       x:1775
       g[y?x]
    "Jane Austen"

    q)g:("William Shakespeare";"John Milton";"Jonathan Swift";"Jane Austen";"John Keats";"Charles Dickens")
    q)y:1564 1608 1667 1775 1795 1812
    q)x:1775
    q)g[y?x]
    "Jane Austen"



## 555. All axes of rectangular array `x`

       x:2 2 2 2# !16
       !#^x
    0 1 2 3



## 556. All indices of vector `x`

       x:2 2 2 2# !16
       !#^x
    0 1 2 3



## 557. Arithmetic progression of `y` numbers from `x` with step `g`

       x:5
       y:8
       g:100
       x+g*!y
    5 105 205 305 405 505 605 705
       ap:{[x;g;y]x+g*!y}
       ap[x;g;y]
    5 105 205 305 405 505 605 705

    q)x:5
    q)y:8
    q)g:100
    q)x+g*til y
    5 105 205 305 405 505 605 705
    q)ap:{[x;g;y]x+g*til y}
    q)ap[x;g;y]
    5 105 205 305 405 505 605 705



## 558. Consecutive integers from `x` to `y`

       ci:{x+!1+y-x}
       ci[5;10]
    5 6 7 8 9 10

    q)ci:{x+til 1+y-x}
    q)ci[5;10]
    5 6 7 8 9 10



## 559. Index of first marker in Boolean `x`

       x:0 0 1 0 1 0 0 1 1 0
       x?1
    2

    q)x?1
    2



## 560. Omitted



## 561. Numeric code from character

       x:" aA0"
       _ic[x]
    32 97 65 48

    q)x:" aA0"
    q)"i"$x
    32 97 65 48



## 562. Index of `y` in `x`

       x:" abcdefgh"
       y:"faded head"
       x?/:y
    6 1 4 5 4 0 8 5 1 4
       y:"deaf adder"
       x?/:y
    4 5 1 6 0 1 4 4 5 9

    q)x:" abcdefgh"
    q)y:"faded head"
    q)x?/:y
    6 1 4 5 4 0 8 5 1 4
    q)y:"deaf adder"
    q)x?/:y
    4 5 1 6 0 1 4 4 5 9



## 563. Empty vector

    !0
    !0
    !0
    ,0
    ""
    ""
    ""
    ,0



## 564. Is `x` within range ( `y[0]`,`y[1]` )

       ci:{(y[0]<x)&(x<y[1])}
       y:3 8
       x:5
       ci[x;y]
    1
       x:3
       ci[x;y]
    0
       x:2
       ci[x;y]
    0
       x:8
       ci[x;y]
    0
       x:9
       ci[x;y]
    0

    q)ci:{(y[0]<x)&(x<y[1])}
    q)y:3 8
    q)x:5
    q)ci[x;y]
    1b
    q)x:3
    q)ci[x;y]
    0b
    q)x:2
    q)ci[x;y]
    0b
    q)x:8
    q)ci[x;y]
    0b
    q)x:9
    q)ci[x;y]
    0b



## 565. Is `x` within range \[ `y[0]`,`y[1]` \]

       oi:{(~y[0]>x)&(~x>y[1])}
       y:3 8
       x:5
       oi[x;y]
    1
       x:3
       oi[x;y]
    1
       x:2
       oi[x;y]
    0
       x:8
       oi[x;y]
    1
       x:9
       oi[x;y]
    0

    q)oi:{(not y[0]>x)&(not x>y[1])}
    q)y:3 8
    q)x:5
    q)oi[x;y]
    1b
    q)x:3
    q)oi[x;y]
    1b
    q)x:2
    q)oi[x;y]
    0b
    q)x:8
    q)oi[x;y]
    1b
    q)x:9
    q)oi[x;y]
    0b



## 566. Zero all items of Boolean x

       x:0 1 0 1 1 0 0 1 1 1 0
    0&x
    0 0 0 0 0 0 0 0 0 0 0

    q)x:0 1 0 1 1 0 0 1 1 1 0
    q)0&x
    0 0 0 0 0 0 0 0 0 0 0



## 567. Select `x` or `y` depending on `g`

       x:`hot `white `short `old
       y:`cold `black `tall `young
       g:1 0 0 1
       x,'y
    (`hot `cold
    `white `black
    `short `tall
    `old `young)
       (!#g),'g
    (0 1
    1 0
    2 0
    3 1)
       (x,'y) ./: (!#g),'g
    `cold `white `short `young

    q)x:`hot`white`short`old
    /short is a reserved name (but it is not a problem here)
    q)y:`cold`black`tall`young
    q)g:1 0 0 1
    q)x,'y
    hot   cold
    white black
    short  tall
    old   young
    q)(key count g),'g
    0 1
    1 0
    2 0
    3 1
    q)(x,'y)./:(key count g),'g
    `cold`white`short`young
    q)(x,'y)@'g /more simple
    `cold`white`short`young
    q)?["b"$g;y;x] /or to use the builtin construct for it
    `cold`white`short`young



## 568. Omitted



## 569. Change `y` to one if `x`

       y:10 5 7 12 20.0
       x:0 1 0 1 1
       y^~x
    10 1 7 1 1.0
    alternatively
       @[y;&x;:;1]
    10 1 7 1 1

    q)y:10 5 7 12 20.0
    q)x:0 1 0 1 1
    q)@[y;where x;:;1.]
    10 1 7 1 1f
    /note that 1. --otherwise 'type as 9h=type y



## 570. `x` implies `y`

       x:0 1 0 1
       y:0 0 1 1
       ~x>y
    1 0 1 1

    q)x:0 1  0 1
    q)y:0 0 1 1
    q)not x>y
    1011b



## 571. `x` but not `y`

       x:0 1 0 1
       y:0 0 1 1
       x>y
    0 1 0 0

    q)x:0 1  0 1
    q)y:0 0 1 1
    q)x>y
    0100b



## 572. Division by 0

       dz:{(~0=x)*y%x+x=0}
       y:10 15 -20
       x:2 0 0
       y%x
    5 0i -0i
       dz[x;y]
    5 0 0.0

    q)dz:{(not 0=x)*y%x+x=0}
    q)y:10 15 -20
    q)x:2 0 0
    q)y%x
    5 0w -0w
    q)dz[x;y]
    5 0 -0f



## 573. Exclusive or

       x:0 0 1 1
       y:0 1 0 1
       ~x=y
    0 1 1 0

    q)x:0 0 1 1
    q)y:0 1 0 1
    q)not x=y
    0110b



## 574. `y` where `x` is 0

       x:0 7 8 0 2
       y:10 4 6 7 3
       x+y*x=0
    10 7 8 7 2

    q)x:0 7 8 0 2
    q)y:10 4 6 7 3
    q)x+y*x=0
    10 7 8 7 2



## 575. Kronecker delta of `x` and `y`

       x:0 0 1 1
       y:0 1 0 1
       x=y
    1 0 0 1

    q)x:0 0 1 1
    q)y:0 1 0 1
    q)x=y
    1001b



## 576. Append `y` items `g` before each item of `x`

       x:1 3 5
       y:2
       g:10
       y#g
    10 10
       (y#g),/:x
    (10 10 1
    10 10 3
    10 10 5)
       ,/(y#g),/:x
    10 10 1 10 10 3 10 10 5

    q)x:1 3 5
    q)y:2
    q)g:10
    q)y#g
    10 10
    q)(y#g),/:x
    10 10 1
    10 10 3
    10 10 5
    q)raze (y#g),/:x
    10 10 1 10 10 3 10 10 5



## 577. Append `y` items `g` after each item of `x`

       x:1 3 5
       y:2
       g:10
       ,/x,\:y#g
    1 10 10 3 10 10 5 10 10

    q)raze x,\:y#g
    1 10 10 3 10 10 5 10 10



## 578. Merge items from `x` and `y` alternately

       x:1 3 5 7
       y:2 4 6 8
       ,/x,'y
    1 2 3 4 5 6 7 8

    q)raze x,'y
    1 2 3 4 5 6 7 8



## 579. Variable length lines

       x:"by and by"
       y:"God caught his eye"
       ,(x;y)
    ,("by and by"
    "God caught his eye")

    q)(x;y)
    "by and by"
    "God caught his eye"



## 580. See 490



## 581. Insert `y` after each item of `x`

       x:"abc"
       y:"d"
       ,/x,'y
    "adbdcd"

    q)x:"abc"
    q)y:"d"
    q)raze x,'y
    "adbdcd"



## 582. See 197



## 583. Array and its negative

       x:1 -3 5
       x,'-x
    (1 -1
    -3 3
    5 -5)

    q)x:1 -3 5
    q)x,'neg x
    1  -1
    -3 3
    5  -5



## 584. Omitted



## 585. Omitted



## 586. Omitted



## 587. First column as a matrix

       x:(0 1 2 3
    4 5 6 7
    8 9 10 11)
       x[;,0]
    (,0
    ,4
    ,8)

    q)x[;enlist 0]
    0
    4
    8



## 588. 2-row matrix from two vectors

       x:"abcd"
       y:"efgh"
       (,x),(,y)
    ("abcd"
    "efgh")

    q)x:"abcd"
    q)y:"efgh"
    q)(enlist x),(enlist y)
    "abcd"
    "efgh"



## 589. 2-column matrix from two vectors

       x:"abcd"
       y:"efgh"
       x,'y
    ("ae"
    "bf"
    "cg"
    "dh")

    q)x,'y
    "ae"
    "bf"
    "cg"
    "dh"



## 590. Increasing rank of `y` to rank of `x`

       x:("abcd"
    > "efgh")
       x
    ("abcd"
    "efgh")
       y:"ijkl"
       #^x
    2
       #^y
    1
       #^,y
    2
       ((#^x)-#^y),:/y
    ,"ijkl"



## 591. Reshape vector `x` into 2-column matrix

       x:"abcdefgh"
       ((_ 0.5*#x),2)#x
    ("ab"
    "cd"
    "ef"
    "gh")

    q)x:"abcdefghi"
    q)((floor 0.5*count x),2)#x
    "ab"
    "cd"
    "ef"
    "gh"
    q)((floor 0.5*count x),2)#x:"ab"
    "ab"
    q)((floor 0.5*count x),2)#x:"abcd"
    "ab"
    "cd"
    q)((floor 0.5*count x),2)#x:"abcde"
    "ab"
    "cd"
    q)((floor 0.5*count x),2)#x:"abcdef"
    "ab"
    "cd"
    "ef"
    q)((floor 0.5*count x),2)#x:"abcdefgh"
    "ab"
    "cd"
    "ef"
    "gh"



## 592. Vector from array

       x:2 1 2 1 2 1# !8
       x
    2 1 2 1 2 1
       ,//x
    0 1 2 3 4 5 6 7
       ,//x
    ,8



## 593. Matrix of `y` rows, each `x`

       x:"abcd"
       y:3
       y#,x
    ("abcd"
    "abcd"
    "abcd")

    q)x:"abcd"
    q)y:3
    q)y#enlist x
    "abcd"
    "abcd"
    "abcd"



## 594. See 203



## 595. One-row matrix from vector

       x:2 3 5 7 11
       x
    2 3 5 7 11
       ^x
    ,5
       ,x
    ,2 3 5 7 11
       ^,x
    1 5



## 596. See 366



## 597. Omitted



## 598. Omitted



## 599. Number of columns in array `x`

       x:1 1 1 1 1 678#0
       ^x
    1 1 1 1 1 678
       *|^x
    678



## 600. Number of columns in matrix `x`

       x:3 19#0
       ^x
    3 19
       (^x)[1]
    19



## 601. Number of rows in matrix `x`

       x:17 2#0
       #x
    17

    q)count x
    17



## 602. Choosing according to sign

       sg:{(x>0)-(x<0)}
       sg -4.5 0 6.78
    -1 0 1
       y:"-0+"
       x:-54
       y[1+sg[x]]
    "-"
       x:0
       y[1+sg[x]]
    "0"
       x:1234.5
       y[1+sg[x]]
    "+"

    q)signum -4.5 0 6.8
    q)y[1+signum[x]]
    "-"
    q)x:0
    q)y[1+signum[x]]
    "0"
    q)x:1234.5
    q)y[1+signum[x]]
    "+"



## 603. Conditional change of sign

       y:1+!6
       y
    1 2 3 4 5 6
       x:0 1 0 1 1 0
       y*1 -1[x]
    1 -2 3 -4 -5 6

    q)y:1+til 6
    q)y
    1 2 3 4 5 6
    q)x:0 1 0 1 1 0
    q)y*1 -1[x]
    1 -2 3 -4 -5 6



## 604. Omitted



## 605. Indexing plotting characters with Boolean index

       x:~3 6 5 7 2<\:1+!7
       x
    (1 1 1 0 0 0 0
    1 1 1 1 1 1 0
    1 1 1 1 1 0 0
    1 1 1 1 1 1 1
    1 1 0 0 0 0 0)
       " *"[x]
    ("*** "
    "****** "
    "***** "
    "*******"
    "** ")

    q)x:not 3 6 5 7 2<\:1+til 7
    q)x
    1110000b
    1111110b
    1111100b
    1111111b
    1100000b
    q)" *"[x]
    "***    "
    "****** "
    "*****  "
    "*******"
    "**     "



## 606. Omitted



## 607. Vector from column of matrix

       x:3 4# !12
       x
    (0 1 2 3
    4 5 6 7
    8 9 10 11)
       x[;0]
    0 4 8

    q)x:3 4#til 12
    q)x
    0 1 2  3
    4 5 6  7
    8 9 10 11
    q)x[;0]
    0 4 8



## 608. Zeroing an array

       x:1 2 3 4
       x
    1 2 3 4
       x[]:0
       x
    0 0 0 0
       x:2 3#!6
       x
    (0 1 2
    3 4 5)
       x[;]:0
       x
    (0 0 0
    0 0 0)
       x:9
       x
    9
       x:0
       x
    0

    q)x:3 4#til 12
    q)x
    0 1 2  3
    4 5 6  7
    8 9 10 11
    q)x[;0]
    0 4 8
    q)x:1 2 3 4
    q)x
    1 2 3 4
    q)x[]:0
    q)x
    0 0 0 0
    q)x:2 3#til 6
    q)x
    0 1 2
    3 4 5
    q)x[;]:0
    q)x
    0 0 0
    0 0 0
    q)x:9
    q)x
    9
    q)x:0



## 609. Omitted



## 610. `y` cyclic repetitions of vector `x`

       x:"abcd"
       y:3
       (y*#x)#x
    "abcdabcdabcd"

    q)(y*count x)#x
    "abcdabcdabcd"



## 611. Multiply each row of `x` by vector `y`

       x:3 4#1+!12
       x
    (1 2 3 4
    5 6 7 8
    9 10 11 12)
       y:1 10 100 10000
       x*\:y
    (1 20 300 40000
    5 60 700 80000
    9 100 1100 120000)

    q)x*\:y
    1 20  300  40000
    5 60  700  80000
    9 100 1100 120000



## 612. Rank of array `y` (number of dimensions)

       x:2 1 2 1 3 1 4#0
       #^x
    7
       #^9
    0
       #^7 8 9
    1
       #^(1 2 3;4 5 6)
    2

    q)rank(1 2 3;4 5 6)
    0 1
    q)count rank(1 2 3;4 5 6)
    2



## 613. See 441



## 614. Array with shape of `y` and `x` as its rows

       y:3 4# !12
       y
    (0 1 2 3
    4 5 6 7
    8 9 10 11)
       x:"abcd"
       (^y)#x
    ("abcd"
    "abcd"
    "abcd")

    /not quite the same
    q)y:3 4#til 12
    q)x:"abcd"
    q)3 4#x
    "abcd"
    "abcd"
    "abcd"



## 615. First atom in `x`

       x:2 2 2 2# !8
       x
    (((0 1
    2 3)
    (4 5
    6 7))
    ((0 1
    2 3)
    (4 5
    6 7)))
       *//x
    0

    /not quite the same
    q)x:4 2#(4 2#til 8)
    q)x
    0 1 2 3
    4 5 6 7
    0 1 2 3
    4 5 6 7
    q)x 0
    0 1
    2 3
    q)x 1
    4 5
    6 7
    q)x 2
    0 1
    2 3
    q)x 3
    4 5
    6 7
    q)prd/[x]
    0



## 616. Scalar from one-item vector

       x:,8
       x
    ,8
       ""#x
    8
       x[0]
    8
    *x
    8

    q)x 0
    8
    q)first x
    8



## 617. Omitted



## 618. Deferred



## 619. Deferred



## 620. Omitted



## 621. See 583



## 622. Retain value of items marked by `y`, zero others

       x:3 7 15 1 292
       y:1 0 1 1 0
       x*y
    3 0 15 1 0

    q)x:3 7 15 1 292
    q)y:1 0 1 1 0
    q)x*y
    3 0 15 1 0



## 623. Conditional change of sign

       x:-9
       y:0
       x*-1^y
    -9.0
       y:1
       x*-1^y
    9.0

`/^` is very different between old k2 k3 and k4/q?

    q)x:-9
    q)y:0
    q)x*-1^y
    0
    q)y:1
    q)x*-1^y
    -9



## 624. Zero numerical array

       x:2 3#99
       x
    (99 99 99
    99 99 99)
       x*0
    (0 0 0
    0 0 0)

    q)x*0
    0 0 0
    0 0 0



## 625. Omitted



## 626. Omitted



## 627. Omitted



## 628. Omitted



## 629. Error to stop execution

    &`



## 630. Omitted



## 631. Omitted



## 1001. Payback

Cumulative accumulation factors (see Zark APL Tutor News 1998 Quarter 2)

       caf:{[W;R]*\(#W)#1+R}
       pay:{[B;T;R;W]C*B-+\W%(#W)#T _ 1,C:caf[W;R]}
    The version pay2 replaces T by END, and permits END to be any value between 0 and 1.
       pay2:{[B;END;R;W]CPA:*\A:1+R
       CPA*B-+\W%CPA%A*1-END}
    B initial balance
    T time of withdrawal: 0 start of period, 1 end
    R interest rate per period
    W withdrawal amount
       B:1000
       T:0
       R:0.05
       W:200 300 400 200
       pay[B;T;.R;W]
    840 567 175.35 -25.8825
       T:1
       pay[B;T;.R;W]
    850 592.5 222.125 33.23125
       R:0.05 0.04 0.06 0.05
       pay[B;T;R;W]
    840 561.6 171.296 -30.1392
       T:1
       pay[B;T;R;W]
    850 584 219.04 29.992

    q)caf:{[W;R]prds(count W)#1+R}
    q)pay:{[B;T;R;W]C*B-sums W%(count W)#T _ 1,C:caf[W;R]}
    q)pay2:{[B;END;R;W]CPA:prds A:1+R;CPA*B-sums W%CPA%A*1-END}
    q)B:1000
    q)T:0
    q)R:0.05
    q)W:200 300 400 200
    q)pay[B;T;R;W]
    840 567 175.35 -25.8825
    q)T:1
    q)pay[B;T;R;W]
    850 592.5 222.125 33.23125
    q)R:0.05 0.04 0.06 0.05
    q)T:0
    q)pay[B;T;R;W]
    840 561.6 171.296 -30.1392
    q)T:1
    q)pay[B;T;R;W]
    850 584 219.04 29.992



## 1002. Round summands

Ensure sum of rounded summands matches round of sum

       f:{y%:x
       i:_y
       x*@[i;{(_.5+/x)#>x}[y-i];+;1]}
       y:42.35 38.45 19.20
    _.5++/y
    100
    _.5+y
    42 38 19
    +/_.5+y
    99
       x:1
       z:f[x;y]
       z
    42 39 19
    +/z
    100
       y:42.65 37.60 19.75
    _.5++/y
    100
    _.5+y
    43 38 20
    +/_.5+y
    101
       z:f[x;y]
       z
    43 37 20
    +/z
    100



## 1003. Maximum sum of infixes

       f:{|/0(0|+)\x}
       x:-100 2 3 4 -100 6 7 8 9 -100
    f x
    30

    /need more study
    q)f:{max 0 (0|+)\x}
    q)x:-100 2 3 4 -100 6 7 8 9 -100
    q)f x
    30



## 1004. Range union

       i:(1 3;8 10;11 12;2 4)
    / given ordered (lefts;rights)
    / interval 0 and where left is greater than 1+ max previous right
       f:{(x i;1!y i:0,&x>1+y:-1!|\y)}
       +f .+{x@<x}i /flip f apply flip sort i
    (1 4;8 12)

    q)f:{(x i;1 rotate y i:0,where x>1+y:-1 rotate(|\)y)}
    q)flip f . flip asc i
    1 4
    8 12



## 1005. Pointer chasing

For `r` a primitive root of prime `p`, the additive list formed by `(r*!p)!p` has an interesting property, first discussed by August Crelle in the early 19th century. For example, if we take such a list for the primitive root 3 of 7:
```q
a:(3*!7)!7
/ list of successive sums of 3, starting from 0, mod 7:
a
0 3 6 2 5 1 4
then if we treat the items of this list as pointers, and write
a\1
1 3 2 6 4 5
```
We find that the new list is the successive powers of 3, mod 7.
```q
q)a:(3*til 7)mod 7
q)a
0 3 6 2 5 1 4
q)a\[1]
1 3 2 6 4 5
```


## 1006. Partitions of `y` with no part less than `x`

       part:{t:x _!1+_ y%2
    (,/t,''t _f'y-t),y}
       part[3;10]
    (3 3 4
    3 7
    4 6
    5 5
    10)
       part[1;6]
    (1 1 1 1 1 1
    1 1 1 1 2
    1 1 1 3
    1 1 2 2
    1 1 4
    1 2 3
    1 5
    2 2 2
    2 4
    3 3
    6)
       #:'part[1]'1+!10
    1 2 3 5 7 11 15 22 30 42

    q)part:{t:x _ til 1+ floor y%2;(raze t,''t part'y-t),y}
    q)part[3;10]
    3 3 4
    3 7
    4 6
    5 5
    10
    q)part[1;6]
    1 1 1 1 1 1
    1 1 1 1 2
    1 1 1 3
    1 1 2 2
    1 1 4
    1 2 3
    1 5
    2 2 2
    2 4
    3 3
    6
    q)count each part[1]'[1+til 10]
    1 2 3 5 7 11 15 22 30 42



## 1007. Pascal’s triangle

       pt:{+':0,x,0}
       4 pt\1
    (1
    1 1
    1 2 1
    1 3 3 1
    1 4 6 4 1)
       pt pt pt pt 1
    1 4 6 4 1
       4 pt/1
    1 4 6 4 1

    /not quite the same
    q)pt:{+':[0,x,0]}
    q)pt pt pt pt 1
    0 0 0 0 1 4 6 4 1
    q)4 pt/1
    0 0 0 0 1 4 6 4 1
    q)4 pt\1
    1
    0 1 1
    0 0 1 2 1
    0 0 0 1 3 3 1
    0 0 0 0 1 4 6 4 1

    / this version gives required output
    q)pt:{0+':x,0}
    q)4 pt\ 1
    1
    1 1
    1 2 1
    1 3 3 1
    1 4 6 4 1



## 1008. Polygon area
```k
   area: 0.5*+/{-/y*|x}':
```
The binary `{-/y*|x}` yields the determinant of a 2×2 matrix. The binary `area` yields the area of a polygon whose x-y coordinates are, in order, the rows of a 2-column matrix, where the last row is the same as the first row.
```k
   x:(7 2;10 5;6 8;3 6;4 3;7 2)
   area x
24.5
```


## 1009. Great-circle distance
```k
   gcd:{_cos?(*/_sin x)+(*/_cos x)*_cos[-/y]}
```
The great-circle distance in radians between two points on a sphere whose latitudes in radians are in `x` and longitudes in radians are in `y`.



## 1010. Nautical miles from radians
```k
   nmr:{x*180*60%3.141592653589798238}
```
```q
q)nmr:{x*180*60%3.141592653589798238}
```


## 1011. Degrees from degrees and minutes
```k
   dfdm:{+/x%1 60}
```
```q
q)dfdm:{sum x%1 60}
q)dfdm 60 0
60f
q)dfdm 60 3
60.05
q)dfdm 60 10
60.16667
q)dfdm 60 30
60.5
```


## 1012. Fibonacci numbers
```k
   fn:{x{x,+/-2#x}/0 1}
   fn:{x(|+\)\1 1.0}
```
```q
q)fn:{x{x,sum -2#x}/0 1}
```


## 1013. Tree from depth;value

    tdv:{[d;v](1#v),(c _ d-1)_f'(c:&1=d)_ v}

    q)tdv:{[d;v](1#v),(c _ d-1)tdv'(c:where 1=d)_ v}



## 1014. Depth from tree

       dt:{0,/1+_f'1_ x}

    q)dt:{0,/1+dt'[1_ x]}



## 1015. Value from tree

       vt:{(1#x),/_f'1_ x}
    q)vt:{(1#x),/vt'[1_ x]}
       d:0 1 2 2 1 1
       v:0 1 2 3 4 5
       t:tdv[d;v]
       t
    (0
    (1
    ,2
    ,3)
    ,4
    ,5)
       dt t
    0 1 2 2 1 1
       vt t
    0 1 2 3 4 5

    q)tdv[d;v]
    (0;(1;,2;,3);,4;,5)
    q)dt t
    0 1 2 2 1 1
    q)vt t
    0 1 2 3 4 5

These 3 recursions stop when they run out of data



## 1016. Streak of numbers with same sign

    q)f:{1+(x;0)y}\[1;]differ signum@
    q)n
    2 3 4 -2 -7 1 4 2
    q)f n
    1 2 3 1 2 1 2 3



## 1017. Permutations

      perm:{(1 0#x){,/(.q.rotate 1)\'x,'y}/x}
      perm`a`b`c
    (`a`b`c;`b`c`a;`c`a`b;`b`a`c;`a`c`b;`c`b`a)

    q)perm:{(1 0#x){raze(1 rotate)scan'x,'y}/x}
    q)perm`a`b`c
    a b c
    b c a
    c a b
    b a c
    a c b
    c b a
    q)


Translated from Kevin Lawler's k3 impl.
