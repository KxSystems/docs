---
title: Multithreaded primitives, implicit parallelism and improved performance in kdb+ | Knowledge base | Documentation for q and kdb+
description: Q primitives in V4.0 implicitly seek and use opportunities for parallel processing. Some existing q code will run significantly faster.
author: Pierre Kovalev
date: March 2020
---
# :fontawesome-solid-bolt: Multithreaded primitives


![Parallelism](../img/parallelism.jpg)
<!-- GettyImages-1133385944 -->

To complement existing explicit parallel computation facilities ([`peach`](../ref/each.md)), kdb+ 4.0 introduces implicit, within-primitive parallelism. It is able to exploit internal parallelism of the hardware – in-memory, with modern multi-channel memory architectures, and on-disk, e.g. making use of SSD internal parallelism. 

```q
/ count words, in-cpu cache
q)a:read1`:big.txt;st:{value"\\s ",string x;value y}
q)f:{sum 0b>':max 0x0a0d0920=\:x}
q)(s;r[0]%r;r:st[;"\\t:100 f a"]each s:1 4 16 32)
1    4   16  32 / threads
1    4.1 8.3 11 / speedup
1082 262 131 95 / time, ms
```

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
           select ... by**
```

\* For lookups, only the probe phase (i.e. dealing with the right hand side) is parallelized.
<br>
\** Internally, but aggregate functions other than `count`, `sum`, `min`, `max`, and `avg` execute single-threaded.


## Practicalities

Multithreaded primitives execute in the same slave threads as `peach`, and similar limitations apply. System command [`\s`](../basics/syscmds.md#s-number-of-slaves) controls the maximum number of threads. 

!!! tip "Launch q with the [`-s`](../basics/cmdline.md#s-slaves) command-line option to allow primitives to multithread."

For example, here we invoke `max` from outside `peach`, and from within `peach`:
```q
q)v:100000000?10000;system each("t max v";"t {max x}peach(0#0;v)")
54 153
```

To keep overhead in check, the number of execution threads is limited by the minimum amount of data processed per thread – at the moment it is in the order of 10<sup>5</sup> vector items, depending on the primitive.

```q
q)a:100 1000000#0;b:2000 50000#0;
q)system"s 2";system each("t a+a";"t b+b")
85 169
q)system"s 0";system each("t a+a";"t b+b")
170 173
```


## Performance

Many q primitives issue lots of reads and writes to memory for relatively little compute, e.g. for sufficiently large `a`, `b`, and `c` in

```q
a+b*c
```

both `+` and `*` would read and write from/to slow main memory, effectively making the entire computation memory bandwidth-bound. Depending on system architecture, bandwidth available to multiple cores can be much higher, but this is not always the case. Total aggregate bandwidth of a single CPU is proportional to number of memory channels available and memory speed. For example, one socket of a cascade-lake based machine has 6 memory channels of 2666MT/s RAM, which translates to practically attainable 110GB/s, almost 6 times the typical single-core bandwidth of <20GB/s. On a typical laptop with dual-channel memory, all-core bandwidth is at most 1.5× of single-core and common kdb+ operations are not expected to benefit from implicit parallelism.

It is therefore important to make sure your memory setup is optimal. A tool like [Intel MLC](https://software.intel.com/en-us/articles/intelr-memory-latency-checker) can help with comparing different RAM configurations.

In a multiple-socket system, under NUMA, non-local memory access is much slower. Kdb+ 4.0 is not NUMA-aware, and decisions of memory placement and scheduling across sockets are left to the operating system. That prevents scaling out to multiple sockets, and performance can fluctuate unpredictably. We recommend restricting the working set to a single socket, if possible, by running q under `numactl --preferred=` or even `--membind=`.


## Peach vs implicit parallelism

In kdb+ parallelism remains single-level, and for a given computation one has to choose a single axis to apply it over, whether implicitly with multithreaded primitives, or explicitly with peach. Within-primitive parallelism has several advantages: 

1. No overhead of splitting and joining large vectors. For simple functions, direct execution can be much faster than [`.Q.fc`](../ref/dotq.md#qft-apply-simple):

    <pre><code class="language-q">q)system"s 24";a:100000000?100;
    q)\t a\*a
    28
    q)\t .Q.fc[{x*x};a]
    130
    </code></pre>

2. Operating on one vector at a time can avoid inefficient scheduling of large, uneven chunks of work:

    <pre><code class="language-q">q)system"s 3";n:100000000;t:([]n?0f;n?0x00;n?0x00);
    q)\t sum t            / within-column parallelism
    30
    q)\t sum peach flip t / column-by-column parallelism ..
    65
    q)\s 0
    q)/ .. takes just as much time as the largest unit of work, 
    q)\t sum t`x          / .. i.e. widest column
    64
    </code></pre>

However, one needs vectors large enough to take advantage. Nested structures and matrices still need hand-crafted `peach`. Well-optimized code already making use of `peach` is unlikely to benefit. 
