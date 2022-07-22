#!/bin/bash

docker run \
    -it \
    --mount type=bind,src=/mnt/f/repo-matterfi/opentxs,dst=/home/src,readonly \
    --mount type=bind,src=/mnt/f/repo-matterfi/docker/_devel/ci,dst=/home/script,readonly \
    --mount type=bind,src=/mnt/f/temp/opentxs-coverage,dst=/home/coverage \
    --mount type=bind,src=/home/pgawron/opentxs/output,dst=/home/output \
    --workdir=/home/script \
    polishcode/matterfi-ci-fedora:36-tidy-1
