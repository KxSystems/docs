# ' Case



_Pick successive items from multiple list arguments: the left argument of the extender determines from which of the arguments each item is picked._

Syntax: `x'[a;b;c;…]`  

Where 

-   `x` is an integer vector
-   $args$ `[a;b;c;…]` are the arguments to the extension

the extension `x'` returns $r$ such that 
$r_i$ is ($args_{x_i})_i$

![case](../img/case.png)

The extension `x'` has rank `max[x]+1`. 

Atom arguments are treated as infinitely-repeated values.
```q
q)0 1 0'["abc";"xyz"]
"ayc"
q)e:`one`two`three`four`five
q)f:`un`deux`trois`quatre`cinq
q)g:`eins`zwei`drei`vier`funf
q)l:`English`French`German
q)l?`German`English`French`French`German
2 0 1 1 2
q)(l?`German`English`French`French`German)'[e;f;g]
`eins`two`trois`quatre`funf

q)/extra arguments don't signal a rank error
q)0 2 0'["abc";"xyz";"123";"789"]
"a2c"
q)0 1 0'["a";"xyz"]  /atom "a" repeated as needed
"aya"
```

You can use Case to select between record fields according to a test on some other field. 

Suppose we have lists `h` and `o` of home and office phone numbers, and a third list `p` indicating at which number the subject prefers to be called. 

```q
q)([]pref: p;home: h; office: o; call: (`home`office?p)'[h;o])
pref   home             office           call
---------------------------------------------------------
home   "(973)-902-8196" "(431)-158-8403" "(973)-902-8196"
office "(448)-242-6173" "(123)-993-9804" "(123)-993-9804"
office "(649)-678-6937" "(577)-671-6744" "(577)-671-6744"
home   "(677)-200-5231" "(546)-864-5636" "(677)-200-5231"
home   "(463)-653-5120" "(636)-437-2336" "(463)-653-5120"
```

<i class="far fa-hand-point-right"></i> 
[Extenders](extenders.md)


