---
hero: <i class="fa fa-cloud"></i> Cloud
title: Migrating a kdb+ HDB to Amazon EC2
author: Glenn Wright
date: March 2018
keywords: Amazon, AWS, EC2, HDB, cloud
---

# Migrating a kdb+ HDB to Amazon EC2 

![Amazon Elastic Compute Cloud](img/media/ec2.png)

Kx has an ongoing project of evaluating different cloud technologies to see how they interact with kdb+. 
If you are assessing migrating a kdb+ historical database (HDB) and analytics workloads into the 
[Amazon Elastic Compute Cloud](https://aws.amazon.com/ec2/) 
(EC2), here are key considerations:

-   performance and functionality attributes expected from using kdb+, and the associated HDB, in EC2
-   capabilities of several storage solutions working in the EC2
environment, as of March 2018
-  performance attributes of EC2, and benchmark results

You must weigh the pros and cons of each solution.
The key issues of each approach are discussed in the Appendices. 
We highlight specific functional constraints of each solution. 

We cover some of the in-house solutions supplied by Amazon Web Services (AWS), as well as a selection of some of the third-party solutions sold and supported for EC2, and a few open-source products. Most of these solutions are freely available for building and testing using Amazon Machine Images (AMI) found within the Amazon Marketplace.


## Why Amazon EC2?

[Gartner](http://fortune.com/2017/06/15/gartner-cloud-rankings/),
and other sources such as [Synergy
Research](https://www.srgresearch.com/articles/microsoft-google-and-ibm-charge-public-cloud-expense-smaller-providers),
rank cloud-services providers:

1. Amazon Web Services
1. Microsoft Azure 
1. Google Cloud Platform

This is partly due to the fact that Amazon was first to market, and
partly because of their strong global data-center presence and rich
sets of APIs and tools.

Amazon EC2 is one of many services available to AWS users, and is managed via the AWS console. EC2 is typically used to host public estates of Web and mobile-based applications. Many of these are ubiquitous and familiar to the public. EC2 forms a significant part of the “Web 2.0/Semantic Web” applications available for mobile and desktop computing.

Kdb+ is a high-performance technology. It is often assumed the Cloud cannot provide a level of performance, storage and memory access commensurate with dedicated or custom hardware implementations. Porting to EC2 requires careful assessment of the functional performance constraints both in EC2 compute and in the supporting storage layers.

Kdb+ users are sensitive to database performance. Many have significant amounts of market data – sometimes hundreds of petabytes – hosted in data centers. Understanding the issues is critical to a successful migration.

Consider the following scenarios:

-   Your internal IT data services team is moving from an in-house data center to a cloud-services offering. This could be in order to move the IT costs of the internal data center from a capital expense line to an operating expense line.

-   You need your data analytics processing and/or storage capacity to be scaled up _instantly_, _on-demand_, and without the need to provide extra hardware in your own data center.

-   You believe the Cloud may be ideal for burst processing of your compute load. For example, you may need to run 100s of cores for just 30 minutes in a day for a specific risk-calculation workload.

-   Your quants and developers might want to work on kdb+, but only for a few hours in the day during the work week, a suitable model for an on-demand or a spot-pricing service.

-   You want to drive warm backups of data from in-house to EC2, or across instances/regions in EC2 – spun up for backups, then shut down.

-   Development/UAT/Prod life-cycles can be hosted on their own instances and then spun down after each phase finishes. Small memory/core instances can cost less and can be increased or decreased on demand.

Hosting both the compute workload and the historical market data on
EC2 can achieve the best of both worlds: 

-   reduce overall costs for hosting the market data pool
-   flex to the desired performance levels

As long as the speed of deployment and ease of use is coupled with similar or _good enough_ runtime performance, EC2 can be a serious contender for hosting your market data.


## Author

Glenn Wright, Systems Architect, Kx Systems, has 30+ years of experience within the high-performance computing industry. He has worked for several software and systems vendors where he has focused on the architecture, design and implementation of extreme performance solutions. At Kx, Glenn supports partners and solutions vendors to further exploit the industry- leading performance and enterprise aspects of kdb+.
