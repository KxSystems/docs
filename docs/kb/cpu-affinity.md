---
title: CPU affinity | Knowledge Base | kdb+ and q documentation
description: Kdb+ can be constrained to run on specific cores through the setting of CPU affinity. Typically, you can set the CPU affinity for the shell you are in, and then processes started within that shell will inherit the affinity.
keywords: affinity, cpu, kdb+, kernel, linux, numa, q, solaris, unix, windows, zone_reclaim_mode
---
# CPU affinity




Kdb+ can be constrained to run on specific cores through the setting of CPU affinity.

Typically, you can set the CPU affinity for the shell you are in, and then processes started within that shell will inherit the affinity.

:fontawesome-regular-hand-point-right: 
[`.Q.w`](../ref/dotq.md#qw-memory-stats) (memory stats)  
Basics: [Command-line parameter `-w`](../basics/cmdline.md#-w-workspace), 
[System command `\w`](../basics/syscmds.md#w-workspace)


## :fontawesome-brands-linux: Linux

Use the `taskset` command to limit to a certain set of cores, e.g.

```bash
taskset -c 0-2,4 q
```

will run q on cores 0, 1, 2 and 4. Or

```bash
taskset -c 0-2,4 bash
```

and then all processes started from within that new shell will automatically be restricted to those cores.

You can also use numactl -S to specify the cores, perhaps combined with -l to always allocate on the current node or other policies discussed in the [linux production notes](linux-production.md#non-uniform-access-memory-numa-hardware):

```bash
numactl --interleave=all --physcpubind=0,1,2 q
```

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


## :fontawesome-brands-windows: Windows

Start `q.exe` with the OS command `start` with the `/affinity` flag set

```powershell
start /affinity 3 c:\q\w64\q.exe 
```

will run q on core 0 and 1.

