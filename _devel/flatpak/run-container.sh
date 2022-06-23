#!/bin/bash

docker run \
    --privileged \
    -it \
    --mount type=bind,src=/mnt/f/repo-matterfi/wallet,dst=/home/src,readonly \
    --mount type=bind,src=/mnt/f/repo-matterfi/docker/_devel/flatpak,dst=/home/script,readonly \
    --mount type=bind,src=/home/pgawron/flatpak-host,dst=/home/flatpak-host \
    --workdir=/home/script \
    polishcode/matterfi-flatpak:kde-5.15-21.08-2
