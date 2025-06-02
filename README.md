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

# Remote Work

## Tunnel into REMOTE and launch neovim server

```
ssh -L 2489:localhost:2489 $REMOTE \
    /home/jaskeland/bin/nvim --listen localhost:2489 --headless
```

## Open Neovide locally and connect to server

```
/Applications/Neovide.app/Contents/MacOS/neovide --server localhost:2489
```

- Open vertical splits `:vs<CR>:vs<CR>`
- Start a shell on one split `\sh`
- Open a horizontal split `:sp`
- Start a shell there `\sh`
- Start aichat `aichat<CR>`

# Old Remote work

## Open neovim
```
mosh $REMOTE
cd <workspace_dir>
tjs    # TMUX join session (or start a new one)
nvim
:vs<CR>
<leader>sh  # start a shell
```

## Copy text from remote neovim to the local host

```
_z   # to open a new tab, turn off gutter and mouse interaction
<use mouse to select>
<Command-C>
```

Note: lemonade can be tempermental

## Move forward/backward one word in command prompt

Configure terminal emulator to treat option as meta.
Then use `<Meta-F>` and `<Meta-B>`.

# Gerrit

## Workflows

### Modify code from a CL

```
git review -d <CL-id>
git checkout -
git worktree add ../<CL-id> review/<users-gerrit-name>/<CL-id>
```

_Do work_

```
git worktree remove review/<users-gerrit-name>/<CL-id>
```

# Neovim

## SSH Copy/Paste Support

See `:help clipboard-tool`.

Lemonade with port forwarding:
```
lemonade server -allow 127.0.0.1 &
ssh -R 2489:127.0.0.1:2489 user@host
```

## Help

### Topics I tend to forget

```
:help formatting
```

### Plugin Mappings

```
:help neomux
:help leap-default-mappings
:help lsp-zero-keybindings
:help copilot-maps
```

### Custom remappings

```lua
vim.keymap.set({'n', 'x', 'o'}, 'M', '<Plug>(leap-forward-to)')
vim.keymap.set({'n', 'x', 'o'}, 'L', '<Plug>(leap-backward-to)')

n_keymap('<Leader>d', ':lua vim.lsp.buf.definition()<CR>')  -- jump to def
n_keymap('<Leader>h', ':ClangdSwitchSourceHeader<CR>')      -- jump src/header

n_keymap('<C-j>', '<C-W>j')  -- window below
n_keymap('<C-k>', '<C-W>k')  -- window above
n_keymap('<C-h>', '<C-W>h')  -- window left
n_keymap('<C-l>', '<C-W>l')  -- window right

n_keymap('=', 'o<Esc>k')  -- newline below

-- Delete the current buffer without closing the current window
n_keymap('<F9><F9>', ':lua delete_buffer()<CR>')

n_keymap('<Leader>w1', ':OpenFileAtLineInWindow(1)<CR>')
...
n_keymap('<Leader>w9', ':OpenFileAtLineInWindow(9)<CR>')
```

## Python Language Server Protocol (LSP) Setup

Per machine, install `pyright` LSP, `black` linter, and `debugpy` debugging
assistant.
```
:MasonInstall pyright
:MasonInstall black
:MasonInstall debugpy
```

Per project, add a file `pyrightconfig.json` to the root folder. Add the
following to it. If you put your virtual environment somewhere other than
your project folder, you'd specify the path via `venvPath`. If you name it
something other than `venv`, you'd supply that name in the `venv` parameter.

```
{
    "venvPath": "./",
    "venv": "venv"
}
```

After calling `pip install`, use `:LspRestart` for changes to take effect.

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

### `gF` & `<Leader>w1`: Open a `file[:line]` pattern to its `file` [and `line`]

This is especially useful with the built-in terminal emulator in newer versions
of vim and neovim. See `:help terminal`.

Using Neomux, in normal mode, type
```
<Leader>sh
```

Then, from the terminal, run any command that generates `file:line` patterns,
such as compiler errors, linters, and file search utilities. The `file` must be
relative to the current (neo)vim path (aka `vpwd`).

Escape to normal mode within the terminal window (`<C-\><C-n>` or, like with
neomux, `<C-s>`), move your cursor to the desired `file:line`, and enter `gF`
to open it in the current window, or `<Leader>w` and the number of the window
you'd rather open it in, e.g. `<Leader>w1`.

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

These options are set automatically via `setup/linux/git.config.bash`.

### `vw [win] <file>`: open `file` [in window `win`] from a Neomux terminal

Neomux terminals can be opened via `<Leader>sh`. Once open, the commands `e`,
`vw`, ... from the command line will open files into the window numbered `win`.
For example, when using `vw [win] <file>`, the `win` number is shown in the
statusline.

### `cd "$(vpwd)"`: Change directory to neovim's working directory

Within a Neomux terminal, this command will bring you to neovim's current
working directory. this is handy when using `gF` on the terminal window in
normal mode.

### Always leave the cursor in the center and use relative numbers to jump

The following settings work together to speed up vertical navigation.

```lua
vim.o.number = true          -- show line numbers
vim.o.relativenumber = true  -- line numbers are relative to the cursor
vim.o.scrolloff = 100000     -- keep cursor in the middle of the screen
```

Setting `number` and `relativenumber` causes gutter line numbering to be
relative to the current line. This lets you jump up and down by typing
`[count]j` or `[count]k` without leaving normal mode. It also normalizes the
range of numbers you'll type to do such jumps, which is both especially useful
in large files and reduces mental overhead.

### `<C-p>`: Fuzzy file search with fzf

First, make sure you've installed fzf. There are install files in setup/ for
linux and darwin. Then use `<C-p>` in normal mode to bring up the fuzzy search
dialog box.

### `gq{motion}`: Apply formatting

This is especially useful with `mason`, `lsp-zero`, and friends. For example,
typing `gqa{` anywhere in the following snippet will format the entire braced
expression.

```
{
 "some_key": "some-value",
        }
```

### Open files changed in the most recent commit

The following lists all the most recently changed files and opens them in window
two.
```
for f in $(git diff-tree --no-commit-id --name-only -r HEAD); do vw 2 $f; done
```

## Neovim package development

To load a new package without restarting Neovim,
```
:lua package.loaded['my-package'] = loadfile('/path/to/my-package.lua')()
```
