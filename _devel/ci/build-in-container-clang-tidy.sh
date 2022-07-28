#!/bin/bash

time \
docker run \
    --mount type=bind,src=/mnt/f/repo-matterfi/opentxs,dst=/home/src,readonly \
    --mount type=bind,src=/home/pgawron/opentxs/output,dst=/home/output \
    -i --entrypoint /usr/bin/build-opentxs-clang.sh \
    polishcode/matterfi-ci-fedora:36-tidy-1 tidy standard
