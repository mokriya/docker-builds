#!/bin/bash
. build/version
TEMPDIR=$(mktemp -d -p packages/)
BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
ARGS="`id -u`:`id -g` $PKGNAME $PYVERSION $RELEASE"
if docker run \
        -v $PWD/$TEMPDIR:/build \
        --tmpfs /tmp:rw,exec,size=1g \
        --name $BUILDCONTAINER \
        altaurog/pybuild:$DEBVERSION $ARGS
then
    mv $TEMPDIR/$PYTHONDEB packages
fi
rm -rf $TEMPDIR
