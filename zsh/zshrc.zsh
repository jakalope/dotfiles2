# Interactive zsh settings shared across machines.
# Sourced from ~/.zshrc (setup/darwin/zsh.zsh adds the line).

# Always use emacs keys. Without this, zsh picks vi mode whenever $EDITOR
# contains "vi" (e.g. neomux sets EDITOR to a path under .../nvim/...).
bindkey -e

# Alt-F: stop at the end of the word like bash/readline (zsh's default
# forward-word jumps to the start of the next word instead).
bindkey '^[f' emacs-forward-word
