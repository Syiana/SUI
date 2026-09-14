--[[
    SUI 2.0 - Features/Misc/PvP.lua

    Small PvP helpers: Tab Binder (TAB targets only players in PvP), arena
    dampening below the arena timer, arena numbers on enemy nameplates,
    /gg to surrender and buttons in the conquest frame that track the
    season's rated achievements.
]]

local _, ns = ...
local SUI = ns.SUI

local next, strfind, select = next, string.find, select
local CanAccess = SUI.Compat.CanAccess

local function inArena()
    return select(2, IsInInstance()) == "arena"
end

-- Tab Binder ------------------------------------------------------------------------
local TabBinder = SUI:NewFeature("Misc.TabBinder", {
    category = "misc",
    toggle = "tabbinder",
})

local PLAYER_ACTION = {
    TARGETNEARESTENEMY = "TARGETNEARESTENEMYPLAYER",
    TARGETPREVIOUSENEMY = "TARGETPREVIOUSENEMYPLAYER",
}

local function take(moved, action, key)
    if key and SetBinding(key, PLAYER_ACTION[action]) then
        moved[key] = action
        return true
    end
    return false
end

-- Moves the enemy target keys to the player-only actions (pvp) or gives
-- back exactly the keys moved before, unless the user rebound them since.
local function applyBindings(pvp)
    local moved = SUI.db.char.misc.tabbinder
    local changed = false
    if pvp then
        for action in next, PLAYER_ACTION do
            local key1, key2 = GetBindingKey(action)
            changed = take(moved, action, key1) or changed
            changed = take(moved, action, key2) or changed
        end
    else
        for key, action in next, moved do
            if GetBindingAction(key) == PLAYER_ACTION[action] then
                SetBinding(key, action)
                changed = true
            end
            moved[key] = nil
        end
    end
    if changed then
        SaveBindings(GetCurrentBindingSet())
    end
end

function TabBinder:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Update")
    self:RegisterEvent("DUEL_REQUESTED", "Update")
    self:RegisterEvent("DUEL_FINISHED", "Update")
    self:Update()
end

function TabBinder:OnDisable()
    self.duel = nil
    SUI:RunAfterCombat(function()
        if not TabBinder.enabled then
            applyBindings(false)
        end
    end)
end

function TabBinder:Update(event)
    if event == "DUEL_REQUESTED" then
        self.duel = true
    elseif event == "DUEL_FINISHED" then
        self.duel = nil
    end
    -- Bindings cannot change in combat.
    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED", "Update")
        return
    end
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")

    local _, instanceType = IsInInstance()
    local zoneType = (C_PvP and C_PvP.GetZonePVPInfo or GetZonePVPInfo)()
    applyBindings(self.duel or instanceType == "arena" or instanceType == "pvp" or zoneType == "combat" or zoneType == "arena")
end

-- Dampening -------------------------------------------------------------------------
local Dampening = SUI:NewFeature("Misc.Dampening", {
    category = "misc",
    toggle = "dampening",
    clients = { Mainline = true, Mists = true },
})

function Dampening:OnLoad()
    self.getPercent = C_Commentator and C_Commentator.GetDampeningPercent
    self.format = (SUI.Compat.GetSpellInfo(110310) or "Dampening") .. ": %d%%"

    local anchor = UIWidgetTopCenterContainerFrame
    local text = UIParent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    if anchor then
        text:SetPoint("TOP", anchor, "BOTTOM", 0, -2)
    else
        text:SetPoint("TOP", UIParent, "TOP", 0, -80)
    end
    text:Hide()
    self.text = text
end

function Dampening:OnEnable()
    if not self.getPercent then
        return
    end
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Zone")
    self:Zone()
end

function Dampening:OnDisable()
    self.text:Hide()
end

function Dampening:Zone()
    if inArena() then
        self:RegisterUnitEvent("UNIT_AURA", "Update", "player")
        self:Update()
    else
        self:UnregisterUnitEvent("UNIT_AURA")
        self.text:Hide()
    end
end

function Dampening:Update()
    local percent = self.getPercent()
    if percent and CanAccess(percent) and percent > 0 then
        if percent ~= self.value then
            self.value = percent
            self.text:SetFormattedText(self.format, percent)
        end
        self.text:Show()
    else
        self.text:Hide()
    end
end

-- Arena nameplates ------------------------------------------------------------------
local ArenaNameplate = SUI:NewFeature("Misc.ArenaNameplate", {
    category = "misc",
    toggle = "arenanameplate",
    clients = { Mainline = true, Mists = true, TBC = true },
})

local ARENA_UNITS = { "arena1", "arena2", "arena3", "arena4", "arena5" }
local arenaActive = false

function ArenaNameplate:OnLoad()
    if not CompactUnitFrame_UpdateName then
        return
    end
    local UnitIsUnit = UnitIsUnit
    self:Hook("CompactUnitFrame_UpdateName", function(frame)
        if not arenaActive or frame:IsForbidden() then
            return
        end
        local unit, name = frame.unit, frame.name
        if not unit or not name or not CanAccess(unit) or strfind(unit, "nameplate", 1, true) ~= 1 then
            return
        end
        for i = 1, #ARENA_UNITS do
            local same = UnitIsUnit(unit, ARENA_UNITS[i])
            if CanAccess(same) and same then
                name:SetText(i)
                name:SetTextColor(1, 1, 0)
                return
            end
        end
    end)
end

function ArenaNameplate:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Zone")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Zone")
    self:Zone()
end

function ArenaNameplate:OnDisable()
    arenaActive = false
end

function ArenaNameplate:Zone()
    arenaActive = inArena()
end

-- Surrender -------------------------------------------------------------------------
local Surrender = SUI:NewFeature("Misc.Surrender", {
    category = "misc",
    toggle = "surrender",
    clients = { Mainline = true, Mists = true },
})

local function surrender()
    local fn = SurrenderArena or (C_PvP and C_PvP.SurrenderArena)
    if fn then
        fn()
    end
end

function Surrender:OnEnable()
    SUI:RegisterChatCommand("gg", surrender)
    SUI:RegisterChatCommand("sr", surrender)
end

function Surrender:OnDisable()
    SUI:UnregisterChatCommand("gg")
    SUI:UnregisterChatCommand("sr")
end

-- Achievement tracking ----------------------------------------------------------------
local Achievements = SUI:NewFeature("Misc.Achievements", {
    category = "misc",
    toggle = "achievements",
    clients = { Mainline = true, Mists = true },
})

-- Current season: Gladiator (3v3), Legend (Solo Shuffle), Strategist (Blitz).
-- ponytail: ids change every season; update them here when a season starts.
local SEASON = {
    Mainline = { Arena3v3 = 62930, RatedSoloShuffle = 62932, RatedBGBlitz = 62950 },
    Mists = { Arena3v3 = 41049, RatedSoloShuffle = 42023, RatedBGBlitz = 42024 },
}

local function toggleTracking(button)
    local id = button.achievementID
    if C_ContentTracking and C_ContentTracking.ToggleTracking then
        local kind = Enum.ContentTrackingType and Enum.ContentTrackingType.Achievement or 2
        local stop = Enum.ContentTrackingStopType and Enum.ContentTrackingStopType.Manual or 2
        C_ContentTracking.ToggleTracking(kind, id, stop)
    elseif IsTrackedAchievement and IsTrackedAchievement(id) then
        RemoveTrackedAchievement(id)
    elseif AddTrackedAchievement then
        AddTrackedAchievement(id)
    end
end

local function showTooltip(button)
    local _, name = GetAchievementInfo(button.achievementID)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
    GameTooltip:SetText(name or "Achievement")
    GameTooltip:AddLine("Click to track or untrack", 1, 1, 1)
    GameTooltip:Show()
end

function Achievements:OnLoad()
    self.buttons = {}
    SUI:OnAddonLoaded("Blizzard_PVPUI", function()
        local conquest = ConquestFrame
        local ids = SEASON[SUI.Client]
        if not conquest or not ids then
            return
        end
        for key, id in next, ids do
            local bracket = conquest[key]
            if bracket then
                local button = CreateFrame("Button", nil, bracket, "UIPanelButtonTemplate")
                button:SetSize(25, 25)
                button:SetText(">")
                button:SetPoint("TOPRIGHT", bracket, "TOPRIGHT", 10, -17.5)
                button.achievementID = id
                button:SetScript("OnClick", toggleTracking)
                button:SetScript("OnEnter", showTooltip)
                button:SetScript("OnLeave", GameTooltip_Hide)
                button:SetShown(Achievements.enabled)
                Achievements.buttons[#Achievements.buttons + 1] = button
            end
        end
    end)
end

function Achievements:SetButtonsShown(shown)
    for i = 1, #self.buttons do
        self.buttons[i]:SetShown(shown)
    end
end

function Achievements:OnEnable()
    self:SetButtonsShown(true)
end

function Achievements:OnDisable()
    self:SetButtonsShown(false)
end
