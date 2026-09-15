--[[
    SUI 2.0 - Features/Tooltip/Options.lua

    The Tooltip tab. Health bar options belong to the Custom style and are
    hidden while the Default style is selected.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }

local function textures()
    local list = SUI.Media:Options("statusbar")
    table.insert(list, 1, { value = SUI:GetDefaults("tooltip").texture, text = "SUI Tooltip" })
    return list
end

local function notCustom()
    return SUI:Get("tooltip.style") ~= "Custom"
end

local function check(key, label, tooltip, order, clients)
    return { key = key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order, clients = clients }
end

SUI.Config:RegisterLayout("Tooltip", {
    group = "interface",
    order = 40,
    category = "tooltip",
    rows = function()
        return {
            { header = { type = "header", label = "Style" } },
            {
                style = {
                    key = "style", type = "dropdown", label = "Style", column = 4, order = 1, rebuild = true,
                    tooltip = "Custom colors names, guild, level and health bar and adds a target line; Default keeps Blizzard's tooltip.",
                    options = { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } },
                },
                texture = {
                    key = "texture", type = "dropdown", label = "Health Bar Texture", column = 4, order = 2,
                    tooltip = "Texture of the tooltip health bar.", options = textures(), hidden = notCustom,
                },
            },
            {
                lifeontop = { key = "lifeontop", type = "checkbox", label = "Health Bar on Top", column = 4, order = 1, hidden = notCustom,
                              tooltip = "Place the health bar at the top of the tooltip instead of the bottom." },
            },
            { header = { type = "header", label = "Behavior" } },
            {
                mouseanchor = check("mouseanchor", "Anchor to Cursor", "Attach tooltips to the mouse cursor.", 1),
                hideincombat = check("hideincombat", "Hide in Combat", "Hide tooltips while you are in combat.", 2),
            },
            { header = { type = "header", label = "Information" } },
            {
                ids = check("ids", "Spell IDs", "Show spell and macro spell IDs.", 1),
                itemids = check("itemids", "Item and NPC IDs", "Show item and NPC IDs.", 2),
                itemlevel = check("itemlevel", "Item Level", "Show the item level of players (inspects them out of combat).", 3, { Mainline = true, Mists = true }),
            },
            {
                mythicplus = check("mythicplus", "Mythic+ Rating", "Show the Mythic+ rating of players.", 1, RETAIL),
                pvprating = check("pvprating", "PvP Rating", "Show arena and Solo Shuffle ratings of players (inspects them out of combat).", 2, RETAIL),
                lfgtooltips = check("lfgtooltips", "Group Finder Info", "Show the leader's Mythic+ rating in group listings and let non-leaders hover applicants.", 3, RETAIL),
            },
        }
    end,
})
