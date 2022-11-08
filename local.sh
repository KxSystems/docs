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
user=$(whoami)
# map local to remote user
if [ $user == 'sjt' ]; then
	user='stephen'
fi

echo "### Copying resources from $site"
rm -f $tempdir local.yml
mkdir $tempdir
wget -r -np -nH -P $tempdir $site/favicon.ico $site/img/ $site/scripts/ $site/stylesheets/

echo '### Deriving temporary config'
rm -f local.yml
cat base-config.yml mkdocs.yml | sed \
	-e 's#^INHERIT.*##' \
	-e 's#^site_url.*$#site_url: ""#' \
	-e 's#favicon: https://code.kx.com/#favicon: local/#' \
	-e 's#logo: https://code.kx.com/#logo: local/#' \
	-e 's#- https://code.kx.com/#- local/#' \
	-e 's#- scripts/qsearch\.js##' \
	> local.yml

echo "### Building docs in $localdir/"
# DOCKER_IMAGE='registry.gitlab.com/kxdev/documentation/framework/mkdocs-build'
docker_image="$(cat docker-image-name.txt):$(cat docker-image-version.txt)"
work_dir="/docs"
mnt="type=bind,source=$(pwd),target=$work_dir"
cmd="build --clean -f local.yml --no-directory-urls --site-dir $localdir"

docker run --rm --mount $mnt --workdir $work_dir $docker_image $cmd

zip -r q.zip $localdir
if ( $? ); then
	echo "*** ERROR *** Failed to build $localdir/"
	exit 2
fi

echo "### Zipping $localdir"
zip -r local.zip $localdir
if ( $? ); then
	echo "*** ERROR *** Failed to zip $localdir/"
	exit 3
fi

echo "### Copying to $site"
scp local.zip $user@code.kx.com:/var/www/download/q.zip
if ( $? ); then
	echo '*** ERROR *** Failed to upload local.zip'
	exit 4
fi

echo '### Cleaning up'
rm -fr $tempdir $localdir local.yml local.zip
echo "### Static site built in $localdir/"

echo '### DONE: subsite zipped and uploaded'
