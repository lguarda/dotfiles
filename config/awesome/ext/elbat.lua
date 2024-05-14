---This class provide basic function for tables and array handling
---Function are prefixed with t_ or a_ for table and array
---@class elbat
local elbat = {}

---@param t1 table
---@param t2 table
---@param ignore_mt boolean disable __eq memethod
---@return boolean
function elbat.t_deep_equal(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then
        return false
    end
    -- Non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then
        return t1 == t2
    end
    -- As well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then
        return t1 == t2
    end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepequals(v1, v2) then
            return false
        end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepequals(v1, v2) then
            return false
        end
    end
    return true
end

---This function create shallow copy of the given table.
---This mean that any nested table with be shared with the original table
---@param orig table
---@return table
function elbat.t_shallow_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- Number, string, boolean, etc
        copy = orig
    end
    return copy
end

---This function create deep copy of the given table.
---Any change within the returned table will not have any impact the original table
---@param orig table
---@return table
function elbat.t_deepcopy(orig )
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- Number, string, boolean, etc
        copy = orig
    end
    return copy
end

---@class elbat_dyn_lut
---@field key any
---@field func fun(...): any
---@field args any[]|nil

---func will be called with the concerned table in first argument and all args will be passed after the table
---@param t table
---@param dynamic_lut elbat_dyn_lut
function elbat.bind_dymanic_lut_build(t, dynamic_lut)
    setmetatable(t, {
        __index = function(table, key)
            local fetch_info = dynamic_lut[key]
            if not fetch_info then
                return nil
            end
            local ret = fetch_info.func(table, fetch_info.args and unpack(fetch_info.args) or nil)
            table[key] = ret

            return ret
        end
    })
end

--local toto =  {}
--
--elbat.bind_dymanic_lut_build(toto, {
--    key="a",
--    func=function() print("toto") end,
--})

---Merge multiple array into the first given array
---@param a1 any[]
---@param a2 any[]
---@vararg any[]
---@return any[]
function elbat.a_merge(a1, a2, ...)
    for _, aN in ipairs({ a2, ... }) do
        for _, value in ipairs(aN) do
            table.insert(a1, value)
        end
    end
    return a1
end

---Get table len or 0 if table doesn't exist
---@param a any[]|nil
---@return integer
function elbat.a_length(a)
    return a and #a or 0
end

---Merge multiple array into the first given array
---@param a1 any[]
---@param a2 any[]
---@vararg any[]
---@return any[]
function elbat.a_copy_merge(a1, a2, ...)
    local a3 = elbat.t_deepcopy(a1)
    return array_merge(a3, a2, ...)
end

---Check whether or not the given value is present within the array
---@generic T
---@param array T[]
---@param value T
---@return boolean
function elbat.a_in(array, value)
    if not array then return false end
    for _, v in ipairs(array) do
        if value == v then
            return true
        end
    end
    return false
end

---Insert given value if not already present
---@param array any[]|nil
---@param value any
---@return boolean return true if value was inserted
function elbat.a_insert_if_not_present(array, value)
    if array and not array_in(array, value) then
        table.insert(array, value)
        return true
    end
    return false
end

---Remove duplication within the given array
---@param array any[]
---@return any[]
function elbat.a_make_unique(array)
    local i
    for idx = 0, #array - 1 do
        i = idx + 1
        while i <= #array do
            if array[idx] == array[i] then
                table.remove(array, i)
                i = i - 1 -- reduce the index to check the new 'i'eme value
            end
            i = i + 1
        end
    end
    return array
end

function array_apply(t, fun)
    for i, v in ipairs(t) do
        t[i] = fun(v)
    end
end

function array_foreach(t, fun)
    local tmp = {}
    for _, v in ipairs(t) do
        table.insert(tmp, fun(v))
    end
    return tmp
end

--- This function will merge all given table into the first one
---@param t1 table
---@param t2 table
---@vararg table
---@return table
function elbat.t_merge(t1, t2, ...)
    for _, tn in ipairs({ t2, ... }) do
        for k, v in pairs(tn) do
            if (type(v) == "table")
                and (type(t1[k]) == "table") then
                elbat.t_merge(t1[k], tn[k])
            else
                t1[k] = v
            end
        end
    end
    return t1
end

function table_join(t1, t2)
    for _, v in pairs(t2) do
        table.insert(t1, v)
    end
    return t1
end

function table_copy_merge(t1, ...)
    local args = { deepcopy(t1) }

    for _, t2 in pairs({ ... }) do
        table.insert(args, deepcopy(t2))
    end
    return table_merge(table.unpack(args))
end

function table_length(t)
    if not t then return 0 end

    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function table_nested_set(t, path, value, override)
    if override == nil then
        override = true
    end
    for n, key in pairs(path) do
        if n == (#path) then
            if override or not t[key] then
                t[key] = value
            end
            break
        else
            if not t[key] then
                t[key] = {}
            end
            t = t[key]
        end
    end
end

function table_nested_get(t, path)
    for _, key in pairs(path) do
        if not t[key] then
            return nil
        end
        t = t[key]
    end
    return t
end

function table_in(t, v)
    for _, value in pairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

function tables_has_intersection(t1, t2)
    for _, value in pairs(t1) do
        if table_in(t2, value) then
            return true
        end
    end
    return false
end

function table_invert(t)
    local s = {}
    for k, v in pairs(t) do
        s[v] = k
    end
    return s
end

function table_get_keys(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

---@diagnostic disable:undefined-global
if not describe then
    return elbat
end

describe("Test elbat class", function()
    it('Test elbat.a_make_unique', function()
        assert.are.same(
            elbat.a_make_unique({1, 1})
        , {1})
        assert.are.same(
            elbat.a_make_unique({1, 2, 1})
        , {1, 2})
    end)
end)


return elbat
