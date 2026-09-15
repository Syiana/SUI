--[[ SUI 2.0 - Features/UnitFrames/Options.lua
    The Unitframes tab. Keys are absolute because the statusbar texture is the
    shared general.texture; everything else lives in unitframes. Target aura
    settings are hidden while their aura type is hidden.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }

local function checkbox(key, label, tooltip, order, clients)
    return { key = "unitframes." .. key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order, clients = clients }
end

local function slider(key, label, min, max, step, order, tooltip, clients, hidden)
    return { key = "unitframes." .. key, type = "slider", label = label, min = min, max = max, step = step, column = 4, order = order,
             tooltip = tooltip, clients = clients, hidden = hidden }
end

local function buffsHidden()
    return SUI:Get("unitframes.buffs.mode") == "hide"
end

local function debuffsHidden()
    return SUI:Get("unitframes.debuffs.mode") == "hide"
end

local BUFF_MODES = {
    { value = "all", text = "Show All" },
    { value = "normal", text = "Show Buffs" },
    { value = "purgeable", text = "Show Purgeable" },
    { value = "hide", text = "Hide" },
}

local DEBUFF_MODES = {
    { value = "all", text = "Show All" },
    { value = "own", text = "Show Own" },
    { value = "hide", text = "Hide" },
}

local function modeDropdown(key, label, options, order, tooltip, clients)
    return { key = "unitframes." .. key, type = "dropdown", label = label, column = 4, order = order, rebuild = true,
             options = options, tooltip = tooltip, clients = clients }
end

local BUFF_TIP = "Which buffs the target and focus frames show."
local DEBUFF_TIP = "Which debuffs the target and focus frames show."

SUI.Config:RegisterLayout("Unitframes", {
    group = "units",
    order = 10,
    rows = function()
        return {
            { header = { type = "header", label = "Style" } },
            {
                style = {
                    key = "unitframes.style", type = "dropdown", label = "Style", column = 4, order = 1, clients = RETAIL, reload = true,
                    tooltip = "Classic puts the pre-Dragonflight art on the player, pet, target and focus frames; switching back needs a reload.",
                    options = { { value = "Default", text = "Default" }, { value = "Classic", text = "Classic" } },
                },
                texture = {
                    key = "general.texture", type = "dropdown", label = "Texture", column = 4, order = 2,
                    tooltip = "Statusbar texture of the unit frame health and power bars (not used by the Classic style).",
                    options = SUI.Media:Options("statusbar"),
                },
                portrait = {
                    key = "unitframes.portrait", type = "dropdown", label = "Portrait", column = 4, order = 3,
                    tooltip = "Show class icons instead of 3D portraits for players.",
                    options = { { value = "Default", text = "Default" }, { value = "ClassIcon", text = "Class Icon" } },
                },
            },
            { header = { type = "header", label = "Size" } },
            {
                playersize = slider("player.size", "Player", 0.5, 2, 0.05, 1, "Scale of the player frame."),
                targetsize = slider("target.size", "Target", 0.5, 2, 0.05, 2, "Scale of the target frame."),
                focussize = slider("focus.size", "Focus", 0.5, 2, 0.05, 3, "Scale of the focus frame."),
            },
            { header = { type = "header", label = "Colors" } },
            {
                class = checkbox("classcolor", "Class Colored Health", "Color health bars of players by class.", 1),
                faction = checkbox("factioncolor", "Reputation Color", "Show the reputation colored name background on target frames.", 2),
                elite = checkbox("elitecolor", "Keep Elite Color", "Keep the golden elite and rare dragon untinted by the theme.", 3),
            },
            { header = { type = "header", label = "Elements" } },
            {
                pvp = checkbox("pvpbadge", "Show PvP Badge", "Show the PvP icon on unit frames.", 1),
                hitindicator = checkbox("hitindicator", "Show Hit Indicator", "Show damage and healing numbers on the player and pet portraits.", 2),
                combat = checkbox("combaticon", "Show Combat Icon", "Show a combat icon next to the target and focus frames while that unit is in combat.", 3),
            },
            {
                totemicons = checkbox("totemicons", "Show Totem Icons", "Show totem icons (e.g. Consecration) below the player frame.", 1),
                classbar = checkbox("classbar", "Show Class Bar", "Show the class resource bar (combo points, holy power etc.).", 2),
                hidename = checkbox("hidename", "Hide Name", "Hide the names on unit frames.", 3),
            },
            {
                hidelevel = checkbox("hidelevel", "Hide Level", "Hide the level text on unit frames.", 1),
                resting = checkbox("hideresting", "Hide Resting Glow", "Hide the resting glow and icon on the player frame.", 2),
                cornericon = checkbox("cornericon", "Show Corner Icon", "Show the corner icon on the player portrait.", 3, RETAIL),
            },
            {
                overshields = checkbox("overshields", "Show Overshields", "Show absorb shields that exceed missing health on the health bar.", 1, RETAIL),
            },
            { header = { type = "header", label = "Target Auras" } },
            {
                buffmode = modeDropdown("buffs.mode", "Buffs", BUFF_MODES, 1, BUFF_TIP),
                buffsize = slider("buffs.size", "Buff Size", 10, 50, 1, 2, "Size of target and focus buff icons.", nil, buffsHidden),
                buffperrow = slider("buffs.perrow", "Buffs Per Row", 1, 16, 1, 3, "Number of buffs per row.", nil, buffsHidden),
            },
            {
                bufftextsize = slider("buffs.targettextsize", "Buff Text Size", 6, 20, 1, 1, "Font size of the buff stack counts and timers.", nil, buffsHidden),
                buffx = slider("buffs.targetx", "Buff X Offset", -50, 50, 1, 2, "Horizontal position of the buffs.", nil, buffsHidden),
                buffy = slider("buffs.targety", "Buff Y Offset", -50, 50, 1, 3, "Vertical position of the buffs.", nil, buffsHidden),
            },
            {
                debuffmode = modeDropdown("debuffs.mode", "Debuffs", DEBUFF_MODES, 1, DEBUFF_TIP),
                debuffsize = slider("debuffs.size", "Debuff Size", 10, 50, 1, 2, "Size of target and focus debuff icons.", nil, debuffsHidden),
                debuffperrow = slider("debuffs.perrow", "Debuffs Per Row", 1, 16, 1, 3, "Number of debuffs per row.", nil, debuffsHidden),
            },
            {
                debufftextsize = slider("debuffs.targettextsize", "Debuff Text Size", 6, 20, 1, 1, "Font size of the debuff stack counts and timers.", nil, debuffsHidden),
                debuffx = slider("debuffs.targetx", "Debuff X Offset", -50, 50, 1, 2, "Horizontal position of the debuffs.", nil, debuffsHidden),
                debuffy = slider("debuffs.targety", "Debuff Y Offset", -50, 50, 1, 3, "Vertical position of the debuffs.", nil, debuffsHidden),
            },
        }
    end,
})
