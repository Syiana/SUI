--[[ SUI 2.0 - Features/UnitFrames/Compat.lua
    Where the Blizzard unit frames keep their parts on each client. Retail
    uses the nested PlayerFrameContent/TargetFrameContent layout, the classic
    clients the old named textures. Everything is resolved lazily inside
    functions, so nothing client specific is touched at file load.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, next, UnitIsPlayer, UnitIsConnected, UnitClass, UnitExists = _G, next, UnitIsPlayer, UnitIsConnected, UnitClass, UnitExists
local UnitIsTapDenied, UnitPlayerControlled, UnitReaction = UnitIsTapDenied, UnitPlayerControlled, UnitReaction

local UF = {}
ns.UnitFrames = UF

local Compat = SUI.Compat
local CanAccess = Compat.CanAccess

-- Parent for regions that must stay hidden whatever Blizzard does to them.
function UF.Hidden()
    local frame = UF.hiddenFrame
    if not frame then
        frame = CreateFrame("Frame")
        frame:Hide()
        UF.hiddenFrame = frame
    end
    return frame
end

UF.Resolve = SUI.Skin.Resolve

-- Frames ------------------------------------------------------------------------
local UNIT_FRAMES = {
    "PlayerFrame", "PetFrame", "TargetFrame", "FocusFrame", "TargetFrameToT", "FocusFrameToT",
    "Boss1TargetFrame", "Boss2TargetFrame", "Boss3TargetFrame", "Boss4TargetFrame", "Boss5TargetFrame",
}
local TARGET_FRAMES = { "TargetFrame", "FocusFrame", "Boss1TargetFrame", "Boss2TargetFrame", "Boss3TargetFrame", "Boss4TargetFrame", "Boss5TargetFrame" }

local function collect(names)
    local out = {}
    for i = 1, #names do
        local frame = _G[names[i]]
        if frame then
            out[#out + 1] = frame
        end
    end
    return out
end

-- Player, pet, target, focus, their targets and the boss frames.
function UF.Frames()
    UF.frames = UF.frames or collect(UNIT_FRAMES)
    return UF.frames
end

-- Frames built from the target frame template (target, focus, bosses).
function UF.TargetFrames()
    UF.targetFrames = UF.targetFrames or collect(TARGET_FRAMES)
    return UF.targetFrames
end

-- Retail keeps the parts of target-like frames in TargetFrameContent.
local function content(frame)
    local c = frame.TargetFrameContent
    return c and c.TargetFrameContentMain, c and c.TargetFrameContentContextual
end

-- The frame art that carries the theme tint.
function UF.Border(frame)
    local container = frame.TargetFrameContainer
    return container and container.FrameTexture or frame.borderTexture
end

-- Golden dragon of elite/rare units (retail has a separate texture).
function UF.EliteTexture(frame)
    local container = frame.TargetFrameContainer
    return container and container.BossPortraitFrameTexture
end

-- Name background / reputation bar.
function UF.Reputation(frame)
    local main = content(frame)
    return main and main.ReputationColor or frame.nameBackground
end

-- Fills `out` with the level text regions of all frames.
function UF.LevelRegions(out)
    out[#out + 1] = _G.PlayerLevelText
    local frames = UF.TargetFrames()
    for i = 1, #frames do
        local frame = frames[i]
        local main, contextual = content(frame)
        out[#out + 1] = main and main.LevelText or frame.levelText
        out[#out + 1] = contextual and contextual.HighLevelTexture or frame.highLevelTexture
    end
    return out
end

-- Fills `out` with PvP icons and prestige badges.
function UF.PvPRegions(out)
    local player = _G.PlayerFrame
    local playerContent = player and player.PlayerFrameContent
    local ctx = playerContent and playerContent.PlayerFrameContentContextual
    if ctx then
        out[#out + 1] = ctx.PVPIcon
        out[#out + 1] = ctx.PrestigeBadge
        out[#out + 1] = ctx.PrestigePortrait
    else
        out[#out + 1] = _G.PlayerPVPIcon
    end
    for _, name in next, { "TargetFrame", "FocusFrame" } do
        local frame = _G[name]
        if frame then
            local _, contextual = content(frame)
            if contextual then
                out[#out + 1] = contextual.PvpIcon
                out[#out + 1] = contextual.PrestigeBadge
                out[#out + 1] = contextual.PrestigePortrait
            else
                out[#out + 1] = frame.pvpIcon
            end
        end
    end
    return out
end

-- Class resource frames shown with the player frame.
local CLASS_BARS = {
    -- retail
    "RogueComboPointBarFrame", "DruidComboPointBarFrame", "MageArcaneChargesFrame", "WarlockPowerFrame",
    "MonkHarmonyBarFrame", "EssencePlayerFrame", "RuneFrame", "PaladinPowerBarFrame",
    -- classic
    "ComboFrame", "PaladinPowerBar", "MonkHarmonyBar", "PriestBarFrame", "EclipseBarFrame",
}
function UF.ClassBars()
    UF.classBars = UF.classBars or collect(CLASS_BARS)
    return UF.classBars
end

-- Colours -------------------------------------------------------------------------
-- Class colour as r, g, b. A secret class token cannot be used as a table key,
-- so it goes straight to C_ClassColor (which accepts secrets on retail).
function UF.ClassColor(class)
    if CanAccess(class) then
        return Compat.GetClassColor(class)
    end
    local color = C_ClassColor and C_ClassColor.GetClassColor(class)
    if color then
        return color.r, color.g, color.b
    end
    return 1, 1, 1
end

-- Health colour of a unit: class for players, grey when tapped or offline,
-- reaction otherwise. Returns nil when there is nothing to colour.
function UF.UnitColor(unit)
    if not unit or not UnitExists(unit) then
        return nil
    end
    if UnitIsPlayer(unit) then
        if not UnitIsConnected(unit) then
            return 0.5, 0.5, 0.5
        end
        local _, class = UnitClass(unit)
        return UF.ClassColor(class)
    end
    if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
        return 0.5, 0.5, 0.5
    end
    local reaction = UnitReaction(unit, "player")
    local color = CanAccess(reaction) and reaction and FACTION_BAR_COLORS and FACTION_BAR_COLORS[reaction]
    if color then
        return color.r, color.g, color.b
    end
    return nil
end

-- Theme tint for unit frame art; without a tinting theme the art is reset.
function UF.Paint(texture)
    if not texture then
        return
    end
    local Theme = SUI.Theme
    if Theme.enabled then
        texture:SetDesaturated(true)
        texture:SetVertexColor(Theme:Color(0.15))
    else
        texture:SetDesaturated(false)
        texture:SetVertexColor(1, 1, 1)
    end
end

