--[[
    SUI 2.0 - Features/NamePlates/Totems.lua

    Totem icons above totem nameplates with a duration sweep, recognised by
    the cached npc id. The combat log is closed to add-ons in 12.x, so the
    first sighting of a totem stands in for its summon time (kept per GUID,
    so walking out of range does not restart the sweep). Important totems glow.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, wipe, GetTime = next, wipe, GetTime

local F = SUI:NewFeature("NamePlates.TotemIcons", {
    category = "nameplates",
    toggle = "totemicons",
    conflicts = NP.conflicts,
})

local FALLBACK = [[Interface\Icons\Spell_Nature_StoneClawTotem]]

-- [npc id] = { spell id (icon), duration }
local RETAIL = {
    [2630] = { 2484, 20 },      -- Earthbind
    [60561] = { 51485, 20 },    -- Earthgrab
    [3527] = { 5394, 15 },      -- Healing Stream
    [6112] = { 8512, 120 },     -- Windfury
    [97369] = { 192222, 15 },   -- Liquid Magma
    [5913] = { 8143, 10 },      -- Tremor
    [5925] = { 204336, 3 },     -- Grounding
    [78001] = { 157153, 15 },   -- Cloudburst
    [53006] = { 98008, 6 },     -- Spirit Link
    [59764] = { 108280, 12 },   -- Healing Tide
    [61245] = { 192058, 2 },    -- Static Charge
    [100943] = { 198838, 15 },  -- Earthen Wall
    [97285] = { 192077, 15 },   -- Wind Rush
    [105451] = { 204331, 15 },  -- Counterstrike
    [104818] = { 207399, 30 },  -- Ancestral Protection
    [105427] = { 204330, 15 },  -- Skyfury
    [179867] = { 355580, 6 },   -- Static Field
    [166523] = { 324386, 30 },  -- Vesper
    [119052] = { 236320, 15 },  -- War Banner
    [101398] = { 211522, 12 },  -- Psyfiend
}

local MISTS = {
    [2630] = { 2484, 20 },      -- Earthbind
    [60561] = { 51485, 20 },    -- Earthgrab
    [3527] = { 5394, 15 },      -- Healing Stream
    [5913] = { 8143, 6 },       -- Tremor
    [5925] = { 8177, 15 },      -- Grounding
    [53006] = { 98008, 6 },     -- Spirit Link
    [59764] = { 108280, 10 },   -- Healing Tide
    [61245] = { 108269, 5 },    -- Capacitor
    [10467] = { 16190, 16 },    -- Mana Tide
    [59717] = { 108273, 6 },    -- Windwalk
    [59712] = { 108270, 30 },   -- Stone Bulwark
    [2523] = { 3599, 60 },      -- Searing
    [5929] = { 8190, 60 },      -- Magma
    [15439] = { 2894, 60 },     -- Fire Elemental
    [15430] = { 2062, 60 },     -- Earth Elemental
}

local CLASSIC = {
    [2630] = { 2484, 20 },      -- Earthbind
    [5925] = { 8177, 45 },      -- Grounding
    [3968] = { 6495, 300 },     -- Sentry
    [15430] = { 2062, 120 },    -- Earth Elemental
    [15439] = { 2894, 120 },    -- Fire Elemental
    [15447] = { 3738, 120 },    -- Wrath of Air
    [17539] = { 30706, 120 },   -- Totem of Wrath
    [5924] = { 8170, 120 },     -- Disease Cleansing
    [5923] = { 8166, 120 },     -- Poison Cleansing
    [15803] = { 25908, 120 },   -- Tranquil Air
    [5913] = { 8143, 120 },     -- Tremor
    [10467] = { 16190, 12 },    -- Mana Tide
}
-- Ranked totems share one icon: { spell, duration, npc ids... }
local CLASSIC_RANKS = {
    { 5675, 120, 3573, 7414, 7415, 7416, 15489 },                -- Mana Spring
    { 1535, 5, 5879, 6110, 6111, 7844, 7845, 15482, 15483 },     -- Fire Nova
    { 8187, 20, 5929, 7464, 7465, 7466, 15484 },                 -- Magma
    { 3599, 60, 2523, 3902, 3903, 3904, 7400, 7402, 15480 },     -- Searing
    { 5730, 15, 3579, 3911, 3912, 3913, 7398, 7399, 15478 },     -- Stoneclaw
    { 8184, 120, 5927, 7424, 7425, 15487 },                      -- Fire Resistance
    { 8227, 120, 5950, 6012, 7423, 10557, 15485 },               -- Flametongue
    { 8181, 120, 5926, 7412, 7413, 15486 },                      -- Frost Resistance
    { 8835, 120, 7486, 7487, 15463 },                            -- Grace of Air
    { 10595, 120, 7467, 7468, 7469, 15490 },                     -- Nature Resistance
    { 8071, 120, 5873, 5919, 5920, 7366, 7367, 7368, 15470, 15474 }, -- Stoneskin
    { 8075, 120, 5874, 5921, 5922, 7403, 15464, 15479 },         -- Strength of Earth
    { 8512, 120, 6112, 7483, 7484, 15496, 15497 },               -- Windfury
    { 15107, 120, 9687, 9688, 9689, 15492 },                     -- Windwall
    { 5394, 120, 3527, 3906, 3907, 3908, 3909, 15488 },          -- Healing Stream
}

local GLOW = { [5925] = true, [5913] = true, [105427] = true, [10467] = true }

local totems
local icons = {}      -- plate state -> icon frame
local startTimes = {} -- guid -> first sighting
local Glow

local function createIcon(st)
    local frame = CreateFrame("Frame", nil, st.plate)
    frame:SetSize(25, 25)
    frame:SetPoint("BOTTOM", st.plate, "TOP", 0, 5)
    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetAllPoints()
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetColorTexture(0, 0, 0, 0.5)
    bg:SetPoint("TOPLEFT", -2, 2)
    bg:SetPoint("BOTTOMRIGHT", 2, -2)
    local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    cooldown.noCooldownCount = true
    cooldown:SetHideCountdownNumbers(true)
    cooldown:SetReverse(true)
    cooldown:SetDrawEdge(false)
    cooldown:SetAllPoints()
    frame.icon, frame.cooldown = icon, cooldown
    icons[st] = frame
    return frame
end

local function release(frame)
    frame:Hide()
    if Glow then
        Glow.ButtonGlow_Stop(frame)
    end
end

local function update(st)
    local data = st.npcId and totems[st.npcId]
    local frame = icons[st]
    if not data then
        if frame then
            release(frame)
        end
        return
    end
    frame = frame or createIcon(st)
    frame.icon:SetTexture(SUI.Compat.GetSpellTexture(data[1]) or FALLBACK)
    local now, guid = GetTime(), st.guid
    local start = guid and startTimes[guid] or now
    if guid then
        startTimes[guid] = start
    end
    frame.cooldown:SetCooldown(start, data[2])
    frame:Show()
    if Glow then
        if GLOW[st.npcId] then
            Glow.ButtonGlow_Start(frame)
        else
            Glow.ButtonGlow_Stop(frame)
        end
    end
end

function F:OnLoad()
    Glow = LibStub("LibCustomGlow-1.0", true)
    if SUI.IsRetail then
        totems = RETAIL
    elseif SUI.IsMists then
        totems = MISTS
    else
        totems = CLASSIC
        for _, rank in next, CLASSIC_RANKS do
            local data = { rank[1], rank[2] }
            for i = 3, #rank do
                totems[rank[i]] = data
            end
        end
    end
end

function F:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Removed")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Reset")
    for _, frame in next, NP.byUnit do
        update(NP.state[frame])
    end
end

function F:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        update(st)
    end
end

function F:Removed()
    local st = NP.removed
    local frame = st and icons[st]
    if not frame then
        return
    end
    release(frame)
    -- Forget the start time once the totem cannot be alive any more.
    local guid, data = st.guid, st.npcId and totems[st.npcId]
    if guid and data and startTimes[guid] and GetTime() - startTimes[guid] >= data[2] then
        startTimes[guid] = nil
    end
end

function F:Reset()
    wipe(startTimes)
end

function F:OnDisable()
    for _, frame in next, icons do
        release(frame)
    end
end
