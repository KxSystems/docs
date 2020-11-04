---
author: Stevan Apter
keywords: kdb+, q, style
---

# Internal assignment




Internal assignments can make code hard to read, especially if there’s a lot of it. For example, in the following line

```q
i:where(k>v@y)&(k:til s)<first(1+y)_ v,s:count n
```

there are internal assignments of `k` and `s`.

Internal assignments should never span lines. That is, the value should be read only on the line on which it is set. In the example above, `k` and `s` should be temporary assignments on the way to computing `i`. If q had a _with_ clause, we would write this differently:

```q
i:where(k>v@y)&k<first(1+y)_ v,s with k:til s with s:count n
```

The aim of this line is to construct `i`. Rather than compute `count n` three times, and `til count n` twice, we snarf these values into temporaries the first time they are computed. 

If `k` and `s` are to be read on subsequent lines, they should be assigned in their own statements:

```q
s:count n;
k:til s;
i:where(k>v@y)&k<first(1+y)_ v,s;
…
```

Now the reader can scan the left edge of the function text and find all non-temporary assignments.

Test your code by mentally drawing arrows from each assignment to each use of the name assigned. 

-   Arrows should never go up or to the right: that means you’re re-using a name. 
-   Arrows going down should always originate at the left edge of a line. 
-   Arrows going left are temporaries, and should never also go down. 

It’s a good idea to pick one or two letters for the purpose of temporary assignment, and use them constantly and exclusively for this purpose. (`t` and `u` are good. And if you do so, then modify the arrow test above to allow for re-use of those names on successive lines.)


:fontawesome-regular-hand-point-right: 
[Three Principles of Coding Clarity](http://archive.vector.org.uk/art10009750): The first principle: shorten lines of communication