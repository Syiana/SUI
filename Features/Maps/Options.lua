--[[
    SUI 2.0 - Features/Maps/Options.lua

    The Map tab. Labels follow SUI 1.x where the option existed.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }

SUI.Config:RegisterLayout("Map", {
    order = 80,
    category = "maps",
    rows = function()
        return {
            { header = { type = "header", label = "Worldmap" } },
            {
                opacity = { key = "opacity", type = "slider", label = "Opacity",
                            min = 0.1, max = 1, step = 0.05, column = 4, order = 1 },
                small = { key = "small", type = "checkbox", label = "Small Map",
                          tooltip = "Show the world map at a smaller size", column = 4, order = 2 },
                coords = { key = "coords", type = "checkbox", label = "Coordinates",
                           tooltip = "Display coordinates on map", column = 4, order = 3 },
            },
            { header = { type = "header", label = "Minimap" } },
            {
                style = { key = "style", type = "dropdown", label = "Style", column = 4, order = 1,
                          options = { { value = "Default", text = "Default" }, { value = "Square", text = "Square" } } },
                minimapsize = { key = "minimapsize", type = "slider", label = "Minimap Size",
                                min = 0.5, max = 2, step = 0.05, column = 4, order = 2 },
                minimap = { key = "minimap", type = "checkbox", label = "Show Minimap",
                            tooltip = "Show/Hide minimap", column = 4, order = 3 },
            },
            {
                clock = { key = "clock", type = "checkbox", label = "Show Clock",
                          tooltip = "Show/Hide clock on minimap", column = 4, order = 1 },
                date = { key = "date", type = "checkbox", label = "Show Date",
                         tooltip = "Show/Hide calendar icon on minimap", column = 4, order = 2 },
                zonetext = { key = "zonetext", type = "checkbox", label = "Show Zone Text",
                             tooltip = "Show/Hide the zone name above the minimap", column = 4, order = 3 },
            },
            {
                tracking = { key = "tracking", type = "checkbox", label = "Tracking Symbol",
                             tooltip = "Show/Hide tracking icon on minimap", column = 4, order = 1 },
                buttons = { key = "buttons", type = "checkbox", label = "Buttons on Mouseover",
                            tooltip = "Show minimap buttons on mouseover", column = 4, order = 2 },
                fade = { key = "fade", type = "checkbox", label = "Fade Minimap",
                         tooltip = "Fade the minimap until the mouse is over it", column = 4, order = 3 },
            },
            {
                minimapcoords = { key = "minimapcoords", type = "checkbox", label = "Minimap Coordinates",
                                  tooltip = "Display your coordinates on the minimap", column = 4, order = 1 },
                garrison = { key = "garrison", type = "checkbox", label = "Expansion Button",
                             tooltip = "Show/Hide the expansion landing page button", clients = RETAIL, column = 4, order = 2 },
                expansionbutton = { key = "expansionbutton", type = "checkbox", label = "Expansion Button Mouseover",
                                    tooltip = "Show Expansion Button on mouseover", clients = RETAIL, column = 4, order = 3 },
            },
            { header = { type = "header", label = "Minimap Buttons" } },
            {
                enabled = { key = "buttonbar.enabled", type = "checkbox", label = "Collect Buttons",
                            tooltip = "Move add-on minimap buttons into a bar", column = 4, order = 1 },
                mode = { key = "buttonbar.mode", type = "dropdown", label = "Show Bar", column = 4, order = 2,
                         options = {
                             { value = "drawer", text = "Drawer Button" },
                             { value = "always", text = "Always" },
                             { value = "mouseover", text = "Minimap Mouseover" },
                         } },
                grow = { key = "buttonbar.grow", type = "dropdown", label = "Grow Direction", column = 4, order = 3,
                         options = {
                             { value = "RIGHT", text = "Right" }, { value = "LEFT", text = "Left" },
                             { value = "DOWN", text = "Down" }, { value = "UP", text = "Up" },
                         } },
            },
            {
                perrow = { key = "buttonbar.perrow", type = "slider", label = "Buttons per Row",
                           min = 1, max = 12, step = 1, column = 4, order = 1 },
                size = { key = "buttonbar.size", type = "slider", label = "Button Size",
                         min = 16, max = 48, step = 1, column = 4, order = 2 },
                spacing = { key = "buttonbar.spacing", type = "slider", label = "Spacing",
                            min = 0, max = 10, step = 1, column = 4, order = 3 },
            },
        }
    end,
})
