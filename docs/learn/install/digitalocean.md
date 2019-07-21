---
title: Installing kdb+ at DigitalOcean on Ubuntu
description: How to install kdb+ under Ubuntu at DigitalOcean
author: Stephen Taylor
keywords: digitalocean, install, kdb+, linux, q, ubuntu
---
# <i class="fab fa-digital-ocean"></i> Installing on Ubuntu at DigitalOcean



In this scenario you install kdb+ on a [DigitalOcean](https://digitalocean.com) ‘droplet’ (cloud server) running Ubuntu. 
Kdb+ tasks on the droplet will be able to offer services over the Net.

You access and control the droplet via SSH and Bash.

Your droplet is identified by an IP address.
For this tutorial we suppose you have listed the droplet’s IP address in your local hosts file as `droplet.dev`. 
(If not, in the following replace `droplet.dev` with the IP address.)

!!! info "Only commercial and 32-bit kdb+ are licensed for use on cloud servers. "

This tutorial supposes you 

-   run Bash on your local machine
-   install 32-bit kdb+ on a 32-bit Ubuntu droplet, e.g. `16.04.5 x32`
-   intend on the server to run one or more scripts, rather than interactive sessions

To run 32-bit kdb+ on a 64-bit server, see the [notes for running 32-bit kdb+ on 64-bit Linux](linux.md#64-bit-or-32-bit).


## <i class="fas fa-download"></i> Download

[Download 32-bit kdb+](https://kx.com/connect-with-us/download/) to your local machine and unzip it. 
You will want the `l32.zip` download. 

Change directory to the parent of the folder `q`.
Your unzipped files look like this: 

```txt
$ tree .
├── q
│   ├── l32
│   │   └── q
│   ├── q.k
$
```


## <i class="fas fa-upload"></i> Upload

Upload the kdb+ files to your droplet. 

Here we suppose you followed [recommended practice](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04) and created a non-root user with superuser privileges. 

We suppose you named this user `boss`, 
and that the kdb+ files will be stored at `/home/boss/q` and run by user `boss`.

```bash
$ scp -r . boss@droplet.dev:/home/boss/q
Enter passphrase for key '/Users/me/.ssh/id_rsa':
q.k                     100%   22KB 116.1KB/s   00:00
q                       100%  642KB 638.2KB/s   00:01
q.k                     100%   22KB  78.9KB/s   00:00
q
```


## <i class="fas fa-code"></i> Define q alias

SSH from your local machine to your droplet. 
Edit the Bash profile for non-login (i.e. non-interactive) sessions. 

```bash
$ ssh boss@droplet.dev
Enter passphrase for key '/Users/me/.ssh/id_rsa':
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.4.0-131-generic i686)
…
boss@droplet:~$ nano ~/.bashrc
```

Append the following line to the file.

```txt
alias q='QHOME=~/q ~/q/l32/q'
```

The Bash profile `.bashrc` sets the environment used for non-login sessions, for example, any script that you set up as a daemon under Systemctl. 


## <i class="fas fa-check"></i> Confirm successful installation

Run `.bashrc` now for your current (login) session.

```bash
boss@droplet:~$ source .bashrc
```

Confirm kdb+ runs.

```bash
boss@droplet:~$ q
KDB+ 3.6 2018.07.30 Copyright (C) 1993-2018 Kx Systems
l32/ 2()core 4041MB boss install-test 127.0.1.1 NONEXPIRE

q)til 6
0 1 2 3 4 5
q)\\
boss@droplet:~$
```


## <i class="fas fa-code"></i> Rlwrap

Interactive kdb+ sessions under Linux use Rlwrap to recall lines from the keyboard buffer. 
This is less useful for the non-interactive sessions you run on your droplet. 

Just as well, because it does not appear possible to install Rlwrap on these droplets.

```bash
boss@droplet:~$ rlwrap -r q
The program 'rlwrap' is currently not installed. You can install it by typing:
sudo apt install rlwrap
boss@droplet:~$ sudo apt install rlwrap
[sudo] password for boss:
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package rlwrap
boss@droplet:~$
```


## <i class="far fa-hand-point-right"></i> What’s next?

Set up a script to run as a service on your droplet:

[How To Use Systemctl to Manage Systemd Services and Units](https://cloudsupport.digitalocean.com/s/#none|ka21N000000Cp7aQAC)

