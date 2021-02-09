---
title: Set up your machine-learning environment – Machine Learning – kdb+ and q documentation
description: How to set up an environment in which to work on Machine Learning within kdb+ and q
keywords: anaconda, conda, docker, embedpy, jupyter, ml, machine learning, python
---
# :fontawesome-solid-share-alt: Setting up your machine-learning environment



There are three methods available to set up an environment in which to work on Machine Learning within kdb+/q: 

-   with Anaconda
-   with Docker
-   do it yourself


## Download via Anaconda

The three KX packages can be downloaded from [anaconda.org/kx](https://anaconda.org/kx):

-   `kdb`
-   `embedpy`
-   `jupyterq`

These are available for Linux, Windows and macOS.

They are in a dependency tree. If you install `embedpy` it will automatically install `kdb`. If you install `jupyterq`  it will install `embedpy` and `kdb`.

The commands are as follows:

```bash
conda install -c kx kdb
conda install -c kx embedpy
conda install -c kx jupyterq
```

At present, the packages work only from the base environment.

Before starting q, run the following commands:

```anaconda
source deactivate base
source activate base
```

When you first run q it will ask the following questions:

```txt
Please provide your email (requires validation):
Please provide your name:
If applicable please provide your company name (press enter for none):
```

This will then contact the KX license server, which will generate a `kc.lic` and send an email confirmation link to validate it.



## Docker command

### 1. Install [Docker](https://docs.docker.com/install/)

### 2. Run embedPy

```bash
$ docker run -it --name myembedpy kxsys/embedpy
KDB+ 3.5 2017.11.08 Copyright (C) 1993-2017 Kx Systems
l64/ 4(16)core 7905MB kx 0123456789ab 172.17.0.2 EXPIRE 2018.12.04 bob@example.com KOD #0000000

q)
```

You can drop straight into Bash with:

```bash
$ docker run -it kxsys/embedpy bash
kx@b8279373a1d1:~$ conda info

     active environment : kx
    active env location : /home/kx/.conda/envs/kx
    ...

kx@b8279373a1d1:~$ q
KDB+ 3.5 2018.04.25 Copyright (C) 1993-2018 Kx Systems
l64/ 8()core 64304MB kx b8279373a1d1 172.17.0.3 EXPIRE 2019.05.21 bob@example.com KOD #0000000

q)
```

:fontawesome-brands-github:
[Instructions for running headless or with an existing license](https://github.com/KxSystems/embedPy/blob/master/docker/README.md#headlesspresets)

:fontawesome-brands-github:
[Build instructions for the embedPy image](https://github.com/KxSystems/embedPy/blob/master/docker/README.md#building)


### 3. Run JupyterQ

```bash
docker run --rm -it -p 8888:8888 kxsys/jupyterq
```

Now point your browser at `http://localhost:8888/notebooks/kdb%2BNotebooks.ipynb`.

:fontawesome-brands-github:
[Build instructions for the JupyterQ image](https://github.com/KxSystems/jupyterq/blob/master/docker/README.md)

Allows Jupyter notebooks to be used within a Docker container.


## Do it yourself

1.  Install [kdb+](../learn/install.md) 
2.  Install [embedPy](embedpy/index.md)
3.  Install [JupyterQ](jupyterq/index.md)
