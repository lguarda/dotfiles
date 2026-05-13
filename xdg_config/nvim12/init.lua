# design mostly copy paste from https://github.com/boltlessengineer/NativeVim
if vim.fn.has("nvim-0.12") == 0 then
    vim.notify("only supports Neovim 0.12+", vim.log.levels.ERROR)
    return
end

-- lua 5.1 compat
if table.unpack == nil then
    table.unpack = unpack
end

require("util")
require("core.options")
require("core.autocmd")
require("core.keybind")
require("core.treesitter")
require("core.lsp")
require("core.statusline")
require("core.command")

vim.cmd.packadd("nvim.undotree")

require("plugin")
