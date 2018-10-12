# Fast loads


==TODO: Translate to q.==


**Loads should take no time.**

Suppose you write a script `a.k` which involves an expensive initialization, say by means of a synchronous request for data from a server:
```k
.A:(`server;1234) 4:(`retrieve;)
```
You mean to load `a.k` from within the application `b.k`, which looks like this:
```k
\l a
\d .B
Show:"`show $ `.A"
Show..c:`button
\d ^
`show $ `B
```
but now `b` takes too long to come up.

So now you decide to improve things by having `Show` load the `a` script:
```k
Show:".\"\\1 a"
```
This is wrong. Instead, modify the `a` script by moving the retrieval code into a function:
```k
\d .a
retrieve:{(`server;1234`) 4:(`retrieve;)}
```
and changing the definition of `Show` in `b.k`:
```k
\l a
\d .B
Show:"`show$.[`.A;();:;.a.retrieve[]]"
…
```


