---
title: Memory backed by filesystem | Basics | q and kdb+ documentation
description: Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+
author: KX Systems, Inc., a subsidiary of KX Software Limited
date: November 2019
keywords: appdirect, dax, memory, thread
---
# The `.m` namespace

Since V4.0 2020.03.17

!!! warning "Breaking change"

    The `.m` namespace was used for a different purpose in previous versions of kdb+. Existing code should be changed to remove this usage, as it may cause unexpected issues.

The `.m` namespace holds the local namespaces of modules. They should not be accessed directly but by using the interface provided by the module.
