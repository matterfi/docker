#!/bin/bash

#make sure we have prerequisites
source /var/lib/opentxs-prologue.sh

C_COMPILER="${1}"
CXX_COMPILER="${2}"
#${3} specifies build type
CODE_COVERAGE="${4}"

if [ "${C_COMPILER}" == "" ]; then
    echo "C compiler not set"
    exit 1
fi

if [ "${CXX_COMPILER}" == "" ]; then
    echo "C++ compiler not set"
    exit 1
fi

#code coverage setting needs to be explicitly defined: ccov or no-ccov
if ! [[ "${CODE_COVERAGE}" =~ ^(ccov|no-ccov)$ ]]; then
    echo "-- code coverage/no code coverage parameter not defined"
    exit 1
fi
#enable code coverage
#TODO works only with gcc
if [ "${CODE_COVERAGE}" == "ccov" ]; then
    echo "-- code coverage enabled"

    #clang - TODO
    #builds, but cannot use gcovr to generate a report; for now gcc should be more than enough
    #export OT_CMAKE_C_FLAGS="-fprofile-instr-generate -fcoverage-mapping"

    #gcc - assumes we are building for gcc, option clang + ccov will fail, but this is fine
    #https://gcovr.com/en/stable/guide/compiling.html#compiler-options
    export OT_CMAKE_C_FLAGS="-fprofile-arcs -ftest-coverage -O1 -fprofile-abs-path"
fi

git config --global --add safe.directory "${SRC}"  #https://stackoverflow.com/a/71941707
source /var/lib/opentxs-config.sh "${3}"

rm -rf "${WORK}/"*
cd "${WORK}"
/usr/local/bin/cmake \
    -GNinja \
    -DCMAKE_C_COMPILER="${C_COMPILER}" \
    -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_FLAGS="${OT_CMAKE_C_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${OT_CMAKE_C_FLAGS}" \
    -DBUILD_SHARED_LIBS=ON \
    -DOT_LUCRE_DEBUG=OFF \
    ${OT_OPTIONS} \
    "${SRC}"
/usr/local/bin/cmake --build .
