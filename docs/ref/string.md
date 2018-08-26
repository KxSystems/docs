# `string`


Syntax: `string x`, `string[x]`  
Syntax: `($)x`, `$[x]` (deprecated)

Returns each item in list or atom `x` as a string; applies to all data types.
```q
q)string `ibm`goog
"ibm"
"goog"
q)string 2 7 15
,"2"
,"7"
"15"
q)string (2 3;"abc")
(,"2";,"3")
(,"a";,"b";,"c")
```
It applies to the values of a dictionary, and the columns of a table:
```q
q)string `a`b`c!2002 2004 2010
a| "2002"
b| "2004"
c| "2010"
q)string ([]a:1 2 3;b:`ibm`goog`aapl)
a    b
-----------
,"1" "ibm"
,"2" "goog"
,"3" "aapl"
```


## Domain and range 
```
domain b g x h i j e f c s p m d z n u v t
range  c c c c c c c c c c c c c c c c c c
```
Range: `c`


<i class="far fa-hand-point-right"></i> [`.h.iso8601`](doth/#hiso8601-iso-timestamp), [`.Q.addr`](dotq/#qaddr-ip-address) (IP address), [`.Q.f`](dotq/#qf-format) (format), [`.Q.fmt`](dotq/#qfmt-format) (format)


