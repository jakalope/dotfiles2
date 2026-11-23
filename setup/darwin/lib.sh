# Shared helpers for the macOS setup scripts. Source from bash or zsh:
#   source "${DOTFILES:-$HOME/dotfiles2}/setup/darwin/lib.sh"

DOTFILES="${DOTFILES:-$HOME/dotfiles2}"

# append_line_if_missing FILE LINE
# Append LINE to FILE unless an identical line is already there.
append_line_if_missing() {
    local file=$1 line=$2
    touch "$file"
    if ! grep -qxF -- "$line" "$file"; then
        printf '%s\n' "$line" >> "$file"
        echo "Added to $file: $line"
    fi
}

# link_config TARGET LINK
# Make LINK a symlink to TARGET. Anything else already at LINK is moved aside
# to LINK.bak.<timestamp> rather than deleted.
link_config() {
    local target=$1 link=$2
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        return 0
    fi
    mkdir -p "$(dirname "$link")"
    if [ -e "$link" ] || [ -L "$link" ]; then
        local backup
        backup="$link.bak.$(date +%Y%m%d%H%M%S)"
        echo "Moving existing $link to $backup"
        mv "$link" "$backup"
    fi
    ln -s "$target" "$link"
    echo "Linked $link -> $target"
}

# brew_install FORMULA...
# Install formulae that aren't installed yet (never upgrades existing ones).
brew_install() {
    local f
    for f in "$@"; do
        brew list --formula "$f" >/dev/null 2>&1 || brew install "$f"
    done
}
