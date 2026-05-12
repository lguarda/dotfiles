vim.keymap.set('n', 'gK', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, silent = true }
    local map = vim.keymap.set
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    map('n', 'gR', vim.lsp.buf.rename, opts)
    --map('n', '<leader>rn', vim.lsp.buf.rename, opts)
    map('n', '<f3>', vim.lsp.buf.format, opts)
    map('n', '<f4>', vim.lsp.buf.code_action, opts)
    --map('n', '[d', vim.diagnostic.goto_prev, opts)
    --map('n', ']d', vim.diagnostic.goto_next, opts)
end

vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(args)
        local clients = vim.lsp.get_clients()
        for _, client in ipairs(clients) do
            local buffers = vim.lsp.get_buffers_by_client_id(client.id)
            if #buffers == 0 then
                print(("Stop lsp server since it's not attached to any buffer:%s"):format(client.name))
                client:stop({ force = false })
            end
        end
    end,
})

local lsps = {
    { "lua_ls", {
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    }
    },
    { "clangd", {
        on_attach = on_attach,
        cmd = { "clangd", "--header-insertion=never" },
        on_init = function(client, _)
            client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
        end,

    } },
    { "marksman" },
    { "openscad_lsp" },
    { "ts_ls" },
    { "ruff" },
    { "rust_analyzer" },
    { "jsonls" },
}

for _, lsp in ipairs(lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)
    if config then
        vim.lsp.config(name, config)
    end
end

vim.diagnostic.config({
    --virtual_lines = true,
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
    float = { border = 'rounded' },
})

