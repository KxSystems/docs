---
title: Set up your machine-learning environment
keywords: Docker, embedPy, Jupyter, ml, machine learning, Python
---

# <i class="fa fa-share-alt"></i> Set up your machine-learning environment

There are three ways to set up an environment in which to work on Machine Learning.


## Docker command

1.  Install [Docker](https://www.docker.com/community-edition) 
2.  Run:

```bash
$ docker run -it --name myembedpy kxsys/embedpy
KDB+ 3.5 2017.11.08 Copyright (C) 1993-2017 Kx Systems
l64/ 4(16)core 7905MB kx 0123456789ab 172.17.0.2 EXPIRE 2018.12.04 bob@example.com KOD #0000000

q)
```
You can drop straight into bash with:

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

Instructions for running headless or an existing q license are [available](https://github.com/KxSystems/embedPy/blob/master/docker/README.md#headlesspresets)

<i class="far fa-hand-point-right"></i> 
[Build instructions for the image](https://github.com/KxSystems/embedPy/blob/master/docker/README.md#building)


### Alternative setup with JupyterQ

Install Docker.

Run

```bash
docker run --rm -it -p 8888:8888 kxsys/jupyterq
```

Now point your browser at http://localhost:8888/notebooks/kdb%2BNotebooks.ipynb.

<i class="far fa-hand-point-right"></i> 
[Build instructions for the image](https://github.com/KxSystems/jupyterq/blob/master/docker/README.md)



## Download via Anaconda

The three Kx packages can be downloaded from [anaconda.org/kx](https://anaconda.org/kx):

-   `kdb`
-   `embedpy`
-   `jupyterq`

Currently available for Linux and macOS; soon to be available for Windows too.

They are in a dependency tree. If you install `embedpy` it will automatically install `kdb`. If you install `jupyterq`  it will install `embedpy` and `kdb`. 

The commands are as follows:

```bash
conda install -c kx kdb
conda install -c kx embedpy
conda install -c kx jupyterq
```

At present, the packages work only from the base environment.

Before starting q, please run the following commands:

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
This will then reach out to the Kx license server and generate a `kc.lic`.

This in turn sends an email confirmation link to validate the license file.


## Do it yourself

1.  Install [kdb+](../learn/install/index.md) 
2.  Install [embedPy](embedpy/)
3.  Install [JupyterQ](jupyterq/)
