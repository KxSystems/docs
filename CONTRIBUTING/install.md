
Install and run a local copy of the site
========================================


Install MkDocs 
--------------


Install the [MkDocs](http://mkdocs.org) package using your packaging tool of choice.
(Requires Python and `pip`.)

```bash
brew install mkdocs     # macOS
sudo apt install mkdocs # Ubuntu
sudo yum install mkdocs # CentOS/RHEL
```

Other packages and fonts required:

```bash
pip install mkdocs-material          # http://squidfunk.github.io/mkdocs-material/
pip install pymdown-extensions       # http://facelessuser.github.io/pymdown-extensions/
pip install fontawesome_markdown
```


Clone this repo
---------------

Standard GitHub procedures – whatever works for you.


Run MkDocs
----------

In the parent folder of `mkdocs.yml`:

```bash
mkdocs serve --dirtyreload
```

This starts a web server on your local machine, where you can see the entire website – with hot-reload when you save a change.

The site is served from the address specified in configuration file `mkdocs.yml`. The MkDocs default is `localhost:8000`, but the code.kx.com configuration file sets it:

```yaml
dev_addr: '0.0.0.0:9000'
```

The `--dirtyreload` option limits rebuilds to the changed page, which means  changes to `mkdocs.yml` are not reflected. 

If you change `mkdocs.yml`, stop and restart `mkdocs serve --dirtyreload`.

