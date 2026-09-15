--[[ SUI 2.0 - Features/UnitFrames/Colors.lua
    Health bar colours and frame tinting. Health bars of every Blizzard unit
    frame (player, target, party, arena, boss ...) get class/reaction colours,
    or SUI green on a custom texture. The colour is worked out when Blizzard
    resets a bar for its unit and re-applied from a cache when a value
    change paints the bar green again. The tint paints the frame art once
    and repaints only what Blizzard swaps: target art on classification
    changes, player art on vehicle changes, reputation bars on faction
    changes, totem borders and class resource points when they appear.
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local _G, select, UnitClassification = _G, select, UnitClassification
local CanAccess = SUI.Compat.CanAccess

-- Health colour ------------------------------------------------------------------------
local ClassColor = SUI:NewFeature("UnitFrames.ClassColor", {
    category = "unitframes",
    toggle = function(db)
        return db.classcolor or not UF.BlizzardTexture()
    end,
    watch = { "general" },
})

-- Last colour per bar, so HealthBar_OnValueChanged costs one SetStatusBarColor.
local barR = setmetatable({}, { __mode = "k" })
local barG = setmetatable({}, { __mode = "k" })
local barB = setmetatable({}, { __mode = "k" })

local function colorBar(bar, unit)
    local r, g, b
    if ClassColor.db.classcolor then
        r, g, b = UF.UnitColor(unit)
        if not r then
            return
        end
        local region = bar:GetStatusBarTexture()
        if region then
            region:SetDesaturated(true)
        end
    else
        r, g, b = 0, 0.7, 0
    end
    barR[bar], barG[bar], barB[bar] = r, g, b
    bar:SetStatusBarColor(r, g, b)
end

function ClassColor:OnLoad()
    self:Hook("UnitFrameHealthBar_Update", function(bar, unit)
        if bar and unit and bar.unit == unit then
            colorBar(bar, unit)
        end
    end)
    if HealthBar_OnValueChanged then
        self:Hook("HealthBar_OnValueChanged", function(bar)
            local r = barR[bar]
            if r then
                bar:SetStatusBarColor(r, barG[bar], barB[bar])
            end
        end)
    end
end

function ClassColor:Update(_, unit)
    local frames = UF.Frames()
    for i = 1, #frames do
        local bar = frames[i].healthbar
        if bar and bar.unit and (not unit or bar.unit == unit) then
            colorBar(bar, bar.unit)
        end
    end
end

function ClassColor:OnEnable()
    self:RegisterUnitEvent("UNIT_FACTION", "Update", "target", "focus")
    self:Update()
end

function ClassColor:OnRefresh(key)
    if key == "classcolor" or key == "texture" then
        self:Update()
    end
end

function ClassColor:OnDisable()
    for bar in next, barR do
        local region = bar:GetStatusBarTexture()
        if region then
            region:SetDesaturated(false)
        end
        bar:SetStatusBarColor(0, 1, 0)
    end
    wipe(barR)
    wipe(barG)
    wipe(barB)
end

-- Reputation bar ----------------------------------------------------------------------
-- factioncolor = false keeps the name background of target-like frames hidden.
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

-- path -> desaturate (1.x tinted most art over its own colours)
local ART = {
    -- retail
    ["PlayerFrame.PlayerFrameContainer.FrameTexture"] = false,
    ["PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture"] = false,
    ["PlayerFrame.PlayerFrameContainer.VehicleFrameTexture"] = false,
    ["PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon"] = false,
    ["TargetFrameToT.FrameTexture"] = false,
    ["FocusFrameToT.FrameTexture"] = false,
    -- classic
    ["PlayerFrameTexture"] = false,
    ["PlayerFrameVehicleTexture"] = false,
    ["TargetFrameToTTextureFrameTexture"] = false,
    ["FocusFrameToTTextureFrameTexture"] = false,
    -- both
    ["PetFrameTexture"] = true,
    ["PlayerFrameAlternateManaBarBorder"] = true,
    ["PlayerFrameAlternateManaBarLeftBorder"] = true,
    ["PlayerFrameAlternateManaBarRightBorder"] = true,
}
local PLAYER_ART = {
    "PlayerFrame.PlayerFrameContainer.FrameTexture",
    "PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture",
    "PlayerFrame.PlayerFrameContainer.VehicleFrameTexture",
    "PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon",
    "PlayerFrameTexture",
}
-- Frames whose texture regions are tinted as a whole (classic).
local ART_FRAMES = { "PlayerFrameAlternateManaBar", "PlayerFrameGroupIndicator" }
-- Named regions of class resource points (retail).
local POINT_REGIONS = {
    "BGActive", "BGInactive", "BGShadow", "ChargedFrameActive", "ArcaneBG", "ArcaneBGShadow", "Background",
    "BG_Active", "BG_Inactive", "BG_Shadow", "Chi_BG", "Chi_BG_Active",
}
-- Nameplate / personal resource copies of the class bars (painted with the player bar).
local NAMEPLATE_BARS = {
    "ClassNameplateBarRogueFrame", "ClassNameplateBarMageFrame", "ClassNameplateBarWarlockFrame",
    "ClassNameplateBarFeralDruidFrame", "ClassNameplateBarWindwalkerMonkFrame", "ClassNameplateBarDracthyrFrame",
    "ClassNameplateBarPaladinFrame", "DeathKnightResourceOverlayFrame", "prdClassFrame",
}

local painted = setmetatable({}, { __mode = "k" }) -- texture -> desaturate

local function paint(texture, desaturate)
    if texture then
        painted[texture] = desaturate == true
        UF.Paint(texture, desaturate)
    end
end

-- Class bar textures keep their tint once painted; only new ones are painted.
local function paintOnce(texture, desaturate)
    if texture and painted[texture] == nil then
        paint(texture, desaturate)
    end
end

local function isElite(frame)
    local unit = frame.unit
    local class = unit and UnitClassification(unit)
    return CanAccess(class) and (class == "elite" or class == "rare" or class == "rareelite" or class == "worldboss")
end

-- Retail reputation bars carry the theme (1.x); classic keeps its reaction colours.
-- Not kept in the paint registry: without a theme Blizzard's faction colour stays.
local function paintReputation(frame)
    local bar = frame.TargetFrameContent and SUI.Theme.enabled and UF.Reputation(frame)
    if bar then
        bar:SetVertexColor(SUI.Theme:Color(0.15))
    end
end

local function paintTarget(frame)
    local border = UF.Border(frame)
    -- Retail keeps the elite dragon in its own texture, which 1.x never tinted.
    -- Classic draws it into the border, so the option decides there.
    if not UF.EliteTexture(frame) and border and Tint.db.elitecolor and isElite(frame) then
        painted[border] = nil
        border:SetDesaturated(false)
        border:SetVertexColor(1, 1, 1)
    else
        paint(border)
    end
    paintReputation(frame)
end

local function paintPoint(point, desaturate)
    for i = 1, #POINT_REGIONS do
        paintOnce(point[POINT_REGIONS[i]], desaturate)
    end
    local essence = point.EssenceFillDone
    if essence then
        paintOnce(essence.CircBG)
        paintOnce(essence.CircBGActive)
    end
end

local function paintBarFrame(bar)
    local points = bar.classResourceButtonTable
    if points then
        for i = 1, #points do
            paintPoint(points[i])
        end
    end
    local pool = bar.classResourceButtonPool
    if pool and type(pool.EnumerateActive) == "function" then
        for point in pool:EnumerateActive() do
            paintPoint(point)
        end
    end
    for i = 1, 6 do
        local rune = bar["Rune" .. i]
        if rune then
            paintPoint(rune, true)
        end
    end
    if not points and not pool then
        -- Personal resource display: points are plain children.
        for i = 1, select("#", bar:GetChildren()) do
            paintPoint((select(i, bar:GetChildren())))
        end
    end
    if bar.Background then
        paintOnce(bar.Background, true)
    end
    if bar.ActiveTexture then
        bar.ActiveTexture:SetAlpha(SUI.Theme.enabled and 0 or 1)
    end
end

local function paintClassBar(bar)
    paintBarFrame(bar)
    for i = 1, #NAMEPLATE_BARS do
        local other = _G[NAMEPLATE_BARS[i]]
        if other and other ~= bar and not other:IsForbidden() then
            paintBarFrame(other)
        end
    end
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
    for i = 1, #PLAYER_ART do
        local path = PLAYER_ART[i]
        paint(UF.Resolve(path), ART[path])
    end
end

function Tint:OnLoad()
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        local frame = targets[i]
        if frame.CheckClassification then
            self:Hook(frame, "CheckClassification", paintTarget)
        end
        if frame.CheckFaction then
            self:Hook(frame, "CheckFaction", paintReputation)
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
    for path, desaturate in next, ART do
        paint(UF.Resolve(path), desaturate)
    end
    for i = 1, #ART_FRAMES do
        local frame = _G[ART_FRAMES[i]]
        if frame then
            for j = 1, select("#", frame:GetRegions()) do
                local region = select(j, frame:GetRegions())
                if region:GetObjectType() == "Texture" then
                    paint(region, true)
                end
            end
        end
    end
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        paintTarget(targets[i])
    end
    -- 1.x hid the target and focus reputation bars once at login.
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        local bar = frame and frame.TargetFrameContent and UF.Reputation(frame)
        if bar then
            bar:Hide()
        end
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
    for texture, desaturate in next, painted do
        UF.Paint(texture, desaturate)
    end
    local targets = UF.TargetFrames()
    for i = 1, #targets do
        paintReputation(targets[i])
    end
    local bars = UF.ClassBars()
    for i = 1, #bars do
        if bars[i].ActiveTexture then
            bars[i].ActiveTexture:SetAlpha(SUI.Theme.enabled and 0 or 1)
        end
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
