---
title: Linear programming – Knowledge Base – kdb+ and q documentation
description: Some applications of kdb+ to linear-programming problems
author: Rob Hodgkinson
keywords: apl, iverson, kdb+, linear programming, q
---
# Linear programming


_Linear Programming is a large topic, of which this article reviews just a few applications. More articles on it would be very welcome: please contact librarian@kx.com._

!!! note "Iverson Notation and linear algebra"
    [![Ken Iverson](../img/kei01.jpg)](https://en.wikipedia.org/wiki/Kenneth_E._Iverson "Wikipedia: Kenneth E. Iverson")
    Q is a descendant of the notation devised at Harvard by the [Turing Award](https://en.wikipedia.org/wiki/Turing_Award) winner, mathematician [Ken Iverson](https://en.wikipedia.org/wiki/Kenneth_E._Iverson), when he worked with [Howard Aiken](https://en.wikipedia.org/wiki/Howard_H._Aiken) and Nobel Prize winner [Wassily Leontief](https://en.wikipedia.org/wiki/Wassily_Leontief) on the computation of economic input-output tables. At Harvard, Ken Iverson and fellow Turing Award winner [Fred Brooks](https://en.wikipedia.org/wiki/Fred_Brooks) gave the world’s first course in what was then called ‘data processing’.

    Like other descendants of Iverson Notation (e.g. [A+](http://www.aplusdev.org/index.html), [APL](https://en.wikipedia.org/wiki/APL_(programming_language)), [J](https://en.wikipedia.org/wiki/J_(programming_language))), q inherits compact and powerful expression of linear algebra. 

    Q Math Library: :fontawesome-brands-github: [zholos/qml](https://github.com/zholos/qml)

    :fontawesome-solid-camera: [Ken Iverson & Arthur Whitney, APL89, New York City](../img/keiandatw89.png "photo courtesy Rob Hodgkinson")




## Problem

Given a series of nodes and distances, find the minimum path from each node to get to each other node.


## Solution

Edsger W. Dijkstra published an optimized solution in 1959 that calculated cumulative minimums.
A simple Linear Algebra approach entails producing a ‘path connection matrix’ (square matrix with nodes down rows and across columns) showing the distances, which is typically symmetric.
Inner product is used in repeated iterations to enhance the initial matrix to include paths possible through 1 hop (through 1 intermediate node), 2 hops and so forth by repeated calls.
The optimal solution (all paths) is found by iterating until no further changes are noted in the matrix (called _transitive closure_).

## Example

Here is a simple case for just 6 nodes and the distances between connected nodes.

```q
q)node6:`a`b`c`d`e`f
q)bgn:`a`a`a`b`b`b`b`d`d`e`e`f`f`f
q)end:`b`d`c`a`d`e`f`a`e`d`f`b`c`e
q)far:30 40 80 21 25 16 23 12 30 23 25 17 18 22
q)show dist6:flip `src`dst`dist!(bgn;end;far)
src dst dist
------------
a   b   30
a   d   40
a   c   80
b   a   21
b   d   25
b   e   16
b   f   23
d   a   12
d   e   30
e   d   23
e   f   25
f   b   17
f   c   18
f   e   22
```

First, transform the above table into a connectivity matrix of path lengths. 

!!! note "Symmetry"

    In this example a->b can differ from b->a, which is more general than the problem requires, but you could make the matrix symmetric for real distances.

For ‘no connection’ we use infinity, so the inner product of cumulative minimums works properly over the iterations.

```q
q)cm[node6;dist6;`inf]
0  30 80 40 0w 0w
21 0  0w 25 16 23
0w 0w 0  0w 0w 0w
12 0w 0w 0  30 0w
0w 0w 0w 23 0  25
0w 17 18 0w 22 0
```

`cm` is a simple function to produce the connectivity matrix. 

-   `cm` creates a connectivity matrix from nodes and a distance table.
-    Result is a square float matrix where a cell contains distance to travel between nodes.
-    An unreachable node is marked with the infinity value for minimum path distance. (Or 0 for credit matrix – see below).

```q
cm:{[n;d;nopath]
  nn:count n;                         / number of nodes
  res:(2#nn)#(0 0w)`zero`inf?nopath;  / default whole matrix to nopath
  ip:flip n?/:d`src`dst;              / index pairs
  res:./[res;ip;:;`float$d`dist];     / set reachable index pairs
  ./[res;til[nn],'til[nn];:;0f]       / zero on diagonal to exclude a node with itself
  }
```

!!! tip "Assignment with a scattered index"

    The last two lines of `cm` both use `./` for assignment with a _scattered index_. The second argument is a list of index pairs – co-ordinates in `res`. The fourth argument is a corresponding list of values. The third argument is the assignment function. 

    :fontawesome-regular-hand-point-right: [Over](../ref/accumulators.md) for how the iterator `/` specifies the iteration here.


`tview` adds row and column labels.
```q
tview:{[mat]
  $[(`$nodes:"node",string[count mat])in key `.;
    nodes:value nodes;
    nodes:`$string til count mat];
  ((1,1+count nodes)#`,nodes),((count[nodes],1)#nodes),'mat
  }
```

To improve the display of the connection matrix:

```q
q)tview cm[node6;dist6;`inf]
   a   b   c   d   e   f
`a 0f  30f 80f 40f 0w  0w
`b 21f 0f  0w  25f 16f 23f
`c 0w  0w  0f  0w  0w  0w
`d 12f 0w  0w  0f  30f 0w
`e 0w  0w  0w  23f 0f  25f
`f 0w  17f 18f 0w  22f 0f
```

In the above result note that `[a;e]` is not directly accessible.
So we use a bridge function to jump through one intermediate node and see new paths.

```q
q)tview bridge cm[node6;dist6;`inf]
   a   b   c   d   e   f
`a 0f  30f 80f 40f 46f 53f
`b 21f 0f  41f 25f 16f 23f
`c 0w  0w  0f  0w  0w  0w
`d 12f 42f 92f 0f  30f 55f
`e 35f 42f 43f 23f 0f  25f
`f 38f 17f 18f 42f 22f 0f
```

We now see a path `[a;e]` of 46, \[a->b(30), then b->e(16)\].
After 1 hop we also see path `[d;c]` of 92, \[d->a(12), then a->c(80)\].

`bridge` applies connectivity over each hop by using a Minimum.Sum inner product cumulatively:

```q
q)bridge
{x & x('[min;+])\: x}
```

So for 2 hops:

```q
q)tview bridge bridge cm[node6;dist6;`inf]
   a   b   c   d   e   f
`a 0f  30f 71f 40f 46f 53f
`b 21f 0f  41f 25f 16f 23f
`c 0w  0w  0f  0w  0w  0w
`d 12f 42f 73f 0f  30f 55f
`e 35f 42f 43f 23f 0f  25f
`f 38f 17f 18f 42f 22f 0f
```

Note with 2 hops we improve `[d;c]` to 73 [d->e(30), then e->f(25), then f->c(18)]:

For ‘transitive closure’ iterate until no further improvement (i.e. optimal path lengths reached)

```q
q)tview (bridge/) cm[node6;dist6;`inf]
   a   b   c   d   e   f
`a 0f  30f 71f 40f 46f 53f
`b 21f 0f  41f 25f 16f 23f
`c 0w  0w  0f  0w  0w  0w
`d 12f 42f 73f 0f  30f 55f
`e 35f 42f 43f 23f 0f  25f
`f 38f 17f 18f 42f 22f 0f
```

A larger example was presented in k4 listbox publicly available here:

```q
q)\curl -s https://us-east.manta.joyent.com/edgemesh/public/net_dist -o dist
q)\l dist
`dist
q)dist
src dst dist
------------
2   17  139
2   34  131
3   174 150
4   226 171
4   567 13
7   786 130
9   174 112
..
q)node:0N!distinct raze dist`src`dst
2 3 4 7 9 12 13 14 16 17 18 20 21 22 24 26 27 29 31 34 35 37 41 42 43 44 45 4..
```

Repeating the above process with this `node` and `dist` for the optimal solution, also showing calculation time and space (using `\ts`):

```q
q)\ts opt:(bridge/) cm[node;dist;`inf]
92 1706512
```
Check node length from node 2 to node 174.
```q
q)node?2 174        / Find row, col of node in optimal matrix
0 72
q)opt[0;72]         / Cell [0;74] is path length to go from node 2 to node 174
398f
q)opt . node?2 174  / Or in one simple step using . index notation
398f
```

This does not get the hops, although the hops could be calculated by ‘capturing’ the intermediate results in the optimal case.
To do this use `bridge\` instead of `bridge/`, then count changes between iterations, or just index in to see the path length converge …

```q
q)count iters:(bridge\) cm[node;dist;`inf]  / Calculate all iterations
5                                            
q)/ It took 5 iterations to find the optimal paths
```

Now we can see how the path length changes during the iterations: here we see it “first converges” to 398 after 1 hop for node [2;174].

```q
q)iters .\: node?2 174  / Index into each iteration to see iterative path improvement
0w 398 398 398 398
```

Another random path choice for node[2;210] does not converge until after 3 hops, also showing iterative improvement:

```q
q)iters .\: node?2 210       / Path improvement for node [2;210]
0w 0w 638 555 555
```


## Related applications of this approach

The principle used can be generalized to different inner-product solutions for related problems.

The solution above is an instance of generalized inner-product of 2 functions `f.g` and was an example Ken Iverson often used to demonstrate how Linear Algebra can be applied to real-world problems.
The solution may be considered ‘expensive’ on memory and CPU, as it calculates all possible paths, but that is becoming less of an issue.

The `bridge` function above uses the inner product of `Minimum.Sum` (`&` and `+` in q), but variants can be used in similar, related problem domains.

Here is a summary of three related use cases, starting with the above minimum-path solution. 


### Minimum distances 

For minimum distances in a path table (example above), using an inner product of `Minimum.Sum`, where ‘no path’ is represented by `0w` (float infinity) to determine minimums properly.

This calculates the minimum of the sums of distances between nodes at each pivot. The `bridge` function looks like this:

```q
bridge:{x & x('[min;+])\: x}
```


### Counterparty credit 

For a counterparty credit-matrix solution, using an inner product of `Maximum.Minimum`, where no credit is represented by 0 to determine maximums properly.

This calculates the maximum of the minimum credit between nodes at each pivot, the `bridge` function looks like this;

```q
bridge:{x | x('[max;&])\: x}
```

This returns the optimal possible credit by allowing credit through intermediate counterparties.
For example if A only has credit with B, but B has credit with C, then after 1 hop, A actually has credit with C through B, but capped by the credit path in the same way.

A special note here is the simple case where the credit matrix is boolean. The ‘connectivity matrix’ is now a simple `yes/no` to determine connections e.g. for electrical circuits.
Each iteration improves the connections by adding additional 1s into the matrix that are now reachable in successive hops and uses the same `bridge` algorithm.
    

### Matrix multiplication

For generalized matrix multiplication, using an inner product of `Sum.Times`.

This calculates the sum of the product between nodes at each pivot, the bridge function looks like this;

```q
bridge:{x + x('[sum;*])\: x}
```
   

## Generalization

The inner product for the above 3 `bridge` use cases could be further generalized as projections of a cumulative inner product function.

```q
q)cip:{[f;g;z] f[z;] z('[f/;g])\: z}
q)bridgeMS:cip[&;+;]  / Minimum.Sum (minimum path)
q)bridgeCM:cip[|;&;]  / Maximum.Minimum (credit matrix)
q)bridgeMM:cip[+;*;]  / Sum.Times (matrix multiplication)
```


## Performance

The version of `bridge` used above shows the Linear Algebra most clearly.
It can be further optimized for performance, as shown here for the first case (minimum-path problem).

Although all operations are atomic, flipping the argument seems to improve cache efficiency.

```q
bridgef:{x + x('[sum;*])/:\: flip x}
```

The `peach` keyword can be used to parallelize evaluation.

```q
/ Parallel version (multithreaded run q -s 6)
bridgep: {x & {min each x +\: y}[flip x;] peach x}
```

The [`.Q.fc` utility](../ref/dotq.md#qfc-parallel-on-cut) uses multi-threading where possible.

```q
/ .Q.fc version
bridgefc:{x & .Q.fc[{{{min x+y}[x] each y}[;y] each x}[;flip x];x]}
```

A colleague, Ryan Sparks, is presently experimenting with further (significant) performance improvements by using [CUDA](../interfaces/gpus.md) on a graphics coprocessor for the inner-product function `bridge`.
This work is evolving and looks very promising.  I look forward to Ryan presenting a paper and/or presentation on his results when complete as perhaps a sequel to this article.

:fontawesome-solid-download: 
[Script with examples from this article](assets/mp.q)


### Test results

Ryan Sparks reports the following test results running V3.5 2017.05.02 using 6 secondary processes:

function   | \ts:1000  20×20  | \ts:100 100×100    | 1000×1000              | 2000×2000                | 4000×4000
-----------|-----------------:|-------------------:|-----------------------:|-------------------------:|-------------------------:
`bridge0`  | 178<br>63,168    | 689<br>5,330,880   | 6,488<br>4,112,433,152 | 35,068<br>32,833,633,920 | untested
`bridge1`  | 296<br>9,456     | 1,065<br>159,728   | 2,255<br>12,337,200    | 11,327<br>49,249,968     | untested
`bridge2`  | 207<br>9,008     | 1,249<br>157,616   | 6,496<br>12,317,152    | 40,073<br>49,209,824     | untested
`bridge3`  | 171<br>63,136.   | 683<br>5,330,848   | 6,292<br>4,112,433,168 | 32,446<br>32,833,633,936 | untested
`bridge4`  | ==165==<br>6,560 | ==182==<br>106,912 | ==425==<br>8,225,232   | 5,967<br>32,834,000      | 48,271<br>131,203,536
`bridge5`  | 612<br>6,656     | 1,823<br>106,624   | 1,695<br>8,221,360     | 5,112<br>32,826,032      | ==32,915==<br>131,187,376
`bridgejp` | 556<br>6,704     | 1,507<br>106,672   | 1,330<br>8,221,360     | ==3,904==<br>32,826,032  | ==32,402==<br>131,187,376
`bridgep`  | 193<br>6,560     | ==219==<br>106,912 | ==429==<br>8,225,184   | 5,922<br>32,833,952      | 53,890<br>131,203,488
`bridgef`  | 201<br>9392      | 778<br>159,664     | 2,030<br>1,233,713     | 10,625<br>49,249,904     | untested
`bridgef2` | 546<br>6,704     | 1,807<br>106,672   | 1,701<br>8,221,360     | 5,552<br>32,826,032      | ==31,428==<br>131,187,376

```q
bridge0:{x & (&/) each' x+/:\: flip x}
bridge1:{x & x(min@+)/:\: flip x}
bridge2:{x & x((&/)@+)\: x}
bridge3:k){x&&/''x+/:\:+x}
bridge4:k){x&(min'(+x)+\:)':x}
bridge5:k){x&.Q.fc[{(min y+)'x}[+x]';x]}
bridgejp:{x & .Q.fc[{{{min x+y}[x] each y}[;y] each x}[;flip x];x]}
bridgep:{x & {min each x +\: y}[flip x;] peach x}
bridgef:{x & x('[min;+])/:\: flip x}
bridgef2:{x & .Q.fc[{x('[min;+])/:\: y}[;flip x];x]}
```

!!! warning "Your mileage may vary"

    As always, optimizations need to be tested on the hardware and data in use. 

 

## Acknowledgements

My thanks to Nion Chang, Pierre Kovalev, Jonny Press, Ryan Sparks and Stephen Taylor for contributions to this article. 


Rob Hodgkinson  
rob@marketgridsystems.com