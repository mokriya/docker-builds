#!/bin/bash
. build/version
INFOVERSION=$(python info/setup.py --version)
if docker run \
        -v $PWD/info:/build \
        --name infodist \
        altaurog/python:$TAG \
        pip install /build
then
    docker commit \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        infodist altaurog/dockerinfo:$INFOVERSION
    docker commit \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        infodist altaurog/dockerinfo:latest
    docker rm infodist
fi
