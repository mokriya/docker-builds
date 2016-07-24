#!/bin/bash
REQUIREMENTS=$1
WHEELDIR=$2
exec /venv/bin/pip wheel \
    -r $REQUIREMENTS \
    --wheel-dir $WHEELDIR \
    --find-links $WHEELDIR
