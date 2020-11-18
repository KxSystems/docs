In emergency, break glass
=========================



How to update code.kx.com with the contents of this repo. 



## Get server access

You will need SSH access to the code.kx.com server, and `sudo` privileges. 
(Consult the Chief Technical Officer.) 

Below, for illustration, your user name on the server is `mruser`.


## Install MkDocs and run locally

Follow [local installation instructions](CONTRIBUTING/install.md).

Requires Python and `pip`. 


## Edit the source

Edit MDs and `mkdocs.yml`; manage assets such as PDFs and PNGs.


## Build the site

For export: `mkdocs build --clean`


## Push to server

On your local machine:

```bash
#!/usr/bin/env bash
OUT=site;
SRVR=code.kx.com;
USR=mruser;
mkdocs build --clean;
rsync -rv --delete $OUT/ $USR@$SRVR:/home/$USR/q;
```

```bash
$ rsync -ruv --delete site/ mruser@code.kx.com:/home/mruser/q/
```

Your home folder on the server needs folders `q` and `archive`.


### Publish on server

Script `post.q`:

```bash
#!/usr/bin/env bash
# Title: Push q content from staging area at /home/stephen/q to web root
#        and update site map and search index table
# Author: stephen@kx.com
# Date: 2020.05.07
# Note: Needs root privilege
# Usage: sudo ./post-q
rm -r archive/q;
TGT=/var/www/q;
cp -r $TGT archive;
rsync -r --delete q/ $TGT;
```


### Roll back on server

The previous version of the site is saved in `~/archive/q` in case a fast roll-back is needed.

```bash
sudo cp -r ~/archive/q/ /var/www/q
```


The above procedure can be adapted for updating code.kx.com/q4m3. The source for this is not on GitHub but in a private repository shared with the author, Jeffry Borror. 