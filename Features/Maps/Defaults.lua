--[[
    SUI 2.0 - Features/Maps/Defaults.lua

    Settings of the Map tab. Keys are the SUI 1.x keys; zonetext, fade,
    minimapcoords and buttonbar are new in 2.0. "Show ..." keys hide the
    element when false.
]]

local _, ns = ...
local SUI = ns.SUI

SUI:RegisterDefaults("maps", {
    minimapsize = 1,       -- minimap scale
    style = "Default",     -- "Default" (round) | "Square"
    small = false,         -- smaller world map
    opacity = 1,           -- world map opacity
    coords = true,         -- coordinates on the world map
    minimap = true,        -- show minimap
    clock = true,
    date = false,          -- calendar button
    garrison = true,       -- expansion landing page button (retail)
    tracking = false,
    buttons = true,        -- add-on buttons (LibDBIcon) only on mouseover
    expansionbutton = false, -- expansion button only on mouseover (retail)
    -- new in 2.0
    zonetext = true,
    fade = false,          -- fade the minimap while the mouse is elsewhere
    minimapcoords = false, -- player coordinates on the minimap
    buttonbar = {          -- collect add-on minimap buttons into a bar
        enabled = false,
        mode = "drawer",   -- "drawer" | "always" | "mouseover"
        perrow = 6,
        size = 28,
        spacing = 2,
        grow = "RIGHT",    -- "RIGHT" | "LEFT" | "DOWN" | "UP"
    },
})

-- SUI 9.x/10.x stored opacity = false and a "Legion" garrison button style.
SUI:RegisterMigration("maps-1x-values", function(profile)
    local maps = rawget(profile, "maps")
    if type(maps) ~= "table" then
        return
    end
    if rawget(maps, "opacity") ~= nil and type(maps.opacity) ~= "number" then
        maps.opacity = nil
    end
    local style = rawget(maps, "style")
    if style ~= nil and style ~= "Default" and style ~= "Square" then
        maps.style = nil
    end
end)
