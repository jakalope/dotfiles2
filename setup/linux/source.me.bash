# Intended to be sourced via ~/.bashrc

git_context_search() {
    local this_directory_path=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
    $this_directory_path/../../scripts/git_context_search.py "$@"
}

gitroot() {
    git rev-parse --show-toplevel
}

gcd() {
    cd $(gitroot)
}

gpushd() {
    pushd $(gitroot)
}

tls() {
    tmux list-sessions
}

gitsubject() {
    git log --pretty=oneline --abbrev-commit --max-count=1
}

# Print all untracked files.
untracked() {
    git status --porcelain | grep '^\?' | awk '{print $2}'
}

# Print all added and modified files [since refspec]
# For example, to see the files changed since two commits ago, run
#   $ modified HEAD~2
modified() {
    git diff --name-status "$@" | grep -v '^[D\?]' | awk '{print $2}'
}

# Print all files modified or untracked.
inprogress() {
    untracked
    modified "$@"
}

# Modified from neomux funcs.sh
# (vw from the command line) -- open a file in the window with the specified number
vims() {
    # remote nvim open file $2 in window $1
    local win="$1"
    local file_line="$2"
    if [[ "$file_line" == "-" ]]; then
        for listing in $(cat); do
            local file="${listing%%:*}"
            local line="${listing##*:}"
            if [[ $line != "" ]]; then
                line="-c $line"
            fi
            nvr -cc "${win}wincmd w" -c "e $(abspath "$file")" "$line"
        done
    else
        local file="${file_line%%:*}"
        local line="${file_line##*:}"
        if [[ $line != "" ]]; then
            line="-c $line"
        fi
        nvr -cc "${win}wincmd w" -c "e $(abspath "$file")" "$line"
    fi
}

# From neomux funcs.sh
abspath() {
    local in_path
    if [[ ! "$1" =~ ^/ ]]; then
        in_path="$PWD/$1"
    else
        in_path="$1"
    fi
    echo "$in_path" | (
        IFS=/
        read -a parr
        declare -a outp
        for i in "${parr[@]}"; do
            case "$i" in
            '' | .)
                continue
                ;;
            ..)
                len=${#outp[@]}
                if ((len == 0)); then
                    continue
                else
                    unset outp[$((len - 1))]
                fi
                ;;
            *)
                len=${#outp[@]}
                outp[$len]="$i"
                ;;
            esac
        done
        echo /"${outp[*]}"
    )
}

# Tmux-Join-Session: If the name of the current directory is the name of an
# existing tmux session, join it. Otherwise create a session of that name.
tjs() {
    # Get the name of the current directory
    dir_name=$(basename "$PWD")
    # Check if a tmux session with the name of the current directory exists
    if tmux has-session -t "$dir_name" 2>/dev/null; then
      echo "Joining existing tmux session: $dir_name"
      # Attach to the existing session
      tmux attach -t "$dir_name"
    else
      echo "Creating new tmux session: $dir_name"
      # Create a new session with the name of the current directory and attach to it
      tmux new-session -s "$dir_name" -d
      tmux attach -t "$dir_name"
    fi
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
