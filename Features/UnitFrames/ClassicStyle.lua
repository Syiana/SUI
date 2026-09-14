--[[ SUI 2.0 - Features/UnitFrames/ClassicStyle.lua
    Retail only: the "Classic" unit frame style puts the pre-Dragonflight
    frame art over the player, pet, target and focus frames and moves bars,
    texts and icons to match it. Styling runs once and again after the
    Blizzard functions that re-layout the frames (player art, classification).
    Switching back needs a reload.
]]

local _, ns = ...
local SUI = ns.SUI

local _G = _G

local F = SUI:NewFeature("UnitFrames.ClassicStyle", {
    category = "unitframes",
    clients = { Mainline = true },
    toggle = function(db)
        return db.style == "Classic"
    end,
    reload = true,
})

local TARGET_ART = [[Interface\TargetingFrame\UI-TargetingFrame]]
local TOT_ART = [[Interface\TargetingFrame\UI-TargetofTargetFrame]]
local SMALL_ART = [[Interface\TargetingFrame\UI-SmallTargetingFrame]]

local artTextures = {} -- textures that carry the dark tint

local function tint(texture)
    artTextures[texture] = true
    if SUI.Theme.enabled then
        texture:SetVertexColor(SUI.Theme:Color(0.1))
    else
        texture:SetVertexColor(1, 1, 1)
    end
end

local function move(region, point, relativeTo, relativePoint, x, y)
    if region then
        region:ClearAllPoints()
        region:SetPoint(point, relativeTo, relativePoint, x, y)
    end
end

-- Keeps x/y of the first anchor, replacing the given offsets.
local function offset(region, x, y)
    if not region then
        return
    end
    local point, relativeTo, relativePoint, ox, oy = region:GetPoint(1)
    if point then
        region:ClearAllPoints()
        region:SetPoint(point, relativeTo, relativePoint, x or ox or 0, y or oy or 0)
    end
end

local function reparent(region, parent)
    if region then
        region:SetParent(parent)
    end
end

-- Overlay frame with the classic art and a dark backdrop behind the bars.
local function overlay(frame)
    local art = frame.suiClassic
    if not art then
        art = CreateFrame("Frame", nil, frame)
        art:SetAllPoints(frame)
        art:SetFrameLevel(frame:GetFrameLevel() + 5)
        art.texture = art:CreateTexture(nil, "BORDER")
        art.backdrop = frame:CreateTexture(nil, "BACKGROUND")
        art.backdrop:SetColorTexture(0, 0, 0, 0.45)
        frame.suiClassic = art
    end
    return art
end

local function styleName(frame, anchor, width, art)
    local name = frame.name
    if name and anchor then
        name:SetParent(art)
        move(name, "BOTTOM", anchor, "TOP", 0, -5)
        name:SetWidth(width)
        name:SetScale(0.9)
        name:SetJustifyH("CENTER")
        name:SetWordWrap(false)
    end
end

local function styleBarTexts(bar, art, anchor, left, right, center, y)
    if not bar then
        return
    end
    local leftText, rightText, centerText = bar.LeftText, bar.RightText, bar.HealthBarText or bar.ManaBarText
    reparent(leftText, art)
    reparent(rightText, art)
    reparent(centerText, art)
    move(leftText, "LEFT", anchor, "LEFT", left, y)
    move(rightText, "RIGHT", anchor, "RIGHT", right, y)
    move(centerText, "CENTER", anchor, center[1], center[2], y)
end

local function styleTarget(frame)
    local content, container = frame.TargetFrameContent, frame.TargetFrameContainer
    if not content or not container then
        return
    end
    local main, context = content.TargetFrameContentMain, content.TargetFrameContentContextual
    local health, mana = main.HealthBarsContainer, main.ManaBar
    local art = overlay(frame)
    local texture = art.texture

    if container.FrameTexture then
        container.FrameTexture:SetAlpha(0)
    end
    texture:SetTexture(TARGET_ART)
    texture:SetTexCoord(0.09375, 1, 0, 0.78125)
    texture:SetSize(232, 100)
    move(texture, "TOPLEFT", frame, "TOPLEFT", 20, -8)
    tint(texture)

    art.backdrop:ClearAllPoints()
    art.backdrop:SetPoint("TOPLEFT", health.HealthBar, "TOPLEFT", 3, 9)
    art.backdrop:SetPoint("BOTTOMRIGHT", mana, "BOTTOMRIGHT", -7, 0)
    styleName(frame, health, 69, art)

    if health.HealthBarMask then
        health.HealthBarMask:SetSize(125, 17)
        offset(health.HealthBarMask, 1, -6)
    end
    offset(health.HealthBar and health.HealthBar.OverAbsorbGlow, -7)
    if mana.ManaBarMask then
        mana.ManaBarMask:SetWidth(253)
        offset(mana.ManaBarMask, -59)
    end

    container.Portrait:SetSize(62, 62)
    move(container.Portrait, "TOPRIGHT", frame, "TOPRIGHT", -23, -22)
    if container.PortraitMask then
        container.PortraitMask:SetSize(61, 61)
        move(container.PortraitMask, "CENTER", container.Portrait, "CENTER", 0, 0)
    end
    if container.Flash then
        container.Flash:SetParent(frame)
        container.Flash:SetDrawLayer("BACKGROUND")
        container.Flash:SetSize(240.5, 93)
        move(container.Flash, "TOPLEFT", frame, "TOPLEFT", -2.5, -8)
    end
    if container.BossPortraitFrameTexture then
        container.BossPortraitFrameTexture:SetAlpha(0)
    end

    styleBarTexts(health, art, texture, 7, -108, { "LEFT", 66 }, 3)
    styleBarTexts(mana, art, texture, 7, -108, { "LEFT", 66 }, -8.5)

    if main.LevelText then
        reparent(main.LevelText, art)
        move(main.LevelText, "CENTER", frame, "BOTTOMRIGHT", -34, 25.5)
    end
    if main.ReputationColor then
        main.ReputationColor:SetSize(119, 18)
        main.ReputationColor:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-LevelBackground]])
        move(main.ReputationColor, "TOPRIGHT", frame, "TOPRIGHT", -87, -31)
    end
    if context.HighLevelTexture then
        reparent(context.HighLevelTexture, art)
        move(context.HighLevelTexture, "CENTER", frame, "BOTTOMRIGHT", -34, 25)
    end
    if context.PetBattleIcon then
        reparent(context.PetBattleIcon, art)
        move(context.PetBattleIcon, "CENTER", frame, "BOTTOMRIGHT", -35, 25)
    end
    if context.LeaderIcon then
        reparent(context.LeaderIcon, art)
        move(context.LeaderIcon, "TOPRIGHT", frame, "TOPRIGHT", -84, -13.5)
    end
    if context.RaidTargetIcon then
        reparent(context.RaidTargetIcon, art)
        move(context.RaidTargetIcon, "CENTER", container.Portrait, "TOP", 1.5, 1)
    end
    if frame.threatIndicator then
        frame.threatIndicator:SetAlpha(0)
    end
    if context.NumericalThreat then
        context.NumericalThreat:SetAlpha(0)
    end

    local tot = frame.totFrame
    if tot and tot.FrameTexture then
        tot.FrameTexture:SetTexture(TOT_ART)
        tot.FrameTexture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
        tot.FrameTexture:SetSize(93, 45)
        move(tot.FrameTexture, "TOPLEFT", tot, "TOPLEFT", 0, 0)
        tint(tot.FrameTexture)
        tot.Portrait:SetSize(37, 37)
        move(tot.Portrait, "TOPLEFT", tot, "TOPLEFT", 4, -5)
        tot.HealthBar:SetSize(47, 7)
        move(tot.HealthBar, "TOPRIGHT", tot, "TOPRIGHT", -29, -15)
        tot.ManaBar:SetSize(49, 7)
        move(tot.ManaBar, "TOPRIGHT", tot, "TOPRIGHT", -29, -23)
    end
end

local function stylePlayer()
    local frame = _G.PlayerFrame
    local content, container = frame and frame.PlayerFrameContent, frame and frame.PlayerFrameContainer
    if not content or not container then
        return
    end
    local main, context = content.PlayerFrameContentMain, content.PlayerFrameContentContextual
    local health = main.HealthBarsContainer
    local mana = main.ManaBarArea and main.ManaBarArea.ManaBar
    local art = overlay(frame)
    local texture = art.texture

    for _, key in next, { "FrameTexture", "AlternatePowerFrameTexture", "VehicleFrameTexture" } do
        if container[key] then
            container[key]:SetAlpha(0)
        end
    end
    texture:SetTexture(TARGET_ART)
    texture:SetTexCoord(1, 0.09375, 0, 0.78125)
    texture:SetSize(232, 100)
    move(texture, "TOPLEFT", frame, "TOPLEFT", -19, -8)
    tint(texture)

    if mana then
        art.backdrop:ClearAllPoints()
        art.backdrop:SetPoint("TOPLEFT", health.HealthBar, "TOPLEFT", 0, 11)
        art.backdrop:SetPoint("BOTTOMRIGHT", mana, "BOTTOMRIGHT", -1, 0)
        reparent(mana.FullPowerFrame, art)
    end
    styleName(frame, health, 76, art)

    if health.HealthBarMask then
        health.HealthBarMask:SetSize(126, 17)
        offset(health.HealthBarMask, 0, -6)
    end
    offset(health.HealthBar and health.HealthBar.OverAbsorbGlow, -3)
    if mana and mana.ManaBarMask then
        mana.ManaBarMask:SetSize(126, 19)
        offset(mana.ManaBarMask, 0, 2)
    end

    container.PlayerPortrait:SetSize(62, 62)
    move(container.PlayerPortrait, "TOPLEFT", frame, "TOPLEFT", 26, -23)
    if container.PlayerPortraitMask then
        container.PlayerPortraitMask:SetSize(62, 62)
        container.PlayerPortraitMask:SetTexture([[Interface\CHARACTERFRAME\TempPortraitAlphaMask]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        move(container.PlayerPortraitMask, "CENTER", container.PlayerPortrait, "CENTER", 0, 0)
    end
    if container.FrameFlash then
        container.FrameFlash:SetParent(frame)
        container.FrameFlash:SetDrawLayer("BACKGROUND")
        container.FrameFlash:SetSize(240.5, 93)
        move(container.FrameFlash, "TOPLEFT", frame, "TOPLEFT", -4.5, -8)
    end

    styleBarTexts(health, art, texture, 108, -7, { "CENTER", 52 }, 3)
    styleBarTexts(mana, art, texture, 108, -7, { "CENTER", 52 }, -8.5)

    if _G.PlayerLevelText then
        reparent(_G.PlayerLevelText, art)
        move(_G.PlayerLevelText, "CENTER", frame, "CENTER", -81, -24.5)
    end
    if context.AttackIcon then
        reparent(context.AttackIcon, art)
        move(context.AttackIcon, "CENTER", frame, "CENTER", -80, -23.5)
        context.AttackIcon:SetSize(32, 31)
        context.AttackIcon:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
        context.AttackIcon:SetTexCoord(0.5, 1.0, 0, 0.484375)
        context.AttackIcon:SetDrawLayer("OVERLAY")
    end
    if context.PlayerPortraitCornerIcon then
        context.PlayerPortraitCornerIcon:SetAlpha(0)
    end
    if frame.threatIndicator then
        frame.threatIndicator:SetAlpha(0)
    end
    if context.RoleIcon then
        reparent(context.RoleIcon, art)
        move(context.RoleIcon, "TOPLEFT", frame, "TOPLEFT", 192, -34)
    end
    if context.GroupIndicator then
        reparent(context.GroupIndicator, art)
        move(context.GroupIndicator, "BOTTOMRIGHT", frame, "TOPRIGHT", -21, -33.5)
    end
    if main.StatusTexture then
        main.StatusTexture:SetSize(191, 77)
        main.StatusTexture:SetTexture([[Interface\CharacterFrame\UI-Player-Status]])
        main.StatusTexture:SetTexCoord(0, 0.74609375, 0, 0.58125)
        move(main.StatusTexture, "TOPLEFT", frame, "TOPLEFT", 17, -15)
        main.StatusTexture:SetBlendMode("ADD")
    end

    local pet = _G.PetFrame
    if pet then
        pet:SetSize(128, 53)
        move(_G.PetPortrait, "TOPLEFT", pet, "TOPLEFT", 7, -6)
        local petArt = _G.PetFrameTexture
        if petArt then
            petArt:SetSize(128, 64)
            petArt:SetTexture(SMALL_ART)
            tint(petArt)
        end
    end
end

function F:OnLoad()
    if PlayerFrame_ToPlayerArt then
        self:Hook("PlayerFrame_ToPlayerArt", stylePlayer)
    end
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        if frame and frame.CheckClassification then
            self:Hook(frame, "CheckClassification", styleTarget)
        end
    end
end

function F:OnEnable()
    SUI:RunAfterCombat(function()
        stylePlayer()
        for _, name in next, { "TargetFrame", "FocusFrame" } do
            if _G[name] then
                styleTarget(_G[name])
            end
        end
    end)
end

function F:OnThemeChanged()
    for texture in next, artTextures do
        tint(texture)
    end
end
