# Setup

## Ubuntu

```
pushd
curl -o setup.ubuntu.bash \
    -L https://raw.githubusercontent.com/jakalope/dotfiles2/main/setup/linux/setup.ubuntu.bash
chmod +x setup.ubuntu.bash
./setup.ubuntu.bash
popd
```

# Neovim

## Help

### Plugin Mappings

```
:help neomux
:help leap-default-mappings
:help lsp-zero-keybindings
:help copilot-maps
```

### Custom remappings

```lua
vim.keymap.set({'n', 'x', 'o'}, 'Mf', '<Plug>(leap-forward-to)')
vim.keymap.set({'n', 'x', 'o'}, 'MF', '<Plug>(leap-backward-to)')

n_keymap('<Leader>d', ':lua vim.lsp.buf.definition()<CR>')  -- jump to def
n_keymap('<Leader>h', ':ClangdSwitchSourceHeader<CR>')      -- jump src/header

n_keymap('<C-j>', '<C-W>j')  -- window below
n_keymap('<C-k>', '<C-W>k')  -- window above
n_keymap('<C-h>', '<C-W>h')  -- window left
n_keymap('<C-l>', '<C-W>l')  -- window right

n_keymap('=', 'o<Esc>k')  -- newline below

-- Delete the current buffer without closing the current window
n_keymap('<F9><F9>', ':lua delete_buffer()<CR>')
```

## My common commands

### `d^`: Delete until first non-whitespace character

Can be used to reduce the indentation of the current line to the cursor's
current position by deleting from cursor to first non-whitespace character.

For example,
```
my_function_call(
        argument1,
                argument2
)       ^ cursor goes here
```

Enter `d^` to align `argument2` with `argument1`.
```
my_function_call(
        argument1,
        argument2
)       ^ enter `d^`
```

### `gF`: Open a `file[:line]` pattern to its `file` [and `line`]

This is especially useful with the built-in terminal emulator in newer versions
of vim and neovim. See `:help terminal`.

For example, open a vim terminal.
```
:terminal
```

Or if you're using neomux (as in this repository),
```
<Leader>sh
```

Then, from the terminal, run any command that generates `file:line` patterns,
such as compiler errors, linters, and file search utilities. The `file` must be
relative to the current (neo)vim path (aka `vpwd`).

Escape to normal mode within the terminal window (`<C-\><C-n>` or, like with
neomux, `<C-s>`), move your cursor to the desired `file:line`, and enter `gF`.

One handy trick is to always run `vim` or `nvim` from the root of the repository
you're working within and then use `--full-name` in your various `git` search
commands.
```
git grep --line-number --full-name <SEARCH-PATTERN>
```

You can set `git` configuration options to always turn these options on.
```
git config --global grep.lineNumber true
git config --global grep.fullName true
```

### `cd "$(vpwd)"`
