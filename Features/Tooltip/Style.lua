--[[
    SUI 2.0 - Features/Tooltip/Style.lua

    The Custom tooltip style: class or reaction coloured names and health
    bar, guild line with rank, level coloured by difficulty, rare/elite/boss
    and AFK tags, raid icon and a target line. The health bar gets SUI's
    texture and sits at the top or bottom of the tooltip.

    Unit data can be secret in Midnight instances, so every value is checked
    with CanAccess before it is compared or concatenated.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, next, floor, format = _G, next, math.floor, string.format
local strmatch = string.match
local CanAccess = SUI.Compat.CanAccess
local GetClassColor = SUI.Compat.GetClassColor
local UnitIsPlayer, UnitClass, UnitReaction, UnitLevel = UnitIsPlayer, UnitClass, UnitReaction, UnitLevel
local UnitClassification, UnitIsAFK, UnitIsDeadOrGhost = UnitClassification, UnitIsAFK, UnitIsDeadOrGhost
local UnitExists, UnitName, UnitIsUnit, GetGuildInfo = UnitExists, UnitName, UnitIsUnit, GetGuildInfo
local GetRaidTargetIndex = GetRaidTargetIndex

local F = SUI:NewFeature("Tooltip.Style", {
    category = "tooltip",
    toggle = function(db)
        return db.style == "Custom"
    end,
})

local TEXT_R, TEXT_G, TEXT_B = 0.4, 0.4, 0.4
local GUILD_R, GUILD_G, GUILD_B = 0.8, 0, 0.6
local DEAD_R, DEAD_G, DEAD_B = 0.5, 0.5, 0.5
local BOSS_R, BOSS_G, BOSS_B = 1, 0, 0
local TARGET_LABEL = "|cffff8080Target|r"
local YOU = "|cffff0000<YOU>|r"
local AFK = " |cff00ffff<AFK>|r"
local TAGS = {
    worldboss = " |cffff0000[B]|r",
    rareelite = " |cffff0000[R+]|r",
    rare = " |cffff9900[R]|r",
    elite = " |cffff6666[E]|r",
}
local BLIZZARD_TEXTURE = [[Interface\TargetingFrame\UI-StatusBar]]

local classHex, reactionHex = {}, {}
local lefts = {} -- index -> GameTooltipTextLeftN
local bar, barBg
local barR, barG, barB -- colour the health bar must keep for the current unit
local settingColor = false

local function hex(r, g, b)
    return format("%02x%02x%02x", floor(r * 255 + 0.5), floor(g * 255 + 0.5), floor(b * 255 + 0.5))
end

local function left(i)
    local line = lefts[i]
    if not line then
        line = _G["GameTooltipTextLeft" .. i]
        lefts[i] = line
    end
    return line
end

local function readText(line)
    local text = line and line:GetText()
    if text and CanAccess(text) then
        return text
    end
end

local function colorBar(r, g, b)
    barR, barG, barB = r, g, b
    settingColor = true
    bar:SetStatusBarColor(r, g, b)
    settingColor = false
end

-- Blizzard recolours the bar on every health update; keep ours.
local function onBarColor()
    if settingColor or not barR then
        return
    end
    settingColor = true
    bar:SetStatusBarColor(barR, barG, barB)
    settingColor = false
end

local function colorLevelLine(unit, index)
    local line = left(index)
    local level = UnitLevel(unit)
    if not line or not CanAccess(level) then
        return
    end
    for i = 2, index - 1 do
        local l = left(i)
        if l then
            l:SetTextColor(TEXT_R, TEXT_G, TEXT_B)
        end
    end
    local c = GetCreatureDifficultyColor(level > 0 and level or 999)
    line:SetTextColor(c.r, c.g, c.b)
end

local function targetText(target)
    local name = UnitName(target)
    if not name or not CanAccess(name) then
        return nil
    end
    local isYou = UnitIsUnit(target, "player")
    if CanAccess(isYou) and isYou then
        return YOU
    end
    local isPlayer = UnitIsPlayer(target)
    if CanAccess(isPlayer) and isPlayer then
        local _, class = UnitClass(target)
        local color = class and CanAccess(class) and classHex[class]
        if color then
            return "|cff" .. color .. name .. "|r"
        end
    else
        local reaction = UnitReaction(target, "player")
        local color = reaction and CanAccess(reaction) and reactionHex[reaction]
        if color then
            return "|cff" .. color .. name .. "|r"
        end
    end
    return name
end

local function onUnit(tooltip)
    if not F.enabled or tooltip ~= GameTooltip then
        return
    end
    barR = nil
    local unit = ns.TooltipUnit(tooltip)
    local isPlayer = unit and UnitIsPlayer(unit)
    if not unit or not CanAccess(isPlayer) then
        return
    end
    local line1 = left(1)
    local tag

    if isPlayer then
        local _, class = UnitClass(unit)
        if class and CanAccess(class) then
            local r, g, b = GetClassColor(class)
            colorBar(r, g, b)
            line1:SetTextColor(r, g, b)
        end
        local guild, rank = GetGuildInfo(unit)
        local levelIndex = 2
        if guild and CanAccess(guild) and CanAccess(rank) then
            local line2 = left(2)
            line2:SetFormattedText("<%s> [%s]", guild, rank)
            line2:SetTextColor(GUILD_R, GUILD_G, GUILD_B)
            levelIndex = 3
        end
        colorLevelLine(unit, levelIndex)
        local afk = UnitIsAFK(unit)
        if CanAccess(afk) and afk then
            tag = AFK
        end
    else
        local reaction = UnitReaction(unit, "player")
        local c = reaction and CanAccess(reaction) and FACTION_BAR_COLORS[reaction]
        if c then
            colorBar(c.r, c.g, c.b)
            line1:SetTextColor(c.r, c.g, c.b)
        end
        -- NPC tooltips have an optional title line before "Level xx".
        local text2 = readText(left(2))
        if text2 and strmatch(text2, "%a%s%d") then
            colorLevelLine(unit, 2)
        else
            local text3 = readText(left(3))
            if text3 and strmatch(text3, "%a%s%d") then
                colorLevelLine(unit, 3)
            end
        end
        local classification = UnitClassification(unit)
        local level = UnitLevel(unit)
        if CanAccess(classification) and CanAccess(level) then
            if level == -1 then
                classification = "worldboss"
            end
            tag = TAGS[classification]
            if classification == "worldboss" and left(2) then
                left(2):SetTextColor(BOSS_R, BOSS_G, BOSS_B)
            end
        end
    end

    local dead = UnitIsDeadOrGhost(unit)
    if CanAccess(dead) and dead then
        line1:SetTextColor(DEAD_R, DEAD_G, DEAD_B)
    end

    local name = readText(line1)
    if name then
        local icon = GetRaidTargetIndex(unit)
        local iconText = icon and CanAccess(icon) and ICON_LIST and ICON_LIST[icon]
        if iconText or tag then
            line1:SetText((iconText and (iconText .. "14|t ") or "") .. name .. (tag or ""))
        end
    end

    local target = unit .. "target"
    local exists = UnitExists(target)
    if CanAccess(exists) and exists then
        tooltip:AddDoubleLine(TARGET_LABEL, targetText(target) or UNKNOWN or "Unknown")
        tooltip:Show()
    end
end

local function layoutBar(db)
    bar:SetStatusBarTexture(db.texture)
    bar:ClearAllPoints()
    bar:SetPoint("LEFT", 4.5, 0)
    bar:SetPoint("RIGHT", -4.5, 0)
    if db.lifeontop then
        bar:SetPoint("TOP", 0, -3)
    else
        bar:SetPoint("BOTTOM", 0, 3)
    end
    bar:SetHeight(4)
end

function F:OnLoad()
    for class in next, RAID_CLASS_COLORS do
        classHex[class] = hex(GetClassColor(class))
    end
    for i = 1, 8 do
        local c = FACTION_BAR_COLORS[i]
        if c then
            reactionHex[i] = hex(c.r, c.g, c.b)
        end
    end
    bar = GameTooltipStatusBar
    barBg = bar:CreateTexture(nil, "BACKGROUND", nil, -8)
    barBg:SetAllPoints()
    barBg:SetColorTexture(0, 0, 0, 0.5)
    self:Hook(bar, "SetStatusBarColor", onBarColor)
    SUI.Compat.OnTooltipUnit(onUnit)
end

function F:OnEnable()
    barBg:Show()
    layoutBar(self.db)
end

function F:OnRefresh(key)
    if key == "texture" or key == "lifeontop" then
        layoutBar(self.db)
    end
end

function F:OnDisable()
    barR = nil
    barBg:Hide()
    bar:SetStatusBarTexture(BLIZZARD_TEXTURE)
    bar:ClearAllPoints()
    bar:SetPoint("BOTTOMLEFT", 2, -9)
    bar:SetPoint("BOTTOMRIGHT", -2, -9)
    bar:SetHeight(8)
end
