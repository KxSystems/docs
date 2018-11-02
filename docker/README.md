The instructions below are for building your own Docker image. A prebuilt Docker image is available on Docker Cloud, if you only want to run the docs image to preview changes to code.kx.com then install Docker and [read the instructions on the main page](../CONTRIBUTING.md#docker) on how to do this.

## Preflight

You will need [Docker installed](https://www.docker.com/community-edition) on your workstation; make sure it is a recent version.

Check out a copy of the project with:

    git clone https://github.com/KxSystems/docs.git

## Building

To build the project locally, change directory to the top level of your cloned repo and run:

```bash
docker build -t mydocs -f docker/Dockerfile .
```
To build version 2 of the site (taking requirements from `docker/piprequirements-v2.txt` run:
```bash
docker build -t mydocs -f docker/Dockerfile --build-arg SITEVERSION=v2 .
```

Once built, you should have a local `mydocs` image, you can run the following to use it to preview the site:

```bash
docker run --rm -it -v $(pwd):/docs -p 9000:9000 -e PORT=9000 mydocs serve
```

and to build the static HTML site in the `site` folder:
```bash
docker run --rm -it -v $(pwd):/docs -p 9000:9000 -e PORT=9000 mydocs build
```



## Related Links

 * [Docker](https://docker.com)
     * [`Dockerfile`](https://docs.docker.com/engine/reference/builder/)
