---Show attached LSP clients in `[name1, name2]` format.
---Long server names will be modified. For example, `lua-language-server` will be shorten to `lua-ls`
---Returns an empty string if there aren't any attached LSP clients.
---@return string
local function lsp_status()
    local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #attached_clients == 0 then
        return ""
    end
    local names = vim.iter(attached_clients)
        :map(function(client)
            local name = client.name:gsub("language.server", "ls")
            return name
        end)
        :totable()
    return ("[%s:%s]"):format(vim.ui.progress_status(), table.concat(names, ", "))
end

---Fake vim mode string base on current mode
---@return string
local function mode_str()
    local modes = {
        n = 'NORMAL',
        i = 'INSERT',
        v = 'VISUAL',
        V = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        c = 'COMMAND',
        t = 'TERMINAL',
    }
    return modes[vim.fn.mode()] or vim.fn.mode()
end

function _G.statusline()
    return table.concat({
        mode_str(),
        "%f",              -- current file
        "%h%w%m%r",        -- change status
        "%=",              -- separation
        lsp_status(),
        " %-14(%l,%c%V%)", -- buffer line h&v
        "%S",              -- showcmd content (i use it to count number of line selected)
        "%P",              -- Percentage through file of displayed window
    }, " ")
end

vim.o.statusline = "%{%v:lua._G.statusline()%}"
