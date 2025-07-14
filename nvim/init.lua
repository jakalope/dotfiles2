local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Effectively disable some of the default neomux mappings
vim.g.neomux_yank_buffer_map = "<Plug><C-1>"   -- I'm never going to use this
vim.g.neomux_paste_buffer_map = "<Plug><C-2>"  -- I'm never going to use this
vim.g.neomux_term_sizefix_map = "<Plug><C-3>"  -- because <C-w>= is useful

vim.g.neovide_scroll_animation_far_lines = 0

local user = os.getenv("USER")

require("lazy").setup({
    "tpope/vim-fugitive",
    "tpope/vim-abolish",
    "nikvdp/neomux",
    "ggandor/leap.nvim",
    "tpope/vim-repeat",
    "moll/vim-bbye",
    "VonHeikemen/lsp-zero.nvim",
    "nvim-treesitter/nvim-treesitter",
    "github/copilot.vim",
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
      "ibhagwan/fzf-lua",
      opts = {}
    }
})

vim.keymap.set('i', '<C-Space>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({
  PATH = "append",  -- Search venv path before masonpath when looking for config
})
require('lspconfig').pylsp.setup({})

require('setup-clipboard')
require('buffer-delete')
require('bazel')
require('nav-to-file')

if string.match(user, "jaskeland") then
    -- Add paths to the path used for gf
    vim.o.path = vim.o.path ..
        ',' .. vim.fn.expand('avdnn/bazel-bin/') ..
        ',' .. vim.fn.expand('src/') ..
        ',' .. vim.fn.expand('bazel-bin/') ..
        ',' .. vim.fn.expand('bazel-bin/src/') ..
        ',' .. vim.fn.expand('src/dwcgf/description/') ..
        ',' .. vim.fn.expand('src/dwroadcast/')

    -- Set the project root environment variable to the value of NV_AV_TOP
    vim.fn.setenv('PROJECT_ROOT', vim.fn.environ()['NV_AV_TOP'])
end

-- Concatenate the default statusline with the neotree statusline.
-- When using `vw [win] <file>`, the `win` number is shown in the statusline
vim.o.statusline = '∥ W:[%{WindowNumber()}] ∥ ' ..
        '%{expand("%:p")}%h%m%r%=%-14.(%l,%c%V%)%P'

--local leap = require('leap')
--leap.opts.highlight_unlabeled_phase_one_targets = true

-- Personalization below this line
--

vim.cmd.colorscheme('slate')  -- set colorscheme
vim.opt.background = 'dark'
vim.cmd([[
  highlight TermCursor guifg=red guibg=red
  highlight Cursor guifg=yellow guibg=yellow
  highlight MatchParen ctermbg=NONE guibg=NONE ctermfg=lightgreen guifg=lightgreen
]])

vim.o.hlsearch = false    -- don't highlight search results

-- Set default filetype plugin options (override in site/ftplugin)
vim.o.expandtab = true    -- use spaces instead of tabs
vim.o.number = true       -- show line numbers
vim.o.tabstop = 4         -- width of <Tab> character (used by <Tab> and <BS>)
vim.o.shiftwidth = 4      -- indent width (used by >> and <<)
vim.o.softtabstop = 4     -- insert/delete <Space> N chars with <Tab>/<BS>

-- Set a guide bar just past an interval of 80 chars (used by gq)
vim.o.colorcolumn = "81,161,241,321,401,481,561,641,721,801"

-- Show relative line numbers (move via [count]j or [count]k)
vim.o.relativenumber = true

-- Function to trim trailing whitespace
local function trim_trailing_whitespace()
  local current_view = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(current_view)
end

-- Autocommand to trim trailing whitespace on buffer write
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = trim_trailing_whitespace
})

-- Autocommand to set scrolloff for non-terminal buffers
-- Fixes scrolloff reset when entering a buffer via "gf" from terminal-normal
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        -- Check if the buffer is not a terminal buffer
        if vim.bo.buftype ~= "terminal" then
            -- Set scrolloff to 10000 for non-terminal buffers
            vim.wo.scrolloff = 10000
        end
    end,
})

-- Disables automatic transition to terminal mode
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "term://*",
    callback = function()
        if vim.bo.buftype == 'terminal' then
            vim.cmd('stopinsert')
        end
    end
})

-- Function to go to the lowest terminal buffer
local function go_to_lowest_terminal_buffer()
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buflisted
      and vim.bo[buf].buftype == 'terminal'
  end, vim.api.nvim_list_bufs())

  if #buffers == 0 then
    print("No terminal buffers found")
    return
  end

  local lowest = math.min(unpack(buffers))
  vim.api.nvim_set_current_buf(lowest)
end

-- Set up the keymap
vim.keymap.set('n', '<Leader>t', go_to_lowest_terminal_buffer,
    { noremap = true, silent = true, desc = "Go to lowest terminal buffer" })

-- Productivity Shortcuts
local n_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

local i_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true, silent = true })
end

local t_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
end

-- Map _z to open a tab that's easy to copy from when using SSH
vim.api.nvim_set_keymap('n', '_z', '', {
    noremap = true,
    callback = function()
        vim.cmd("set mouse=")
        vim.cmd("tabnew %")
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.foldcolumn = "0"
    end
})

-- File navigation
n_keymap('<Leader>d', ':lua vim.lsp.buf.definition()<CR>') -- jump to def
n_keymap('<Leader>h', ':ClangdSwitchSourceHeader<CR>')     -- jump src/header
n_keymap('<Leader>f', ":FzfLua files<CR>")                 -- fuzzy find files
n_keymap('<Leader>b', ":FzfLua buffers<CR>")               -- fuzzy find buffers
n_keymap('<Leader>g', ":FzfLua git_files<CR>")             -- fuzzy find git
n_keymap('<leader>s', ":Neotree float git_status<cr>")
n_keymap('<Leader><Leader>', ':Neotree toggle<CR>')        -- toggle neotree

-- Window navigation
n_keymap('<C-j>', '<C-W>j')  -- window below
n_keymap('<C-k>', '<C-W>k')  -- window above
n_keymap('<C-h>', '<C-W>h')  -- window left
n_keymap('<C-l>', '<C-W>l')  -- window right

-- Tab navigation
n_keymap('<F5>', ':tabp<CR>')  -- previous tab
n_keymap('<F6>', ':tabn<CR>')  -- next tab

-- Buffer navigation
n_keymap('gb', ":bp<CR>")  -- previous buffer (can't use <C-^>; used by mosh)
n_keymap('gn', ":bn<CR>")  -- next buffer

i_keymap('<C-j>', '<Esc><C-W>j')  -- window below
i_keymap('<C-k>', '<Esc><C-W>k')  -- window above
i_keymap('<C-h>', '<Esc><C-W>h')  -- window left
i_keymap('<C-l>', '<Esc><C-W>l')  -- window right

t_keymap('<C-j>', '<C-\\><C-n><C-w>j')  -- window below
t_keymap('<C-k>', '<C-\\><C-n><C-w>k')  -- window above
t_keymap('<C-h>', '<C-\\><C-n><C-w>h')  -- window left
t_keymap('<C-l>', '<C-\\><C-n><C-w>l')  -- window right
t_keymap('<C-u>', '<C-\\><C-n><C-u>')   -- page up
t_keymap('<S-Space>', '<Plug>')         -- disable shift-space in iterm2

-- Motions
vim.keymap.set({'n', 'x', 'o'}, 'z', '<Plug>(leap-forward)')
vim.keymap.set({'n', 'x', 'o'}, 'Z', '<Plug>(leap-backward)')

n_keymap('=', 'o<Esc>k')  -- newline below
n_keymap('+', 'O<Esc>j')  -- newline above

-- Terminal search
t_keymap('<F4>', '<C-\\><C-n>?ERROR:.*Compiling<CR>/: error:<CR>0')

-- Remap <C-d> in terminal so we don't accidentally close the shell
t_keymap('<C-d>', '<Plug>x')
t_keymap('<C-;>', '<C-d>')

-- Delete the current buffer without closing the current window
n_keymap('<F9><F9>', ':Bdelete<CR>')
n_keymap('<F9><F10>', ':Bdelete!<CR>')

-- Source this file
n_keymap('<F12>', ':source ~/dotfiles2/nvim/init.lua<CR>')

-- Visual block mode when terminal thinks <C-v> is paste
n_keymap('<C-y>', '<C-v>')

-- Copy the path of the current buffer
n_keymap('_y', ':let @"=@%<CR>:let @+=@%<CR>')

-- Copy the current buffer's file:line; useful for setting breakpoints
n_keymap('_b', [[:let @+ = expand('%:~:.') . ':' . line('.')<CR>]])

-- For neovide
-- vim.env.TERM = "xterm-256color"
vim.opt.termguicolors = false  -- TODO this should be true if using neovide

-- TODO determine why shift-<Space> in a terminal window is causing strange
--      behavior in neovide

local function pasteFromClipboard()
    local clipboard_content = vim.fn.getreg('+') -- '+' is the system clipboard register
    vim.api.nvim_put({ clipboard_content }, 'l', true, true)
end
vim.keymap.set('t', '<D-v>', pasteFromClipboard, { silent = true, noremap = true })

vim.g.neovide_input_use_logo = false
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_window_blurred = false
