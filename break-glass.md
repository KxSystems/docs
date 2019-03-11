# In emergency, break glass

How to update code.kx.com with the contents of this repo. 



## Get server access

You will need SSH access to the code.kx.com server. 
(Consult the Chief Technical Officer.) 

## Install MkDocs

Follow instructions at [mkdocs.org](https://mkdocs.org/). This may entail installing Python and `pip`. 


## Install Material for MkDocs

Follow instructions at [squidfunk.github.io/mkdocs-material/](http://squidfunk.github.io/mkdocs-material/)


## Install the PyMdown Extensions

Follow instructions at [facelessuser.github.io/pymdown-extensions/](http://facelessuser.github.io/pymdown-extensions/)


## Clone this repo

Standard GitHub procedures – whichever of them work for you 


## Initialise the repo

As a MkDocs project

## Run MkDocs

Bringing the site to life on your local machine (follow MkDocs instructions) 


## Edit the source

Edit MDs and mkdocs.yml; and manage assets such as PDFs and PNGs


## Build the site

For export: `mkdocs build --clean`


## Push to server

In my home folder `/home/stephen`on the server:
```bash
$ sudo cp -r /var/www/q .
$ sudo chmod -R stephen:stephen q
```
On my local machine:
```bash
$ rsync -ruv --delete site/ stephen@code.kx.com:/home/stephen/q/
```
On the server:
```bash
$ sudo chmod -R www-data:www-data q
$ sudo mv /var/www/q archive/q0 && sudo mv q /var/www
```
In my home folder I keep in folder `archive` the last several versions of `/var/www/q`. In the example above the previous version is saved as `q0` – substitute your own naming scheme. 


## Push source to GitHub

```bash
$ git commit -am "what this change was about"
$ git push origin master
```

The procedure can be adapted for updating code.kx.com/q4m3. The source for this is not on GitHub but in a private repository shared with the author, Jeffry Borror. 