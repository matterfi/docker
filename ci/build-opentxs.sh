#!/bin/bash

#make sure we have prerequisites
source /var/lib/opentxs-prologue.sh

C_COMPILER="${1}"
CXX_COMPILER="${2}"
#${3} specifies build type
BUILD_MODE="${4}"

if [ "${C_COMPILER}" == "" ]; then
    echo "C compiler not set"
    exit 1
fi
if [ "${CXX_COMPILER}" == "" ]; then
    echo "C++ compiler not set"
    exit 1
fi
if [ "${BUILD_MODE}" == "" ]; then
    echo "build mode not set"
    exit 1
fi

#build mode setting needs to be explicitly defined:
# standard 
# ccov      - gcc only, for calculating code coverage statistics
# sanitizer - clang only, for running under sanitizer
if ! [[ "${BUILD_MODE}" =~ ^(standard|ccov|sanitizer)$ ]]; then
    echo "-- build mode parameter not defined [standard|ccov|sanitizer]"
    exit 1
fi
if [ "${BUILD_MODE}" == "ccov" ]; then
    echo "-- code coverage enabled"

    #clang - TODO
    #builds, but cannot use gcovr to generate a report; for now gcc should be more than enough
    #export OT_CMAKE_C_FLAGS="-fprofile-instr-generate -fcoverage-mapping"

    #gcc - assumes we are building for gcc, option clang + ccov will fail, but this is fine
    #https://gcovr.com/en/stable/guide/compiling.html#compiler-options
    export OT_CMAKE_C_FLAGS="-fprofile-arcs -ftest-coverage -O1 -fprofile-abs-path"
fi
if [ "${BUILD_MODE}" == "sanitizer" ]; then
    echo "-- sanitizer enabled"

    #clang-only
    export OT_OPTIMIZE="-O1"
    export OT_CMAKE_C_FLAGS="-fno-omit-frame-pointer -fno-optimize-sibling-calls -fsanitize=address,undefined,leak -fsanitize-address-use-after-scope -fno-sanitize-recover=all -fsanitize-recover=implicit-conversion -fsanitize-recover=signed-integer-overflow"
    export OT_CMAKE_CXX_FLAGS="-fno-sanitize=vptr"
    export OT_CMAKE_EXE_LINKER_FLAGS="-fsanitize=address,undefined,leak"
    export ASAN_OPTIONS="detect_container_overflow=0"
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
    -DCMAKE_C_FLAGS="${OT_OPTIMIZE} ${OT_CMAKE_C_FLAGS}" \
    -DCMAKE_CXX_FLAGS="${OT_OPTIMIZE} ${OT_CMAKE_C_FLAGS} ${OT_CMAKE_CXX_FLAGS}" \
    -DCMAKE_EXE_LINKER_FLAGS="${OT_CMAKE_EXE_LINKER_FLAGS}" \
    -DBUILD_SHARED_LIBS=ON \
    -DOT_LUCRE_DEBUG=OFF \
    ${OT_OPTIONS} \
    "${SRC}"
/usr/local/bin/cmake --build . -- -k0
