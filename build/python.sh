#!/bin/bash
. build/version
ls packages/$PYTHONDEB || exit 1
TEMPDIR=$(mktemp -d -p packages/)
CONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
docker run -v $PWD:/m --name $CONTAINER debian ln /m/packages/$PYTHONDEB /m/$TEMPDIR/
M4="m4 -P -D debversion=$DEBVERSION -D pythondeb=$PYTHONDEB"
$M4 python/Dockerfile.m4 > $TEMPDIR/Dockerfile
docker build -t altaurog/python:$TAG $TEMPDIR
docker rm $CONTAINER
rm -rf $TEMPDIR
