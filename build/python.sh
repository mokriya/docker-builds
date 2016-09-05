#!/bin/bash
. build/version
ls packages/$PYTHONDEB || exit 1
BUILD=/build

BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        --name $BUILDCONTAINER \
        -v $PWD/python:$BUILD \
        -v $PWD/packages/$PYTHONDEB:$BUILD/$PYTHONDEB \
        altaurog/debbase:$DEBVERSION $BUILD/install.sh $PYTHONDEB
then
    REPO=altaurog/python
    docker commit \
        -c "ENV PATH /venv/bin:/usr/local/bin:/usr/bin:/bin" \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        $BUILDCONTAINER $REPO:$TAG
    docker tag $(docker images -q $REPO:$TAG) $REPO:latest
fi

BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        --name $BUILDCONTAINER \
        -v $PWD/wheelbuild:$BUILD \
        altaurog/python:$TAG $BUILD/{install.sh,buildwheels.sh}
then
    REPO=altaurog/wheelbuild
    docker commit \
        -c 'ENV PATH /venv/bin:/usr/local/bin:/usr/bin:/bin' \
        -c 'ENTRYPOINT ["/venv/bin/buildwheels.sh"]' \
        -a 'Aryeh Leib Taurog <python@aryehleib.com>' \
        $BUILDCONTAINER $REPO:$TAG
    docker tag $(docker images -q $REPO:$TAG) $REPO:latest
fi
