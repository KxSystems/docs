---
author: Stevan Apter
keywords: kdb+, q, style
---

# SAM: A simple application model



<!-- FIXME
Keep or toss?
 -->


SAM is an abstract model of q applications. Think of SAM as having an inner core and an outer layer.

The inner core of SAM consists of variables and constants interconnected by 
<!-- ~~functional dependencies and triggers~~  -->
views.
All functions, and all 
<!-- ~~dependencies~~  -->
views expressed in terms of them are completely free of side effects. 
All side effects in the core are explictly located in 
<!-- ~~triggers~~  -->
views. 
Changes in the state of the core happen only as the result of activity in the outer layer, which in turn is restricted to the form of

variable assignments
: caused by set messages from other processes (including real-time feeds)

<!--     -   ~~window edits~~
    -   ~~radio box check button events~~
    -   set messages from other processes (including real-time feeds)
 -->
code execution
: caused by close callbacks

<!--     -   ~~button presses~~
    -   ~~click and double-click events~~
 -->
Moreover, 

variable assignments 
: only

    -   invalidate other variables
    -   fire triggers

and

code execution
: only 

    -   assigns variables
    -   sends messages to other processes

