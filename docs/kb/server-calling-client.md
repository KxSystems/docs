---
title: Server calling client – Knowledge Base – kdb+ and q documentation
description: Demonstrates how to simulate a C client handling a get call from a kdb+ server. The Java interface allows the programmer to emulate a kdb+ server. The C interface does not provide a means to respond to a sync call from the server but async responses (message type 0) can be sent using k(-c,...).
keywords: client, kdb+, q, server
---
# Server calling client


This demonstrates how to _simulate_ a [C client](../interfaces/c-client-for-q.md) handling a _get_ call from a kdb+ server. 

The [Java interface](https://github.com/KxSystems/javakdb) allows the programmer to emulate a kdb+ server. The C interface does not provide a means to respond to a sync call from the server but async responses ([message type 0](../basics/ipc.md)) can be sent using [`k(-c,...)`](../interfaces/capiref.md#k-evaluate).

A _get_ call may be desirable when client functions need to be called by the server – as though the client were an [extension](../interfaces/using-c-functions.md#portable-example). This q code shows how a listening kdb+ server can call a kdb+ client (with handle `h`) using async messaging only:

```q
q)f:{neg[h]({neg[.z.w]value x};x);h[]} 
q)f"1+1"
2
```

Generally, async _set_ messages to the client are preferable because the server has many clients and does not want to be blocked by a slow response from any one client. One application of simulated get from the server is where an extension might have been the solution to a problem, but an out-of-process solution was preferred because:

-   only 32-bit or 64-bit libraries were available
-   unreliable external code may stomp on kdb+
-   licensing issues
-   system calls in external code conflict with kdb+


## Example

This example shows a kdb+ server operating with a single client.

The client defines a range of C functions, which are registered with the kdb+ instance and can then be susequently called remotely using the q language.

### Code

#### sc.q

Script for kdb+ server instance

```q
GET:{(neg h)x;x:h[];x[1]}
S:string
fs:{{eval parse s,":{GET[(`",(s:S x[0]y),";",(S y),";",(";"sv S x[1;y]#"xyz"),")]}"}[x]each til count x}
.z.po:{h::x;fs GET`}
```

#### sc.c

C code for building client application

```c
//sc.c  server calls client with simulated GET.
// linux build instructions gcc sc.c -o sc -DKXVER=3 -lrt -pthread l64/c.o
// macOS build instructions gcc sc.c -o sc -DKXVER=3 -pthread m64/c.o
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/select.h>
#include"k.h"
#define A(x)     if(!(x))printf("A(%s)@%d\n",#x,__LINE__),exit(0);  //assert - simplistic error handling

static K home(K x){
    char* s;
    printf("%s function called\n",__FUNCTION__);
    s=getenv("HOME");
    x=ktn(KC,strlen(s));
    DO(xn,xC[i]=s[i])
    return x;
}
static K palindrome(K x){
    char c,*d;
    printf("%s function called\n",__FUNCTION__);
    A(xt==KC);
    K k=ktn(KC,xn*2);
    DO(xn,kC(k)[i]=xC[i]);
    DO(xn,kC(k)[xn+i]=xC[xn-1-i]);
    return k;
}
//exported functions and their arity
static K(*f[])()={home,palindrome,0};
static char* n[]={"home","palindrome",0};
static long long a[]={1,1};

static K d(K x){
    K k=ktn(KS,0),v=ktn(KJ,0);
    long long i=0;
    while(f[i])
        js(&k,ss(n[i])),ja(&v,a+i),i++;
    return knk(2,k,v);
}
//remote sends atom or (`palindrome;0;x) or (`home;1;)
static K call(K x){
    P(0>xt,d(0));
    A(xt==0);
    A(xn>1);
    A(xx->t==-KS);
    return f[xy->j](xK[2]);
}
static I sel(int c,double t){
    A(2<c);
    int r;
    fd_set f,*p=&f;
    FD_ZERO(p);
    FD_SET(c,p);
    long s=t,v[]={s,1e6*(t-s)};
    A(-1<(r=select(c+1,p,(V*)0,(V*)0,(V*)v)));
    P(r&&FD_ISSET(c,&f),c)
    return 0;
}
static K sr(int c){
    int t;
    K x;
    A(x=k(c,(S)0));
    return k(-c,"",call(x),(K)0);
} //async from q
int main(int n,char**v){
    int c=khp("",5001);
    while(1)
        if(c==sel(c,1e-2))
            A(sr(c));
}
```

### Running Example

Run kdb+, listening on port 5001 using the sc.q script:
```bash
q sc.q -p 5001
``` 
on another terminal run `sc` to connect to the kdb+ instance.

In q, [`.z.po`](../ref/dotz.md#zpo-open) is called when `sc` connects. `.z.po` then saves the socket `h` and calls ``GET` `` to find the list of functions the client provides.

`fs` is called to eval a new function definition for `home` and `palindrome`. Then in q you can view the registered functions after sc connects:

Here is what `sc.q` defined when it received the list of functions from the client:

```q
q)home
{GET[(`home;0;x)]}
q)palindrome
{GET[(`palindrome;1;x)]}
```

then in q, you can call these functions and see that the client C program `sc` executes its C functions & returns a result to kdb+

```q
q)home[]
"/home/jack"
q)palindrome home[]
"/home/jackkcaj/emoh/"
```


## Other uses

Consider a C client that is nothing but a 
[TUI](https://en.wikipedia.org/wiki/Text-based_user_interface). 
It exposes 
[ncurses](https://en.wikipedia.org/wiki/Ncurses) 
functionality for a kdb+ listener. For fun, 
[Conway’s game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
will play out on the client application – all drawn by a 
[q program](https://thesweeheng.wordpress.com/2009/02/10/game-of-life-in-one-line-of-q/).

:fontawesome-regular-hand-point-right: 
Basics: [Interprocess communication](../basics/ipc.md)

