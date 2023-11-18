#!/usr/bin/env bash
set -euo pipefail

mkdir -p /tmp/win32yank
cd /tmp/win32yank
wget "https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip"
unzip win32yank-x64.zip
chmod +x win32yank.exe
mv win32yank.exe $HOME/bin/
cd -
rm -rf /tmp/win32yank
