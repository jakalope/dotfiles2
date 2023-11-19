#!/usr/bin/env bash
set -euo pipefail

#git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#~/.fzf/install

source "./source.me.bash"
apt_install_if_missing fzf
