--[[
    SUI 2.0 - Features/NamePlates/PersonalBar.lua

    Personal resource bar (retail PersonalResourceDisplayFrame, or the own
    nameplate and class mana bar on classic): texture, class coloured
    health, power colour and sizes. Applied when the bars appear or the
    power type changes; hooks on the bars' own setters put SUI's values back
    when Blizzard overwrites them.
]]

local _, ns = ...
local SUI = ns.SUI
local NP = ns.NamePlates

local hooksecurefunc, wipe, select = hooksecurefunc, wipe, select

local F = SUI:NewFeature("NamePlates.PersonalBar", {
    category = "nameplates",
    toggle = function(db)
        return db.personalbar.style == "Custom"
    end,
    conflicts = NP.conflicts,
    reload = true, -- Blizzard does not restore sizes and textures by itself
})

local applying = false
local hooked = {} -- every bar SUI hooked
local current = {} -- bars that currently belong to the player (classic plates are pooled)
local classR, classG, classB = 1, 1, 1

-- health bar, its container (retail), power bar, extra bar
local function getBars()
    local health, container, power
    local display = PersonalResourceDisplayFrame
    if display then
        container = display.HealthBarsContainer
        health = container and container.healthBar
        power = display.PowerBar
    end
    if not health and C_NamePlate then
        local plate = C_NamePlate.GetNamePlateForUnit("player")
        local frame = plate and not plate:IsForbidden() and plate.UnitFrame
        health = frame and NP.HealthBar(frame)
    end
    return health, container, power or ClassNameplateManaBarFrame, ClassNameplateBrewmasterBarFrame
end

local apply, sizeQueued

local function setSelfSize()
    sizeQueued = false
    C_NamePlate.SetNamePlateSelfSize(F.db.personalbar.width, 45)
end

local function onBarChanged(bar)
    if not applying and F.enabled and current[bar] then
        apply()
    end
end

local function onHealthColor(bar)
    if not applying and F.enabled and current[bar] then
        applying = true
        bar:SetStatusBarColor(classR, classG, classB)
        applying = false
    end
end

local function hookBar(bar, skin, classColored)
    if not bar then
        return
    end
    current[bar] = true
    if hooked[bar] then
        return
    end
    hooked[bar] = true
    hooksecurefunc(bar, "SetWidth", onBarChanged)
    hooksecurefunc(bar, "SetHeight", onBarChanged)
    if not skin then
        return
    end
    hooksecurefunc(bar, "SetStatusBarTexture", onBarChanged)
    if classColored then
        hooksecurefunc(bar, "SetStatusBarColor", onHealthColor)
    end
    -- Border art of the bar takes the theme colour (the fill keeps its own).
    local fill = bar:GetStatusBarTexture()
    local regions = { bar:GetRegions() }
    for i = 1, #regions do
        local region = regions[i]
        if region ~= fill and region:GetObjectType() == "Texture" then
            SUI.Skin:Texture(region, true)
        end
    end
end

local function size(frame, width, height)
    if frame then
        frame:SetWidth(width)
        if height then
            frame:SetHeight(height)
        end
    end
end

-- 1.x: SUI texture on the bar (fill drawn on BORDER) and on its prediction overlays.
local PREDICTIONS = { "myHealPrediction", "otherHealPrediction", "totalAbsorb", "myHealAbsorb",
    "overAbsorbGlow", "overHealAbsorbGlow", "ManaCostPredictionBar", "ManaCostPredictionBarOverlay" }

local function fill(bar, texture)
    if bar.SetStatusBarTexture then
        bar:SetStatusBarTexture(texture)
        local fillTexture = bar:GetStatusBarTexture()
        if fillTexture then
            fillTexture:SetDrawLayer("BORDER")
        end
    end
    for i = 1, #PREDICTIONS do
        local overlay = bar[PREDICTIONS[i]]
        if overlay then
            if overlay.SetStatusBarTexture then
                overlay:SetStatusBarTexture(texture)
            elseif overlay.SetTexture then
                overlay:SetTexture(texture)
            end
        end
    end
end

function apply()
    local cfg = F.db.personalbar
    local health, container, power, extra = getBars()
    wipe(current)
    hookBar(container, false)
    hookBar(health, true, true)
    hookBar(power, true)
    hookBar(extra, true)
    applying = true
    size(container, cfg.width, cfg.height)
    if container and container ~= health then
        fill(container, cfg.texture)
    end
    if health then
        fill(health, cfg.texture)
        size(health, cfg.width, cfg.height)
        health:SetStatusBarColor(classR, classG, classB)
    end
    if power then
        fill(power, cfg.texture)
        size(power, cfg.width, cfg.manaheight)
        local c = PowerBarColor and (PowerBarColor[select(2, UnitPowerType("player"))] or PowerBarColor.MANA)
        if c and c.r then
            power:SetStatusBarColor(c.r, c.g, c.b)
            if power.Texture and power.Texture.SetVertexColor then
                power.Texture:SetVertexColor(c.r, c.g, c.b)
            end
        end
        -- 1.x hid the full-power flash and the power change feedback.
        if power.FullPowerFrame then
            power.FullPowerFrame:SetAlpha(0)
        end
        if power.FeedbackFrame then
            power.FeedbackFrame:SetAlpha(0)
        end
    end
    if extra then
        fill(extra, cfg.texture)
        size(extra, cfg.width)
    end
    applying = false
    if C_NamePlate and C_NamePlate.SetNamePlateSelfSize and not sizeQueued then
        sizeQueued = true
        SUI:RunAfterCombat(setSelfSize)
    end
end

function F:OnLoad()
    local _, class = UnitClass("player")
    classR, classG, classB = SUI.Compat.GetClassColor(class)
    if PersonalResourceDisplayFrame then
        self:HookScript(PersonalResourceDisplayFrame, "OnShow", apply)
    end
end

function F:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", apply)
    self:RegisterUnitEvent("UNIT_DISPLAYPOWER", apply, "player")
    self:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Plate")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Plate")
    apply()
end

F.OnRefresh = apply

-- The own nameplate (classic) comes and goes; a removed one may be reused for
-- another unit, so the bar list is rebuilt either way.
function F:Plate(_, unit)
    local isSelf = UnitIsUnit(unit, "player")
    if SUI.Compat.CanAccess(isSelf) and isSelf then
        apply()
    end
end
