#!/bin/bash
. build/version
TEMPDIR=$(mktemp -d -p packages/)
BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        -v $PWD/$TEMPDIR:/build \
        --tmpfs /tmp:rw,exec,size=1g \
        --name $BUILDCONTAINER \
        altaurog/pybuild:$DEBVERSION $PKGNAME $PYVERSION $RELEASE
then
    docker run --rm -v $PWD:/m debian mv /m/$TEMPDIR/$PYTHONDEB /m/packages
fi
rm -rf $TEMPDIR
