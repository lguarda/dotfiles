-- {{{ require
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awesome = awesome
local gdebug = require('gears.debug')
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

local aw = require 'awlib'

local myfair = require "fair"

-- }}}
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
local home_dir = os.getenv('HOME')
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
-- This is used later as the default terminal and editor to run.
local terminal = "gnome-terminal "
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    myfair.h,
    myfair.v,
    awful.layout.suit.max,
}

local key_alias = {
    up="k",
    down="j",
    left="h",
    right="l",
}

-- }}}
-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                {raise = true}
                )
        end
    end),
    awful.button({ }, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local inspect = require 'inspect'

local function debug_popup(...)
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = inspect({...})
    })
end

-- Helper functions for sane(er) keyboard resizing in layout.suit.tile.* modes
local function resize_horizontal(factor)
    local layout = awful.layout.get(awful.screen.focused())
    if layout == awful.layout.suit.tile then
        awful.client.incwfact(-factor)
    end
end

local function resize_vertical(factor)
    local layout = awful.layout.get(awful.screen.focused())
    if layout == awful.layout.suit.tile then
        awful.tag.incmwfact(factor)
    end
end


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local key_bind_text_widget = wibox.widget.textbox("")

local key_bind_mode_widget = wibox.widget({
        {
            widget = key_bind_text_widget,
        },
        --bg = beautiful.bg_normal,
        bg = '#ff944d',
        fg = '#000000',
        visible      = false,
        widget = wibox.container.background
    })

local key_modes = {
}

local function add_key_modes(name, bindings)
    key_modes[name] = bindings
end

local function signal_key_bind_mode(text, visible, key_mode)
    key_bind_text_widget:set_text(text)
    key_bind_mode_widget.visible = visible
    root.keys(key_modes[key_mode])
end

local tag_list = {
    {name="0", key="#49"},
    {name="1", key="#" .. 1 + 9 },
    {name="2", key="#" .. 2 + 9 },
    {name="3", key="#" .. 3 + 9 },
    {name="4", key="#" .. 4 + 9 },
    {name="5", key="#" .. 5 + 9 },
    {name="6", key="#" .. 6 + 9 },
    {name="7", key="#" .. 7 + 9 },
    {name="8", key="#" .. 8 + 9 },
    {name="9", key="#" .. 9 + 9 },
    {name="10", key="#" .. 10 + 9 },
}

local function tag_select_layout(t)
    local list = t:clients()
    if #list == 1 then
        t.layout = awful.layout.suit.max
    elseif #list > 1 then
        local no_floating = 0
        for _,c in pairs(list) do
            if c.floating == false then
                no_floating = no_floating + 1
                if no_floating > 1 then
                    t.layout = t.layout_save
                    return
                end
            end
        end
        t.layout = awful.layout.suit.max
    end
end

local function focus_first_client_in_tag(t)
    local client_list = t:clients()
    if #client_list > 0 then
        client.focus = client_list[1]
        t.focused = client_list[1]
    end
    t.focused = nil
end

local cjson = require 'cjson'

local function ip_widget()
    local wid = awful.widget.watch('/usr/lib/i3blocks/iface/iface', 15, function(widget, stdout)
        if stdout == "" then
            widget:set_text("down")
        else
            widget:set_text(stdout)
        end
    end)
    --return wibox.container.background(wid, '#00ff00')
    return wid
end

local function format_bat(bat_data)
    local ret = {}
    for _, bat in pairs(bat_data) do
        local out = bat.level .. "%"

        if bat.status == "Not Charging" then
            out = out .. " NOT"
        elseif bat.status == "Discharging" then
            out = out .. " DIS"
        else
            out = out .. " CHA"
        end
        if bat.time  and bat.time ~= cjson.null then
            out = out .. " " .. bat.time
        end
        table.insert(ret, out)
    end
    return ret
end

local function bat_widget()
    local wid = awful.widget.watch('/home/p1-leo/.local/bin/bat.py', 15, function(widget, stdout)
        local bat = cjson.decode(stdout)
        widget:set_text(table.concat(format_bat(bat), " "))
    end)
    return wid
end

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")

local vert_sep = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 10,
    color = "#cccccc",
}

    vert_sep.border_width = 100
    vert_sep.span_ratio = 0.5
local function create_wibar(s)
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height=28 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            key_bind_mode_widget,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            net_speed_widget({timeout=5}),
            vert_sep,
            volume_widget(),
            vert_sep,
            fs_widget(),
            vert_sep,
            cpu_widget({timeout=3}),
            vert_sep,
            batteryarc_widget({show_current_level=true, arc_thickness=1}),
            vert_sep,
            ip_widget(),
            vert_sep,
            awful.widget.keyboardlayout(),
            vert_sep,
            wibox.widget.systray(),
            vert_sep,
            wibox.widget.textclock("%V %a %Y-%m-%d %H:%M:%S"),
            vert_sep,
            s.mylayoutbox,
        },
    }
end

local function create_tab(s, tag, idx)
    local tag_properties = {
        layout             = awful.layout.suit.tile,
        layout             = myfair.h,
        master_fill_policy = "master_width_factor",
        --gap_single_client  = true,
        --gap                = 3,
        screen             = s,
        selected           = idx == 1,
        -- custom
        layout_save        = myfair.h,
        focused            = nil,
    }
    awful.tag.add(tag.name, tag_properties)
    --[[
      t:connect_signal("tagged", function(c)
      local client_list = t:clients()
      if #client_list > 0 then
      client.focus = client_list[#client_list]
      end
      tag_select_layout(t)
      end)
      t:connect_signal("untagged", function()
      -- when a client is kill or move to another tag focus the first cient
      -- found in the current tag
      focus_first_client_in_tag(t)
      tag_select_layout(t)
      end)
      t:connect_signal("tag_unfocused", function()
      -- save last focused client in tag
      t.focused = client.focus
      -- when a client is kill or move to another tag focus the first cient
      -- found in the current tag
      focus_first_client_in_tag(t)
      tag_select_layout(t)
      end)
      --]]
end

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
    -- Each screen has its own tag table.
    for idx, tag in ipairs(tag_list) do
        create_tab(s, tag, idx)
    end
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }
    create_wibar(s)
end)
-- }}}
-- {{{ Personal function
-- {{{ Toggle spawn
local function create_matcher_any(rule)
    return function(c)
        for key, value in pairs(rule) do
            if c[key] == value then
                return true
            end
        end
    end
end

local function client_find_first(rule)
    local matcher = create_matcher_any(rule)
    local final_ret = nil
    for ret in awful.client.iterate(matcher) do
        return ret
    end
    return nil
end


local toggle_state = {}

local function toggle_spawn_handle_kill(c, cmd)
    c:connect_signal("unmanage", function()
        toggle_state[cmd] = nil
    end)
end

local function toggle_spawn(cmd, do_hide, rule)
    local c = toggle_state[cmd]
    if c then
        if not c:isvisible() then
            c:move_to_tag(awful.tag.selected(1))
        elseif do_hide then
            c:tags {}
        else
            if c.pid then
                awful.spawn { "kill", tostring(c.pid) }
            else
                c:kill()
            end
            toggle_state[cmd] = nil
        end
    else
        if rule then
            local c = client_find_first(rule)
            if c then
                toggle_state[cmd] = c
                toggle_spawn_handle_kill(c, cmd)
                return toggle_spawn(cmd, do_hide, rule)
            end
        end
        awful.spawn.raise_or_spawn(cmd, nil, nil, nil, function(c)
            toggle_state[cmd] = c
            c:connect_signal("unmanage", function()
                toggle_state[cmd] = nil
                toggle_spawn_handle_kill(c, cmd)
            end)
        end)
    end
end
-- }}}
-- {{{ Focus
local function change_focus_bydirection(direction, rev)
    return awful.key({ modkey }, key_alias[direction], function()
        if awful.layout.getname() == "max" then
            awful.client.focus.byidx(rev and -1 or 1)
        else
            awful.client.focus.bydirection(direction)
        end
        if client.focus then client.focus:raise() end
    end,
    {description = "Go to the window on the " .. direction, group = "layout"}
    )
end

local function move_focused_bydirection(direction, rev)
    return awful.key({ modkey, "Shift" }, key_alias[direction], function()
        if awful.layout.getname() == "max" then
            awful.client.swap.byidx(rev and -1 or 1)
        else
            awful.client.swap.bydirection(direction)
        end
        if client.focus then client.focus:raise() end
    end,
    {description = "Move window to the " .. direction, group = "layout"}
    )
end
-- }}}
-- {{{ Chasing client
local chasing = {
    client_chasing_width = 600,
    client_chasing_height = 400,
    uniq_sticky_chasing_window = nil
}

function chasing.focus_client_behind()
    gears.timer( {  timeout = 0.1,
            autostart = true,
            single_shot = true,
            callback =  function()
                local n = mouse.object_under_pointer()
                if n ~= nil and n ~= client.focus then
                client.focus = n end
            end
        } )
end

function chasing.unset_property(c)
    c.floating = false
    c.ontop = false
    c.sticky = false
    c.skip_taskbar = false
    c.focusable = true
    c.opacity=1
end

function chasing.set_property(c)
    c.floating = true
    c.ontop = true
    c.sticky = true
    c.skip_taskbar = true
    c.focusable = false
    c.opacity=0.8
    local geometry = c:geometry()
    geometry["x"] = c.screen.geometry["width"] - chasing.client_chasing_width
    geometry["y"] = c.screen.geometry["height"]/2 - chasing.client_chasing_height/2
    geometry["width"] = chasing.client_chasing_width
    geometry["height"] = chasing.client_chasing_height
    c:geometry(geometry)
end

function chasing.flee_mouse()
    local c = chasing.uniq_sticky_chasing_window
    local geometry = c:geometry()
    if geometry["x"] == 0 then
        geometry["x"] = c.screen.geometry["width"] - chasing.client_chasing_width
    else
        geometry["x"] = 0
    end
    c:geometry(geometry)
    chasing.focus_client_behind()
end

function chasing.create()
    if chasing.uniq_sticky_chasing_window ~= nil then
        chasing.unset_property(chasing.uniq_sticky_chasing_window)
        chasing.uniq_sticky_chasing_window:disconnect_signal("mouse::enter", chasing.flee_mouse)
        chasing.uniq_sticky_chasing_window = nil
        chasing.focus_client_behind()
    else
        local c = client.focus
        chasing.set_property(c)
        c:connect_signal("mouse::enter", chasing.flee_mouse)
        chasing.focus_client_behind(c)
        chasing.uniq_sticky_chasing_window = c
    end
end
-- }}}
-- {{{ Keybind wrapper
local function akr(keys, desc, group, cb)
    local mk = keys:split('+')
    local key = mk[#mk]
    mk[#mk] = nil

    return awful.key(mk,
        key,
        cb,
        {description=desc, group=group}
    )
end

local function ak(keys, desc, group, cb)
    return akr(modkey .. '+' .. keys, desc, group, cb)
end
--}}}
-- {{{ Functional call
local function backlight_ctrl(nb)
    awful.spawn.easy_async_with_shell(("xbacklight -inc %d && xbacklight -get"):format(nb), function(out)
        naughty.notify {
            text = ("LCD Backlight %s"):format(out),
            timeout = 0.500,
        }
    end)
end
-- }}}
-- }}}
-- {{{ Key bindings

local function my_resize(x, y)
    if client.focus.floating then
        client.focus:relative_move(0,0,x,y)
    else
        if x ~= 0 then
            resize_vertical(x/10)
        else
            resize_horizontal(y/10)
        end
    end
end


local mode_keys_resize = gears.table.join(
    ak(key_alias["up"], "resize", "Mode:resize", aw.cba(my_resize, 0, -10)),
    ak(key_alias["down"], "resize", "Mode:resize", aw.cba(my_resize, 0, 10)),
    ak(key_alias["left"], "resize", "Mode:resize", aw.cba(my_resize, -10, 0)),
    ak(key_alias["right"], "resize", "Mode:resize", aw.cba(my_resize, 10, 0)),
    -- # back to normal
    awful.key({}, "Escape",
        aw.cba(signal_key_bind_mode, "", false, 'globalkeys'),
        {description="normal mode", group="Mode:resize"}
    )
)

add_key_modes('mode_keys_resize', mode_keys_resize)

local function my_move(x, y)
    client.focus:relative_move(x, y,0,0)
end

local mode_keys_move = gears.table.join(
    ak(key_alias["up"], "move", "Mode:move", aw.cba(my_move, 0, -10)),
    ak(key_alias["down"], "move", "Mode:move", aw.cba(my_move, 0, 10)),
    ak(key_alias["left"], "move", "Mode:move", aw.cba(my_move, -10, 0)),
    ak(key_alias["right"], "move", "Mode:move", aw.cba(my_move, 10, 0)),
    -- # back to normal
    awful.key({}, "Escape",
        aw.cba(signal_key_bind_mode, "", false, 'globalkeys'),
        {description="normal mode", group="Mode:move"}
    )
)

add_key_modes('mode_keys_move', mode_keys_move)
-- {{{ Global key bind
local globalkeys = gears.table.join(
    ak("Shift+h", "show help", "awesome", hotkeys_popup.show_help),
    ak("Escape", "go back", "tag", awful.tag.history.restore),
    ak("w", "Set layout to max", "layout", function ()
            awful.layout.set(awful.layout.suit.max)
        end
    ),
    ak("e", "Toggle fair layout horizontal and vertiacal", "layout", function ()
            if awful.layout.getname() == "fairh" then
                awful.layout.set(myfair.v)
            else
                awful.layout.set(myfair.h)
            end
        end
    ),
    -- media keys
    akr("XF86MonBrightnessUp", "Increase Brigtness", "Media", aw.cba(backlight_ctrl, 10)),
    akr("XF86MonBrightnessDown", "Decrease Brigtness", "Media", aw.cba(backlight_ctrl, -10)),
    -- Standard program
    ak("Return", "open a terminal", "launcher", aw.cba(awful.spawn, terminal)),
    ak("Shift+r", "reload awesome", "awesome", awesome.restart),
    ak("Shift+e", "quit awesome", "awesome", awesome.quit),
    ak("x", "Lock session", "awesome", aw.cba(awful.spawn, "slock")),
    ak("u", "jump to urgent client", "client", awful.client.urgent.jumpto),
    ak("Shift+p", "jump to urgent client", "client", awful.client.urgent.jumpto),
    -- Layout manipulation
    ak("g", "Toggle chasing window", "awesome", aw.cba(chasing.create)),
    ak("space", "Toggle floating", "layout", aw.cba(awful.client.floating.toggle)),

    change_focus_bydirection("up"),
    change_focus_bydirection("down"),
    change_focus_bydirection("left", true),
    change_focus_bydirection("right"),

    move_focused_bydirection("up"),
    move_focused_bydirection("down"),
    move_focused_bydirection("left", true),
    move_focused_bydirection("right"),

      -- dmenu
      --awful.key({ modkey }, "d", function() menubar.show() end, {description = "Pop up the launcher", group = "launcher"}),
    ak("d", "Pop up the launcher", "launcher",
        aw.cba(awful.spawn, 'rofi -modi drun,run -show drun')
    ),
    ak("Shift+s", "Pop up Flameshot", "launcher",
        aw.cba(awful.spawn, ('flameshot gui --path=%s/screenshot'):format(home_dir))),
    --ak("a", "Pop up crocohotkey", "launcher",
    --    aw.cba(awful.spawn, ("%s/.local/bin/toggle.sh %s/.local/bin/ahk.py"):format(home_dir, home_dir))),
    ak("a", "Pop up crocohotkey", "launcher",
        aw.cba(toggle_spawn, ("%s/.local/bin/ahk.py"):format(home_dir), true, {name="Crocohotkey"})),
    ak("c", "Pop up pavucontrol", "launcher",
        aw.cba(toggle_spawn, 'pavucontrol', true)),
    ak("s", "Pop up slack", "launcher",
        aw.cba(toggle_spawn, 'slack', true, {class="Slack", })),
    -- Keybind mode
    ak("r", "Change keybind mode to resize", "Keybind mode",
        aw.cba(signal_key_bind_mode, 'resize', true, 'mode_keys_resize')),
    ak("m", "Change keybind mode to move", "Keybind mode",
        aw.cba(signal_key_bind_mode, 'move', true, 'mode_keys_move'))
)
-- }}}
-- {{{ Tag key bind
local function tag_focus_only(id)
    local screen = awful.screen.focused()
    local tag = screen.tags[id]
    if tag then
        tag:view_only()
    end
end

local function tag_focus_toggle(id)
    local screen = awful.screen.focused()
    local tag = screen.tags[id]
    if tag then
        awful.tag.viewtoggle(tag)
    end
end

local function client_move_to_tag(id)
    if client.focus then
        local tag = client.focus.screen.tags[id]
        if tag then
            client.focus:move_to_tag(tag)
        end
    end
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i, tag_setting in ipairs(tag_list) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        ak(tag_setting.key,
        "view tag ".. tag_setting.name,
        "tag",
        aw.cba(tag_focus_only, i)
        ),
        -- Toggle tag display.
        ak('Control+'..tag_setting.key,
        "toggle tag ".. tag_setting.name,
        "tag",
        aw.cba(tag_focus_toggle, i)
        ),
        -- Move client to tag.
        ak('Shift+'..tag_setting.key,
        "move focused client to tag ".. tag_setting.name,
        "tag",
        aw.cba(client_move_to_tag, i)
        )
    )
end
-- }}}
add_key_modes('globalkeys', globalkeys)

local clientkeys = gears.table.join(
    ak("f", "toggle fullscreen", "client",
    function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end
    ),
    ak("Shift+q", "Close", "client", function (c) c:kill() end),
    ak("space", "toggle floating", "client", awful.client.floating.toggle),
    ak("Control+Return", "move to master", "client", function (c) c:swap(awful.client.getmaster()) end),
    ak("o", "move to screen", "client", function (c) c:move_to_screen() end),
    ak("t", "toggle keep on top", "client", function (c) c.ontop = not c.ontop end)
)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
local default_rule = {
    -- All clients will match this rule.
    rule = { },
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen,
        size_hints_honor = false,
    }
}

local floating_client_rule = {
    rule_any = {
        instance = {
            "copyq",  -- Includes session name in class.
        },
        class = { "Arandr" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester",  -- xev.
            "Crocohotkey",
        },
        role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "ConfigManager",  -- Thunderbird's about:config.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true,
        placement = awful.placement.centered,
    }
}


-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    default_rule,
    floating_client_rule,
    -- Add titlebars to normal clients and dialogs
--{ rule_any = {type = { "normal", "dialog" } }, properties = { titlebars_enabled = false } },
    { rule = { class = "Pavucontrol" }, properties = {
            placement = function(...) return awful.placement.centered(...)end,
            height = 600,
            width = 1600,
            floating = true,
            opacity=0.9,
            ontop=true
        },
    },
    { rule = { class = "Slack" }, properties = {
            placement = function(...) return awful.placement.centered(...)end,
            height = 1300,
            width = 2300,
            floating = true,
            opacity=0.9,
            ontop=true
        },
    },
    { rule = { class = "Dragon" }, properties = {
        sticky = true, ontop = true, floating = true, placement = awful.placement.centered }
    },

-- Set Firefox to always map on the tag named "2" on screen 1.
-- { rule = { class = "Firefox" },
--   properties = { screen = 1, tag = "2" } },
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("property::floating", function(c)
    if c.floating then
        c.border_width = 0
        c.ontop = true
    else
        c.border_width = beautiful.border_width
        c.ontop = false
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = true })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- vim: fdm=marker
