local remap = vim.keymap.set
-- {{{ Nvim
remap('i', '<Tab>', '<Tab>', { noremap = true }) -- neovim map this to a weird shit that break neovim so let's unbind it
remap("", "<space><space>", function()
    vim.cmd.tabedit("~/.config/nvim/init.lua")
end, { remap = true })
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
for i = 1, 5 do
    local tabnex = function()
        vim.cmd(i .. "tabnext")
    end
    remap({ "n", "t", "i" }, "<A-" .. i .. ">", tabnex)
end
remap({ "n", "t", "i" }, "<A-j>", vim.cmd.tabprevious, { desc = "Go to previous tab" })
remap({ "n", "t", "i" }, "<A-k>", vim.cmd.tabnext, { desc = "Go to next tab" })
remap({ "n", "t", "i" }, "<A-h>", function() vim.cmd.wincmd("h") end, { desc = "Move to left buffer" })
remap({ "n", "t", "i" }, "<A-l>", function() vim.cmd.wincmd("l") end, { desc = "Move to right buffer" })
remap({ "n", "t", "i" }, "<A-d>", vim.cmd.tabclose, { desc = "Close current tab" })

remap("c", "<c-a>", "<c-b>", { desc = "Go to begin cmd line" })

-- }}}
-- {{{ Terminal specific
remap("t", "<S-esc>", "<C-\\><C-n>")                                                                   -- normal mode
remap("t", "<MouseMove>", "<NOP>")                                                                     -- mouse isn't well handled for now
remap("t", "<c-w><c-l>", "<c-l><c-\\><c-n>:set scrollback=1 | sleep 100m | set scrollback=10000<CR>i") --clear terminal and history
-- }}}
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
remap("n", "<S-A-k>", '"mddk"mP==')       -- move current line up
remap("n", "<S-A-j>", '"mdd"mp==')        -- move current line down
remap("v", "<S-A-k>", ":m '<-2<CR>gv=gv") -- move selecion up
remap("v", "<S-A-j>", ":m '>+1<CR>gv=gv") -- move selecion down
remap("v", "<Tab>", ">gv")                -- indent up
remap("v", "<S-Tab>", "<gv")              -- indent down
-- }}}
--{{{ Action
remap("n", "<space>d", ":w !diff -u % -<CR>")                     -- Show current unsaved modification diff
remap("n", "<space>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- Make current file executable
remap("n", "x", '"_x', { silent = true })
remap("n", "X", '"_X', { silent = true })
remap("n", "<S-z><S-s>", ":execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>")
remap("v", "@", ":normal @r<CR>")
remap("n", "-<S-o>", ":vertical sbuffer 2<CR>")

local function switch_case()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local word = vim.fn.expand('<cword>')
    local word_start = vim.fn.matchstrpos(vim.fn.getline('.'), '\\k*\\%' .. (col + 1) .. 'c\\k*')[2]

    -- Detect camelCase
    if word:find('[a-z][A-Z]') then
        -- Convert camelCase to snake_case
        local snake_case_word = word:gsub('([a-z])([A-Z])', '%1_%2'):lower()
        vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
        -- Detect snake_case
    elseif word:find('_[a-z]') then
        -- Convert snake_case to camelCase
        local camel_case_word = word:gsub('(_)([a-z])', function(_, l) return l:upper() end)
        vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
    else
        print("Not a snake_case or camelCase word")
    end
end

remap('n', '<space>s', '', { noremap = true, silent = true, callback = switch_case })
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

-- vim: set sw=4 ts=4 foldmethod=marker:
