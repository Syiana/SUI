--[[
    SUI 2.0 - Features/RaidFrames/Options.lua

    The Raidframes tab. Settings apply live through SUI:Set; only turning off
    the custom party size asks for a reload. Options of a switch that is off
    (or a mode that does not use them) are hidden.
]]

local _, ns = ...
local SUI = ns.SUI

local function withBlizzard(options, value)
    table.insert(options, 1, { value = value, text = "Blizzard" })
    return options
end

local POINTS = {
    { value = "TOPLEFT", text = "Top Left" }, { value = "TOP", text = "Top" }, { value = "TOPRIGHT", text = "Top Right" },
    { value = "LEFT", text = "Left" }, { value = "CENTER", text = "Center" }, { value = "RIGHT", text = "Right" },
    { value = "BOTTOMLEFT", text = "Bottom Left" }, { value = "BOTTOM", text = "Bottom" },
    { value = "BOTTOMRIGHT", text = "Bottom Right" },
}
local GROW = {
    { value = "LEFT", text = "Left" }, { value = "RIGHT", text = "Right" },
    { value = "UP", text = "Up" }, { value = "DOWN", text = "Down" },
}

local function get(key)
    return SUI:Get("raidframes." .. key)
end

-- Appends the option rows of one aura group ("buffs" or "debuffs").
local function auraRows(rows, key, title, filters)
    local p = "auras." .. key .. "."
    local noun = title:lower()
    local function off()
        return not get(p .. "enabled")
    end
    local function id(name)
        return key .. name
    end
    local function slider(name, label, min, max, order, tooltip, clients)
        return { key = p .. name, type = "slider", label = label, min = min, max = max, step = 1, column = 4, order = order,
                 tooltip = tooltip, clients = clients, hidden = off }
    end
    rows[#rows + 1] = { [id("Header")] = { type = "header", label = title } }
    rows[#rows + 1] = {
        [id("Enabled")] = { key = p .. "enabled", type = "checkbox", label = "Show " .. title, column = 4, order = 1, rebuild = true,
                            tooltip = "Show " .. noun .. " on raid frames with SUI's layout." },
        [id("Filter")] = { key = p .. "filter", type = "dropdown", label = "Filter", column = 4, order = 2, options = filters, hidden = off,
                           tooltip = "Which " .. noun .. " are shown." },
        [id("Size")] = slider("size", "Size", 8, 40, 3, "Size of the " .. noun .. " icons."),
    }
    rows[#rows + 1] = {
        [id("Max")] = slider("max", "Max Count", 1, 10, 1, "Most " .. noun .. " shown per frame."),
        [id("PerRow")] = slider("perRow", "Per Row", 1, 10, 2, "Number of " .. noun .. " per row."),
        [id("Grow")] = { key = p .. "grow", type = "dropdown", label = "Grow Direction", options = GROW, column = 4, order = 3, hidden = off,
                         tooltip = "Direction in which further " .. noun .. " are added." },
    }
    rows[#rows + 1] = {
        [id("Anchor")] = { key = p .. "anchor", type = "dropdown", label = "Anchor Point", options = POINTS, column = 4, order = 1, hidden = off,
                           tooltip = "Corner of the raid frame the " .. noun .. " start from." },
        [id("X")] = slider("x", "X Offset", -50, 50, 2, "Horizontal offset from the anchor point."),
        [id("Y")] = slider("y", "Y Offset", -50, 50, 3, "Vertical offset from the anchor point."),
    }
    rows[#rows + 1] = {
        [id("Duration")] = { key = p .. "duration", type = "checkbox", label = "Cooldown Swipe", column = 4, order = 1, hidden = off,
                             tooltip = "Show the remaining duration as a cooldown swipe." },
        [id("Count")] = { key = p .. "count", type = "checkbox", label = "Stack Count", column = 4, order = 2, hidden = off,
                          tooltip = "Show the stack count on the icons." },
        [id("Spacing")] = slider("spacing", "Spacing", 0, 10, 3, "Space between the icons.", { Classic = true }),
    }
end

local function fonts()
    return withBlizzard(SUI.Media:Options("font"), "")
end

SUI.Config:RegisterLayout("Raidframes", {
    group = "units",
    order = 20,
    category = "raidframes",
    rows = function()
        local function sizeOff()
            return not get("size")
        end
        local function namesHidden()
            return get("names.mode") == "Hide"
        end
        local function healthHidden()
            return get("health.hide")
        end
        local function defensivesOff()
            return not get("auras.defensives")
        end
        local rows = {
            { header = { type = "header", label = "General" } },
            {
                texture = { key = "texture", type = "dropdown", label = "Texture", column = 4, order = 1,
                            tooltip = "Health bar texture of party and raid frames.",
                            options = withBlizzard(SUI.Media:Options("statusbar"), "Disabled") },
                colors = { key = "colors", type = "dropdown", label = "Health Color", column = 4, order = 2,
                           tooltip = "Color of the health bars.",
                           options = {
                               { value = "Default", text = "Blizzard" },
                               { value = "Class", text = "Class Color" },
                               { value = "Dark", text = "Dark" },
                           } },
                roleicons = { key = "roleicons", type = "dropdown", label = "Role Icons", column = 4, order = 3,
                              tooltip = "Which role icons party and raid frames show.",
                              options = {
                                  { value = "Default", text = "Show All" },
                                  { value = "TankHealer", text = "Tanks and Healers" },
                                  { value = "Hide", text = "Hide" },
                              } },
            },
            {
                alwaysontop = { key = "alwaysontop", type = "checkbox", label = "Always on Top", column = 4, order = 1,
                                tooltip = "Draw party and raid frames above other frames." },
                mouseover = { key = "mouseover", type = "checkbox", label = "Mouseover Highlight", column = 4, order = 2,
                              tooltip = "Highlight a party or raid frame while hovering it." },
                keepenabled = { key = "keepenabled", type = "checkbox", label = "Keep Blizzard Raid Frames", column = 4, order = 3,
                                tooltip = "Enable Blizzard's raid frame add-on again when another add-on disables it." },
            },
            {
                solo = { key = "solo", type = "checkbox", label = "Solo Party Frames", column = 4, order = 1,
                         tooltip = "Show the raid-style party frame when you are not in a group.",
                         clients = { Mainline = true, TBC = true } },
            },
            { header = { type = "header", label = "Scale & Size" } },
            {
                partyscale = { key = "partyscale", type = "slider", label = "Party Frame Scale", min = 0.5, max = 1.5, step = 0.1, column = 4, order = 1,
                               tooltip = "Scale of the party frames." },
                raidscale = { key = "raidscale", type = "slider", label = "Raid Frame Scale", min = 0.5, max = 1.5, step = 0.1, column = 4, order = 2,
                              tooltip = "Scale of the raid frames." },
                size = { key = "size", type = "checkbox", label = "Custom Party Size", column = 4, order = 3, rebuild = true,
                         tooltip = "Resize raid-style party frames out of combat; turning it off needs a reload." },
            },
            {
                width = { key = "width", type = "slider", label = "Width", min = 50, max = 200, step = 1, column = 4, order = 1, hidden = sizeOff,
                          tooltip = "Width of the party frames." },
                height = { key = "height", type = "slider", label = "Height", min = 20, max = 150, step = 1, column = 4, order = 2, hidden = sizeOff,
                           tooltip = "Height of the party frames." },
            },
            { namesHeader = { type = "header", label = "Names" } },
            {
                nameMode = { key = "names.mode", type = "dropdown", label = "Names", column = 4, order = 1, rebuild = true,
                             tooltip = "Show Blizzard's names, names cut to a length, or no names.",
                             options = {
                                 { value = "Default", text = "Blizzard" },
                                 { value = "Short", text = "Short" },
                                 { value = "Hide", text = "Hide" },
                             } },
                nameLength = { key = "names.length", type = "slider", label = "Short Name Length", min = 3, max = 20, step = 1, column = 4, order = 2,
                               tooltip = "Number of characters of a short name.",
                               hidden = function()
                                   return get("names.mode") ~= "Short"
                               end },
                nameClass = { key = "names.classcolor", type = "checkbox", label = "Class Color Names", column = 4, order = 3, hidden = namesHidden,
                              tooltip = "Color player names by class." },
            },
            {
                nameFont = { key = "names.font", type = "dropdown", label = "Name Font", column = 4, order = 1, options = fonts(), hidden = namesHidden,
                             tooltip = "Font of the names." },
                nameSize = { key = "names.size", type = "slider", label = "Name Font Size", min = 6, max = 24, step = 1, column = 4, order = 2, hidden = namesHidden,
                             tooltip = "Font size of the names." },
            },
            { healthHeader = { type = "header", label = "Health Text" } },
            {
                healthHide = { key = "health.hide", type = "checkbox", label = "Hide Health Text", column = 4, order = 1, rebuild = true,
                               tooltip = "Hide the health text on party and raid frames." },
                healthColor = { key = "health.color", type = "dropdown", label = "Health Text Color", column = 4, order = 2, hidden = healthHidden,
                                tooltip = "Color of the health text.",
                                options = {
                                    { value = "Default", text = "Blizzard" },
                                    { value = "Class", text = "Class Color" },
                                } },
                healthFont = { key = "health.font", type = "dropdown", label = "Health Text Font", column = 4, order = 3, hidden = healthHidden,
                               tooltip = "Font of the health text.", options = fonts() },
            },
            {
                healthSize = { key = "health.size", type = "slider", label = "Health Text Size", min = 6, max = 24, step = 1, column = 4, order = 1, hidden = healthHidden,
                               tooltip = "Font size of the health text." },
            },
            { aurasHeader = { type = "header", label = "Aura Highlights", clients = { Mainline = true } } },
            {
                dispel = { key = "auras.dispel", type = "checkbox", label = "Dispel Highlight", clients = { Mainline = true }, column = 4, order = 1,
                           tooltip = "Border a frame in the debuff color when you can dispel it." },
                defensives = { key = "auras.defensives", type = "checkbox", label = "Defensive Cooldowns", clients = { Mainline = true }, column = 4, order = 2,
                               rebuild = true,
                               tooltip = "Show big defensive and external cooldowns in the center of the frame; turn off Blizzard's own center defensive to avoid duplicates." },
                important = { key = "auras.important", type = "checkbox", label = "Important Buffs", clients = { Mainline = true }, column = 4, order = 3,
                              hidden = defensivesOff, tooltip = "Also show important buffs next to the defensive cooldowns." },
            },
            {
                auraSize = { key = "auras.size", type = "slider", label = "Defensive Icon Size", min = 10, max = 40, step = 1, clients = { Mainline = true },
                             column = 4, order = 1, hidden = defensivesOff, tooltip = "Size of the defensive cooldown icons." },
            },
        }
        local buffFilters = { { value = "All", text = "All" }, { value = "Mine", text = "Mine" } }
        if SUI.IsRetail then
            buffFilters[3] = { value = "Defensives", text = "Defensives" }
        end
        auraRows(rows, "buffs", "Buffs", buffFilters)
        auraRows(rows, "debuffs", "Debuffs", {
            { value = "All", text = "All" },
            { value = "Dispellable", text = "Dispellable by Me" },
            { value = "Boss", text = "Boss and Important" },
        })
        return rows
    end,
})
