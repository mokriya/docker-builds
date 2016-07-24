#!/bin/bash
PYTHONDEB=$1
dpkg -i $PYTHONDEB
pyvenv /venv
/venv/bin/pip install --upgrade pip
