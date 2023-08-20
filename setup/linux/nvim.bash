#!/usr/bin/env bash
set -euo pipefail

# Create a softlink to the git managed copy of the nvim directory.
if [ ! -d "$HOME/.config/nvim" ]; then
    # Default XDG_CONFIG_HOME if it isn't already set.
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
    mkdir -p "$HOME/.config"
    ln -s "$HOME/dotfiles2/nvim" "$XDG_CONFIG_HOME/nvim"
fi

if [ ! -d ~/.config/nvim/pack/github/start/copilot.vim ]; then
    git clone https://github.com/github/copilot.vim \
       ~/.config/nvim/pack/github/start/copilot.vim
fi

# Ensure Node.js version 16 or greater is isntalled
./nodejs.bash
