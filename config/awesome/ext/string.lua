function string:startswith(value)
	-- True to disable pattern matching
	local find_start, _ = self:find(value, 1, true)
	return (find_start and find_start == 1) or false
end

function string:endswith(value)
	-- True to disable pattern matching
	local index_start = self:len() + 1 - value:len()
	local find_start, _ = self:find(value, index_start, true)
	return (find_start and find_start == index_start) or false
end

---@param self string
function string:trim()
    return (self:gsub("^%s*(.-)%s*$", "%1"))
end

---@param self string
---@param delimiter string
---@return string[]
function string:split(delimiter)
    local result = {};
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

function string:tohex()
    return (self:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end
