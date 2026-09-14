--[[ SUI 2.0 - Features/Buffs/Options.lua
    The Buffs tab: player buff and debuff frame texts and borders (Style
    Auras) and the optional icon layout (Custom Layout). Options of a switch
    that is off are hidden.
]]

local _, ns = ...
local SUI = ns.SUI

local function styleOff()
    return not SUI:Get("buffs.style")
end

local function layoutOff()
    return not SUI:Get("buffs.layout")
end

local function slider(key, label, min, max, order, tooltip, hidden)
    return { key = key, type = "slider", label = label, min = min, max = max, step = 1, column = 4, order = order, tooltip = tooltip, hidden = hidden }
end

local function section(kind, title)
    local noun = kind == "buff" and "buffs" or "debuffs"
    return {
        {
            header = {
                type = "header", label = title,
                hidden = function()
                    return styleOff() and layoutOff()
                end,
            },
        },
        {
            durationtext = {
                key = kind .. ".durationtext", type = "checkbox", label = "Duration Text", column = 4, order = 1, hidden = styleOff,
                tooltip = "Show the remaining time below your " .. noun .. ".",
            },
            collapse = kind == "buff" and {
                key = "buff.collapse", type = "checkbox", label = "Collapse Button", column = 4, order = 2, hidden = styleOff,
                tooltip = "Show Blizzard's collapse button next to your buffs.",
            } or nil,
            textsize = slider(kind .. ".textsize", "Text Size", 8, 16, 3, "Font size of the duration and stack count texts.", styleOff),
        },
        {
            durationoffset = slider(kind .. ".durationoffset", "Duration Offset", -50, 50, 1, "Vertical position of the duration text.", styleOff),
            countx = slider(kind .. ".countx", "Count X Offset", -50, 50, 2, "Horizontal position of the stack count.", styleOff),
            county = slider(kind .. ".county", "Count Y Offset", -50, 50, 3, "Vertical position of the stack count.", styleOff),
        },
        {
            size = slider(kind .. ".size", "Icon Size", 16, 64, 1, "Size of the " .. noun .. " icons.", layoutOff),
            padding = slider(kind .. ".padding", "Padding", 0, 20, 2, "Space between the " .. noun .. " icons.", layoutOff),
            icons = slider(kind .. ".icons", "Icons Per Row", 1, 32, 3, "Number of " .. noun .. " icons per row.", layoutOff),
        },
    }
end

SUI.Config:RegisterLayout("Buffs", {
    group = "interface",
    order = 30,
    category = "buffs",
    rows = function()
        local rows = {
            { header = { type = "header", label = "General" } },
            {
                style = {
                    key = "style", type = "checkbox", label = "Style Auras", column = 4, order = 1, reload = true, rebuild = true,
                    tooltip = "SUI borders and texts on the player buff and debuff frames; turning it off needs a reload.",
                },
                layout = {
                    key = "layout", type = "checkbox", label = "Custom Layout", column = 4, order = 2, rebuild = true,
                    tooltip = "Use SUI's icon size, padding and icons per row instead of the Edit Mode settings.",
                },
            },
        }
        for _, part in next, { section("buff", "Buffs"), section("debuff", "Debuffs") } do
            for i = 1, #part do
                rows[#rows + 1] = part[i]
            end
        end
        return rows
    end,
})
