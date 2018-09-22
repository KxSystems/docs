hero: <i class="fa fa-cloud"></i> Cloud

# Storing your HDB in S3



S3 might be something you are seriously considering for storage of some,
or all, of your HDB data in EC2. Here is how S3 fits into the landscape
of all of the storage options in EC2.


## Locally-attached drives

You can store your HDB on locally-attached drives, as you might do today on your own physical hardware on your own premises. 

EC2 offers the capability of bringing up an instance with internal NVMe or SAS/SATA disk drives, although this is not expected to be used for anything other than caching data, as this storage is referred to as ephemeral data by AWS, and might not persist after system shutdowns. This is due to the on-demand nature of the compute instances: they could be instantiated on any available hardware within the availability zone selected by your instance configuration.


## EBS volumes

You can store your HDB on [EBS volumes](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/RootDeviceStorage.html). These appear like persistent block-level storage. Because the EC2 instances are virtualized, the storage is separated at birth from all compute instances. 

By doing this, it allows you to start instances on demand, without the need to co-locate the HDB data alongside those nodes. This separation is always via the networking infrastructure built into EC2. In other words, your virtualized compute instance can be attached to a real physical instance of the storage via the EC2 network, and thereafter appears as block storage. This is referred to as _network attached storage_ (Elastic Block Storage). 

Alternatively, you can place the files on a remote independent file system, which in turn is typically supported by EC2 instances stored on EBS or S3.


## Amazon S3 object store

Finally, there is the ubiquitous Amazon S3 object store, available in all regions and zones of EC2. Amazon uses S3 to run its own global network of websites, and many high-visibility web-based services store their key data under S3. With S3 you can create and deploy your HDB data in buckets of S3 objects. 

-   **Storage prices** are lower (as of January 2018): typically 10% of the costs of the Amazon EBS model.
-   S3 can be configured to offer **redundancy and replication** of object data, regionally and globally.

Amazon can  be configured to duplicate your uploaded data across multiple geographically diverse repositories, according to the replication service selected at bucket-creation time. S3 promises [99.999999999%](https://aws.amazon.com/s3/faqs/) durability. 

<i class="far fa-hand-point-right"></i> [AWS S3 replication](https://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html)

However, there are severe limitations on using S3 when it comes to kdb+.
The main limitation is the API. 


### API limitations

An S3 object store is organized differently from a POSIX file system. 

[![S3 object store](img/media/image7.png)](img/media/image7.png "Click to expand")

S3 uses a web-style [RESTful interface](https://en.m.wikipedia.org/wiki/Representational_state_transfer "Wikipedia") HTTP-style interface with [eventual-&#8203;consistency](https://en.wikipedia.org/wiki/Eventual_consistency "Wikipedia") semantics of put and change. 
This will always represent an additional level of abstraction for an application like kdb+ that directly manages its virtual memory. 
S3 therefore exhibits slower per–process/thread performance than is usual for kdb+. The lack of POSIX interface and the semantics of RESTful interfaces prevents kdb+ and other high-performance databases from using S3 directly. 

However, S3’s low cost, and its ability to scale performance horizontally when additional kdb+ instances use the same S3 buckets, make it a candidate for some customers.


### Performance limitations

The second limitation is S3’s performance, as measured by the time taken to populate vectors in memory. 

Kdb+ uses POSIX file-system semantics to manage HDB structure directly on disk. It exploits this feature to gain very high-performance memory management through Linux-based memory mapping functions built into the kernel, from the very inception of Linux.

S3 uses none of this.

On EC2, kdb+ performance stacks up in this order (from slowest to faster):

1.  S3
2.  EBS
3.  Third-party distributed or managed file system
4.  Local drives to the instance (typically cache only)

Although the performance of S3 as measured from one node is not fast, S3 retains comparative performance for each new instance added to an HDB workload in each availability zone. Because of this, S3 can scale up its throughput when used across multiple nodes within one availability zone. This is useful if you are positioning large numbers of business functions against common sets of market data, or if you are widely distributing the workload of a single set of business queries. This is not so for EBS as, when deployed, the storage becomes owned by one, and only one, instance at a time.


### Replication limitations

A nice feature of S3 is its built-in replication model between regions
and/or time zones. 

Note you have to choose a replication option; none is chosen by default.

The replication process may well duplicate incorrect behavior from one region to another. In other words, this is not a backup.

However, the data at the replica site can be used for production
purposes, if required. Replication is only for cross-region propagation
(e.g. US-East to US-West). But, given that the kdb+ user can design this
into the solution (i.e. end-of-day copies to replica sites, or multiple
pub-sub systems), you may choose to deploy a custom solution within
kdb+, across region, rather than relying on S3 or the file system
itself.


### Summary

-   The **POSIX file system interface** allows the Linux kernel to move data
    from the blocks of the underlying physical hardware, directly into
    memory mapped space of the user process. This concept has been tuned
    and honed by over 20 years of Linux kernel refinement. In our case,
    the recipient user process is kdb+. S3, by comparison, requires the
    application to bind to an HTTP-based RESTful (get, wait, receive)
    protocol, which is typically transferred over TCP/IP LAN or WAN
    connection. Clearly, this is not directly suitable for a
    high-performance in-memory analytics engine such as kdb+. However,
    all of the file-system plug-ins and middleware packages reviewed in
    this paper help mitigate this issue. The appendices list the main
    comparisons of all of the reviewed solutions.

-   Neither Kdb+, nor any other high-performance database, makes use of the **RESTful object-store interface**.

-   There is no notion of **vectors, lists, memory mapping** or optimized placement of objects in memory regions.

-   S3 employs an **eventual-consistency** model, meaning there is no guaranteed service time for placement of the object, or replication of the object, for access by other processes or threads.

-   S3 exhibits relatively low **streaming-read performance**. A RESTful, single S3 reader process is limited to a [read throughput](http://blog.zachbjornson.com/2015/12/29/cloud-storage-performance.html) of circa 0.07&nbsp;GB/sec. Some of the solutions reviewed in this paper use strategies to improve these numbers within one instance (e.g. raising that figure to the 100s&nbsp;MB/sec – GB/sec range). There is also throughput scalability gained by reading the same bucket across multiple nodes. There is no theoretical limit on this bandwidth, but this has not been exhaustively tested by Kx.

-   Certain **metadata operations**, such as kdb+’s append function, cause significant latency vs that observed on EBS or local attached storage, and your mileage depends on the file system under review.

Performance enhancements, some of which are bundled into **third-party
solutions** that layer between S3 and the POSIX file system layer, are
based around a combination of: multithreading read requests to the S3
bucket; separation of large sequential regions of a file into individual
objects within the bucket and read-ahead and caching strategies.

There are some areas of synergy. Kdb+ HDB data typically stores billions
and billions of time-series entries in an immutable read-only mode. Only
updated new data that lands in the HDB needs to be written. S3 is a
[shared nothing](https://en.wikipedia.org/wiki/Shared-nothing_architecture "Wikipedia") model. Therefore, splitting a single segment or
partitioned column of data into one file, which in turn is segmented
into a few objects of say 1&nbsp;MB, should be a lightweight operation, as
there is no shared/locking required for previously written HDB data. So
the HDB can easily tolerate this eventual consistency model. This does
not apply to all use-cases for kdb+. For example, S3, with or without a
file system layer, cannot be used to store a reliable ticker-plant log.

Where S3 definitely plays to its strengths, is that it can
be considered for an **off-line deep archive** of your kdb+ formatted market
data.

Kx does not make recommendations with respect to
the merits, or otherwise, of storing kdb+ HDB market data in a data
retention type “WORM” model, as required by the regulations [SEC 17-a4](https://en.wikipedia.org/wiki/SEC_Rule_17a-4 "Wikipedia").


