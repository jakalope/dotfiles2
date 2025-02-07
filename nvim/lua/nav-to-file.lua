local function ExtractNumberAfterColon()
    -- Get the current line and cursor position
    local line = vim.api.nvim_get_current_line()
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

    -- Extract text from cursor position to the end of the line
    local text_after_cursor = line:sub(cursor_col + 1)

    -- Find the next colon
    local colon_index = text_after_cursor:find(":")

    if not colon_index then
        -- No colon found after the cursor, return an error or handle appropriately
        return nil
    end

    -- Extract the text after the colon
    local text_after_colon = text_after_cursor:sub(colon_index + 1)

    -- Find the first sequence of digits (assuming this is what you mean by "number")
    local number_match = text_after_colon:match("%d+")

    if not number_match then
        -- No number found after the colon, return an error or handle appropriately
        return nil
    end

    -- Return the extracted number
    return tonumber(number_match)
end

function OpenFileAtLineInWindow(window_number)
    local file = vim.fn.expand('<cfile>')
    local line = ExtractNumberAfterColon()
    vim.api.nvim_command(window_number .. 'wincmd w')
    vim.api.nvim_command('edit ' .. file)
    -- Move the cursor to the specified line if line is not nil
    if line then
        vim.api.nvim_win_call(0, function() vim.fn.cursor(line, 1) end)
    end
end

vim.api.nvim_set_keymap('n', '<Leader>w1', ':lua OpenFileAtLineInWindow(1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w2', ':lua OpenFileAtLineInWindow(2)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w3', ':lua OpenFileAtLineInWindow(3)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w4', ':lua OpenFileAtLineInWindow(4)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w5', ':lua OpenFileAtLineInWindow(5)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w6', ':lua OpenFileAtLineInWindow(6)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w7', ':lua OpenFileAtLineInWindow(7)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w8', ':lua OpenFileAtLineInWindow(8)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>w9', ':lua OpenFileAtLineInWindow(9)<CR>', { noremap = true, silent = true })
