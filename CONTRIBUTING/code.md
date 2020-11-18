---
title: Code blocks | Style Guide | Style | About | kdb+ and q documentation
description: Usage and markup rules for code blocks
author: Stephen Taylor
keywords: 
---
# :fontawesome-solid-pen-nib: Code blocks


Code blocks aim as far as practically possible for visual fidelity, mimicking what the reader sees in a script or session. 

Code is displayed on the developer site to help the reader’s understanding. (It might reasonably look quite different in a production environment.) 

Q code blocks are of three kinds: 

type    | content
--------|--------
output  | Output only: requires no syntax highlighting. Mark the opening code fence as `txt`.
script  | Definitions and executable expressions only: no output
session | Executable expressions and output, distinguished by `q)` prompts

Session blocks mimic the [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop "Wikipedia") and, like the REPL, use `q)` prompts to distinguish input from output.

Label the opening of every code block with its language type. If none, use `txt`.



## Long lines

A code block does not wrap long lines, but produces a horizontal scroll bar to display lines longer than about 70 characters. Avoid that.

-   Recast a long code line to two or more shorter ones
-   In a script block, wrap the line and use indentation and line breaks to clarify its structure
-   Truncate wide output from column 70 unless the content to the right is essential to the point being made

Consider using temporary variables to recast a long line as multiple lines.


## Multiline expressions and lambdas

Multiline expressions and function definitions are best displayed in script blocks. Use empty lines to separate them from what precedes and follows them. 

Indent function lines in multiples of two spaces. Where opening and closing braces are on different lines, horizontally align the closing bracket or brace with the left edge of the line on which the opening bracket or brace is found **except** in closing a multiline function.

!!! note "Closing a multiline function" 

    Place the closing brace of a function defined in a script (not local to another function definition) at the end of the last line. 
    Precede it with a space. 

    Some text editors will left-align a closing brace orphaned on its own line, breaking the script.

Terminate expressions in a function with semicolons, excepting the last if it defines the result to be returned. Do not use semicolons to terminate expressions in a session block; nor definitions in a script block. 

Follow a script block with a session block in order to show output from a multiline function. E.g.

```q
/ script block: definitions
bar:{10+x%y}

foo:{[x;y;z]
  a:bar[x;y];
  b:{[x;y]
    ..;
    ..
  }[a;3];
  y xexp b }
```
```q
q)/session block: input and output
q)fubar["abc";trades]
c0                                   c2        c4       c6         c8
---------------------------------------------------------------------..
ee3694e6-b552-c0d9-a665-d1d1973e8e19 `mibabdan 3.977203 2002.04.24 0D..
1bf59ad1-a00b-94a6-52a5-f008d1186808 `ijincbbc 1.097637 2017.01.16 0D..
b814b3f7-51d0-284d-0045-22b137c978f2 `mopddnfc 3.023156 2012.06.21 0D..
23fe2357-3334-22f6-bd87-1945662719f2 `ndnlddge 3.887816 2009.01.02 0D..
28593b83-52d7-c48b-1cce-6bdde34bba4f `ojcobeaj 3.797913 2013.08.15 0D..
```


## Long queries

Queries are often longer than 70 characters. Better to wrap them, breaking visual fidelity, rather than repeatedly alternate script and session blocks. 

In session blocks indent wrapped queries in multiples of four spaces to mark the distinction from script blocks. E.g.

```q
q)select 
    firstTime:min time, 
    firstHoursTime:min time where extime within flip dr2t[([]date;sym)] 
    by date, sym 
    from rtrade 
    where date=d, sym in `FDP1`FDP2`FDP3 
date       sym  | firstTime    firstHoursTime
----------------| ---------------------------
2013.04.22 FDP1 | 08:03:42.113 13:30:00.023 
2013.04.22 FDP2 | 10:57:30.935 14:30:02.532 
2013.04.22 FDP3 | 08:29:58.950 15:30:17.567
```


## Code fences

Use code fences, not indentation, to mark code blocks. Suffix the opening fence with the lower-case name of the code language. For example,

<pre><code class="language-markdown">
&#096;&#096;&#096;q
q)til 3
0 1 2
&#096;&#096;&#096;
</code></pre>


## Child code blocks

Where a code block is a child of a list item or an admonition, indent it to mark its parentage. This will break the Prism JavaScript that highlights syntax, so it is necessary to replace the backtick code fences with HTML elements. For example, to put the code block above within a list item:

<pre><code class="language-markdown">
&#060;pre&#062;&#060;code class="language-q"&#062;
q)til 3
0 1 2
&#060;/code&#062;&#060;/pre&#062;
</code></pre>

