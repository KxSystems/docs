---
title: Server calling client
description: Demonstrates how to simulate a C client handling a get call from a kdb+ server. The Java interface allows the programmer to emulate a kdb+ server. The C interface does not provide a means to respond to a sync call from the server but async responses (message type 0) can be sent using k(-c,...).
keywords: client, kdb+, q, server
---
# Server calling client



This demonstrates how to _simulate_ a C client handling a _get_ call from a kdb+ server. The [Java interface](../interfaces/java-client-for-q.md) allows the programmer to emulate a kdb+ server. The C interface does not provide a means to respond to a sync call from the server but async responses ([message type 0](../basics/ipc.md)) can be sent using `k(-c,...)`.

A _get_ call may be desirable when client functions need to be called by the server – as though the client were an [extension](../interfaces/using-c-functions.md#portable-example). This q code shows how a listening kdb+ server can call a kdb+ client (with handle `h`) using async messaging only:

```q
q)f:{neg[h]({neg[.z.w]value x};x);h[]} 
q)f"1+1"
2
```

Generally, async _set_ messages to the client are preferable because the server has many clients and does not want to be blocked by a slow response from any one client. One application of simulated get from the server is where an extension might have been the solution to a problem, but an out-of-process solution was preferred because:

-   only 32-bit or 64-bit libraries were available
-   unreliable external code may stomp on kdb+
-   licencing issues
-   system calls in external code conflict with kdb+


## Essential example

These programs work when the kdb+ server has only has one client, `sc` in the example below.

`sc.c` defines two functions, `home` and `palindrome` that may be called by the server. 

When the server is run as `q sc.q -p 5001` and then `sc` is run, `sc` will connect to `` `::5001 ``.

In q, [`.z.po`](../ref/dotz.md#zpo-open) is called when `sc` connects. `.z.po` then saves the socket `h` and calls ``GET` `` to find the list of functions the client provides.

`fs` is called to eval a new function definition for `home` and `palindrome`. Then in q:

```bash
$ q sc.q -p 5001
```

```q
q)home`
"/home/jack"
q)palindrome home`
"/home/jackkcaj/emoh/"
```

Here is what `sc.q` defined when it received the list of functions from the client:

```q
q)home
{GET[(`home;0;x)]}
q)palindrome
{GET[(`palindrome;1;x)]}
```

### sc.q

```q
GET:{(neg h)x;x:h[];x[1]}
S:string
fs:{{eval parse s,":{GET[(`",(s:S x[0]y),";",(S y),";",(";"sv S x[1;y]#"xyz"),")]}"}[x]each til count x}
.z.po:{h::x;fs GET`}
```


### sc.c

```c
//sc.c  server calls client with simulated GET.   gcc sc.c -o sc -DKXVER=3 -pthread l64/c.o
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"k.h"
#define A(x)     if(!(x))O("A(%s)@%d\n",#x,__LINE__),exit(*(S)0);  //assert - simplistic error handling

Z K1(home){S s=getenv("HOME");x=ktn(KC,strlen(s));DO(xn,xC[i]=s[i])R x;}
Z K1(palindrome){A(xt==KC);C c,*d;K k=ktn(KC,xn*2);DO(xn,kC(k)[i]=xC[i]);DO(xn,kC(k)[xn+i]=xC[xn-1-i]);R k;}
ZK(*f[])()={home,palindrome,0};ZS n[]={"home","palindrome",0};ZJ a[]={1,1};//exported functions and their arity

Z K1(call)//remote sends atom or (`palindrome;0;x) or (`home;1;)
{K1(d){K k=ktn(KS,0),v=ktn(KJ,0);J i=0;while(f[i])js(&k,ss(n[i])),ja(&v,a+i),i++;R knk(2,k,v);}
 P(0>xt,d(0));A(xt==0);A(xn>1);A(xx->t==-KS);R f[xy->j](xK[2]);
}
ZI sel(I c,F t)
{A(2<c);I r;fd_set f,*p=&f;FD_ZERO(p);FD_SET(c,p);long s=t,v[]={s,1e6*(t-s)};
 A(-1<(r=select(c+1,p,(V*)0,(V*)0,(V*)v)));P(r&&FD_ISSET(c,&f),c)R 0;
}
ZK sr(I c){I t;K x;A(x=k(c,(S)0));R k(-c,"",call(x),(K)0);} //async from q
I main(I n,S*v){I c=khp("",5001);while(1)if(c==sel(c,1e-2))A(sr(c));}
```


## A TUI

Consider a C client `u` that is nothing but a 
[TUI](http://en.wikipedia.org/wiki/Text-based_user_interface). 
It exposes 
[ncurses](https://en.wikipedia.org/wiki/Ncurses) 
functionality for a kdb+ listener. For fun, 
[Conway’s game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
will play out on `u` – all drawn by a 
[q program](http://thesweeheng.wordpress.com/2009/02/10/game-of-life-in-one-line-of-q/).

```bash
$ cat t.c
#include<curses.h>
#include"k.h"

TODO...
```

<i class="far fa-hand-point-right"></i> 
[Interprocess communication](ipc.md)  
Basics: [IPC protocol](../basics/ipc.md)

