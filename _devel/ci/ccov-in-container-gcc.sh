#!/bin/bash

time \
docker run \
    --mount type=bind,src=/mnt/f/repo-matterfi/opentxs,dst=/home/src,readonly \
    --mount type=bind,src=/home/pgawron/opentxs/output,dst=/home/output \
    --mount type=bind,src=/mnt/f/temp/opentxs-coverage,dst=/home/coverage \
    -i --entrypoint /usr/bin/ccov-opentxs-gcc.sh \
    polishcode/matterfi-ci-fedora:35-2
