local naughty = require("naughty")
local aw = {}

local home_dir = os.getenv('HOME')
function aw.path(path)
    return path:gsub("~", home_dir)
end

-- This helper transalte this
-- aw.cba(print, "lol") ->
-- function() print("lol") end
function aw.cba(f, ...)
    local args = {...}
    return function() f(table.unpack(args)) end
end

function aw.file_write(path, content)
    local file = io.open(path, "w")
    file:write(content)
    file:close()
end

function aw.file_read(path)
    local file = io.open(path, "r")
    local ret = file:read("a*")
    file:close()
    return ret
end

function string:trim()
    return (self:gsub("^%s*(.-)%s*$", "%1"))
end

function string:split(delimiter)
    result = {};
    local special_char_set = "().%+*?[^$"
    local escape_delimiter = ''
    for special_char in special_char_set:gmatch"." do
        if special_char == delimiter then
            escape_delimiter = '%'
        end
    end
    self = self:trim()
    for match in (self..delimiter):gmatch("(.-)"..escape_delimiter..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function aw.array_merge(a1, ...)
    for _, a2 in ipairs({...}) do
        for _,value in ipairs(a2) do
            table.insert(a1, value)
        end
    end
    return a1
end

function aw.print(text)
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "debug:",
        text = text
    })
end

return aw
