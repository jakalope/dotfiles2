#!/usr/bin/env zsh
# Neovim + this repo's config. Plugins are managed by lazy.nvim (see init.lua).
set -euo pipefail
source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

# ripgrep: fzf-lua grep. node: Mason-installed language servers (e.g. pyright).
brew_install neovim ripgrep node

link_config "$DOTFILES/nvim" "$HOME/.config/nvim"
link_config "$DOTFILES/nvim/site" "$HOME/.local/share/nvim/site"

# Install any missing plugins (doesn't update ones already installed).
nvim --headless "+Lazy! install" +qa
