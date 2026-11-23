#!/usr/bin/env bash
# fzf with zsh key bindings (Ctrl-R, Ctrl-T, Alt-C) and completion.
set -euo pipefail
source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

brew_install fzf
# Non-interactive: writes ~/.fzf.zsh; we add the source line ourselves.
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
append_line_if_missing "$HOME/.zshrc" '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
