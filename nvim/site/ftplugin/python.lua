vim.o.expandtab = true    -- use spaces instead of tabs
vim.o.number = true       -- show line numbers
vim.o.tabstop = 4         -- width of <Tab> character (used by <Tab> and <BS>)
vim.o.shiftwidth = 4      -- indent width (used by >> and <<)
vim.o.softtabstop = 4     -- insert/delete <Space> N chars with <Tab>/<BS>

-- Show relative line numbers (move via [count]j or [count]k)
vim.o.relativenumber = true

local function set_colorcolumn_from_pycodestyle()
    local handle = io.popen("grep '^max-line-length' ~/.config/pycodestyle | cut -d '=' -f2 | tr -d ' '")
    local max_length = handle:read("*a")
    handle:close()

    max_length = max_length:gsub("%s+", "")
    max_length = tonumber(max_length) or 80  -- Use 80 as default if conversion fails

    -- Calculate colorcolumn positions at intervals of max_length
    local columns = {}
    for i = 1, 10 do  -- Assuming you won't need more than 10 intervals
        table.insert(columns, i * max_length)
        if i * max_length > 500 then  -- Assuming a reasonable max width to avoid performance issues
            break
        end
    end

    -- Join the column positions with commas for the 'colorcolumn' option
    vim.o.colorcolumn = table.concat(columns, ",")
end

set_colorcolumn_from_pycodestyle()
