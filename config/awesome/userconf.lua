local aw = require("awlib")
local awful = require("awful")
local gears = require("gears")
local ruled = require("ruled")


local globalkeys = gears.table.join(
    aw.ak("s", "Pop up slack", "launcher",
        aw.cba(aw.toggle_spawn, '/home/leo/Downloads/mattermost-desktop-5.7.0-linux-x64/mattermost-desktop', true,
            { class = "Mattermost" }, { border_width = 0 })),
    aw.ak("i", "Pop up irc", "launcher",
        aw.cba(aw.toggle_spawn, 'hexchat', true, { class = "Hexchat" }, { border_width = 0 }))
)

aw.kb_append_bindings('globalkeys', globalkeys)
aw.kb_swap_mode('globalkeys')

ruled.client.connect_signal("request::rules", function()
    ruled.client.append_rules {
        {
            rule = { class = "Hexchat" },
            properties = {
                placement = function(...)
                    return awful.placement.centered(...)
                end,
                height = 700,
                width = 1200,
                floating = true,
                opacity = 0.9,
                above = true,
                ontop = true
            },
        },
        {
            rule = { class = "Mattermost" },
            properties = {
                placement = function(...)
                    return awful.placement.centered(...)
                end,
                height = 700,
                width = 1200,
                floating = true,
                opacity = 0.9,
                above = true,
                ontop = true
            },
        },
    }
end)
