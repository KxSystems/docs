---
author: Stevan Apter
keywords: kdb+, q, style
---

# Engine design



## Goodbye world

Design the engine independently of the screen.
The engine is a system of variables, constants and pure functions. Pay no attention to screens, file I/O, real-time feeds, etc. Deal with those components later. In q, this is easy, since in the final analysis the engine is able to ‘see’ only other variables on the K tree. So you might as well develop the engine entirely in the context of variables and worry later about how, when, and how often those variables get populated by external agents.


## Factor into functional relationships

Factor the engine into functional relationships between the variables which will hold the data for your application. 
For example, a simple calculator consists of 

-   a set of input variables;
-   a set of output, or result, variables; and
-   a set of functional relationships between inputs and outputs.

Decide on the proper data structures for inputs and outputs (atoms, or lists, integers or reals, etc.) and design and implement your functions accordingly. Now is also the right time decide on names for things, and on how variables and functions are to be ancapsulated. Some questions to ask are:

-   Will I ever need more than one instance of X?
-   Can X ever go to empty?
-   What is the default state of X?
-   Is X an instance of a more general kind of thing Y?


## Expect correct data

Design the functional components to expect correct data. 
Don’t waste time writing code to handle bad or incomplete data. Push the buck for this job up or out a level. Expect that by the time a function is called, the data will be filtered, defaulted-out correctly, etc. 
For example, don’t pollute a function which expects a list by having it convert atoms to one-element lists. Defer responsibility for that to whoever calls the function. 

Don’t trap errors unless there is a compelling reason to do so.
For example, don’t provide for division by zero unless the data can logically _be_ zero. Plan to trap errors as high in the calling tree as you can.


## Keep data structures simple

Don’t design elaborate result structures with error codes and messages.
For example, don’t design your functions to return lists in which the first element is a return code, and the second the data or a message – a popular but wrong-headed strategy. Emulate the q primitives, which signal errors. 

Don’t over-design data structures. For example, don’t use a dictionary of atoms where a list will do. Higher-level routines can always be written to convert more complicated forms of data into the simple forms the engine requires. 


## Be skeptical about tools

Don’t design tools prematurely, or with too general a purpose in mind. Keep the tools as simple as the application requires. Don’t spend too much time developing the tool set. 

Most tools contain functionality which is never used. Avoid using tools which are too heavy for the job in hand. Don’t overpopulate the tree with utility functions and variables which your application [will not use](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it "Wikipedia: You aren’t going to need it"). 

:fontawesome-brands-youtube: 
[The design of Software Tools](https://www.youtube.com/watch?v=qSVR4Z3DA24): A developer pleads for simple tools 

If you want one tool out of a pre-packaged set of twenty, extract that tool and tuck it into your application. If you want a single piece of functionality built into a larger system, consult the author and learn how to implement it yourself. Remember that in q, ideas are worth more than code. 


!!! important "Minimize the number of moving parts."