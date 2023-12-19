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

echo "### Copying resources from $site"
rm -rf $localdir $tempdir local.yml
mkdir $tempdir
wget -q -r -np -nH -P $tempdir $site/favicon.ico $site/img/ $site/scripts/ $site/stylesheets/

echo '### Deriving temporary config'
rm -f local.yml
cat mkdocs.yml | sed \
	-e 's#^INHERIT.*##' \
	-e 's#^site_url.*$#site_url: ""#' \
	-e 's#favicon: https://code.kx.com/#favicon: local/#' \
	-e 's#logo: https://code.kx.com/#logo: local/#' \
	-e 's#- https://code.kx.com/#- local/#' \
	-e 's#- scripts/qsearch\.js##' \
	> local.yml

echo "### Building docs in $localdir/"
docker_image="$(cat docker-image-name.txt):$(cat docker-image-version.txt)"
work_dir="/docs"
cmd="build --clean -f local.yml --no-directory-urls --site-dir $localdir"
docker run --rm -v $(pwd):$work_dir --workdir $work_dir $docker_image $cmd

echo "### Zipping $localdir"
if ! zip -qr local.zip $localdir; then
    echo "*** ERROR *** Failed to zip $localdir/"
    exit 1
fi

