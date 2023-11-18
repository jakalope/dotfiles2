function delete_buffer()
    local current_buf = vim.api.nvim_get_current_buf()
    -- create a new empty buffer
    vim.api.nvim_command('enew')
    -- delete the old buffer
    vim.api.nvim_buf_delete(current_buf, { force = true })
end
