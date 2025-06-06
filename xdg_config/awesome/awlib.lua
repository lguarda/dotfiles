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
        text = gears.debug.dump_return(text)
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

-- This will call the given function after the given time
--@param f function
--@param time delay to wait befor calling f
function aw.call_in(f, time)
    gears.timer {
        timeout     = time,
        call_now    = false,
        autostart   = true,
        single_shot = true,
        callback    = f
    }
end

-- }}}
-- {{{ Files

function aw.file_write(path, content)
    local file, err = io.open(path, "w")

    if not file then
        aw.print(err)
        return nil
    end

    file:write(content)
    file:close()
end

function aw.file_read(path)
    local file, err = io.open(path, "r")

    if not file then
        aw.print(err)
        return nil
    end

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
-- {{{ Client
function aw.client_apply_properties(c, properties)
    if not properties then
        return
    end
    -- Some time properties aren't well applied do it twice
    -- for now fix the issue (it's related width/height and placement)
    -- TODO: investigate why
    -- for prop, value in pairs(properties) do
    --     c[prop] = value
    -- end
    for prop, value in pairs(properties) do
        c[prop] = value
    end
end

-- }}}
-- {{{ Toggle spawn
local function create_matcher_any(properties)
    return function(c)
        for key, value in pairs(properties) do
            if c[key] and c[key]:find(value) then
                return true
            end
        end
    end
end

local function client_find_first(properties)
    if not properties then
        return
    end
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
        local s = awful.screen.focused()
        c:move_to_screen(s)
        c:tags(s.selected_tags)
        -- Refresh ontop if it was change
        c.ontop = true
        c:jump_to(false)
        aw.client_apply_properties(c, properties)
        awful.placement.centered(c)
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
    end)
    aw.client_apply_properties(client_match, properties)
    awful.placement.centered(client_match)
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


function aw.detect_next_client(cmd, properties)
    local function match_next_created_client(c)
        toggle_spawn_attach(cmd, c, properties)
        client.disconnect_signal("request::manage", match_next_created_client)
        -- I don't know why but client doesn't always respect properties so for i call this twice
        -- Adding delay doesn't seems to fix it this need debugging
        --toggle_spawn_attach(cmd, c, properties)
        --toggle_spawn_attach(cmd, c, properties)
    end

    client.connect_signal("request::manage", match_next_created_client)
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

        local matcher

        if match_properties then
            matcher = build_matcher(match_properties)
        else
            aw.detect_next_client(cmd, properties)
        end

        awful.spawn.single_instance(cmd,
            properties,
            matcher,
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
