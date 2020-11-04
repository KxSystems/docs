---
author: Stevan Apter
keywords: kdb+, q, style
---

# How many arguments should a function have?



One of the most interesting properties of the q language is that function application is itself a function. [Apply](../ref/apply.md) takes a function on the left and a list of arguments on the right, and applies the function to the list, mapping each item of the list to the corresponding argument of the function. 

Used properly, this is a wonderfully convenient feature, since functions can be designed to apply to many small, named things, which are themselves parts of a list or dictionary. Keeping the parts in a composite data structure is good for organizational reasons. Designing the function to see those parts as separate, named entities reduces code and improves readability.

For example, suppose that `v` is a list of five heterogeneous items, and `f` is a function which re-arranges those items. 

```q
v:(12;`xyz;"abc";1.1;10 20 30)
f:{[i;s;c;r;l] (s;c;i;l;r)}
```

Application of `f` to `v` serially maps the items of `v` to the arguments of `f`. 

```q
q)f . v
(`xyz;"abc"12;10 20 30;1.1)
```

Compare `f` with the unary list functions `g` and `h`:

```q
g:{x[1 2 0 4 3]}        / what?

h:{
  i:x 0; s:x 1; c:x 2; r:x 3; l:x 5;
  (s;c;i;l;r)           / why?
  }
```

Good function design is the outcome of taking multiple perspectives on functionality: 

-   from within the function, we want the data already decomposed and ready for processing; 
-   from outside, the function is a node in a network of calculation routines, and we strive for uniformity and simplicity. 

Balance these competing forces. 

**Design functions with meaningful arguments.**