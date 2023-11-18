#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/bin
mkdir -p ~/nvim-install
if [ ! -d ~/nvim-install/squashfs-root ]; then
    pushd ~/nvim-install
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    ./squashfs-root/AppRun --version
    ln -s ~/nvim-install/squashfs-root/AppRun ~/bin/nvim
    popd
fi

# Create a softlink to the git managed copy of the nvim directory.
if [ ! -d "$HOME/.config/nvim" ]; then
    # Default XDG_CONFIG_HOME if it isn't already set.
    XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
    mkdir -p "$XDG_CONFIG_HOME"
    ln -s "$HOME/dotfiles2/nvim" "$XDG_CONFIG_HOME/nvim" || true
fi

if [ ! -d "$HOME/.local/share/nvim/site" ]; then
    # Default XDG_LOCAL_HOME if it isn't already set.
    XDG_LOCAL_HOME=${XDG_LOCAL_HOME:-"$HOME/.local"}
    mkdir -p "$XDG_LOCAL_HOME/share/nvim"
    ln -s "$HOME/dotfiles2/nvim/site" "$XDG_LOCAL_HOME/share/nvim/" || true
fi

if [ ! -d ~/.config/nvim/pack/github/start/copilot.vim ]; then
    git clone https://github.com/github/copilot.vim \
       ~/.config/nvim/pack/github/start/copilot.vim
fi

if [ ! -d ~/.config/nvim/autoload/plug.vim ]; then
    sh -c 'curl -fLo \
        ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# Ensure Node.js version 16 or greater is isntalled
./nodejs.bash
