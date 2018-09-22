hero: <i class="fa fa-cloud"></i> Cloud

# Observations from kdb+ testing 



## CPU and memory speed

For CPU and memory speed/latencies with kdb+, EC2 compute nodes performance for CPU/memory mirrors the capability of logically equivalent bare-metal servers. At time of writing, your main decision here is the selection of system instance. CPUs range from older generation Intel up to Haswell and Broadwell, and from 1 core up to 128 vcores (vCPU). Memory ranges from 1&nbsp;GB up to 1952&nbsp;GB RAM.


## Storage performance

The best storage performance was, as expected, achieved with locally-attached ephemeral NVMe storage. This matched, or exceeded, EBS as that storage is virtualized and will have higher latency figures. As data kept on this device cannot be easily shared, we anticipate this being considered for a super cache for hot data (recent dates). Data stored here would have to be replicated at some point as this data could be lost if the instance is shut down by the operator.


## Wire speeds

Kdb+ reaches wire speeds on most streaming read tests to networked/shared storage, under kdb+, and in several cases we can reach wire speeds for random 1-MB reads using standard mapped reads into standard q abstractions, such as lists.


## `gp2` vs `io1`

EBS was tested for both `gp2` and its brethren the `io1` flash variation. Kdb+ achieved wire speed bandwidth for both of these. When used for larger capacities, we saw no significant advantages of `io1` for the HDB store use case, so the additional charges applied there need to be considered.


## `st1`

EBS results for the `st1` devices (low cost traditional disk drives, lower cost per GB) show good (90th-percentile) results for streaming and random 1-MB reads, but, as expected, significantly slower results for random 64-KB and 1-MB reads, and 4× the latencies for metadata ops. Consider these as a good candidate for storing longer term, older HDB data to reduce costs for owned EBS storage.


## ObjectiveFS and WekaIO Matrix

ObjectiveFS and WekaIO Matrix are commercial products that offer full operational functionality for the POSIX interface, when compared to open-source S3 gateway products. These can be used to store and read your data from/to S3 buckets. 

WekaIO Matrix offers an erasure-encoded clustered file-system, which works by sharing out pieces of the data around each of the members of the Matrix cluster. 

ObjectiveFS works between kdb+ and S3 with a per-instance buffer cache plus distributed eventual consistency. It also allows you to cache files locally in RAM cache and/or on ephemeral drives within the instance. Caching to locally provisioned drives is likely to be more attractive vs. caching to another RAM cache.


## POSIX file systems

Standalone file systems such as MapR-FS and Quobyte support POSIX fully. Other distributed file systems designed from the offset to support POSIX should fare equally well, as to some degree, the networking infrastructure is consistent when measured within one availability zone or placement group. Although these file system services are encapsulated in the AWS marketplace as AMI’s, you are obliged to run this estate alongside your HDB compute estate, as you would own and manage the HDB just the same as if it were in-house. Although the vendors supply AWS marketplace instances, you would own and running your own instances required for the file system.


## WekaIO and Quobyte

WekaIO and Quobyte use a distributed file-system based on erasure-coding distribution of data amongst their quorum of nodes in the cluster. This may be appealing to customers wanting to provision the HDB data alongside the compute nodes. If, for example, you anticipate using eight or nine nodes in production these nodes could also be configured to fully own and manage the file system in a reliable way, and would not mandate the creation of distinct file-system services to be created in other AWS instances in the VPC. 

What might not be immediately apparent is that for this style of product, they will scavenge at least one core on every participating node in order to run their erasure-coding algorithm most efficiently. This core will load at 100% CPU.


## EFS and AWS Gateway

Avoid [EFS](http://docs.aws.amazon.com/efs/latest/ug/performance.html) and AWS Gateway for HDB storage. They both exhibit very high latencies of operation in addition to the network-bandwidth constraints. They appear to impact further on the overall performance degradations seen in generic NFS builds in Linux. This stems from the latency between a customer-owned S3 bucket (AWS Gateway), and an availability zone wide distribution of S3 buckets managed privately by AWS.


## Open-source products

Although the open source products that front an S3 store (S3FS, S3QL and Goofys) do offer POSIX, they all fail to offer full POSIX semantics such as symbolic linking, hard linking and file locking. Although these may not be crucial for your use case, it needs consideration. 

You might also want to avoid these, as performance of them is at best average, partly because they both employ user-level FUSE code for POSIX support.



