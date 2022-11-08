---
author: Stevan Apter
keywords: kdb+, q, style
---

# Use of braces


A function containing one statement which returns a result:

```q
foo:{x+y}
```

A function containing many statements which returns a result:

```q
foo:{
  a:first x;
  b:last x;
  a+b}
```

**A multi-line function which does not return a result should always end with an isolated brace.**

```q
foo:{
  Sum::x+y;
  Prod::x*y;
  }
```

A function with one line which does not return a result can be written on a single line, using a semicolon.

```q
foo:{Sum::x+y;}
```

but consistent use of the isolated brace to mean _no result_ suggests we write:

```q
foo:{
  Sum::x+y;
  }
```

