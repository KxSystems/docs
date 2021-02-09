---
title: Linux production notes – Knowledge Base – kdb+ and q documentation
description: Notes for deploying kdb+ processes on production Linux servers
keywords: kdb+, linux, production, q
---
# Linux production notes



!!! important "Linux kernels"

    KX recommendations for NUMA hardware, Transparent Huge Pages and Huge Pages are different for different Linux kernels. 
    Details below. Look for the :fontawesome-solid-code: icon. 



## Non-Uniform Access Memory (NUMA) hardware

Historically, there have been a number of situations where the choice of NUMA memory management settings in the kernel would adversely affect the performance of q on systems using NUMA memory architectures. This resulted in higher-than-expected system-process usage for q, and lower memory performance. For this reason we made certain recommendations for the settings for memory interleave and transparent huge pages. 

One of the performance issues seen by q in this context is the same as the “swap insanity” issue, as linked below. Essentially, when the Linux kernel decides to swap out dirty pages, due to memory exhaustion, it was observed to affect performance of q, significantly more than expected. A relief for this situation was achieved via setting NUMA interleaving options in the kernel.

However, with the introduction of new Linux distributions based on newer kernel versions we now recommend different NUMA settings, depending on the version of the distribution being used. The use of the interleave feature should still be considered for those cases where your code drives the q processes to write to memory pages in excess of the physical memory capacity of the node. For distributions based on kernels

-   **3.x or higher**, please disable `interleave`, and enable `zone_reclaim`; for all situations where memory page demand is constrained to the physical memory space of the node, this should return a better overall performance.  
-   **2.6 or earlier** (e.g RHEL 6.7 or CentoS 6.7 or earlier), we recommend to disable NUMA, and instead set an interleave memory policy, especially in the use-case described above.

Linux kernel   | NUMA    | interleave memory | zone-reclaimed
---------------|---------|-------------------|---------------
3.x or higher  | enable  | disable           | enable        
2.6 or earlier | disable | enable            |

In both cases, q is unaware of whether NUMA is enabled or not.

If possible, you should change the NUMA settings via a BIOS setting, if that is supported by your system. Otherwise use the technique below.

To fully disable NUMA and enable an interleave memory policy, start q with the `numactl` command as follows

```bash
$ numactl --interleave=all q
```

_and_ disable zone-reclaim in the proc settings as follows

```bash
$ echo 0 > /proc/sys/vm/zone_reclaim_mode
```

!!! info "The MySQL “swap insanity” problem and the effects of NUMA"

    Although [**this post**](https://blog.jcole.us/2010/09/28/mysql-swap-insanity-and-the-numa-architecture/) is about the impact on MySQL, the issues are the same for other databases such as q.

To find out whether NUMA is enabled in your bios, use

```bash
$ dmesg | grep -i numa
```

And to see if NUMA is enabled on a process basis

```bash
$ numactl -s
```

:fontawesome-regular-hand-point-right: 
[CPU affinity – Linux](cpu-affinity.md#linux)


## Huge Pages and Transparent Huge Pages (THP)

A number of customers have been impacted by bugs in the Linux kernel with respect to Transparent Huge Pages. These issues manifest themselves as process crashes, stalls at 100% CPU usage, and sporadic performance degradation. 

Our recommendation for THP is similar to the recommendation for memory interleaving. 

Linux kernel   | THP
---------------|--------
2.6 or earlier | disable
3.x or higher  | enable

Other database vendors are also reporting similar issues with THP.

Note that changing Transparent Huge Pages isn’t possible via `sysctl(8)`. Rather, it requires manually echoing settings into `/sys/kernel` at or after boot. In `/etc/rc.local` or by hand. To disable THP, do this:

```bash
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
  echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
```

Some distributions may require a slightly different path, e.g:


```bash
$ echo never >/sys/kernel/mm/redhat_transparent_hugepage/enabled
```
Another possibility to configure this is via `grub`

```bash
transparent_hugepage=never
```

To enable THP for Linux kernel 3.x, do this:

```bash
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
  echo always > /sys/kernel/mm/transparent_hugepage/enabled
fi

if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
  echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
```

Q must be restarted to pick up the new setting.


## Monitoring free disk space

In addition to monitoring free disk space for the usual partitions you write to, ensure you also monitor free space of `/tmp` on Unix, since q uses this area for capturing the output from system commands, such as `system "ls"`.

!!! warning "Disk space for log files"

    It is essential to ensure there is sufficient disk space for tickerplant log files, as in the event of exhausting disk space, the logging mechanism may write a partial record, and then drop records, thereby leaving the log file in a corrupt state due to the partial record.


## Back up the sym file

The sym file is found in the root of your HDB.
It is the key to the default enums. 

!!! tip "Regularly back up the sym file _outside_ the HDB."


## Compression

If you find that q is seg faulting (crashing) when accessing compressed files, try increasing the Linux kernel parameter `vm.max_map_count`. As root

```bash
$ sysctl vm.max_map_count=16777216
```

and/or make a suitable change for this parameter more permanent through `/etc/sysctl.conf`. As root

```bash
$ echo "vm.max_map_count = 16777216" | tee -a /etc/sysctl.conf
$ sysctl -p
```

You can check current settings with

```bash
$ more /proc/sys/vm/max_map_count
```

Assuming you are using 128-KB logical size blocks for your compressed files, a general guide is, at a minimum, set `max_map_count` to one map per 128&nbsp;KB of memory, or 65530, whichever is higher.

If you are encountering a SIGBUS error, please check that the size of `/dev/shm` is large enough to accommodate the decompressed data. Typically, you should set the size of `/dev/shm` to be at least as large as a fully decompressed HDB partition.

Set `ulimit` to the higher of 4096 and 1024 plus the number of compressed columns which may be queried concurrently.

```bash
$ ulimit -n 4096
```

!!! warning "`lz4` compression"

    Certain [releases](https://github.com/lz4/lz4/releases) of `lz4` do not function correctly within kdb+.

    Notably, `lz4-1.7.5` does not compress, and `lz4-1.8.0` appears to hang the process. 

    Kdb+ requires at least `lz4-r129`.
    `lz4-1.8.3` works. 
    We recommend using the latest `lz4` release available.


## Timekeeping

Timekeeping on production servers is a complicated topic. These are just a few notes which can help.

If you are using any of local time functions `.z.(TPNZD)` q will use the `localtime(3)` system function to determine time offset from GMT. In some setups (GNU libc) this can cause excessive system calls to `/etc/localtime`.  
:fontawesome-regular-hand-point-right: [chemie.fu-berlin.de](http://kirste.userpage.fu-berlin.de/chemnet/use/info/libc/libc_17.html#SEC301), [stackoverflow.com](https://stackoverflow.com/questions/4554271/how-to-avoid-excessive-stat-etc-localtime-calls-in-strftime-on-linux/4554302#4554302)

Setting TZ environment helps this:

```bash
$ export TZ=America/New_York
```

or from q

```q
q)setenv[`TZ;"Europe/London"]
```

One more way of getting excessive system calls when using `.z.(pt…)` is to have a slow clock source configured on your OS. Modern Linux distributions provide very low overhead functionality for getting current time. Use `tsc` clocksource to activate this.

```bash
$ echo tsc >/sys/devices/system/clocksource/clocksource0/current_clocksource
# list available clocksource on the system
$ cat /sys/devices/system/clocksource/clocksource*/available_clocksource
```

If you are using PTP for timekeeping, your PTP hardware vendor might provide their own implementation of time. Check that those utilize VDSO mechanism for exposing time to user space.


