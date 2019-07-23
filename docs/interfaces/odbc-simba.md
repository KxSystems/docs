---
title: Simba/Magnitude ODBC
description: How to use a the Simba ODBC Driver to connect to a kdb+ server process
author: Glenn Wright
date: March 2019
keywords: interface, kdb+, library, magnitude, odbc, odbc3, q, simba, sql
---
# <i class="fas fa-database"></i> Simba/Magnitude ODBC



!!! info "Current version"

    The latest version of Simba/Magnitude ODBC is 1.1, released 2019.07.04.


The Simba Kdb+ ODBC Driver enables Business Intelligence (BI), analytics, and reporting on kdb+ data. The driver complies with the ODBC 3.80 data standard and adds important functionality such as Unicode, as well as 32- and 64-bit support for high-performance computing environments on all platforms.

ODBC is one of the best established and widely supported APIs for connecting to and working with databases. At the heart of the technology is the ODBC driver, which connects an application to the database.

<i class="far fa-hand-point-right"></i>
simba.com: [Data Access Standards](https://www.simba.com/resources/data-access-standards-glossary)  
microsoft.com: [ODBC API Reference](https://docs.microsoft.com/en-us/sql/odbc/reference/syntax/odbc-api-reference)


## Clients

The Simba Kdb+ ODBC Driver is available for these clients:

-   <i class="fab fa-linux"></i> Linux
    +   RedHat®EnterpriseLinux®(RHEL) 6 or 7
    +   CentOS 6 or 7
    +   SUSE Linux EnterpriseServer (SLES) 11 or 12
    +   Debian 8 or 9
    +   Ubuntu 14.04, 16.04, or 18.04
-   <i class="fab fa-apple"></i> macOS version 10.12, 10.13, or 10.14
-   <i class="fab fa-windows"></i> Microsoft® Windows® 
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

<i class="fas fa-download"></i> 
[_Installation and Configuration Guide_](/download/simba-kdb-odbc-install-and-configuration-guide.pdf)
(PDF 1.5MB)

os | bit | file | size | md5
---|-----|------|------|-------------------------
Linux | 64 | [`simbakdb-1.1.0.1000-1.x86_64.rpm`](/download/simbakdb-1.1.0.1000-1.x86_64.rpm) | 20MB | `f01e05f05f40fc16c3c29254b1ba25bc`
Linux | 32 | [`simbakdb-1.1.0.1000-1.i686.rpm`](/download/simbakdb-1.1.0.1000-1.i686.rpm) | 20MB | `59e454a35a1b7c1f8d7ec22926688470`
macOS |    | [`simba-kdb-1.1.dmg`](/download/simba-kdb-1.1.dmg) | 35MB | `fcb7db71b7bd461e72d6df74f2056a32`
Windows | 64 | [`simba-kdb-1.1-64-bit.msi`](/download/simba-kdb-1.1-64-bit.msi) | 17MB | `3844c00a9922f772fae584baecd4c71c`
Windows | 32 | [`simba-kdb-1.1-32-bit.msi`](/download/simba-kdb-1.1-32-bit.msi) | 16MB | `f69dc00d6b00320914a3f5aae9a34804`
Windows | | [`simba-kdb-odbc-driver.tdc`](/download/simba-kdb-odbc-driver.tdc)<br/>(Common config file) | 2kB | `bdc05a4eb0a3b5602d210446da06d25c`


## License

The license for the driver itself is presented during installation. 
One can then choose to accept the license or abort the installation.
The driver is sponsored by Kx, at no cost to the end user.

<!-- 
## Prior releases

The biggest change from previous releases is that with this version you install and run the driver entirely from the client perspective.

 -->