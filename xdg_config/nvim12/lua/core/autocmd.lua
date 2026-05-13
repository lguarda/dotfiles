-- {{{ Wrong whitespace
local wrongwhitespace = vim.api.nvim_create_augroup("wrongwhitespace", { clear = true })
local ac = vim.api.nvim_create_autocmd
ac("BufWinEnter", {
    group = wrongwhitespace,
    callback = function()
        -- Detect non-file
        if vim.bo.buftype ~= "" then
            vim.fn.clearmatches()
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
local function get_buffers(options)
    local buffers = {}

    for buffer = 1, vim.fn.bufnr('$') do
        local is_listed = vim.fn.buflisted(buffer) == 1
        if not (options.listed and is_listed) then
            table.insert(buffers, buffer)
        end
    end

    return buffers
end
local function is_last_window()
    -- check for last tab
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
        return false
    end

    -- check for last split
    local counter = #get_buffers({ listed = true })
    return counter <= 1
end
vim.api.nvim_create_autocmd('TermOpen', {
    desc = "Disable number status line and sign",
    callback = function()
        vim.wo.statusline = 0
        vim.wo.number = true
        vim.wo.relativenumber = false
        vim.wo.signcolumn= "no"
    end,
})

--ac("TermOpen", { command = "setlocal nonumber norelativenumber signcolumn=no laststatus=0" })
ac("TermOpen", { desc = "Start with insert mode when openging terminal", command = "startinsert" })
ac("TermOpen", { desc = "Remove matches highlight when openging terminal",
    callback = function()
        vim.fn.clearmatches()
    end,
})

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
vim.api.nvim_create_user_command("ShowPuml", function()
    local file = vim.fn.expand("%p"):match("^(.+)%..+$") .. ".png"
    print(file)
    vim.fn.execute(("!sxiv %s &"):format(file))
end, {})
-- Enable spell by default on git commit,rebase
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "COMMIT_EDITMSG", "git-rebase-todo" },
    command = "set spell",
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "SConscript",
    command = "set filetype=python",
})
-- }}}
-- {{{ GUI
-- This is needed so when you close a vim gui like neovide it will really kill everything attached to it
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.cmd("silent! bufdo if &buftype=='terminal' | bd! | endif")
        vim.cmd("qa!")
    end,
})
-- }}}
-- vim: set sw=4 ts=4 foldmethod=marker:
