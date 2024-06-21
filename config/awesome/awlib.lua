-- {{{ Require
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
-- }}}
-- {{{ Variable
local aw = {}
local modkey = "Mod4"
local home_dir = os.getenv('HOME')
-- }}}
-- {{{ Fourtous
function string:split(delimiter)
    return gears.string.split(self, delimiter)
end

-- Function print value into a critical notification for debug purposes
--@param text string
function aw.print(text)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "debug:",
        text = tostring(text)
    })
end

-- Function replace ~ in string by the value of $HOME
--@param path string
function aw.path(path)
    return path:gsub("~", home_dir)
end

-- This helper transalte this
-- aw.cba(print, "lol") ->
-- function() print("lol") end
--@param f function
function aw.cba(f, ...)
    local args = { ... }
    return function() f(table.unpack(args)) end
end
-- }}}
-- {{{ Files

function aw.file_write(path, content)
    local file, err = io.open(path, "w")
    if err then
        aw.print(err)
    end
    file:write(content)
    file:close()
end

function aw.file_read(path)
    local file = io.open(path, "r")
    local ret = file:read("a*")
    file:close()
    return ret
end

-- }}}
-- {{{ Keybind wrapper

---This function is a wrapper to create rawy keybind
---@param keys string example:"Shift+e"
---@param desc string
---@param group string
---@param cb function
function aw.akr(keys, desc, group, cb)
    local mk = keys:split('+')
    local key = mk[#mk]
    mk[#mk] = nil

    return awful.key(mk,
        key,
        cb,
        { description = desc, group = group }
    )
end

---This function is a wrapper to create keybind with the default modkey
---@param keys string example:"Shift+e"
---@param desc string
---@param group string
---@param cb function
function aw.ak(keys, desc, group, cb)
    return aw.akr(modkey .. '+' .. keys, desc, group, cb)
end

-- }}}
-- {{{ Keybind modes

local key_modes = {
}

---This function will append the given bindings to a key mode
---and create it if it didn't exist yet
---@param kb_mode string name of the keys mode
---@param bindings table list of bindings to add in the key mode
function aw.kb_append_bindings(kb_mode, bindings)
    if not key_modes[kb_mode] then
        key_modes[kb_mode] = {}
    end
    key_modes[kb_mode] = gears.table.join(key_modes[kb_mode], bindings)
end

---This will swap to the given keybind mode it can also
---disply the specific text while in the new mode
---@param kb_mode string keybind mode name
---@param text string? text to display in the keybind mode widget
function aw.kb_swap_mode(kb_mode, text)
    if text and text ~= "" then
        key_bind_text_widget:set_text(text)
        key_bind_mode_widget.visible = true
    else
        key_bind_mode_widget.visible = false
    end
    root.keys(key_modes[kb_mode])
end

-- }}}
-- {{{ Toggle spawn
local function create_matcher_any(properties)
    return function(c)
        for key, value in pairs(properties) do
            if c[key]:find(value) then
                return true
            end
        end
    end
end

local function client_find_first(properties)
    local matcher = create_matcher_any(properties)
    return awful.client.iterate(matcher)()
end

local function build_matcher(properties)
    return function(c)
        return awful.rules.match(c, properties)
    end
end

local toggle_state = {}

---Toggle on/off the given client
---@param c table targeted client
---@param cmd string related command
---@param hide boolean if set to false the client is killed instead of being hide
---@param properties? table properties to apply on the client
local function toggle_client(c, cmd, hide, properties)
    if not c:isvisible() then
        c:move_to_tag(awful.tag.selected(1))
        -- Refresh ontop if it was change
        c.ontop = true
        c:jump_to(false)
        if properties then
            for key, value in pairs(properties) do
                c[key] = value
            end
        end
    elseif hide then
        c:tags {}
    else
        if c.pid then
            awful.spawn { "kill", tostring(c.pid) }
        else
            c:kill()
        end
        toggle_state[cmd] = nil
    end
end

---When toggled client is created or found they will be stored within
---`toggle_state` and request::unmanage signal is connected to removed it
---when client is killed.
---@param new_cmd string command related to the new client to toggle
local function toggle_spawn_attach(cmd, client_match, properties)
    toggle_state[cmd] = client_match
    client_match:connect_signal("request::unmanage", function()
        toggle_state[cmd] = nil
        if properties then
            gears.table.join(client_match, properties)
        end
    end)
end

---Toggle all other client present in `toggle_state` off.
---@param new_cmd string command related to the new client to toggle
local function toggle_spawn_all_off(new_cmd)
    for cmd, client_obj in pairs(toggle_state) do
        if new_cmd ~= cmd then
            client_obj:tags {}
        end
    end
end

---Toggle on and of any client, if it doesn't exist
---the client will be spawn with the given command, all client object
---are within the global variable `toggle_state`.
---All client are mutually exclusive spawn A will hide/kill B.
---@param cmd string the actual command to run
---@param hide boolean if set to false the client is killed instead of being hide
---@param match_properties table dict of properties to match the spawned client
---@param properties? table properties to apply on the client
function aw.toggle_spawn(cmd, hide, match_properties, properties)
    local client_match = toggle_state[cmd]
    toggle_spawn_all_off(cmd)
    if not client_match then
        client_match = client_find_first(match_properties)
        if client_match then
            toggle_spawn_attach(cmd, client_match)
            toggle_client(client_match, cmd, hide, properties)
            return
        end

        awful.spawn.single_instance(cmd,
            properties,
            build_matcher(match_properties),
            nil,
            function(client_match)
                toggle_spawn_attach(cmd, client_match, properties)
            end
        )

        return
    end

    -- already spawn just toggle it
    toggle_client(client_match, cmd, hide, properties)
end

-- }}}
return aw
-- vim: fdm=marker
