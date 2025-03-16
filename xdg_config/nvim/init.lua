-- {{{ Variables
local home = vim.env["HOME"]
local backupdir = home .. "/.vim/backup//"
-- }}}
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
vim.o.endofline = false                 -- No <EOL> will be written for the last line in the file
vim.o.number = true                     -- Display line number
vim.o.relativenumber = true             -- Display line number
vim.o.cursorline = true                 -- Highlight current line
vim.o.expandtab = true                  -- Use muliple space instead of tab
vim.o.autoindent = true                 -- Copy indent from current line when starting a new line
vim.o.smartindent = true                -- Do smart autoindenting when starting a new line
vim.o.autoread = true                   -- Change file when editing from the outside
vim.o.hlsearch = true                   -- Highligth search
vim.o.ignorecase = true                 -- Case insensitive
vim.o.smartcase = true                  -- Override the 'ignorecase' option if the search pattern contains upper case characters
vim.o.wildmenu = true                   -- Pop menu when autocomplete command
vim.o.wildignorecase = true             -- Ignore case for command completion
vim.o.infercase = true                  -- IDK just testing this option
vim.o.autochdir = true                  -- Auto change directories of file
vim.o.wrap = false                      -- Don't warp long line
vim.o.linebreak = true                  -- Break at a word boundary
vim.o.incsearch = true                  -- While typing a search command, show where the pattern is
vim.o.swapfile = false                  -- Don't use swapfile for the buffer
vim.bo.swapfile = false                 -- Don't use swapfile for the buffer
vim.o.ruler = true                      -- Show the line and column number of the cursor position
vim.o.undofile = true                   -- Use undofile
vim.o.backup = true                     -- Make a backup before overwriting a file.
vim.o.list = true                       -- Enable listchars
vim.o.fixendofline = false              -- Don't automaticaly add new line at end of file
vim.o.syntax = "on"
vim.opt.whichwrap:append("<,>,h,l,[,]") -- Move cursor to next/previous line when reach end and begin of line
vim.o.virtualedit = "onemore"           -- Allow normal mode to go one more charater at the end
vim.o.mouse = ""                        -- Disable mouse for all mode
vim.o.mousemoveevent = false
vim.opt.display:append("uhex,lastline") -- Change the way text is displayed. uhex: Show unprintable characters hexadecimal as <xx>
vim.o.backupdir = backupdir             -- List of directories for the backup file, separated with commas.

--vim.o.undodir=vim.env['HOME']/.vim/undo      -- Undofile location
--vim.o.conceallevel = 2
--vim.o.lazyredraw = true                  -- Redraw only when we need to.
--vim.o.wildmode=longest:full,full   -- Widlmenu option
--vim.o.completeopt=menuone,menu,longest,preview -- Change <ctrl+n> behavior see :h completeopt
--
--treesiteer fold is completely shitty idk why
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- The folowing option break the fold idk why see the autocommand
--vim.opt.foldlevelstart = 99
-- }}}
-- {{{ custom filetype action

vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    pattern = "*",
    command = "normal zR"
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
    command = "set spell",
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "SConscript",
    command = "set filetype=python",
})

-- This is used to have timestamped backup file
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "let &bex = '-' . strftime(\"%Y%m%d%H%M\") . '~'",
})
-- }}}
-- {{{ Auto command
-- {{{ Wrong whitespace
local wrongwhitespace = vim.api.nvim_create_augroup("wrongwhitespace", { clear = true })
local ac = vim.api.nvim_create_autocmd
ac("BufWinEnter", {
    group = wrongwhitespace,
    callback = function()
        local bname = vim.api.nvim_buf_get_name(0)
        if bname == "" then
            return
        end
        -- red highlight color for every whitechar issue
        vim.cmd.highlight("ExtraCarriageReturn", "ctermbg=red", "guibg=red")
        vim.cmd.highlight("ExtraWhitespace", "ctermbg=red", "guibg=red")
        vim.cmd.highlight("ExtraSpaceDwich", "ctermbg=red", "guibg=red")
        vim.cmd.highlight("NonBreakSpace", "ctermbg=yellow", "guibg=yellow")
        vim.cmd.highlight("EmptyChar", "ctermfg=red", "ctermbg=red", "guibg=red", "guifg=red")
        vim.cmd.highlight("currawong", "ctermbg=darkred", "guibg=darkred")

        vim.fn.matchadd("ExtraWhitespace", "\\s\\+$")
        -- Highlight mixed tab and space
        vim.fn.matchadd("ExtraSpaceDwich", " \\t\\|\\t ")
        -- Highlight windows \r
        vim.fn.matchadd("ExtraCarriageReturn", "\\r")
        -- Highlight non breaking space
        vim.fn.matchadd("NonBreakSpace", " ")
        -- Highligth other shitty white space that aren't space
        vim.fn.matchadd("EmptyChar", " ")
        vim.fn.matchadd("EmptyChar", " ")
        vim.fn.matchadd("EmptyChar", " ")
        vim.fn.matchadd("EmptyChar", " ")
        vim.fn.matchadd("EmptyChar", " ")
        vim.fn.matchadd("EmptyChar", " ")
    end,
})
-- }}}
-- {{{ Terminal specific
local function is_last_window()
    -- check for last tab
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
        return false
    end

    -- check for last split
    local counter = 0

    for i = 0, vim.fn.bufnr("$") do
        counter = counter + vim.fn.buflisted(i)
    end

    return counter <= 1
end
ac("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no laststatus=0" })
ac("TermOpen", { command = "startinsert" })
-- This one is to avoid typen enter when you ctr+d in terminal
ac("TermClose", {
    callback = function()
        if is_last_window() then
            vim.cmd("q")
        end
    end
})
ac("BufEnter", { pattern = "term://*", command = "startinsert" })
-- }}}
-- {{{ language specific
ac("BufWrite", { pattern = "*.puml", command = "silent !plantuml % &" })
ac("BufWrite", { pattern = "*.dot", command = "silent !dot -O -Tsvg % &" })
-- }}}
-- }}}
-- {{{ Key Map
local remap = vim.keymap.set
-- {{{ Nvim
remap("", "<space><space>", function()
    vim.cmd.tabedit("~/.config/nvim/init.lua")
end, { remap = true })
remap("n", "<space>r", function()
    require("plenary.reload").reload_module("~/.config/nvim/init.lua") -- replace with your own namespace
end)
remap("n", "<Tab>", ":tabnext<CR>")
remap("n", "<S-Tab>", ":tabprevious<CR>")
-- }}}
-- {{{ system ClipBoard
remap("v", "<A-c>", '"+y', { remap = true })
remap("v", "<A-v>", 'd"+P', { remap = true })
remap("n", "<A-c>", 'V"+y', { remap = true })
remap("n", "<A-v>", '"+P', { remap = true })
remap("t", "<A-v>", '<S-ESC>"+PI', { remap = true })
remap("i", "<A-v>", '<C-o>"+P', { remap = true })
remap("c", "<A-v>", "<C-r>+", { remap = true })
-- }}}
-- {{{ Resize Pane
remap("n", "<S-right>", ":vertical resize +5<CR>")
remap("n", "<S-left>", ":vertical resize -5<CR>")
remap("n", "<S-up>", "5<C-w>+")
remap("n", "<S-down>", "5<C-w>-")
-- }}}
-- {{{ Search and Replace
remap("v", "<Space>", ":s/\\s\\+$//e<CR>")                             -- "Delete Extra white sapce from selection
remap("v", "<A-r>", '"hy<ESC>:%s;<C-r>h;<C-r>h;gc<left><left><left>')  -- "Replace all selection
remap("v", "<S-r>", '"hy<ESC>:%s/<C-r>h/<C-r>0/gc<left><left><left>')  -- "Replace all selection by last yank
remap("n", "<space>", ":nohlsearch<CR>")                               -- "Stop hightliting search
remap("n", "<A-r>", 'yiw:%s/\\<<C-R>"\\>/<C-R>"/gc<left><left><left>') -- "Replace word on cursor
remap("c", "<A-r><A-r>", '<CR>:%s/<C-R>"/g<left><left>')               -- "Relplace word in yank buffer on all file
remap("v", "<A-r><A-r>", ':s/<C-R>"/<C-R>"/g<left><left>')             -- "Relplace word in yank buffer on selected zone
remap("v", "/", '"ay:let @a = "/" . escape(@a, "/")<CR>@a<CR>')        -- "Search selected Text
-- }}}
-- {{{ Navigation
remap("t", "<A-h>", "<C-\\><C-N><C-w>h")
remap("i", "<A-h>", "<C-\\><C-N><C-w>h")
remap("n", "<A-h>", "<C-w>h")

remap("t", "<A-l>", "<C-\\><C-N><C-w>l")
remap("i", "<A-l>", "<C-\\><C-N><C-w>l")
remap("n", "<A-l>", "<C-w>l")

remap("i", "<A-j>", "<C-\\><C-N>:tabprevious<CR>")
remap("n", "<A-j>", ":tabprevious<CR>")
remap("t", "<A-j>", "<C-\\><C-N>:tabprevious<CR>")

remap("i", "<A-k>", "<C-\\><C-N>:tabnext<CR>")
remap("t", "<A-k>", "<C-\\><C-N>:tabnext<CR>")
remap("n", "<A-k>", ":tabnext<CR>")
-- {{{ Terminal specific
remap("t", "<S-esc>", "<C-\\><C-n>") -- normal mode
remap("t", "<MouseMove>", "<NOP>")   -- mouse isn't well handled for now
-- GUI seems ti send some weird shit with this so we disable it
remap("t", "<S-BS>", "<nop>")
remap("t", "<S-D-BS>", "<nop>")
remap("t", "<S-A-BS>", "<nop>")
remap("t", "<S-CR>", "<nop>")
remap("t", "<S-D-CR>", "<nop>")
remap("t", "<S-A-CR>", "<nop>")
remap("t", "<S-space>", "<nop>")
remap("t", "<S-A-space>", "<nop>")
remap("t", "<S-D-space>", "<nop>")
-- }}}
-- }}}
vim.api.nvim_create_user_command("OpenscadOpen", function()
    vim.fn.execute(("!openscad %s &"):format(vim.fn.expand("%p")))
end, {})
-- {{{ Formating
local function toggle_conf(scope, conf)
    local opt_type = type(vim[scope][conf])
    local old_value
    if opt_type == "table" then
        old_value = vim[scope][conf]:get()
    elseif opt_type == "boolean" then
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
remap("n", "<A-k>", '"mddk"mP==')       -- move current line up
remap("n", "<A-j>", '"mdd"mp==')        -- move current line down
remap("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move selecion up
remap("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move selecion down
remap("v", "<Tab>", ">gv")              -- indent up
remap("v", "<S-Tab>", "<gv")            -- indent down
-- }}}
--{{{ Action
remap("n", "<space>x", "<cmd>!chmod +x %<CR>", { silent = true })
remap("n", "x", '"_x', { silent = true })
remap("n", "X", '"_X', { silent = true })
remap("n", "<S-z><S-s>", ":execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>")
remap("v", "@", ":normal @r<CR>")
remap("n", "-<S-o>", ":vertical sbuffer 2<CR>")

--}}}
-- {{{ Gui
local default_font = "Mononoki Nerd Font"
local default_font_size = 8
local font_size = default_font_size

local function set_font_size()
    print()
    vim.o.guifont = ("%s:h%s"):format(default_font, font_size)
end

local function mod_font_size(delta)
    font_size = font_size + delta
    set_font_size()
end
set_font_size()

remap("n", "<c-->", function()
    mod_font_size(-1)
end)
remap("n", "<c-=>", function()
    mod_font_size(1)
end)
remap("t", "<c-->", function()
    mod_font_size(-1)
end)
remap("t", "<c-=>", function()
    mod_font_size(1)
end)

-- neovide option
vim.g.neovide_scroll_animation_length = 0

-- }}}
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

if vim.g.started_by_firenvim == true then
    vim.o.laststatus = 0
    vim.o.number = false
    vim.o.relativenumber = false
end
vim.g.firenvim_config = {
    localSettings =
    {
        ['.*'] = {
            takeover = 'never'
        }
    }
}

vim.opt.rtp:prepend(lazypath)
--}}}
--{{{ lazy plugin list
require("lazy").setup({
    {
        'glacambre/firenvim',
        -- Lazy load firenvim
        -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
        lazy = not vim.g.started_by_firenvim,
        build = function()
            vim.fn["firenvim#install"](0)
        end,
        config = function()
        end
    },
    "aklt/plantuml-syntax",
    "godlygeek/tabular",
    "fidian/hexmode",
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                    -- this will enable highlight with set spell for example
                    --additional_vim_regex_highlighting = true,
                },
                ensure_installed = {
                    "c",
                    "lua",
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
            })
        end,
    },
    { -- {{{ telescope
        "nvim-telescope/telescope.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<space>fo", builtin.oldfiles, {})
            vim.keymap.set("n", "<space>ff", builtin.find_files, {})
            vim.keymap.set("n", "<space>fg", function()
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
        end,
    }, -- }}}
    {  -- {{{ hop
        'smoka7/hop.nvim',
        version = "*",
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
    }, -- }}}
    {  -- {{{ neotree
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
    }, --}}}
    {
        "wesleimp/stylua.nvim",
        config = function()
            local stylua = require("stylua")
            vim.api.nvim_create_user_command("LuaFormat", function()
                stylua.format()
            end, {})
        end,
    },
    { -- {{{ lsp-zero
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
            --'saadparwaiz1/cmp_luasnip',
            --"rafamadriz/friendly-snippets",
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

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- An example for configuring `clangd` LSP to use nvim-cmp as a completion engine
            require('lspconfig').clangd.setup {
                capabilities = capabilities,
            }
            -- (Optional) Configure lua language server for neovim
            require("lspconfig").lua_ls.setup {
                capabilities = capabilities,
            }
            require("lspconfig").clangd.setup {
                capabilities = capabilities,
            }
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
        end,
    }, -- }}}
    {
        "VDuchauffour/neodark.nvim",
        config = function()
            require("neodark").setup({
                theme_style = "neodarker",
            })
        end,
    },
    "tpope/vim-fugitive",
    { -- {{{ gitsign
        "lewis6991/gitsigns.nvim",
        config = function()
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
        end,
    }, --}}}
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false,
    },
})
-- }}}
-- {{{ Command

local function gdb_addr()
    local str = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
    vim.fn.setreg("+", str)
    vim.fn.setreg('"', str)
    print(("%s copied to clipbboard !"):format(str))
end

vim.api.nvim_create_user_command("GdbAddr", function()
    gdb_addr()
end, {})

local function merge_tab()
    local buff_list = vim.fn.tabpagebuflist()
    vim.cmd("tabclose")
    for _, bn in pairs(buff_list) do
        vim.cmd("vertical sbuffer " .. tostring(bn))
    end
    vim.cmd("wincmd =")
end
vim.api.nvim_create_user_command("MergeTab", function()
    merge_tab()
end, {})

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
-- }}}
-- vim700: set sw=4 ts=4 fdm=marker
