--[[ SUI 2.0 - Features/UnitFrames/Options.lua
    The Unitframes tab. Keys are absolute because the statusbar texture is the
    shared general.texture; everything else lives in unitframes. Labels
    follow SUI 1.x.
]]

local _, ns = ...
local SUI = ns.SUI

local RETAIL = { Mainline = true }
local CLASSIC = { Classic = true }

local function checkbox(key, label, tooltip, order, clients)
    return { key = "unitframes." .. key, type = "checkbox", label = label, tooltip = tooltip, column = 4, order = order, clients = clients }
end

local function slider(key, label, min, max, step, order, clients)
    return { key = "unitframes." .. key, type = "slider", label = label, min = min, max = max, step = step, column = 4, order = order, clients = clients }
end

SUI.Config:RegisterLayout("Unitframes", {
    order = 20,
    rows = function()
        return {
            { header = { type = "header", label = "Player and Target" } },
            {
                style = {
                    key = "unitframes.style", type = "dropdown", label = "Style", column = 4, order = 1, clients = RETAIL, reload = true,
                    options = { { value = "Default", text = "Default" }, { value = "Classic", text = "Classic" } },
                },
                texture = {
                    key = "general.texture", type = "dropdown", label = "Texture", column = 4, order = 2,
                    options = SUI.Media:Options("statusbar"),
                },
                portrait = {
                    key = "unitframes.portrait", type = "dropdown", label = "Portrait", column = 4, order = 3,
                    tooltip = "Show class icons instead of 3D portraits for players",
                    options = { { value = "Default", text = "Default" }, { value = "ClassIcon", text = "Class Icon" } },
                },
            },
            {
                playersize = slider("player.size", "Player Size", 0.5, 2, 0.05, 1),
                targetsize = slider("target.size", "Target Size", 0.5, 2, 0.05, 2),
                focussize = slider("focus.size", "Focus Size", 0.5, 2, 0.05, 3),
            },
            {
                class = checkbox("classcolor", "Class Color", "Change healthcolor to class color", 1),
                faction = checkbox("factioncolor", "Reputation Color", "Show the reputation colored name background on target frames", 2),
                elite = checkbox("elitecolor", "Elite Color", "Keep the golden elite and rare dragon untinted", 3),
            },
            {
                pvp = checkbox("pvpbadge", "PvP Badge", "Display PVP icon on Unit frames", 1),
                hitindicator = checkbox("hitindicator", "Hit indicator", "Display numbers on Player Portrait", 2),
                combat = checkbox("combaticon", "Combat Icon", "Display combat icon on Unitframes", 3),
            },
            {
                totemicons = checkbox("totemicons", "Totem Icons", "Show Totem Icons (Consecration duration etc.) below the Player Unitframe", 1),
                classbar = checkbox("classbar", "Class Bar", "Show ClassBar (Combopoints, HolyPower etc.)", 2),
                cornericon = checkbox("cornericon", "Corner Icon", "Display corner icon on Unitframes", 3, RETAIL),
            },
            {
                hidename = checkbox("hidename", "Hide Name", "Hide names on Unitframes", 1),
                hidelevel = checkbox("hidelevel", "Hide Level", "Hide level text on Unitframes", 2),
                resting = checkbox("hideresting", "Hide Rest Textures", "Hide the resting glow on the Player Unitframe", 3),
            },
            {
                overshields = checkbox("overshields", "Overshields", "Show absorb shields that exceed missing health on the health bar", 1, RETAIL),
            },
            { header = { type = "header", label = "Target Auras" } },
            {
                buffmode = {
                    key = "unitframes.buffs.mode", type = "dropdown", label = "Buffs", column = 4, order = 1,
                    options = {
                        { value = "all", text = "Show All" },
                        { value = "normal", text = "Show Buffs" },
                        { value = "purgeable", text = "Show Purgeable" },
                        { value = "hide", text = "Hide" },
                    },
                },
                debuffmode = {
                    key = "unitframes.debuffs.mode", type = "dropdown", label = "Debuffs", column = 4, order = 2,
                    options = {
                        { value = "all", text = "Show All" },
                        { value = "own", text = "Show Own" },
                        { value = "hide", text = "Hide" },
                    },
                },
            },
            {
                buffsize = slider("buffs.size", "Target Buff Size", 10, 50, 1, 1, CLASSIC),
                debuffsize = slider("debuffs.size", "Target Debuff Size", 10, 50, 1, 2, CLASSIC),
                aurasize = slider("buffs.size", "Aura Size", 10, 50, 1, 1, RETAIL),
                ownsize = slider("debuffs.size", "Own Aura Size", 10, 50, 1, 2, RETAIL),
            },
            {
                buffperrow = slider("buffs.perrow", "Buffs Per Row", 1, 16, 1, 1, CLASSIC),
                debuffperrow = slider("debuffs.perrow", "Debuffs Per Row", 1, 16, 1, 2, CLASSIC),
                auraperrow = slider("buffs.perrow", "Auras Per Row", 1, 16, 1, 1, RETAIL),
            },
            {
                bufftextsize = slider("buffs.targettextsize", "Target Buff Text Size", 6, 20, 1, 1, CLASSIC),
                debufftextsize = slider("debuffs.targettextsize", "Target Debuff Text Size", 6, 20, 1, 2, CLASSIC),
            },
            {
                buffx = slider("buffs.targetx", "Buff X Offset", -50, 50, 1, 1, CLASSIC),
                buffy = slider("buffs.targety", "Buff Y Offset", -50, 50, 1, 2, CLASSIC),
            },
            {
                debuffx = slider("debuffs.targetx", "Debuff X Offset", -50, 50, 1, 1, CLASSIC),
                debuffy = slider("debuffs.targety", "Debuff Y Offset", -50, 50, 1, 2, CLASSIC),
            },
        }
    end,
})
