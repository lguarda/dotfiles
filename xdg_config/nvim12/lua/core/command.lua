
vim.api.nvim_create_user_command("OpenscadOpen", function()
    vim.fn.execute(("!openscad %s &"):format(vim.fn.expand("%p")))
end, {})

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

vim.api.nvim_create_user_command("A", function()
    vim.fn.execute('ClangdSwitchSourceHeader')
end, {})

vim.api.nvim_create_user_command("AV", function()
    vim.fn.execute('vsp | ClangdSwitchSourceHeader')
end, {})

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

-- This Command will remove all unnecessary feature
-- making neovim nice to be used as an overlay window client
vim.api.nvim_create_user_command("Overlay", function()
    vim.o.cmdheight = 0
    vim.o.number = false
    vim.o.wrap = true
    vim.o.showtabline = 0
    vim.o.relativenumber = false
    vim.o.signcolumn = "auto"
    vim.g.neovide_opacity = 0.7
    vim.opt.foldmethod = "marker"
end, {})

vim.api.nvim_create_user_command('WipeWindowlessBufs', function()
    local bufinfos = vim.fn.getbufinfo({ buflisted = true })
    vim.tbl_map(function(bufinfo)
        if bufinfo.changed == 0 and (not bufinfo.windows or #bufinfo.windows == 0) then
            print(('Deleting buffer %d : %s'):format(bufinfo.bufnr, bufinfo.name))
            -- vim.api.nvim_buf_delete(bufinfo.bufnr, { force = false, unload = true })
            -- needed for BufDelete event
            vim.cmd({ cmd = "bdelete", args = { bufinfo.bufnr } })
        end
    end, bufinfos)
end, { desc = 'Wipeout all buffers not shown in a window' })

-- vim: set sw=4 ts=4:
