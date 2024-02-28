-- Setup language servers.
function getUserName()
    local handle = io.popen("whoami")
    local result = handle:read("*a")
    handle:close()
    return result:match("^%s*(.-)%s*$")  -- Trim
end

local max_length_python = 79
if getUserName() == "jaskeland" then
    max_length_python = 100
end

function checkLogs()
    vim.cmd('e'..vim.lsp.get_log_path())
end

local lspconfig = require('lspconfig')
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {}

lspconfig.clangd.setup{
    cmd = { "clangd",
            "--suggest-missing-includes",
            "--malloc-trim",
            "--background-index",
            "-j=16",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--header-insertion=never",
            "--clang-tidy",
            "--log=info",
            "--fallback-flags=-std=c++14",
            "--query-driver=/usr/bin/g++*,external/**/bin/*g++*," ..
                "/**/external/**/bin/*g++*,external/**/bin/q++," ..
                "/**/external/**/bin/q++"
        },
    on_attach = function(client, bufnr)
        -- Custom on_attach function, if needed
    end,
    flags = {
        debounce_text_changes = 150,
    }
}

-- lspconfig.pylsp.setup is handled by ~/.config/pycodestyle
--   [pycodestyle]
--   max-line-length = 100

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

