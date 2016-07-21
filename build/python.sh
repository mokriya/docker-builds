#!/bin/bash
. build/version
ls packages/$PYTHONDEB || exit 1
TEMPDIR=$(mktemp -d -p packages/)
ln packages/$PYTHONDEB $TEMPDIR/
M4="m4 -P -D debversion=$DEBVERSION -D pythondeb=$PYTHONDEB"

$M4 python/Dockerfile.m4 > $TEMPDIR/Dockerfile
docker build -t altaurog/python:$TAG $TEMPDIR

$M4 wheelbuild/Dockerfile.m4 > $TEMPDIR/Dockerfile
docker build -t altaurog/wheelbuild:$TAG $TEMPDIR

rm -rf $TEMPDIR
