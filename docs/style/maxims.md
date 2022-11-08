---
author: Stevan Apter
keywords: kdb+, q, style
---

# Maxims




## Style improves with knowledge of the language

The more q you know, the less code you will need to write. Q has been designed to simpify many of the tasks routinely required in writing distributed event-driven applications. Stay alert for code that feels ‘wrong’. 

Expect q to provide a simple solution to what seems like a simple problem. 


## Program with, and not against, the grain of the language

For example, q provides two notations for constructing a list:

```q
1 2.2 3          / real vector
(1;2.2;3)        / list of integers and reals
```

Vector notation is used to create structures of atoms of the same type. List notation is more general, and can be used to create lists whose items are arbitrary q data. Vector notation requires less typing. Vectors have the most efficient forms of storage. And vectors compute faster than general lists. Q nudges you in the direction of efficiency by making efficient structures easier to create than inefficient ones.

Seek to apply this to your own designs. 


## Seek opportunities to throw away code

A fact to bear in mind is that all of q is contained in 4,000 lines of C code. That figure encompasses the language as well as all the code for the interprocess communications (IPC), object-file management, and operating-system interaction. 

Q’s freedom from bugs is not unrelated to the high degree of compression achieved in the source code. 