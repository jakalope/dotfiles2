#!/usr/bin/env bash
set -euo pipefail

if [ ! -e /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo $PATH | grep homebrew
failure=$?
if [ $failure ]; then
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ${HOME}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
