--[[
    SUI 2.0 - Features/CastBars/Options.lua

    The Castbars tab. Labels follow SUI 1.x; the timer (never shown in 1.x)
    and the statusbar texture are new. Focus options are hidden on Vanilla,
    which has no focus frame.
]]

local _, ns = ...
local SUI = ns.SUI

local FOCUS = { Mainline = true, Mists = true, TBC = true }

local function textures()
    local list = SUI.Media:Options("statusbar")
    table.insert(list, 1, { value = "Disabled", text = "Blizzard" })
    return list
end

SUI.Config:RegisterLayout("Castbars", {
    order = 50,
    category = "castbars",
    rows = function()
        local noBoss = function()
            return Boss1TargetFrameSpellBar == nil
        end
        return {
            { header = { type = "header", label = "Castbars" } },
            {
                style = {
                    key = "style", type = "dropdown", label = "Style", column = 5, order = 1,
                    tooltip = "Custom restyles the player, target, focus and boss castbars; Default keeps Blizzard's look",
                    options = { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } },
                },
                texture = { key = "texture", type = "dropdown", label = "Texture", tooltip = "Statusbar texture of the castbars (Blizzard keeps the default)", options = textures(), column = 5, order = 2 },
            },
            { header = { type = "header", label = "Settings" } },
            {
                casticons = { key = "icon", type = "checkbox", label = "Icons", tooltip = "Display spell icons on castbar", column = 4, order = 1 },
                casttime = { key = "timer", type = "checkbox", label = "Timer", tooltip = "Display cast time on castbar", column = 4, order = 2 },
                targetCastbar = { key = "targetCastbar", type = "checkbox", label = "Target Castbar", tooltip = "Custom Target Castbar", column = 4, order = 3 },
            },
            {
                focusCastbar = { key = "focusCastbar", type = "checkbox", label = "Focus Castbar", tooltip = "Custom Focus Castbar", clients = FOCUS, column = 4, order = 1 },
                bossCastbar = { key = "bossCastbar", type = "checkbox", label = "Boss Castbars", tooltip = "Give the boss frame castbars the Custom look (size, texture, icon, timer)", hidden = noBoss, column = 4, order = 2 },
            },
            { header = { type = "header", label = "Castbar Scales" } },
            {
                targetSize = { key = "targetSize", type = "slider", label = "Target", tooltip = "Scale of the target castbar", min = 0.5, max = 3, step = 0.1, precision = 1, column = 4, order = 1 },
                focusSize = { key = "focusSize", type = "slider", label = "Focus Target", tooltip = "Scale of the focus castbar", min = 0.5, max = 3, step = 0.1, precision = 1, clients = FOCUS, column = 4, order = 2 },
                bossSize = { key = "bossSize", type = "slider", label = "Boss", tooltip = "Scale of the boss castbars", min = 0.5, max = 3, step = 0.1, precision = 1, hidden = noBoss, column = 4, order = 3 },
            },
            { header = { type = "header", label = "Castbar On Top" } },
            {
                targetOnTop = { key = "targetOnTop", type = "checkbox", label = "Target", tooltip = "Display the Castbar above its Unitframe", column = 4, order = 1 },
                focusOnTop = { key = "focusOnTop", type = "checkbox", label = "Focus", tooltip = "Display the Castbar above its Unitframe", clients = FOCUS, column = 4, order = 2 },
            },
        }
    end,
})
