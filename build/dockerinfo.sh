#!/bin/bash
. build/version
INFOVERSION=$(python info/setup.py --version)
CONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        -v $PWD/info:/build \
        --name $CONTAINER \
        altaurog/python:$TAG \
        pip install /build
then
    docker commit \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        $CONTAINER altaurog/dockerinfo:$INFOVERSION
    docker commit \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        $CONTAINER altaurog/dockerinfo:latest
    docker rm $CONTAINER
fi
