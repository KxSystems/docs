---
title: WekaIO Matrix – Appendix I of Migrating a kdb+ HDB to Amazon EC2 – Cloud – kdb+ and q documentation
description: WekaIO Matrix is a commercial product from WekaIO. Version 3.1.2 was used for testing. Matrix uses a VFS driver, enabling Weka to support POSIX semantics with lockless queues for I/O. The WekaIO POSIX system has the same runtime semantics as a local Linux file system.
author: Glenn Wright
date: March 2018
keywords: Amazon, AWS, EC2, HDB, cloud, kdb+, wekaio
---
# Appendix I – WekaIO Matrix



!!! info "WekaIO Matrix is qualified with kdb+."

WekaIO Matrix is a commercial product from WekaIO. 
Version 3.1.2 was used for testing.
Matrix uses a VFS driver, enabling Weka to support POSIX semantics with lockless queues for I/O. 
The WekaIO POSIX system has the same runtime semantics as a local Linux file system.

Matrix provides distributed data protection based on a proprietary form of erasure coding. 
Files are broken up into chunks and spread across nodes (or EC2 instances) of the designated Matrix cluster (minimum cluster size is six nodes = four data + two parity). 
The data for each chunk of the file is mapped into an erasure-coded stripe/chunk that is stored on the node’s direct-attached SSD. 
EC2 instances must have local SATA or NVMe based SSDs for storage.

With Matrix, we would anticipate kdb+ to be run in one of two ways. 
Firstly, it can run on the server nodes of the Matrix cluster, sharing the same namespace and same compute components. 
This eliminates the need to create an independent file-system infrastructure under EC2. 
Secondly, the kdb+ clients can run on clients of the Matrix cluster, the client/server protocol elements being included as part of the Matrix solution, being installed on both server and client nodes.

One nice feature is that WekaIO tiers its namespace with S3, and includes operator selectable tiering rules, and can be based on age of file and time in cache, and so on.

The performance is at its best when running from the cluster’s erasure-coded SSD tier, exhibiting good metadata operational latency.

This product, like others using the same design model, does require server and client nodes to dedicate one or more cores (vCPU) to the file-system function. 
These dedicated cores run at 100% of capability on that core. 
This needs to be catered for in your core sizing calculations for kdb+, if you are running directly on the cluster.

![](img/media/image44.png)

![](img/media/image45.png)

![](img/media/image46.png)

![](img/media/image47.png)

When forcing the cluster to read from the data expired to S3, we see these results:

![](img/media/image48.png)

![](img/media/image49.png)

function       | latency (mSec) | function   | latency (mSec) 
---------------|----------------|------------|---------------
`hclose hopen` | 0.555          | `();,;2 3` | 3.5
`hcount`       | 0.049          | `read1`    | 0.078

<small>_WekaIO Matrix metadata operational latencies - mSecs (headlines)_</small>


## Summary

Streaming reads running in concert across multiple nodes of the cluster achieve 4.6&nbsp;GB/sec transfer rates, as measured across eight nodes running kdb+, and on one file system. 
What is interesting here is to observe there is no decline in scaling rate between one and eight nodes. 
This tested cluster had twelve nodes, running within that a 4+2 data protection across these nodes, each of instance type `r3.8xlarge` (based on the older Intel Ivy Bridge chipset), chosen for its modest SSD disks and not for its latest CPU/mem speeds.

Streaming throughput on one client node is 1029&nbsp;MB/sec representing wire speed when considered as a client node. 
This indicates that the data is injected to the host running kdb+ from all of the Matrix nodes whilst still constructing sequential data from the remaining active nodes in the cluster, across the same network.

Metadata operational latency: whilst noticeably worse than EBS, is one or two orders of magnitude better than EFS and Storage Gateway and all of the open source products.

For the S3 tier, a single kdb+ thread on one node will stream reads at 555&nbsp;MB/sec. 
This rises to 1596&nbsp;MB/sec across eight nodes, continuing to scale, but not linearly. 
For eight processes and eight nodes throughput maximizes at a reasonable 1251&nbsp;MB/sec. 
In a real-world setting, you are likely to see a blended figure improve with hits coming from the SSDs. 
The other elements that distinguish this solution from others are “block-like” low operational latencies for some meta-data functions, and good aggregate throughputs for the small random reads with kdb+.

For setup and installation, a configuration tool guides users through the cluster configuration, and it is pre-configured to build out a cluster of standard r3- or i3-series EC2 instances. 
The tool has options for both standard and expert users. 
The tool also provides users with performance and cost information based on the options that have been chosen.




<div class="kx-nav" markdown="1">
<div class="kx-nav-prev">[H. ObjectiveFS](app-h-objectivefs.md)</div><div class="kx-nav-next">[J. Quobyte](app-j-quobyte.md)</div>
</div>
