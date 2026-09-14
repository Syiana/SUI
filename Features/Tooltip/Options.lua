--[[
    SUI 2.0 - Features/Tooltip/Options.lua

    The Tooltip tab. Labels follow SUI 1.x where the option existed.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }

local function textures()
    local list = SUI.Media:Options("statusbar")
    table.insert(list, 1, { value = SUI:GetDefaults("tooltip").texture, text = "SUI Tooltip" })
    return list
end

SUI.Config:RegisterLayout("Tooltip", {
    order = 70,
    category = "tooltip",
    rows = function()
        return {
            { header = { type = "header", label = "Tooltip" } },
            {
                style = {
                    key = "style", type = "dropdown", label = "Style", column = 4, order = 1,
                    tooltip = "Custom colours names, guild, level and health bar and adds a target line",
                    options = { { value = "Default", text = "Default" }, { value = "Custom", text = "Custom" } },
                },
                texture = {
                    key = "texture", type = "dropdown", label = "Health Bar Texture", column = 4, order = 2,
                    tooltip = "Health bar texture of the Custom style", options = textures(),
                },
            },
            { header = { type = "header", label = "Behavior" } },
            {
                mouseanchor = { key = "mouseanchor", type = "checkbox", label = "Mouse Anchor",
                                tooltip = "Attach tooltip to mouse cursor", column = 4, order = 1 },
                lifeontop = { key = "lifeontop", type = "checkbox", label = "Life on Top",
                              tooltip = "Show HP bar in tooltip on top", column = 4, order = 2 },
                hideincombat = { key = "hideincombat", type = "checkbox", label = "Hide in Combat",
                                 tooltip = "Hide tooltips while in combat", column = 4, order = 3 },
            },
            { header = { type = "header", label = "Information" } },
            {
                ids = { key = "ids", type = "checkbox", label = "IDs",
                        tooltip = "Show spell, item and NPC IDs", column = 4, order = 1 },
                itemlevel = { key = "itemlevel", type = "checkbox", label = "Item Level",
                              tooltip = "Show the item level of players (inspects players out of combat)",
                              clients = { Mainline = true, Mists = true }, column = 4, order = 2 },
                mythicplus = { key = "mythicplus", type = "checkbox", label = "Mythic+ Rating",
                               tooltip = "Show the Mythic+ rating of players", clients = RETAIL, column = 4, order = 3 },
            },
            {
                pvprating = { key = "pvprating", type = "checkbox", label = "PvP Rating",
                              tooltip = "Show arena and Solo Shuffle ratings of players (inspects players out of combat)",
                              clients = RETAIL, column = 4, order = 1 },
                lfgtooltips = { key = "lfgtooltips", type = "checkbox", label = "Group Finder",
                                tooltip = "Show the leader's Mythic+ rating in group listings and let non-leaders hover applicants",
                                clients = RETAIL, column = 4, order = 2 },
            },
        }
    end,
})
