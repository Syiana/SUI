--[[
    SUI 2.0 - Features/NamePlates/Indicators.lua

    Small markers around the health bar: class or arena spec icons in PvP,
    a healer marker, target arrows and the raid marker size and position.
    Icons are created once per plate and updated when a plate appears or
    the arena, group or target changes.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, unpack, hooksecurefunc = next, unpack, hooksecurefunc
local CanAccess = SUI.Compat.CanAccess
local state = NP.state

local ANCHORS = {
    TOP = { "BOTTOM", "TOP" },
    LEFT = { "RIGHT", "LEFT" },
    RIGHT = { "LEFT", "RIGHT" },
    BOTTOM = { "TOP", "BOTTOM" },
}

-- Shared "icon per plate" plumbing: fn(st) is run for every shown plate.
local function forPlates(fn)
    for _, frame in next, NP.byUnit do
        fn(state[frame])
    end
end

local function newIcon(st, layer)
    local tex = st.frame:CreateTexture(nil, "OVERLAY", nil, layer)
    tex:Hide()
    return tex
end

-- Class / spec icons ------------------------------------------------------------------
local CI = SUI:NewFeature("NamePlates.ClassIcons", {
    category = "nameplates",
    toggle = "classicons.enabled",
    conflicts = NP.conflicts,
})

local classIcons = {} -- state -> texture
NP.classIcons = classIcons

local function setClassTexture(tex, class)
    if GetClassAtlas then
        tex:SetAtlas(GetClassAtlas(class))
    else
        tex:SetTexture([[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]])
        tex:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
    end
end

local function updateClassIcon(st)
    local db = CI.db.classicons
    local tex = classIcons[st]
    if not st.class or not st.healthBar or (db.pvponly and not NP.inPvP) then
        if tex then
            tex:Hide()
        end
        return
    end
    if not tex then
        tex = newIcon(st, 1)
        classIcons[st] = tex
    end
    if st.specIcon then
        tex:SetTexture(st.specIcon)
        tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    else
        setClassTexture(tex, st.class)
    end
    tex:SetSize(db.size, db.size)
    tex:ClearAllPoints()
    tex:SetPoint("RIGHT", st.healthBar, "LEFT", -4, 0)
    tex:Show()
end

function CI:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ApplyAll")
    if not SUI.IsVanilla then
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", "ApplyAll")
    end
    self:ApplyAll()
end

function CI:ApplyAll()
    forPlates(updateClassIcon)
end

CI.OnRefresh = CI.ApplyAll

function CI:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        updateClassIcon(st)
    end
end

function CI:OnDisable()
    for _, tex in next, classIcons do
        tex:Hide()
    end
end

-- Healer marker -----------------------------------------------------------------------
local HM = SUI:NewFeature("NamePlates.HealerMarker", {
    category = "nameplates",
    toggle = "healer.enabled",
    conflicts = NP.conflicts,
})

local healerIcons = {}
NP.healerIcons = healerIcons

local function updateHealer(st)
    local healer = st.role == "HEALER"
    if st.isPlayer and not st.role and UnitGroupRolesAssigned then
        local role = UnitGroupRolesAssigned(st.unit)
        healer = CanAccess(role) and role == "HEALER"
    end
    local tex = healerIcons[st]
    if not healer or not st.healthBar then
        if tex then
            tex:Hide()
        end
        return
    end
    if not tex then
        tex = newIcon(st, 2)
        tex:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]])
        tex:SetTexCoord(20 / 64, 39 / 64, 1 / 64, 20 / 64)
        healerIcons[st] = tex
    end
    local size = HM.db.healer.size
    tex:SetSize(size, size)
    tex:ClearAllPoints()
    tex:SetPoint("LEFT", st.healthBar, "RIGHT", 4, 0)
    tex:Show()
end

function HM:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "ApplyAll")
    if not SUI.IsVanilla then
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", "ApplyAll")
    end
    self:ApplyAll()
end

function HM:ApplyAll()
    forPlates(updateHealer)
end

HM.OnRefresh = HM.ApplyAll

function HM:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        updateHealer(st)
    end
end

function HM:OnDisable()
    for _, tex in next, healerIcons do
        tex:Hide()
    end
end

-- Target indicator --------------------------------------------------------------------
local TI = SUI:NewFeature("NamePlates.TargetIndicator", {
    category = "nameplates",
    toggle = "target.enabled",
    conflicts = NP.conflicts,
})

local ARROW = [[Interface\ChatFrame\ChatFrameExpandArrow]]
local holder, leftArrow, rightArrow

function TI:OnLoad()
    holder = CreateFrame("Frame")
    holder:Hide()
    leftArrow = holder:CreateTexture(nil, "OVERLAY")
    rightArrow = holder:CreateTexture(nil, "OVERLAY")
    leftArrow:SetTexture(ARROW)
    rightArrow:SetTexture(ARROW)
    leftArrow:SetDesaturated(true)
    rightArrow:SetDesaturated(true)
    rightArrow:SetTexCoord(1, 0, 0, 1)
end

local function shown(icons, st)
    local tex = icons[st]
    return tex and tex:IsShown() and tex
end

function TI:Update()
    local plate = C_NamePlate.GetNamePlateForUnit("target")
    local st = plate and plate.UnitFrame and state[plate.UnitFrame]
    if not (st and st.unit and st.healthBar) then
        holder:Hide()
        return
    end
    local bar = st.healthBar
    holder:SetParent(st.frame)
    holder:SetAllPoints(bar)
    leftArrow:ClearAllPoints()
    leftArrow:SetPoint("RIGHT", shown(classIcons, st) or bar, "LEFT", -2, 0)
    rightArrow:ClearAllPoints()
    rightArrow:SetPoint("LEFT", shown(healerIcons, st) or bar, "RIGHT", 2, 0)
    holder:Show()
end

function TI:OnEnable()
    local db = self.db.target
    local c = db.color
    leftArrow:SetSize(db.size, db.size)
    rightArrow:SetSize(db.size, db.size)
    leftArrow:SetVertexColor(c.r, c.g, c.b, c.a or 1)
    rightArrow:SetVertexColor(c.r, c.g, c.b, c.a or 1)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update")
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Update")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Update")
    self:Update()
end

TI.OnRefresh = TI.OnEnable

function TI:OnDisable()
    holder:Hide()
end

-- Raid marker -------------------------------------------------------------------------
local RM = SUI:NewFeature("NamePlates.RaidMarker", {
    category = "nameplates",
    toggle = "raidmarker.enabled",
    conflicts = NP.conflicts,
    reload = true, -- Blizzard re-anchors the marker only on a new layout
})

local markerState = {} -- RaidTargetFrame -> plate state (hook installed)
local placing = false

local place

local function onMarkerMoved(marker)
    if placing or not RM.enabled then
        return
    end
    local st = markerState[marker]
    if st.unit then
        place(st)
    end
end

function place(st)
    local marker, bar = st.frame.RaidTargetFrame, st.healthBar
    if not (marker and bar) then
        return
    end
    if not markerState[marker] then
        markerState[marker] = st
        hooksecurefunc(marker, "SetPoint", onMarkerMoved)
    end
    local db = RM.db.raidmarker
    local anchor = ANCHORS[db.anchor] or ANCHORS.TOP
    placing = true
    marker:SetSize(db.size, db.size)
    marker:ClearAllPoints()
    marker:SetPoint(anchor[1], bar, anchor[2], db.x, db.y)
    local icon = marker.RaidTargetIcon
    if icon then
        icon:ClearAllPoints()
        icon:SetAllPoints(marker)
    end
    placing = false
end

function RM:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    forPlates(place)
end

RM.OnRefresh = RM.OnEnable

function RM:Added(_, unit)
    local st = NP.Get(unit)
    if st then
        place(st)
    end
end
