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

-- Personalization below this line
--

vim.cmd.colorscheme('habamax')  -- set colorscheme

-- Set default options
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 100000
vim.o.colorcolumn = "81,161,241,321,401,481,561,641,721,801"

-- Productivity Shortcuts
local n_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

n_keymap('<Leader>d', ':lua vim.lsp.buf.definition()<CR>')  -- jump to include
n_keymap('<Leader>h', ':ClangdSwitchSourceHeader<CR>')      -- jump to source/header
n_keymap('<C-j>', '<C-W>j')                                 -- move to window below
n_keymap('<C-k>', '<C-W>k')                                 -- move to window above
n_keymap('<C-h>', '<C-W>h')                                 -- move to window left
n_keymap('<C-l>', '<C-W>l')                                 -- move to window right

local t_keymap = function(lhs, rhs)
    vim.api.nvim_set_keymap('t', lhs, rhs, { noremap = true, silent = true })
end

t_keymap('<Esc>', '<C-\\><C-n>')  -- Exit terminal mode
