---
title: Installing kdb+ – Learn – kdb+ and q documentation
description: How to install kdb+
author: Stephen Taylor
keywords: install, kdb+, q
---
# Installing kdb+



## :fontawesome-solid-download: Download

### Personal, non-commercial

Free 64-bit kdb+ On-Demand Personal Edition
: The 64-bit kdb+ On-Demand Personal Edition is free for personal, non-commercial use. Currently it may be used on up to 2 computers, and up to a maximum of 16 cores per computer, but is not licensed for use on any cloud – only personal computers. It requires an **always-on internet connection** to operate, and a **license key file**, obtainable from [ondemand.kx.com](https://ondemand.kx.com/)

Free 32-bit kdb+ Personal Edition
: The 32-bit kdb+ Personal Edition is free for non-commercial use. It can be run on cloud servers.

!!! warning ":fontawesome-brands-apple: macOS Catalina (10.15) ended macOS support for 32-bit applications."

Use the link below to obtain the 64-bit or 32-bit Personal Edition of kdb+.

<button style="background: #0088ff; padding: 10px;" type="button">
  <a href="https://kx.com/connect-with-us/download/" style="color: white">
    <span style="font-size: 2em">:fontawesome-solid-download: Get kdb+</span><br/>Personal, non-commercial
      :fontawesome-brands-linux:
      :fontawesome-brands-apple:
      :fontawesome-brands-windows:
  </a>
</button>


### Commercial 

Commercial versions of kdb+ are available to customers from [downloads.kx.com](https://downloads.kx.com). (Credentials for this site are issued to customers’ [Designated Contacts](../licensing.md#obtain-a-license-key-file)). 

!!! tip "Internal distribution"

    Most customers download the latest release of kdb+ (along with the accompanying README.txt, the detailed change list) and make a limited number of approved kdb+ versions available from a central file server. 

    Designated Contacts should encourage developers to keep production systems up to date with these versions of kdb+. This can greatly simplify development, deployment and debugging.


## Platforms and versions

The names of the ZIPs denote the platform (`l64.zip` – 64-bit Linux; `w32.zip` – 32-bit Windows, etc.).

Numerical release versions of the form 2.8, or 3.5 are production code. Versions of kdb+ with a trailing `t` in the name such as `3.7t` are test versions and are neither intended nor supported for production use.


## Install

Follow the installation instructions for your operating system:

-   :fontawesome-brands-linux: [Linux](linux.md)
-   :fontawesome-brands-apple: [macOS](macos.md)
-   :fontawesome-brands-windows: [Windows](windows.md)


## :fontawesome-solid-certificate: Licenses

### Personal, non-commercial

Use of the Free 64-bit kdb+ On-Demand Personal Edition is governed by the [On Demand terms and conditions](https://ondemand.kx.com/) and requires a [license key file](../licensing.md) to run.

Use of the Free 32-bit kdb+ Personal Edition is governed by the [32-bit terms and conditions](https://kx.com/download/) and requires no license key file.


### Commercial

Use of commercial kdb+ is covered by your license agreement with Kx.
Ensure your kdb+ installation is connected to your `k4.lic` or `kc.lic` [license key file](../licensing.md).

:fontawesome-regular-hand-point-right: [License errors](../../basics/errors.md#license-errors), [Licensing](../licensing.md), [Linux production notes](../../kb/linux-production.md)


## :fontawesome-regular-hand-point-right: What’s next?

[Learn the q programming language](../index.md#learn-q), look through the [reference card](../..//ref/index.md), or see in the [Knowledge Base](../../kb/index.md)  what you can do with kdb+.

