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
    MVCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
    docker run -v $PWD:/m --name $MVCONTAINER debian mv /m/$TEMPDIR/$PYTHONDEB /m/packages
fi
docker rm $CONTAINER $MVCONTAINER
rm -rf $TEMPDIR
