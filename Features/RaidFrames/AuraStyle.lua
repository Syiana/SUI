--[[
    SUI 2.0 - Features/RaidFrames/AuraStyle.lua

    The SUI 1.x look of raid frame aura icons on every client: cropped icon,
    gloss border, outer shadow and an optional white border that is coloured
    by debuff type. Aura features call RF.StyleAura once per button when it
    is built; this feature repaints the decorations on theme changes
    ("Blizzard" = no decorations).
]]

local _, ns = ...
local SUI = ns.SUI
local RF = ns.RaidFrames

local CreateFrame, pairs, max = CreateFrame, pairs, math.max

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
RF.DEBUFF_R = { none = 0.8, Magic = 0.2, Curse = 0.6, Disease = 0.6, Poison = 0 }
RF.DEBUFF_G = { none = 0, Magic = 0.6, Curse = 0, Disease = 0.4, Poison = 0.6 }
RF.DEBUFF_B = { none = 0, Magic = 1, Curse = 1, Disease = 0, Poison = 0 }

local styled = setmetatable({}, { __mode = "k" }) -- button -> true

local function applyTheme(button)
    local theme = SUI.Theme
    local shown = theme.enabled
    button.suiBorder:SetShown(shown)
    button.suiShadow:SetShown(shown)
    if shown then
        button.suiBorder:SetVertexColor(theme:Color(0.15))
        local r, g, b = theme:Color(0.25)
        button.suiShadow:SetBackdropBorderColor(r, g, b, 0.9)
    end
end

-- overlay: frame above the cooldown swipe that carries the borders. Returns
-- the white type border when withTypeBorder is set (the caller colours it).
function RF.StyleAura(button, icon, overlay, withTypeBorder)
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    local border = overlay:CreateTexture(nil, "OVERLAY", nil, 1)
    border:SetTexture(GLOSS)
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
    button.suiBorder = border

    local shadow = CreateFrame("Frame", nil, button, "BackdropTemplate")
    shadow:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4)
    shadow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4)
    shadow:SetFrameLevel(max(button:GetFrameLevel() - 1, 0))
    shadow:SetBackdrop(SHADOW)
    SUI:ProtectBackdrop(shadow)
    button.suiShadow = shadow

    local typeBorder
    if withTypeBorder then
        typeBorder = overlay:CreateTexture(nil, "OVERLAY", nil, 2)
        typeBorder:SetTexture(GLOSS_WHITE)
        typeBorder:SetDesaturated(true)
        typeBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
        typeBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
    end

    styled[button] = true
    applyTheme(button)
    return typeBorder
end

local Style = SUI:NewFeature("RaidFrames.AuraStyle", { category = "raidframes" })

function Style:OnThemeChanged()
    for button in pairs(styled) do
        applyTheme(button)
    end
end

-- Anchoring shared by the retail and classic rows -------------------------------
-- Rows in a bottom corner sit on top of a shown power bar (1.x), so they
-- never cover a healer's mana; returns reference, relative point, x, y.
local ABOVE_POWER = { BOTTOMLEFT = "TOPLEFT", BOTTOM = "TOP", BOTTOMRIGHT = "TOPRIGHT" }
local INSET_X = { TOPLEFT = 2, LEFT = 2, BOTTOMLEFT = 2, TOPRIGHT = -2, RIGHT = -2, BOTTOMRIGHT = -2 }
local INSET_Y = { TOPLEFT = -2, TOP = -2, TOPRIGHT = -2 }

function RF.AuraAnchor(frame, point)
    local x = INSET_X[point] or 0
    local above = ABOVE_POWER[point]
    if above then
        local power = frame.powerBar
        if power and power:IsShown() then
            return power, above, x, 1
        end
        return frame, point, x, 2
    end
    return frame, point, x, INSET_Y[point] or 0
end

-- Growth: horizontal?, x sign, y sign. The second direction (new rows or
-- columns) points away from the edge the anchor sits on.
function RF.AuraGrowth(point, grow)
    local bottom = ABOVE_POWER[point] ~= nil
    local right = INSET_X[point] == -2
    if grow == "LEFT" or grow == "RIGHT" then
        return true, grow == "RIGHT" and 1 or -1, bottom and 1 or -1
    end
    return false, right and -1 or 1, grow == "UP" and 1 or -1
end
