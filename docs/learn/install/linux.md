---
title: Installing under Linux – Learn – kdb+ and q documentation
description: How to install kdb+ under Linux
author: Stephen Taylor
keywords: install, kdb+, linux, q
---
# <i class="fab fa-linux"></i> Installing under Linux



Open a Bash session (eg LXTerminal) in your home folder and `cd` to the folder where you downloaded your ZIP file. Unzip the archive. A new folder `q` will appear there. Copy it to your home folder and `cd` there.

```bash
$ cd ~/Downloads
~/Downloads$ unzip linux-x86.zip
Archive:  linux-x86.zip
  inflating: q/README.txt
  inflating: q/l32/q
  inflating: q/q.q
  inflating: q/q.k
  inflating: q/s.k
  inflating: q/trade.q
  inflating: q/sp.q
~/Downloads$ cp -r q ~/.
~/Downloads$ cd
$
```

<!-- ![cd ~/Downloads unzip linux-x86.zip cp -r q ~/. cd ~](img/install_linux_01.png "cd ~/Downloads unzip linux-x86.zip cp -r q ~/. cd ~") -->


## 64-bit or 32-bit?

Use the `uname` command to determine whether your machine is using the 32-bit or 64-bit Linux distribution.
```bash
$ uname -m
i686
```
<!-- ![Determining the distribution bit size](img/install_linux_02.png "Determining the distribution bit size") -->

If the result is `i686` or `i386` or similar, you are running a **32-bit** Linux distribution. If the result is `x86_64`, you are running a **64-bit** Linux distribution.

If you are installing 32-bit kdb+ on a 32-bit Linux distribution, proceed to [Launch (minimum install)](#minimum-install-and-launch).

But if you are installing 32-bit kdb+ on a 64-bit Linux distribution, you will need a 32-bit library. Use your usual package manager to install i686 or i386: for example:
```bash
sudo apt-get install libc6-i386
```

<i class="far fa-hand-point-right"></i> AskUbuntu: [How to run 32-bit app in Ubuntu 64-bit?](https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit)


## <i class="fas fa-rocket"></i> Minimum install and launch

Confirm that kdb+ runs. In your home folder, type `q/l32/q`
to see the kdb+ banner and the `q)` prompt. 
Type `til 6` to see the first six integers. Type `\\` to return to Linux.

```txt
$ q/l32/q
KDB+ 3.6 2018.07.30 Copyright (C) 1993-2018 Kx Systems
l32/ 2()core 4096MB sjt mark.local 192.168.0.17 NONEXPIRE

Welcome to kdb+ 32bit edition
For support please see https://groups.google.com/d/forum/personal-kdbplus
Tutorials can be found at http://code.kx.com/q/tutorials/install
To exit type \\
To remove this startup msg, edit q.q
q)til 6
0 1 2 3 4 5
q)\\
$
```
<!-- ![Launching q](img/install_linux_03.png "Launching q") -->

You have completed the minimum installation. We recommend continuing with _Complete install and launch_.


## Complete install and launch

The minimum installation can be improved in two important ways. We strongly recommend them.

* Call kdb+ within the `rlwrap` command, which will allow you to call back and edit previous lines
* Define `q` as a command alias, allowing you to invoke kdb+ without specifying the path to it


### <i class="fas fa-plug"></i> Install Rlwrap

<!-- Exit kdb+ to return to the Bash prompt and your home folder.  -->
Ask for Rlwrap’s version number. If you see one, Rlwrap is already installed

```bash
$ rlwrap -v
rlwrap 0.42
$
```

<!-- ![Exit q and see if Rlwrap is installed](img/install_linux_04.png "Exit q and see if Rlwrap is installed") -->

If Rlwrap is already installed you can go on to the next step.

Otherwise, you will be told `rlwrap: command not found`. Install Rlwrap using your package manager.


### <i class="fas fa-code"></i> Edit your profile

!!! info "Environment variables"

    The q interpreter refers to environment variable `QHOME` for the location of certain files. 
    Absent this variable, it will guess based on the path to the interpreter. 
    Better to set the variable explicitly. 

    If you run just one version of kdb+, it might suit you to define `QHOME` in your Bash profile and export it for use by non-console processes. 

    Otherwise set `QHOME` with each invocation of the interpreter, as shown below. 

    The `QLIC` environment variable tells kdb+ where to find [a license key file](../licensing.md). Absent the variable, the value of `QHOME` is used. 

In the File Manager, find `.bashrc` in your home folder.

![Bash profile](img/install_linux_05.png "Bash profile")

Open it with a text editor, append the following line

```bash
alias q='QHOME=~/q rlwrap -r ~/q/l32/q'
```
and save it. 
Start a new Bash session, or tell Bash to use the revised profile:

```bash
$ source .bashrc
```

<!-- ![source .bashrc](img/install_linux_06.png "source .bashrc") -->

!!! tip "Installing elsewhere"

    You can install kdb+ where you please. The environment variables `QHOME` (specified above) and `QLIC` tell kdb+ [where to find its files](../licensing.md). 


## <i class="fas fa-check"></i> Confirm successful installation

From your home folder, launch kdb+, type an expression and recall it using the up-arrow key. Exit kdb+.

```txt
$ q
KDB+ 3.6 2018.07.30 Copyright (C) 1993-2018 Kx Systems
l32/ 2()core 4096MB sjt mark.local 192.168.0.17 NONEXPIRE

Welcome to kdb+ 32bit edition
For support please see http://groups.google.com/d/forum/personal-kdbplus
Tutorials can be found at http://code.kx.com/q/tutorials/install
To exit type \\
To remove this startup msg, edit q.q
```
```q
q)til 6 / first 6 integers
0 1 2 3 4 5
q)til 6 / first 6 integers
0 1 2 3 4 5
q)\\
$
```


<!-- ![In q, type an expression and recall it with the up-arrow key](img/install_linux_07.png "In q, type an expression and recall it with the up-arrow key") -->


## <i class="fas fa-certificate"></i> Install a license key file

64-bit kdb+ requires a license key file.
[Obtain and install](../licensing.md) one.

You’re done. You have completely installed kdb+. 


## <i class="fas fa-code"></i> Installing multiple versions

For any version of q, 64-bit and 32-bit interpreter binaries share the same `q.k` file, located in `QHOME` for that version. 

All versions share the same `k4.lic` license-key file. 

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
└── v3.6
    ├── m64
    │   └── q
    └── q.k
```

In `.bash_profile` export `QLIC` and define aliases as in this example:

```bash
# versions of q
export QLIC=~/q
alias    q='export QHOME=~/q/v3.6; rlwrap -r $QHOME/m64/q'
alias q3.5='export QHOME=~/q/v3.5; rlwrap -r $QHOME/m64/q'
alias  q32='export QHOME=~/q/v3.5; rlwrap -r $QHOME/m32/q'
```

In a command shell:

```bash
$ q32
KDB+ 3.5 2019.05.15 Copyright (C) 1993-2019 Kx Systems
l32/ 4()core 8192MB sjt mint.local 192.168.0.10 EXPIRE 2020.04.01 stephen@kx.com #55032

q)\\
$
```

The 32-bit interpreter finds and reports the license-key file even though it will run without it. 

```bash
$ q
KDB+ 3.6 2019.03.07 Copyright (C) 1993-2019 Kx Systems
l64/ 4()core 8192MB sjt mint.local 192.168.0.10 EXPIRE 2020.04.01 stephen@kx.com #55032

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



## <i class="far fa-hand-point-right"></i> What’s next?

[Learn the q programming language](../index.md#learn-q), look through the [reference card](../../ref/index.md), or see in the [Knowledge Base](../../kb/index.md)  what you can do with kdb+.



