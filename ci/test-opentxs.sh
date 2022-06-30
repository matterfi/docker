#!/bin/bash

#make sure we have prerequisites
source /var/lib/opentxs-prologue.sh

#e.g. "-j 10 --output-on-failure --repeat until-pass:5 --timeout 300 --schedule-random"
CTEST_PARAMS="${1}"

if [ "${CTEST_PARAMS}" == "" ]; then
    echo "ctest params not set"
    exit 1
fi

cd "${WORK}"

echo ${CTEST_PARAMS}
#cmake --install .  #no need to install
ctest ${CTEST_PARAMS}
