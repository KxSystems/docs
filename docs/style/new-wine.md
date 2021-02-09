---
author: Stevan Apter
keywords: kdb+, q, style
---

# New wine for old bottles


The following rules appear in Kernighan & Plauger’s _The Elements of Programming Style_, second edition, NY: McGraw-Hill, 1978.

-   Write clearly – don’t be too clever.

-   Say what you mean, simply and directly.
-   Use library functions.
-   Avoid temporary variables.
-   Write clearly – don’t sacrifice clarity for ‘efficiency’.
-   Let the machine do the dirty work.
-   Replace repetitive expressions by calls to a common function.
-   Parenthesize to avoid ambiguity.
-   Choose variable names that won’t be confused.
-   Avoid the Fortran arithmetic `IF`.
-   Avoid unnecessary branches.
-   Use the good features of a language; avoid the bad ones.
-   Don’t use conditional branches as a substitute for a logical expression.
-   Use the ‘telephone test’ for readability.

-   Use `DO-END` and indenting to delimit groups of statements.
-   Use `IF-ELSE` to emphasize that only one of two actions is to be performed. 
-   Use `DO` and `DO-WHILE` to emphasize the presence of loops.
-   Make your programs read from top to bottom.
-   Use `IF…ELSE IF…ELSE IF…ELSE …` to implement multi-way branches.
-   Use the fundamental control flow constructs. 
-   Write first in an easy-to-understand pseudo-language; then translate into whatever language you have to use.
-   Avoid `THEN-IF` and null `ELSE`.
-   Avoid `ELSE GOTO` and `ELSE RETURN`.
-   Follow each decision as closely as possible with iots associated action.
-   Use data arrays to avoid repetitive control sequences.
-   Choose a data representation that makes the program simple.
-   Don’t stop with your first draft.

-   Modularize. Use subroutines.
-   Make the coupling between modules visible.
-   Each module should do one thing well.
-   Make sure each module hides something.
-   Let the data structure the program.
-   Don’t patch bad code – rewrite it.
-   Write and test a big program in small pieces.
-   Use recursive procedures for recursively-defined data structures.

-   Test input for validity and plausibility.
-   Make sure input cannot violate the limits of the program.
-   Terminate input by end-of-file or marker, not by count.
-   Identify bad input; recover if possible.
-   Treat end-of-file conditions in a uniform manner.
-   Make input easy to prepare and output self-explanatory.
-   Use uniform input formats.
-   Make input easy to proofread.
-   Use freeform input whenever possible.
-   Use self-identifying input. Allow defaults. Echo both on output.
-   Localize input and output in subroutines. 

-   Make sure all variables are initialized before use.
-   Don’t stop at one bug.
-   Use debugging compilers.
-   Initialize constants with `DATA` statements or `INITIAL` attributes; initialize variables with executable code.
-   Watch out for off-by-one errors.
-   Take care to branch the right way on equality.
-   Avoid multiple exits from loops.
-   Make sure your code ‘does nothing’ gracefully.
-   Test programs at their boundary values.
-   Program defensively.
-   10.0 times 0.1 is hardly ever 1.0.
-   Don’t compare floating-point numbers just for equality. 

-   Make it right before you make it faster.
-   Keep it right when you make it faster.
-   Make it clear before you make it faster.
-   Don’t sacrifice clarity for amll gains in ‘efficiency’.
-   Let your compiler do the simple optimizations.
-   Don’t strain to re-use code; re-organize instead.
-   Make sure special cases are truly special.
-   Keep it simple to make it faster.
-   Don’t diddle code to make it faster – find a better algorithm.
-   Instrument your programs. Measure before making ‘efficiency’ changes.

-   Make sure comments and code agree.
-   Don’t just echo the code with comments – make every comment count.
-   Don’t comment bad code – rewrite it.
-   Use variable names that mean something.
-   Use statement labels that mean something.
-   Format a program to help a reader understand it.
-   Indent to show the lgical structure of your program. 
-   Document your data layouts.
-   Don’t over-comment.

