--[[
    SUI 2.0 - Features/Maps/Options.lua

    The Map tab. The button bar options only show while add-on buttons are
    collected; "Buttons on Mouseover" only while they are not.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }

local function check(key, label, tooltip, order, extra)
    local el = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function slider(key, label, min, max, step, order, tooltip, hidden)
    return { key = key, type = "slider", label = label, min = min, max = max, step = step, column = 4, order = order, tooltip = tooltip, hidden = hidden }
end

local function barOff()
    return not SUI:Get("maps.buttonbar.enabled")
end

SUI.Config:RegisterLayout("Map", {
    group = "interface",
    order = 50,
    category = "maps",
    rows = function()
        return {
            { header = { type = "header", label = "Minimap" } },
            {
                minimap = check("minimap", "Show Minimap", "Show the minimap; unchecked hides it with everything around it.", 1),
                style = { key = "style", type = "dropdown", label = "Style", column = 4, order = 2,
                          tooltip = "Round (Default) or square minimap.",
                          options = { { value = "Default", text = "Default" }, { value = "Square", text = "Square" } } },
                minimapsize = slider("minimapsize", "Size", 0.5, 2, 0.05, 3, "Scale of the minimap."),
            },
            { header = { type = "header", label = "Minimap Elements" } },
            {
                clock = check("clock", "Show Clock", "Show the clock below the minimap.", 1),
                date = check("date", "Show Calendar", "Show the calendar button with the date next to the minimap.", 2),
                zonetext = check("zonetext", "Show Zone Text", "Show the zone name above the minimap.", 3),
            },
            {
                tracking = check("tracking", "Show Tracking", "Show the tracking button on the minimap.", 1),
                minimapcoords = check("minimapcoords", "Show Coordinates", "Show your coordinates on the minimap.", 2),
                garrison = check("garrison", "Show Expansion Button", "Show the expansion landing page button.", 3, { clients = RETAIL, rebuild = true }),
            },
            {
                expansionbutton = check("expansionbutton", "Expansion on Mouseover", "Only show the expansion landing page button while the mouse is over it.", 1, {
                    clients = RETAIL,
                    hidden = function()
                        return not SUI:Get("maps.garrison")
                    end,
                }),
            },
            { header = { type = "header", label = "Minimap Buttons" } },
            {
                enabled = check("buttonbar.enabled", "Collect Buttons", "Move add-on minimap buttons into a separate bar.", 1, { rebuild = true }),
                buttons = check("buttons", "Buttons on Mouseover", "Only show add-on minimap buttons while the mouse is over the minimap.", 2, {
                    hidden = function()
                        return not barOff()
                    end,
                }),
                mode = { key = "buttonbar.mode", type = "dropdown", label = "Show Bar", column = 4, order = 3, hidden = barOff,
                         tooltip = "Open the bar from a drawer button, show it always or while the mouse is over the minimap.",
                         options = {
                             { value = "drawer", text = "Drawer Button" },
                             { value = "always", text = "Always" },
                             { value = "mouseover", text = "Minimap Mouseover" },
                         } },
                grow = { key = "buttonbar.grow", type = "dropdown", label = "Grow Direction", column = 4, order = 4, hidden = barOff,
                         tooltip = "Direction in which the bar adds buttons.",
                         options = {
                             { value = "RIGHT", text = "Right" }, { value = "LEFT", text = "Left" },
                             { value = "DOWN", text = "Down" }, { value = "UP", text = "Up" },
                         } },
            },
            {
                perrow = slider("buttonbar.perrow", "Buttons per Row", 1, 12, 1, 1, "Number of buttons before the bar starts a new row.", barOff),
                size = slider("buttonbar.size", "Button Size", 16, 48, 1, 2, "Size of the buttons in the bar.", barOff),
                spacing = slider("buttonbar.spacing", "Spacing", 0, 10, 1, 3, "Space between the buttons in the bar.", barOff),
            },
            { header = { type = "header", label = "World Map" } },
            {
                small = check("small", "Small Map", "Show the world map at a smaller size.", 1),
                coords = check("coords", "Coordinates", "Show player and cursor coordinates on the world map.", 2),
                opacity = slider("opacity", "Opacity", 0.1, 1, 0.05, 3, "Opacity of the world map."),
            },
            { header = { type = "header", label = "Fade" } },
            {
                fade = check("fade", "Fade Minimap", "Fade the minimap out until the mouse is over it.", 1),
            },
        }
    end,
})
