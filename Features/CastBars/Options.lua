--[[
    SUI 2.0 - Features/CastBars/Options.lua

    The Castbars tab. The icon and the target, focus and boss bars only use
    SUI's look with the Custom style, so their rows are hidden while Default is
    selected. Focus options are limited to clients with a focus frame; boss
    options are hidden when the client has no boss castbars.
]]

local _, ns = ...
local SUI = ns.SUI

local FOCUS = { Mainline = true, Mists = true, TBC = true }

local function textures()
    local list = SUI.Media:Options("statusbar")
    table.insert(list, 1, { value = "Disabled", text = "Blizzard" })
    return list
end

local function notCustom()
    return SUI:Get("castbars.style") ~= "Custom"
end

local function noBoss()
    return Boss1TargetFrameSpellBar == nil
end

-- Hidden unless the style is Custom and `key` is on.
local function off(key)
    return function()
        return notCustom() or not SUI:Get("castbars." .. key)
    end
end

local function check(key, label, tooltip, order, extra)
    local el = { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

local function scale(key, tooltip, order, extra)
    local el = { key = key, type = "slider", label = "Scale", tooltip = tooltip, min = 0.5, max = 3, step = 0.1, precision = 1, column = 4, order = order }
    for k, v in pairs(extra or {}) do
        el[k] = v
    end
    return el
end

SUI.Config:RegisterLayout("Castbars", {
    group = "units",
    order = 40,
    category = "castbars",
    rows = function()
        return {
            { header = { type = "header", label = "Style" } },
            {
                style = {
                    key = "style", type = "dropdown", label = "Style", column = 4, order = 1, rebuild = true,
                    tooltip = "Custom restyles the player, target, focus and boss castbars; Default keeps Blizzard's look.",
                    options = { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } },
                },
                texture = { key = "texture", type = "dropdown", label = "Texture", column = 4, order = 2, options = textures(),
                            tooltip = "Statusbar texture of the castbars (Blizzard keeps the default)." },
            },
            { header = { type = "header", label = "Elements" } },
            {
                icon = check("icon", "Spell Icon", "Show spell icons on the castbars.", 1, { hidden = notCustom }),
                timer = check("timer", "Cast Timer", "Show the remaining cast time next to the castbars.", 2),
            },
            { header = { type = "header", label = "Target", hidden = notCustom } },
            {
                targetCastbar = check("targetCastbar", "Custom Castbar", "Give the target castbar the Custom look; unchecked keeps Blizzard's.", 1,
                                      { rebuild = true, hidden = notCustom }),
                targetOnTop = check("targetOnTop", "On Top", "Show the target castbar above the target frame.", 2, { hidden = off("targetCastbar") }),
                targetSize = scale("targetSize", "Scale of the target castbar.", 3, { hidden = off("targetCastbar") }),
            },
            { header = { type = "header", label = "Focus", clients = FOCUS, hidden = notCustom } },
            {
                focusCastbar = check("focusCastbar", "Custom Castbar", "Give the focus castbar the Custom look; unchecked keeps Blizzard's.", 1,
                                     { clients = FOCUS, rebuild = true, hidden = notCustom }),
                focusOnTop = check("focusOnTop", "On Top", "Show the focus castbar above the focus frame.", 2, { clients = FOCUS, hidden = off("focusCastbar") }),
                focusSize = scale("focusSize", "Scale of the focus castbar.", 3, { clients = FOCUS, hidden = off("focusCastbar") }),
            },
            {
                header = {
                    type = "header", label = "Boss",
                    hidden = function()
                        return notCustom() or noBoss()
                    end,
                },
            },
            {
                bossCastbar = check("bossCastbar", "Custom Castbars", "Give the boss frame castbars the Custom look (size, texture, icon, timer).", 1, {
                    rebuild = true,
                    hidden = function()
                        return notCustom() or noBoss()
                    end,
                }),
                bossSize = scale("bossSize", "Scale of the boss castbars.", 2, {
                    hidden = function()
                        return noBoss() or off("bossCastbar")()
                    end,
                }),
            },
        }
    end,
})
