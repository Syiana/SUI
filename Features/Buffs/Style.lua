--[[ SUI 2.0 - Features/Buffs/Style.lua
    SUI 1.x look of the player buff and debuff frames: gloss border and soft
    shadow (theme dependent, repainted on theme change, none for the
    Blizzard theme), plus duration and stack texts.
    All clients use Blizzard's AuraFrame (BuffFrame/DebuffFrame) with a fixed
    set of aura buttons, so every button is styled once at load. Hooks on the
    button only redo what Blizzard resets: the debuff border colour on
    Update, the duration text on UpdateDuration and the duration font and
    anchor when Blizzard sets them again.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, ceil, CreateFrame = _G, math.ceil, CreateFrame
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Buffs.Style", {
    category = "buffs",
    toggle = "style",
    conflicts = { "BlizzBuffsFacade" },
    reload = true, -- borders and fonts are not taken back without a reload
})

local GLOSS = SUI.mediaPath .. [[Textures\Core\gloss]]
local GLOSS_WHITE = SUI.mediaPath .. [[Textures\Core\gloss_border_w]]
local SHADOW = SUI.mediaPath .. [[Textures\Nameplates\textureShadow]]
local HOLDER_SIZE = 34 -- 1.x: border and shadow sit on a 34px square centred on the icon

-- Debuff type colours as numbers (1.x palette).
local TYPE_R = { none = 0.8, Magic = 0.2, Curse = 0.6, Disease = 0.6, Poison = 0 }
local TYPE_G = { none = 0, Magic = 0.6, Curse = 0, Disease = 0.4, Poison = 0.6 }
local TYPE_B = { none = 0, Magic = 1, Curse = 1, Disease = 0, Poison = 0 }

local buttons = {} -- button -> "buff" | "debuff"

local function settings(button)
    return F.db[buttons[button]]
end

local function colorDebuff(button)
    local info = button.buttonInfo
    local kind = info and info.debuffType
    if not CanAccess(kind) or not kind or not TYPE_R[kind] then
        kind = "none"
    end
    button.suiBorder:SetVertexColor(TYPE_R[kind], TYPE_G[kind], TYPE_B[kind], 1)
end

-- Theme look (1.x): Dark uses the grey gloss and a black shadow, other themes
-- the white gloss tinted with the theme colour. "Blizzard" shows no SUI art.
local function paint(button)
    local Theme = SUI.Theme
    local shown = Theme.enabled
    button.suiHolder:SetShown(shown)
    button.suiBorder:SetShown(shown)
    if button.DebuffBorder then
        button.DebuffBorder:SetAlpha(shown and 0 or 1)
    end
    if button.TempEnchantBorder then
        button.TempEnchantBorder:SetAlpha(shown and 0 or 1)
    end
    button.Icon:SetTexCoord(shown and 0.08 or 0, shown and 0.92 or 1, shown and 0.08 or 0, shown and 0.92 or 1)
    if not shown then
        return
    end
    local dark = Theme.name == "Dark"
    if dark then
        button.suiShadow:SetVertexColor(0, 0, 0, 0.9)
    else
        local r, g, b = Theme:Color(0.2)
        button.suiShadow:SetVertexColor(r, g, b, 0.9)
    end
    if buttons[button] == "debuff" then
        colorDebuff(button)
    else
        button.suiBorder:SetTexture(dark and GLOSS or GLOSS_WHITE)
        if dark then
            button.suiBorder:SetVertexColor(0.4, 0.35, 0.35, 1)
        else
            local r, g, b = Theme:Color()
            button.suiBorder:SetVertexColor(r, g, b, 1)
        end
    end
end

local function formatDuration(button, timeLeft)
    if not timeLeft or not CanAccess(timeLeft) or not button.Duration:IsShown() then
        return
    end
    local duration = button.Duration
    if timeLeft >= 86400 then
        duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
    elseif timeLeft >= 3600 then
        duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
    elseif timeLeft >= 60 then
        duration:SetFormattedText("%dm", ceil(timeLeft / 60))
    else
        duration:SetFormattedText("%ds", timeLeft)
    end
end

local function setDurationFont(button)
    local db = settings(button)
    button.suiBusy = true
    button.Duration:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
    button.suiBusy = nil
end

local function setDurationPoint(button)
    local db = settings(button)
    local duration = button.Duration
    button.suiBusy = true
    duration:ClearAllPoints()
    duration:SetPoint("TOP", button, "BOTTOM", 0, db.durationoffset)
    button.suiBusy = nil
end

local function applyButton(button)
    local db = settings(button)
    setDurationFont(button)
    setDurationPoint(button)
    button.Duration:SetAlpha(db.durationtext and 1 or 0)
    button.Duration:SetDrawLayer("ARTWORK")
    local count = button.Count
    count:SetDrawLayer("ARTWORK")
    count:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
    count:ClearAllPoints()
    count:SetPoint("TOPRIGHT", button, "TOPRIGHT", db.countx, db.county)
end

function F:InitButton(button, kind)
    buttons[button] = kind
    local icon = button.Icon

    local holder = CreateFrame("Frame", nil, button)
    holder:SetFrameLevel(button:GetFrameLevel())
    holder:SetPoint("CENTER", icon, "CENTER", 0, 0)
    holder:SetSize(HOLDER_SIZE, HOLDER_SIZE)
    holder:SetAlpha(icon:GetAlpha() or 1)
    button.suiHolder = holder

    local shadow = holder:CreateTexture(nil, "BACKGROUND", nil, -8)
    shadow:SetTexture(SHADOW)
    shadow:SetPoint("CENTER", holder, "CENTER", 0, 0)
    shadow:SetSize(HOLDER_SIZE + 8, HOLDER_SIZE + 8)
    button.suiShadow = shadow

    local border = button:CreateTexture(nil, "OVERLAY", nil, 1)
    border:SetTexture(GLOSS_WHITE)
    border:SetAllPoints(holder)
    button.suiBorder = border

    self:Hook(icon, "SetAlpha", function(_, alpha)
        holder:SetAlpha(alpha)
    end)
    if kind == "debuff" then
        self:Hook(button, "Update", function()
            if SUI.Theme.enabled then
                colorDebuff(button)
            end
        end)
    end
    paint(button)
    if button.UpdateDuration then
        self:Hook(button, "UpdateDuration", formatDuration)
    end
    -- Blizzard re-applies the duration font and anchor on layout and, on some
    -- clients, from the button's OnUpdate.
    local duration = button.Duration
    self:Hook(duration, "SetFontObject", function()
        if not button.suiBusy then
            setDurationFont(button)
        end
    end)
    self:Hook(duration, "SetPoint", function()
        if not button.suiBusy then
            setDurationPoint(button)
        end
    end)
end

function F:OnLoad()
    for host, kind in next, { BuffFrame = "buff", DebuffFrame = "debuff" } do
        local frame = _G[host]
        local list = frame and frame.auraFrames
        if list then
            for i = 1, #list do
                local button = list[i]
                if not button.isAuraAnchor and button.Icon and button.Duration and button.Count then
                    self:InitButton(button, kind)
                end
            end
        end
    end
end

function F:Apply()
    for button in next, buttons do
        applyButton(button)
    end
    local collapse = _G.BuffFrame and _G.BuffFrame.CollapseAndExpandButton
    if collapse then
        local show = self.db.buff.collapse
        collapse:SetAlpha(show and 1 or 0)
        collapse:EnableMouse(show)
    end
end

F.OnEnable = F.Apply
F.OnRefresh = F.Apply

function F:OnThemeChanged()
    for button in next, buttons do
        paint(button)
    end
end
