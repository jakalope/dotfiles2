#!/usr/bin/env bash
set -euo pipefail

if [[ ! -e ~/.ssh/id_rsa ]]; then
    echo 'Looks like you need to run the following:'
    echo '  ssh-keygen -t rsa -b 4096 -C <email-address>'
    echo '  eval "$(ssh-agent -s)"'
    echo '  ssh-add ~/.ssh/id_rsa'
    echo '  cat ~/.ssh/id_rsa.pub'
    echo 'and then copy the public key into your github profile ssh keys.'
    echo 'See https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/ for more details'
fi

sudo apt install \
	neovim \
	git

git clone git@github.com:jakalope/dotfiles2.git ~/dotfiles2
