--[[ SUI 2.0 - Features/UnitFrames/Colors.lua
    Health bar colours and frame tinting. Class colour paints health bars
    whenever Blizzard resets them (UnitFrameHealthBar_Update). The tint paints
    the frame art once and repaints only the textures Blizzard swaps: the
    target border on classification changes, the player art on vehicle
    changes, totem borders and class resource points when they are created.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local _G, UnitClassification = _G, UnitClassification
local CanAccess = SUI.Compat.CanAccess

-- Class colour ------------------------------------------------------------------------
local ClassColor = SUI:NewFeature("UnitFrames.ClassColor", {
    category = "unitframes",
    toggle = "classcolor",
})

local healthBars = {} -- bar -> true

local function colorBar(bar, unit)
    local r, g, b = UF.UnitColor(unit)
    if r then
        local region = bar:GetStatusBarTexture()
        if region then
            region:SetDesaturated(true)
        end
        bar:SetStatusBarColor(r, g, b)
    end
end

function ClassColor:OnLoad()
    local frames = UF.Frames()
    for i = 1, #frames do
        if frames[i].healthbar then
            healthBars[frames[i].healthbar] = true
        end
    end
    self:Hook("UnitFrameHealthBar_Update", function(bar, unit)
        if healthBars[bar] then
            colorBar(bar, unit)
        end
    end)
end

function ClassColor:Update(_, unit)
    for bar in next, healthBars do
        if not unit or bar.unit == unit then
            colorBar(bar, bar.unit)
        end
    end
end

function ClassColor:OnEnable()
    self:RegisterUnitEvent("UNIT_FACTION", "Update", "target", "focus")
    self:Update()
end

function ClassColor:OnDisable()
    for bar in next, healthBars do
        local region = bar:GetStatusBarTexture()
        if region then
            region:SetDesaturated(false)
        end
        bar:SetStatusBarColor(0, 1, 0)
    end
end

-- Reputation bar ----------------------------------------------------------------------
-- factioncolor = false hides the coloured name background of target-like frames.
local Reputation = SUI:NewFeature("UnitFrames.Reputation", {
    category = "unitframes",
    toggle = function(db)
        return not db.factioncolor
    end,
})

local function setReputationAlpha(alpha)
    local frames = UF.TargetFrames()
    for i = 1, #frames do
        local bar = UF.Reputation(frames[i])
        if bar then
            bar:SetAlpha(alpha)
        end
    end
end

function Reputation:OnEnable()
    setReputationAlpha(0)
end

function Reputation:OnDisable()
    setReputationAlpha(1)
end

-- Tint --------------------------------------------------------------------------------
local Tint = SUI:NewFeature("UnitFrames.Tint", {
    category = "unitframes",
})

local ART = {
    -- retail
    "PlayerFrame.PlayerFrameContainer.FrameTexture",
    "PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture",
    "PlayerFrame.PlayerFrameContainer.VehicleFrameTexture",
    "PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon",
    "TargetFrameToT.FrameTexture",
    "FocusFrameToT.FrameTexture",
    -- classic
    "PlayerFrameTexture",
    "PlayerFrameVehicleTexture",
    "TargetFrameToTTextureFrameTexture",
    "FocusFrameToTTextureFrameTexture",
    -- both
    "PetFrameTexture",
    "PlayerFrameAlternateManaBarBorder",
    "PlayerFrameAlternateManaBarLeftBorder",
    "PlayerFrameAlternateManaBarRightBorder",
}
-- Frames whose texture regions are tinted as a whole (classic).
local ART_FRAMES = { "PlayerFrameAlternateManaBar", "PlayerFrameGroupIndicator" }
-- Named regions of class resource points (retail).
local POINT_REGIONS = { "BGActive", "BGInactive", "BGShadow", "ArcaneBG", "ArcaneBGShadow", "Background", "BG_Active", "BG_Inactive", "BG_Shadow", "Chi_BG", "Chi_BG_Active" }

local painted = setmetatable({}, { __mode = "k" }) -- texture -> true

local function paint(texture)
    if texture then
        painted[texture] = true
        UF.Paint(texture)
    end
end

local function isElite(frame)
    local unit = frame.unit
    local class = unit and UnitClassification(unit)
    return CanAccess(class) and (class == "elite" or class == "rare" or class == "rareelite" or class == "worldboss")
end

local function paintTarget(frame)
    local elite = UF.EliteTexture(frame)
    local keepElite = Tint.db.elitecolor
    if elite then
        if keepElite then
            painted[elite] = nil
            elite:SetDesaturated(false)
            elite:SetVertexColor(1, 1, 1)
        else
            paint(elite)
        end
        paint(UF.Border(frame))
    else
        -- Classic: the dragon is part of the border texture itself.
        local border = UF.Border(frame)
        if border and keepElite and isElite(frame) then
            border:SetDesaturated(false)
            border:SetVertexColor(1, 1, 1)
        else
            paint(border)
        end
    end
end

local function paintPoint(point)
    for i = 1, #POINT_REGIONS do
        paint(point[POINT_REGIONS[i]])
    end
    local essence = point.EssenceFillDone
    if essence then
        paint(essence.CircBG)
        paint(essence.CircBGActive)
    end
end

local function paintClassBar(bar)
    local points = bar.classResourceButtonTable
    if points then
        for i = 1, #points do
            paintPoint(points[i])
        end
    end
    for i = 1, 6 do
        local rune = bar["Rune" .. i]
        if rune then
            paintPoint(rune)
        end
    end
    paint(bar.Background)
end

local function paintTotems(totemFrame)
    local pool = totemFrame.totemPool
    if pool and type(pool.EnumerateActive) == "function" then
        for totem in pool:EnumerateActive() do
            paint(totem.Border)
        end
    end
end

local function paintPlayer()
    for i = 1, 4 do
        paint(UF.Resolve(ART[i]))
    end
    paint(_G.PlayerFrameTexture)
end

function Tint:OnLoad()
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        if targets[i].CheckClassification then
            self:Hook(targets[i], "CheckClassification", paintTarget)
        end
    end
    if PlayerFrame_ToPlayerArt then
        self:Hook("PlayerFrame_ToPlayerArt", paintPlayer)
    end
    if PlayerFrame_ToVehicleArt then
        self:Hook("PlayerFrame_ToVehicleArt", paintPlayer)
    end
    local totems = _G.TotemFrame
    if totems and totems.totemPool and totems.Update then
        self:Hook(totems, "Update", paintTotems)
    end
    local bars = UF.ClassBars()
    for i = 1, #bars do
        local bar = bars[i]
        if bar.UpdatePower then
            self:Hook(bar, "UpdatePower", paintClassBar)
        elseif bar.UpdateRunes then
            self:Hook(bar, "UpdateRunes", paintClassBar)
        end
    end
end

function Tint:Apply()
    for i = 1, #ART do
        paint(UF.Resolve(ART[i]))
    end
    for i = 1, #ART_FRAMES do
        local frame = _G[ART_FRAMES[i]]
        if frame then
            for j = 1, select("#", frame:GetRegions()) do
                local region = select(j, frame:GetRegions())
                if region:GetObjectType() == "Texture" then
                    paint(region)
                end
            end
        end
    end
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        paintTarget(targets[i])
    end
    local bars = UF.ClassBars()
    for i = 1, #bars do
        paintClassBar(bars[i])
    end
    if _G.TotemFrame then
        paintTotems(_G.TotemFrame)
    end
end

function Tint:OnEnable()
    self:Apply()
end

function Tint:OnThemeChanged()
    for texture in next, painted do
        UF.Paint(texture)
    end
end

function Tint:OnRefresh(key)
    if key == "elitecolor" then
        local targets = UF.TargetFrames()
        for i = 1, #targets do
            paintTarget(targets[i])
        end
    end
end
