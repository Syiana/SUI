--[[ SUI 2.0 - Features/Buffs/Options.lua
    The Buffs tab: player buff and debuff frame texts, borders and the
    optional icon layout. Labels follow SUI 1.x.
]]

local _, ns = ...
local SUI = ns.SUI

local function slider(key, label, min, max, order, step)
    return { key = key, type = "slider", label = label, min = min, max = max, step = step or 1, column = 4, order = order }
end

local function section(kind, title)
    local noun = kind == "buff" and "buffs" or "debuffs"
    return {
        { header = { type = "header", label = title } },
        {
            durationtext = {
                key = kind .. ".durationtext", type = "checkbox", label = "Duration Text", column = 4, order = 1,
                tooltip = "Show the remaining time underneath your " .. noun,
            },
            collapse = kind == "buff" and {
                key = "buff.collapse", type = "checkbox", label = "Collapse Button", column = 4, order = 2,
                tooltip = "Show the Collapse button at the Player Buff Frame",
            } or nil,
        },
        {
            textsize = slider(kind .. ".textsize", "Text Size", 8, 16, 1),
            durationoffset = slider(kind .. ".durationoffset", "Duration Offset", -50, 50, 2),
        },
        {
            countx = slider(kind .. ".countx", "Count X Offset", -50, 50, 1),
            county = slider(kind .. ".county", "Count Y Offset", -50, 50, 2),
        },
        {
            size = slider(kind .. ".size", "Icon Size", 16, 64, 1),
            padding = slider(kind .. ".padding", "Padding", 0, 20, 2),
            icons = slider(kind .. ".icons", "Icons Per Row", 1, 32, 3),
        },
    }
end

SUI.Config:RegisterLayout("Buffs", {
    order = 60,
    category = "buffs",
    rows = function()
        local rows = {
            { header = { type = "header", label = "General" } },
            {
                style = {
                    key = "style", type = "checkbox", label = "Style Auras", column = 4, order = 1, reload = true,
                    tooltip = "SUI borders and texts on the player buff and debuff frames",
                },
                layout = {
                    key = "layout", type = "checkbox", label = "Custom Layout", column = 4, order = 2,
                    tooltip = "Use the icon size, padding and icons per row below instead of the Edit Mode settings",
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
