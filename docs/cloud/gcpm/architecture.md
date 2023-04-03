---
title: Reference architecture | Google Cloud | kdb+ and q documentation
description:
date: June 2021
author: Ferenc Bodon
---
# Reference architecture for Google Cloud

kdb+ is the technology of choice for many of the world’s top financial institutions when implementing a tick-capture system. kdb+ is capable of processing large amounts of data in a very short space of time, making it the ideal technology for dealing with the ever-increasing volumes of financial tick data.

KX clients can lift and shift their kdb+ plants to the cloud and make use of virtual machines (VM) and storage solutions. This is the classic approach that relies on the existing license. To benefit more from the cloud technology it is recommended to migrate to kdb Insights.

!!! summary "kdb Insights"

    ![Microservices](../../img/microservice_icon.png){: style="float:left; margin:0 2em 2em 0; max-width:20%"}

    [kdb Insights](https://code.kx.com/insights/) provides a range of tools to build, manage and deploy kdb+ applications in the cloud. It supports interfaces for deployment and common ‘Devops‘ orchestration tools such as Docker, Kubernetes, Helm, etc. It supports integrations with major cloud logging services. It provides a kdb+ native REST client, Kurl, to authenticate and interface with other cloud services. kdb Insights also provides kdb+ native support for reading from cloud storage. By taking advantage of kdb Insights suite of tools, developers can quickly and easily create new and integrate existing kdb+ applications on Google Cloud.

    Deployment:

    <!-- -   [QPacker](https://code.kx.com/insights/core/qpacker/qpacker.html) – A packaging utility that supports q, Python and C libraries -->
    <!-- -   [Detailed guide](https://code.kx.com/insights/cloud-edition/kx-core-app-charts/helloworld/) to using Helm and Kubernetes to deploy kdb+ applications to the cloud. -->
    
    -   Use Helm and Kubernetes to deploy kdb+ applications to the cloud

    Service integration:

    -   [QLog](https://code.kx.com/insights/core/qlog/overview.html) – Integrations with major cloud logging services
    -   [Kurl](https://code.kx.com/insights/core/kurl/kurl.html) – Native kdb+ REST client with authentication to cloud services

    Storage:
    
    -   [kdb+ Object Store](https://code.kx.com/insights/core/objstor/main.html) – Native support for reading and querying cloud object storage


## Architectural components

The core of a kdb+ tick-capture system is called kdb+tick.

[kdb+tick](../../learn/startingkdb/tick.md) is an architecture which allows the capture, processing and querying of timeseries data against realtime, streaming and historical data. This reference architecture describes a full solution running kdb+tick within Google Cloud which consists of these bare-minimum functional components:

-   datafeeds
-   feed handlers
-   tickerplant
-   realtime database
-   historical database
-   KX gateway

[![A simplified architecture diagram for kdb+tick in Google Cloud](img/gc-architecture.png)](img/gc-architecture.png "Click to expand")
<br>
<small>_A simplified architecture diagram for kdb+/tick in Google Cloud_</small>

Worthy of note in this reference architecture is the ability to place kdb+ processing functions either in one Google Cloud instance or distributed around many Google Cloud instances. The ability for kdb+ processes to communicate with each other through kdb+’s built-in language primitives, allows for this flexibility in final design layouts. The transport method between kdb+ processes and all overall  external communication is done through low-level TCP/IP sockets. If two components are on the same Google Cloud instance, then local Unix sockets can be used to reduce communication overhead.

Many customers have kdb+tick set up on their premises. The Google Cloud reference architecture allows customers to manage a hybrid infrastructure that communicates with both kdb+tick systems on-premises and in the cloud. However, benefits from migrating their infrastructure to the cloud include

-   flexibility
-   auto-scaling
-   more transparent cost management
-   access to management/infrastructure tools built by Google
-   quick hardware allocation


### Data feeds

This is the source data we aim to ingest into our system. For financial use cases, data may be ingested from B-pipe (Bloomberg), or Elektron (Refinitiv) data or any exchange that provides a data API.

Often the streaming data is available on a pub-sub component like Kafka or Solace, with an open-source interface to kdb+. The data feeds are in a proprietary format, but always one KX has familiarity with. Usually this means that a feed handler just needs to be aware of the specific data format.

The flexible architecture of KX means most if not all the underlying kdb+ processes that constitute the system can be placed anywhere in it. For example, for latency, compliance or other reasons, the data feeds may be relayed through an existing customer on-premises data center. Or the connection from the feed handlers may be made directly from this Virtual Private Cloud (VPC) into the market data venue.

The kdb+ infrastructure is often used to also store internally-derived data. This can optimize internal data flow and help remove latency bottlenecks. The pricing of liquid products (for example, B2B markets) is often done by a complex distributed system. This system often changes with new models, new markets or other internal system changes. Data in kdb+ that will be generated by these internal steps will also require processing and handling huge amounts of timeseries data. When all the internal components of these systems send data to kdb+, a comprehensive impact analysis captures any changes.


### Feed handler

A feed handler is a process that captures external data and translates it into kdb+ messages. Multiple feed handlers can be used to gather data from several different sources and feed it to the kdb+ system for storage and analysis.
There are a number of open-source (Apache 2 licensed) Fusion interfaces between KX and third-party technologies. Feed handlers are typically written in Java, Python, C++ and q.

:fontawesome-brands-superpowers:
[Fusion interfaces on kdb+](../../interfaces/index.md)


### Tickerplant

The tickerplant (TP) is a specialized, single threaded kdb+ process that operates as a link between the client’s data feed and a number of subscribers. It implements a pub-sub pattern: specifically, it receives data from the feed handler, stores it locally in a table then saves it to a log file. It publishes this data to a realtime database (RDB) and any clients that have subscribed to it. It then purges its local tables of data.

Tickerplants can operate in two modes:

Batch

: Collects updates in its local tables. It batches up for a period of time and then forwards the update to realtime subscribers in a bulk update.

Realtime

: Forwards the input immediately. This requires smaller local tables but has higher CPU and network costs, bear in mind that each message has a fixed network overhead.

Supported API calls:

call | action
-----|-------
Subscribe | Adds subscriber to message receipt list and sends subscriber table definitions.
Unsubscribe| Removes subscriber from message receipt list.

Events:

End of Day

: At midnight, the TP closes its log files, auto creates a new file, and notifies the realtime database (RDB) about the start of the new day.


### Realtime database

The realtime database (RDB) holds all the intraday data in memory, to allow for fast powerful queries.

For example, at the start of business day, the RDB sends a message to the tickerplant and receives a reply containing the data schema, the location of the log file, and the number of lines to read from the log file. It then receives subsequent updates from the tickerplant as they are published. One of the key design choices for Google Cloud will be the size of memory for this instance, as ideally we need to contain the entire business day/period of data in-memory.

Purpose:

-   Subscribed to the messages from the tickerplant
-   Stores (in memory) the messages received
-   Allows this data to be queried intraday

Actions:

-   On message receipt inserts into local, in-memory tables
-   At End of Day (EOD), usually writes intraday data down then sends a new End-of-Day message to the HDB; may sort certain tables (e.g. by sym and time) to speed up queries

An RDB can operate in single- or multi-input mode. The default mode is single input, in which user queries are served sequentially and queries are queued until an update from the TP is processed (inserted into the local table).
In standard tick scripts, the RDB tables are indexed, typically by the product identifier.

An index is a hash table behind the scene. Indexing has a significant impact on the speed of the queries at the cost of slightly slower ingestion. The insert function takes care of the indexing, i.e. during an update it also updates the hash table.

Performance of the CPU and memory in the chosen Google Cloud instance will have some impact on the overall sustainable rates of ingest and queryable rate of this realtime kdb+ function.


### Historical database

The historical database (HDB) is a simple kdb+ process with a pointer to the persisted data directory. A kdb+ process can read this data and memory maps it, allowing for fast queries across a large volume of data. Typically, the RDB is instructed to save its data to the data directory at EOD from where the HDB can refresh its memory mappings.

HDB data is partitioned by date in the standard kdb+tick. If multiple disks are attached to the box, then data can be segmented, and kdb+ makes use of parallel I/O operations. Segmented HDB requires a `par.txt` file that identifies the locations of the individual segments.

An HDB query is processed by multiple threads and map-reduce is applied if multiple partitions are involved in the query.

Purpose:

-   Provides a queryable data store of historical data
-   In instances involving research and development or data analytics, customers can create customer reports on order execution times

Actions:

-   End of Day receipt: reloads the database to get the new days’ worth of data from the RDB write-down

HDBs are often expected to be mirrored locally. Some users (e.g.  quants) need a subset of the data for heavy analysis and backtesting where the performance is critical.


### KX gateway

In production, a kdb+ system may be accessing multiple timeseries data sets, usually each one representing a different market data source, or using the same data, refactored for different schemas. Process-wise, this can be seen as multiple TP, RDB and HDB processes.

A KX gateway generally acts as a single point of contact for a client. A gateway collects data from the underlying services, combines data sets and may perform further data operations (e.g. aggregation, joins, pivoting, etc.) before it sends the result back to the user. The gateway hides the data segregation, provides utility functions and implements business logic.

The specific design of a gateway can vary in several ways according to expected use cases. For example, in a hot-hot set up, the gateway can be used to query services across availability zones.

The implementation of a gateway is largely determined by the following factors.

-   Number of clients or users
-   Number of services and sites
-   Requirement of data aggregation
-   Support of free-form queries
-   Level of redundancy and failover

The task of the gateway can be broken down into the following steps.

-   Check user entitlements and data-access permissions
-   Provide access to stored procedures
-   Gain access to data in the required services (TP, RDB, HDB)
-   Provide the best possible service and query performance

Google BigQuery is a fully managed, serverless data warehouse that enables scalable analysis over petabytes of data. The kdb Insights [BigQuery API](https://code.kx.com/insights/core/big-query/intro.html) lets you easily interact with the REST API that Google exposes for BigQuery. This is particularly useful for the gateway. Data may reside in BigQuery that can be fetched by the gateway and users can enjoy the expressiveness of the q language to further analyze the data or join it with other data sources.


## Storage and filesystem

kdb+tick architecture needs storage space for three types of data:

Tickerplant log

: If the tickerplant (TP) needs to handle many updates, then writing to TP needs to be fast since slow I/O may delay updates and can even cause data loss. Optionally, you can write updates to TP log batched (e.g. in every second) as opposed to realtime. You will suffer data loss if TP or instance is halted unexpectedly or stops/restarts, as the recently received updates are not persisted. Nevertheless, you already suffer data loss if a TP process or the Google Cloud instance goes down or restarts. The extra second of data loss is probably marginal to the whole outage window.

: If the RDB process goes down, then it can replay data to recover from the TP log. The faster it can recover the less data is waiting in the TP output queue to be processed by the restarted RDB. Hence fast read operation is critical for resilience reasons.

Sym file (and `par.txt` for segmented databases)

: The sym file is written by the realtime database (RDB) after end-of-day, when new data is appended to the historical database (HDB). The HDB processes will then read the sym file to reload new data. Time to read and write the sym file is often marginal compared to other I/O operations.  Usually it is beneficial here to be able to write down to a shared filesystem, thereby adding huge flexibility in the Google Virtual Private Cloud (VPC). (For example, any other Google Cloud instance can assume this responsibility in a stateless fashion).

Historical data

: Performance of the file system solution will determine the speed and operational latency for kdb+ to read its historical (at rest) data. The solution needs to be designed to cater for good query execution times for the most important business queries. These may splay across many partitions or segments of data or may deeply query on few/single partitions of data. The time to write a new partition impacts RDB EOD work. For systems that are queried around the clock the RDB write time needs to be very short.

kdb+ supports tiering via `par.txt`. The file may contain multiple lines; each represents a location of the data. Hot, warm, and cold data may reside in storage solutions of different characteristics. Hot data probably requires low latency and high throughput, while the cost may be the primary goal for cold data.

One real great value of storing your HDB within the Google Cloud ecosystem is the flexibility of storage. This is usually distinct from ‘on-prem’ storage, whereby you may start at one level of storage capacity and grow the solution to allow for dynamic capacity growth. One huge advantage of most Google Cloud storage solutions (e.g. Persistent Disks) is that disks can grow dynamically without the need to halt instances, this allows you to dynamically change resources. For example, start with small disk capacity and grow capacity over time.

The reference architecture recommends replicating data. Either this can be tiered out to lower cost/lower performance object storage in Google Cloud or the data can be replicated across availability zones. The latter may be useful if there is client-side disconnection from other time zones. You may consider failover of service from Europe to North America, or vice-versa. kdb+ uses POSIX filesystem semantics to manage HDB structure directly on a POSIX-style filesystem stored in persistent storage (Google Cloud’s Persistent Disk _et al._)
There are many solutions that offer full operational functionality for the POSIX interface.



### Persistent disk

Google Cloud’s [Persistent Disk](https://cloud.google.com/persistent-disk) is a high-performance block storage for virtual machine instances.

Persistent Disk has a POSIX interface so it can be used to store historical database (HDB) data. One can use disks with different latency and throughput characteristics. Storage volumes can be transparently resized without downtime. You no longer need to delete data that might be needed in the future, just add capacity on the fly. Although the Persistent Disk capacity can be shrunk this is not always supported by all filesystem types.

Persistent Disks in Google Cloud allow simultaneous readers, so they can be attached to multiple VMs running their own HDB processes. Frequently-used data that are sensitive to latency should use SSD disks that offer consistently high performance.

Persistent Disk’s automatic encryption helps protect sensitive data at the lowest level of the infrastructure.

The limitation of Persistent Disks is that they can be mounted in read-write mode only to a single VM. When EOD [splaying](../../kb/splayed-tables.md) happens, the Persistent Disk needs to be unmounted from another VM, (i.e. all extra HDBs need to be shut down).

Local SSD can be mounted to a single VM. They have higher throughput and lower latency (especially with NVMe interface) at the expense of functionality including redundancy and snapshots. Local SSD with write-cache-flushing disabled can be a great choice for TP logs. Mirrored HDBs for target groups like quants also require maximal speed; redundancy and snapshots are less important here.

When considering selecting the right Persistent Disk, one needs to be aware of the relation between maximal IOP and number of CPUs.


### Filestore

[Filestore](https://cloud.google.com/filestore) is a set of services from Google Cloud allowing you to load your HDB store into a fully managed service. All Filestore tiers use network-attached storage (NAS) for Google Compute Engine (GCE) instances to access the HDB data. Depending on which tier you choose, it can scale to a few 100s of TBs for high-performance workloads. Along with predictable performance, it is simple to provision and easy to mount on GCE VM instances. NFSv3 is fully supported.

Filestore includes some other storage features such as: Deduplication, Compression, Snapshots, Cross-region replication, and Quotas. kdb+ is qualified with any tier of Filestore. In using Filestore, you can take advantage of these built-in features when using it for all or some of your HDB segments and partitions. As well as performance, it allows for consolidation of RDB write down and HDB reads, due to its simultaneous read and write support within a single filesystem namespace.

This makes it more convenient than Google Cloud Persistent Disks. You can simply add HDB capacity by setting up a new VM, mounting Filestore tier as if an NFS client to that service, and if needed, register the HDB to the HDB load balancer. RDB or any other data-writer processes can write HDB anytime, it just needs to notify the HDB processes to remap the HDB files to the backing store. Note that the VMs of your RDB and HDB instances need to be in the same zone as your Filestore.

Each Filestore service tier provides performance of a different level. The Basic tiers offer consistent performance beyond a 10 TB instance capacity. For High Scale tier instances, performance grows or shrinks linearly as the capacity scales up or down.

Filestore is not highly available. It is backed by VMs of a zone. If the complete zone suffers an outage, users can expect downtime. Filestore backups are regional resources, however. In the rare case of inaccessibility of a given zone, users can restore the data using the regional backup and continue working in any available zone.

Prior to choosing this technology, check in via your Google Cloud console to find the currently supported regions, as e.g. High Scale SSD is gradually being deployed globally.


### Google Cloud Storage

[Google Cloud Storage](https://cloud.google.com/storage) (GCS) is an object store that scales to exabytes of data. There are different storage classes (standard, nearline, cold line, archive) for different availability. Infrequently used data can use cheaper but slower storage. The cloud storage interface supports PUT, GET, LIST, HEAD operations only so it cannot be used for its historical database (HDB) directly, and constitutes ‘eventual consistency’ and RESTful interfaces. There is an open-source adapter (e.g. [Cloud Storage FUSE](https://cloud.google.com/storage/docs/gcs-fuse)) which allows mounting a Cloud Storage bucket as a file system.

The Kx Insights native object-store functionality outperforms open-source solutions and allows users to read HDB data from GCS. All you need do is add the URI of the bucket that stores HDB data to `par.txt`. Cloud object storage has a relatively high latency compared to local storage such as local SSD. However, the performance of kdb+ when working with GCS can be improved by caching GCS data. The results of requests to cloud storage can be cached on a local high-performance disk thus increasing performance. The cache directory is continuously monitored and a size limit is maintained by deleting files according to a LRU (least recently used) algorithm.

Caching coupled with enabling secondary threads can increase the performance of queries against a HDB on cloud storage. The larger the number of secondary threads, irrespective of CPU core count, the better the performance of kdb+ object storage. Conversely the performance of cached data appears to be better if the secondary-thread count matches the CPU core count.

Each query to GCS has a financial cost and caching the resulting data can help to reduce it.

It is recommended to use compression on the HDB data residing on cloud storage. This can reduce the cost of object storage and possible egress costs and also counteract the relatively high-latency and low bandwidth associated with cloud object storage.

Object store is great for archiving, tiering, and backup. The TP log file and the sym file should be stored each day and archived for a period of time. The lifecycle management of the object store simplifies clean-up whereby one can set expiration time to any file. The [versioning feature](https://cloud.google.com/storage/docs/object-versioning) of GCS is particularly useful when a sym file bloat happens due to feed misconfiguration or upstream change. Migrating back to a previous version saves the health of the whole database.

A kdb+ feed can subscribe to a GCS file update that the upstream drops into a bucket and can start its processing immediately. The data is available earlier compared to the solution when the feed is started periodically, e.g. in every hour.


## Memory

The tickerplant (TP) uses very little memory during normal operation in realtime mode, whilst a full record of intraday data is maintained in the realtime database. Abnormal operation occurs if a realtime subscriber (including RDB) is unable to process the updates. TP stores these updates in the output queue associated with the subscriber. Large output queue needs a large memory. TP may even hit memory limits and exit in extreme cases. Also, TP in batch mode needs to store data (e.g. for a second). This also increases memory need. Consequently, the memory requirement of the TP box depends on the set-up of the subscribers and the availability requirements of the tick system.

The main consideration for an instance hosting the RDB is to use a memory-optimized VM instance such as the `n1-highmem-16` (with 104 GB memory), `n1-highmem-32` (208 GB memory), etc. Google Cloud also offers VM with extremely large memory, `m1-ultramem-160`, with 3.75 TiB of memory, for clients who need to store large amounts of high-frequency data in memory, in the RDB, or even to keep more than one partition of data in the RDB form.

Bear in mind, there is a tradeoff between having a large memory and a quick RDB recovery time. The larger the tables, the longer it takes for the RDB to start from TP log. To alleviate this problem, clients may split a large RDB into two. The driving rule for separating the tables into two clusters is the join operation between them. If two tables are never joined, then they can be placed into separate RDBs.

HDB boxes are recommended to have large memories. User queries may require large temporal space for complex queries. Query execution times are often dominated by IO cost to get the raw data. OS level caching stores frequently used data. The larger the memory the less cache miss will happen and the faster the queries will run.


## CPU

The CPU load generated by the tickerplant (TP) depends on the number of publishers and their verbosity (number of updates per second) and the number of subscribers. Subscribers may subscribe to partial data, but any filtering applied will consume further CPU cycles.

The CPU requirement of the realtime database (RDB) comes from

-   appending updates to local tables
-   user queries

Local table updates are very efficient especially if TP sends batch updates. User queries are often CPU intensive. They perform aggregation, joins, and call expensive functions. If the RDB is set up in multi-input mode (started with a negative port) then user queries are executed in parallel. Furthermore, kdb+ 4.0 supports multithreading in most primitives, including `sum`, `avg`, `dev`, etc. If the RDB process is heavily used and hit by many queries, then it is recommended to start in multi-process mode by [`-s` command-line option](../../basics/cmdline.md#-s-secondary-threads)). VMs with a lot of cores are recommended for RDB processes with large numbers of user queries.

If the infrastructure is sensitive to the RDB EOD work, then powerful CPUs are recommended. Sorting tables before splaying is a CPU-intensive task.

Historical databases (HDB) are used for user queries. In most cases the I/O dominates execution times. If the box has large memory and OS-level caching reduces I/O operations efficiently, then CPU performance will directly impact execution times.

## VM Maintenance, live migration

Virtual machines run on real physical machines. Occasionally physical machines suffer hardware failures. Google developed a suite of monitoring tools to detect hardware failure as early as possible. If the physical server is considered unreliable then the VM is moved to a healthy server. In most cases, the migration is unnoticed in Google Cloud, in contrast to to an on-premise solution where DevOps are involved and it takes time to replace the server. Improving business continuity is a huge value for all domains.

Even Google Cloud cannot break the laws of physics. The migration step takes some time: data must be transferred over the network. The more memory you have, the longer it takes to migrate the VM. VMs that run the RDB are likely to have the largest memory. During migration, client queries are not ignored but delayed a bit. The connections are not dropped, the queries go into a buffer temporarily, and are executed after the migration.

VM migration is not triggered solely by hardware failure. Google needs to perform maintenance that is integral to keeping infrastructure protected and reliable. The maintenance includes host OS and BIOS upgrades, security or compliance requirements, etc. Maintenance events are logged in Stackdriver and you can receive advance notice by monitoring value

`/computeMetadata/v1/instance/maintenance-event metadata`

Furthermore, Google provides `gcloud` command `compute instances simulate-maintenance-event` to simulate a maintenance event. You can use this function to measure the impact of live migration and provide an SLA for the kdb+tick. You can also instruct Google Cloud to avoid live migration during maintenance. The alternative is stopping the instance before live migration, and starting it up once the maintenance finished. For kdb+tick this is probably not the policy you need, since you need to provide continuous service.


## Locality, latency and resilience

The standard tick setup on premises requires the components to be placed on the same server. The tickerplant (TP) and realtime database (RDB) are linked via the TP log file and the RDB and historical database (HDB) are bound due to RDB EOD splaying. Customized kdb+tick release this constraint in order to improve resilience. One motivation could be to avoid HDB queries impacting data capture in TP. You can set up an HDB writer on the HDB box and RDB can send its tables via IPC at midnight and delegate the I/O work together with the sorting and attribute handling.

We recommend placing the fhe feedhandlers outside the TP box, on another VM between TP and data feed. This way any feedhandler malfunctions have a smaller impact on TP stability.


### Sole-tenant nodes

Physical servers may run multiple VMs that may belong to different organizations. Sole-tenancy lets you have exclusive access to the physical server that is dedicated to hosting only your project’s VMs. Having this level of isolation is useful in performance-sensitive, business-critical applications or to meet security or compliance requirements.

Another advantage of sole-tenant nodes is that you can define a maintenance window. This is particularly useful in business domains (e.g. exchanges that close for the weekend) where the data flow is not continuous.


## Recovery

A disaster recovery plan is usually based on requirements from both the Recovery Time Objective (RTO) and Recovery Point Objective (RPO) specifications, which can guide the design of a cost-effective solution. However, every system has its own unique requirements and challenges. Here we suggest the best-practice methods for dealing with the various possible failures one needs to be aware of and plan for when building a kdb+tick system.

In all the various combinations of failover operations that can be designed, the end goal is always to maintain availability of the application and minimize any disruption to the business.

In a production environment, some level of redundancy is always required. Depending on the use case, requirements may vary but in nearly all instances requiring high availability, the best option is to have a hot-hot (or ‘active-active’) configuration.

The following are the four main configurations that are found in production: hot-hot, hot-warm, hot-cold, and pilot light (or cold hot-warm).

Hot-hot

: Hot-hot is the term for an identical mirrored secondary system running, separate to the primary system, capturing and storing data but also serving client queries.

: In a system with a secondary server available, hot-hot is the typical configuration as it is sensible to use all available hardware to maximize operational performance. The KX gateway handles client requests across availability zones and collects data from several underlying services, combining data sets and if necessary, performing an aggregation operation before returning the result to the client.

Hot-warm

: The secondary system captures data but does not serve queries. In the event of a failover, the KX gateway will reroute client queries to the secondary (warm) system.

Hot-cold

: The secondary system has a complete backup or copy of the primary system at some previous point in time (recall that kdb+ databases are just a series of operating system files and directories) with no live processes running.

: A failover in this scenario involves restoring from this latest backup, with the understanding that there may be some data loss between the time of failover to the time the latest backup was made.

Pilot light (cold hot-warm)

: The secondary is on standby and the entire system can quickly be started to allow recovery in a shorter time period than a hot-cold configuration.

Typically, kdb+ is deployed in a high-value system. Hence, downtime can impact business which justifies the hot-hot setup to ensure high availability.

Usually, the secondary will run on separate infrastructure, with a separate file system, and save the data to a secondary database directory, separate from the primary. In this way, if the primary system or underlying infrastructure goes offline, the secondary would be able to take over completely.

The usual strategy for failover is to have a complete mirror of the production system (feed handler, tickerplant, and realtime subscriber), and when any critical process goes down, the secondary is able to take over. Switching from production to disaster recovery systems can be implemented seamlessly using kdb+ inter process communication.

:fontawesome-regular-map:
[Disaster-recovery planning for kdb+tick systems](../../wp/disaster-recovery/index.md)
<br>
:fontawesome-regular-map:
[Data recovery for kdb+tick](../../wp/data-recovery.md)


## Network

The network bandwidth needs to be considered if the tickerplant components are not located on the same VM. The network bandwidth between Google Cloud VMs depends on the type of the VMs. For example, a VM of type `n1-standard-8` has a maximum egress rate of 2 GBps. For a given update frequency you can calculate the required bandwidth by employing the [`-22!` internal function](../../basics/internal.md#-22x-uncompressed-length) that returns the length of the IPC byte representation of its argument. The tickerplant copes with large amounts of data if batch updates are sent. Make sure that the network is not your bottleneck in processing the updates.

You might want to use the premium network service tier for higher throughput and lower latencies. Premium tier delivers GCP traffic over Google’s well-provisioned, low-latency, highly reliable global network.


### Network load balancer

[Cloud Load Balancing](https://cloud.google.com/load-balancing/) is used for ultra-high performance, TLS offloading at scale, centralized certificate deployment, support for UDP, and static IP addresses for your application. Operating at the connection level, network load balancers are capable of handling millions of requests per second securely while maintaining ultra-low latencies. Standard network tier offers regional load balancing. The global load balancing is available as a premium tier feature.

Load balancers can distribute load among applications that offer the same service. kdb+ is single threaded by default. With a negative [`-p` command-line option](../../basics/cmdline.md#-p-listening-port) you can set multithreaded input mode, in which requests are processed in parallel. This however, is not recommended for gateways (due to socket-usage limitation) and for kdb+ servers that process data from disk, like HDBs.

A better approach is to use a pool of HDB processes. Distributing the queries can either be done by the gateway via async calls or by a load balancer. If the gateways are sending sync queries to the HDB load balancer, then a gateway load balancer is recommended to avoid query contention in the gateway. Furthermore, there are other kdb+tick components that enjoy the benefit of load balancers to better handle simultaneous requests.

Adding a load balancer on top of an historical database (HDB) pool is quite simple. You create an instant template. It starts script automatically mounting the HDB data, sets environment variables (e.g. `QHOME`) and starts the HDB. The HDB accepts incoming TCP connections so you need to set up an ingress firewall rule via network tags.

In the next step, you need to create a managed, stateless instance group (set of virtual machines) with autoscaling to better handle peak loads.

The final step is creating a TCP network load balancer between your VMs. You can set the recently created instance group as a backend service and request a static internal address. All clients will access the HDB pool via this static address and the load balancer will distribute the requests among the HDB servers seamlessly.

General TCP load balancers with an HDB pool offer better performance than a stand-alone HDB, however, utilizing the underlying HDBs is not optimal.

Consider three clients C1, C2, C3 and two servers HDB1 and HDB2. C1 is directed to HDB1 when establishing the TCP connection, C2 to HDB2 and C3 to HDB1 again. If C1 and C3 send heavy queries and C2 sends a few lightweight queries, then HDB1 is overloaded and HDB2 is idle. To improve the load distribution the load balancer needs to go under the TCP layer and needs to understand the kdb+ protocol.


## Logging

Google Cloud provides a fully-managed logging service that performs at scale and can ingest applications and system log data. [Cloud Logging](https://cloud.google.com/logging) allows you to search and analyze the system log. It provides an easy-to-use and customizable interface so that DevOps can quickly troubleshoot applications. Log messages can be transferred to [BigQuery](https://cloud.google.com/bigquery) by a single click, where complex queries allow a more advanced log-data analysis. In this section we also illustrate how to easily interact with the Google Cloud API from a q process.

You can make use of cloud logging without any change in the code by setting up a [fluentd-based logging agent](https://cloud.google.com/logging/docs/agent). After installation, you simply add a config file to `/etc/google-fluentd/config.d` and restart service `google-fluentd`. At minimum, you need to set the path of the log files and specify a tag to derive the `logName` part of a log message.

The simplest way to send a log message directly from a kdb+ process is to use the [`system`](../../ref/system.md) keyword and the `gcloud logging` command-line tool.

```q
system "gcloud logging write kdb-log \"My first log message as text.\" --severity INFO&"
```

The ampersand is needed to prevent the logging from blocking the main thread.

Google Cloud allows sending structured log messages in JSON format. If you would like to send some key-value pair that is stored in a q dictionary then you can use the function `.j.j` to serialize the map into JSON.

```q
m: `message`val!("a structured message"; 42)
system "gcloud logging write --severity=INFO --payload-type=json kdb-log '", .j.j[m], "'"
```

Using system commands for logging is not convenient. A better approach is to use client libraries. There is no client library for the q programming language but you can use embedPy and the Python API as a workaround.

```q
\l p.q
p)from google.cloud import logging
p)logging_client = logging.Client()
p)log_name = 'kdb-log-embedpy'
p)logger = logging_client.logger(log_name)

qlogger:.p.get `logger

qlogger[`:log_text; "My kdb+ third log message as text"; `severity pykw `ERROR]

m: `message`val!("another structured message"; 42)
qlogger[`:log_struct; m; `severity pykw `ERROR]
```

Another way to interact with the Cloud Logging API is through the REST API. kdb+ supports HTTP get and post requests by utilities [`.Q.hg`](../../ref/dotq.md#hg-http-get) and [`.Q.hp`](../../ref/dotq.md#hp-http-post). The advantage of this approach is that you don’t need to install embedPy. Instead you have a portable pure-q solution. There is a long journey from `.Q.hp` till you have a fully featured cloud-logging library. The QLog library of kdb Insights spares you the trip. Call unary function `msg` in namespace `.qlog` to log a message. The argument is a string or a dictionary, depending on the type (structured or unstructured) of the message.

```q
.log.msg "unstructured message via QLog"
.log.msg `severity`labels`message!("ERROR"; `class`facility!`rdb`EOD; "Something went wrong")
```

QLog supports multiple endpoint types through a simple interface and lets you write to them concurrently. The logging endpoints in QLog are encoded as URLs with two main types: file descriptors and REST endpoints. The file descriptor endpoints supported are:

```txt
:fd://stdout
:fd://stderr
:fd:///path/to/file.log
```

REST endpoints are encoded as standard HTTP/S URLs such as: `https://logging.googleapis.com`. QLog generates structured, formatted log messages tagged with a severity level and component name. Routing rules can also be configured to suppress or route based on these tags.

Existing q libraries that implement their own formatting can still use QLog via the base APIs. This enables them to do their own formatting but still take advantage of the QLog-supported endpoints. Integration with cloud logging application providers can easily be achieved using logging agents. These can be set up alongside running containers/virtual machines to capture their output and forward to logging endpoints, such as Cloud Logging API.

Once the log messages are ingested you can search, sort and display them by

-   the `gcloud` command-line tool
-   [APIs Explorer](https://cloud.google.com/monitoring/api/apis-explorer)
-   [Legacy Logs Viewer](https://cloud.google.com/logging/docs/view/overview)

Logs Viewer is probably the best place to start the log analysis as it provides a slick web interface with a search bar and filters based on the most popular choices. A clear advantage of structured log messages over text-based ones is that you can make better use of the advanced search facility. You can restrict by any key, value pair in the boolean expression of filtering constraints.

Log messages can be filtered and copied to BigQuery, which allows a more advanced analysis thanks to the Standard SQL of BigQuery that provides superset functionality of ANSI SQL (e.g. by allowing array and JSON columns).

Key benefits of Cloud Logging:

-   Almost all kdb+tick components can benefit from Cloud Logging. Feed handlers log new data arrival, data and connection issues. The TP logs new or disappearing publishers and subscribers. It can log if the output queue is above a threshold. The RDB logs all steps of the EOD process which includes sorting and splaying of all tables. HDB and gateway can log every single user query.

-   kdb+ users often prefer to save log messages in kdb+ tables. Tables that are unlikely to change are specified by a schema, while entries that require more flexibility use key-value columns. Log tables are ingested by log tickerplants and these Ops tables are separated from the tables required for the business.

-   One benefit of storing log messages is the ability to process log messages in [qSQL](../../basics/qsql.md). Timeseries [join functions](../../basics/joins.md) include as-of and window joins. Consider how it investigates gateway functions that are executed hundreds of times during the day. The gateway query executes RDB and HDB queries and via load balancers. All these components have their own log entries. You can simply employ window join to find relevant entries and perform aggregation to get an insight of the performance characteristics of the execution chain.

    Nothing prevents you from logging both to kdb+ and to Cloud Logging.

-   Cloud Logging integrates with [Cloud Monitoring](https://cloud.google.com/monitoring). You may also wish to integrate your [KX Monitoring](../../devtools.md#kx-monitoring) for kdb+ components into this Cloud Logging and Cloud Monitoring framework. The purpose is the same, to get insights into performance, uptime and overall health of the applications and the servers pool. You can visualize trends via dashboards and set rules to trigger alarms.

Cloud Monitoring supports monitoring, alarming and creating dashboards. It is simple to create a Metric Filter based on a pattern and set an alarm (e.g. sending email) if a certain criterion holds. You may also wish to integrate your KX Monitoring for kdb+ components into this cloud logging and monitoring framework. The purpose is the same, to get insights into performance, uptime and overall health of the applications and the servers pool. You can visualize trends via dashboards.

<!-- ## Package, manage and deploy

QPacker (`qp`) is a tool to help developers package, manage and deploy q/kdb+ applications to the cloud. It automates the creation of containers and virtual machines using a simple configuration file `qp.json`. It packages q/kdb+ applications with common shared code dependencies, such as Python and C. QPacker can build and run containers locally as well as push to container registries (DockerHub, GCP Container Registry etc.).

Software is often built by disparate teams, who may individually have remit over a particular component, and package that component for consumption by others. QPacker will store all artifacts for a project in a QPK file. While this file is intended for binary dependencies, it is also designed to be portable across environments.

QPacker can interface with Hashicorp Packer to generate virtual-machine (VM) images for Google Cloud. These VM images can then be used as templates for a VM instance running in the cloud. When a cloud target is passed to QPacker (`qp build -gcp`), an image is generated for each application defined in the top-level `qp.json` file. The QPK file resulting from each application is installed into the image and integrated with `systemd` to allow the `startq.sh` launch script to start the application on boot. -->


## Google Cloud Functions

[Cloud Functions](https://cloud.google.com/functions) allow you to run code without worrying about infrastructure management. You deploy a code that is triggered by some event – the backend system is managed by Google Cloud. You pay only for the resource during the function execution. This may result in a better cost allocation than maintaining a complete backend server, by not paying for idle periods.

The function’s platform only supports Node.js, Java, Go, and Python programming languages. Python has a kdb+ API via PyQ but this requires starting up binary pyq, which is not supported. Java and Go have kdb+ client APIs, the former is maintained by KX.

One use case for Cloud Functions is implementing feed handlers. An upstream can drop, for instance, a CSV file to a Google Filestore bucket. This event can trigger a Java or Go cloud function that reads the file, applies some filtering or other data transformation, then sends the data to a tickerplant (TP). The real benefit of not caring about the backend infrastructure becomes obvious when the number of kdb+ tables, hence the number of feed handlers, increases, and distributing the feed handler on available servers needs constant human supervision.

A similar service, called [Cloud Run](https://cloud.google.com/run), can be leveraged to run kdb+ in a serverless architecture. The kdb+ binary and code can be containerized and deployed to Cloud Run. <!-- QPacker helps you create images. Cloud Run then provisions the containers and manages the underlying infrastructure. -->

## Service discovery

Feeds and the RDB need to know the address of the tickerplant. The gateway and the RDB need to know the address of the HDB. In fact, there are multiple RDBs and HDBs connecting to a gateway in practice. In a microservice infrastructure like kdb+tick, these configuration details are best stored in a configuration-management service. This is especially true if the addresses are constantly changing and new services are added dynamically.

Google offers [Service Directory](https://cloud.google.com/service-directory), a managed service, to reduce the complexity of management and operations by providing a single place to publish, discover, and connect services. Service Directory organizes services into namespaces. A service can have multiple attributes, called annotations, as key-value pairs. You can add several endpoints to
a service. The IP address and a port is mandatory for each end point. Unfortunately Service Directory neither validates addresses nor performs health checks.

kdb+ can easily interact with the Service Directory using Kurl. Kurl can be extended to create or query namespaces, discover or add and remove endpoints to facilitate service discovery of your kdb+ processes running in your tick environment. For example a kdb+ gateway can fetch from Service Directory the addresses of RDBs and HDBs. The cloud console also comes with a simple web interface to e.g. list the endpoints and their addresses of any service.


## Access management

We distinguish application and infrastructure level access control. Application-level access management controls who can access kdb+ components and run commands. tickerplant (TP), realtime database (RDB) and historical database (HDB) are generally restricted to kdb+ infra admins only and the gateway is the access point for the users. One responsibility of the gateway is to check if the user can access the tables (columns and rows) s/he is querying. This generally requires checking user ID (returned by [`.z.u`](../../ref/dotz.md#zu-user-id)) against some organizational entitlement database, cached locally in the gateway and refreshed periodically.

Google provides an enterprise-grade identity and access management referred to as Cloud IAM. It offers a unified way to administrate fine-grained actions on any Google Cloud resource including storage, VMs and logs.


## Hardware

service | VM instance type | storage | CPU, memory, I/O
--------|------------------|---------|-----------------
Tickerplant | High CPU<br>`n1-highcpu-[16-96]`<br>`n2-highcpu-[8-80]` | PD<br>local PD | High-Perf<br>Medium<br>Medium
Realtime Database | High Memory<br>`n1-highmem-[16-96]`<br>`n2-highmem-[8-80]` | | High-Perf<br>High-Capacity<br>Medium
Historical Database | High Memory<br>`n1-highmem-[16-96]`<br>`n2-highmem-[8-80]` | PD<br>ElastiFile | Medium Perf<br>Medium<br>High
Complex Event Processing (CEP) | Standard<br>`n1-standard-[16-96]`<br>`n2-standard-[8-80]` | | Medium Perf<br>Medium<br>High
Gateway | High CPU<br>`n1-highcpu-[16-96]`<br>`n2-highcpu-[8-80]` | | Medium-Perf<br>Medium<br>High


## Resources

:fontawesome-brands-github:
[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick):
standard `tick.q` scripts
<br>
:fontawesome-regular-map:
[Building Realtime Tick Subscribers](../../wp/rt-tick/index.md)
<br>
:fontawesome-regular-map:
[Data Recovery for kdb+ tick](../../wp/data-recovery.md)
Disaster-recovery planning for kdb+ tick systems
<br>
:fontawesome-regular-map:
[Intraday writedown solutions](../../wp/intraday-writedown/index.md)
<br>
:fontawesome-regular-map:
[Query Routing: a kdb+ framework for a scalable load-balanced system](../../wp/query-routing/index.md)
<br>
:fontawesome-regular-map:
[Order Book: a kdb+ intraday storage and access methodology](../../wp/order-book.md)
<br>
:fontawesome-regular-map:
[kdb+tick profiling for throughput optimization](../../wp/tick-profiling.md)

