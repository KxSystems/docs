---
title: Multithreaded primitives, implicit parallelism and improved performance in kdb+ | Knowledge base | Documentation for q and kdb+
description: Q primitives in V4.0 implicitly seek and use opportunities for parallel processing. Some existing q code will run significantly faster.
author: Pierre Kovalev
date: March 2020
---
# <i class="fas fa-bolt"></i> Multithreaded primitives


![Parallelism](../img/parallelism.jpg)
<!-- GettyImages-1133385944 -->

To complement existing explicit parallel computation facilities ([`peach`](../ref/each.md)), kdb+ 4.0 introduces implicit, within-primitive parallelism. It is able to exploit internal parallelism of the hardware – in-memory, with modern multi-channel memory architectures, and on-disk, e.g. making use of SSD internal parallelism.

The following primitives now use multiple threads where appropriate:

```txt
atomics:   abs acos and asin atan ceiling cos div exp floor 
           log mod neg not null or reciprocal signum sin sqrt 
           tan within xbar xexp xlog + - * % & | < > = >= <= <>
aggregate: all any avg cor cov dev max min scov sdev sum svar var wavg
lookups*:  ?(Find) aj asof bin binr ij in lj uj 
index:     @(Apply At) select .. where delete 
misc:      $(Cast) #(Take) _(Drop/Cut) ,(Join) deltas differ distinct 
           next prev sublist til where xprev
           select ... by 
```

\* For lookups, only the probe phase (i.e. dealing with the right hand side) is parallelized.


## Practicalities

Multithreaded primitives execute in the same slave threads as `peach`, and similar limitations apply. System command [`\s`](../basics/syscmds.md#s-number-of-slaves) controls the maximum number of threads. 

For example, here we invoke `max` from outside `peach`, and from within `peach`:
```q
q)v:100000000?10000;system each("t max v";"t {max x}peach(0#0;v)")
54 153
```

To keep overhead in check, the number of execution threads is limited by the minimum amount of data processed per thread – at the moment it is in the order of 10<sup>5</sup> vector items, depending on the primitive.


## Performance

Many q primitives issue lots of reads and writes to memory for relatively little compute, e.g. for sufficiently large `a`, `b`, and `c` in

```q
a+b*c
```

both `+` and `*` would read and write from/to slow main memory, effectively making the entire computation memory bandwidth-bound. Depending on system architecture, bandwidth available to multiple cores can be much higher, but this is not always the case. Total aggregate bandwidth of a single CPU is proportional to number of memory channels available and memory speed.

It is therefore important to make sure your memory setup is optimal. A tool like [Intel MLC](https://software.intel.com/en-us/articles/intelr-memory-latency-checker) can help with comparing different RAM configurations.

In a multiple-socket system, under NUMA, non-local memory access is much slower. Kdb+ 4.0 is not NUMA-aware, and decisions of memory placement and scheduling across sockets are left to the operating system. That prevents scaling out to multiple sockets, and performance can fluctuate unpredictably. We recommend restricting the working set to a single socket, if possible, by running q under `numactl --preferred=` or even `--membind=`.


## `select` … `by`

Internally, the general case of `select` … `by` requires the following steps, for every group:

 1. Construct a set of objects corresponding to columns mentioned
 2. Execute `select` expressions

(1) is now parallelized and cache-friendly, but (2) proceeds single-threaded as before. A few ‘simple aggregates’, however, are (and have been) optimized to skip (1): `sum`, `min`, `max`, `avg`, `first`, `last` – the first four of these are now executed in parallel too. (Previously, you needed all expressions in a `select` to be simple to activate this.) 

Some additional optimizations are:

1. `select` ... ``by `s#x`` or `` `p#x`` with empty Where clause avoids a few more intermediate steps. (Most useful for simple aggregates.)
2. `select` ... ``by `byte$x`` or `` `short$x`` is faster too.
3. For expressions that need step (1), intermediate structures from the previous expression are cached. e.g.: 

    <pre><code class="language-q">select a+b, a*b, c by s from t</code></pre>

    should be faster than 

    <pre><code class="language-q">select a+b, c, a*b by s from t</code></pre>


<!--
## Peach vs implicit parallelism

As parallelism remains single-level, one has to choose 

```q
q)\t a*a
24
q)\t .Q.fc[{x*x};a]
69
```

==FIXME==
fair scheduling advantage e.g. table@i
small lists
-->


## Benchmarking

As most primitives of kdb+ are memory-bound, the point of multithreaded primitives is to exploit all-core memory bandwidth available on modern hardware with >2 memory channels. (Or storage parallelism, when reading off SSD or disk.)

For example, one socket of a cascade-lake based machine has 6 memory channels of 2666MT/s RAM, which translates to practically attainable 110Gbps, almost 6 times the typical single-core bandwidth of <20Gbps.

Therefore it makes no sense to benchmark any of it on a laptop like a MacBook Air, where all-core bandwidth is at most 1.5× of single-core. In one test, `smape (n=50e6)` runs 11× faster on a single socket (`numactl -m 0 -N 0`) of a Xeon 8260L. It is important to understand the consequences of NUMA; we observed pushing that to 19× for 2 sockets by taking care to avoid cross-socket traffic. One has to call [`.Q.gc[]`](../ref/dotq.md#qgc-garbage-collect) right before the test, and both arguments should result from previous multithreaded primitives to distribute input data evenly across 2 sockets. For primitives like [Find](../ref/find.md), cross-socket traffic is unavoidable and we do not expect them to scale outside a single socket.

