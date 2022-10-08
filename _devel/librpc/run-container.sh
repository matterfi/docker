#!/bin/bash

docker run \
    -it \
    --mount type=bind,src=/mnt/f/repo-matterfi/libcsprrpc,dst=/home/src \
    --mount type=bind,src=/mnt/f/temp/vcpkg-bin-lin-librpc/01,dst=/home/vcpkg,readonly \
    --mount type=bind,src=/mnt/f/repo-matterfi/libcsprrpc/build-linux,dst=/home/build \
    --workdir=/home/build \
    polishcode/matterfi-librpc-fedora:35-1
    
#polishcode/matterfi-casper-cpp-sdk-debian:1
#polishcode/matterfi-ci-fedora:36-tidy-1
#polishcode/matterfi-ci-fedora:35-3
