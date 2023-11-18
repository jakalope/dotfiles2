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

require("lazy").setup({
    "nikvdp/neomux",  -- Control neovim from its terminal and vice versa
    "ggandor/leap.nvim",  -- Speed up f/F/t/T motions
    "tpope/vim-repeat",  -- Make plugins repeatable with . (leap dep)
    "VonHeikemen/lsp-zero.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "github/copilot.vim",
})

local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)
lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})

require('setup-clipboard')
require('buffer-delete')

-- Prepare neovim to be controlled from its terminal via neomux
vim.fn.setenv('NVIM_LISTEN_ADDRESS', vim.v.servername)

local leap = require('leap')
leap.opts.highlight_unlabeled_phase_one_targets = true

-- Personalization below this line
--

vim.cmd.colorscheme('habamax')  -- set colorscheme

vim.o.scrolloff = 100000  -- keep cursor in the middle of the screen
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

-- Productivity Shortcuts
local n_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

local t_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
end

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
