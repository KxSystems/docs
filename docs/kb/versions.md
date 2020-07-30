---
title: Installing multiple versions of kdb+ | Learn | kdb+ and q documentation
description: How to install and run multiple versions kdb+
author: Stephen Taylor
date: June 2020
---
# :fontawesome-regular-clock: Installing multiple versions of kdb+



For any version of q, the 64-bit and 32-bit interpreter binaries share the same `q.k` file, located in `QHOME` for that version. 

All versions share the same `k4.lic` or `kc.lic` license-key file. 

Arrange your files as in this example:

```txt
$ tree q
q
├── k4.lic
├── phrases.q
├── sp.q
├── trade.q
├── v3.5
│   ├── m32
│   │   └── q
│   ├── m64
│   │   └── q
│   └── q.k
└── v4.0
    ├── m64
    │   └── q
    └── q.k
```

In your profile export `QLIC` and define aliases as in this example:

```bash
# versions of q
export QLIC=~/q
alias    q='export QHOME=~/q/v4.0; rlwrap -r $QHOME/m64/q'
alias q3.5='export QHOME=~/q/v3.5; rlwrap -r $QHOME/m64/q'
alias  q32='export QHOME=~/q/v3.5; rlwrap -r $QHOME/m32/q'
```

In a command shell:

```bash
$ q3.5
KDB+ 3.5 2019.05.15 Copyright (C) 1993-2019 Kx Systems
m64/ 8()core 16384MB sjt max.local 127.0.0.1 EXPIRE 2020.08.01…

q)\\
$
```

The 32-bit interpreter finds and reports the license-key file even though it will run without it. 

```bash
$ q32
KDB+ 3.6 2019.03.07 Copyright (C) 1993-2019 Kx Systems
m32/ 8()core 16384MB sjt max.local 192.168.0.10 EXPIRE 2020.08.01…

q)\pwd
"/Users/sjt"
q)\echo $QLIC
"/Users/sjt/q"
q)\echo $QHOME
"/Users/sjt/q/v3.6"
q)\l ../sp.q
+`p`city!(`p$`p1`p2`p3`p4`p5`p6`p1`p2;`london`london`london`london`london`lon..
(`s#+(,`color)!,`s#`blue`green`red)!+(,`qty)!,900 1000 1200
+`s`p`qty!(`s$`s1`s1`s1`s2`s3`s4;`p$`p1`p4`p6`p2`p2`p4;300 200 100 400 200 300)
q)
```

Loading `sp.q`, a sibling of `QHOME`, requires the relative path specified. 


:fontawesome-solid-graduation-cap:
[Installing kdb+](../learn/install.md)