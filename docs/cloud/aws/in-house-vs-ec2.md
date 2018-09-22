hero: <i class="fa fa-cloud"></i> Cloud


# In-house vs EC2

Kdb+ is used to support 

-   real-time data analytics
-   streaming data analytics
-   historical data analytics

The historical database in a kdb+ solution is typically kept on a non-volatile persistent storage medium (a.k.a. _disks_). 
In financial services this data is kept for research (quant analytics or back-testing), algorithmic trading and for regulatory and compliance requirements.

!!! warning "Low latency and the Cloud"

    In the current state of cloud infrastructure, Kx does not recommend keeping the high-performance, low-latency part of market data – or streaming data collection – applications in the Cloud.

    When speed translates to competitive advantage, using AWS (or cloud in general) needs to be considered carefully.

Carefully-architected cloud solutions are acceptable for parts of the
application that are removed from from the cutting-edge performance and
data-capture requirements often imposed on kdb+. For example, using
parallel transfers with a proven simple technology such as `rsync`, that can
take advantage of the kdb+ data structures (distinct columns that
can safely be transferred in parallel) and the innate compressibility of
some of the data types to transfer data to historical storage in a cloud
environment at end of day.

Storage and management of historical data can be a non-trivial
undertaking for many organizations: 

-   capital and running costs 
-   overhead of maintaining security policies
-   roles and technologies required
-   planning for data growth and disaster recovery

AWS uses tried-and-tested infrastructure, which includes excellent policies and processes for handling such production issues.

Before we get to the analysis of the storage options, it is important to
take a quick look at the performance you might expect from compute and
memory in your EC2 instances.


## CPU cores 

We assume you require the same number of cores and
memory quantities as you use on your in-house bare-metal servers. The
chipset used by the instance of your choice will list the number of
cores offered by that instance. The definition used by AWS to describe
cores is vCPUs. It is important to note that with very few exceptions,
the vCPU represents a hyper-threaded core, not a physical core. This is
normally run at a ratio of 2 hyper-threaded cores to one physical core.
There is no easy way to eliminate this setting. Some of the very large
instances do deploy on two sockets. For example, `r4.16xlarge` uses two
sockets.

If your sizing calculations depend on getting one q process to run
only on one physical core and not share itself with other q processes,
or threads, you need to either 

-   use CPU binding on q execution
-   invalidate the execution on even, or odd, core counts

Or you can run on instances that have more vCPUs than there will be instances
running. For the purposes of these benchmarks, we have focused our
testing on single socket instances, with a limit of 16 vCPUs, meaning
eight physical cores, thus:
```bash
[centos@nano-client1 ~]$ lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Byte Order: Little Endian
CPU(s): 16
On-line CPU(s) list: 0-15
Thread(s) per core: 2
Core(s) per socket: 8
Socket(s): 1
NUMA node(s): 1
Vendor ID: GenuineIntel
CPU family: 6
Model: 79
Model name: Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz
```


## System memory

Memory sizes vary by the instance chosen. 

!!! warning "Memory lost to hypervisor"

    Memory is reduced from the nominal “power of two” RAM sizing, as some is set aside for the Xen hypervisor. For example, a nominal 128 GB of RAM gets sized to approximately 120 GB. 

    Take account of this in your memory sizing exercises.


## Compute and memory performance

For CPU and memory, the EC2 performance matches that seen on physical systems, when correlated to the memory specifications. So the default HVM mode of an AMI under Xen seems to work efficiently when compared to a native/physical server.

There is one caveat to this, in testing kdb+ list creation speeds we observe a degradation of memory list creation times when the number of q processes running exceeds the number of vCPUs in the virtual machine. This is because the vCPU in EC2 is actually a single hyperthreaded core, and not a physical core. In this example, we see competition on the physical cores. For a 16 vCPU instance we notice this only when running above 8 q processes:

![](img/media/image4.png)

!!! info "Megabytes and mebibytes"

    Throughout this paper, MB and GB are used to refer to [MiBytes](https://en.wikipedia.org/wiki/Mebibyte "Wikipedia") and GiBytes respectively.


## Network and storage performance

As expected, we see more noticeable performance variations with the aspects of the system that are virtualized and shared in EC2, especially those which in principle are shared amongst others on the platform. For kdb+ users, the storage (I/O) and the networking access are virtualized/shared, being separated from the bare metal by the Xen hypervisor. Most of the AMIs deployed into EC2 today are based on the Hardware Virtual Machine layer (HVM). It seems that in recent instantiations of HVM, the performance for I/O aspects of the guest have improved. For the best performance, AWS recommends current-generation instance types and HVM AMIs when you launch your instances.
Any storage solution that hosts historical market data must:

-   support the Linux-hosted [POSIX file system](https://en.wikipedia.org/wiki/POSIX) interfaces
-   offer suitable performance for streaming and random I/O mapped read
rates
-   offer acceptable performance for random-region reads of a table (splayed) columns, constituting large record reads from random regions of the file

These aspects, and inspection of metadata performance, are summarized in the tests. The term _metadata_ is used to refer to file operations such as listing files in a directory, gathering file size of a file, appending, finding modification dates, and so on.

!!! warning "Using Amazon S3 as a data store"

    Because kdb+ does not directly support the use of an object store for its stored data, it cannot support direct use of an object-store model such as the Amazon S3. If you wish to use Amazon S3 as a data store, kdb+ historical data must be hosted on a POSIX-based file system layer fronting S3.

    Several solutions offer a POSIX interface layered over an underlying S3 storage bucket. These can be included alongside native file-system support that can also be hosted on EC2.

Although EC2 offers both physical systems and virtual systems within the Elastic Cloud, it is most likely customers will opt for a virtualized environment. There is also a choice in EC2 between spot pricing of an EC2, and deployed virtual instances. We focus here on the attribute and results achieved with the deployed virtual instance model. These are represented by instances that are tested in one availability zone and one placement group.

A _placement group_ is a logical grouping of instances within a single availability zone. Nodes in a placement group should gain better network latency figures when compared to nodes scattered anywhere within an availability zone. Think of this as placement subnets or racks with a data center, as opposed to the datacenter itself. All of our tests use one placement group, unless otherwise stated.

Kdb+ is supported on most mainstream Linux distributions, and by extension we support standard Linux distributions deployed under the AWS model.

Testing within this report was carried out typically on CentOS 7.3 or 7.4 distributions, but all other mainstream Linux distributions are expected to work equally well, with no noticeable performance differences seen in spot testing on RHEL, Ubuntu and SuSe running on EC2.


## Does kdb+ work in the same way under EC2?

Yes – mostly.

When porting or hosting the HDB data to EC2, we expect our customers to:

1.  Use one of the many POSIX-based file systems solutions available under EC2.

1.  Use (partly or fully) the lower-cost object storage via a POSIX or POSIX-like access method.

1.  Not store the historical data on Hadoop HDFS file systems.

If kdb+ runs alongside one of the solutions reviewed here, your HDB will function identically to any internally-hosted, bare-metal system. You can use this report as input to determine the performance and the relative costs for an HDB solution on EC2.


