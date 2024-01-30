# Intended to be sourced via ~/.bashrc

reporoot() {
    git rev-parse --show-toplevel
}

apt_install_if_missing() {
    if dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "not-installed"; then
        sudo apt install $1
    fi
}

append_line_if_missing() {
    if ! grep -qF "$1" ~/.bashrc; then
        echo "$1" >> ~/.bashrc
    fi
}
