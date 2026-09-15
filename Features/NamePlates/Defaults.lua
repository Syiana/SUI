--[[
    SUI 2.0 - Features/NamePlates/Defaults.lua

    Defaults and migrations for the nameplates category. The NPC colour list
    is user data: only an empty list lives in the defaults, the 1.x list is
    seeded once per profile by a migration (flag `npcseeded`).
]]

local _, ns = ...
local SUI = ns.SUI

local type, pairs, rawget, tonumber = type, pairs, rawget, tonumber

local CONFLICTS = { "Plater", "TidyPlates_ThreatPlates", "TidyPlates", "Kui_Nameplates" }
ns.NamePlates = {
    conflicts = CONFLICTS,
    -- 1.x: most of the look only applies with the Custom style.
    isCustom = function(db)
        return db.style == "Custom"
    end,
}

SUI:RegisterDefaults("nameplates", {
    style = "Default",
    texture = SUI.Media.statusbar,
    height = 2,
    width = 1,
    stackingmode = false,
    healthtext = true,
    decimals = 0,
    server = true,
    color = true,
    arenanumber = true,
    totemicons = false, -- 1.x never loaded totem icons
    casttime = true,
    debuffs = false,
    focusHighlight = false,
    colors = true,
    threat = true,
    npccolors = {},
    npcseeded = false,
    npctypes = {
        enabled = false,
        instancesonly = true,
        boss = { r = 0.74, g = 0.11, b = 0, a = 1 },
        miniboss = { r = 0.57, g = 0, b = 0.74, a = 1 },
        caster = { r = 0, g = 0.46, b = 0.74, a = 1 },
    },
    castbar = {
        colors = false,
        cooldown = { r = 0.85, g = 0.15, b = 0.15, a = 1 },
        uninterruptible = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
    },
    classicons = { enabled = false, pvponly = true, size = 22 },
    healer = { enabled = false, size = 18 },
    target = { enabled = false, size = 16, color = { r = 1, g = 1, b = 1, a = 1 } },
    raidmarker = { enabled = false, size = 22, anchor = "TOP", x = 0, y = 4 },
    auras = { enabled = false, cc = true, important = true, size = 20 },
    cvars = { enabled = false, friendlynpcs = false, onlynames = false, offscreen = false, maxdistance = 41 },
    personalbar = {
        style = "Custom",
        texture = SUI.Media.textures .. [[Status\Flat.blp]],
        width = 130,
        height = 14,
        manaheight = 8,
    },
})

-- 1.x default NPC colour list (Mythic+ casters): { npc id, name }.
local DEFAULT_NPCS = {
    -- Mists of Tirna Scithe
    { 164921, "Drust Harvester" }, { 166275, "Mistveil Shaper" }, { 166299, "Mistveil Tender" }, { 167111, "Spinemaw Staghorn" },
    -- The Necrotic Wake
    { 166302, "Corpse Harvester" }, { 165137, "Zolramus Gatekeeper" }, { 163128, "Zolramus Sorcerer" },
    { 163618, "Zolramus Necromancer" }, { 163126, "Brittlebone Mage" }, { 165919, "Skeletal Marauder" },
    { 165824, "Nar'zudah" }, { 173016, "Corpse Collector" },
    -- Siege of Boralus
    { 129370, "Irontide Waveshaper" }, { 128969, "Ashvane Commander" }, { 135241, "Bilge Rat Pillager" },
    { 129367, "Bilge Rat Tempest" }, { 144071, "Irontide Waveshaper" },
    -- The Stonevault
    { 212389, "Cursedheart Invader" }, { 212453, "Ghastly Voidsoul" }, { 213338, "Forgebound Mender" },
    { 221979, "Void Bound Howler" }, { 214350, "Turned Speaker" }, { 214066, "Cursedforge Stoneshaper" },
    { 224962, "Cursedforge Mender" },
    -- The Dawnbreaker
    { 213892, "Nightfall Shadowmage" }, { 214762, "Nightfall Commander" }, { 210966, "Sureki Webmage" },
    { 213893, "Nightfall Darkcaster" }, { 213932, "Sureki Militant" },
    -- Grim Batol
    { 224219, "Twilight Earthcaller" }, { 40167, "Twilight Beguiler" }, { 224271, "Twilight Warlock" },
    -- Ara-Kara
    { 216293, "Trilling Attendant" }, { 217531, "Ixin" }, { 218324, "Nakt" }, { 217533, "Atik" },
    { 223253, "Bloodstained Webmage" }, { 216340, "Sentry Stagshell" }, { 220599, "Bloodstained Webmage" },
    { 216364, "Blood Overseer" },
    -- City of Threads
    { 220195, "Sureki Silkbinder" }, { 220196, "Herald Of Ansurek" }, { 219984, "Xephitik" },
    { 223844, "Covert Webmancer" }, { 224732, "Covert Webmancer" }, { 216339, "Sureki Unnaturaler" },
    { 221102, "Elder Shadeweaver" },
}

local function nameplatesOf(profile)
    local np = rawget(profile, "nameplates")
    if type(np) ~= "table" then
        np = {}
        profile.nameplates = np
    end
    return np
end

-- Seeds the NPC colour list once. 1.x kept the list in the defaults, so AceDB
-- saved only per-index differences from it: rebuild the list the user saw by
-- laying those differences over the 1.x defaults.
SUI:RegisterMigration("nameplates-1x-npccolors", function(profile)
    local np = nameplatesOf(profile)
    if rawget(np, "npcseeded") then
        return
    end
    local list, count = {}, #DEFAULT_NPCS
    for i = 1, count do
        list[i] = { id = DEFAULT_NPCS[i][1], name = DEFAULT_NPCS[i][2], color = { r = 0, g = 0.55, b = 1, a = 1 } }
    end
    local saved = rawget(np, "npccolors")
    if type(saved) == "table" then
        for i, diff in pairs(saved) do
            if type(i) == "number" and type(diff) == "table" then
                local entry = list[i] or { color = { r = 0, g = 0.55, b = 1, a = 1 } }
                list[i] = entry
                if i > count then
                    count = i
                end
                for k, v in pairs(diff) do
                    if k == "color" and type(v) == "table" then
                        for ck, cv in pairs(v) do
                            entry.color[ck] = cv
                        end
                    else
                        entry[k] = v
                    end
                end
            end
        end
    end
    local clean = {}
    for i = 1, count do
        local entry = list[i]
        if entry and tonumber(entry.id) and entry.name then
            entry.id = tonumber(entry.id)
            clean[#clean + 1] = entry
        end
    end
    np.npccolors = clean
    np.npcseeded = true
end)

-- 1.x stored the decimals dropdown value as a string ("0", "1", "2").
SUI:RegisterMigration("nameplates-decimals-number", function(profile)
    local np = rawget(profile, "nameplates")
    if type(np) == "table" and type(rawget(np, "decimals")) == "string" then
        np.decimals = tonumber(np.decimals) or 0
    end
end)

-- The personal resource bar lived under unitframes.personalbar in 1.x.
SUI:RegisterMigration("nameplates-1x-personalbar", function(profile)
    local uf = rawget(profile, "unitframes")
    local old = type(uf) == "table" and rawget(uf, "personalbar")
    if type(old) ~= "table" then
        return
    end
    local np = nameplatesOf(profile)
    local target = rawget(np, "personalbar")
    if type(target) ~= "table" then
        target = {}
        np.personalbar = target
    end
    for k, v in pairs(old) do
        target[k] = v
    end
    uf.personalbar = nil
end)

-- Totem icons and castbar interrupt colours are new visuals: 1.x never showed
-- them, so profiles from 1.x start with them off.
SUI:RegisterMigration("nameplates-1x-unused-visuals", function(profile)
    local np = nameplatesOf(profile)
    np.totemicons = false
    local castbar = rawget(np, "castbar")
    if type(castbar) ~= "table" then
        castbar = {}
        np.castbar = castbar
    end
    castbar.colors = false
end)
