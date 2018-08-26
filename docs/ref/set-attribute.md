# `#` Set Attribute




Syntax: `x # y`

Where `y` is a list and atom `x` is 

-   an item from the list `` `s`u`p`g ``, returns `y` with the corresponding [attribute](../basics/elements.md#/#attributes) set
-   the null symbol `` ` ``, returns `y` with all attributes removed

```q
q)`s#1 2 3
`s#1 2 3
q)`#`s#1 2 3
1 2 3
```

Setting or unsetting an attribute other than `s` (i.e. `upg`) causes a copy of the object to be made. 

Setting/unsetting the `s` attribute on a list which is already sorted will not cause a copy to be made, and hence will affect the original list in-place. 

Setting the `s` attribute on a dictionary or table, where the key is already in sorted order, in order to obtain a step-function, causes the `s` attribute to be set in place for the key but copies the outer object. 

`s`, `u` and `g` are preserved on append in memory, if possible.
Only `s` is preserved on append to disk.

```q
q)t:([1 2 4]y:7 8 9);`s#t;attr each (t;key t)
``s
```


<i class="far fa-hand-point-right"></i> 
Basics: [Attributes](../basics/elements.md#/#attributes)


