#!/bin/bash
# title: Build MkDocs instance in KX Docker image for MkDocs for use from isolated filesystem
# required: Docker
# usage: ./local.sh

# sanity check
# ============
if [ ! -d docs ]; then
	echo '*** ERROR*** No docs folder found'
	exit 1
fi

localdir=local
tempdir=docs/local
site=https://code.kx.com

echo "### Copying resources from $site (stylesheets,images,javascript,etc)"
rm -rf $localdir $tempdir local.yml
mkdir $tempdir
wget -q -r -np -nH -P $tempdir $site/favicon.ico $site/img/ $site/scripts/ $site/stylesheets/

echo '### Deriving temporary config (converting mkdocs.yml to local.yml)'
rm -f local.yml

if [ $# -eq 0 ]; then
    cat mkdocs.yml | sed \
        -e 's#^INHERIT.*##' \
        -e 's#^site_url.*$#site_url: ""#' \
        -e 's#favicon: https://code.kx.com/#favicon: local/#' \
        -e 's#logo: https://code.kx.com/#logo: local/#' \
        -e 's#- https://code.kx.com/#- local/#' \
        -e 's#- scripts/qsearch\.js##' \
        > local.yml
    work_dir="/docs"
    docker_image="$(cat docker-image-name.txt):$(cat docker-image-version.txt)"
    cmd="build --clean -s -f local.yml --no-directory-urls --site-dir $localdir"
    echo "### Using docs in $localdir/ using docker image $docker_image"
    docker run --rm -v $(pwd):$work_dir --workdir $work_dir $docker_image $cmd
else
    cat mkdocs.yml | sed \
        -e 's#^INHERIT.*##' \
        -e 's#favicon: https://code.kx.com/#favicon: local/#' \
        -e 's#logo: https://code.kx.com/#logo: local/#' \
        -e 's#- https://code.kx.com/#- local/#' \
        -e 's#- scripts/qsearch\.js##' \
        > local.yml
    cmd="build --clean -s -f local.yml --site-dir $localdir"
    echo "### Building docs in $localdir/ using mkdocs"
    mkdocs $cmd
fi

retval=$?
if [ $retval -ne 0 ]; then
    echo "mkdocs build failed - check warnings above, fix and try again" >&2
    exit $retval
fi

if [ $# -ne 0 ]; then
    echo "### Zipping $localdir directory"
    if ! zip -qr local.zip $localdir; then
        echo "*** ERROR *** Failed to zip $localdir/"
        exit 1
    fi
fi
