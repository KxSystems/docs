---
title: Intel Optane Persistent Memory and kdb+ | Knowledge Base | Documentation for kdb+ and q
description: Kdb+ 4.0 can exploit Optane persistent memory, a new hardware technology from Intel, in App Direct Memory mode and substantially reduce execution times.
author: Glenn Wright
date: January 2021
---
# :fontawesome-solid-bolt: Intel Optane Persistent Memory and kdb+
​
​
![Optane Memory](../img/optane-memory.jpg)
{: style="text-align: center"}

Intel® Optane™ persistent memory, herein called Intel Optane PMem, is a new
hardware technology from Intel.

Intel Optane PMem is based on a new silicon technology, 3D XPoint, which has low latency (memory like) attributes and is more durable than traditional NAND Flash. ​

Intel Optane technology was first unveiled in 2017, in the form of Intel Optane SSD. By packaging 3DX Point in a Solid State Drive (SSD), Intel created a product with speeds faster than the other SSD devices (largely based on NAND Flash) that preceded it. However, the scale of performance improvement of 3DX Point brought another target into Intel’s sights – main memory.

The technology that dominates main memory, DRAM, is order of magnitudes faster to access, but smaller in size and more cost per Byte than NAND flash. Storage (whether SSD or spinning disk) is large and cheap, but orders-of-magnitude slower to access. This has led to a significant gap in the memory-storage hierarchy: 
​
```txt
SRAM   CPU cache L1, L2, L3
DRAM   main memory
SSD    storage
HDD    archival
```
​
Intel Optane PMem introduces a new category that sits between memory and storage. In newly designed system boards, capable of supporting Intel Cascade Lake CPU chip set, or later, the memory sits in the same DDR4 DIMM slots (and memory bus) as DRAM. Persistent memory sits close to the CPU, and allows applications to directly address it as memory.
​
```txt
SRAM   CPU cache L1, L2, L3
DRAM   main memory
>> Optane Memory
>> Optane SSD
SSD    storage
HDD    archival
```


## What are the advantages?
​
By combining storage and memory, Intel Optane PMem is at once high-performance, high-capacity, and cost-efficient.
​
### High-performance
​
Intel Optane technology is faster than existing storage media, as
shown by Intel Optane SSDs.
​
Intel Optane PMem offers another advantages, due to
​
-   Direct CPU access to individual bytes, rather than blocks, at a time.
-   Minimal latency and maximal throughput via the memory bus, versus PCIe connections for SSDs.
​
​
### High-capacity
​
While DRAM currently caps at 258 GiB per module, Intel Optane PMem is
current generation of Optaen (aka Apache Pass) is available in capacities of 128 GiB, 256 GiB, and 512 GiB.
​
On Cascade Lake designs,  six Intel Optane PMem modules can be used per socket, users can address 10+ TB of
optane memory space on a single 4 socket system.
​
​
### Cost-efficient
​
The retail prices of Intel Optane PMem are intended to sit between the price per GiB for DRAM and NVMe Intel Optane storage. This can be one consideration for a kdb+ solution, especially if it uses a lot of active memory for streaming or real-time analytics, or if it needs extremely fast access to hot data in a HDB. This may make such a solution more affordable than just using DRAM.
​
The increased memory size also provides an opportunity to consolidate
workloads onto fewer nodes, leading to an even lower TCO through reduced
hardware, software, datacenter and operations costs.
​
​
## How can kdb+ users benefit?
​
Some advantages that Intel Optane PMem provides to databases are:

-   On-disk databases will run faster using expanded Intel Optane PMem as storage because some or all of the space does not need fetching from disk
-   In-memory databases will scale using Intel Optane PMem as a larger memory space

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
​
​
### Read/write data from storage
​
Kdb+ on-disk databases are partitioned, most commonly by date, with
individual columns stored as binary objects within a file system. The
result is a self-describing database on disk, mapped into memory by a
kdb+ process and presented to users as if it resides in memory. The
limiting factor with most queries to on-disk data, is the latency and
bandwidth penalty paid to jump from storage to DRAM-based memory.
​
​
### Scale horizontally
​
Adding more machines into the mix allows users to add more memory by
scaling out. Processes across a cluster communicate via IPC and work on
calculations as a single logical unit. The success of this approach
depends largely on the inherent parallelization of the task at hand,
which must be balanced against the increased complexity and costs of
hardware.
​
​
### Scale vertically
​
Vertical scaling is the preferred method of scaling for most kdb+
applications, as users aim to keep as much hot data as possible close to
the CPU. If everything would fit in memory, and we could afford it, we’d
probably put it there. However, traditional memory (DRAM) is expensive
and, even if funds were unlimited, is limited in capacity on a
per-socket basis.
​
Intel Optane PMem presents opportunities to address these issues, through
faster form of block storage or through significantly scaled-up memory capacity.


## How can kdb+ users deploy Intel Optane PMem?
​
Intel Optane PMem can be deployed in a number of ways, depending on the
design of users’ existing applications.
​
There are three modes by which Intel Optane PMem can be used by kdb+.

-   Memory mode
-   App Direct Mode
-   Storage over App Direct
​
​
### Memory mode

In Memory mode, the DRAM acts as a cache for frequently-accessed data, while the Intel Optane PMem provides large memory capacity. When configured for Memory Mode, the applications and operating system perceive a pool of volatile memory, no differently than on DRAM-only systems. In this mode, no specific persistent memory programming is required in the applications. This dramatically increases the amount of memory seen by the kernel and hence available to kdb+. DRAM mixes its memory address space with Optane.

For larger datasets, this increased memory space avoids the costs and complexity of horizontal scaling.

??? detail "Vertical-vs-horizontal scaling"

    A common solution for overly-large in-memory datasets, is to split the data across multiple machines. Data is usually split based on some inherent partition of the data (e.g. ticker symbol, sensor ID, region), to allow parallelization of calculations. Horizontal scaling allows users to add memory, but comes at a cost. Average perfomance (versus a single machine) is reduced due to the cost of IPC to move data between processes. There is also an increase in complexity as well as hardware, datacenter and operations costs.

    Intel Optane PMem, in Memory mode, creates a new opportunity to scale vertically. A significantly extended memory space enables calculations on a single machine, rather than a cluster. This removes or reduces the complexities and performance cost of IPC, allowing users to run simpler, more efficient analytics.


### App Direct Mode ​

Kdb+ 4.0 contains support for App Direct Mode, in which the applicaitons and operating system are explicitly aware there are two types of direct load/store memory in the platform, and can direct whihch type of data read or write is suitable for DRAM or Intel® Optane™ persistent memory. Kdb+ sees Intel Optane PMem and DRAM as two separate pools, and gives users control over which entities reside in each. As a result, users can optimize their applications and schemas, keeping hot data in fast DRAM while still taking full advantage of the expanded memory capacity.
​
Horizontal partitioning ​

: e.g. Keep ‘recent’ historical data in Intel Optane PMem, allowing multi-day
queries in memory

Vertical partitioning

: e.g. Different tables/columns residing in DRAM/Intel Optane PMem
​
​
### Storage over App Direct
​
Storage over App Direct Mode is a specialized application of App Direct Mode, in which Intel Optane PMem behaves like a storage device accessible via a filesystem. As the filesystem is explicitly optimized for the underlying technology, it offers better operational latencies. With extremely low read/write speeds, data is passed quickly between storage and memory, enabling faster queries. Intel Optane PMem is particularly fast at small, random reads, which makes it particularly effective at speeding up kdb+ historical queries.

Storage over App Direct Mode was recently benchmarked, publicly, using the **STAC M3** industry-standard benchmarks. Tests ran on Lenovo ThinkSystem servers with Intel Optane PMem, 2nd Generation Intel® Xeon® processors, and kdb+ 3.6.

Using a 2-socket server:

-   Intel Optane PMem was faster in 16 of 17 STAC-M3 Antuco benchmarks, relative to 3D NAND SSD
-   In 11 of the benchmarks, Intel Optane PMem was faster by more than 2×

Using a 4-socket server:

-   Intel Optane PMem was faster in 8 of 9 STAC-M3 Kanaga benchmarks, relative to 3D NAND SSD
-   In 6 of the benchmarks, Intel Optane PMem was faster by more than 2×

Compared to all publicly disclosed STAC-M3 Antuco results:

-   For 2-socket systems running kdb+, this solution set new records in 11 of 17 mean response-time benchmarks. 
-   For 4-socket systems running kdb+ this solution set new records in 9 of 17 mean response-time benchmarks.

Write speeds are also improved using Intel Optane PMem, allowing higher throughput when logging and writing database partitions.


## Summary
​
Intel Optane persistent memory is a game-changing technology from Intel, which allows kdb+ users to increase the performance and capacity of their applications. Through reduced memory costs and infrastructure consolidation, Intel Optane PMem should also reduce TCO. ​

Earlier versions of kdb+ are already compatible with Intel Optane PMem through Memory Mode (BIOS settings required) and Storage over App Direct Mode, providing improvements for both in-memory and on-disk datasets. From version 4.0 onwards App Direct Mode gives users control over Intel Optane PMem, taking optimal advantage of the technology to suit their applications. ​

KX has created a new technology and marketing partnership with Intel, around Optane Memory. By working closely with Intel’s engineers, we ensure kdb+ takes full advantage of the features of Intel Optane PMem. We also have a team of engineers ready to help customers evaluate Intel Optane PMem. Through a POC, we can determine the optimal way to deploy the new technology to new and existing use cases. Please contact optane@kx.com to coordinate any such POC, or for any technical questions. ​

---
:fontawesome-solid-book:
[`.m` namespace](../ref/dotm.md)
