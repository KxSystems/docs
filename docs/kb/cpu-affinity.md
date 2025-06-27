---
title: CPU affinity – Knowledge Base – kdb+ and q documentation
description: Kdb+ can be constrained to run on specific cores through the setting of CPU affinity. Typically, you can set the CPU affinity for the shell you are in, and then processes started within that shell will inherit the affinity.
keywords: affinity, cpu, kdb+, kernel, linux, numa, q, solaris, unix, windows, zone_reclaim_mode
---
# CPU affinity




Kdb+ can be constrained to run on specific cores through the setting of CPU affinity.

Typically, you can set the CPU affinity for the shell you are in, and then processes started within that shell will inherit the affinity.

:fontawesome-regular-hand-point-right: 
[`.Q.w`](../ref/dotq.md#w-memory-stats) (memory stats)  
Basics: [Command-line parameter `-w`](../basics/cmdline.md#-w-workspace), 
[System command `\w`](../basics/syscmds.md#w-workspace)


## Linux

:fontawesome-regular-hand-point-right: 
[Non-Uniform Access Memory (NUMA)](linux-production.md#non-uniform-access-memory-numa-hardware)


### Detecting NUMA

The following commands will show if NUMA is active.

```bash
$ grep NUMA=y /boot/config-`uname -r`
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_ACPI_NUMA=y
```

Or test for the presence of NUMA maps.

```bash
$ find /proc -name numa_maps
/proc/12108/numa_maps
/proc/12109/task/12109/numa_maps
/proc/12109/numa_maps
...
```


### Q and NUMA

Until Linux kernels 3.x, q and NUMA did not work well together. 

When activating NUMA, substitute parameter settings according to the [recommendations for different Linux kernels](linux-production.md#non-uniform-access-memory-numa-hardware).


### Activating NUMA

When NUMA is 

-   **not active**, use the `taskset` command, e.g.

	```bash
	taskset -c 0,1,2 q
	```

	will run q on cores 0, 1 and 2. Or

	```bash
	taskset -c 0,1,2 bash
	```

	and then all processes started from within that new shell will automatically be restricted to those cores.

-   **active**, use `numactl` instead of `taskset`

	```bash
	numactl --interleave=all --physcpubind=0,1,2 q
	```

	and set

	```bash
	echo 0 > /proc/sys/vm/zone_reclaim_mode
	```

You can change `zone_reclaim_mode` without restarting q.


### Other ways to limit resources

On Linux systems, administrators might prefer [cgroups](https://en.wikipedia.org/wiki/Cgroups) as a way of limiting resources.

On Unix systems, memory usage can be constrained using `ulimit`, e.g.

```bash
ulimit -v 262144
```

limits virtual address space to 256MB.


## Solaris

Use `psrset`

```bash
psrset -e 2 q
```

which will run q using processor set 2. Or, to start a shell restricted to those cores:

```bash
psrset -e 2 bash
```


## Windows

Start `q.exe` with the OS command `start` with the `/affinity` flag set

```powershell
start /affinity 3 c:\q\w64\q.exe 
```

will run q on core 0 and 1.

