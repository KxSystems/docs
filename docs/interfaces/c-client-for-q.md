---
title: C client for kdb+ | Interfaces | kdb+ and q documentation
description: How to connect a C client program to a kdb+ server process
author: Charles Skelton
---
# C client for kdb+



:fontawesome-regular-hand-point-right: 
[API reference](capiref.md)

There are three cases in which to to use the C API for kdb+:

1.   Dynamically-loaded library called by q, e.g. OS, math, analytics.  
:fontawesome-regular-hand-point-right: [Using C functions](using-c-functions.md)
2.  Dynamically-loaded library doing callbacks into q, e.g. feedhandlers ([Bloomberg client](q-client-for-bloomberg.md))
3.  C/C++ clients talking to kdb+ servers (standalone applications), e.g. feedhandlers and clients. Links with `c.o`/`c.dll`. 



## Two sets of files

To minimize dependencies for existing projects, there are now two sets of files available.

:fontawesome-brands-github: [KxSystems/kdb](https://github.com/kxsystems/kdb)

The `e` set of files, those with SSL/TLS support, contain all the functionality of the `c` files.

!!! warning "Do not link with both `c` and `e` files; just choose one set."


### :fontawesome-brands-linux: Linux

capability | dependencies | 32-bit | 64-bit 
-----------|--------------|-----------|-----
no SSL/TLS |              | [`l32/c.o`](https://github.com/KxSystems/kdb/blob/master/l32/c.o) | [`l64/c.o`](https://github.com/KxSystems/kdb/blob/master/l64/c.o) 
SSL/TLS    | OpenSSL      | [`l32/e.o`](https://github.com/KxSystems/kdb/blob/master/l32/e.o) | [`l64/e.o`](https://github.com/KxSystems/kdb/blob/master/l64/e.o)


### :fontawesome-brands-apple: macOS

capability | dependencies | 32-bit | 64-bit 
-----------|--------------|-----------|-----
no SSL/TLS |              | [`m32/c.o`](https://github.com/KxSystems/kdb/blob/master/m32/c.o) | [`m64/c.o`](https://github.com/KxSystems/kdb/blob/master/m64/c.o) 
SSL/TLS    | OpenSSL      | [`m32/e.o`](https://github.com/KxSystems/kdb/blob/master/m32/e.o) | [`m64/e.o`](https://github.com/KxSystems/kdb/blob/master/m64/e.o)


### :fontawesome-brands-windows: Windows

capability | dependencies | 32-bit | 64-bit 
-----------|--------------|-----------|-----
no SSL/TLS |              | [`w32/c.dll`](https://github.com/kxsystems/kdb/blob/master/w32/c.dll)<br>[`w32/c.lib`](https://github.com/kxsystems/kdb/blob/master/w32/c.lib)<br>[`w32/cst.dll`](https://github.com/kxsystems/kdb/blob/master/w32/cst.dll)<br>[`w32/cst.lib`](https://github.com/kxsystems/kdb/blob/master/w32/cst.lib)<br>[`w32/c_static.lib`](https://github.com/kxsystems/kdb/blob/master/w32/c_static.lib)<br>[`w32/cst_static.lib`](https://github.com/kxsystems/kdb/blob/master/w32/cst_static.lib) | [`w64/c.dll`](https://github.com/kxsystems/kdb/blob/master/w64/c.dll)<br>[`w64/c.lib`](https://github.com/kxsystems/kdb/blob/master/w64/c.lib)<br>[`w64/cst.dll`](https://github.com/kxsystems/kdb/blob/master/w64/cst.dll)<br>[`w64/cst.lib`](https://github.com/kxsystems/kdb/blob/master/w64/cst.lib)<br>[`w64/c_static.lib`](https://github.com/kxsystems/kdb/blob/master/w64/c_static.lib)<br>[`w64/cst_static.lib`](https://github.com/kxsystems/kdb/blob/master/w64/cst_static.lib)
SSL/TLS    | OpenSSL      | [`w32/e.dll`](https://github.com/kxsystems/kdb/blob/master/w32/e.dll)<br>[`w32/e.lib`](https://github.com/kxsystems/kdb/blob/master/w32/e.lib)<br>[`w32/est.dll`](https://github.com/kxsystems/kdb/blob/master/w32/est.dll)<br>[`w32/est.lib`](https://github.com/kxsystems/kdb/blob/master/w32/est.lib)<br>[`w32/e_static.lib`](https://github.com/kxsystems/kdb/blob/master/w32/e_static.lib)<br>[`w32/est_static.lib`](https://github.com/kxsystems/kdb/blob/master/w32/est_static.lib) | [`w64/e.dll`](https://github.com/kxsystems/kdb/blob/master/w64/e.dll)<br>[`w64/e.lib`](https://github.com/kxsystems/kdb/blob/master/w64/e.lib)<br>[`w64/est.dll`](https://github.com/kxsystems/kdb/blob/master/w64/est.dll)<br>[`w64/est.lib`](https://github.com/kxsystems/kdb/blob/master/w64/est.lib)<br>[`w64/e_static.lib`](https://github.com/kxsystems/kdb/blob/master/w64/e_static.lib)<br>[`w64/est_static.lib`](https://github.com/kxsystems/kdb/blob/master/w64/est_static.lib)

`c.lib` is a stub library which loads `c.dll` and resolves the functions dynamically; `e.lib` does the same for `e.dll`. 

We no longer ship `c.obj` or `cst.obj`; they have been replaced by `c_static.lib` and `cst_static.lib`, and are complemented by `e_static.lib` and `est_static.lib` – these static libraries have no dependency on the aforementioned DLLs.

`cst` continues to represent ‘single-threaded’ apps, those which on Windows have [issues due to the `LoadLibrary` API](#windows-and-the-loadlibrary-api).


## Overview

The best way to understand the underpinnings of q, and to interact with it from C, is to start with the header file available from 
:fontawesome-brands-github: [KxSystems/kdb/c/c/k.h](https://github.com/KxSystems/kdb/blob/master/c/c/k.h) .

This is the file you will need to include in your C or C++ code to interact with q from a low level.

Let’s explore the basic types and their synonyms that you will commonly encounter when programming at this level. First though, it is worth noting the size of data types in 32- versus 64-bit operating systems to avoid a common mistake.

To provide succinct composable names, the q header defines synonyms for the common types as in the following table:


type          | synonym
--------------|--------
16-bit int    | `H`    
32-bit int    | `I`    
64-bit int    | `J`    
char\*        | `S`    
unsigned char | `G`    
char          | `C`    
32-bit float  | `E`    
64-bit double | `F`    
void          | `V`    

With this basic knowledge, we can now tackle the types available in q and their matching C types and accessor functions provided in the C interface. We will see shortly how the accessor functions are used in practice.

<div class="kx-compact" markdown="1">

| q type name                  | q type number    | encoded type name | C type   | size in bytes | interface list accessor function              |
|------------------------------|------------------|-------------------|----------|---------------|-----------------------------------------------|
| mixed list                   | 0                | -                 | K        | -             | `kK`                                          |
| boolean                      | 1                | KB                | char     | 1             | `kG`                                          |
| guid                         | 2                | UU                | U        | 16            | `kU`                                          |
| byte                         | 4                | KG                | char     | 1             | `kG`                                          |
| short                        | 5                | KH                | short    | 2             | `kH`                                          |
| int                          | 6                | KI                | int      | 4             | `kI`                                          |
| long                         | 7                | KJ                | int64\_t | 8             | `kJ`                                          |
| real                         | 8                | KE                | float    | 4             | `kE`                                          |
| float                        | 9                | KF                | double   | 8             | `kF`                                          |
| char                         | 10               | KC                | char     | 1             | `kC`                                          |
| symbol                       | 11               | KS                | char\*   | 4 or 8        | `kS`                                          |
| timestamp                    | 12               | KP                | int64\_t | 8             | `kJ`                                          |
| month                        | 13               | KM                | int      | 4             | `kI`                                          |
| date                         | 14               | KD                | int      | 4             | `kI` (days from 2000.01.01)                   |
| datetime                     | 15               | KZ                | double   | 8             | `kF` (days from 2000.01.01)                   |
| timespan                     | 16               | KN                | int64\_t | 8             | `kJ` (nanoseconds)                            |
| minute                       | 17               | KU                | int      | 4             | `kI`                                          |
| second                       | 18               | KV                | int      | 4             | `kI`                                          |
| time                         | 19               | KT                | int      | 4             | `kI` (milliseconds)                           |
| table/flip                   | 98               | XT                | -        | -             | `x->k`                                        |
| dict/table with primary keys | 99               | XD                | -        | -             | `kK(x)[0]` for keys and `kK(x)[1]` for values |
| error                        | -128             | -                 | char\*   | 4 or 8        | `x->s`                                        |

</div>

Note that the type numbers given are for vectors of that type. 
For example, 9 for vectors of the q type float. 
By convention, the negative value is an atom: -9 is the type of an atom float value.


## The K object structure

The q types are all encapsulated at the C level as _K objects_. 
(Recall that k is the low-level language underlying the q language.) 
K objects are all instances of the following structure (note this is technically defining K objects as pointers to the `k0` structure but we’ll conflate the terms and refer to K objects as the actual instance).

- for V3.0 and later

```c
typedef struct k0{
  signed char m,a;   // m,a are for internal use.
  signed char t;     // The object's type
  C u;               // The object's attribute flags
  I r;               // The object's reference count
  union{
    // The atoms are held in the following members:
    G g;H h;I i;J j;E e;F f;S s;
    // The following members are used for more complex data.
    struct k0*k;
    struct{
      J n;            // number of elements in vector
      G G0[1];
    };
  };
}*K;
```

- prior to V3.0 it is defined as

```c
typedef struct k0 {
  I r;                   // The object's reference count
  H t, u;                // The object's type and attribute flags
  union {                // The data payload is contained within this union.
    // The atoms are held in the following members:
    G g;H h;I i;J j;E e;F f;S s;
    // The following members are used for more complex data.
    struct k0*k;
    struct {
      I n;              // number of elements in vector
      G G0[1];
    };
  };
}*K;
```

As an exercise, it is instructive to count the minimum and the maximum number of bytes a K object can use on your system, taking into account any padding or alignment constraints.

Given a K object `x`, we can use the accessors noted in the table above to access elements of the object. 
For example, given a K object containing a vector of floats, we can access `kF(x)[42]` to get the 42nd element of the vector. 
For accessing atoms, use the following accessors:


type   | accessor | additional types                 
-------|----------|----------------------------------
byte   | `x->g`   | boolean, char                    
short  | `x->h`   |                                  
int    | `x->i`   | month, date, minute, second, time
long   | `x->j`   | timestamp, timespan              
real   | `x->e`   |                                  
float  | `x->f`   | datetime                         
symbol | `x->s`   | error                            

!!! warning "Changes in V3.0"

    The k struct changed with the release of V3.0, and if you are compiling using the C library (c.o/c.dll) stamped on or after 2012.06.25 you should ensure you use the correct k struct by defining KXVER accordingly, e.g. 

    <pre><code class="language-bash">gcc -D KXVER=3 …</code></pre>
    
    If you need to link against earlier releases of the C library, you can obtain those files from :fontawesome-brands-github: [the earlier version](https://github.com/KxSystems/kdb/blob/6455fa25b0e1e5e403ded9bcec96728b4445ccac/c/c/k.h) of 2011.04.20. 


## Examining K objects

Whether you know beforehand the type of the K objects, or you are writing a function to work with different types, it is useful to dispatch based on the type flag `x->t` for a given K object `x`.

Where `x->t` is: 

-   negative, the object is an atom, and we should use the atom accessors noted above. 
-   greater than zero, we use the vector accessors as all the elements are of the same type (eg. `x->t == KF` for a vector of q floats).
-   exactly zero, the K object contains a mixed list of other K objects. 
Each item in the list is a pointer to another K object. 
To access each item of `x` we use the `kK` object accessor. 
For example: `kK(x)[42]` to access the 42nd element of the mixed list.


## Nulls and infinities

The next table provides the null and infinite immediate values for the q types. These are constants defined in k.h.


type  | null                                          | infinity                                      
------|-----------------------------------------------|-----------------------------------------------
short | 0xFFFF8000 (nh)                               | 0x7FFF (wh)                                   
int   | 0x80000000 (ni)                               | 0x7FFFFFFF (wi)                               
long  | 0x8000000000000000 (nj)                       | 0x7FFFFFFFFFFFFFFF (wj)                       
float | log(-1.0) on Windows or (0/0.0) on Linux (nf) | -log(0.0) in Windows or (1/0.0) on Linux (wf) 

Null objects can be created using `ks(""),kh(nh),ki(ni),kj(nj),kc(" ")`, etc. A null guid can be created with `U g={0};ku(g);`


## Managing memory and reference counting

Although memory in q is managed for the programmer implicitly, when interfacing from C or C++ we must (as is usual in those languages) manage memory explicitly. 
The following functions are provided to interface with the q memory manager.


purpose                                        | function  
-----------------------------------------------|-----------
Increment the object‘s reference count         | `r1(K)`   
Decrement the object‘s reference count         | `r0(K)`   
Free up memory allocated for the thread‘s pool | `m9()`    
Set whether interning symbols uses a lock      | `setm(I)` 

A reference count indicates the usage of an object, allowing the same object to be used by more than one piece of code.

If you create a K object through one of the ‘generator’ functions (`ki`, `kj`, `knk`, etc), you automatically have a reference to that object. 
Once you have finished using that object, you should call `r0`.
```c
r0(ki(5));
```
creates and immediately destroys an integer object.

!!! warning "Initialise the kdb+ memory system"

    Before calling any 'generator' functions in a standalone application, you must initialise the kdb+ internal memory system. (It is done automatically when you open a connection to other kdb+ processes.) Without making a connection, use `khp("",-1);`

In the case of a function being called from q

```c
K myfunc(K x)
{
  return ki(5);
}
```

the object is returned to q, and q will eventually decrement the reference count.

In this scenario, the arg `x` from q is passed to the C function. If it is to be returned to q, the reference count must be incremented with `r1`.

```c
K myfunc(K x)
{
    return r1(x);
}
```

It is _vital_ to increment and decrement when adding or removing references to values that should be managed by the q runtime, to avoid memory leaks or access faults due to double frees.

Note that K objects must be freed from the thread they are allocated within, and `m9()` should be called when the thread is about to complete, freeing up memory allocated for that thread's pool. 
Furthermore, to allow symbols to be created in other threads, `setm(1)` should be called from the main thread before any other threads are started.

When a K object is created, it usually has a reference count of 0 – exceptions are common constants such as `(::)` which may vary in their current reference count, as they may be used by other areas of the C API library or q. 
If `r0` happens to be passed a K object with a reference count of 0, that object’s memory is freed (returned to an internal pool). 
Be aware that if a reference count is &gt;0, you should very likely _not_ change the data stored in that object as it is being referenced by another piece of code which may not expect the change. 
In this case, create a new copy of the object, and change that.

If in doubt, the current reference count can be seen in C with

```c
printf("Reference count for x is %d\n",x->r);
```

and in q with

```q
-16!x
```

The function `k`, as in

```c
K r=k(handle,"functionname",params,(K)0);
```

requires a little more explanation.

If the handle is 

-   &ge;0, it is a generator function, and can return 0 (indicating a network error) or a pointer to a k object. 
If that object has type -128, it indicates an error, accessible as a null-terminated string in `r->s`. When you have finished using this object, it should be freed by calling `r0(r)`.
-   &lt;0, this is for async messaging, and the return value can be either 0 (network error) or non-zero (success). This result should _not_ be passed to `r0`.

K objects passed as parameters to the `k` function call have their reference counts decremented automatically on the return from that call. 
(To continue to use the object later in that C function, after the `k` call, increment the reference count before the call.)

```c
K r=k(handle,"functionname",r1(param),(K)0);
```


## Creating atom values

To create atom values the following functions are available. Function `ka` creates an atom of the given type, and the rest create an atom with the given value:


purpose                | call            
-----------------------|-----------------
Create an atom of type | `K ka(I);`      
Create a boolean       | `K kb(I);`      
Create a guid          | `K ku(U);`      
Create a byte          | `K kg(I);`      
Create a short         | `K kh(I);`      
Create an int          | `K ki(I);`      
Create a long          | `K kj(J);`      
Create a real          | `K ke(F);`      
Create a float         | `K kf(F);`      
Create a char          | `K kc(I);`      
Create a symbol        | `K ks(S);`      
Create a timestamp     | `K ktj(-KP,J);` 
Create a time          | `K kt(I);`      
Create a date          | `K kd(I);`      
Create a timespan      | `K ktj(-KN,J);` 
Create a datetime      | `K kz(F);`      

An example of creating an atom:

```c
K z = ka(-KI);
z->i = 42;
```

Equivalently:

```c
K z = ki(42);
```


## Creating lists

To create

-   a simple list `K ktn(I type,J length);` 
-   a mixed list  `K knk(I n,...);` 

where `length` is a non-negative, non-null integer. 

!!! warning "Limit of length"

    Before V3.0. `length` had to be in the range 0…2147483647, and was type I. See KXVER sections in k.h.


For example, to create an integer list of 5 we say `ktn(KI,5)`. A mixed list of 5 items can be created with `ktn(0,5)` but note that each element _must_ be initialized before further usage. 
A convenient shortcut to creating a mixed list when all items already exist at the creation of the list is to use `knk`, e.g. `knk(2,kf(2.3),ktn(KI,10))`. 
As we've noted, the type of a mixed list is 0, and the elements are pointers to other K objects – hence it is mandatory to initialize those n elements either via `knk` params, or explicitly setting each item when created with `ktn(0,n)`.

To join

-   an atom to a list: `K ja(K*,V*);` 
-   a string to a list: `K js(K*,S);` 
-   another K object to a list: `K jk(K*,K);` 
-   another K list to the first: `K jv(K*,K);` 

The join functions assume there are no other references to the list, as the list may need to be reallocated during the call. 
In case of reallocation passed `K*` pointer will be updated to refer to new K object and returned from the function.

```c
K x=ki(42);
K list=ktn(0,0);
jk(&list,x); // append a k object to a list

K vector=ktn(KI,0);
int i=2;
ja(&vector,&i); // append a primitive int to an int vector

K syms=ktn(KS,0);
S sym=ss("IBM");
js(&syms,sym); // append an interned symbol to a symbol vector

K more=ktn(KS,2);
kS(more)[0]=ss("INTC");
kS(more)[1]=ss("GOOG");
jv(&syms,more); // append a vector with two symbols to syms
```


## Strings and datetimes

Strings and datetimes are special cases and extra utility functions are provided:


purpose                            | function
-----------------------------------|--------------------------
Create a char array from string    | `K kp(string);`           
Create a char array from string of length n | `K kpn(string, n);`
Intern a string                    | `S ss(string);`          
Intern n chars from a string       | `S sn(string,n);`        
Convert q date to yyyymmdd integer | `I dj(date);`            
Encode a year/month/day as q date <br/>`0==ymd(2000,1,1)`| `I ymd(year,month,day);` 

Recall that Unix time is the number of seconds since `1970.01.01D00:00:00` while q time types have an epoch of `2000.01.01D00:00:00`.

```q
q)`long$`timestamp$2000.01.01
0
q)`int$2000.01.01
0i
```

Utilities to convert between Unix and q temporal types may be defined as below.

```c
F zu(I u){return u/8.64e4-10957;}   // kdb+ datetime from unix
I uz(F f){return 86400*(f+10957);}  // unix from kdb+ datetime
J pu(J u){return 1000000LL*(u-10957LL*86400000LL);} // kdb+ timestamp from unix, use ktj(Kj,n) to create timestamp from n
I up(J f){return (f/8.64e13+10957)*8.64e4;}  // unix from kdb+ timestamp
struct tm* lt(int kd) { time_t t = uz(kd); return localtime(&t); }
struct tm* lt_r(int kd, struct tm* res) { time_t t = uz(kd); return localtime_r(&t, res); } 
struct tm* gt(int kd) { time_t t = uz(kd); return gmtime(&t); }
struct tm* gt_r(int kd, struct tm* res) { time_t t = uz(kd); return gmtime_r(&t, res); }
char* fdt(struct tm* ptm, char* d) { strftime(d, 10, "%Y.%m.%d", ptm); return d; }
void tsms(unsigned ts,char*h,char*m,char*s,short*mmm) {*h=ts/3600000;ts-=3600000*(*h);*m=ts/60000;ts-=60000*(*m);*s=ts/1000;ts-=1000*(*s);*mmm=ts;}
char* ftsms(unsigned ts, char* d){char h, m, s; short mmm; tsms(ts, &h, &m, &s, &mmm); sprintf(d, "%02d:%02d:%02d.%03d", h, m, s, mmm); return d;}
```


## What’s the difference between a symbol and a char vector?

A symbol is a pointer to a location in an internal map of strings; that is, symbols are interned zero-terminated strings. 
In contrast, a char vector is similar to an int vector and is instead a counted K vector as usual.

When symbol is created it is automatically interned and stored in internal map of strings.

```c
K someSymbol = ks("some symbol");     // "some symbol" is placed into internal map
K nullSymbol = ks("");
```

When storing strings in symbol vector, they should be interned manually using `ss` function, i.e.

```c
kS(v)[i] = ss("some symbol");
```

## Creating dictionaries and tables

To create

-   a dict: `K xD(K,K);` 
-   a table from a dict: `K xT(K);` 
-   a simple table from a keyed table: `K ktd(K);` 

A dictionary is a K object of type 99. It contains a list of two K objects; the keys and the values. We can use `kK(x)[0]` and `kK(x)[1]` to get these contained data.

A simple table (a ‘flip’) is a K object of type 98. In terms of the K object, this is an atom that points to a dictionary. This means that to access the columns we can use the `kK(x->k)[0]` accessor and the `kK(x->k)[1]` for the values.

A keyed table is a dictionary where keys and values are both simple tables. A keyed table has type 99.

The following example shows the steps to create a keyed table:

```c
K maketable(){
  K c,d,e,v,key,val;
/* table of primary keys */
  c=ktn(KS,1);kS(c)[0]=ss("sid");
  d=ktn(KS,3);kS(d)[0]=ss("ibm");kS(d)[1]=ss("gte");kS(d)[2]=ss("kvm");
  v=knk(1,d);
  key=xT(xD(c,v));
/* table of values */
  c=ktn(KS,2);kS(c)[0]=ss("amt");kS(c)[1]=ss("date");
  d=ktn(KI,3);kI(d)[0]=100;kI(d)[1]=300;kI(d)[2]=200;
  e=ktn(KD,3);kI(e)[0]=2;kI(e)[1]=3;kI(e)[2]=5;
  v=knk(2,d,e);
  val=xT(xD(c,v));
  return xD(key,val);
}
```

Although we can thus access the data using the accessors already introduced, you many find it easier to first convert it to a simple table before manipulating it in C.

```c
// Get a keyed table
K x = maketable();

// Convert the result to a simple table.
K y=ktd(x);

/*
 Note that if the ktd conversion fails for any reason,
 it returns 0 and x is not freed.
 since 2011-01-27, ktd always decrements ref count of input.
*/
if (!y)
  printf("x is still a keyed table because the conversion failed.");
else
  printf("y is a simple table and x has been deallocated.");
```

## Connecting to a q server

We use the `int khpu(host, port,username)` function to connect to a q server. 
Note you _must_ call `khpu` before generating any q data, and the very first call to `khpu` must not be concurrent to other `khpu` calls. 
To initialise memory without making a connection, use `khp("",-1);`

It is highly recommended to use `khpu` and supply a meaningful username, as this will help server administrators identify a user’s connection.

The `khp`,`khpu` and `khpun` functions are for use in stand-alone applications only; they are not for use within a q server via a shared library. Hence, to avoid potential confusion, these functions have been removed from more recent releases of q.

A timeout can be specified with function `khpun`.

```c
int c=khpun("localhost",1234,"myname:mypassword",1000); // timeout in mS
```

Return values for `khp`/`khpu`/`khpun` are:

```txt
>0 - active handle
 0 - authentication error
-1 - error
-2 - timeout(khpun case)
```

Note that with the release of `c.o` with V2.6, `c.o` now tracks the connection type (pre-V2.6, or V2.6+). Hence to close the connection you must call `kclose` (instead of `close` or `closeSocket`) – this will clean up the connection tracking and close the socket.

The `k` function is used to send messages over the connection. If a positive handle is used then the call is synchronous, otherwise it is an asynchronous call.

```c
// Connect to a q server on the localhost port 1234.
int c = khpu("localhost", 1234,"myusername:mypassword"); 
if(c<=0) {perror("Connection error");return;}
K r = k(-c,"a:2+2",(K)0);      // Asynchronously set a to be 4 on the server.
r = k(c,"b:til 1000000",(K)0); // Synchronously set b to be a list up to 1000000.
r = k(c,(S)0);                 // Read incoming data (blocking call)
```

Note that the object returned from an async set call must not be passed to `r0`.

There is no timeout argument for the `k(handle,…,(K)0)` call, but you can use socket timeouts as described below, or if you are _reading incoming async msgs_ only, you can use `select` to determine whether the handle has data pending.

```c
#include"k.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
int main(){
  int retval;
  K x,r;
  int fd=khp("localhost",9999); // In a production system, check return value
  fd_set fds;
  struct timeval tv;
  while(1){
    tv.tv_sec=5;
    tv.tv_usec=0;
    FD_ZERO(&fds);
    FD_SET(fd,&fds);
    retval=select(fd+1,&fds,NULL,NULL,&tv);
    if(retval==-1)
      perror("select()"),exit(1);
    else if(retval){
      printf("Data is available now.\n");
      if(FD_ISSET(fd,&fds)){
        x=k(fd,(S)0);
        if(x){
          if(-128==x->t){printf("Error occurred:%s\n",x->s);r0(x);return;}
          printf("%d\n",x->i);
          r0(x);
        }
        //else connection closed
      }
    }
    else
      printf("No data within five seconds.\n");
  }
  kclose(fd);
  return 0;
}
```


## Unix domain sockets

A Unix domain socket may be requested via the IP address `0.0.0.0`, e.g.

```c
int handle=khpu("0.0.0.0",5000,"user:password");
```


## SSL/TLS

To use this feature, you must link with one of [the `e` libs](#two-sets-of-files).

Encrypted connections may be requested via the capability parameter of the new `khpunc` function, e.g.

```c
extern I khpunc(S hostname,I port,S usernamepassword,I timeout,I capability); 
// capability is a bit field (1 - 1TB limit, 2 - use TLS)
int handle=khpunc("remote host",5000,"user:password",timeout,2);
```

There’s an additional return value for TLS connections, `-3`, which indicates the `openssl init` failed. This can be checked via

```c
extern K sslInfo(K x); // returns an error if init fails, or a dict of settings similar to -26!x
if(handle==-3){K x=ee(sslInfo((K)0));printf("Init error %s\n",xt==-128?x->s:"unknown");r0(x);}
```

A restriction for SSL/TLS connections – these can be used from the initialization thread only, i.e. the thread which first calls any `khp` function since the start of the application.

The lib is sensitive to the same environment variables as kdb+, noted at [Knowledge Base: SSL/TLS](../kb/ssl.md)

The OpenSSL libs are loaded dynamically,  the first time a TLS connection is requested. It may be forced on startup with

```c
int h=khpunc("",-1,"",0,2); // remember to test the return value for -3
```


## Socket timeouts

There are a number of reasons not to specify or implement timeouts. 
Typically these will be hit at the least convenient of times when under load from e.g. a sudden increase in trading volumes. 
Cascading timeouts can rapidly bring systems down and/or waste server resources. 
But if you are convinced they are the only solution for your problem scenario, the following code may help you. 
(Note that in the event of a timeout, you must close the connection.)

```c
#if defined(_WIN32) || defined(__WIN32__)
V sst(I d,I sendTimeout,I recvTimeout){
  setsockopt(d,SOL_SOCKET,SO_SNDTIMEO,(char*)&sendTimeout,sizeof(I));
  setsockopt(d,SOL_SOCKET,SO_RCVTIMEO,(char*)&recvTimeout,sizeof(I));}
#else
V sst(I d,I sendTimeout,I recvTimeout){
  struct timeval tv;tv.tv_sec=sendTimeout/1000;tv.tv_usec=sendTimeout%1000000;
  setsockopt(d,SOL_SOCKET,SO_SNDTIMEO,(char*)&tv,sizeof(tv));
  tv.tv_sec=recvTimeout/1000;tv.tv_usec=recvTimeout%1000000;
  setsockopt(d,SOL_SOCKET,SO_RCVTIMEO,(char*)&tv,sizeof(tv));}
#endif

// usage
int c=khpun("localhost",1234,"myname:mypassword",1000); // connect timeout 1000mS
if(c>0) sst(c,30000,45000); // timeout sends with 30s, receives with 45s
```



## Bulk transfers

A kdb+tick feed handler can send one record at a time, like this

```c
I kdbSocketHandle = khpu("localhost", 5010, "username");
if (kdbSocketHandle > 0)
{
  K row = knk(3, ks((S)"ibm"), kf(93.5), ki(300));
  K r = k(-kdbSocketHandle, ".u.upd", ks((S)"trade"), row, (K)0);
  if(!r) { perror("network error"); return;}
  kclose(kdbSocketHandle);
}
```

or send multiple records at a time:

```c
int n = 100;
S sid[] = {"ibm","gte","kvm"};
K x = knk(3, ktn(KS, n), ktn(KF, n), ktn(KI, n));
for(int i=0; i<n ; i++) {
  kS(kK(x)[0])[i] = ss(sid[i%3]);
  kF(kK(x)[1])[i] = 0.1*i;
  kI(kK(x)[2])[i] = i;
}
K r = k(-kdbSocketHandle, ".u.upd", ks((S)"trade"), x, (K)0);
if(!r) perror("network");
```

This example assumes rows with three fields: symbol, price and size.


## Error signaling and catching

Note the two different directions of error flow below.

1.  To signal an error from your C code to kdb+ use the function `krr(S)`. 
A utility function `orr(S)` can be used to signal system errors. 
It is similar to `krr(S)`, but it appends a system error message to the user-provided string before passing it to `krr`. 

1.  To catch an error code from the results of a call to `r=k(h, …)`, check the return value and type. 
If result is `NULL`, then a network error has occurred. 
If it has type -128, then `r->s` will point to the error string. Note that K object with type -128 acts as a marker only and other uses are not supported(i.e. passing it to other C API or kdb+ functions).

```c
K r=k(handle, "f", arg1, arg2, (K)0);
if(r && -128==r->t)
  printf("error string: %s\n", r->s);
```

Under some network-error scenarios, `errno` can be used to obtain the details of the error,
e.g. `perror(“network”);`

:fontawesome-regular-hand-point-right:
[`krr`](capiref.md#krr-signal-c-error)


## Return values

If your C function, called from q, has nothing to return to q, it can return `(K)0`.

```c
K doSomething(K x)
{
  // do something with x;
  return (K)0;
}
```

From a standalone C application, it can sometimes be convenient to return the identity function `(::)`. 
This atom can be created with

```c
K identity(){
  K id=ka(101);
  id->g=0;
  return id;
}
```


## Callbacks

The `void sd0(I)` and `K sd1(I, K(*)(I))` functions are for use with callbacks and are available only within q itself, i.e. used from a shared library loaded into q. 
The value of the file descriptor passed to `sd1` must be 0 &lt; `fd` &lt; 1024, and 1021 happens to be the maximum number of supported connections (recalling 0, 1, 2 used for stdin,stdout,stderr).

```c
sd1(d,f);
```

puts the function `K f(I d){…}` on the q main event loop given a socket `d` (or `-d` for non-blocking). 
The function `f` should return `(K)0` or a pointer to a K object, and its reference count will be decremented.

```c
sd0(d); 
sd0x(d,1);
```

Each of the above calls removes the callback on `d` and calls `kclose(d)`.  `sd0x(I d,I f)` was introduced in V3.0 2013.04.04: its second argument indicates whether to call `kclose(d)`.

On Linux, `eventfd` can be used with `sd1` and `sd0`. Given a file efd.c

```c
// compile with
// gcc -shared -m64 -DKXVER=3 efd.c -o efd.so -fPIC
// or
// g++ -shared -m64 -DKXVER=3 efd.cpp -o efd.so -fPIC
#include<stdio.h>
#include<sys/eventfd.h>
#include<unistd.h>
#include"k.h"
#ifdef __cplusplus
extern"C"{
#endif
K callback(I d){K r;J a;R -1!=read(d,&a,8)?r=k(0,(S)"onCallback",ki(d),kj(a),(K)0),r->t==-128?krr(r->s),r0(r),(K)0:r:(sd0(d),orr((S)"read"));}
K newFd(K x){I d;R x->t!=-KJ?krr((S)"type"):(d=eventfd(x->j,0))==-1?orr((S)"eventfd"):sd1(d,callback);}
K writeFd(K x,K y){R x->t!=-KI||y->t!=-KJ?krr((S)"type"):-1!=write(x->i,&y->j,8)?0:(sd0(x->i),orr((S)"write"));}
#ifdef __cplusplus
}
#endif
```

and combined with appropriate q code

```q
q)newFd:(`$"./efd")2:(`newFd;1)
q)writeFd:(`$"./efd")2:(`writeFd;2)
q)fd:newFd 0 / arg is start value of eventfd counter
q)onCallback:{0N!(x;y)}
q)writeFd[fd;3] / increments the eventfd counter by 3, triggering the callback later
```

This demonstrates the deferred invocation of `onCallback` until q has at least finished processing the current handle or script. 
In situations where you can’t hook a feedhandler’s callbacks directly into `sd1`, on Linux `eventfd` may be a viable option for you. 
Callbacks from `sd1` are executed on the main thread of q.

!!! tip "Windows developers may be interested in :fontawesome-brands-github: [ncm/selectable-socketpair](https://github.com/ncm/selectable-socketpair)."

Callbacks from `sd1` are executed on the main thread of q, in the handle context ([`.z.w`](../ref/dotz.md#zw-handle)) of the registered handle, and hence are also subject to permissions checks:

-   read-only [(Command-line option `-b`)](../basics/cmdline.md#-b-blocked)
-   access-controlled path ([Command-line option `-u`)](../basics/cmdline.md#-u-usr-pwd-local)
-   [`reval`](../ref/eval.md#reval)


## Serialization and deserialization

The `K b9(I,K)` and `K d9(K)` functions serialize and deserialize K objects.

```c
b9(mode,kObject);
```

will generate a K byte vector that contains the serialized data for `kObject`. 
Since V3.0, for shared libraries loaded into q the value for `mode` must be -1. 
For standalone applications binding with c.o/c.dll, or shared libraries prior to V3.0, the values for `mode` can be

value | effect
------|------
-1    | valid for V3.0+ for serializing/deserializing within the same process
0     | unenumerate, block serialization of timespan and timestamp (For working with versions prior to 2.6).
1     | retain enumerations, allow serialization of timespan and timestamp. (Useful for passing data between threads).
2     | unenumerate, allow serialization of timespan and timestamp
3     | unenumerate, compress, allow serialization of timespan and timestamp

```c
d9(kObject);
```

will deserialize the byte stream in `kObject` returning a new `kObject`. 
The byte stream passed to `d9` is not altered in any way. 
If you are concerned that the byte vector that you wish to deserialize may be corrupted, call `okx` to verify it is well formed first.

```c
unsigned char bytes[]={0x01,0x00,0x00,0x00,0x0f,0x00,0x00,0x00,0xf5,0x68,0x65,0x6c,0x6c,0x6f,0x00}; // -8!`hello
K r,x=ktn(KG,sizeof(bytes));
memcpy(kG(x),bytes,x->n);
int ok=okx(byteVector);
if(ok){
  r=d9(byteVector);
  r0(x);
}
else
  perror("bad data");
```


## Miscellaneous

The `K dot(K x, K y)` function is the same as the q function `.[x;y]`.

```q
q).[{x+y};(1 2;3 4)]
4 6
```

The dynamic link, `K dl(V* f, I n)`, function takes a C function that would take _n_ K objects as arguments and return a new K object, and returns a q function. 
It is useful, for example, to expose more than one function from an extension module.

```c
#include "k.h"
Z K1(f1){R r1(x);}
Z K2(f2){R r1(y);}
K1(lib){K y=ktn(0,2);x=ktn(KS,2);xS[0]=ss("f1");xS[1]=ss("f2");
  kK(y)[0]=dl(f1,1);kK(y)[1]=dl(f2,2);R xD(x,y);}
```

Alternatively, for simpler editing of your lib API:

```c
#define sdl(f,n) (js(&x,ss(#f)),jk(&y,dl(f,n)))
K1(lib){K y=ktn(0,0);x=ktn(KS,0);sdl(f1,1);sdl(f2,2);R xD(x,y);}
```

With the above compiled into `lib.so`:

```q
q).lib:(`:lib 2:(`lib;1))`
q).lib.f1 42
42
q).lib.f2 . 42 43
43
```


## Debugging with gdb

It can be a struggle printing q values from a debugger, but you can call the handy k.h macros in gdb like `xt`, `xC`, `xK`, …

If your client is a shared library, you might get away with `p k(0,"show",r1(x),(K)0)`

:fontawesome-regular-hand-point-right: 
_GDB Manual_: [§12. C Preprocessor Macros](https://sourceware.org/gdb/onlinedocs/gdb/Macros.html)

Now, we compile the program using the GNU C compiler, `gcc`. We pass the `-gdwarf-21` and `-g3` flags to ensure the compiler includes information about preprocessor macros in the debugging information.

```bash
$ gcc -gdwarf-2 -g3 sample.c -o sample
$
```

Now, we start `gdb` on our sample program:

```bash
$ gdb -nw sample
GNU gdb 2002-05-06-cvs
Copyright 2002 Free Software Foundation, Inc.
GDB is free software, ...
(gdb)
```

And all you need is

```bash
gcc -g3 client.c -o client
gdb ./client
```
… get signal, go up stack frame with `up`:

```bash
Thread 1 "sdl" received signal SIGSEGV, Segmentation fault.
0x000000000040711b in nx ()
(gdb) up
#1  0x0000000000407411 in nx ()
(gdb)  
#2  0x0000000000407411 in nx ()
 (gdb) 
#3  0x0000000000408a15 in b9 ()
(gdb) 
#4  0x0000000000409ac2 in ww ()
(gdb) 
#5  0x0000000000409d33 in k ()
(gdb) 
#6  0x000000000040410d in main (n=1, v=0x7fffffffdf68) at sdl.c:108
108     }else if(e.type==SDL_USEREVENT){K x=e.user.data1;A(!xt);A(xn==2);k(-c,"{value[x]y}",xK[0]->s,xK[1],(K)0);}
```

Now use `k.h` macros!

```c
(gdb) p xt
$20 = 0 '\000'
(gdb) p xn
$21 = 2
```

so it’s a q list. Show two elements:

```c
(gdb) p xK[0]->t
$23 = -11 '\365'
(gdb) p xK[0]->s
$24 = (S) 0x2078b98 `"blink"
(gdb) p xK[1]->t
$25 = -7 '\371'
(gdb) p xK[1]->j
$27 = 0
```

which is a bit easier than:

```c
(gdb) p *(((K*)(x->G0))[0])
$14 = {m = 0 '\000', a = 1 '\001', t = -11 '\365', u = 0 '\000', r = 0, {g = 152 '\230', h = -29800, i = 34048920, j = 34048920, 
   e = 9.95829503e-38, f = 1.6822401649996936e-316, s = 0x2078b98 "blink", k = 0x2078b98, {n = 34048920, G0 = ""}}}
(gdb) p *(((K*)(x->G0))[1])
$13 = {m = 0 '\000', a = 0 '\000', t = -7 '\371', u = 0 '\000', r = 0, {g = 0 '\000', h = 0, i = 0, j = 0, e = 0, f = 0, s = 0x0, k = 0x0, 
   {n = 0, G0 = "\002"}}}
```


## Windows and the LoadLibrary API

The q multithreaded C library (`c.dll`) uses static thread-local storage (TLS), and is incompatible with the `LoadLibrary` Win32 API. 
If you are writing an Excel plugin, this point is relevant to you, as loading of the plugin uses this mechanism. 

:fontawesome-regular-hand-point-right:
Microsoft Knowledge Base: [PRB: Calling LoadLibrary() to Load a DLL That Has Static TLS](http://support.microsoft.com/kb/118816)

When trying to use the library, the problem manifests itself as a crash during the `khpu()` call.

Hence KX also provides at :fontawesome-brands-github: [KxSystems/kdb](https://github.com/KxSystems/kdb) a single-threaded version of this library as `w32/cst.dll` and `w64/cst.dll`, which do _not_ use TLS. 
To use this library:

-    download `cst.dll` and `cst.lib` 
-    rename them to `c.dll`/`c.lib`
-    relink and ensure that `c.dll` is in your path

If in doubt whether the `c.dll` you have uses TLS, run

```bash
dumpbin /EXPORTS c.dll
```

and look for a `.tls` entry under the summary section. 
If it is present it uses TLS and is the wrong library to link with use with Excel add-ins.

```bash
...
Summary

      4000 .data
      1000 .rdata
      1000 .reloc
      1000 .rsrc
      7000 .text
      1000 .tls
```


## Troubleshooting: loading a library

In some cases [`2:`](../ref/dynamic-load.md) may fail because of missing dependencies. Sadly, OS error messages are not always helpful. 

You can check dependencies using the methods described at [qt.io](https://wiki.qt.io/Show_library_dependencies).


## Example

:fontawesome-brands-github: 
[KxSystems/cookbook/c/csv.c](https://github.com/KxSystems/cookbook/blob/master/c/csv.c) – CSV export example in C

