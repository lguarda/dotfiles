require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'ts_ls', 'ruff', 'openscad_lsp'},
    automatic_installation = true,
})

vim.keymap.set('n', 'gK', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

local lspconfig = require('lspconfig')

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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

lspconfig.marksman.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.openscad_lsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.clangd.setup {
    on_attach = on_attach,
    cmd = { "clangd", "--header-insertion=never" },
    capabilities = capabilities,
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
    end,
}

lspconfig.ruff.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        settings = {
            -- Ruff language server settings go here
        }
    }
})

require("lspconfig").rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

require("lspconfig").jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

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
