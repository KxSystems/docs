# Casting and encoding


Casting converts data from one representation to another.

function  | semantics
----------|----------------------------------------------
`$`       | [Cast](../ref/cast.md) between datatypes
`$`       | [Tok](../ref/tok.md): interpret string as value
`!`       | [Enumeration](../ref/enumeration.md)
`string`  | [cast to character](../ref/string.md)
`sv`      | [decode](../ref/sv.md) to integer
`vs`      | [encode](../ref/vs.md) 

<!-- 
## `\:` (int to byte)

Syntax: `0x0\:x`

Where `x` is an int.
```q
q)0x0\:1234605616436508552
0x1122334455667788
```

==FIXME Signals `'\:`==

 -->

