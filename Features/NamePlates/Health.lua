--[[
    SUI 2.0 - Features/NamePlates/Health.lua

    Health percentage text (updated only when Blizzard updates the health of
    a nameplate) and health bar colours: NPC id colours, role based threat
    colours and NPC type colours. Colour work runs only on colour updates,
    threat changes and when a plate appears, with cached per-plate data.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, wipe, tonumber = next, wipe, tonumber
local UnitHealth, UnitHealthMax, UnitHealthPercent = UnitHealth, UnitHealthMax, UnitHealthPercent
local UnitThreatSituation, UnitIsTapDenied, UnitGroupRolesAssigned = UnitThreatSituation, UnitIsTapDenied, UnitGroupRolesAssigned
local UnitPlayerControlled, FACTION_BAR_COLORS = UnitPlayerControlled, FACTION_BAR_COLORS
local UnitClassification, UnitPowerMax = UnitClassification, UnitPowerMax
local UnitLevel = UnitEffectiveLevel or UnitLevel
local CanAccess = SUI.Compat.CanAccess
local state = NP.state
local isCustom = NP.isCustom

-- Health text -------------------------------------------------------------------------
local H = SUI:NewFeature("NamePlates.HealthText", {
    category = "nameplates",
    toggle = function(db)
        return isCustom(db) and db.healthtext
    end,
    conflicts = NP.conflicts,
})

local format = "%.0f%%"
local texts = {} -- state -> font string

local function percentSecret(unit)
    return UnitHealthPercent(unit, true, CurveConstants.ScaleTo100)
end

local function percentPlain(unit)
    local maxHealth = UnitHealthMax(unit)
    if maxHealth and maxHealth > 0 then
        return UnitHealth(unit) / maxHealth * 100
    end
    return 0
end

local percent = percentPlain

local function updateText(st)
    local text = texts[st]
    if not text then
        local bar = st.healthBar
        if not bar then
            return
        end
        text = bar:CreateFontString(nil, "ARTWORK")
        text:SetPoint("CENTER")
        text:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
        texts[st] = text
    end
    text:SetFormattedText(format, percent(st.unit))
    text:Show()
end

function H:OnLoad()
    -- Midnight: health of other units can be secret, the percent API handles it.
    if UnitHealthPercent and CurveConstants and CurveConstants.ScaleTo100 then
        percent = percentSecret
    end
    self:Hook("CompactUnitFrame_UpdateHealth", function(frame)
        local st = state[frame]
        if st and st.unit then
            updateText(st)
        end
    end)
end

function H:OnEnable()
    format = "%." .. (tonumber(self.db.decimals) or 0) .. "f%%"
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    for _, frame in next, NP.byUnit do
        updateText(state[frame])
    end
end

H.OnRefresh = H.OnEnable

function H:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        updateText(st)
    end
end

function H:OnDisable()
    for _, text in next, texts do
        text:Hide()
    end
end

-- Health colours ----------------------------------------------------------------------
local C = SUI:NewFeature("NamePlates.HealthColor", {
    category = "nameplates",
    toggle = function(db)
        return isCustom(db) and (db.colors or db.threat or db.npctypes.enabled)
    end,
    conflicts = NP.conflicts,
})

local npcColors = {} -- npc id -> { r, g, b } entry of the user list
local useNpc, useThreat, useTypes, typesInstanceOnly, role
local typeR, typeG, typeB = {}, {}, {}

local function classify(st)
    st.npcType = nil
    if st.isPlayer or not useTypes or (typesInstanceOnly and not NP.inInstance) then
        return
    end
    local unit = st.unit
    local class, level, playerLevel = UnitClassification(unit), UnitLevel(unit), UnitLevel("player")
    if not (CanAccess(class) and CanAccess(level)) then
        return
    end
    if class == "worldboss" or level == -1 or level >= playerLevel + 2 then
        st.npcType = "boss"
    elseif (class == "elite" or class == "rareelite") and level > playerLevel then
        st.npcType = "miniboss"
    elseif class ~= "trivial" and class ~= "minus" then
        local mana = UnitPowerMax(unit, 0)
        if CanAccess(mana) and mana > 0 then
            st.npcType = "caster"
        end
    end
end

local function colorize(st)
    local bar = st.healthBar
    if not bar or st.isPlayer or not st.canAttack then
        return
    end
    local unit = st.unit
    local c = useNpc and st.npcId and npcColors[st.npcId]
    local tank = role == "TANK"

    if useThreat and (tank or role == "HEALER" or role == "DAMAGER") then
        local status = UnitThreatSituation("player", unit)
        if CanAccess(status) and status then
            if status == 2 then
                bar:SetStatusBarColor(1, 0.8, 0)
            elseif (status == 3) == tank then
                if c then
                    bar:SetStatusBarColor(c.r, c.g, c.b)
                else
                    bar:SetStatusBarColor(0, 1, 0.6)
                end
            else
                bar:SetStatusBarColor(1, 0, 0.3)
            end
            return
        end
    end

    -- 1.x: tapped grey; hostile (2) or unknown reaction: NPC colour or SUI red;
    -- other reactions: the faction colour.
    local tapped, controlled = UnitIsTapDenied(unit), UnitPlayerControlled(unit)
    local reaction = st.reaction
    if CanAccess(tapped) and tapped and CanAccess(controlled) and not controlled then
        bar:SetStatusBarColor(0.5, 0.5, 0.5)
    elseif reaction == nil or reaction == 2 then
        if c then
            bar:SetStatusBarColor(c.r, c.g, c.b)
        elseif st.npcType then
            local t = st.npcType
            bar:SetStatusBarColor(typeR[t], typeG[t], typeB[t])
        elseif useNpc then
            bar:SetStatusBarColor(1, 0, 0.3)
        end
    elseif st.npcType then
        local t = st.npcType
        bar:SetStatusBarColor(typeR[t], typeG[t], typeB[t])
    elseif useNpc then
        local faction = FACTION_BAR_COLORS and FACTION_BAR_COLORS[reaction]
        if faction then
            bar:SetStatusBarColor(faction.r, faction.g, faction.b)
        end
    end
end

function C:OnLoad()
    self:Hook("CompactUnitFrame_UpdateHealthColor", function(frame)
        local st = state[frame]
        if st and st.unit then
            colorize(st)
        end
    end)
end

function C:Settings()
    local db = self.db
    useNpc, useThreat, useTypes = db.colors, db.threat, db.npctypes.enabled
    typesInstanceOnly = db.npctypes.instancesonly
    for _, t in next, { "boss", "miniboss", "caster" } do
        local c = db.npctypes[t]
        typeR[t], typeG[t], typeB[t] = c.r, c.g, c.b
    end
    wipe(npcColors)
    local list = db.npccolors
    for i = 1, #list do
        local entry = list[i]
        if entry.id and entry.color then
            npcColors[entry.id] = entry.color
        end
    end
end

function C:UpdateRole()
    role = UnitGroupRolesAssigned and UnitGroupRolesAssigned("player")
end

function C:OnEnable()
    self:Settings()
    self:UpdateRole()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", "Threat")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateRole")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateRole")
    if SUI.IsRetail or SUI.IsMists then
        self:RegisterEvent("PLAYER_ROLES_ASSIGNED", "UpdateRole")
        self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "UpdateRole")
    end
    self:ApplyAll()
end

function C:ApplyAll()
    for _, frame in next, NP.byUnit do
        local st = state[frame]
        classify(st)
        colorize(st)
    end
end

function C:OnRefresh()
    self:Settings()
    self:ApplyAll()
end

function C:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        classify(st)
        colorize(st)
    end
end

function C:Threat(_, unit)
    local st = unit and NP.Get(unit)
    if st then
        colorize(st)
    end
end

-- Blizzard keeps the colour it last applied on the bar; put that back.
function C:OnDisable()
    for _, st in next, state do
        local bar = st.healthBar
        if bar and bar.r and CanAccess(bar.r) then
            bar:SetStatusBarColor(bar.r, bar.g, bar.b)
        end
    end
end
