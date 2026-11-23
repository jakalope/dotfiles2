#!/usr/bin/env zsh
# Top-level macOS setup. Safe to re-run: every step skips what's already done.
#
# Fresh machine (works before the repo is cloned):
#   curl -fsSLO https://raw.githubusercontent.com/jakalope/dotfiles2/main/setup/darwin/setup.darwin.zsh
#   zsh setup.darwin.zsh
#
# Existing checkout:
#   ~/dotfiles2/setup/darwin/setup.darwin.zsh
#
# Optional extras not run here: gpt.zsh.

set -euo pipefail
export DOTFILES="${DOTFILES:-$HOME/dotfiles2}"

if [[ ! -e ~/.ssh/id_ed25519 && ! -e ~/.ssh/id_rsa ]]; then
    cat <<'EOF'
No SSH key found. Create one and add it to GitHub, then re-run:
  ssh-keygen -t ed25519 -C <email-address>
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  pbcopy < ~/.ssh/id_ed25519.pub   # paste at https://github.com/settings/keys
EOF
    exit 1
fi

# Homebrew (also brings in git via the Xcode Command Line Tools).
if [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$({ /opt/homebrew/bin/brew shellenv || /usr/local/bin/brew shellenv; } 2>/dev/null)"

if [[ ! -d "$DOTFILES" ]]; then
    git clone git@github.com:jakalope/dotfiles2.git "$DOTFILES"
fi

steps=(
    brew.bash        # brew on PATH for login shells
    git.config.bash  # git editor and grep settings
    zsh.zsh          # shared zsh settings (emacs keys)
    fzf.bash
    mosh.bash
    nvim.zsh         # neovim, config links, plugins
    karabiner.zsh    # Caps Lock and Option-F/B/D remaps
)
for step in $steps; do
    echo "==> $step"
    "$DOTFILES/setup/darwin/$step"
done

echo "Done. Open a new terminal to pick up shell changes."
