#!/bin/bash
set -euo pipefail

# Check if Node.js is installed and its version
echo Checking nodejs version...
installed_version=$(node -v 2>/dev/null || true)
required_version="v16"

# Compare versions
if [[ -z "$installed_version" || "$installed_version" < "$required_version" ]]; then
    echo "Installing Node.js..."
    
    # Remove any existing NodeSource repository configurations
    sudo rm /etc/apt/sources.list.d/nodesource.list* || true

    # Avoid problems with existing versions of Node.js
    sudo apt remove libnode72
    sudo apt autoremove
    sudo apt clean
    sudo apt autoclean

    # Update package lists and install dependencies
    sudo apt update
    sudo apt install curl dirmngr apt-transport-https lsb-release ca-certificates

    # Add the NodeSource repository for Node.js 16.x
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

    # Install Node.js and npm
    sudo apt install nodejs

    echo "Node.js installed successfully!"
    echo "Node version: $(node -v)"
    echo "npm version: $(npm -v)"
else
    echo "Node.js is already installed and up-to-date."
    echo "Installed version: $installed_version"
fi
