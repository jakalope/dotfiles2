#!/usr/bin/env zsh
# Karabiner-Elements: Caps Lock = Ctrl/Esc, Option-F/B/D word motion.
set -euo pipefail
source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

if [[ ! -d /Applications/Karabiner-Elements.app ]]; then
    brew install --cask karabiner-elements
    echo "Open Karabiner-Elements once and approve its driver and input-monitoring"
    echo "prompts in System Settings, or the remaps won't take effect."
fi

# Link the whole directory: Karabiner rewrites karabiner.json in place, which
# would replace a symlink to the file itself.
link_config "$DOTFILES/karabiner" "$HOME/.config/karabiner"

# Have a running Karabiner reload the linked config.
launchctl kickstart -k "gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server" \
    2>/dev/null || true
