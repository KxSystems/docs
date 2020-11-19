---
title: Intel Optane Memory and kdb+ performance | Knowledge Base | Documentation for jdb+ and queries
description: Kdb+ 4.0 can exploit Optane DC persistent memory, a new hardware technology from Intel, in App Direct Memory mode and substantially reduce execution times.
author: Glenn Wright
date: March 2020
---
# :fontawesome-solid-bolt: Optane Memory and kdb+


![Optane Memory](../img/optane-memory.jpg)
{: style="text-align: center"}

Intel Optane DC persistent memory, herein called Optane Memory, is a new
hardware technology from Intel. 
<!--Compared to recent emerging memory technologies,-->
Optane Memory has the potential to substantially disrupt
the memory and storage landscape.

Optane Memory is based on a new silicon technology, 3DX Point, which is
significantly faster and more durable than existing storage media.

Optane technology was first unveiled in 2017, in the form of Optane DC
SSD. By packaging 3DX Point in a Solid State Drive (SSD), Intel created
a product many-times faster than the best devices (largely based on
NAND Flash) that preceded it. However, the scale of performance
improvement of 3DX Point brought another target into Optane’s sights –
main memory.

The technology that dominates main memory, DRAM, is fast to access, but
small and very expensive. Storage (whether SSD or spinning disk) is
large and cheap, but typically orders-of-magnitude slower to access.
This has led to a significant gap in the memory-storage hierarchy:

```txt
SRAM   CPU cache L1, L2, L3
DRAM   main memory
SSD    storage
HDD    archival
```

Optane Memory disrupts the traditional hierarchy, by introducing a new
category that sits between memory and storage. Sitting in the same DDR4
DIMM slots (and memory bus) as DRAM, Optane Memory sits close to the
CPU, and allows applications to directly address it as memory.

```txt
SRAM   CPU cache L1, L2, L3
DRAM   main memory
>> Optane Memory
>> Optane SSD
SSD    storage
HDD    archival
```


## What are the advantages?

By combining the best aspects of storage and memory, Intel Optane is at
once high-performance, high-capacity, and cost-efficient.

### High-performance

Optane technology is markedly faster than existing storage media, as
shown by Optane DC SSD.

Optane memory offers another significant performance improvement, due to

-   Direct CPU access to individual bytes, rather than blocks, at a time.
-   Minimal latency and maximal throughput via the memory bus, versus PCIe connections for SSDs.


### High-capacity

While DRAM currently caps at 128 GiB per module, Optane Memory is
available in capacities of 128 GiB, 256 GiB, and 512 GiB.

With six Optane Memory modules per socket, users can address 10+ TB of
system memory on a single system.


### Cost-efficient

The retail prices of Optane memory should sit between the prices for DRAM and NVMe Optane storage. This can be one consideration for a kdb+ solution, especially if it uses a lot of active memory for streaming or real-time analytics, or if it needs extremely fast access to hot data in a HDB. This may make such a solution more affordable than just using DRAM.

The increased memory size also provides an opportunity to consolidate
workloads onto fewer nodes, leading to an even lower TCO through reduced
hardware, software, datacenter and operations costs.


## How can kdb+ users benefit?

The advantages that Optane Memory provides to databases are clear:

-   On-disk databases will run faster using Optane as storage
-   In-memory databases will scale using Optane as a larger memory space

A typical kdb+ application uses a combination of memory and storage to
gather, persist and analyze enormous datasets. Kdb+’s structured use of
on-disk data allows efficient access to databases up to petabyte scale.
The size of in-memory datasets, however, is primarily restricted by the
size of the accessible memory space.

Once datasets grow beyond the available memory capacity, users have
three main options:

-   read/write data from storage
-   scale horizontally
-   scale vertically


### Read/write data from storage

Kdb+ on-disk databases are partitioned, most commonly by date, with
individual columns stored as binary objects within a file system. The
result is a self-describing database on disk, mapped into memory by a
kdb+ process and presented to users as if it resides in memory. The
limiting factor with most queries to on-disk data, is the latency and
bandwidth penalty paid to jump from storage to DRAM-based memory.


### Scale horizontally

Adding more machines into the mix allows users to add more memory by
scaling out. Processes across a cluster communicate via IPC and work on
calculations as a single logical unit. The success of this approach
depends largely on the inherent parallelization of the task at hand,
which must be balanced against the increased complexity and costs of
hardware.


### Scale vertically

Vertical scaling is the preferred method of scaling for most kdb+
applications, as users aim to keep as much hot data as possible close to
the CPU. If everything would fit in memory, and we could afford it, we’d
probably put it there. However, traditional memory (DRAM) is expensive
and, even if funds were unlimited, is limited in capacity on a
per-socket basis.

Optane Memory presents opportunities to address these issues, through
much faster storage and significantly scaled-up memory capacity.


## How can kdb+ users deploy Optane?

Optane technology can be deployed in a number of ways, depending on the
design of users’ existing applications.

There are three modes by which Optane can be used by kdb+

-   Storage mode
-   Cached Memory mode
-   App Direct Memory mode


### Storage mode

With Storage mode, Optane Memory behaves like a file system visible to
kdb+. As the file system is explicitly optimized for the underlying
technology, it offers significantly better operational latencies than
are seen from anything so far in the industry. With extremely low
read/write speeds, data is passed quickly between storage and memory,
enabling faster queries. Optane Memory is particularly fast at small,
random reads, which makes it particularly effective at speeding up kdb+
historical queries.

<!-- *STAC Benchmarks* -->

Storage mode was recently audited, publicly, using the **STAC M3**
industry-standard benchmarks. Tests ran on Lenovo ThinkSystem servers
with Optane Memory, 2nd Generation Intel Scalable Xeon (Cascade Lake)
processors, and kdb+ 3.6.

Using a 2-socket server:

-   Optane Memory was faster in 16 of 17 STAC-M3 Antuco benchmarks, relative to 3D NAND SSD
-   In 11 of the benchmarks, Optane Memory was faster by more than 2×

Using a 4-socket server:

-   Optane memory was faster in 8 of 9 STAC-M3 Kanaga benchmarks,
relative to 3D NAND SSD
-   In 6 of the benchmarks, Optane Memory was faster by more than 2×

Compared to all publicly disclosed STAC-M3 Antuco results:

-   For 2-socket systems running kdb+, this solution set new records in 11 of 17 mean response-time benchmarks.
-   For 4-socket systems running kdb+, this solution set new records in 9
of 17 mean response-time benchmarks.

Write speeds are also improved using Optane memory, allowing higher
throughput when logging and writing down database partitions.


### Cached Memory mode

In Cached Memory mode, DRAM mixes its memory address space with Optane
Memory, dramatically increasing the amount of memory seen by the kernel
and hence available to kdb+.

The CPU memory controller uses DRAM as cache and Optane Memory as
addressable main memory. This transparently extends the amount of memory
visible to kdb+, with no application changes necessary to take
advantage. For larger datasets, this increased memory space avoids the
costs and complexity of horizontal scaling.

Vertical-vs-horizontal scaling

: A common solution for overly-large in-memory datasets, is to split the data across multiple machines. Data is usually split based on some inherent partition of the data (e.g. ticker symbol, sensor ID, region), to allow parallelization of calculations. Horizontal scaling allows users to add memory, but comes at a cost. Average perfomance (versus a single machine) is reduced due to the cost of IPC to move data between processes. There is also an increase in complexity as well as hardware, datacenter and operations costs.

: Optane Memory, in Cached Memory mode, creates a new opportunity to scale vertically. A significantly extended memory space enables calculations on a single machine, rather than a cluster. This removes or reduces the complexities and performance cost of IPC, allowing users to run simpler, more efficient analytics.


### App Direct Memory mode

In kdb+ 4.0, App Direct Memory mode lets applications talk directly
to the Optane Memory. Kdb+ sees Optane Memory and DRAM as two separate
pools, and gives users control over which entities reside in each. As a
result, users can optimize their applications and schemas, keeping hot
data in fast DRAM while still taking full advantage of the expanded
memory capacity.

Horizontal partitioning

: e.g. Keep ‘recent’ historical data in Optane Memory, allowing multi-day
queries in memory

Vertical partitioning

: e.g. Different tables/columns residing in DRAM/Optane Memory


## Summary

Optane Memory is a game-changing technology from Intel, which will allow
kdb+ users to increase the performance and capacity of their
applications. Through reduced memory costs and significant
infrastructure consolidation, Optane Memory should also reduce TCO.

Earlier versions of kdb+ are already compatible with Optane Memory
through Storage mode and Cached Memory modes, providing significant
improvements for both in-memory and on-disk datasets. From version 4.0
onwards App Direct Memory mode gives users control over Optane Memory,
taking optimal advantage of the technology to suit their applications.

Kx have created a new technology and marketing partnership with Intel,
around Optane Memory. By working closely with Intel’s engineers, we will
ensure kdb+ takes full advantage of the features of Optane Memory.
We also have a team of engineers ready to help Kx customers evaluate
Optane Memory. Through a POC, we can determine the optimal way to deploy
the new technology to new and existing use cases. Please contact
optane@kx.com to coordinate any such POC, or for any technical
questions.

:fontawesome-solid-book:
[`.m` namespace](../ref/dotm.md)