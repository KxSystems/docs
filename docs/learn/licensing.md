---
title: Licensing kdb+ – Learn – kdb+ and q documentation
description: How to ensure your kdb+ processes have the licenses they need.
author: Stephen Taylor
keywords: commercial, free, kdb+, key file, license, license key file, licensing, non-commercial, on-demand, q, qhome, qlic
---
# :fontawesome-solid-certificate: Licensing


## Who needs a license for kdb+?

Everyone. All use of kdb+ is governed by a license. Without one, kdb+ signals an error [`'k4.lic`](../basics/errors.md#k4.lic) and aborts.

64-bit installations require a **license key file**: `k4.lic`, or `kc.lic` for kdb+ On Demand.

If both are found, the `kc.lic` file is used.


## Obtain a license key file

A license file can be a commercial license or an on-demand person license (for non-commercial use).

### On-Demand License

It requires a `kc.lic` license key file and an always-on internet connection to operate.

#### Licensing server

If kdb+ with an on-demand license cannot contact the KX license server it will abort with a timestamped message.

```q
'2018.03.28T11:20:03.831 couldn't connect to license daemon -- exiting
```

If an HTTP proxy is required, the environment variables `http_proxy` or `HTTP_PROXY` define the URL of the HTTP proxy to use.
Since 4.1t 2022.11.01,4.0 2022.10.26,4.0ce 2022.09.16 the on-demand system honours the NO_PROXY/no_proxy environment variables, with the lowercase version taking precedence.

### Commercial License

Use of commercial kdb+ is covered by your license agreement with KX.

Your copy of kdb+ will need access to a valid license key file.

If you wish to begin using kdb+ commercially, please contact sales@kx.com.

## Install the license key file

Save a copy of the license key file (`k4.lic` or `kc.lic`) in the `QHOME` folder. 
(See [installation instructions](install.md#step-3-install-the-license-file) for your operating system.) 
Restart your kdb+ session and note the change in the banner. 

```txt
tom@mb13:~/q$ q
KDB+ 3.6 2018.07.30 Copyright (C) 1993-2018 Kx Systems
m64/ 2()core 8192MB tom mb13.local 192.168.1.44 EXPIRE 2019.05.15 tom@kx.com #400
q)til 6
0 1 2 3 4 5
q)
```

Note the license number (`#400` in the example) and quote it in any correspondence about the license. 

If you are sharing use of a commercial license, you will probably want to set the environment variable `QLIC` to the path of the license key file, as below.

### License errors

A list of possible errors can be found [here](../basics/errors.md#license-errors).


### Keeping the license key file elsewhere

The default location for the license key file is the `QHOME` folder. You do not have to keep the license key file there. You can use the environment variable `QLIC` to specify a different filepath.

!!! tip "Folder not file"

    Like `QHOME`, `QLIC` points to a folder, not a file. For example,

    ```bash
    QLIC='/Users/simon/q'
    ```

Note: If a license file is found in the current working directory it will be used preferentially over any found in `QLIC` and `QHOME`.

## Core restrictions

If the license is for fewer cores than the total number on the machine, the number of cores available to kdb+ must be [restricted with OS programs](../kb/cpu-affinity.md), or kdb+ will signal `'cores` and abort.

```txt
KDB+ 3.6 2018.07.30 Copyright (C) 1993-2018 Kx Systems
m64/ 4(3)core 16384MB simon simon-macos.local 127.0.0.1   simon@kx.com #40000

'cores
```

As long as you use `taskset` or `numa` correctly, the binary will not abort itself.

You can see the number of cores entitled to a q process:

-   by looking at the banner, e.g. `…m64/ 4(3)core…` – the 4 here is the number of cores reported by the OS, and the 3 is the number of cores licensed 
-   with [`.z.c`](../ref/dotz.md#zc-cores) – not the physical cores of the system, but rather the number the process is allowed to use
-   the first element of [`.z.l`](../ref/dotz.md#zl-license) 

The number of licensed cores is always 16 for the on-demand license. 


!!! tip "On the road"

    The license key file binds the interpreter to your computer’s hostname.
    For example, for a Mac named `mymbp` the hostname might be `mymbp.local`.
    When traveling you may find a network has changed the hostname, for example to `mymbp.lan` or `mymbp.fritz.box`. kdb+ then signals a host error on launch. 

    Linux and macOS users can restore their hostnames from the command shell, e.g. 

    ```bash
    scutil --set HostName "mymbp.local"
    ```

## License questions

Designated Contacts should send license questions to licadmin@kx.com. 

## Emergency failover licenses

In case of an emergency, such as a hardware or infrastructure failure that renders your license key file unusable, the Designated Contact can email failover@kx.com to request a temporary failover license to allow use of a different machine or IP address. 

