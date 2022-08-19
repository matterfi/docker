#!/bin/bash

docker run \
    -it \
    --mount type=bind,src=/mnt/f/repo-matterfi/tangem-demo,dst=/home/tangem \
    --workdir=/home/tangem \
    polishcode/matterfi-tangem-fedora:36-1
