#!/usr/bin/env bash
set -euo pipefail

pushd /tmp
if [ ! -d cuda-keyring_1.0-1_all.deb ]; then
    wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.0-1_all.deb
    sudo dpkg -i cuda-keyring_1.0-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda
fi
popd
