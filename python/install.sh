#!/bin/bash
PYTHONDEB=$1
BUILDDIR=$(dirname "$(readlink -f "$0")")
dpkg -i $BUILDDIR/$PYTHONDEB
pyvenv /venv
/venv/bin/pip install --upgrade pip
install $BUILDDIR/pip.sh /venv/bin
