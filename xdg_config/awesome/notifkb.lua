local naughty = require("naughty")
local gears = require("gears")
local aw = require 'awlib'

local notif_focused = nil

local function notif_list()
    return naughty.active
end

function notif_set_focus(n)
    if notif_focused then
        notif_focused.border_width = 0
    end
    notif_focused = n
    if notif_focused then
        notif_focused.border_color = "#ff0000" -- swap for a beautiful.* var
        notif_focused.border_width = 4
    end
end

function notif_focus_move(delta)
    local list = notif_list()
    if #list == 0 then notif_set_focus(nil) return end
    local idx = 1
    if notif_focused then
        for i, n in ipairs(list) do
            if n == notif_focused then idx = i break end
        end
        idx = ((idx - 1 + delta) % #list) + 1
    end
    notif_set_focus(list[idx])
end

function notif_focus_next(idx)
    local new_list = notif_list()
    notif_set_focus(#new_list == 0 and nil or new_list[math.min(idx, #new_list)])
end

function notif_delete_focused()
    if not notif_focused then return end
    local list = notif_list()
    local idx = 1
    for i, n in ipairs(list) do
        if n == notif_focused then idx = i break end
    end
    notif_focused:destroy(naughty.notification_closed_reason.dismissedByUser)
    gears.timer.delayed_call(function()
        notif_focus_next(idx)
    end)
end

function notif_trigger_action()
    if not notif_focused or not notif_focused.actions or #notif_focused.actions == 0 then return end
    notif_focused.actions[1]:invoke()
end
