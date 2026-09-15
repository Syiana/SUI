--[[
    SUI 2.0 - Features/Tooltip/Info.lua

    Extra lines on tooltips: spell/item/NPC ids, Mythic+ rating, item level
    and PvP rating of players. Item level and PvP rating of other players need
    an inspect; requests are throttled, only sent out of combat and cached per
    player, so hovering a crowd does not spam the server.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, floor, tonumber, next = _G, math.floor, tonumber, next
local CanAccess = SUI.Compat.CanAccess
local GetTime, InCombatLockdown = GetTime, InCombatLockdown
local UnitIsPlayer, UnitIsUnit, UnitGUID = UnitIsPlayer, UnitIsUnit, UnitGUID

local LABEL_R, LABEL_G, LABEL_B = 0, 0.6, 1

local function playerUnit(tooltip)
    local unit = ns.TooltipUnit(tooltip)
    if not unit then
        return nil
    end
    local isPlayer = UnitIsPlayer(unit)
    if CanAccess(isPlayer) and isPlayer then
        return unit
    end
end

-- Ids ---------------------------------------------------------------------------------
-- ids: spell and macro ids (1.x); itemids: item and NPC ids (new in 2.0).
local Ids = SUI:NewFeature("Tooltip.Ids", {
    category = "tooltip",
    toggle = function(db)
        return db.ids or db.itemids
    end,
})

local ID_LABEL = "|cff0099ffID|r"
local GetItemInfoInstant

local function addId(tooltip, id)
    if not id or not CanAccess(id) then
        return
    end
    -- Classic fires OnTooltipSetItem twice for some items; do not add a second line.
    local name = tooltip:GetName()
    if name then
        local last = _G[name .. "TextLeft" .. tooltip:NumLines()]
        local text = last and last:GetText()
        if text and CanAccess(text) and text == ID_LABEL then
            return
        end
    end
    tooltip:AddDoubleLine(ID_LABEL, id, 1, 1, 1, 1, 1, 1)
    tooltip:Show()
end

local function onSpell(tooltip, data)
    if not Ids.enabled or not Ids.db.ids or tooltip:IsForbidden() then
        return
    end
    local id = data and data.id
    if not id and tooltip.GetSpell then
        local _, a, b = tooltip:GetSpell()
        id = tonumber(b) or tonumber(a)
    end
    addId(tooltip, id)
end

local function onItem(tooltip, data)
    if not Ids.enabled or not Ids.db.itemids or tooltip:IsForbidden() then
        return
    end
    local id = data and data.id
    if not id and tooltip.GetItem then
        local _, link = tooltip:GetItem()
        if link and CanAccess(link) and GetItemInfoInstant then
            id = GetItemInfoInstant(link)
        end
    end
    addId(tooltip, id)
end

local function onUnit(tooltip, data)
    if not Ids.enabled or not Ids.db.itemids or tooltip ~= GameTooltip then
        return
    end
    local guid = data and data.guid
    if not guid then
        local unit = ns.TooltipUnit(tooltip)
        guid = unit and UnitGUID(unit)
    end
    if not guid or not CanAccess(guid) then
        return
    end
    local kind, _, _, _, _, npcId = strsplit("-", guid)
    if kind == "Creature" or kind == "Vehicle" then
        addId(tooltip, npcId)
    end
end

-- Retail macro tooltips: the second line holds the spell name.
local function onMacro(tooltip, data)
    if not Ids.enabled or not Ids.db.ids or tooltip:IsForbidden() then
        return
    end
    local lines = data and data.lines
    local line = lines and lines[2]
    local text = line and line.leftText
    if text and CanAccess(text) then
        local _, _, id = SUI.Compat.GetSpellInfo(text)
        addId(tooltip, id)
    end
end

function Ids:OnLoad()
    GetItemInfoInstant = SUI.Compat.GetItemInfoInstant
    SUI.Compat.OnTooltipSpell(onSpell)
    SUI.Compat.OnTooltipItem(onItem)
    SUI.Compat.OnTooltipUnit(onUnit)
    local processor, types = _G.TooltipDataProcessor, Enum and Enum.TooltipDataType
    if processor and types and types.Macro then
        processor.AddTooltipPostCall(types.Macro, onMacro)
    end
end

-- Mythic+ rating --------------------------------------------------------------------------
local MythicPlus = SUI:NewFeature("Tooltip.MythicPlus", {
    category = "tooltip",
    toggle = "mythicplus",
    clients = { Mainline = true },
})

local function onMythicPlusUnit(tooltip)
    if not MythicPlus.enabled or tooltip ~= GameTooltip then
        return
    end
    local unit = playerUnit(tooltip)
    local summary = unit and C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
    local score = summary and summary.currentSeasonScore
    if not score or not CanAccess(score) or score <= 0 then
        return
    end
    local r, g, b = 1, 1, 1
    local color = C_ChallengeMode.GetDungeonScoreRarityColor(score)
    if color then
        r, g, b = color.r, color.g, color.b
    end
    tooltip:AddDoubleLine("Mythic+ Rating", score, LABEL_R, LABEL_G, LABEL_B, r, g, b)
    tooltip:Show()
end

function MythicPlus:OnLoad()
    SUI.Compat.OnTooltipUnit(onMythicPlusUnit)
end

-- Item level and PvP rating (inspect) -----------------------------------------------------------
local Inspect = SUI:NewFeature("Tooltip.Inspect", {
    category = "tooltip",
    clients = { Mainline = true, Mists = true },
    toggle = function(db)
        return db.itemlevel or db.pvprating
    end,
})

local CACHE_TIME = 300   -- seconds an inspect result stays valid
local REQUEST_GAP = 1.5  -- seconds between two inspect requests
local BRACKET_2V2, BRACKET_3V3, BRACKET_SHUFFLE = 1, 2, 7
local PVP_STEPS = { 2400, 2100, 1800, 1400, 1000 }
local PVP_COLORS = { { 0.95, 0.55, 0.27 }, { 1, 0.5, 0 }, { 0.64, 0.21, 0.93 }, { 0, 0.44, 0.87 }, { 0.12, 1, 0 } }

local cache = {} -- guid -> { time, ilvl, solo, v2, v3 }
local pendingGuid, pendingUnit
local lastRequest = 0
local GetInspectItemLevel, GetInspectShuffle, hasPvP

local function pvpColor(rating)
    for i = 1, #PVP_STEPS do
        if rating >= PVP_STEPS[i] then
            local c = PVP_COLORS[i]
            return c[1], c[2], c[3]
        end
    end
    return 0.62, 0.62, 0.62
end

local function addRating(tooltip, label, rating)
    if rating and rating > 0 then
        local r, g, b = pvpColor(rating)
        tooltip:AddDoubleLine(label, rating, LABEL_R, LABEL_G, LABEL_B, r, g, b)
    end
end

local function addLines(tooltip, ilvl, solo, v2, v3)
    local db = Inspect.db
    if db.itemlevel and ilvl and ilvl > 0 then
        tooltip:AddDoubleLine("Item Level", floor(ilvl), LABEL_R, LABEL_G, LABEL_B, 1, 1, 1)
    end
    if db.pvprating and hasPvP then
        addRating(tooltip, "Solo Shuffle", solo)
        addRating(tooltip, "2v2 Rating", v2)
        addRating(tooltip, "3v3 Rating", v3)
    end
    tooltip:Show()
end

local function request(unit, guid)
    local now = GetTime()
    if now - lastRequest < REQUEST_GAP or InCombatLockdown() or (InspectFrame and InspectFrame:IsShown()) then
        return
    end
    local canInspect = CanInspect(unit)
    if not CanAccess(canInspect) or not canInspect then
        return
    end
    lastRequest = now
    pendingGuid, pendingUnit = guid, unit
    NotifyInspect(unit)
end

local function onInspectUnit(tooltip)
    if not Inspect.enabled or tooltip ~= GameTooltip then
        return
    end
    local unit = playerUnit(tooltip)
    if not unit then
        return
    end
    local isYou = UnitIsUnit(unit, "player")
    if CanAccess(isYou) and isYou then
        local _, equipped = GetAverageItemLevel()
        local solo = hasPvP and GetPersonalRatedInfo(BRACKET_SHUFFLE)
        local v2 = hasPvP and GetPersonalRatedInfo(BRACKET_2V2)
        local v3 = hasPvP and GetPersonalRatedInfo(BRACKET_3V3)
        addLines(tooltip, equipped, solo or nil, v2 or nil, v3 or nil)
        return
    end
    local guid = UnitGUID(unit)
    if not guid or not CanAccess(guid) then
        return
    end
    local entry = cache[guid]
    if entry and GetTime() - entry.time < CACHE_TIME then
        addLines(tooltip, entry.ilvl, entry.solo, entry.v2, entry.v3)
    elseif GetInspectItemLevel or hasPvP then
        request(unit, guid)
    end
end

function Inspect:OnLoad()
    local paperDoll = _G.C_PaperDollInfo
    GetInspectItemLevel = paperDoll and paperDoll.GetInspectItemLevel
    GetInspectShuffle = paperDoll and paperDoll.GetInspectRatedSoloShuffleData
    hasPvP = GetInspectShuffle ~= nil and _G.GetInspectArenaData ~= nil
    SUI.Compat.OnTooltipUnit(onInspectUnit)
end

function Inspect:OnEnable()
    self:RegisterEvent("INSPECT_READY")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ClearCache")
end

function Inspect:OnDisable()
    pendingGuid, pendingUnit = nil, nil
end

function Inspect:ClearCache()
    for guid in next, cache do
        cache[guid] = nil
    end
end

function Inspect:INSPECT_READY(_, guid)
    if not guid or not CanAccess(guid) or guid ~= pendingGuid then
        return
    end
    local unit = pendingUnit
    pendingGuid, pendingUnit = nil, nil
    local unitGuid = UnitGUID(unit)
    if not CanAccess(unitGuid) or unitGuid ~= guid then
        return
    end
    local entry = cache[guid]
    if not entry then
        entry = {}
        cache[guid] = entry
    end
    entry.time = GetTime()
    entry.ilvl = GetInspectItemLevel and GetInspectItemLevel(unit) or nil
    if hasPvP then
        entry.v2 = GetInspectArenaData(BRACKET_2V2)
        entry.v3 = GetInspectArenaData(BRACKET_3V3)
        local shuffle = GetInspectShuffle()
        entry.solo = shuffle and shuffle.rating or nil
    end
    -- Refill the tooltip if it still shows this player.
    if GameTooltip:IsShown() then
        local shown = ns.TooltipUnit(GameTooltip)
        local shownGuid = shown and UnitGUID(shown)
        if shownGuid and CanAccess(shownGuid) and shownGuid == guid then
            GameTooltip:SetUnit(shown)
        end
    end
end
