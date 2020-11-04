---
title: S3QL – Appendix G of Migrating a kdb+ HDB to Amazon EC2 – Cloud – kdb+ and q documentation
description: The code is perhaps the least-referenced open-source S3 gateway package, and from a vanilla RHEL 7.3 build we had to add a significant number of packages to get to the utility compiled and installed. S3QL is written in Python. Significant additions are required to build S3QL namely llfuse, Python3, Cython, Python-pip, EPEL and SQlite.
author: Glenn Wright
date: March 2018
keywords: Amazon, AWS, EC2, HDB, cloud, kdb+, s3ql
---
# Appendix G - S3QL



The code is perhaps the least-referenced open-source S3 gateway package, and from a vanilla RHEL 7.3 build we had to add a significant number of packages to get to the utility compiled and installed. 
S3QL is written in Python. 
Significant additions are required to build S3QL namely: llfuse, Python3, Cython, Python-pip, EPEL and SQlite.

S3QL uses the Python bindings (llfuse) to the Linux user-mode kernel FUSE layer. 
By default, it uses the POSIX handle mapped as an S3 object in a one-to-one map. 
S3QL supports only one node sharing one subset (directory) tree of one S3 bucket. 
There is no sharing in this model.

Several code exception/faults were seen in Python subroutines of the
`mkfs.s3ql` utility during initial test so, due to time pressures, we
will revisit this later.

Although the process exceptions are probably due to a build error, and plainly the product does work, this does highlight that the build process was unusually complex, due to the nature of so many dependencies on other open-source components. 
This may play as a factor in the decision process for selecting solutions.




<div class="kx-nav" markdown="1">
<div class="kx-nav-prev">[F. S3FS](app-f-s3fs.md)</div><div class="kx-nav-next">[H. ObjectiveFS](app-h-objectivefs.md)</div>
</div>
