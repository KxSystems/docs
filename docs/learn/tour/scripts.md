---
title: Scripting in q | A tour of the q programming language | kdb+ and q documentation
author: Stephen Taylor
date: February 2020
---
# Scripts




Scripts are text files in which you record what you might otherwise type into the q session. 

Load a script with the Load system command `\l` or specify the script as a [command-line option](session.md#command-line-options).

Use scripts to 

-   evaluate expressions that define variables and functions
-   issue system commands, e.g. to load other scripts

In a script you can also write multiline expressions. 
(You cannot do that in the q session.)


## Multiline expressions

Scripts allow you to break over multiple lines expressions that would exceed the maximum line length, or otherwise be awkward to read. 

Continuation lines must be contiguous (no empty lines) and indented by one or more spaces.

`jt.q`:

```q
jt:.[!] flip(
  (`first; "Jacques");
  (`family; "Tati");
  (`dob; 1907.10.09);
  (`dod; 1982.11.05);
  (`spouse; "Micheline Winter");
  (`children; 3);
  (`pic; "https://en.wikipedia.org/wiki/Jacques_Tati#/media/File:Jacques_Tati.jpg") )

portrait:{
  n:" "sv x`first`family;                         / name
  i:.h.htac[`img;`alt`href!(n;x`pic);""];         / img
  a:"age ",string .[-;jt`dod`dob]div 365;         / age
  c:", "sv(n;"d. ",4#string x`dod;a);             / caption
  i,"<br>",.h.htac[`p;.[!]enlist each(`style;"font-style:italic");c] }
```

```q
q)\l jt.q
q)portrait jt
"<img alt=\"Jacques Tati\" href=\"https://en.wikipedia.org/wiki/Jacques_Tati#..
```

[![Jacques Tati](img/jacques-tati.jpg)](https://en.wikipedia.org/wiki/Jacques_Tati#/media/File:Jacques_Tati.jpg "Wikipedia")
<br>
_Jacques Tati, d. 1982, age 75_


!!! warning "Back to the margin"

    Resist the temptation to close a list or function definition with a right parenthesis or brace on the left margin.

    Q would interpret that as the start of a new expression.


## Multiline comments

Scripts allow you to write comments that span multiple lines. 
(There is no way you can do that in the q session.)

Open the comment block with a single forward slash.
Close it with a single backward slash. 

```q
/
  This is a comment block.
  Q ignores everything in it.

  And I mean everything.
  2+2
\
```

Except when closing a comment block, a line with a single backward slash opens a trailing comment block: the interpreter ignores _all_ the subsequent lines. That is, there is no way to close a trailing comment block. 

Below, the expressions that run a script are temporarily relegated to a trailing comment block, allowing the developer to load the script and explore the execution environment.

```q
foo:42
bar:"quick brown fox"

main:{ /main process
  ..
  .. }

\
main[foo;bar]

exit 0
```


## Terminate with exit status

The [`exit`](../../ref/exit.md) keyword terminates the q session and returns its argument as the [exit status](https://en.wikipedia.org/wiki/Exit_status "Wikipedia").

```q
parm:.Q.opt .z.x / command-line parameters

err:{ / validate parameters
  if[not`foo in key args;2 "foo missing";:104];
  if[not`bar in key args;2 "bar missing";:105];
  0 }parm

err:$[err=0;main parm;err]

main:{ / main process
  .. 
  .. }

exit err
```

Above is a script that validates the command-line parameters. If the `foo` or `bar` parameters are missing, messages are written to stderr (`2`) and an error code returned as the exit status. Otherwise the parameters are passed to `main`, which determines the exit status.

