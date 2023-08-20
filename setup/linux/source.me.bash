# Intended to be sourced via ~/.bashrc

reporoot() {
    git rev-parse --show-toplevel
}

apt_install_if_missing() {
    if ! dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "installed"; then
        sudo apt install $1
    fi
}
