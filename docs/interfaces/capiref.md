---
title: C API reference – Interfaces – kdb+ and q documentation
description: A reference guide to the API for connecting a C program to a kdb+ server process
author: Charles Skelton
keywords: api, c, interface, kdb+, library, q, reference
---
# C API Reference


:fontawesome-regular-hand-point-right: [C client for kdb+](c-client-for-q.md)


## Overview

### K object

The C API provides access to the fundamental data `K` object of kdb+ and methods of manipulating it. The `K` object is a pointer to a `k0` struct, a [tagged union](https://en.wikipedia.org/wiki/Tagged_union), and most of the API manipulates this pointer.

It is defined as
```c
typedef struct k0 *K;
```

More detailed information can be found in C API header file [k.h](https://github.com/KxSystems/kdb/blob/master/c/c/k.h).
The C API defines some types to improve uniformity of the API.

```txt
unsigned char   G
16-bit int      H
32-bit int      I
64-bit int      J
32-bit float    E
64-bit double   F
char            C
char*           S
void            V
16-byte array   U
```


### Accessing members of the K object

### K object properties for object x

The members which are common to all variant types are `t`, `u`, and `r`. The field `n` is common to all variant types which have a length. These may be dereferenced as usual in the C language:
```txt
x->t    type of K object. (signed char)
x->u    attribute. 0 means no attributes. (C)
x->r    reference count. Modify only via r1(x), r0(x). (I)
x->n    number of elements in a list. (J)
```

### Atom accessors for object x

The fields of the variant types which represent an atom (sometimes called a scalar) are:

```txt
kdb+ type   accessor    derived types
---------------------------------------------------------
byte        x->g (G)    boolean, char
short       x->h (H)
int         x->i (I)    month, date, minute, second, time
long        x->j (J)    timestamp, timespan
real        x->e (E)
float       x->f (F)    datetime
symbol      x->s (S)    error
table       x->k (K)
```

### List accessors

To simplify accessing the members for list variant, the following multiple helper macros are provided, to be used as, `kG(x)`, for example.

```txt
q type name   interface list accessor function
----------------------------------------------------------
mixed list    K* kK(x)
boolean       G* kG(x)
guid          U* kU(x)
byte          G* kG(x)
short         H* kH(x)
int           I* kI(x)
long          J* kJ(x)
real          E* kE(x)
float         F* kF(x)
char          C* kC(x)
symbol        S* kS(x)
timestamp     J* kJ(x)
month         I* kI(x)
date          I* kI(x)  days from 2000.01.01
datetime      F* kF(x)  days from 2000.01.01
timespan      J* kJ(x)  nanoseconds
minute        I* kI(x)
second        I* kI(x)
time          I* kI(x)  milliseconds
dictionary    kK(x)[0]  or keys and kK(x)[1] for values
```


## Reference counting

Q uses reference counting to manage object lifetimes. You are said to _own a reference_ if you have created it with [`r1`](#r1-increment-refcount) or received it with an object returned to a call by a C API function. You are responsible for destroying the reference you own with [`r0`](#r0-decrement-refcount) when you are finished with the object.

Ownership of a reference to an object passed as parameter can be taken from you by some of the C API functions. Other C API functions, and all functions from dynamically-linked modules, do not take ownership of references to their parameters; they have to create a new reference to any object they wish to retain or return.

If ownership of a reference has been taken from you, you are no longer responsible for it and should not destroy it. To retain an owned reference to an object, create a new reference to it prior to the call.


## Error handling

C API functions marked as requiring `ee` return 0 on error. You should either propagate the error further by returning 0 or handle it by calling `ee` and handling the resulting object.

Note that you can only return an error object at a top level from a C function called from q.


## Constants

Q has a rich type system. The type is indicated by a type number and many of these numbers have a constant defined around 0. Positive numbers are used for types which have a length, and the negative of these represent the scalar type.

For example, `KB` is the type for a vector of booleans, and the negative, `-KB` is for an atom of type boolean.

Some types do not have a constant. For example, `mixed list` has type `0`, and `error` has a type `-128`.

```txt
constant  associated type  value
--------------------------------
KB        boolean          1
UU        guid             2
KG        byte             4
KH        short            5
KI        int              6
KJ        long             7
KE        real             8
KF        float            9
KC        char             10
KS        symbol           11
KP        timestamp        12
KM        month            13
KD        date             14
KZ        datetime         15
KN        timespan         16
KU        minute           17
KV        second           18
KT        time             19
XT        table            98
XD        dictionary       99
```

Some numeric constants are defined and have special meaning – indicating null or positive infinity for that type.

```txt
constant   value                                      description
--------------------------------------------------------------------
nh         0xFFFF8000                                 short null
wh         0x7FFF                                     short infinity
ni         0x80000000                                 int null
wi         0x7FFFFFFF                                 int infinity
nj         0x8000000000000000                         long null
wj         0x7FFFFFFFFFFFFFFF                         long infinity
nf         log(-1.0) on Windows or (0/0.0) on Linux   float null
wf         -log(0.0) in Windows or (1/0.0) on Linux   float infinity
```

## Functions by category

### Constructors

<pre markdown="1" class="language-txt">
[ka](#ka-create-atom)  atom        [kj](#kj-create-long)   long            [ktj](#ktj-create-timespan)    timespan
[kb](#kb-create-boolean)  boolean     [knk](#knk-create-list)  list            [ktn](#ktn-create-vector)    vector
[kc](#kc-create-char)  char        [knt](#knt-create-keyed-table)  keyed table     [ku](#ku-create-guid)     guid
[kd](#kd-create-date)  date        [kp](#kp-create-string)   char array      [kz](#kz-create-datetime)     datetime
[ke](#ke-create-real)  real        [kpn](#kpn-create-fixed-string)  char array      [vaknk](#vak-vaknk-va_list-versions-of-k-knk)  va_list version of knk
[kf](#kf-create-float)  float       [ks](#ks-create-symbol)   symbol          [xD](#xd-create-dictionary)     dictionary
[kg](#kg-create-byte)  byte        [kt](#kt-create-time)   time            [xT](#xt-table-from-dictionary)     table
[kh](#kh-create-short)  short       [ktd](#ktd-create-simple-table)  simple table
[ki](#ki-create-int)  int         [ktj](#ktj-create-timestamp)  timestamp
</pre>

### Joins

<pre markdown="1" class="language-txt">
[ja](#ja-join-value)  raw value to list    [js](#js-join-string)  interned string to symbol vector
[jk](#jk-join-k-object)  K object to list     [jv](#jv-join-k-lists)  K list to first of same type
</pre>

When appending to a list, if the capacity of the list is
insufficient to accommodate the new data, the list is reallocated with the contents of `x` updated. The new data is always appended, unless the reallocation causes an out-of-memory condition which is then fatal; these functions never return `NULL`. The reallocation of the list will cause the initial list’s reference count to be decremented. The target list passed to join functions should not have an attribute, and the caller should consider that modifications to that target object will be visible to all references to that object unless a reallocation occurred.


### Other functions

<pre markdown="1" class="language-txt">
[b9](#b9-serialize)   serialize               [r0](#r0-decrement-refcount)    decrement ref count
[d9](#d9-deserialize)   deserialize             [r1](#r1-increment-refcount)    increment ref count
[dj](#dj-date-to-number)   date to integer         [sd0](#sd0-remove-callback)   remove callback
[dl](#dl-dynamic-link)   dynamic link            [sd0x](#sd0x-remove-callback-conditional)  remove callback
[dot](#dot-apply)  apply                   [sd1](#sd1-set-function-on-loop)   function on event loop
[ee](#ee-error-string)   capture error           [setm](#setm-toggle-symbol-lock)  toggle symbol lock
[k](#k-evaluate)    evaluate                [sn](#sn-intern-chars)    intern chars from string
[krr](#krr-signal-c-error)  signal C error          [ss](#ss-intern-string)    intern null-terminated string
[m9](#m9-release-memory)   release memory          [vak](#vak-vaknk-va_list-versions-of-k-knk)   va_list version of k
[okx](#okx-verify-ipc-message)  verify IPC message      [ymd](#ymd-numbers-to-date)   encode q date
[orr](#orr-signal-system-error)  signal system error
</pre>


### Standalone applications

<pre markdown="1" class="language-txt">
[kclose](#kclose-disconnect)  disconnect from host
[khp](#khp-connect-anonymously)     connect to host without credentials
[khpu](#khpu-connect-no-timeout)    connect to host without timeout
[khpun](#khpun-connect)   connect to host
</pre>

!!! warning "Unless otherwise specified, no function accepting K objects should be passed `NULL`."


## Functions by name

In the following descriptions, functions are tagged as follows.

```txt
c.o  is also available in c.o
own  takes ownership of a reference
ee   requires ee for error handling
```

### `b9` – serialize

Signature: `K b9(I mode, K x)`
Tags: `c.o` `ee`

Uses q IPC and  `mode` capabilities level, where `mode` is:

value | effect
:----:|------
-1    | valid for V3.0+ for serializing/deserializing within the same process
0     | unenumerate, block serialization of timespan and timestamp (for working with versions prior to V2.6)
1     | retain enumerations, allow serialization of timespan and timestamp: Useful for passing data between threads
2     | unenumerate, allow serialization of timespan and timestamp
3     | unenumerate, compress, allow serialization of timespan and timestamp


On success, returns a byte-array K object with serialized representation. On error, `NULL` is returned; use `ee` to retrieve error string.


### `d9` – deserialize

Signature: `K d9(K x)`<br>
Tags: `c.o` `ee`

The byte array `x` is not modified.

On success, returns deserialized K object. On error, `NULL` is returned; use `ee` to retrieve the error string.



### `dj` – date to number

Signature: `I dj(I date)`<br>
Tags: `c.o`

Converts a q date to a `yyyymmdd` integer.

:fontawesome-regular-hand-point-right:
[`ymd` – numbers to date](#ymd-numbers-to-date)


### `dl` – dynamic link

Signature: `K dl(V* f, J n)`

Function takes a C function that would take _n_ K objects as arguments and returns a K object. Shared library only.

Returns a q function.


### `dot` – apply

Signature: `K dot(K x, K y)`<br>
Tags: `ee`

The same as the q function [Apply](../ref/apply.md), i.e. `.[x;y]`. Shared library only.

On success, returns a K object with the result of the `.` application. On error, `NULL` is returned. See `ee` for result-handling example.



### `ee` – error string

Signature: `K ee(K)`<br>
Tags: `c.o`

Capture (and reset) error string into usual error object, e.g.
```c
K x=ee(dot(a,b));if(xt==-128)printf("error %s\n", x->s);
```

Since V3.5 2017.02.16, V3.4 2017.03.13

!!! tip "Handling errors"

    If a function returns type K and has the option to return NULL, the user should wrap the call with `ee`, and check for the error result, also considering that the error string pointer (`x->s`) may also be NULL. e.g.

    ```c
    ​K x=ee(dot(a,b));if(xt==-128)printf("error %s\n", x->s?x->s:"");
    ```

    Otherwise the error status within the interpreter may still be set, resulting in the error being signalled incorrectly elsewhere in kdb+.

    Calling `ee(…)` has the side effect of clearing the interpreter’s error status for the NULL result path.


### `ja` – join value

Signature: `K ja(K* x, V*)`<br>
Tags: `c.o`

Appends a raw value to a list.
`x` points to a K object, which may be reallocated during the function.
The contents of `x`, i.e. `*x`, will be updated in case of reallocation.

Returns a pointer to the (potentially reallocated) K object.


### `jk` – join K object

Signature: `K jk(K* x, K y)`<br>
Tags: `c.o` `own`

Appends another K object to a mixed list. Takes ownership of a reference to its argument `y`.

Returns a pointer to the (potentially reallocated) K object.


### `js` – join string

Signature: `K js(K* x, S s)`<br>
Tags: `c.o`

Appends an interned string `s` to a symbol list.

Returns a pointer to the (potentially reallocated) K object.


### `jv` – join K lists

Signature: `K jv(K* x, K y)`<br>
Tags: `c.o`

Append a K list `y` to K list `x`.

Returns a pointer to the (potentially reallocated) K object.


### `k` – evaluate

<!-- Signature: `K k(I handle, const S s, …)__attribute__((sentinel))` -->
Signature: `K k(I handle, const S s, …)`<br>
Tags: `own`

Evaluates `s`.
Optional parameters are either local (shared library only) or remote.
The last argument must be `NULL`.

Takes ownership of references to its arguments.

Behavior depends on the value of `handle`.

-    `handle>0`, sends sync message to handle, to evaluate a string or function with parameters, and then blocks until a message of any type is received on handle. It can return `NULL` (indicating a network error) or a pointer to a K object. `k(handle,(S)NULL)` does not send a message, and blocks until a message of any type is received on handle.
    If that object has type -128, it indicates an error, accessible as a null-terminated string in `r->s`. When you have finished using this object, it should be freed by calling `r0(r)`.

-    `handle<0`, this is for async messaging, and the return value can be either 0 (network error) or non-zero (success). This result should _not_ be passed to `r0`.

<!-- -   `handle=0`, this function is equivalent of [_apply_](../ref/unclassified/#apply) (`.`). -->
-   `handle==0` is valid only for a plugin, and executes against the kdb+ process in which it is loaded.

See more on [message types](java-client-for-q.md#message-types). Note that a `k` call will block until a message is sent/received (`handle!=0`) or evaluated (`handle=0`).




### `ka` – create atom

Signature: `K ka(I t)`<br>
Tags: `c.o`

Creates an atom of type `t`.


### `kb` – create boolean

Signature: `K kb(I)`<br>
Tags: `c.o`



### `kc` – create char

Signature: `K kc(I)`<br>
Tags: `c.o`

Null: `kc(" ")`


### `kclose` – disconnect

Signature: `V kclose(I)`

With the release of `c.o` with V2.6, `c.o` now tracks the connection type (pre V2.6, or V2.6+). Hence, to close the connection, you must call `kclose` (instead of `close` or `closeSocket`): this will clean up the connection tracking and close the socket.

Standalone apps only.
Available only from [the c/e libs](c-client-for-q.md#two-sets-of-files) and not as a shared library loaded into kdb+.


### `kd` – create date

Signature: `K kd(I)`<br>
Tags: `c.o`

Null: `kd(ni)`


### `ke` – create real

Signature: `K ke(F)`<br>
Tags: `c.o`

Null: `ke(nf)`


### `kf` – create float

Signature: `K kf(F)`<br>
Tags: `c.o`

Null: `kf(nf)`


### `kg` – create byte

Signature: `K kg(I)`<br>
Tags: `c.o`


### `kh` – create short

Signature: `K kh(I)`<br>
Tags: `c.o`

Null: `kh(nh)`


### `khp` – connect anonymously

Signature: `I khp(const S hostname, I port)`

Standalone apps only.
Available only from [the c/e libs](c-client-for-q.md#two-sets-of-files) and not as a shared library loaded into kdb+.

:fontawesome-regular-hand-point-right: `khpu(hostname, port, "")`


### `khpu` – connect, no timeout

Signature: `I khpu(const S hostname, I port, const S credentials)`

Standalone apps only.
Available only from [the c/e libs](c-client-for-q.md#two-sets-of-files) and not as a shared library loaded into kdb+.

:fontawesome-regular-hand-point-right: `khpun(hostname, port, credentials, 0)`


### `khpun` – connect

Signature: `I khpun(const S hostname, I port, const S credentials, I timeout)`

Establish a connection to hostname on port providing credentials (`username:password` format) with timeout.

On success, returns positive file descriptor for established connection. On error, 0 or a negative value is returned.

```txt
 0   Authentication error
-1   Connection error
-2   Timeout error
```

Standalone apps only.
Available only from [the c/e libs](c-client-for-q.md#two-sets-of-files) and not as a shared library loaded into kdb+.


### `khpunc` – connect with capability

Signature: `I khpunc(S hostname, I port, S credentials, I timeout, I capability)`

`capability` is a bit field:

```txt
1    1 TB limit
2    use TLS
```

??? detail "Messages larger than 2GB"

    During the initial handshake of a connection, each side’s capability is exchanged, and the common maximum is chosen for the connection. By setting the capability parameter for `khpunc`, the default message-size limit for this connection can be raised from 2GB to 1TB. e.g.

    ```
    int handle=khpunc("hostname",5000,"user:password",timeout,1);
    ```

    A TLS-enabled connection supporting upto 1TB messages can be achieved via bit-or of the TLS and 1TB bits, e.g.

    ```
    int handle=khpunc("hostname",5000,"user:password",timeout,1|2);
    ```

A return value of -3 indicates the OpenSSL initialization failed.

```txt
 0   Authentication error
-1   Connection error
-2   Timeout error
-3   OpenSSL initialization failed
```

:fontawesome-regular-hand-point-right: [`sslInfo`](#sslinfo-ssl-info)

!!! tip "Unix domain socket"

    For `khp`, `khpu`, `khpun`, and `khpunc` a Unix domain socket may be requested via the IP address `0.0.0.0`, e.g.

    ```
    int handle=khpu("0.0.0.0",5000,"user:password");
    ```


### `ki` – create int

Signature: `K ki(I)`<br>
Tags: `c.o`

Null: `ki(ni)`


### `kj` – create long

Signature: `K kj(J)`<br>
Tags: `c.o`

Null: `kj(nj)`


### `knk` – create list

Signature: `K knk(I n, …)`<br>
Tags: `c.o`

Create a mixed list.

Takes ownership of references to arguments.


### `knt` – create keyed table

Signature: `K knt(J n, K x)`<br>
Tags: `c.o` `ee`

Create a table keyed by `n` first columns if number of columns exceeds `n`.

Returns null if the argument `x` is not a table.


### `kp` – create string

Signature: `K kp(S x)`<br>
Tags: `c.o`

Create a char array from a string.


### `kpn` – create fixed-length string

Signature: `K kpn(S x, J n)`<br>
Tags: `c.o`

Create a char array from a string of length `n`.


### `krr` – signal C error

Signature: `K krr(const S)`<br>
Tags: `c.o`

Kdb+ recognizes an error returned from a C function via the function’s return value being 0, combined with the value of a global error indicator that can be set by calling `krr` with a null-terminated string. As `krr` records only the passed pointer, you should ensure that the string remains valid after the return from your code into kdb+ – typically you should use static storage for the string. (Thread-local if you expect to amend the error string from multiple threads.) The strings `"stop"`, `"abort"` and `"stack"` are reserved values and `krr` must not be called with those.

Do **not** call `krr()` and then return a valid pointer!
For convenience, `krr` returns 0, so it can be used directly as 

```c
K f(K x){
  K r=someFn();
  ...
  if(some error)
    return krr("an error message"); // preferred style
  ...
  return r;
}
```

or a style more prone to mismatch, decoupled as

```c
K f(K x){
  I f=0;
  K r=someFn();
  ...
  if(some error){
    krr("an error message"); // set the message string
    f=1;
  }
  ...
  if(f)
    return 0; // combined with string set via krr(), this return value of 0 indicates an error 
  else
    return r;
}
```

:fontawesome-regular-hand-point-right:
[Error signaling and catching](c-client-for-q.md#error-signaling-and-catching)


### `ks` – create symbol

Signature: `K ks(S x)`<br>
Tags: `c.o`

Null: `ks("")`


### `kt` – create time

Signature: `K kt(I x)`<br>
Tags: `c.o`

Create a time from a number of milliseconds since midnight.

Null: `ki(ni)`


### `ktd` – create simple table

Signature: `K ktd(K x)`<br>
Tags: `c.o` `ee` `own`

Create a simple table from a keyed table.

Takes ownership of a reference to its argument `x`.


### `ktj` – create timestamp

Signature: `K ktj(-KP, x)`<br>
Tags: `c.o`

Create a timestamp from a number of nanos since 2000.01.01.

Null: `ktj(-KP, nj)`


### `ktj` – create timespan

Signature: `K ktj(-KN, x)`<br>
Tags: `c.o`

Create a timespan from a number of nanos since the beginning of the interval: midnight in the case of `.z.n`.

Null: `ktj(-KN, nj)`


### `ktn` – create vector

Signature: `K ktn(I type, J length)`<br>
Tags: `c.o`


### `ku` – create guid

Signature: `K ku(U)`<br>
Tags: `c.o`

Null: `U g={0};ku(g)`


### `kz` – create datetime

Signature: `K kz(F)`<br>
Tags: `c.o`

Create a datetime from the number of days since 2000.01.01.
The fractional part is the time.

Null: `kz(nf)`


### `m9` – release memory

Signature: `V m9(V)`

Release the memory allocated for the thread’s pool.

Call `m9()` when the thread is about to complete, releasing the memory allocated for that thread’s pool.


### `okx` – verify IPC message

Signature: `I okx(K x)`<br>
Tags: `c.o`

Verify that the byte vector `x` is a valid IPC message.

Decompressed data only. `x` is not modified.

Returns `0` if not valid.


### `orr` – signal system error

Signature: `K orr(const S)`<br>
Tags: `c.o`

Similar to `krr`, this appends a system-error message to string `S` before passing it to `krr`.


### `r0` – decrement refcount

Signature: `V r0(K)`<br>
Tags: `c.o`

Decrement an object‘s reference count.

If `x->r` is 0, `x` is unusable after the `r0(x)` call, and the memory pointed to by it may have been freed.

!!! warning "Reference counting starts and ends with 0, not 1."


### `r1` – increment refcount

Signature: `K r1(K)`<br>
Tags: `c.o`

Increment an object‘s reference count.


### `sd0` – remove callback

Signature: `V sd0(I d)`

Remove the callback on `d` and call `kclose`.

Returns null if the socket descriptor arg `d` is invalid or was not registered via `sd1`.

Shared library only.


### `sd0x` – remove callback conditional

Signature: `V sd0x(I d, I f)`<br>

Remove the callback on `d` and call `kclose` on `d` if `f` is 1.

Returns null if the socket descriptor arg `d` is invalid or was not registered via `sd1`.

Shared library only. Since V3.0 2013.04.04.


### `sd1` – set function on loop

Signature: `K sd1(I d, f)`

Put the function `K f(I d){…}` on the q main event loop given a socket `d`.

If `d` is negative, the socket is switched to non-blocking.

The function `f` should return `NULL` or a pointer to a K object, and its reference count will be decremented.
(It is the return value of `f` that will be `r0`’d – and only if not null.)

Shared library only.

On success, returns int K object containing `d`. On error, `NULL` is returned, `d` is closed.

:fontawesome-regular-hand-point-right:
[Callbacks](c-client-for-q.md#callbacks)


### `setm` – toggle symbol lock

Signature: `I setm(I m)`

Set whether interning symbols uses a lock: `m` is either 0 or 1.

Returns the previously set value.


### `sn` – intern chars

Signature: `S sn(S, J n)`<br>
Tags: `c.o`

Intern `n` chars from a string.

Returns an interned string and should be used to store the string in a symbol vector.


### `ss` – intern string

Signature: `S ss(S)`<br>
Tags: `c.o`

Intern a null-terminated string.

Returns an interned string and should be used to store the string in a symbol vector.


### `sslInfo` – SSL info

Signature: `K sslInfo(K x)`

A dictionary of settings similar to [`-26!x`](../basics/internal.md#-26x-ssl), or an error if SSL initialisation failed.

```c
extern I khpunc(S hostname,I port,S usernamepassword,I timeout,I capability);
int handle=khpunc("remote host",5000,"user:password",timeout,2);
extern K sslInfo(K x);
if(handle==-3){
    K x=ee(sslInfo((K)0));
    printf("Init error %s\n",xt==-128?x->s:"unknown");
    r0(x);
}
```

Returns null if there was an error initializing the OpenSSL lib.


### `vak`, `vaknk` – va_list versions of k, knk

Signature: `K vak(I,const S,va_list)`<br>
Signature: `K vaknk(I,va_list)`

where `va_list` is as defined in
[`stdarg.h`](https://en.wikipedia.org/wiki/Stdarg.h),
included by `k.h`

These are `va_list` versions of the `K k(I,const S,…)` and `K knk(I,…)` functions, useful for writing variadic utility functions that can forward the K objects.

:fontawesome-regular-hand-point-right:
comp.lang.c: [How can I write a function which takes a variable number of arguments and passes them to some other function (which takes a variable number of arguments)?](http://c-faq.com/varargs/handoff.html)


### `ver` – release date

Signature: `I ver()`

Returns an int as `yyyymmdd`.


### `xD` – create dictionary

Signature: `K xD(K x, K y)`<br>
Tags: `c.o` `own`

Create a dictionary from two K objects.

Takes ownership of references to the arguments.

If `y` is null, will `r0(x)` and return null.


### `xT` – table from dictionary

Signature: `K xT(K x)`<br>
Tags: `c.o` `ee` `own`

Create a table from a dictionary object.

Will `r0(x)` and return null if it is unable to form a valid table from `x`.

Takes ownership of a reference to its argument `x`.


### `ymd` – numbers to date

Signature: `I ymd(year, month, day)`<br>
Tags: `c.o`

Encode a year/month/day as a q date, e.g. `0==ymd(2000, 1, 1)`

:fontawesome-regular-hand-point-right:
[`dj` – date to number](#dj-date-to-number)

