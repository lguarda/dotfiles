-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gdebug = require('gears.debug')
local gears = require("gears")
local awful = require("awful")
--require("awful.autofocus")
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

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

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
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
--awful.layout.layouts = {
    --awful.layout.suit.floating,
    --awful.layout.suit.tile,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
--}
awful.layout.layouts = {
   awful.layout.suit.tile,
   awful.layout.suit.floating,
   awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

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

local function debug_popup(text)
    local popup = {
        widget = {
            {
                {
                    text   = text,
                    widget = wibox.widget.textbox
                },
                layout = wibox.layout.fixed.vertical,
            },
            margins = 10,
            widget  = wibox.container.margin
        },
        border_color = '#00ff00',
        border_width = 5,
        placement    = awful.placement.top_left,
        shape        = gears.shape.rounded_rect,
        visible      = true,
    }
    awful.popup(popup)
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

local function signal_key_bind_mode(text, visible)
    key_bind_text_widget:set_text(text)
    key_bind_mode_widget.visible = visible
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
    end
end

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    for _, tag in ipairs(tag_list) do
        local t = awful.tag.add(tag.name, {
            layout             = awful.layout.suit.tile,
            master_fill_policy = "master_width_factor",
            gap_single_client  = true,
            gap                = 3,
            screen             = s,
            selected           = true,
            -- custom
            layout_save            = awful.layout.suit.tile,
            focused            = nil
        })
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
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
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

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

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
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

awful.placement.top(buttons_example, { margins = {top = 40}, parent = awful.screen.focused()})

local key_alias = {
    -- vim hjkl
    up="k",
    down="j",
    left="h",
    right="l",

    -- default i3
    --up="l",
    --down="k",
    --left="j",
    --right="semicolon",
}

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

local function focus_client_under_mouse()
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

local function unset_chasing_property(c)
    c.floating = false
    c.ontop = false
    c.sticky = false
    c.opacity=1
end

local client_chasing_width = 600
local client_chasing_height = 400

local function set_chasing_property(c)
        c.floating = true
        c.ontop = true
        c.sticky = true
        c.opacity=0.8
        local geometry = c:geometry()
        geometry["x"] = c.screen.geometry["width"]-client_chasing_width
        geometry["y"] = c.screen.geometry["height"]/2 - client_chasing_height/2
        geometry["width"] = client_chasing_width
        geometry["height"] = client_chasing_height
        c:geometry(geometry)
end

local uniq_sticky_chasing_window = nil

local function test_gain_focus()
    local c = uniq_sticky_chasing_window
    local geometry = c:geometry()
    if geometry["x"] == 0 then
        geometry["x"] = c.screen.geometry["width"] - client_chasing_width
    else
        geometry["x"] = 0
    end
    c:geometry(geometry)
    focus_client_under_mouse()
end

local function create_sticky_chasing_window(pause)
    if uniq_sticky_chasing_window ~= nil then
        unset_chasing_property(uniq_sticky_chasing_window)
        uniq_sticky_chasing_window:disconnect_signal("focus", test_gain_focus)
        uniq_sticky_chasing_window = nil
        focus_client_under_mouse()
    else
        local c = client.focus
        set_chasing_property(c)
        c:connect_signal("focus", test_gain_focus)
        focus_client_under_mouse(c)
        uniq_sticky_chasing_window = c
    end
end

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey,           }, "w", function ()
        awful.tag.selected(1).layout_save = awful.layout.suit.max
        awful.layout.set(awful.layout.suit.max)
    end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey,           }, "e", function ()
        awful.tag.selected(1).layout_save = awful.layout.suit.tile
        if awful.layout.getname() == "tile" then
            awful.client.cycle(true)
        else
            awful.layout.set(awful.layout.suit.tile)
        end
    end,
              {description = "show main menu", group = "awesome"}),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "c", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "x", function () awful.spawn("slock") end,
              {description = "Lock session", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "p", function () awful.spawn("manage_power.sh") end,
              {description = "Lock session", group = "awesome"}),

    awful.key({ modkey,           }, "g", function ()
        create_sticky_chasing_window()
    end,
              {description = "Toggle chasing window", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey,           }, "space", function () awful.client.floating.toggle() end,
              {description = "Toggle floating", group = "layout"}),

    change_focus_bydirection("up"),
    change_focus_bydirection("down"),
    change_focus_bydirection("left", true),
    change_focus_bydirection("right"),

    move_focused_bydirection("up"),
    move_focused_bydirection("down"),
    move_focused_bydirection("left", true),
    move_focused_bydirection("right"),

    -- dmenu
    awful.key({ modkey }, "d", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Keybind mode
    awful.key({ modkey }, "r", function ()
        signal_key_bind_mode("resize", true)
        root.keys(mode_keys_resize)
    end,
              {description = "Change keybind mode to resize", group = "Keybind mode"}),
    awful.key({ modkey }, "m", function ()
        signal_key_bind_mode("move", true)
        root.keys(mode_keys_move) end,
              {description = "Change keybind mode to move", group = "Keybind mode"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i, tag_setting in ipairs(tag_list) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, tag_setting.key,
            function ()
                awful.tag.selected(1):emit_signal("tag_unfocused", awful.tag.selected(1))
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                    if tag.focused then
                        -- Restore previsous focused client for the new tag
                        client.focus = tag.focused
                    else
                        focus_first_client_in_tag(tag)
                    end
                end
            end,
            {description = "view tag ".. tag_setting.name, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, tag_setting.key,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                    focus_first_client_in_tag(tag)
                end
            end,
            {description = "toggle tag " .. tag_setting.name, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, tag_setting.key,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        focus_first_client_in_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag ".. tag_setting.name, group = "tag"})
    )
end

mode_keys_resize = gears.table.join(
    awful.key({ modkey,           }, key_alias["up"],
    function () if client.focus.floating then client.focus:relative_move(0,0,0,-10) else resize_horizontal(-0.05) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["down"],
    function () if client.focus.floating then client.focus:relative_move(0,0,0,10) else resize_horizontal(0.05) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["left"],
    function () if client.focus.floating then client.focus:relative_move(0,0,-10,0) else resize_vertical(-0.05) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["right"],
    function () if client.focus.floating then client.focus:relative_move(0,0,10,0) else resize_vertical(0.05) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,   "Shift" }, key_alias["up"],
    function () if client.focus.floating then client.focus:relative_move(0,0,0,-1) else resize_horizontal(-0.01) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,   "Shift" }, key_alias["down"],
    function () if client.focus.floating then client.focus:relative_move(0,0,0,1) else resize_horizontal(0.01) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,   "Shift" }, key_alias["left"],
    function () if client.focus.floating then client.focus:relative_move(0,0,-1,0) else resize_vertical(-0.01) end  end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,   "Shift" }, key_alias["right"],
    function () if client.focus.floating then client.focus:relative_move(0,0,1,0) else resize_vertical(0.01) end  end,
              {description="show help", group="awesome"}),
    -- # back to normal
    awful.key({}, "Escape", function() signal_key_bind_mode("", false) root.keys(globalkeys) end,
              {description="show help", group="awesome"})
        )

mode_keys_move = gears.table.join(
    awful.key({ modkey,           }, key_alias["up"],
    function () client.focus:relative_move(0,-10,0,0) end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["down"],
    function () client.focus:relative_move(0,10,0,0) end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["left"],
    function () client.focus:relative_move(-10,0,0,0) end,
              {description="show help", group="awesome"}),

    awful.key({ modkey,           }, key_alias["right"],
    function () client.focus:relative_move(10,0,0,0) end,
              {description="show help", group="awesome"}),
    -- # back to normal
    awful.key({}, "Escape", function()
        signal_key_bind_mode("", false)
        root.keys(globalkeys) end,
              {description="show help", group="awesome"})
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
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false,
                     --honor_padding=false,
                     --honor_workarea=false,
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = {
          floating = true,
      }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    { rule = { class = "Firefox" },
            properties = { opacity = 1, maximized = false, floating = false } },

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

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

