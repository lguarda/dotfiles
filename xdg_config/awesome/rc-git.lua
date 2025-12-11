-- {{{ require
-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")

local aw = require 'awlib'

-- }}}
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}
-- {{{ Variable definitions
local home_dir = os.getenv('HOME')
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "neovide -- +term"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

local key_alias = {
    up = "k",
    down = "j",
    left = "h",
    right = "l",
}

-- }}}
-- {{{ Personal function
-- {{{ Debug
local function debug_popup(text)
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "debug:",
        text = tostring(text)
    })
end

local function debug_popup_client()
    local properties_list = {
        "window",
        "name",
        "skip_taskbar",
        "type",
        "class",
        "instance",
        "pid",
        "role",
        "machine",
        "icon_name",
        "icon",
        "icon_sizes",
        "screen",
        "hidden",
        "minimized",
        "size_hints_honor",
        "border_width",
        "border_color",
        "urgent",
        "content",
        "opacity",
        "ontop",
        "above",
        "below",
        "fullscreen",
        "maximized",
        "maximized_horizontal",
        "maximized_vertical",
        "transient_for",
        "group_window",
        "leader_window",
        "size_hints",
        "motif_wm_hints",
        "sticky",
        "modal",
        "focusable",
        "shape_bounding",
        "shape_clip",
        "shape_input",
        "client_shape_bounding",
        "client_shape_clip",
        "startup_id",
        "valid",
        "first_tag",
        "marked",
        "is_fixed",
        "immobilized",
        "immobilized",
        "floating",
        "x",
        "y",
        "width",
        "height",
        "dockable",
        "requests_no_titlebar",
        "shape",
    }
    local out = {}
    local c = client.focus
    if c == nil then
        return
    end
    for _, key in ipairs(properties_list) do
        out[key] = c[key]
    end
    debug_popup(out.class)
end

-- }}}
-- {{{ True easy async


---@class asaw
local asaw = {}

---This run the given function into a corotoine
---@param fn function
---@async
function asaw.run(fn)
    coroutine.wrap(function() fn() end)()
end

---This function will convert any function in the form
---```lua
---function(arg1, argn, callback)
---```
---into it's async await form using the power of coroutine
---@param fun function
---@return function
function asaw.build_from_cb_based_async(fun)
    return function(...)
        local co = coroutine.running()
        local cb = function(...)
            coroutine.resume(co, ...)
        end
        fun(..., cb)
        return coroutine.yield()
    end
end

--- This will call awful.spawn.easy_async but within coroutine
--- So you can run it like this:
---
--- ```lua
--- asaw.run(function()
---     local out, err = async_spawn("command that take time")
---     local out2 = async_spawn("command that take time with previous output: " .. out)
--- end)
--- print("here you can use all argument provided by the easy_async* callback:" .. out2)
--- -- acheive the same result with
--- awful.spawn.easy_async("command that take time", function (out, err)
---     awful.spawn.easy_async("command that take time with previous output: " .. out, function (out2)
---         print(out2)
---     end)
--- end)
--- ```
---
--- No need to add callback this is handled within the coroutine
--- with yield and resume, your code look synchronous but it'async
--- behind the hood
---@async
---@type fun(cmd: string|string[]): string, string, string, string
local async_spawn = asaw.build_from_cb_based_async(awful.spawn.easy_async)

---@async
---@type fun(cmd: string|string[]): string, string, string, string
local async_spawn_with_shell = asaw.build_from_cb_based_async(awful.spawn.easy_async_with_shell)

-- }}}
-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.max,
        awful.layout.suit.corner.nw,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)
-- }}}
-- {{{ Focus
local function change_focus_bydirection(direction, rev)
    return awful.key({ modkey }, key_alias[direction], function()
            local layout = awful.layout.getname()
            if layout == "max" or layout == "fullscreen" then
                awful.client.focus.byidx(rev and -1 or 1)
            else
                awful.client.focus.bydirection(direction)
            end
            if client.focus then client.focus:raise() end
        end,
        { description = "Go to the window on the " .. direction, group = "layout" }
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
        { description = "Move window to the " .. direction, group = "layout" }
    )
end
-- }}}
-- {{{ Focus client under mouse
local function focus_client_under_mouse()
    local n = mouse.object_under_pointer()
    if n ~= nil and n ~= client.focus then
        n:jump_to(false)
    end
end
-- }}}
-- {{{ Chasing client

---@class chasing
---@field uniq_sticky_chasing_window table|nil
---@field client_chasing_width integer
---@field client_chasing_height integer
local chasing = {
    client_chasing_width = 600,
    client_chasing_height = 400,
}

---When chasing window has moved simply force focus on
---the window behind
function chasing.focus_client_behind()
    gears.timer({
        timeout = 0.1,
        autostart = true,
        single_shot = true,
        callback = focus_client_under_mouse
    })
end

---Stop chasing mode for the given client
---@param c table the client that was in chasing mode
function chasing.unset_property(c)
    c.floating = false
    c.ontop = false
    c.sticky = false
    c.skip_taskbar = false
    c.focusable = true
    c.opacity = 1
end

---Start chasing mode for the given client
---@param c table the client to set in chasing mode
function chasing.set_property(c)
    c.floating = true
    c.ontop = true
    c.sticky = true
    c.skip_taskbar = true
    c.focusable = false
    c.opacity = 0.8
    local geometry = c:geometry()
    geometry["x"] = c.screen.geometry["width"] - chasing.client_chasing_width
    geometry["y"] = c.screen.geometry["height"] / 2 - chasing.client_chasing_height / 2
    geometry["width"] = chasing.client_chasing_width
    geometry["height"] = chasing.client_chasing_height
    c:geometry(geometry)
end

function chasing.flee_mouse()
    local c = chasing.uniq_sticky_chasing_window

    if not c then
        return
    end

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
        if c == nil then
            return
        end
        chasing.set_property(c)
        c:connect_signal("mouse::enter", chasing.flee_mouse)
        chasing.focus_client_behind()
        chasing.uniq_sticky_chasing_window = c
    end
end

-- }}}
-- {{{ Functional call
local function backlight_ctrl(nb)
    asaw.run(function()
        local bright_max = async_spawn("brightnessctl max")
        local bright = async_spawn("brightnessctl get")
        local bright_percent = math.min(100, math.floor(bright / bright_max * 100) + nb)
        if (bright_percent < 5) then
            -- prevent to go bellow 0 or the screen can be black
            bright_percent = 1
        end
        async_spawn(("brightnessctl set %d%%"):format(bright_percent))
        _G.backlight_ctrl_notif_id = naughty.notify {
            text = ("LCD Backlight %d%%"):format(bright_percent),
            timeout = 0.500,
            replaces_id = _G.backlight_ctrl_notif_id,
        }.id
    end)
end

local function get_last_screen_shot()
    local name_handle = io.popen(("ls -t1 '%s/Pictures/screenshot/' | head -n 1"):format(home_dir))
    if not name_handle then return end
    return name_handle:read()
end

local function screenshot()
    asaw.run(function()
        async_spawn(('flameshot gui --path=%s/Pictures/screenshot/'):format(home_dir))
        local filename = get_last_screen_shot()
        debug_popup(filename)
        async_spawn(("dragon '%s/Pictures/screenshot/%s'"):format(home_dir, filename))
    end)
end
-- }}}
-- }}}
-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        local c = client.focus
        if c then
            c:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        local c = client.focus
        if c then
            c:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c ~= client.focus then
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

key_bind_text_widget = wibox.widget.textbox("")

key_bind_mode_widget = wibox.widget({
    {
        widget = key_bind_text_widget,
    },
    bg      = '#ff944d',
    fg      = '#000000',
    visible = false,
    widget  = wibox.container.background
})

local kb_append_bindings = aw.kb_append_bindings
local kb_swap_mode = aw.kb_swap_mode

local tag_list = {
    { name = "0",  key = "#49" },
    { name = "1",  key = "#" .. 1 + 9 },
    { name = "2",  key = "#" .. 2 + 9 },
    { name = "3",  key = "#" .. 3 + 9 },
    { name = "4",  key = "#" .. 4 + 9 },
    { name = "5",  key = "#" .. 5 + 9 },
    { name = "6",  key = "#" .. 6 + 9 },
    { name = "7",  key = "#" .. 7 + 9 },
    { name = "8",  key = "#" .. 8 + 9 },
    { name = "9",  key = "#" .. 9 + 9 },
    { name = "10", key = "#" .. 10 + 9 },
}

local function ip_widget()
    local wid = awful.widget.watch("ip -4 route get 8.8.8.8", 15, function(widget, stdout)
        stdout = string.match(stdout, "src (%d*.%d*.%d*.%d*)")
        if stdout == "" then
            widget:set_text("down")
        else
            widget:set_text(stdout)
        end
    end)
    return wid
end

local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")

local vert_sep = wibox.widget {
    widget = wibox.widget.separator,
    orientation = "vertical",
    forced_width = 10,
    color = "#cccccc",
}

vert_sep.border_width = 100
vert_sep.span_ratio = 0.5


awful.spawn.single_instance("xss-lock " .. aw.path("~/.local/bin/lock.sh"))
awful.spawn.single_instance("blueman-applet")

local keybaord_layout = awful.widget.keyboardlayout()
local current_keyboard_layout = 'us'
keybaord_layout:connect_signal("button::press", function()
    if current_keyboard_layout == 'us' then
        current_keyboard_layout = 'fr'
    else
        current_keyboard_layout = 'us'
    end

    awful.spawn('setxkbmap -option caps:escape ' .. current_keyboard_layout)
end)

local function create_wibar(s)
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 28 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            key_bind_mode_widget,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            net_speed_widget({ timeout = 5 }),
            vert_sep,
            volume_widget(),
            vert_sep,
            fs_widget(),
            vert_sep,
            ram_widget({ color_used = "#e63c5b", color_free = "#a8ffb1", color_buf = "#4aa153", timeout = 3 }),
            vert_sep,
            cpu_widget({ timeout = 3 }),
            vert_sep,
            batteryarc_widget({ show_current_level = true, arc_thickness = 2 }),
            vert_sep,
            ip_widget(),
            vert_sep,
            keybaord_layout,
            vert_sep,
            wibox.widget.systray(),
            vert_sep,
            wibox.widget.textclock("%V %a %Y-%m-%d %H:%M:%S", 1),
            vert_sep,
            s.mylayoutbox,
        },
    }
end
-- }}}
-- {{{ Screen
local function create_tab(s, tag, idx)
    local tag_properties = {
        layout             = awful.layout.suit.tile.left,
        master_fill_policy = "expand",
        screen             = s,
        selected           = idx == 1,
    }
    awful.tag.add(tag.name, tag_properties)
end

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    for idx, tag in ipairs(tag_list) do
        create_tab(s, tag, idx)
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }

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
-- {{{ Key bindings
local ak = aw.ak
local akr = aw.akr
local function my_resize(x, y)
    local c = client.focus
    if c == nil then
        return
    end
    if c.floating then
        c:relative_move(0, 0, x, y)
    elseif x ~= 0 then
        awful.tag.incmwfact(-(x * 0.005))
    end
end


local mode_keys_resize = gears.table.join(
    akr(key_alias["up"], "resize", "Mode:resize", aw.cba(my_resize, 0, -10)),
    akr(key_alias["down"], "resize", "Mode:resize", aw.cba(my_resize, 0, 10)),
    akr(key_alias["left"], "resize", "Mode:resize", aw.cba(my_resize, -10, 0)),
    akr(key_alias["right"], "resize", "Mode:resize", aw.cba(my_resize, 10, 0)),
    ak("m", "Change keybind mode to move", "Keybind mode",
        aw.cba(kb_swap_mode, 'mode_keys_move', 'move')),

    -- # back to normal
    awful.key({}, "Escape",
        aw.cba(kb_swap_mode, 'globalkeys'),
        { description = "normal mode", group = "Mode:resize" }
    )
)

kb_append_bindings('mode_keys_resize', mode_keys_resize)

local function my_move(x, y)
    local c = client.focus
    if c == nil then
        return
    end
    c:relative_move(x, y, 0, 0)
end

local mode_keys_move = gears.table.join(
    akr(key_alias["up"], "move", "Mode:move", aw.cba(my_move, 0, -10)),
    akr(key_alias["down"], "move", "Mode:move", aw.cba(my_move, 0, 10)),
    akr(key_alias["left"], "move", "Mode:move", aw.cba(my_move, -10, 0)),
    akr(key_alias["right"], "move", "Mode:move", aw.cba(my_move, 10, 0)),
    ak("r", "Change keybind mode to resize", "Keybind mode",
        aw.cba(kb_swap_mode, 'mode_keys_resize', 'resize')),

    -- # back to normal
    awful.key({}, "Escape",
        aw.cba(kb_swap_mode, 'globalkeys'),
        { description = "normal mode", group = "Mode:move" }
    )
)

local cairo = require("lgi").cairo

---This function will make the shape input in 0x0
---So it will only be focusable via keybind, the mouse move and click
---will be applied through the given client
local function blend_out(c)
    local img = cairo.ImageSurface(cairo.Format.A1, 0, 0)
    c.shape_input = img._native
    img:finish()
end

local over_editor_cmd = 'neovide --x11-wm-class=overnvim --x11-wm-class-instance=overnvim -- '
    .. '+term'

local pulsemixer_cmd =
    'neovide --x11-wm-class=pulsemixer --x11-wm-class-instance=pulsemixer -- '
    .. [[ "+lua vim.keymap.set('t', 'q', '<nop>')"]]
    .. [[ "+lua vim.keymap.set('t', '<esc>', '<nop>')"]]
    .. ' "+term ~/clone/pulsemixer/pulsemixer"'
    .. ' "+set wrap"'

kb_append_bindings('mode_keys_move', mode_keys_move)
-- {{{ Global key bind
local globalkeys = gears.table.join(
    ak("Shift+h", "show help", "awesome", hotkeys_popup.show_help),
    ak("Escape", "go back", "tag", awful.tag.history.restore),
    ak("o", "move mouse to other screen", "screen", aw.cba(awful.screen.focus_relative, 1)),
    ak("f", "toggle fullscreen", "client",
        function()
            if awful.layout.getname() == "fullscreen" then
                awful.layout.set(awful.layout.suit.tile.left)
            else
                awful.layout.set(awful.layout.suit.max.fullscreen)
            end
        end
    ),
    ak("Shift+m", "Toggle maximized", "layout", function()
        -- save client under mouse
        local tof = mouse.object_under_pointer()
        local c = client.focus
        if c then
            c.maximized = not c.maximized
        end
        -- jump to the client that was under the mouse after changing to max
        if tof and tof.jump_to then
            tof:jump_to(false)
        end
    end
    ),
    ak("w", "Set layout to max", "layout", function()
        -- save client under mouse
        local tof = mouse.object_under_pointer()
        local c = client.focus
        if c and c.fullscreen then
            c.fullscreen = false
        end
        awful.layout.set(awful.layout.suit.max)
        -- jump to the client that was under the mouse after changing to max
        if tof and tof.jump_to then
            tof:jump_to(false)
        end
    end
    ),
    ak("y", "Toggle tile layout horizontal and vertiacal", "layout", function()
        awful.layout.set(awful.layout.suit.tile)
    end),
    ak("e", "Toggle tile layout horizontal and vertiacal", "layout", function()
        local c = client.focus
        if c and c.fullscreen then
            c.fullscreen = false
            return
        end
        if awful.layout.getname() == "tileleft" then
            awful.layout.set(awful.layout.suit.tile.bottom)
        else
            awful.layout.set(awful.layout.suit.tile.left)
        end
    end
    ),
    ak("Shift+v", "Paste clipboard content with keyoard emulation", "Development",
        aw.cba(awful.spawn.with_shell, "sleep 0.5; xdotool type $(xclip -o -selection clipboard)")),
    -- media keys
    akr("XF86MonBrightnessUp", "Increase Brigtness", "Media", aw.cba(backlight_ctrl, 5)),
    akr("XF86MonBrightnessDown", "Decrease Brigtness", "Media", aw.cba(backlight_ctrl, -5)),
    akr("XF86AudioRaiseVolume", "Raise Volume", "Media",
        aw.cba(awful.spawn, "pactl set-sink-volume 0 +5% #decrease sound volume")),
    akr("XF86AudioLowerVolume", "Lower Volume", "Media",
        aw.cba(awful.spawn, "pactl set-sink-volume 0 -5% #decrease sound volume")),
    akr("KP_Add", "Raise Volume", "Media", aw.cba(awful.spawn, "pactl set-sink-volume 0 +5% #decrease sound volume")),
    akr("KP_Subtract", "Lower Volume", "Media", aw.cba(awful.spawn, "pactl set-sink-volume 0 -5% #decrease sound volume")),
    akr("XF86AudioMicMute", "Mute microphone", "Media",
        aw.cba(awful.spawn, "pactl set-source-mute @DEFAULT_SOURCE@ toggle")),
    akr("XF86AudioMute", "Mute speaker", "Media", aw.cba(awful.spawn, "pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    -- Standard program
    ak("Return", "open a terminal", "launcher", aw.cba(awful.spawn, terminal)),
    ak("Shift+r", "reload awesome", "awesome", awesome.restart),
    ak("Shift+e", "quit awesome", "awesome", awesome.quit),
    ak("x", "Lock session", "awesome", function()
        -- Lock tty switching
        awful.spawn("physlock -l")
        awful.spawn.easy_async("slock", function()
            -- Unlock tty switching
            awful.spawn("physlock -L")
        end)
    end),
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

    ak("d", "Pop up the launcher", "launcher",
        aw.cba(awful.spawn, 'rofi -show drun -sorting-method fzf -sort -matching fuzzy')
    ),
    ak("Shift+d", "Debug client", "launcher",
        function() debug_popup_client() end),
    --ak("Shift+s", "Pop up Flameshot", "launcher",
    --    aw.cba(awful.spawn, ('flameshot gui --path=%s/Pictures/screenshot/'):format(home_dir))),
    ak("Shift+s", "Pop up Flameshot", "launcher", aw.cba(screenshot)),
    ak("Shift+p", "Open last screenshot", "launcher",
        function()
            local name_handle = io.popen(("ls -t1 '%s/Pictures/screenshot/' | head -n 1"):format(home_dir))
            if not name_handle then return end
            local filename = name_handle:read()
            if filename ~= nil then
                awful.spawn(("feh '%s/Pictures/screenshot/%s'"):format(home_dir, filename))
            end
        end
    ),
    ak("a", "Pop up crocohotkey", "launcher",
        aw.cba(aw.toggle_spawn, aw.path("~/clone/crocohotkey/src/crocoui.py"), true, { name = "Config" },
            { border_width = 0 })),
    ak("c", "Pop up pavucontrol", "launcher",
        aw.cba(aw.toggle_spawn,
            pulsemixer_cmd,
            true, { class = "pulsemixer" }, { border_width = 1 })),
    ak("n", "Pop over over nvim editor", "launcher",
        aw.cba(aw.toggle_spawn,
            over_editor_cmd,
            true, { class = "overnvim" })),
    ak("Shift+n", "Apply blend out on a client", "launcher",
        function()
            local c = client.focus
            blend_out(c)
        end),
    ak("Shift+c", "Pop up pavucontrol", "launcher",
        aw.cba(aw.toggle_spawn, 'pavucontrol', true)),

    ak("b", "Pop up Blueman", "launcher",
        aw.cba(aw.toggle_spawn, aw.path('blueman-manager '), true, { class = "Blueman-manager" }, { border_width = 0 })),
    ak("p", "keepmenu auto type username", "keepmenu",
        aw.cba(awful.spawn, 'keepmenu -a {USERNAME}')),
    --ak("Shift+p", "keepmenu auto type username", "keepmenu",
    --    aw.cba(awful.spawn, 'keepmenu -a {PASSWORD}')),

    akr("#106", "Alert gogole", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/emmerde_maison.mp3'))),
    akr("#63", "Alert gogole", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/craquer.mp3'))),
    akr("#87", "Alert gogole", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/alert_gogol.mp3'))),
    akr("#88", "Auncun sens", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/aucun_sens.mp3'))),
    akr("#89", "Ba les couille", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/ba_les_couille.mp3'))),
    akr("#83", "Ho non pas ca", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/pas_ca_zinedine.mp3'))),
    akr("#84", "C'est l'heur du duel", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/cest_lheure_du_duel.mp3'))),
    akr("#85", "Great succes", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/over.sh mpv ~/music/sound_box/ff_success.mp3'))),
    akr("#79", "Perceval", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/.local/bin/play_random_kaa.sh Perceval'))),
    akr("#80", "Perceval", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/.local/bin/play_random_kaa.sh Karadoc'))),
    akr("#81", "Kaalot", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/.local/bin/play_random_kaa.sh'))),

    akr("#90", "Perceval", "Sound Box",
        aw.cba(awful.spawn, aw.path('~/clone/crocohotkey/tools/kill.sh mpv'))),

    ak("z", "Pop up slack", "launcher",
        aw.cba(aw.toggle_spawn,
            'sxiv -N zmk /home/leo/Pictures/zmk_layout/layout0.png /home/leo/Pictures/zmk_layout/layout1.png', true,
            { instance = "zmk" }, { border_width = 0 })),
    -- Keybind mode
    ak("r", "Change keybind mode to resize", "Keybind mode",
        aw.cba(kb_swap_mode, 'mode_keys_resize', 'resize')),
    ak("m", "Change keybind mode to move", "Keybind mode",
        aw.cba(kb_swap_mode, 'mode_keys_move', 'move')),
    -- Debug
    ak("Shift+d", "Dedicated debug call", "Debug", function()
        mouse.coords {
            x = 0,
            y = 0
        }
        for s in screen do
            debug_popup(gears.debug.dump_return(s.geometry))
        end
    end)
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
    local c = client.focus
    if c then
        local tag = c.screen.tags[id]
        if tag then
            c:move_to_tag(tag)
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
            "view tag " .. tag_setting.name,
            "tag",
            aw.cba(tag_focus_only, i)
        ),
        -- Toggle tag display.
        ak('Control+' .. tag_setting.key,
            "toggle tag " .. tag_setting.name,
            "tag",
            aw.cba(tag_focus_toggle, i)
        ),
        -- Move client to tag.
        ak('Shift+' .. tag_setting.key,
            "move focused client to tag " .. tag_setting.name,
            "tag",
            aw.cba(client_move_to_tag, i)
        )
    )
end
-- }}}
kb_append_bindings('globalkeys', globalkeys)

local clientkeys = gears.table.join(
    ak("q", "Close", "client", function(c) c:kill() end),
    ak("space", "toggle floating", "client", awful.client.floating.toggle),
    ak("Control+Return", "move to master", "client", function(c) c:swap(awful.client.getmaster()) end),
    ak("Shift+o", "move to screen", "client", function(c) c:move_to_screen() end),
    ak("t", "toggle keep on top", "client", function(c) c.ontop = not c.ontop end),
    ak("Shift+t", "toggle keep on top + sticky", "client", function(c)
        c.ontop = not c.ontop
        c.sticky = not c.sticky
    end)
)

local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey, "Shift" }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- use globalkeys on startup
aw.kb_swap_mode('globalkeys')

-- }}}
-- {{{ Rules
local default_rule = {
    -- All clients will match this rule.
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        size_hints_honor = true,
        maximized = false,
    }
}

local floating_client_rule = {
    rule_any = {
        instance = {
            "copyq", -- Includes session name in class.
        },
        class = { "Blueman-manager", "Sxiv", "feh" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
            "Crocohotkey",
            "Config",
        },
        role = {
            "AlarmWindow",   -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true,
        placement = awful.placement.centered,
    }
}

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules {
        default_rule,
        floating_client_rule,
        {
            rule = { class = "Arandr" },
            properties = {
                placement = function(...) return awful.placement.centered(...) end,
                height = 600,
                width = 800,
                floating = true,
                opacity = 0.9,
                ontop = true
            },
        },
        {
            rule = { class = "Pavucontrol" },
            properties = {
                placement = function(...) return awful.placement.centered(...) end,
                height = 600,
                width = 1600,
                floating = true,
                opacity = 0.9,
                ontop = true
            },
        },
        {
            rule = { class = "pulsemixer" },
            properties = {
                placement = function(...) return awful.placement.centered(...) end,
                height = 800,
                width = 1000,
                floating = true,
                opacity = 0.9,
                ontop = true,
                border_width = beautiful.border_width,
            },
        },
        {
            rule = { class = "overnvim" },
            properties = {
                height = 600,
                width = 800,
                floating = true,
                -- opacity = 0.6,
                ontop = true,
                border_width = 0,
            },
        },
        {
            rule_any = { class = { "Dragon-drop", "Dragon" } },
            properties = {
                sticky = true, ontop = true, floating = true, placement = awful.placement.centered }
        },
        {
            rule = { class = "KeePassXC", modal = true },
            properties = {
                sticky = true, ontop = true, floating = true, placement = awful.placement.centered,
                callback = function(c)
                    c:move_to_screen(awful.screen.focused())
                end
            }
        },
        {
            rule = { name = "KeePassXC - Browser Access Request" },
            properties = {
                sticky = true, ontop = true, floating = true, placement = awful.placement.centered,
                callback = function(c)
                    c:move_to_screen(awful.screen.focused())
                end
            }
        },
        {
            rule = { class = "VirtualBox Machine" },
            properties = {
                tag = "10"
            }
        },
        {
            rule_any = { class = { "org.gnome.Nautilus", "firefox", "steam", "libreoffice" } },
            properties = {
                floating = false,
                maximized = false,
            }
        },
        {
            rule = { class = "gnome-terminal-server" },
            properties = {
                size_hints_honor = false
            }
        },
    }
end)
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
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

-- Force minimized clients to unminimize.
-- This could prevent some proton game to freeze let's see if stack overflow is right
client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)

--client.connect_signal("request::manage", function (c)
--    debug_popup(("new client c in tag %s"):format(tostring(c.first_tag)))
--    --c.first_tag.name = ("%d: %s"):format(c.first_tag.index, c.name)
--    c.first_tag.icon = c.icon
--end)

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
    -- All notifications will match this rule.
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            screen       = awful.screen.preferred,
            timeout      = 300,
            border_color = '#ff0000'
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)
-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("focus", function(c) c.border_color = "#3b9c43" end)
client.connect_signal("unfocus", function(c) c.border_color = "#205725" end)

local function border_control(t, only_one)
    if not t then
        return
    end
    local cs = t:clients()
    local layout_name = awful.tag.getproperty(t, "layout").name
    if only_one or layout_name == "fullscreen" or layout_name == 'max' then
        for _, c in ipairs(cs) do
            if c.floating == false then
                c.border_width = 0
            end
        end
    else
        for _, c in ipairs(cs) do
            if c.floating == false then
                c.border_width = beautiful.border_width
            end
        end
    end
end

local function disble_border_on_single_window(s)
    local tag = s.selected_tag
    if (tag) then
        border_control(s.selected_tag, #s.tiled_clients == 1)
    end
end

-- No borders when rearranging only 1 non-floating or maximized client
tag.connect_signal("property::layout", function(t)
    disble_border_on_single_window(t.screen)
end)
client.connect_signal("request::unmanage", function(c)
    disble_border_on_single_window(c.screen)
end)
client.connect_signal("request::manage", function(c)
    disble_border_on_single_window(c.screen)
end)

-- }}}
-- {{{ Use config
local user_config = gears.filesystem.get_dir("config") .. "/" .. "userconf.lua"
if gears.filesystem.file_readable(user_config) then
    local f, err = loadfile(user_config)
    if err or not f then
        debug_popup(err)
    else
        f()
    end
end
-- }}}
-- vim: fdm=marker
