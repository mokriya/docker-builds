#!/bin/bash
BUILDWHEELS=$1
install $BUILDWHEELS /venv/bin
/venv/bin/pip install wheel

export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
/bin/aptinstall libpq-dev
