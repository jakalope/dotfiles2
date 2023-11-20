append_line_if_missing() {
    if ! grep -qF "$1" ~/.zprofile; then
        echo "$1" >> ~/.zprofile
    fi
}
