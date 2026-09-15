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
local RETAIL, CLASSIC = { Mainline = true }, { Classic = true }

local function get(key)
    return SUI:Get("raidframes." .. key)
end

-- Rows shared by buffs and debuffs: layout, placement and display switches.
local function rowOptions(rows, side, noun, hidden, sizeMin, sizeMax, perRowMax)
    local p = "auras." .. side .. "."
    local function id(name)
        return side .. name
    end
    local function slider(name, label, min, max, order, tooltip, clients)
        return { key = p .. name, type = "slider", label = label, min = min, max = max, step = 1, column = 4, order = order,
                 tooltip = tooltip, clients = clients, hidden = hidden }
    end
    local title = noun:sub(1, 1):upper() .. noun:sub(2)
    rows[#rows + 1] = {
        [id("Size")] = slider("size", title .. " Size", sizeMin, sizeMax, 1, "Icon size as a share of the frame height."),
        [id("Max")] = slider("max", "Max " .. title, 1, 6, 2, "Most " .. noun .. " shown per frame."),
        [id("PerRow")] = slider("perrow", title .. " Per Row", 1, perRowMax, 3, "Icons per row before a new row starts."),
    }
    rows[#rows + 1] = {
        [id("Point")] = { key = p .. "point", type = "dropdown", label = title .. " Anchor", options = POINTS, column = 4, order = 1,
                          hidden = hidden, tooltip = "Point of the frame the " .. noun .. " start from; bottom rows sit above a shown power bar." },
        [id("X")] = slider("x", "X Offset", -50, 50, 2, "Horizontal offset from the anchor."),
        [id("Y")] = slider("y", "Y Offset", -50, 50, 3, "Vertical offset from the anchor."),
    }
    rows[#rows + 1] = {
        [id("Grow")] = { key = p .. "grow", type = "dropdown", label = "Grow Direction", options = GROW, column = 4, order = 1,
                         hidden = hidden, tooltip = "Direction further " .. noun .. " are added in." },
        [id("Duration")] = { key = p .. "duration", type = "checkbox", label = "Cooldown Swipe", column = 4, order = 2, hidden = hidden,
                             tooltip = "Show the remaining duration as a cooldown swipe." },
        [id("Count")] = { key = p .. "count", type = "checkbox", label = "Stack Count", column = 4, order = 3, hidden = hidden,
                          tooltip = "Show the stack count on the icons." },
    }
    rows[#rows + 1] = {
        [id("Spacing")] = slider("spacing", "Spacing", 0, 10, 1, "Space between the icons.", CLASSIC),
    }
end

local function auraRows(rows)
    local function aurasOff()
        return not get("auras.enabled")
    end
    local function buffsOff()
        return aurasOff() or get("auras.buffs.mode") == "hide"
    end
    local function debuffsOff()
        return aurasOff() or get("auras.debuffs.mode") == "hide"
    end
    local function defensivesOff()
        return aurasOff() or get("auras.defensives.mode") == "hide"
    end

    rows[#rows + 1] = { aurasHeader = { type = "header", label = "Auras" } }
    rows[#rows + 1] = {
        aurasEnabled = { key = "auras.enabled", type = "checkbox", label = "SUI Auras", column = 4, order = 1, rebuild = true,
                         tooltip = "Draw buffs, debuffs and defensives on party and raid frames with SUI's look. Turning this off hands the rows back to Blizzard." },
        auraTooltips = { key = "auras.tooltips", type = "checkbox", label = "Aura Tooltips", column = 4, order = 2, hidden = aurasOff,
                         tooltip = "Show a tooltip when you hover one of the icons." },
        dispel = { key = "auras.dispel", type = "checkbox", label = "Dispel Highlight", column = 4, order = 3, clients = RETAIL,
                   tooltip = "Border the whole frame in the debuff color while it carries a dispellable debuff." },
    }

    local buffFilters = { { value = "raid", text = "Raid Buffs" } }
    if SUI.IsRetail then
        buffFilters[#buffFilters + 1] = { value = "important", text = "Important Only" }
    end
    buffFilters[#buffFilters + 1] = { value = "all", text = "Everything" }
    rows[#rows + 1] = { buffsHeader = { type = "header", label = "Buffs", hidden = aurasOff } }
    rows[#rows + 1] = {
        buffMode = { key = "auras.buffs.mode", type = "dropdown", label = "Buffs", column = 4, order = 1, rebuild = true, hidden = aurasOff,
                     tooltip = "Show only your own buffs, all buffs, or none.",
                     options = { { value = "mine", text = "Show Own" }, { value = "all", text = "Show All" }, { value = "hide", text = "Hide" } } },
        buffFilter = { key = "auras.buffs.filter", type = "dropdown", label = "Buff Filter", column = 4, order = 2, hidden = buffsOff,
                       options = buffFilters,
                       tooltip = "Which buffs are worth a slot. Raid Buffs is the selection Blizzard's raid frames draw." },
    }
    rowOptions(rows, "buffs", "buffs", buffsOff, 15, 60, 6)

    rows[#rows + 1] = { debuffsHeader = { type = "header", label = "Debuffs", hidden = aurasOff } }
    rows[#rows + 1] = {
        debuffMode = { key = "auras.debuffs.mode", type = "dropdown", label = "Debuffs", column = 4, order = 1, rebuild = true, hidden = aurasOff,
                       tooltip = "Show all debuffs, only dispellable ones, or none.",
                       options = { { value = "all", text = "Show All" }, { value = "dispellable", text = "Show Dispellable" }, { value = "hide", text = "Hide" } } },
        debuffLead = { key = "auras.debuffs.lead", type = "checkbox", label = "Enlarge Boss Debuffs", column = 4, order = 2, hidden = debuffsOff,
                       tooltip = "Draw boss and role debuffs larger, at the front of the row." },
    }
    rowOptions(rows, "debuffs", "debuffs", debuffsOff, 20, 80, 8)

    rows[#rows + 1] = { defensivesHeader = { type = "header", label = "Defensives", clients = RETAIL, hidden = aurasOff } }
    rows[#rows + 1] = {
        defensiveMode = { key = "auras.defensives.mode", type = "dropdown", label = "Defensives", column = 4, order = 1, rebuild = true,
                          clients = RETAIL, hidden = aurasOff, tooltip = "Show major defensive cooldowns, also externals, or none.",
                          options = { { value = "big", text = "Major Only" }, { value = "all", text = "Major and External" }, { value = "hide", text = "Hide" } } },
        defensivePoint = { key = "auras.defensives.point", type = "dropdown", label = "Position", column = 4, order = 2, clients = RETAIL,
                           hidden = defensivesOff, tooltip = "Where on the frame the defensive icons sit.",
                           options = { { value = "CENTER", text = "Center" }, { value = "LEFT", text = "Left" }, { value = "RIGHT", text = "Right" } } },
        defensiveSize = { key = "auras.defensives.size", type = "slider", label = "Defensive Size", min = 20, max = 100, step = 1, column = 4, order = 3,
                          clients = RETAIL, hidden = defensivesOff, tooltip = "Icon size as a share of the frame height." },
    }
    rows[#rows + 1] = {
        defensiveX = { key = "auras.defensives.x", type = "slider", label = "X Offset", min = -50, max = 50, step = 1, column = 4, order = 1,
                       clients = RETAIL, hidden = defensivesOff, tooltip = "Horizontal offset from the position." },
        defensiveY = { key = "auras.defensives.y", type = "slider", label = "Y Offset", min = -50, max = 50, step = 1, column = 4, order = 2,
                       clients = RETAIL, hidden = defensivesOff, tooltip = "Vertical offset from the position." },
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
        }
        auraRows(rows)
        return rows
    end,
})
