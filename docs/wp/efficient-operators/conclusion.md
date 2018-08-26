---
title: Conclusion
authors: 
    - Conor Slattery
    - Stephen Taylor
date: August 2018
keywords: kdb+, operators, q
---

# Conclusion

This whitepaper provides a summary of the unary operators available in q,
showing how they modify the behavior of different types of functions.

It showed, through the use of examples, that the operation of the derived function is determined by

-   the unary operator
-   the rank of the argument function (for Each, Scan and Over)
-   the rank at the derivative is applied (for binary functions with Each Prior, Scan, and Over)

More elaborate examples with multiple operators can be analyzed wih these rules.

Certain applications of unary operators 
(creating iterating functions, applying operators to functions within select statements) 
were examined in more detail, as these are useful for many tasks, but often poorly understood.
Some common uses were examined to show the ability of unary operators to reduce
execution times.

This whitepaper illustrates how unary operators can extend the functionality of built-in and user-defined functions, allowing code to take full advantage of kdb+’s ability to process large volumes of data quickly.
Correctly using adverbs on data minimizes manipulation, and allows more concise code, which is easier to maintain.

All tests were run using kdb+ V3.1 (2013.08.09)


## Authors

Conor Slattery is a Financial Engineer who has designed kdb+
applications for a range of asset classes. Conor is currently working
with a New York-based investment firm, developing kdb+ trading
platforms for the US equity markets.

Stephen Taylor is the Kx Librarian and the editor of the code.kx.com site.

