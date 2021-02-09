---
title: C/C++ functions – Interfaces – kdb+ and q documentation
description: Functions can be written in C or C++ as shared objects and loaded into a kdb+ process for use in a q program.
author: Charles Skelton
keywords: api, c, c++, interface, kdb+, library, q
---
# C/C++ functions



Q functionality can be extended using dynamically-loaded modules. 

To make a function `foo` defined in a shared object `bar.so` available in a q session, we use [2:](../ref/dynamic-load.md) to load the function dynamically.

```q
q)foo:`bar 2:(`foo;n)
```

where `n` is the number of arguments that `foo` accepts.

If a path to `bar` is specified, kdb+ will first attempt to load `bar` from that directory, and if `bar` is not found, then it will try the default directory.

If the shared library is not to be loaded from the default directory, then (on Unix) `LD_LIBRARY_PATH` should include the directory containing the shared library, and the path to `bar` must be specified.

<!-- 
If no path to `bar` is specified, kdb+ will attempt to load `bar` from the default directory.

Note that if no path to `bar` is specified, q will attempt to load `bar.[so|dll]` from the current working directory and then the default directory 
```
$QHOME/\[l|w|s|v|m\]\[32|64\] 
```
where l=Linux, w=Windows, m=macOS, s=Solaris(SPARC), v=Solaris(x86) and 32=32-bit, 64=64-bit. e.g. `$QHOME/l32`).

If a path to `bar` is specified, q will attempt to load `bar` from that directory, and then the default directory.

If the shared library is _not_ to be loaded from the default directory, then (on Unix) `LD_LIBRARY_PATH` should include the directory containing the shared library.
 -->

!!! warning "Working directory not in `LD_LIBRARY_PATH`"

    A common error is that, during development, the shared library might exist in _both_ the current working directory and the default directory, in which case q attempts to load the shared library from the current working directory but fails if `LD_LIBRARY_PATH` does not include the current working directory.

In this article we explain how to write functions in C that can be used in this manner.


## Compiling extension modules

### Windows

```shell
cl /LD bar.c bar.def q.lib
```


### Linux

```bash
gcc -shared -fPIC bar.c -o bar.so
```


### Solaris

```bash
gcc -G -fPIC  bar.c -o bar.so
```


### macOS

```bash
gcc -bundle -undefined dynamic_lookup bar.c -o bar.so
```

The resulting binary should be placed in the same directory as the q executable. Solaris x86\_64 may require `-nostdlib` as that lib may not have been pic-compiled. MacOS seems to require explicit `-m64` flag for 64-bit builds.

!!! warning "Static libraries"

    The C-API functions (e.g. `kj`, `kf`, etc) are dynamically linked when loading your shared library into q, hence you should not link with the static libraries c.o, c.obj or c.lib/c.dll when creating a shared library to load into q.


## Portable example

Building an extension on multiple platforms with portable source.

You will need :fontawesome-brands-github: [KxSystems/kdb/c/c/k.h](https://github.com/KxSystems/kdb/blob/master/c/c/k.h) 
and familiarity with [C client for q](c-client-for-q.md).

`add()` adds two q integers and returns the result. The code is portable across all platforms supported by q.

**add.c**

```c
#include"k.h"
#ifdef __cplusplus
extern "C"{
#endif

K add(K x,K y)
{
  if(x->t!=-KJ||y->t!=-KJ)
    return krr("type");
  return kj(x->j+y->j);
}

#ifdef __cplusplus
}
#endif
```

Note that if compiling C (not C++), you may omit the `extern "C"`.

### Linux

```bash
gcc -shared -fPIC -DKXVER=3 add.c -o add.so
```


### Solaris

```bash
gcc -G -fPIC -DKXVER=3 add.c -o add.so
```


### macOS

```bash
gcc -bundle -undefined dynamic_lookup -DKXVER=3 add.c -o add.so
```

The resulting binary may be placed in the same directory as the q executable.
Solaris x86\_64 may require `-nostdlib` as that lib may not have been pic-compiled.

MacOS seems to require explicit `-m64` flag for 64-bit builds.


### Windows: Microsoft Compiler

An additional file (`add.def`) is required, unless you add `declspec`s to the code.

**add.def**

```def
EXPORTS
add
```

To ensure that the linker can find `kj()`, we link with :fontawesome-brands-github: [KxSystems/kdb/w32/q.lib](https://github.com/KxSystems/kdb/blob/master/w32/q.lib) or [KxSystems/kdb/w64/q.lib](https://github.com/KxSystems/kdb/blob/master/w64/q.lib) The `.lib` contains stub code that links to the `kj()` function in `q.exe`.

Now, with k.h, add.c, add.def, q.lib we can build a C extension:

```dos
cl /LD  /DKXVER=3 add.c add.def q.lib
```

Now, with q in your path and your current directory containing `add.dll`:

```q
q)(`add 2:(`add;2))[3;4]
7
```


### Windows: MinGW-64

```dos
/c/q$ echo 'LIBRARY q.exe'>q.def;  echo EXPORTS>>q.def;  nm -p w32/q.lib |egrep 'T _' |sed 's/0* T _//' >>q.def
/c/q$ dlltool -v -l libq.a -d q.def
/c/q$ gcc -shared -DKXVER=3 add.c -L. -lq -o add.dll
```

Tested using [MinGW-64](http://mingw-w64.org/doku.php) with `q/w32`.


## High-resolution timing

The purpose of this recipe is to explain how to access a low-level feature of an operating system and processor from q. This is illustrative of the type of operation that cannot be performed directly in q, and for which it makes sense to write a C function for use within q.

Source code: :fontawesome-brands-github: [KxSystems/cookbook/cpu_extension](https://github.com/KxSystems/cookbook/tree/master/cpu_extension)


### Accessing the TSC

Recent IA-32 processors, since the Intel Pentium Pro implementation, contain a high-resolution timestamp counter register. This register originally was increased at a fixed rapid rate, subject to 64-bit overflow. This made it useful as a high-resolution timer with a known relationship to wall-clock time. In IA-32 assembly language the RDTSC instruction (a mnemonic for Read Time Stamp Counter) with opcode `0f 32` is used to read the register.

This has been brought forward in the AMD64/EM64T version of the IA-32 instruction set. However, several of the recent implementatons broke the never-guaranteed but often-assumed idea that the register would be incremented at a constant rate. With the introduction of performance- and frequency scaling for power usage adjustment and thermal control, the TSC register, though still monotonically increasing, began to behave in non-intuitive ways.

Some implementations tied the rate of increase of the register to the operating frequency of the core. As this varied, for example due to [SpeedStep](https://en.wikipedia.org/wiki/SpeedStep), the rate of increase of the register varied. Even more bizarrely, some processors exhibited changes in the register (“drift”) due to changes in the operating temperature of the core. Furthermore, multi-processor and multi-core machines have more than one TSC register. Depending on the processor the instruction is executed on, different values could be returned. Most modern operating systems are aware of this and attempt to properly account for TSC drift between cores, as well as frequency modulations. Recent processor implementations have removed the more obvious changes, making life easier for the programmers again.

Applications should rarely depend directly on the TSC for timekeeping, and instead use the applicable operating system calls. However, the extreme granularity (around a third of a nanosecond on a 3GHz processor) of the count is useful in certain situations where small instruction sequences need to be timed, or events logged with a very fine-grained timestamp. Note that in the latter case the TSC value cannot be used by itself as a timestamp due to multiple TSC registers being in the system, TSC drift, and 64-bit rollover.

The value of the register is read in the following C code segment using a GCC-compatible inline assembly directive to execute the RDTSC instruction. The value is then wrapped as a “J” value in a K object, with potential loss of accuracy (the J type is the largest integral type wrappable in a K object).

```c
#include <k.h>

/**
  * Read the cycle counter. AMD64 only in this version (note the non-portable
  * use of unsigned long long).
  *
  * @param x Ignored; required to allow us to bind to this from q.
  *
  * @return A long long wrapped in a K object.
  */
K q_read_cycles_of_this_cpu(K x)
{
  unsigned long a, d, reading;
  asm volatile("rdtsc" : "=a" (a), "=d" (d));
  reading = ((unsigned long long)a) | (((unsigned long long)d) << 32);
  return kj((J)reading);
}
```

Note that the function takes and returns a K object. At least one K argument is required for integration into q. We compile as follows:

```bash
$ cc -I. -fPIC -shared -o ~/q/l64/cpu.so cpu.c
```

and the function may be loaded into q:

```q
read_cycles:`cpu 2:(`q_read_cycles_of_this_cpu;1)
```

A sample execution which counts the cycles taken between two executions of function:

```q
q)read_cycles[]-read_cycles[]
1377
```


### Reading CPU frequency on Linux

Under the Linux operating system, the file `/proc/cpuinfo` contains many useful pieces of information on the processor cores in the system. Here we illustrate reading the current operating frequency of the first core found in this file. Note that the operating frequency may change on recent IA-32 implementations so this reading is valid only at the instant it was taken. The following function:

```c
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include"k.h"
#define MAX_PROCFILE_SIZE 32768
/**
  * Get the current cpu frequency by reading /proc/cpuinfo, or -1
  * if there is a problem.
  *
  * @param x Ignored; required to allow us to bind to this from q.
  *
  * @return A double wrapped in a K object.
  */
K q_get_first_cpu_frequency(K x)
{
  static double frequency = -1.0;
  const char searchString[] = "cpu MHz";
  char line[MAX_PROCFILE_SIZE];
  int fd = open("/proc/cpuinfo", O_RDONLY);
  if(fd==-1) return orr("open");
  read (fd, line, MAX_PROCFILE_SIZE);
  char* position = strstr (line, searchString);
  if (position) {
    position += strlen(searchString);
    position = strchr(position,':');
    sscanf (position+1, "%lf", &frequency);
  }
  close(fd);
  return kf(frequency);
}
```

opens and parses the processor information file and extracts the first frequency reading. This is then wrapped as a double precison floating point number in a K object and returned.

Compile as follows, and place in the l64 directory (which is searched for extensions by default):

```bash
$ cc -I. -fPIC -DKXVER=3 -shared -o $QHOME/l64/cpu.so cpu.c
```

Then at a q prompt, we can load the function and use it to find the current processor frequency:

```q
q)cpu_frequency:`cpu 2:(`q_get_first_cpu_frequency;1)
q)cpu_frequency[]
800.128
```


### Reading CPU frequency on macOS

MacOS does not have `/proc` interface. One can create one in user space using [MacFUSE](http://osxbook.com/book/bonus/chapter11/procfs/), but it is easier to use `sysctl`:

```c
#include <sys/types.h>
#include <sys/sysctl.h>
#include "k.h"

K1(cpuf){J f;size_t l=sizeof(f);
 P(sysctlbyname("hw.cpufrequency",&f,&l,0,0),
   orr("sysctl"))R kj(f);}
```

```q
q)cpuf:`cpu 2:(`cpuf;1)
q)cpuf[]
2330000000
```


## High-precision wall time on Linux

The built-in `.z.p` currently returns up to &mu;S, as returned by `gettimeofday`. For those who would like higher precision, below is a possible solution. Note that cores on a multicore machine can each have slightly different times.

```c
#include<time.h>
K getTime(K x){struct timespec ts;clock_gettime(CLOCK_REALTIME,&ts);R ktj(-KP,(ts.tv_sec-10957*86400)*1000000000LL+ts.tv_nsec);}
```


## Generating sequential numbers (or sets of)

Here’s a simple method to generate sequential numbers in a thread-safe manner.

```q
q){x set`:./seq 2:x,y}[`seq;1]; / bind to the shared lib
q)seq[] / no arg means generate just 1 number
0
q)seq[]
1
q)seq 6 // generate next 6 numbers
2 3 4 5 6 7
q)seq 10
8 9 10 11 12 13 14 15 16 17
```

```c
// compile with gcc -DKXVER=3 seq.c -seq.so -shared -fPIC -O2
#include<inttypes.h>
#include"k.h"
static volatile J v;
K seq(K x){
  K y;J j=1;
  P(xt!=101&&xt!=-7,krr("type"))
  j=__sync_fetch_and_add(&v,xt==-7?xj:j);
  P(xt==101,kj(j))
  y=ktn(KJ,xj);DO(xj,kJ(y)[i]=j++)
  R y;
}
```


## Fun/hobby stuff

### Blinking OK LED on Raspberry Pi

A little bit of fun – usually the OK LED on the Raspberry Pi flashes whenever there is disk I/O. 
You can also control it through mapping the GPIO memory, and writing directly to it as below.

```q
q){x set`:./a 2:x,1}each`init`led  / here it expects shared lib name is a.so
```

```c
// btw, the following c libs are useful for accessing gpio 
// http://www.open.com.au/mikem/bcm2835
// https://projects.drogon.net/raspberry-pi/wiringpi

#include<fcntl.h>
#include<sys/mman.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<unistd.h>
#include"k.h"

static volatile unsigned *gpio;

#define BCM2708_PERI_BASE 0x20000000
#define GPIO_BASE         (BCM2708_PERI_BASE+0x200000)
//#define INP_GPIO(x) *(gpio+((x)/10))&=~(7<<(((x)%10)*3))
#define OUT_GPIO(x) *(gpio+((x)/10))|=(1<<(((x)%10)*3))
#define GPIO_SET *(gpio+7)  // sets   bits which are 1 ignores bits which are 0
#define GPIO_CLR *(gpio+10) // clears bits which are 1 ignores bits which are 0
#define OKLED 16

K init(K x){
  int fd;
  void *p;
  if(gpio)R krr("Already initialized!");
  if((fd=open("/dev/mem",O_RDWR|O_SYNC))<0)
    R krr("can't open /dev/mem\n");
  p=mmap(NULL,4096,PROT_READ|PROT_WRITE,MAP_SHARED,fd,GPIO_BASE);
  close(fd);
  if(p==MAP_FAILED)R krr("mmap error");
  gpio=(volatile unsigned*)p;
//  INP_GPIO(OKLED);
  OUT_GPIO(OKLED);
  R(K)0;
}
K led(K x){
  if(xj)GPIO_CLR=1<<OKLED;else GPIO_SET=1<<OKLED;
  R(K)0;
}
```

