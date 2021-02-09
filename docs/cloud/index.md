---
title: KX and the cloud
author: P.J. O’Kane
date: March 2020
---
# KX and the cloud


![cloud computing](../img/cloud-computing.jpg)
<!-- GettyImages-1087885966 -->

KX technology was created to address one of the most basic problems in high-performance computing: the inability of traditional relational database technology to keep up with the explosive escalation of data volumes. 

Ever since, our singular goal has been to provide clients and partners with the most efficient and flexible tools for ultra-high-speed processing of real-time, streaming and historical data. The resulting KX streaming-analytics platform provides a framework for designing, building and deploying data-capture systems and visualizations. 

Designed from the start for extreme scale, and running on industry-standard servers, KX technology has been proven to solve complex problems faster than any of its competitors.

The basis for KX technology is kdb+, the world’s fastest timeseries database. It is a uniquely integrated platform combining:

-   a high-performance timeseries columnar database
-   an in-memory compute engine
-   a real-time streaming processor
-   an expressive query and programming language, q

Solutions created on the KX framework have extensive redundancy, fault tolerance, query filtering, alerting, reporting and visualization features. They are used for stock-market analysis, algorithmic trading, predictive analytics, scientific analysis, and embedded-sensor data capture for IoT use cases.


## Why cloud?

KX is a certified Amazon Solutions Partner and Google Cloud Partner and has successfully deployed on numerous public, private and hybrid clouds.

Some motivations for cloud deployments:

**Instant scaling**

: Data analytics processing and/or storage capacity can be scaled up instantly, on-demand, and without putting extra hardware in your own data center.

**Bursty workloads**

: Cloud may be ideal for burst processing of your compute load. For example, you might need to run hundreds of cores for just 30 minutes in a day for a specific risk-calculation workload.

**Periodic data access**

: Your quants and developers might want to work on kdb+ only for a few hours a day during the work week. This is a suitable model for an on-demand or a spot-pricing service.

**Development/UAT/Prod life-cycles**

: These can be hosted on their own instances and spun down at the end of each phase. Small memory/core instances can be cheap, and enlarged or shrunk at need.


## Deployments

KX customers have deployed kdb+ and other KX solutions successfully in the cloud, including the three main cloud vendors: 

-   [kdb+ on Amazon Web Services](aws/index.md) :fontawesome-brands-aws: 
-   [kdb+ on Google Cloud Platform](gcpm/index.md) 
-   Microsoft Azure


