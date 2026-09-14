--[[ SUI 2.0 - Features/Buffs/Style.lua
    Borders, duration and stack texts of the player buff and debuff frames.
    All clients use Blizzard's AuraFrame (BuffFrame/DebuffFrame) with a fixed
    set of aura buttons, so every button is styled once at load. Hooks on the
    button only redo what Blizzard resets: the debuff border colour on
    Update, the duration text on UpdateDuration and the duration font and
    anchor when Blizzard sets them again.
]]

local _, ns = ...
local SUI = ns.SUI

local _G, ceil = _G, math.ceil
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Buffs.Style", {
    category = "buffs",
    toggle = "style",
    conflicts = { "BlizzBuffsFacade" },
    reload = true, -- borders and fonts are not taken back without a reload
})

local BORDER = SUI.mediaPath .. [[Textures\Core\gloss_border_w]]

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
    button.suiBorder:SetVertexColor(TYPE_R[kind], TYPE_G[kind], TYPE_B[kind])
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
    local count = button.Count
    count:SetFont(STANDARD_TEXT_FONT, db.textsize, "OUTLINE")
    count:ClearAllPoints()
    count:SetPoint("TOPRIGHT", button, "TOPRIGHT", db.countx, db.county)
end

function F:InitButton(button, kind)
    buttons[button] = kind
    local icon = button.Icon
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local border = button:CreateTexture(nil, "OVERLAY", nil, 1)
    border:SetTexture(BORDER)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
    border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
    button.suiBorder = border
    if button.DebuffBorder then
        button.DebuffBorder:SetAlpha(0)
    end
    if button.TempEnchantBorder then
        button.TempEnchantBorder:SetAlpha(0)
    end

    if kind == "debuff" then
        border:SetDesaturated(true)
        self:Hook(button, "Update", colorDebuff)
    else
        SUI.Theme:Paint(border, true)
    end
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
