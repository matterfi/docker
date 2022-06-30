#!/bin/bash

#make sure we have prerequisites
source /var/lib/opentxs-prologue.sh

export CCOV="/home/coverage"

if [ ! -d "${CCOV}" ]; then
    echo "Code coverage directory missing. Initialize at ${CCOV}"
    exit 1
fi

gcovr --version
gcovr   -r "${SRC}" \
        -j 16 \
        -e "${SRC}"/src/serialization \
        -e "${SRC}"/deps \
        -e "${SRC}"/tests \
        --html-details "${CCOV}"/coverage.html \
        --print-summary \
        "${WORK}"
