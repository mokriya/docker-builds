#!/bin/bash
. build/version
TEMPDIR=$(mktemp -d -p packages/)
ARGS="`id -u`:`id -g` $PKGNAME $PYVERSION $RELEASE"
if docker run \
        --rm \
        -v $PWD/$TEMPDIR:/build \
        --tmpfs /tmp:rw,exec,size=1g \
        altaurog/pybuild:$DEBVERSION $ARGS
then
    mv $TEMPDIR/$PYTHONDEB packages
fi
rm -rf $TEMPDIR
