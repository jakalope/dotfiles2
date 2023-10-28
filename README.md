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

## Remappings

### Language Server Protocol (LSP)

Through `Mason`, I've installed the `clangd` LSP for C++.
The plugin `lsp-zero` uses the following mapping by default.
See `:help lsp-zero-keybindings`

### Custom remappings

```lua
n_keymap('<Leader>f', ':lua vim.lsp.buf.definition()<CR>')  -- jump to include
n_keymap('<Leader>d', ':ClangdSwitchSourceHeader<CR>')      -- jump to source/header
```
