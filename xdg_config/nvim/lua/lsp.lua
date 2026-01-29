require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'ts_ls', 'ruff', 'openscad_lsp'},
    automatic_installation = true,
})

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
                client.stop({ force = false })
            end
        end
    end,
})

-- local last_activity = {}
-- 
-- vim.api.nvim_create_autocmd(
--     { "BufEnter", "TextChanged", "TextChanged" },
--     {
--         callback = function(ev)
--             print(("buff enter %d"):format(ev.buf))
--             -- store last activity
--             for _, client in pairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
--                 last_activity[client.id] = vim.loop.now()
--             end
--             --print(("buff enter %d is needed %s %s"):format(ev.buf, tostring(vim.b[ev.buf].lsp_can_restart), type(ev.buf)))
--             -- restart lsp when cameback after timeout
--             if vim.b[ev.buf].lsp_can_restart then
--                 vim.b[ev.buf].lsp_can_restart = nil
--                 vim.lsp.start(vim.b[ev.buf].lsp_can_restart)
--             end
--         end,
--     }
-- )
-- 
-- -- vim.fn.timer_start(60000, function() -- check each minutes
--  vim.fn.timer_start(5000, function() -- check each minutes
--     local now = vim.loop.now()
--     for _, client in pairs(vim.lsp.get_clients()) do
--         local idle = now - (last_activity[client.id] or now)
--         print(("Last buffer activity for %s is %d"):format(client.name, idle))
-- 
--         -- if idle > 1 * 60 * 1000 then -- 15 minutes
--         if idle > 2000 then -- 15 minutes
--             local buffers = vim.lsp.get_buffers_by_client_id(client.id)
--             print(("Stop lsp server since there's no activity :%s"):format(client.name))
--             for _, buffer in ipairs(buffers) do
--                 print(("tag buffer :%d"):format(buffer, type(buffer)))
--                  vim.b[buffer].lsp_can_restart = client.config
--             end
--             client:stop()
--         end
--     end
-- end, { ["repeat"] = -1 })


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

local cmp = require('cmp')
-- local luasnip = require('luasnip')
--
cmp.setup({
    --snippet = {
    --    expand = function(args)
    --        luasnip.lsp_expand(args.body)
    --    end,
    --},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    },
    sources = cmp.config.sources({
        { name = "path" },
        { name = "nvim_lsp" },
        --{ name = 'luasnip' }, -- For luasnip users.
        {
            name = "buffer",
            option = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end,
            },
        },
    }),
})
