#!/usr/bin/env zsh
# Hook the shared zsh settings into ~/.zshrc.
set -euo pipefail
source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

append_line_if_missing "$HOME/.zshrc" 'source "$HOME/dotfiles2/zsh/zshrc.zsh"'
