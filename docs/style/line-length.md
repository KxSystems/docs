---
author: Stevan Apter
keywords: kdb+, q, style
---

# How long is a line?



Ideally, a physical line of code contains exactly one q statement, and a q statement encodes exactly one thought. 

Some thoughts are too large or complex to represent in a single readble q statement. Some thoughts are too small or trivial to justify the expenditure of a whole physical line. 

An example of a line which contains several q statements, each of which encodes a small piece of a single thought:

```q
a:x 0; b:x 1; c:x 2; d:x 3; e:x 4
```

!!! note

    Observe how the blanks are used after each semicolon to achieve visual separation. This is legitimate, since whitespace should help us see computational structure. Not so in <pre><code class="language-q">v:m[a; b; ]</code></pre>where the spaces create a visual obstacle.

Sometimes a thought consists of a simple operation on parts whose construction is complicated:

```q
r:(…x 0…;…x 1…;…x 2…;…x 3…)
```

Where the ellipses stand for complicated calculations on the parts of `x`. if the calculations are mutually independent, break the construction of `r` into a set of preliminary steps:

```q
d:…x 3…;
c:…x 2…;
b:…x 1…;
a:…x 0…;
r:(a;b;c;d)
```

A good rule of thumb is that **a line should consist of no more than 50 characters**, including the initial spaces. This leaves room for 40 or 50 characters’ worth of comment.

If your function looks tall and skinny, see whether you’re breaking ideas up into pieces which are too small. If your function looks short and fat, see whether you‘re trying to express more than one idea on each line. 