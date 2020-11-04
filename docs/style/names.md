---
author: Stevan Apter
keywords: kdb+, q, style
---

# Names



## Names should be easy to type

That is, short, and containing no, or only a very few, shifted characters. 

The Great Divide is between local and global variables. 
<!-- ~~Only global variables can be on the screen. Only global variables can can have attributes such as assignment triggers and dependency definitions.~~  -->
Global variables contain the persistent data and programs 
<!-- ~~, and attributes~~  -->
of your application.

Although every piece of named q data is a variable, we reserve this term for variables whose datatype is not functional. Function-valued variables we call _functions_, leaving context to sort out whether we arem referring to the name, to the variable, or to its data.

In q we use dictionaries in two ways: 

-   as namespaces for functions and variables
-   as symbolically-indexed structured data

Global dictionaries whose names start with a dot are _directories_.
They are used as namespaces. 
For example:

```q
q)\d .stat
q.stat)mean:{(+/x)%count x}
q.stat)vrnc:{avg[x exp 2]-(avg x)xexp 2}
q.stat)stdv:{sqrt var x}
```

Directory names should be as short as can be managed, to minimize the length of the absolute paths. 
The minimum is a dot followed by two characters. 

!!! warning "Directories named with a dot and a single character are reserved for Kx."

We use the term _dictionary_ for local dictionary-valued variables, and for global dictionaries when used as structured data. For example, 

```q
Bond:`tick`coup`mat!(`xyz;9.2;2017.08.15)
```


## Conventions


The following naming conventions are designed to help you write intelligible, compact code. 

object           | names      | examples
-----------------|----------- |---------
directory        | begin with a dot and a lower-case letter | `.bonds:([]`<br>&nbsp;&nbsp;&nbsp;&nbsp;``Tick:`abc`def`ghi;``<br>&nbsp;&nbsp;&nbsp;&nbsp;`Coup:9.4 10.2 6.5;`<br>&nbsp;&nbsp;&nbsp;&nbsp;<code class="nowrap">Mat:2017.08.15 2017.12.01 2018.01.01)</code>
global variable  | begin with an upper-case letter | `Global:10 20 30` 
global constant  | all upper-case | `NUM:"0123456789"`
global functions | begin with a lower-case letter and contain at least three characters | `dlb:{(+/&\x=" ")_ x}`
local variable   | begin with a lower-case letter, and contain one or two characters | `foo:{`<br>&nbsp;&nbsp;`f:count x;`<br>&nbsp;&nbsp;`r:1_ x;`<br>&nbsp;&nbsp;:
local function   | begin with a lower-case letter and contain exactly two characters | `goo:{`<br>&nbsp;&nbsp;`hv:*2;`<br>&nbsp;&nbsp;:

The letters `x`, `y`, and `z` are used exclusively for the first , second, and third arguments to a function. 


## Names with underscores

Use of the underscore character as a separator in multipart names should be avoided, since this will interfere with the commonly used q operator `_`. Phrases such as the following are difficult to read.

```q
a_b _ c_d _ e_f_g
```

If the result is legible, avoid separators altogether.

```q
a:ab _ cd _ efg
```

If you must distinguish the parts of a name, do so by shifting case.

```q
aNameWithParts
```

The only context in which the underscore should occur as part of a name is where that name has an origin outside q; for example, if you are reading a Sybase table into q, and that table contains names with underscores. 


## Names with intermittent uppercase

Long descriptive names are almost always less readable than short ones. Consider the following sequence of ever-shorter names.

```q
deleteLeadingBlanks
deLeadBlns
dlb
```

The first variant is clearly the most meaningful: it conveys unambiguously the effect of the function. The last is completely cryptic: find the documentation, or read the comment for the line in which the function occurs. 

Some programmers think that variant 2 is a good compromise: abbreviate down to just the point where meaning starts to evaporate. (No question: this function deflates lead balloons.)

Now, compare the following two lines.

```q
newString:deleteLeadinBlanks`oldStrings
n:dlb`os          / delete leading blanks from old strings
```

Which is easier to type?  
Which is easier to understand?  
Which is easier to type?  
Which line contains the typo?

Long names make it hard to see syntactic structure, which contributes as importantly to the meaning of an expression as does the ‘meaning’ of a single function or an individual piece of data. Long names also make it hard to see typos, since any twelve-character names looks much like itself minus one letter. (Which is why proof readers get paid – say, did you find _both_ typos in the last example?)

**If it is important you’ll type it a lot.  
If you type it a lot, it should be short.**


## Prevention of cruelty to vowels

Some programmers try to reduce typing and keep their code descriptive by purging all or most vowels from long names, together with those consonants which seem redundant. For example, the path

```q
slstrk.posn.Tbl.NwBlnc
```

is almost certainly the result of performing a vowelectomy on

```q
salestrack.position.Table.NewBalance
```

37 characters worth of name reduced to 23: 35% shorter, without loss of meaning. How could this fail to be a Good Thing?

While the first name is shorter, it is definitely harder to type than the unabbreviated form. Convince yourself of this by typing both names from memory four or five times at normal typing speed. the chances are good that you will mistype the first name more often than the second. That fact alone should warn us off the practice.

!!! tip "Use names made of either"

    -   a single letter
    -   a single syllable
    -   the first letter of each word that describes the object.

    For example: <pre><code class="language-q">st.pos.Tab.New</code></pre>

Typing accuracy as well as typing speed is at stake here. Sometimes we are actually compelled to work together face-to-face, in which case we rely on speech rather than email to convey information. We should not spend a lot of time having to explain how things are spelled, or which letters in a name are upper-case, or which vowels didn’t get dropped and which consonants did. 

Practice the folowing typing instructions with a friend:

s l s t r k dot p o s n dot capital t bl dot capital n e w capital b lnc

salestrack dot position dot capital t table dot new capital b balanace

s t dot pos dot capital t tab capital n new

**A name that is easy to pronounce is easy to remember and easy to type.**

