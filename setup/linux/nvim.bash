#!/usr/bin/env bash
set -euo pipefail

# Default XDG_CONFIG_HOME if it isn't already set.
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

# Create a softlink to the git managed copy of the nvim directory.
mkdir -p "$HOME/.config"
ln -s "$HOME/dotfiles2/nvim" "$XDG_CONFIG_HOME/nvim"
