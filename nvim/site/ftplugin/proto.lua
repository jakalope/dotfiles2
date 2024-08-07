vim.o.expandtab = true    -- use spaces instead of tabs
vim.o.number = true       -- show line numbers

local user = os.getenv("USER")
vim.o.tabstop = 2         -- width of <Tab> character (used by <Tab> and <BS>)
vim.o.shiftwidth = 2      -- indent width (used by >> and <<)
vim.o.softtabstop = 2     -- insert/delete <Space> N chars with <Tab>/<BS>

-- Set a guide bar at 80 chars (used by gq)
vim.o.colorcolumn = "80"

-- Show relative line numbers (move via [count]j or [count]k)
vim.o.relativenumber = true

-- workaround
vim.diagnostic.config({
    virtual_text = false,  -- This disables the inline display of diagnostics
    signs = false,         -- This disables the gutter signs
    underline = false,     -- This disables underlining the text
    update_in_insert = false,  -- This stops diagnostics from updating in insert mode
    severity_sort = true,
})

