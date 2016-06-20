#!/bin/bash
# Start with something really simple
# Limitations:
#
# * Doesn't address building native extensions,
#   which would have to be done in the buildpython 
#   container first.  (Blog post describing such an
#   approach using python wheels:
#   https://glyph.twistedmatrix.com/2015/03/docker-deploy-double-dutch.html
#
# * Deps should be installed from a requirements.txt,
#   which is used to specify precise version numbers
#   for builds.  setup.py should give more lenient 
#   ranges (i.e. they are maintained separately).
#
# * Doesn't separate the app from the dependencies,
#   so deps will have to be re-installed with each build.
#   Deps should be (built then) installed to an appbase
#   image so the app image can be built quickly from that
#   without reinstalling deps.
#
# * Ideally building appbase should leverage caching as 
#   well so updated dependency lists can be deployed 
#   efficiently:
#   http://stackoverflow.com/a/25307587/519015
#   https://jpetazzo.github.io/2013/12/01/docker-python-pip-requirements/
#   https://pip.pypa.io/en/stable/user_guide/
#   http://doc.devpi.net/latest/
#
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
        -a 'Aryeh Leib Taurog <python@aryehleib.com>' \
        --change 'ENTRYPOINT ["dinfo"]' \
        $CONTAINER altaurog/dockerinfo:$INFOVERSION
    docker commit \
        -a 'Aryeh Leib Taurog <python@aryehleib.com>' \
        --change 'ENTRYPOINT ["dinfo"]' \
        $CONTAINER altaurog/dockerinfo:latest
    docker rm $CONTAINER
fi
