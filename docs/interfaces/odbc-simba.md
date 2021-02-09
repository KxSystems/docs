---
title: Simba/Magnitude ODBC – Interfaces – kdb+ and q documentation
description: How to use a the Simba ODBC Driver to connect to a kdb+ server process
author: Glenn Wright
date: March 2019
keywords: interface, kdb+, library, magnitude, odbc, odbc3, q, simba, sql
---
# :fontawesome-solid-database: Simba/Magnitude ODBC



!!! info "The latest version of Simba/Magnitude ODBC is 1.1.1, released 2020.02.14."


The Simba Kdb+ ODBC Driver enables Business Intelligence (BI), analytics, and reporting on kdb+ data. The driver complies with the ODBC 3.80 data standard and adds important functionality such as Unicode, as well as 32- and 64-bit support for high-performance computing environments on all platforms.

ODBC is one of the best established and widely supported APIs for connecting to and working with databases. At the heart of the technology is the ODBC driver, which connects an application to the database.

:fontawesome-regular-hand-point-right:
simba.com: [Data Access Standards](https://www.simba.com/resources/data-access-standards-glossary/)
microsoft.com: [ODBC API Reference](https://docs.microsoft.com/en-us/sql/odbc/reference/syntax/odbc-api-reference?view=sql-server-2017)


## Clients

The Simba Kdb+ ODBC Driver is available for these clients:

-   :fontawesome-brands-linux: Linux
    +   RedHat®EnterpriseLinux®(RHEL) 6 or 7
    +   CentOS 6 or 7
    +   SUSE Linux EnterpriseServer (SLES) 11 or 12
    +   Debian 8 or 9
    +   Ubuntu 14.04, 16.04, or 18.04
-   :fontawesome-brands-apple: macOS version 10.12, 10.13, or 10.14
-   :fontawesome-brands-windows: Microsoft® Windows®
    +   Windows 10, 8.1, or 7 SP1
    +   WindowsServer 2016, 2012, or 2008R2SP1


The primary target for this release is support for:

-   Tableau (certification compliance included)
-   PowerBI
-   Excel


## Downloads

The
_Installation and Configuration Guide_
is suitable for all users who are looking to access kdb+ data from their desktop environment.

:fontawesome-solid-download:
[_Installation and Configuration Guide_](/download/simba-kdb-odbc-install-and-configuration-guide.pdf)
(PDF 1.5MB)

!!! info "The latest version of Simba/Magnitude ODBC is 1.1.1, released 2020.02.14."

<div markdown="1" class="typewriter">
Linux     [linux-1.1.1.zip](/download/linux-1.1.1.zip)          42MB fc2eb21cfdb54617b2c795ac2e5eab61
macOS     [osx-1.1.1.zip](/download/osx-1.1.1.zip)            35MB d5427c1b84ad6ee4a0563099159e276f
Windows   [windows-1.1.1.zip](/download/windows-1.1.1.zip)        32MB d87519bd7a197471f26bad4dc7f18c13
</div>

<!-- Linux
 64 [`simbakdb-1.1.1.1000-1.x86_64.rpm`](/download/simbakdb-1.1.1.1000-1.x86_64.rpm)   eefafb40b28f574a8f5ce1603112f992
 32 [`simbakdb-1.1.1.1000-1.i686.rpm`](/download/simbakdb-1.1.1.1000-1.i686.rpm)     0989e038d86335f83bf1390bdc2827a8

macOS
    [`simba-kdb-1.1.dmg`](/download/simba-kdb-1.1.dmg)                  1800022aabd7b1b707ae1603c55c4273

Windows
 64 [`simba-kdb-1.1-64-bit.msi`](/download/simba-kdb-1.1-64-bit.msi)           ca70acfa4f02ac8443c6e9b7ca0bc2f9
 32 [`simba-kdb-1.1-32-bit.msi`](/download/simba-kdb-1.1-32-bit.msi)           34fe980c2408f369956d58c695b49e7b
 Common config file:
    [`simba-kdb-odbc-driver.tdc`](/download/simba-kdb-odbc-driver.tdc)          bdc05a4eb0a3b5602d210446da06d25c
 -->

## License

The license for the driver itself is presented during installation.
One can then choose to accept the license or abort the installation.
The driver is sponsored by KX, at no cost to the end user.

<!--
## Prior releases

The biggest change from previous releases is that with this version you install and run the driver entirely from the client perspective.

 -->