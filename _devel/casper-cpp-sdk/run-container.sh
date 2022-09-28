#!/bin/bash

docker run \
    -it \
    --mount type=bind,src=/mnt/f/repo-matterfi/casper-cpp-sdk,dst=/home/src \
    --mount type=bind,src=/mnt/f/temp/vcpkg-bin-lin-casper-cpp-sdk/01,dst=/home/vcpkg,readonly \
    --mount type=bind,src=/mnt/f/repo-matterfi/casper-cpp-sdk/build-linux,dst=/home/build \
    --workdir=/home/build \
    polishcode/matterfi-casper-cpp-sdk-ubuntu:1   

#polishcode/matterfi-casper-cpp-sdk-alpine:1
