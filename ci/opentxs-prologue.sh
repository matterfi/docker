#!/bin/bash

#exit immediately if sth goes wrong
set -e

export SRC="/home/src"
export WORK="/home/output"

if [ ! -d "${SRC}" ]; then
    echo "Source tree missing. Mount opentxs source directory at ${SRC}"
    exit 1
fi

if [ ! -d "${WORK}" ]; then
    echo "Work directory missing. Mount build directory at ${WORK}"
    exit 1
fi
