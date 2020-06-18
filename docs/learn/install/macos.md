---
title: Installing under macOS – Learn – kdb+ and q documentation
description: How to install kdb+ under macOS
author: Stephen Taylor
keywords: install, kdb+, macos, q
---
# :fontawesome-brands-apple: Installing under macOS




After downloading, if necessary, unzip the archive. A new folder `q` will appear in your `Downloads` folder.

Next perform the _Minimum install and launch_. We then strongly recommend continuing to [Complete install and launch](#complete-install-and-launch).

!!! warning "macOS Catalina (10.15) ended macOS support for 32-bit applications."


## :fontawesome-solid-rocket: Minimum install and launch

### Step 1. Copy the download

Open the Terminal application and enter the following commands:

```bash
$ cd ~/Downloads
$ cp -r q ~/.
```

### Step 2. Install a license key file

64-bit kdb+ requires a license key file.
[Obtain and install](../licensing.md) one.


### Step 3. Launch a q session

```bash
$ cd ~
$ q/m64/q
```

### Step 4. Catalina security

MacOS Catalina (10.15) introduced tighter security rules. 
At this point it may display a warning that it does not recognize the software.

??? detail "Warning dialog from macOS Catalina"
    ![Catalina warning](img/catalina-warning.png)

    These articles explain how to deal with the tighter security rules.

    :fontawesome-solid-globe:
    [Can’t launch your apps on macOS Catalina? Here’s the fix](https://www.cultofmac.com/672576/cant-launch-your-apps-on-macos-catalina-heres-the-fix/)
    <br>
    :fontawesome-solid-globe:
    [How to open apps from unidentified developers on Mac in macOS Catalina](https://www.imore.com/how-open-apps-anywhere-macos-catalina-and-mojave)


### Step 5. Confirm q installed

In your q session

```q
q)til 6 / first 6 integers
0 1 2 3 4 5
```

You have installed and launched kdb+.

### Step 6. Exit from q

```q
q)\\
$
```

## :fontawesome-solid-code: Complete install and launch

The minimum installation can be improved in two important ways. We strongly recommend them.

-   Call kdb+ within the `rlwrap` command, which will allow you to call back and edit previous lines
-   Define `q` as a command alias, allowing you to invoke kdb+ without specifying the path to it


### Step 7. Install Rlwrap

Exit kdb+ to return to the command prompt and your home folder. Ask for Rlwrap’s version number. If you see one, Rlwrap is already installed.

```bash
q)\\
$ rlwrap -v
rlwrap 0.42
$
```

If Rlwrap is already installed you can go on to the next step.

Otherwise, you will see `rlwrap: command not found`. Install Rlwrap using your package manager. (Probably either [MacPorts](https://www.macports.org/install.php) or [Homebrew](https://brew.sh/))


### Step 8. Edit your profile

!!! info "Environment variables"

    The q interpreter refers to environment variable `QHOME` for the location of certain files. 
    Absent this variable, it will guess based on the path to the interpreter. 
    Better to set the variable explicitly. 

    If you run just one version of kdb+, it might suit you to define `QHOME` in your Bash profile and export it for use by non-console processes. 

    Otherwise set `QHOME` with each invocation of the interpreter, as shown below. 

    The `QLIC` environment variable tells kdb+ where to find [a license key file](../licensing.md). Absent the variable, the value of `QHOME` is used. 

In Terminal (Bash), open your profile `~/.bash_profile` with TextEdit, Sublime Text or your favourite text editor

```bash
$ open -a "Sublime Text" .bash_profile
```

append the following line

```bash
alias q='QHOME=~/q rlwrap -r ~/q/m64/q'
```

and save it. Start a new Terminal session, or tell Bash to use the revised profile:

```bash
$ source .bash_profile
```

!!! tip "Installing elsewhere"

    You can install kdb+ where you please. The environment variables `QHOME` (specified above) and `QLIC` tell kdb+ [where to find its files](../licensing.md). 


### Step 9. Confirm successful installation

From your home folder, launch kdb+, type an expression and recall it using the up-arrow key:

```txt
$ q
KDB+ 4.0 2020.06.01 Copyright (C) 1993-2020 Kx Systems
m64/ 8()core 16384MB sjt max.local 127.0.0.1 EXPIRE 2020.08.01…
```
```q
q)til 6 / first 6 integers
0 1 2 3 4 5
q)til 6 / first 6 integers
0 1 2 3 4 5
q)\\
$
```

You’re done. You have completely installed kdb+. 


## :fontawesome-solid-code: Installing multiple versions

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
└── v4.0
    ├── m64
    │   └── q
    └── q.k
```

In `.bash_profile` export `QLIC` and define aliases as in this example:

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



## :fontawesome-regular-hand-point-right: What’s next?

[Learn the q programming language](../index.md#learn-q), look through the [reference card](../../ref/index.md), or see in the [Knowledge Base](../../kb/index.md)  what you can do with kdb+.



