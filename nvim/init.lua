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

require("lazy").setup({
    "tpope/vim-fugitive", -- Git integration
    "tpope/vim-abolish",  -- Change word case (e.g. crs for snake_case)
    "nikvdp/neomux",  -- Control neovim from its terminal and vice versa
    "ggandor/leap.nvim",  -- Speed up f/F/t/T motions
    -- "justinmk/vim-sneak",  -- Speed up f/F/t/T motions
    "tpope/vim-repeat",  -- Make plugins repeatable with . (leap dep)
    "moll/vim-bbye",  -- Bdelete, remove buffers w/o affecting splits
    "VonHeikemen/lsp-zero.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "github/copilot.vim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required
          "MunifTanjim/nui.nvim",
          "3rd/image.nvim", -- See `# Preview Mode` for more information
        }
    },
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
      end
    }
})

require'nvim-web-devicons'.get_icons()

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

require('mason').setup({
  PATH = "append",  -- Search venv path before masonpath when looking for config
})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})


require('setup-clipboard')
require('buffer-delete')
require('bazel')
require('nav-to-file')

-- Concatenate the default statusline with the neotree statusline.
-- When using `vw [win] <file>`, the `win` number is shown in the statusline
vim.o.statusline = '∥ W:[%{WindowNumber()}] ∥ ' ..
        '%{expand("%:p")}%h%m%r%=%-14.(%l,%c%V%)%P'

-- Prepare neovim to be controlled from its terminal via neomux
vim.fn.setenv('NVIM_LISTEN_ADDRESS', vim.v.servername)

--local leap = require('leap')
--leap.opts.highlight_unlabeled_phase_one_targets = true

-- Personalization below this line
--

vim.cmd.colorscheme('slate')  -- set colorscheme
vim.cmd('highlight TermCursor ctermfg=red guifg=red')
vim.cmd('highlight Cursor ctermfg=yellow guifg=yellow')

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

vim.o.scrolloff = 100000  -- keep cursor in the middle of the screen

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
n_keymap('<Leader>g', ":FzfLua git_files<CR>")             -- fuzzy find git
n_keymap('<Leader>b', ":FzfLua buffers<CR>")               -- fuzzy find buffers
n_keymap('<leader>s', ":Neotree float git_status<cr>")
n_keymap('<Leader><Leader>', ':Neotree toggle<CR>')        -- toggle neotree

-- Window navigation
n_keymap('<C-j>', '<C-W>j')  -- window below
n_keymap('<C-k>', '<C-W>k')  -- window above
n_keymap('<C-h>', '<C-W>h')  -- window left
n_keymap('<C-l>', '<C-W>l')  -- window right

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
t_keymap('<F4>', '<C-\\><C-n>?ERROR:.*<CR>/.* error:<CR>0')
n_keymap('<F4>', '?ERROR:.*<CR>/.* error:<CR>0')

-- Remap <C-d> in terminal so we don't accidentally close the shell
t_keymap('<C-d>', '<Plug>x')
t_keymap('<C-;>', '<C-d>')

-- Delete the current buffer without closing the current window
n_keymap('<F9><F9>', ':Bdelete<CR>')

-- Source this file
n_keymap('<F12>', ':source ~/dotfiles2/nvim/init.lua<CR>')

-- Visual block mode when terminal thinks <C-v> is paste
n_keymap('<C-y>', '<C-v>')

-- Copy the name of the current file
n_keymap('_y', ':let @"=@%<CR>:let @+=@%<CR>')

-- Copy the name of the current file:line; useful for setting breakpoints
n_keymap('_b', [[:let @+ = expand('%:~:.') . ':' . line('.')<CR>]])

-- TODO figure out why neotree icons aren't working
-- TODO determine why shift-<Space> in a terminal window is causing strange
--      behavior
