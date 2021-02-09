---
author: Stevan Apter
keywords: kdb+, q, style
---

# Comments



**Comment every line** of a q function, keeping code and comment on the same line. 

**Align the comments** for ease of reading.

**Indent the comment block** to mirror that of the function.

```q
sendLeft:{                      / update from left to right links at x=_i
  s:get[_v;`G]                  /   absolute source field name
  h:(::;*:)?get[_v;`H]          /   0 (::) or  1 (*:)
  j:enlist@x                    /   itemwise index
  p:.[att[_d;`J];undot s]       /   left link partition
  i::[h;p j;p . x]              /   index map into right table
  d::[h;_v j;_v . x]            /   first (*:) or all (::)
  @[s;i;:d]                     /   update source field
}
```

<small>_A function in an early version of k: the comments now even more valuable than before_</small>
<!-- FIXME replace with q function of comparable substance. -->


## Conventions for comments

line | comment
-----|---------
Local assignment | Describe the meaning or the role of the variable.
Side effect | Use the [imperative mode](https://en.wikipedia.org/wiki/Imperative_mood), indicating the action performed. 
Control structure | Describe the meaning of the condition or loop.

**Document ‘dangerous curves’ in ALL CAPS, or use some other eye-catching device.**


## Header comments

How to comment the header of a q function is a matter of some controversy. 

We recommend treating the header as just another line in the function, with this one difference: the comment should describe the meaning of the function as a whole. 

Some programmers believe the header comment should contain standardized information about the function as a whole. 

```q
sendLeft:{
  / ds: update from left to right link
  / ts: sjt 2017.08.13
  / x:  +i or _n if _i is ()
  / rs: none
  / gr: _v
  :
```

The header comment block contains a function description, author and timestamp data, argument and result documentation, and information about which global variables are read and set. Unfortunately, this style tends to bloat functions with non-executable lines. Recall that the typical q function contains but five lines.


## Help dictionary

The same information could be packed into a help dictionary for the function.

```q
\d sendLefth
ds:"update from left to right link"
ts:"sjt 2017.08.13"
x:"+i or _n if _i is ()"
rs:"none"
gr:"_v"
```

Any q variable (and functions are just variables) can have a help dictionary, which then can be displayed or inspected. This is consistent with q’s general approach to the constructs of programming: if it matters, make it first-class. (Eventually this form of help could be directly supported by q’s interactive debugger.) 


