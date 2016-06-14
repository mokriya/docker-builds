#!/bin/bash
DEBVERSION=${1:-jessie}
M4="m4 -P -D debversion=$DEBVERSION"
$M4 debbase/Dockerfile.m4 > debbase/Dockerfile
docker build -t altaurog/debbase:$DEBVERSION debbase/

$M4 pybuild/Dockerfile.m4 > pybuild/Dockerfile
docker build -t altaurog/pybuild:$DEBVERSION pybuild/
