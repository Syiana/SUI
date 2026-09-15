--[[
    SUI 2.0 - Features/Misc/PvP.lua

    Small PvP helpers: Tab Binder (TAB targets only players in PvP), arena
    dampening below the arena timer, /gg to surrender and buttons in the
    conquest frame that track the season's rated achievements.
]]

local _, ns = ...
local SUI = ns.SUI

local next, select = next, select
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

-- 1.x fallback when nothing is bound to enemy targeting at all.
local DEFAULT_KEY = {
    TARGETNEARESTENEMY = "TAB",
    TARGETPREVIOUSENEMY = "SHIFT-TAB",
}

local function take(moved, action, key)
    if key and SetBinding(key, PLAYER_ACTION[action]) then
        moved[key] = action
        return true
    end
    return false
end

-- In PvP the enemy target keys move to the player-only actions (TAB /
-- SHIFT-TAB when nothing is bound). Outside PvP the keys moved before go
-- back, and like 1.x the target key is forced to the normal action.
local function applyBindings(pvp)
    local moved = SUI.db.char.misc.tabbinder
    local changed = false
    if pvp then
        for action, playerAction in next, PLAYER_ACTION do
            local key1, key2 = GetBindingKey(action)
            if not key1 and not GetBindingKey(playerAction) then
                key1 = DEFAULT_KEY[action]
            end
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
        for action, playerAction in next, PLAYER_ACTION do
            local key = GetBindingKey(playerAction) or GetBindingKey(action) or DEFAULT_KEY[action]
            if GetBindingAction(key) ~= action and SetBinding(key, action) then
                changed = true
            end
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

    -- 1.x look: a widget-style line right below the arena timer.
    local container = UIWidgetTopCenterContainerFrame
    -- The widget template gives the 1.x look; clients without it get a plain line.
    local hasTemplate = not C_XMLUtil or not C_XMLUtil.GetTemplateInfo or C_XMLUtil.GetTemplateInfo("UIWidgetTemplateIconAndText") ~= nil
    local ok, frame = pcall(CreateFrame, "Frame", nil, UIParent, hasTemplate and "UIWidgetTemplateIconAndText" or nil)
    if not ok then
        frame = CreateFrame("Frame", nil, UIParent)
    end
    if not frame.Text then
        frame:SetHeight(20)
        frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    end
    local setID = C_UIWidgetManager and C_UIWidgetManager.GetTopCenterWidgetSetID and C_UIWidgetManager.GetTopCenterWidgetSetID()
    local setInfo = setID and C_UIWidgetManager.GetWidgetSetInfo(setID)
    if container and container.verticalAnchorPoint then
        frame:SetPoint(container.verticalAnchorPoint, container, container.verticalRelativePoint, 0, setInfo and setInfo.verticalPadding or 0)
    elseif container then
        frame:SetPoint("TOP", container, "BOTTOM", 0, -2)
    else
        frame:SetPoint("TOP", UIParent, "TOP", 0, -80)
    end
    frame:SetWidth(200)
    frame.Text:SetParent(frame)
    frame.Text:SetAllPoints()
    frame.Text:SetJustifyH("CENTER")
    frame:Hide()
    self.frame = frame
end

function Dampening:OnEnable()
    if not self.getPercent then
        return
    end
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Zone")
    self:Zone()
end

function Dampening:OnDisable()
    self.frame:Hide()
end

function Dampening:Zone()
    if inArena() then
        self:RegisterUnitEvent("UNIT_AURA", "Update", "player")
        self:Update()
    else
        self:UnregisterUnitEvent("UNIT_AURA")
        self.frame:Hide()
    end
end

function Dampening:Update()
    local percent = self.getPercent()
    if percent and CanAccess(percent) and percent > 0 then
        if percent ~= self.value then
            self.value = percent
            self.frame.Text:SetFormattedText(self.format, percent)
        end
        self.frame:Show()
    else
        self.frame:Hide()
    end
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
