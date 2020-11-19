---
author: Stevan Apter
keywords: kdb+, q, style
---

# Preface

![Remarks on Style](img/qros.png)

_Stevan Apter’s classic [“K: Remarks on Style”](http://www.nsl.com/papers/style.pdf), adapted for q._ 
{: style="font-size: .9em; margin-bottom: 5em" markdown="1"}



Most of us recognize ‘stylish’ code when we see it, even though we may be unable to say, in general, what good style is, or even whether there is any one way to achieve it. 

**Stylish programming shows the author’s concern to write code that is transparent, consistent, direct and readable.** 

The care taken to make code stylish is one aspect of writing ‘good code’: programs which are small, fast, and extensible.

This document – a collection of remarks , observations, advice, rules, and models – is intended to be the nucleus for a proper manual of q style. 
The hope is that q programmers will find the project sufficiently interesting to think through the consequences of their current practices and try to articulate the principles on which those practices are based. 

:fontawesome-regular-hand-point-right: 
[“Three Principles of Coding Clarity”](http://archive.vector.org.uk/art10009750)

We have not sought to group the material under fixed chapter headings: that would be premature. Instead, it is just one remark after another. 

Kernighan & Plauger, in their classic paper on [“The Elements of Programming Style”](http://www2.ing.unipi.it/~a009435/issw/extra/kp_elems_of_pgmng_sty.pdf), organize issues of style under seven headings: expression, control structure, program structure, input/output, common blunders, efficiency and documentation. 

In the 1970s, addressing an audience of mainframe Fortran programmers, this way of dissecting the components of programming style had much to recommend it. For us, the emphasis is distributed differently. Some wholly new problems have arisen, and some, which once appeared central to the business of programming, now seem to be artifacts of the languages then used. As examples of the first class, consider: client-server interaction, GUI control, timing problems, and programming with lists and arrays. And as examples, of the second, much mental effort was expended on the proper way to process files, write loops, and branch within a program. 

At the end, we reproduce (without comment) the complete set of style rules from Kernighan & Plauger.
A later version may summarize whatever rules survive winnowing by the programming community. 