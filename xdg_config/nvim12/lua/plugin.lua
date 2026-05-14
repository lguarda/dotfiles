vim.pack.add({
    { src = "https://github.com/lguarda/nvim-unception" },
})

if vim.g.unception_open_buffer_in_new_tab == nil then
    vim.g.unception_open_buffer_in_new_tab = true
end
if vim.g.unception_multi_file_open_method == nil then
    vim.g.unception_multi_file_open_method = "tab"
end

vim.pack.add({ { src = 'https://github.com/neovim/nvim-lspconfig' } })

vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<space>ff", builtin.find_files, {})
vim.keymap.set("n", "<space>fg", function()
    builtin.git_files({ recurse_submodules = true })
end
, {})
vim.keymap.set("n", "<S-Space>fg", function()
    builtin.git_files({ recurse_submodules = true })
end
, {})
vim.keymap.set("n", "<space>g", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<space>vh", builtin.help_tags, {})

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

vim.pack.add({ 'https://github.com/smoka7/hop.nvim' })

local hop = require("hop")
hop.setup({ keys = "etovxqpdygfblzhckisuran" })
local directions = require("hop.hint").HintDirection
vim.keymap.set("", "f", function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("", "F", function()
    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("", "W", function()
    hop.hint_camel_case()
end, { remap = true })


vim.pack.add({ 'https://github.com/williamboman/mason.nvim' })
require("mason").setup()

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "≈" },
        untracked = { text = "┆" },
    },
})

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup()
vim.keymap.set("", "<C-g>", "<CMD>lua require('oil').toggle_float()<CR>",
    { desc = "Open parent directory", noremap = true, silent = true })

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require('nvim-treesitter').install { 'rust', 'javascript', 'python', "typescript", "fish", "cpp", "bash" }

vim.pack.add { { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } }
vim.cmd.colorscheme "catppuccin-mocha"

