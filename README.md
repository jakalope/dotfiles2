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

```
:help neomux
:help lsp-zero-keybindings
:help copilot-maps
```

## Custom remappings

```lua
n_keymap('<Leader>d', ':lua vim.lsp.buf.definition()<CR>')  -- jump include
n_keymap('<Leader>h', ':ClangdSwitchSourceHeader<CR>')      -- jump src/header
n_keymap('<C-j>', '<C-W>j')                                 -- window below
n_keymap('<C-k>', '<C-W>k')                                 -- window above
n_keymap('<C-h>', '<C-W>h')                                 -- window left
n_keymap('<C-l>', '<C-W>l')                                 -- window right
t_keymap('<Esc>', '<C-\\><C-n>')                            -- Exit term mode
```
