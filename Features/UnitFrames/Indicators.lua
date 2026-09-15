--[[ SUI 2.0 - Features/UnitFrames/Indicators.lua
    Small visibility options of the Blizzard unit frames: PvP badges, combat
    icon, hit indicator, corner icon, resting glow, names, levels, totem
    icons and class resource bars. Blizzard only shows and hides these
    regions, so fading them with SetAlpha needs no hooks; where Blizzard
    shows a whole frame again, an OnShow hook hides it.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local _G, wipe = _G, wipe
local UnitExists, UnitAffectingCombat, IsResting = UnitExists, UnitAffectingCombat, IsResting

local buffer = {}

local function setAlpha(regions, alpha)
    for i = 1, #regions do
        local region = regions[i]
        if region then
            region:SetAlpha(alpha)
        end
    end
end

-- PvP badge -----------------------------------------------------------------------------
local PvPBadge = SUI:NewFeature("UnitFrames.PvPBadge", {
    category = "unitframes",
    toggle = function(db)
        return not db.pvpbadge
    end,
})

function PvPBadge:OnEnable()
    setAlpha(UF.PvPRegions(wipe(buffer)), 0)
end

function PvPBadge:OnDisable()
    setAlpha(UF.PvPRegions(wipe(buffer)), 1)
end

-- Names and levels ------------------------------------------------------------------------
local HideName = SUI:NewFeature("UnitFrames.HideName", {
    category = "unitframes",
    toggle = "hidename",
})

local function setNameAlpha(alpha)
    local frames = UF.Frames()
    for i = 1, #frames do
        if frames[i].name then
            frames[i].name:SetAlpha(alpha)
        end
    end
end

function HideName:OnEnable()
    setNameAlpha(0)
end

function HideName:OnDisable()
    setNameAlpha(1)
end

local HideLevel = SUI:NewFeature("UnitFrames.HideLevel", {
    category = "unitframes",
    toggle = "hidelevel",
})

function HideLevel:OnEnable()
    setAlpha(UF.LevelRegions(wipe(buffer)), 0)
end

function HideLevel:OnDisable()
    setAlpha(UF.LevelRegions(wipe(buffer)), 1)
end

-- Combat icon ------------------------------------------------------------------------------
local CombatIcon = SUI:NewFeature("UnitFrames.CombatIcon", {
    category = "unitframes",
    toggle = "combaticon",
})

local combatIcons = {} -- unit -> texture

function CombatIcon:OnLoad()
    for unit, name in next, { target = "TargetFrame", focus = "FocusFrame" } do
        local frame = _G[name]
        if frame then
            -- 1.x: not a child of the target frame, so it keeps its own scale and level.
            local holder = CreateFrame("Frame", nil, UIParent)
            holder:SetSize(25, 25)
            holder:SetPoint("CENTER", frame, "RIGHT", 10, 0)
            local icon = holder:CreateTexture(nil, "BORDER")
            icon:SetAllPoints()
            icon:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
            holder:Hide()
            combatIcons[unit] = holder
        end
    end
end

function CombatIcon:Update()
    for unit, icon in next, combatIcons do
        icon:SetShown(UnitExists(unit) and UnitAffectingCombat(unit))
    end
end

function CombatIcon:OnEnable()
    self:RegisterUnitEvent("UNIT_FLAGS", "Update", "target", "focus")
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "Update")
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", "Update")
    self:Update()
end

function CombatIcon:OnDisable()
    for _, icon in next, combatIcons do
        icon:Hide()
    end
end

-- Hit indicator ------------------------------------------------------------------------------
-- hitindicator = true shows the damage numbers on the player and pet portrait.
local HitIndicator = SUI:NewFeature("UnitFrames.HitIndicator", {
    category = "unitframes",
    toggle = function(db)
        return not db.hitindicator
    end,
})

function HitIndicator:OnLoad()
    if CombatFeedback_OnCombatEvent then
        self:Hook("CombatFeedback_OnCombatEvent", function(frame)
            if frame.feedbackText then
                frame.feedbackText:Hide()
            end
        end)
    end
end

-- Corner icon (retail) -------------------------------------------------------------------------
local CornerIcon = SUI:NewFeature("UnitFrames.CornerIcon", {
    category = "unitframes",
    clients = { Mainline = true },
    toggle = function(db)
        return not db.cornericon
    end,
})

local function cornerIcon()
    return UF.Resolve("PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon")
end

function CornerIcon:OnEnable()
    local icon = cornerIcon()
    if icon then
        icon:SetAlpha(0)
    end
end

function CornerIcon:OnDisable()
    local icon = cornerIcon()
    if icon then
        icon:SetAlpha(1)
    end
end

-- Resting textures ------------------------------------------------------------------------------
local RESTING = {
    Mainline = { "PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture", "PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop" },
    Classic = { "PlayerStatusTexture", "PlayerRestIcon", "PlayerRestGlow", "PlayerStatusGlow" },
}

local function restingFeature(id, clients, paths)
    local F = SUI:NewFeature(id, {
        category = "unitframes",
        clients = clients,
        -- The Classic style brings back the old resting glow (1.x).
        toggle = function(db)
            return db.hideresting and db.style ~= "Classic"
        end,
    })

    local function update()
        if IsResting() then
            for i = 1, #paths do
                local region = UF.Resolve(paths[i])
                if region then
                    region:Hide()
                end
            end
        end
    end

    function F:OnLoad()
        if PlayerFrame_UpdateStatus then
            self:Hook("PlayerFrame_UpdateStatus", update)
        end
    end

    function F:OnEnable()
        update()
    end

    function F:OnDisable()
        if IsResting() then
            for i = 1, #paths do
                local region = UF.Resolve(paths[i])
                if region then
                    region:Show()
                end
            end
        end
    end
end

restingFeature("UnitFrames.Resting", { Mainline = true }, RESTING.Mainline)
restingFeature("UnitFrames.RestingClassic", { Classic = true }, RESTING.Classic)

-- Totem icons -------------------------------------------------------------------------------------
local TotemIcons = SUI:NewFeature("UnitFrames.TotemIcons", {
    category = "unitframes",
    toggle = function(db)
        return not db.totemicons
    end,
})

local function hideSelf(frame)
    frame:Hide()
end

function TotemIcons:OnLoad()
    if _G.TotemFrame then
        self:HookScript(_G.TotemFrame, "OnShow", hideSelf)
    end
end

function TotemIcons:OnEnable()
    if _G.TotemFrame then
        _G.TotemFrame:Hide()
    end
end

function TotemIcons:OnDisable()
    local frame = _G.TotemFrame
    if not frame or not GetTotemInfo then
        return
    end
    for i = 1, tonumber(MAX_TOTEMS) or 4 do
        if GetTotemInfo(i) then
            frame:Show()
            return
        end
    end
end

-- Class resource bar -------------------------------------------------------------------------------
local ClassBar = SUI:NewFeature("UnitFrames.ClassBar", {
    category = "unitframes",
    toggle = function(db)
        return not db.classbar
    end,
    reload = true, -- Blizzard decides per spec and form whether a bar shows
})

function ClassBar:OnLoad()
    local bars = UF.ClassBars()
    for i = 1, #bars do
        self:HookScript(bars[i], "OnShow", hideSelf)
    end
end

function ClassBar:OnEnable()
    local bars = UF.ClassBars()
    for i = 1, #bars do
        bars[i]:Hide()
    end
end
