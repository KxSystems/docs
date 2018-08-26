Q can be constrained to run on specific cores through the setting of CPU affinity.

Typically, you can set the CPU affinity for the shell you are in, and then processes started within that shell will inherit the affinity.

<i class="far fa-hand-point-right"></i> Command-line parameter [`-w`](/basics/cmdline/#-w-memory), System command [`\w`](/basics/syscmds/#w-workspace), utility [`.Q.w`](/basics/dotq/#qw-memory-stats) (memory stats)


## Linux

When NUMA (Non-Uniform Access Memory) is not active, this is achieved through the `taskset` command, e.g.
```bash
$ taskset -c 0,1,2 q
```
will run q on cores 0,1 and 2. Or as follows
```bash
$ taskset -c 0,1,2 bash
```
and then all processes started from within that new shell will automatically be restricted to those cores.

Q and NUMA do not work well together. If NUMA is active, you should use `numactl` instead of `taskset`.
```bash
$ numactl --interleave=all --physcpubind=0,1,2 q
```
and set
```bash
$ echo 0 > /proc/sys/vm/zone_reclaim_mode
```
You can change `zone_reclaim_mode` without restarting q.

You can tell if NUMA is active via the following commands
```bash
$ grep NUMA=y /boot/config-`uname -r`
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_ACPI_NUMA=y
```
or testing for the presence of NUMA maps
```
$ find /proc -name numa_maps
/proc/12108/numa_maps
/proc/12109/task/12109/numa_maps
/proc/12109/numa_maps
...
```

!!! tip "Other ways to limit resources"
    On Linux systems, administrators might prefer [cgroups](https://en.wikipedia.org/wiki/Cgroups) as a way of limiting resources.

    On Unix systems, memory usage can be constrained using `ulimit`, e.g.<pre><code class="language-bash">$ ulimit -v 262144</code></pre>limits virtual address space to 256MB.


## Solaris

Use `psrset`
```bash
$ psrset -e 2 q
```
which will run q using processor set 2. Or, to start a shell restricted to those cores:
```bash
$ psrset -e 2 bash
```


## Windows

Start q.exe with the OS command `start` with the `/affinity` flag set
```dos
C> start /affinity 3 c:\q\w64\q.exe 
```
will run q on core 3.

