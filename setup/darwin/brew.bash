#!/usr/bin/env bash
# Install Homebrew if needed and put it on PATH for login shells.
set -euo pipefail
source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

brew_bin=""
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$b" ]; then brew_bin=$b; break; fi
done

if [ -z "$brew_bin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$b" ]; then brew_bin=$b; break; fi
    done
fi

append_line_if_missing "$HOME/.zprofile" "eval \"\$($brew_bin shellenv)\""
