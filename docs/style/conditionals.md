---
hero: <i class="fas fa-pen-nib"></i> Remarks on Style
author: Stevan Apter
keywords: kdb+, q, style
---

# The right conditional


Q has two forms of conditional evaluation: `$` and `if`. The following rules help you write code where useful information is conveyed by your choice of conditional.

`$[]` has the structure:

```q
r:$[cond1;
  true1;
  …
  condN;
  trueN;
  false]
```

`if` has the structure:

```q
if[cond;
  true1;
  …
  trueN]
```

**Use `if` when side effects are desired.**

For example, to assign default values to the arguments of a function:

```q
foo:{
  if[x~::;x:101];
  …
  }
```


## If-then-else

Although `if` does not support if-then-else logic, it should be used even when that logic is required but where side effects are intended:

```q
if[b:x>5;foo[x]];
if[not b;goo[x]];
```

and not:

```q
$[x>5;foo[x];goo[x]]
```

**Use `$` only when a result is desired.**

```q
s::$[x~::;til y;enlist y]
```


## Testing 

Use `if` when testing, to return from a function with an explicit result.

```q
foo:{
  if[()~x;:0]
  …
  }
```

Reverse the condition when the function can return null.

```q
goo:{
  if[not()~x;
  …
  }
```

Use `if`, not `$[]`, when signalling from within a function.

```q
if[x=0;'"cannot be zero"];
```

Consistent use of `if` and the conditional will make your code more readable: 

-   seeing `if` you know that a side effect is sought and a result is not; 
-   seeing `$[]`, you know that a result is intended unconditionally.


