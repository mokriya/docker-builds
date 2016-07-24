#!/bin/bash
. build/version
ls packages/$PYTHONDEB || exit 1
BUILD=/build

BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        --name $BUILDCONTAINER \
        -v $PWD/packages/$PYTHONDEB:$BUILD/$PYTHONDEB \
        -v $PWD/python/install.sh:$BUILD/install.sh \
        altaurog/debbase:$DEBVERSION $BUILD/install.sh $BUILD/$PYTHONDEB
then
    docker commit \
        -c "ENV PATH /venv/bin:/usr/local/bin:/usr/bin:/bin" \
        -a "Aryeh Leib Taurog <python@aryehleib.com>" \
        $BUILDCONTAINER altaurog/python:$TAG
fi

BUILDCONTAINER=$(</dev/urandom tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
if docker run \
        --name $BUILDCONTAINER \
        -v $PWD/wheelbuild:$BUILD \
        altaurog/python:$TAG $BUILD/{install.sh,buildwheels.sh}
then
    docker commit \
        -c 'ENV PATH /venv/bin:/usr/local/bin:/usr/bin:/bin' \
        -c 'ENTRYPOINT ["/venv/bin/buildwheels.sh"]' \
        -a 'Aryeh Leib Taurog <python@aryehleib.com>' \
        $BUILDCONTAINER altaurog/wheelbuild:$TAG
fi
