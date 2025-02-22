#!/bin/bash

docker run \
    --mount type=bind,src=/mnt/f/repo-matterfi/opentxs,dst=/home/src,readonly \
    --mount type=bind,src=/home/pgawron/opentxs/output,dst=/home/output \
    -i --entrypoint /usr/bin/test-opentxs.sh \
    polishcode/matterfi-ci-fedora:35-3 "-V -R ottest-blockchain-address"
