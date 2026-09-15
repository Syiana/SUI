--[[
    SUI 2.0 - Features/NamePlates/Plates.lua

    Per-plate state shared by every nameplate feature. When a plate appears,
    the unit data the features need (npc id, class colour, reaction, arena
    slot) is read once and cached on a state table that is reused for the
    lifetime of the Blizzard frame. Hooks on CompactUnitFrame_* look frames
    up in NP.state, so raid frames and forbidden plates return at once.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local next, tonumber, strsplit, max = next, tonumber, strsplit, math.max
local UnitGUID, UnitIsPlayer, UnitClass, UnitCanAttack, UnitReaction, UnitIsUnit =
    UnitGUID, UnitIsPlayer, UnitClass, UnitCanAttack, UnitReaction, UnitIsUnit
local UnitNameplateShowsWidgetsOnly = UnitNameplateShowsWidgetsOnly
local CanAccess = SUI.Compat.CanAccess

NP.state = {}  -- UnitFrame -> state (kept while the frame exists)
NP.byUnit = {} -- "nameplateN" -> UnitFrame (only while the plate is shown)
NP.inArena, NP.inPvP = false, false

local state, byUnit = NP.state, NP.byUnit

local function access(v)
    if CanAccess(v) then
        return v
    end
end

function NP.HealthBar(frame)
    return frame.healthBar or (frame.HealthBarsContainer and frame.HealthBarsContainer.healthBar)
end

function NP.CastBar(frame)
    return frame.castBar or (frame.CastBarsContainer and frame.CastBarsContainer.castBar)
end

-- State of a shown plate by unit token, or nil.
function NP.Get(unit)
    local frame = byUnit[unit]
    return frame and state[frame]
end

local function readArena(st)
    st.arena, st.specIcon, st.role = nil, nil, nil
    if not (NP.inArena and st.isPlayer) then
        return
    end
    for i = 1, 5 do
        local same = UnitIsUnit(st.unit, "arena" .. i)
        if CanAccess(same) and same then
            st.arena = i
            local spec = GetArenaOpponentSpec and GetArenaOpponentSpec(i)
            if spec and CanAccess(spec) and spec > 0 and GetSpecializationInfoByID then
                local _, _, _, icon, role = GetSpecializationInfoByID(spec)
                st.specIcon, st.role = icon, role
            end
            return
        end
    end
end

local function read(st, unit)
    st.unit = unit
    st.healthBar = NP.HealthBar(st.frame)
    st.castBar = NP.CastBar(st.frame)

    local guid = access(UnitGUID(unit))
    st.guid = guid
    st.npcId = nil
    if guid then
        local kind, _, _, _, _, id = strsplit("-", guid)
        if kind == "Creature" or kind == "Vehicle" then
            st.npcId = tonumber(id)
        end
    end

    st.isPlayer = access(UnitIsPlayer(unit)) or false
    local _, class = UnitClass(unit)
    st.class = st.isPlayer and access(class) or nil
    if st.class then
        st.classR, st.classG, st.classB = SUI.Compat.GetClassColor(st.class)
    end
    st.canAttack = access(UnitCanAttack("player", unit)) or false
    st.reaction = access(UnitReaction(unit, "player"))
    readArena(st)
end

-- 1.x icon look ---------------------------------------------------------------------
-- Gloss border plus a theme coloured outer shadow. Icons are styled once and
-- kept (plates and aura frames are pooled); shadows repaint on theme changes.
local SHADOW = {
    edgeFile = SUI.Media.textures .. [[Core\outer_shadow]],
    tile = false,
    tileSize = 32,
    edgeSize = 4,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}
local GLOSS = SUI.Media.textures .. [[Core\gloss]]
local shadows = {} -- icon -> backdrop frame

local function paintShadow(back)
    if SUI.Theme.enabled then
        back:SetBackdropBorderColor(SUI.Theme:Color(0.25))
    else
        back:SetBackdropBorderColor(1, 1, 1)
    end
end

function NP.SkinIcon(icon, parent)
    if not icon or shadows[icon] then
        return
    end
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local holder = CreateFrame("Frame", nil, parent)
    local border = holder:CreateTexture(nil, "BACKGROUND", nil, -7)
    border:SetTexture(GLOSS)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
    local back = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    back:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
    back:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
    back:SetFrameLevel(max(holder:GetFrameLevel() - 1, 0))
    back:SetBackdrop(SHADOW)
    SUI:ProtectBackdrop(back)
    paintShadow(back)
    back:SetAlpha(0.9)
    back.border = border
    shadows[icon] = back
end

-- Hides or shows a skinned icon with its border and shadow; `hidden` may be a secret.
function NP.SetIconHidden(icon, hidden)
    local back = shadows[icon]
    if not back then
        return
    end
    if SUI.Compat.IsSecret(hidden) then
        if icon.SetAlphaFromBoolean then
            icon:SetAlphaFromBoolean(hidden, 0, 1)
            back.border:SetAlphaFromBoolean(hidden, 0, 1)
            back:SetAlphaFromBoolean(hidden, 0, 0.9)
        end
        return
    end
    icon:SetAlpha(hidden and 0 or 1)
    back.border:SetAlpha(hidden and 0 or 1)
    back:SetAlpha(hidden and 0 or 0.9)
end

local F = SUI:NewFeature("NamePlates.Plates", {
    category = "nameplates",
    conflicts = NP.conflicts,
})
NP.registry = F

function F:OnEnable()
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Added")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Removed")
    self:RegisterEvent("UNIT_FACTION", "Faction")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "Zone")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Zone")
    if not SUI.IsVanilla then
        self:RegisterEvent("ARENA_OPPONENT_UPDATE", "Arena")
    end
    self:Zone()
    if C_NamePlate and C_NamePlate.GetNamePlates then
        for _, plate in next, C_NamePlate.GetNamePlates() do
            if plate.namePlateUnitToken then
                self:Added(nil, plate.namePlateUnitToken)
            end
        end
    end
end

function F:Added(_, unit)
    local plate = C_NamePlate.GetNamePlateForUnit(unit)
    if not plate or plate:IsForbidden() then
        return
    end
    local frame = plate.UnitFrame
    if not frame or frame:IsForbidden() then
        return
    end
    local isSelf = UnitIsUnit(unit, "player")
    if (CanAccess(isSelf) and isSelf) or (UnitNameplateShowsWidgetsOnly and UnitNameplateShowsWidgetsOnly(unit)) then
        return
    end
    local st = state[frame]
    if not st then
        st = { frame = frame, plate = plate }
        state[frame] = st
    end
    byUnit[unit] = frame
    read(st, unit)
end

function F:OnThemeChanged()
    for _, back in next, shadows do
        paintShadow(back)
    end
end

function F:Removed(_, unit)
    NP.removed = nil
    local frame = byUnit[unit]
    if frame then
        byUnit[unit] = nil
        local st = state[frame]
        st.unit = nil
        NP.removed = st -- for features that release per-plate objects on removal
    end
end

function F:Faction(_, unit)
    local st = NP.Get(unit)
    if st then
        st.canAttack = access(UnitCanAttack("player", unit)) or false
        st.reaction = access(UnitReaction(unit, "player"))
    end
end

function F:Zone()
    local _, kind = IsInInstance()
    NP.inArena = kind == "arena"
    NP.inPvP = kind == "arena" or kind == "pvp"
    NP.inInstance = kind == "party" or kind == "raid"
end

function F:Arena()
    for _, frame in next, byUnit do
        readArena(state[frame])
    end
end
