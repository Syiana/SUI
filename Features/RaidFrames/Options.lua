--[[
    SUI 2.0 - Features/RaidFrames/Options.lua

    The Raidframes tab. Labels of the three 1.x options (texture, party and
    raid scale) are kept; the rest is new in 2.0. Settings apply live through
    SUI:Set; only turning off the custom party size asks for a reload.
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

-- Appends the option rows of one aura group ("buffs" or "debuffs").
local function auraRows(rows, key, title, filters)
    local p = "auras." .. key .. "."
    local function id(name)
        return key .. name
    end
    rows[#rows + 1] = { [id("Header")] = { type = "header", label = title } }
    rows[#rows + 1] = {
        [id("Enabled")] = { key = p .. "enabled", type = "checkbox", label = "Show " .. title, column = 4, order = 1,
                            tooltip = "Show " .. title:lower() .. " on raid frames with SUI's layout" },
        [id("Filter")] = { key = p .. "filter", type = "dropdown", label = "Filter", column = 4, order = 2,
                           options = filters },
        [id("Size")] = { key = p .. "size", type = "slider", label = "Size", min = 8, max = 40, step = 1,
                         column = 4, order = 3 },
    }
    rows[#rows + 1] = {
        [id("Max")] = { key = p .. "max", type = "slider", label = "Max Count", min = 1, max = 10, step = 1,
                        column = 4, order = 1 },
        [id("PerRow")] = { key = p .. "perRow", type = "slider", label = "Per Row", min = 1, max = 10, step = 1,
                           column = 4, order = 2 },
        [id("Spacing")] = { key = p .. "spacing", type = "slider", label = "Spacing", min = 0, max = 10, step = 1,
                            clients = { Classic = true }, column = 4, order = 3 },
    }
    rows[#rows + 1] = {
        [id("Anchor")] = { key = p .. "anchor", type = "dropdown", label = "Anchor Point", options = POINTS,
                           column = 4, order = 1 },
        [id("X")] = { key = p .. "x", type = "slider", label = "X Offset", min = -50, max = 50, step = 1,
                      column = 4, order = 2 },
        [id("Y")] = { key = p .. "y", type = "slider", label = "Y Offset", min = -50, max = 50, step = 1,
                      column = 4, order = 3 },
    }
    rows[#rows + 1] = {
        [id("Grow")] = { key = p .. "grow", type = "dropdown", label = "Grow Direction", options = GROW,
                         column = 4, order = 1 },
        [id("Duration")] = { key = p .. "duration", type = "checkbox", label = "Show Duration", column = 4, order = 2,
                             tooltip = "Show the cooldown swipe" },
        [id("Count")] = { key = p .. "count", type = "checkbox", label = "Show Stack Count", column = 4, order = 3 },
    }
end

SUI.Config:RegisterLayout("Raidframes", {
    order = 25,
    category = "raidframes",
    rows = function()
        local rows = {
            { header = { type = "header", label = "Raid and Party" } },
            {
                texture = { key = "texture", type = "dropdown", label = "Texture", column = 4, order = 1,
                            options = withBlizzard(SUI.Media:Options("statusbar"), "Disabled") },
                partyscale = { key = "partyscale", type = "slider", label = "Party Frame Scale",
                               min = 0.5, max = 1.5, step = 0.1, column = 4, order = 2 },
                raidscale = { key = "raidscale", type = "slider", label = "Raid Frame Scale",
                              min = 0.5, max = 1.5, step = 0.1, column = 4, order = 3 },
            },
            {
                colors = { key = "colors", type = "dropdown", label = "Health Color", column = 4, order = 1,
                           tooltip = "Color of the health bars",
                           options = {
                               { value = "Default", text = "Blizzard" },
                               { value = "Class", text = "Class Color" },
                               { value = "Dark", text = "Dark" },
                           } },
                roleicons = { key = "roleicons", type = "dropdown", label = "Role Icons", column = 4, order = 2,
                              options = {
                                  { value = "Default", text = "Show All" },
                                  { value = "TankHealer", text = "Tanks and Healers" },
                                  { value = "Hide", text = "Hide" },
                              } },
            },
            {
                alwaysontop = { key = "alwaysontop", type = "checkbox", label = "Always on Top",
                                tooltip = "Draw party and raid frames above other frames", column = 4, order = 1 },
                mouseover = { key = "mouseover", type = "checkbox", label = "Mouseover Highlight",
                              tooltip = "Highlight a party or raid frame while hovering it", column = 4, order = 2 },
                solo = { key = "solo", type = "checkbox", label = "Solo Party Frames",
                         tooltip = "Show the raid-style party frame when not in a group",
                         clients = { Mainline = true, TBC = true }, column = 4, order = 3 },
            },
            {
                keepenabled = { key = "keepenabled", type = "checkbox", label = "Keep Blizzard Raid Frames",
                                tooltip = "Enable Blizzard's raid frame add-on again when another add-on disables it",
                                column = 6, order = 1 },
            },
            { sizeHeader = { type = "header", label = "Party Frame Size" } },
            {
                size = { key = "size", type = "checkbox", label = "Custom Size", column = 4, order = 1,
                         tooltip = "Resize raid-style party frames out of combat" },
                width = { key = "width", type = "slider", label = "Width", min = 50, max = 200, step = 1,
                          column = 4, order = 2 },
                height = { key = "height", type = "slider", label = "Height", min = 20, max = 150, step = 1,
                           column = 4, order = 3 },
            },
            { namesHeader = { type = "header", label = "Names" } },
            {
                nameMode = { key = "names.mode", type = "dropdown", label = "Names", column = 4, order = 1,
                             options = {
                                 { value = "Default", text = "Blizzard" },
                                 { value = "Short", text = "Short" },
                                 { value = "Hide", text = "Hide" },
                             } },
                nameLength = { key = "names.length", type = "slider", label = "Short Name Length",
                               min = 3, max = 20, step = 1, column = 4, order = 2 },
                nameClass = { key = "names.classcolor", type = "checkbox", label = "Class Color Names",
                              column = 4, order = 3 },
            },
            {
                nameFont = { key = "names.font", type = "dropdown", label = "Name Font", column = 4, order = 1,
                             options = withBlizzard(SUI.Media:Options("font"), "") },
                nameSize = { key = "names.size", type = "slider", label = "Name Font Size",
                             min = 6, max = 24, step = 1, column = 4, order = 2 },
            },
            { healthHeader = { type = "header", label = "Health Text" } },
            {
                healthHide = { key = "health.hide", type = "checkbox", label = "Hide Health Text",
                               column = 4, order = 1 },
                healthColor = { key = "health.color", type = "dropdown", label = "Health Text Color",
                                column = 4, order = 2,
                                options = {
                                    { value = "Default", text = "Blizzard" },
                                    { value = "Class", text = "Class Color" },
                                } },
            },
            {
                healthFont = { key = "health.font", type = "dropdown", label = "Health Text Font", column = 4,
                               order = 1, options = withBlizzard(SUI.Media:Options("font"), "") },
                healthSize = { key = "health.size", type = "slider", label = "Health Text Size",
                               min = 6, max = 24, step = 1, column = 4, order = 2 },
            },
            { aurasHeader = { type = "header", label = "Auras", clients = { Mainline = true } } },
            {
                dispel = { key = "auras.dispel", type = "checkbox", label = "Dispel Highlight",
                           tooltip = "Border a frame in the debuff color when you can dispel it",
                           clients = { Mainline = true }, column = 4, order = 1 },
                defensives = { key = "auras.defensives", type = "checkbox", label = "Defensive Cooldowns",
                               tooltip = "Show big defensive and external cooldowns in the center of the frame. If Blizzard's raid frames show their own center defensive, turn that off to avoid duplicates.",
                               clients = { Mainline = true }, column = 4, order = 2 },
                important = { key = "auras.important", type = "checkbox", label = "Show Important Buffs",
                              tooltip = "Also show important buffs next to the defensive cooldowns",
                              clients = { Mainline = true }, column = 4, order = 3 },
            },
            {
                auraSize = { key = "auras.size", type = "slider", label = "Defensive Icon Size",
                             min = 10, max = 40, step = 1, clients = { Mainline = true }, column = 4, order = 1 },
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
