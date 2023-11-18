#!/usr/bin/env bash
set -euo pipefail

# Configure only this repository for my private email address.
git config --local user.name "Jake Askeland"
git config --local user.email "jake.askeland@gmail.com"

# Configure git to use vim as the default editor.
git config --global core.editor "nvim"

# Configure git grep results to be compatible with vim quickfix, making it
# useful for `gF`.
git config --global grep.lineNumber true
git config --global grep.fullName true
