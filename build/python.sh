#!/bin/bash
DEBVERSION=${1:-jessie}
PYVERSION=${2:-3.5.1}
TAG=${DEBVERSION:0:1}${PYVERSION//./}
TEMPDIR=$(mktemp -d -p packages/)
if docker run \
        -v $PWD/$TEMPDIR:/build \
        --tmpfs /tmp:rw,exec,size=1g \
        --name pythonbuild \
        altaurog/pybuild:$DEBVERSION $PYVERSION
then
    PYTHONDEB=$(basename $TEMPDIR/md-cpython_${PYVERSION}*.deb)
    M4="m4 -P -D debversion=$DEBVERSION -D pythondeb=$PYTHONDEB"
    $M4 python/Dockerfile.m4 > $TEMPDIR/Dockerfile
    docker build -t altaurog/python:$TAG $TEMPDIR
fi
docker run -v $PWD:/m --name m debian mv /m/$TEMPDIR/*.deb /m/packages
docker rm pythonbuild m
rm -rf $TEMPDIR
