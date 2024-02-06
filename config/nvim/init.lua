-- {{{ Settings
-- number settings
vim.o.scrolloff = 10     -- scroll terminal when cursor is N line from the top or botom
vim.o.showtabline = 1    -- Enable tabline
vim.o.numberwidth = 1    -- Minimum number column size
vim.o.tabstop = 4        -- Redefine tab display as n space
vim.o.softtabstop = 4
vim.o.shiftwidth = 4     -- Number of spaces to use for each step of (auto)indent
vim.o.laststatus = 2     -- Always show status line
vim.o.cmdheight = 1      -- Number of screen lines to use for the command-line
vim.o.history = 10000    -- A history of ":" commands, and a history of previous search patterns is remembered
vim.o.sidescroll = 1     -- The minimal number of columns to scroll horizontally
vim.o.sidescrolloff = 10 -- scroll terminal when cursor is N line from the left or right
vim.o.scrolloff = 10     -- scroll terminal when cursor is N line from the top or botom
vim.o.timeoutlen = 300   -- scroll terminal when cursor is N line from the top or botom

-- boolean settings
vim.o.endofline = false     -- No <EOL> will be written for the last line in the file
vim.o.number = true         -- Display line number
vim.o.relativenumber = true -- Display line number
vim.o.cursorline = true     -- Highlight current line
vim.o.expandtab = true      -- Use muliple space instead of tab
vim.o.autoindent = true     -- Copy indent from current line when starting a new line
vim.o.smartindent = true    -- Do smart autoindenting when starting a new line
vim.o.autoread = true       -- Change file when editing from the outside
vim.o.hlsearch = true       -- Highligth search
vim.o.ignorecase = true     -- Case insensitive
vim.o.smartcase = true      -- Override the 'ignorecase' option if the search pattern contains upper case characters
vim.o.wildmenu = true       -- Pop menu when autocomplete command
vim.o.wildignorecase = true -- Ignore case for command completion
vim.o.infercase = true      -- IDK just testing this option
vim.o.autochdir = true      -- Auto change directories of file
vim.o.wrap = false          -- Don't warp long line
vim.o.linebreak = true      -- Break at a word boundary
--vim.o.lazyredraw = true                  -- Redraw only when we need to.
vim.o.incsearch = true      -- While typing a search command, show where the pattern is
vim.o.swapfile = false      -- Don't use swapfile for the buffer
vim.bo.swapfile = false     -- Don't use swapfile for the buffer
vim.o.ruler = true          -- Show the line and column number of the cursor position
vim.o.undofile = true       -- Use undofile
vim.o.backup = true         -- Make a backup before overwriting a file.
vim.o.list = true           -- Enable listchars
--vim.o.conceallevel = 2

vim.o.syntax = "on"
vim.opt.whichwrap:append("<,>,h,l,[,]")               -- Move cursor to next/previous line when reach end and begin of line
--vim.o.wildmode=longest:full,full   -- Widlmenu option
vim.o.virtualedit = "onemore"                         -- Allow normal mode to go one more charater at the end
--vim.o.mouse=a                      -- Set mouse for all mode
vim.opt.display:append("uhex,lastline")               -- Change the way text is displayed. uhex: Show unprintable characters hexadecimal as <xx>
--vim.o.undodir=vim.env['HOME']/.vim/undo      -- Undofile location
vim.o.backupdir = vim.env['HOME'] .. '/.vim/backup//' -- List of directories for the backup file, separated with commas.
--vim.o.completeopt=menuone,menu,longest,preview -- Change <ctrl+n> behavior see :h completeopt
-- }}}
-- {{{ Auto command
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.expand("%") == "init.lua" then
            vim.opt.foldmethod = "marker"
        end
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.expand("%") == "init.lua" then
            vim.opt.foldmethod = "marker"
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "COMMIT_EDITMSG",
    command = "set spell"
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "SConscript",
    command = "set filetype=python",
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "let &bex = '-' . strftime(\"%Y%m%d%H%M\") . '~'",
})
-- {{{ Wrong whitespace
vim.cmd([[
" red highlight color for every whitechar issue
highlight ExtraCarriageReturn ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraSpaceDwich ctermbg=red guibg=red
highlight NonBreakSpace ctermbg=yellow guibg=yellow
highlight EmptyChar ctermfg=red ctermbg=red guibg=red guifg=red
highlight currawong ctermbg=darkred guibg=darkred
]])

local wrongwhitespace = vim.api.nvim_create_augroup("wrongwhitespace", { clear = true })
local ac = vim.api.nvim_create_autocmd
-- Highlight white space at end of line
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('ExtraWhitespace', '\\s\\+$')" })
-- Highlight mixed tab and space
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('ExtraSpaceDwich', ' \\t\\|\\t ')" })
-- Highlight windows \r
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('ExtraCarriageReturn', '\\r')" })
-- Highlight non breaking space
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('NonBreakSpace', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', ' ')" })
ac("BufWinEnter", { group = wrongwhitespace, command = "exec matchadd('EmptyChar', '　')" })
--}}}
--}}}
-- {{{ Key Map
local remap = vim.keymap.set
-- {{{ Nvim
remap("", "<space><space>", function()
    vim.cmd.tabedit("~/.config/nvim/init.lua")
end, { remap = true })
remap("n", "<space>r", function()
    require("plenary.reload").reload_module("~/.config/nvim/init.lua") -- replace with your own namespace
end)
remap("n", "<Tab>", ":tabnext")
remap("n", "<S-Tab>", ":tabprevious")
-- }}}
-- {{{ system ClipBoard
remap("v", "<M-c>", '"+2yy', { remap = true })
remap("v", "<M-v>", 'd"+P', { remap = true })
remap("n", "<M-v>", '"+P', { remap = true })
remap("i", "<M-v>", '<C-o>"+P', { remap = true })
-- }}}
-- {{{ Resize Pane
remap("n", "<S-right>", ":vertical resize +5<CR>")
remap("n", "<S-left>", ":vertical resize -5<CR>")
remap("n", "<S-up>", "5<C-w>+")
remap("n", "<S-down>", "5<C-w>-")
-- }}}
-- {{{ Search and Replace
remap("v", "<Space>", ":s/\\s\\+$//e<CR>")                             -- "Delete Extra white sapce from selection
remap("v", "<M-r>", '"hy<ESC>:%s;<C-r>h;<C-r>h;gc<left><left><left>')  -- "Replace all selection
remap("v", "<S-r>", '"hy<ESC>:%s/<C-r>h/<C-r>0/gc<left><left><left>')  -- "Replace all selection by last yank
remap("n", "<space>", ":nohlsearch<CR>")                               -- "Stop hightliting search
remap("n", "<M-r>", 'yiw:%s/\\<<C-R>"\\>/<C-R>"/gc<left><left><left>') -- "Replace word on cursor
remap("c", "<M-r><M-r>", '<CR>:%s/<C-R>"/g<left><left>')               -- "Relplace word in yank buffer on all file
remap("v", "<M-r><M-r>", ':s/<C-R>"/<C-R>"/g<left><left>')             -- "Relplace word in yank buffer on selected zone
remap("v", "/", '"ay:let @a = "/" . escape(@a, "/")<CR>@a<CR>')        -- "Search selected Text
-- }}}
-- {{{ Navigation
remap("t", "<A-h>", "<C-\\><C-N><C-w>h")
remap("t", "<A-j>", "<C-\\><C-N><C-w>j")
remap("t", "<A-k>", "<C-\\><C-N><C-w>k")
remap("t", "<A-l>", "<C-\\><C-N><C-w>l")
remap("i", "<A-h>", "<C-\\><C-N><C-w>h")
remap("i", "<A-j>", "<C-\\><C-N><C-w>j")
remap("i", "<A-k>", "<C-\\><C-N><C-w>k")
remap("i", "<A-l>", "<C-\\><C-N><C-w>l")
remap("n", "<Tab>", ":tabnext<CR>")
remap("n", "<S-Tab>", ":tabprevious<CR>")
remap("n", "<A-h>", "<C-w>h")
remap("n", "<A-l>", "<C-w>l")
--remap('n', '<A-j>', '<C-w>j')
--remap('n', '<A-k>', '<C-w>k')
-- }}}
-- {{{ Formating
local function toggle_conf(scope, conf)
    local opt_type = type(vim[scope][conf])
    local old_value
    if opt_type == 'table' then
        old_value = vim[scope][conf]:get()
    elseif opt_type == 'boolean' then
        old_value = vim[scope][conf]
    else
        error(("%s not handled when toggle conf"):format(opt_type))
    end
    vim[scope][conf] = not old_value
    print(("%s:%s set to %s"):format(scope, conf, not old_value))
end
remap("n", "<space>e", function()
    toggle_conf("bo", "expandtab")
end) -- "Toggle expandtab
remap("n", "<space>w", function()
    toggle_conf("opt_local", "wrap")
end) -- "Toggle expandtab

-- Move text around
remap("n", "<A-k>", '"mddk"mP==') -- move current line up
remap("n", "<A-j>", '"mdd"mp==') -- move current line down
remap("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move selecion up
remap("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move selecion down
remap("v", "<Tab>", ">gv") -- indent up
remap("v", "<S-Tab>", "<gv") -- indent down
-- }}}
--{{{ Action
remap("n", "<space>x", "<cmd>!chmod +x %<CR>", { silent = true })
remap("n", "x", '"_x', { silent = true })
remap("n", "X", '"_X', { silent = true })
remap("n", "<S-z><S-s>", ":execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>")
remap("v", "@", ":normal @r<CR>")
remap("n" , "-<S-o>", ":vertical sbuffer 2<CR>")
--}}}
remap("n", "<M-y>", 'qaq:g/<C-R>//y A<CR>:let @a=@"<CR>', {})
-- }}}
-- {{{ Ensure lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
--}}}
--{{{ lazy plugin list
require("lazy").setup({
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("kanagawa-dragon")
            vim.cmd("hi LineNr guibg=none ctermbg=none")
            vim.cmd("hi SignColumn guibg=none ctermbg=none")
            vim.cmd("hi GitSignsAdd guibg=none ctermbg=none")
            vim.cmd("hi GitSignsChange guibg=none ctermbg=none")
            vim.cmd("hi GitSignsDelete guibg=none ctermbg=none")
        end,
    },
    { "vim-scripts/a.vim" },
    { "jakemason/ouroboros", dependencies = "nvim-lua/plenary.nvim" },
    --{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
    "fidian/hexmode",
    "godlygeek/tabular",
    "mbbill/undotree",
    "tpope/vim-fugitive",
    {
        --"ThePrimeagen/refactoring.nvim",
        "lguarda/refactoring.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
            { "nvim-treesitter/playground" },
        },
        config = function()
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.groovy = {
                install_info = {
                    url = "~/projects/tree-sitter-zimbu",   -- local path or git repo
                    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
                },
                filetype = "Jenkinsfile",                   -- if filetype does not match the parser name
            }
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true, -- <= THIS LINE is the magic!
                },
                ensure_installed = {
                    "c",
                    "lua",
                    "teal",
                    "vim",
                    "query",
                    "regex",
                    "bash",
                    "markdown",
                    "markdown_inline",
                    "python",
                    --"git-config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                },
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = "o",
                        toggle_hl_groups = "i",
                        toggle_injected_languages = "t",
                        toggle_anonymous_nodes = "a",
                        toggle_language_display = "I",
                        focus_language = "f",
                        unfocus_language = "F",
                        update = "R",
                        goto_node = "<cr>",
                        show_help = "?",
                    },
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<space>fo", builtin.oldfiles, {})
            vim.keymap.set("n", "<space>ff", builtin.find_files, {})
            vim.keymap.set("n", "<space>fg", builtin.git_files, {})
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
        end,
    },
    {
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
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
                hop.hint_words()
            end, { remap = true })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.keymap.set("", "<C-g>", ":NeoTreeFocusToggle<CR>", { noremap = true, silent = true })
            vim.keymap.set("", "<C-x><C-g>", function()
                vim.cmd.Neotree(".")
            end, { noremap = true, silent = true })
        end,
    },
    {
        "wesleimp/stylua.nvim",
        config = function()
            local stylua = require("stylua")
            vim.api.nvim_create_user_command("LuaFormat", function()
                stylua.format()
            end, {})
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig", -- Required
            {
                -- Optional
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            "williamboman/mason-lspconfig.nvim", -- Optional

            -- Autocompletion
            "hrsh7th/nvim-cmp",     -- Required
            "hrsh7th/cmp-nvim-lsp", -- Required
            "L3MON4D3/LuaSnip",     -- Required
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd", "pylsp" },
            })

            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(_, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            -- (Optional) Configure lua language server for neovim
            require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
            require("lspconfig").clangd.setup({})
            require("lspconfig").pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            -- formatter options
                            black = { enabled = true },
                            pycodestyle = {
                                ignore = { "W391", "E501" },
                                maxLineLength = 200,
                            },
                        },
                    },
                },
            })
            require("lspconfig").rust_analyzer.setup({})

            lsp.setup()
            -- Make sure you setup `cmp` after lsp-zero

            local cmp = require("cmp")
            -- local cmp_action = require('lsp-zero').cmp_action()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                },
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- For luasnip users.
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
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    "sindrets/diffview.nvim",
})
-- }}}
--{{{ Command
vim.api.nvim_create_user_command("JsonIndent", function()
    vim.fn.execute(':%!jq "."')
end, {})

vim.api.nvim_create_user_command("JsonIndentSort", function()
    vim.fn.execute(':%!jq --sort-keys "."')
    vim.fn.execute(':%!jq "walk(if type == "array" then sort else . end)"')
end, {})

vim.api.nvim_create_user_command("JsonIndentMimify", function()
    vim.fn.execute(':%!jq -c "."')
end, {})

vim.api.nvim_create_user_command("YamlIndent", function()
    vim.fn.execute(':%!yq -y "."')
end, {})
vim.api.nvim_create_user_command("YamlIndentSort", function()
    vim.fn.execute(':%!yq -y --sort-keys "."')
end, {})
vim.api.nvim_create_user_command("YamlIndentMimify", function()
    vim.fn.execute(':%!yq -y -c "."')
end, {})
--}}}

-- vim600: et sw=4 ts=4 fdm=marker
