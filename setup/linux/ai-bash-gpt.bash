#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$HOME/bin" ]; then
    mkdir -p "$HOME/bin"
fi

cmd="deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" 
if [ ! -e "$HOME/bin/ai" ]; then
    sudo apt -y install jq curl imagemagick catimg

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo $cmd | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install glow

    curl "https://raw.githubusercontent.com/nitefood/ai-bash-gpt/master/ai" > \
        "$HOME/bin/ai"
    chmod 0755 "$HOME/bin/ai"
fi
