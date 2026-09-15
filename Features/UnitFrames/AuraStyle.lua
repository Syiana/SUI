--[[ SUI 2.0 - Features/UnitFrames/AuraStyle.lua
    The SUI 1.x look of target and focus aura buttons: cropped icon, gloss
    border, outer shadow and a dispel-type coloured border on debuffs
    (white on purgeable buffs). Aura features call UF.StyleAura once per
    button when it is created; this feature only repaints and shows or
    hides the decorations when the theme changes ("Blizzard" = none).
]]

local _, ns = ...
local SUI = ns.SUI
local UF = ns.UnitFrames

local CreateFrame = CreateFrame

local F = SUI:NewFeature("UnitFrames.AuraStyle", {
    category = "unitframes",
})

local TEXTURES = SUI.mediaPath .. [[Textures\Core\]]
local GLOSS = TEXTURES .. "gloss"
local GLOSS_WHITE = TEXTURES .. "gloss_border_w"
local SHADOW = {
    edgeFile = TEXTURES .. "outer_shadow",
    tile = false,
    tileSize = 32,
    edgeSize = 4,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- Debuff type colours (1.x palette), as numbers.
UF.DEBUFF_R = { none = 0.8, Magic = 0.2, Curse = 0.6, Disease = 0.6, Poison = 0 }
UF.DEBUFF_G = { none = 0, Magic = 0.6, Curse = 0, Disease = 0.4, Poison = 0.6 }
UF.DEBUFF_B = { none = 0, Magic = 1, Curse = 1, Disease = 0, Poison = 0 }

local styled = {} -- button -> true

local function paintShadow(button)
    local r, g, b = SUI.Theme:Color(0.25)
    button.suiShadow:SetBackdropBorderColor(r, g, b, 0.9)
end

local function applyTheme(button)
    local shown = SUI.Theme.enabled
    button.suiBorder:SetShown(shown)
    button.suiShadow:SetShown(shown)
    if button.suiTypeBorder then
        button.suiTypeBorder:SetShown(shown and button.suiTypeShown == true)
    end
    if button.suiBlizzardBorder then
        button.suiBlizzardBorder:SetAlpha(shown and 0 or 1)
    end
    if shown then
        paintShadow(button)
    end
end

-- Styles one aura button. overlay: frame above the cooldown swipe that
-- carries the borders (nil = the button itself). blizzardBorder: Blizzard's
-- dispel border, hidden while SUI draws its own.
function UF.StyleAura(button, icon, overlay, blizzardBorder)
    if styled[button] then
        return
    end
    styled[button] = true

    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon:SetDrawLayer("BACKGROUND", -8)

    local holder = overlay or button
    local border = holder:CreateTexture(nil, overlay and "OVERLAY" or "BACKGROUND", nil, overlay and 1 or -7)
    border:SetTexture(GLOSS)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.suiBorder = border

    local typeBorder = holder:CreateTexture(nil, "OVERLAY", nil, 2)
    typeBorder:SetTexture(GLOSS_WHITE)
    typeBorder:SetDesaturated(true)
    typeBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
    typeBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
    typeBorder:Hide()
    button.suiTypeBorder = typeBorder

    local shadow = CreateFrame("Frame", nil, button, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
    shadow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
    shadow:SetFrameLevel(math.max(button:GetFrameLevel() - 1, 0))
    shadow:SetBackdrop(SHADOW)
    SUI:ProtectBackdrop(shadow)
    button.suiShadow = shadow

    button.suiBlizzardBorder = blizzardBorder
    applyTheme(button)
end

-- Colours the gloss border and the type border; r = nil resets to plain gloss.
function UF.ColorAura(button, r, g, b)
    local typeBorder = button.suiTypeBorder
    if not typeBorder then
        return
    end
    if r then
        button.suiBorder:SetVertexColor(r, g, b, 1)
        typeBorder:SetVertexColor(r, g, b, 1)
        button.suiTypeShown = true
    else
        button.suiBorder:SetVertexColor(1, 1, 1, 1)
        button.suiTypeShown = false
    end
    typeBorder:SetShown(button.suiTypeShown and SUI.Theme.enabled)
end

-- Colours a debuff by dispel type name; secret or unknown types count as "none".
function UF.ColorDebuff(button, kind)
    if not SUI.Compat.CanAccess(kind) or not kind or not UF.DEBUFF_R[kind] then
        kind = "none"
    end
    UF.ColorAura(button, UF.DEBUFF_R[kind], UF.DEBUFF_G[kind], UF.DEBUFF_B[kind])
end

function F:OnThemeChanged()
    for button in next, styled do
        applyTheme(button)
    end
end
