--[[
    SUI 2.0 - Features/Misc/Group.lua

    Group and looting helpers: interrupt announcements (retail reads
    UNIT_SPELLCAST_INTERRUPTED, classic the combat log), /pull through the
    Blizzard countdown, fast looting and re-listing groups that declined you
    in the retail group finder.
]]

local _, ns = ...
local SUI = ns.SUI

local Compat = SUI.Compat
local CanAccess = Compat.CanAccess

-- Interrupt announce ----------------------------------------------------------------
local lastAnnounce = 0

local function announce(destName, spellID)
    if Compat.IsRestrictedContext() then
        return
    end
    if not destName or not spellID or not CanAccess(destName) or not CanAccess(spellID) then
        return
    end
    local channel = (LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT")
        or (IsInRaid() and "RAID")
        or (IsInGroup() and "PARTY")
    if not channel then
        return
    end
    -- Retail reports one interrupt once per unit token of the caster.
    local now = GetTime()
    if now - lastAnnounce < 0.5 then
        return
    end
    local link = (C_Spell and C_Spell.GetSpellLink or GetSpellLink)(spellID)
    if not link then
        return
    end
    lastAnnounce = now
    local send = C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage
    send("INTERRUPTED " .. destName .. ": " .. link, channel)
end

local Interrupt = SUI:NewFeature("Misc.Interrupt", {
    category = "misc",
    toggle = "interrupt",
    clients = { Mainline = true },
})

function Interrupt:OnEnable()
    self.playerGUID = UnitGUID("player")
    -- The combat log is closed to add-ons since 12.0; this event carries the interrupter.
    self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "OnInterrupted")
end

function Interrupt:OnInterrupted(_, unit, _, spellID, interruptedBy)
    if interruptedBy and CanAccess(interruptedBy) and interruptedBy == self.playerGUID then
        announce(unit and UnitName(unit), spellID)
    end
end

local InterruptClassic = SUI:NewFeature("Misc.InterruptClassic", {
    category = "misc",
    toggle = "interrupt",
    clients = { Classic = true },
})

local getCombatLogInfo

function InterruptClassic:OnLoad()
    getCombatLogInfo = CombatLogGetCurrentEventInfo
end

function InterruptClassic:OnEnable()
    self.playerGUID = UnitGUID("player")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombatLog")
end

function InterruptClassic:OnCombatLog()
    local _, subEvent, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, extraSpellID = getCombatLogInfo()
    if subEvent == "SPELL_INTERRUPT" and sourceGUID == self.playerGUID then
        announce(destName, extraSpellID)
    end
end

-- Pull timer ------------------------------------------------------------------------
local PullTimer = SUI:NewFeature("Misc.PullTimer", {
    category = "misc",
    toggle = "pulltimer",
    conflicts = { "DBM-Core", "BigWigs" }, -- both own /pull
})

local function pull(input)
    local countdown = C_PartyInfo and C_PartyInfo.DoCountdown
    if not countdown then
        SUI:Print("Pull timers are not available on this client.")
        return
    end
    local seconds = tonumber(strtrim(input or "")) or 10
    countdown(math.max(0, math.min(floor(seconds), 3600))) -- 0 cancels
end

function PullTimer:OnEnable()
    SUI:RegisterChatCommand("pull", pull)
end

function PullTimer:OnDisable()
    SUI:UnregisterChatCommand("pull")
end

-- Fast loot ---------------------------------------------------------------------------
local FastLoot = SUI:NewFeature("Misc.FastLoot", {
    category = "misc",
    toggle = "fastloot",
})

function FastLoot:OnEnable()
    self:RegisterEvent("LOOT_READY", "Loot")
end

function FastLoot:Loot()
    if Compat.GetCVarBool("autoLootDefault") == IsModifiedClick("AUTOLOOTTOGGLE") then
        return
    end
    local now = GetTime()
    if now - (self.last or 0) < 0.3 then
        return
    end
    self.last = now
    for i = GetNumLootItems(), 1, -1 do
        LootSlot(i)
    end
end

-- Declined group listings (retail) ------------------------------------------------------
local LFGDeclined = SUI:NewFeature("Misc.LFGDeclined", {
    category = "misc",
    toggle = "lfgdeclined",
    clients = { Mainline = true },
})

local DECLINED = { declined = true, declined_delisted = true, declined_full = true, timedout = true }

function LFGDeclined:OnLoad()
    -- Blizzard remembers declines in LFGListFrame.declines and greys those
    -- listings out; forgetting them lists the groups as available again.
    self.forget = function()
        local frame = LFGListFrame
        local declines = frame and frame.declines
        if declines and next(declines) then
            wipe(declines)
            if LFGListSearchPanel_UpdateResults and frame.SearchPanel then
                securecallfunction(LFGListSearchPanel_UpdateResults, frame.SearchPanel)
            end
        end
    end
end

function LFGDeclined:OnEnable()
    self:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED", "OnStatus")
end

function LFGDeclined:OnStatus(_, _, newStatus)
    if DECLINED[newStatus] then
        -- Blizzard records the decline in its own handler; clear it afterwards.
        self:After(0, self.forget)
    end
end
