vim.o.expandtab = true    -- use spaces instead of tabs
vim.o.number = true       -- show line numbers
vim.o.tabstop = 4         -- width of <Tab> character (used by <Tab> and <BS>)
vim.o.shiftwidth = 4      -- indent width (used by >> and <<)
vim.o.softtabstop = 4     -- insert/delete <Space> N chars with <Tab>/<BS>

-- Set a guide bar just past an interval of 79 (pep8) chars (used by gq)
vim.o.colorcolumn = "80,160,240,320,400,480,560,640,720,800"

-- Show relative line numbers (move via [count]j or [count]k)
vim.o.relativenumber = true

