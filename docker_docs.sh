#!/usr/bin/env bash
function usage(){
 printf "Usage:\n\tdocker_docs.sh {serve|build|shell} [OPTS]\n\n\t" >&2
 printf -- "-p PORT\n\t\tPort used for preview site, only used for serve option, the default is 9000\n\t" >&2
 printf -- "-v {v1|v2}\n\t\tVersion of the site to build, this will run the corresponding container, default is v1\n\t" >&2
 printf -- "-t {docker tag}\n\t\trun a specific version of the docker container, default is 'latest'\n" >&2
 }
case $1 in 
 serve) command=serve;;
 build) command=build;;
 shell) command=shell;;
 *) usage ; exit 1 ;;
esac
shift
PORT=9000
IMAGE=kxsys/docs-v1
TAG=latest
while getopts ":hp:v:t:" opt; do
  case ${opt} in
    h ) 
     usage ; exit 0 ;;
    p ) 
     PORT=$OPTARG ;;
    v ) 
     IMAGE=kxsys/docs-$OPTARG ;;
    t ) 
     TAG=$OPTARG ;;
    \? ) usage ; exit 1 ;;
  esac
done
IMAGE=${IMAGE}:${TAG}
DOCPATH="$( cd "$(dirname "$0")" ; pwd -P )"

case $command in
 serve) docker run --rm -it -v $DOCPATH:/docs -p $PORT:$PORT -e PORT=$PORT $IMAGE serve ;;
 build) docker run --rm     -v $DOCPATH:/docs                              $IMAGE build ;;
 shell) docker run --rm -it -v $DOCPATH:/docs                              $IMAGE shell ;;
 *) usage; exit 1 ;;
esac
