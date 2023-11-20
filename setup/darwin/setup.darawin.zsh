#!/usr/bin/env zsh
# Top level setup script for Darwin

set -euo pipefail
source "./source.me.zsh"

if [[ ! -e ~/.ssh/id_rsa ]]; then
    echo 'Looks like you need to run the following:'
    echo '  ssh-keygen -t rsa -b 4096 -C <email-address>'
    echo '  eval "$(ssh-agent -s)"'
    echo '  ssh-add ~/.ssh/id_rsa'
    echo '  cat ~/.ssh/id_rsa.pub'
    echo 'and then copy the public key into your github profile ssh keys.'
    echo 'See https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/ for more details'
    exit 1
fi

brew install git

if [[ ! -d ~/dotfiles2 ]]; then
    git clone git@github.com:jakalope/dotfiles2.git ~/dotfiles2
fi

brew install unzip nvim

append_line_if_missing 'source "$HOME/dotfiles2/setup/darwin/source.me.zsh"'
append_line_if_missing 'PATH=$PATH:"$HOME/bin"'
