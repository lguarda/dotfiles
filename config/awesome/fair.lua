local function do_fair_only(p, horizontal)
    local wa = p.workarea
    local cls = p.clients

    local cd1,cd2,wd1,wd2
    if horizontal then
        cd1 = 'x'
        cd2 = 'y'
        wd1 = 'width'
        wd2 = 'height'
    else
        cd1 = 'y'
        cd2 = 'x'
        wd1 = 'height'
        wd2 = 'width'
    end

    if #cls > 0 then
        local client_d1 = wa[wd1] / #cls


        for k, c in ipairs(cls) do
            local idx = k - 1 
            local g = {}
	    g[wd2] = wa[wd2]
	    g[cd2] = wa[wd2] - g[wd2]

	    g[wd1] = client_d1 
	    g[cd1] = idx * g[wd1]

            p.geometries[c] = g
        end
    end
end

---------------------------------------------------------------------------
--- Fair layouts module for awful.
--
-- @author Josh Komoroske
-- @copyright 2012 Josh Komoroske
-- @module awful.layout
---------------------------------------------------------------------------

-- Grab environment we need

--- The fairh layout layoutbox icon.
-- @beautiful beautiful.layout_fairh
-- @param surface
-- @see gears.surface

--- The fairv layout layoutbox icon.
-- @beautiful beautiful.layout_fairv
-- @param surface
-- @see gears.surface

local fair = {
    h = {
        -- Vertical fair layout.
        -- @param screen The screen to arrange.
        name = "fairh",
        arrange = function(p)
            return do_fair_only(p, true)
        end
    },
    v = {
        -- Vertical fair layout.
        -- @param screen The screen to arrange.
        name = "fairv",
        arrange = function(p)
            return do_fair_only(p, false)
        end
    }
}

--- The fair layout.
-- Try to give all clients the same size.
-- @clientlayout awful.layout.suit.fair
-- @usebeautiful beautiful.layout_fairv

--- The horizontal fair layout.
-- Try to give all clients the same size.
-- @clientlayout awful.layout.suit.fair.horizontal
-- @usebeautiful beautiful.layout_fairh

return fair

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
