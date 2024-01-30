#!/usr/bin/env bash
# Top level setup script for Ubuntu

set -euo pipefail
source "./source.me.bash"

echo Installing git...
apt_install_if_missing git

if [[ ! -d ~/dotfiles2 ]]; then
    echo Cloning dotfiles2...
    git clone git@github.com:jakalope/dotfiles2.git ~/dotfiles2
fi

echo Installing neovim...
./nvim.bash

echo Installing unzip...
apt_install_if_missing unzip
apt_install_if_missing "python3.10-venv"

echo Appending to ~/.bashrc...
append_line_if_missing 'source "$HOME/dotfiles2/setup/linux/source.me.bash"'
append_line_if_missing 'PATH=$PATH:"$HOME/bin"'
