---
title: Parallel processing | Basics | kdb+ and q documentation
description: The iterator Each Parallel (or its mnemonic keyword peach) delegates processing to secondary tasks for parallel execution. This can be useful, for example, for computationally expensive functions, or for accessing several drives at once from a single CPU.
keywords: kdb+, parallel, parallel each, peach, q, uniform
---
# Parallel processing






The iterator [Each Parallel](../ref/maps.md#each-parallel) `':` (or its mnemonic keyword `peach`) delegates processing to secondary tasks for parallel execution. 
This can be useful, for example, for computationally expensive functions, or for accessing several drives at once from a single CPU.

To execute in parallel, start kdb+ with multiple secondary processes, using [`-s` in the command line](cmdline.md#-s-secondary-threads), and (since V3.5) the [`\s`](syscmds.md#s-number-of-secondary-processes) system command.

Each Parallel iterates a unary value: the argument list of the derived function is divided between secondary processes for evaluation. 

The result of `m':[x]` is exactly the same as `m'[x]`. 
If no secondary tasks are available, performance is the same as well. 

Syntax: `(f':) x`, `f':[x]`, `f peach x`

where `f` is a unary value and the items of list `x` are in its domain.

```q
q)f:{sum exp x?1.0}
q)\t f each 2#1000000
132
q)\t f peach 2#1000000     / with 2 CPUs
70
```

Use the [Apply](../ref/apply.md) operator to project a higher-rank value over argument pairs (or triples, etc.).

For example, `x g'y` <=> `g'[x;y]` <=> `.[g;]'[flip(x;y)]`. 
Thus

```q
q)g:{sum y*exp x?1.0}
q)\ts g'[2#1000000;2 3]
57 16777856
q)\ts .[g;]peach flip(2#1000000;2 3)
32 1744
```

The secondary processes used by Parallel Each and `peach` are either threads or processes according to the sign of the [value used in the command line](cmdline.md#-s-secondary-processes).


## Threads


### Globals

The function `f` is executed within the secondary processes, unless the list `x` is a single-item list, in which case the function is executed within the main kdb+ thread. 

!!! info "Only the main kdb+ thread may update global variables"

The function executed with `peach` is restricted to updating local variables only. Thus:

```q
q){`a set x} peach enlist 0
```

works, as single-item list shortcuts to execute on the main kdb+ thread

```q
q){`a set x} peach 0 1
```

fails and signals `noupdate` as it is executed from within secondary threads.

:fontawesome-solid-graduation-cap:
[Table counts in a partitioned database](../kb/partition.md#table-counts)

`peach` defaults to `each` when no secondary threads are specified on startup. 
It then executes on the only available thread, the main kdb+ thread.

```q
q){`a set x} peach 0 1
```

works when no secondary threads are specified, as `peach` defaults to `each`.

The algorithm for grouping symbols differs between secondary threads and the main kdb+ thread. The main kdb+ thread uses an optimization not available to the secondary threads. E.g. kdb+ started with two secondary threads

```q
q)s:100000000?`3
q)\t {group s} peach enlist 0 / defaults to main thread as only single item
2580
q)\t {group s} peach 0 1 / group in secondary threads, can't use optimized algorithm
9885
```

However, grouping integers behaves as expected

```q
q)s:100000000?1000
q)\t {group s} peach enlist 0
2308
q)\t {group s} peach 0 1
2802
```

Perfect scaling may not be achieved, because of resource clashes.


### Number of cores/secondary threads

A vector with _n_ items peached with function `f` with _s_ secondary processes on _m_ cores is distributed such that threads are preassigned which items they will be responsible for processing, e.g. for 9 jobs over 4 threads, thread \#0 will be assigned elements 0, 4, 8; if each job takes the same time to complete, then the total execution time of jobs will be quantized according to \#jobs _mod_ \#cores, i.e. with 4 cores, 12 jobs should execute in a similar time as 9 jobs (assuming \#secondary processes≥\#cores).


### Sockets and handles 

!!! warning "Handles between threads"

    A handle must not be used concurrently between threads as there is no locking around a socket descriptor, and the bytes being read/written from/to the socket will be garbage (due to message interleaving) and most likely result in a crash. 

Since V3.0, a socket can be used from the main thread only, or if you use the one-shot sync request syntax as

```q
q)`:localhost:5000 "2+2"
```

`peach` forms the basis for a multithreaded HDB. For illustration, consider the following query. 

```q
q){select max price by date,sym from trade where date=d} peach date
```

This would execute a query for each date in parallel. The multithreaded HDB with `par.txt` hides the complexity of splitting the query up between threads and aggregating the results.


### Memory usage

Each secondary thread has its own heap, a minimum of 64MB.

Since V2.7 2011.09.21, [`.Q.gc[]`](../ref/dotq.md#qgc-garbage-collect) in the main thread collects garbage in the secondary threads too.

Automatic garbage collection within each thread (triggered by a wsfull, or hitting the artificial heap limit as specified with [`-w`](cmdline.md#-w-workspace) on the command line) is executed only for that particular thread, not across all threads.

Symbols are internalized from a single memory area common to all threads.


## Processes (distributed each)

Since V3.1, `peach` can use multiple processes instead of threads, configured through the startup [command-line option `-s`](cmdline.md#-s-secondary-threads) with a negative integer, e.g. `-s -4`. 

Unlike multiple threads, the distribution of the workload is not precalculated, and is distributed to the secondary processes as soon as they complete their allocated items. All data required by the peached function must either already exist on all secondary processes, or be passed as an argument. Argument sizes should be minimised because of IPC costs. 

If any of the secondary processes are restarted, the primary process must also restart to reconnect. 

The motivating use case for this mode is multiprocess HDBs, combined with non-compressed data and [`.Q.MAP[]`](../ref/dotq.md#qmap-maps-partitions).

Secondary processes must be started explicitly and [`.z.pd`](../ref/dotz.md#zpd-peach-handles) set to a vector of their connection handles, or a function that returns it.

These handles must not be used for other messages: `peach` will close them if it receives anything other than a response message. e.g.

```q
q).z.pd:{n:abs system"s";$[n=count handles;handles;[hclose each handles;:handles::`u#hopen each 20000+til n]]}
q).z.pc:{handles::`u#handles except x;}
q)handles:`u#`int$();
```

----
:fontawesome-solid-book: 
[`.Q.fc`](../ref/dotq.md#qfc-parallel-on-cut) (parallel on cut)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§A.68 `peach`](/q4m3/A_Built-in_Functions/#a68-peach)

<!-- FIXME replicate discussion in Q4M §A.68 -->