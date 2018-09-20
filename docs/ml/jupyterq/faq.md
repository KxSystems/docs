---
hero: <i class="fa fa-share-alt"></i> Machine learning / Jupyterq
title: JupyterQ FAQ - code.kx.com
description: JupyterQ frequently-asked questions
keywords: anaconda, docker, jupyter, jupyterhub, jupyterq, kdb+, kernel, learning, machine, notebook, python, q, script
---

# Frequently-asked questions


## Can I run the kernel remotely?

Yes, see the Jupyter documentation [here](http://jupyter-notebook.readthedocs.io/en/stable/public_server.html). If you are looking to set up a notebook server for multiple users Jupyter recommends [JupyterHub](http://jupyterhub.readthedocs.io/en/latest/index.html)


### Additional setup for JupyterQ under JupyterHub

If you see this error when running the Jupyter console on the server you're installing on:

```txt
You may need to set LD_LIBRARY_PATH/DYLD_LIBRARY_PATH to your 
python distribution's library directory: $HOME/anaconda3/lib
```

You will need to export the `LD_LIBRARY_PATH` and add this to your configuration file for JupyterHub 

```python
c.Spawner.env_keep.append('LD_LIBRARY_PATH')
```


## Why is setting `LD_LIBRARY_PATH/DYLD_LIBRARY_PATH` required with Anaconda python?

Anaconda packages libraries which may conflict with the system versions of these libraries loaded by q at startup e.g. `libssl` or `libz`. There is a `conda` packaged version of `q` which doesn't require setting `LD_LIBRARY_PATH`, if you are already using Anaconda then you can install it with

```bash
conda install -c kx kdb
```


## How can I save the contents of a notebook to a q script?

To dump the entire contents of the code cells in a notebook to a q script use
_File > Download as > Q (.q)_.

![save q script](img/save_qscript.png)
 
To save the contents of individual cells as q scripts use `/%savescript` in a cell.

<i class="far fa-hand-point-right"></i> 
[Loading and saving scripts](load-save.md)

<!-- 
FIXME
==Generating reports use case==
 -->


## Can I mix Python and q code in the same notebook? 

Yes, either with `p)` or `/%python`.

<i class="far fa-hand-point-right"></i> 
[Examples](inline-display.md)


## Is there a Docker image available?

Yes, if you have [Docker](https://www.docker.com/community-edition) installed, you can run:

```bash
docker run -it --rm -p 8888:8888 kxsys/jupyterq
```

Further instructions for running headless and building the image are [available](https://github.com/KxSystems/jupyterq/blob/master/README.md#docker)

!!! note "Always Linux"

    Even if you are running Docker on macOS or Windows the version of kdb+ is 64-bit Linux, and the Docker image is Linux.



