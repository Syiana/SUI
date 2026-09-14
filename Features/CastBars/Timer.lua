--[[
    SUI 2.0 - Features/CastBars/Timer.lua

    Remaining cast time next to the player, target and focus cast bars. The
    cast bar's own OnUpdate only runs while it is shown, so the hook costs
    nothing between casts; it is throttled and only writes the text when the
    shown tenth of a second changes. Secret values (Midnight) leave it empty.
]]

local _, ns = ...
local SUI = ns.SUI
local CB = ns.CastBars

local floor = math.floor
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("CastBars.Timer", {
    category = "castbars",
    toggle = "timer",
})

local INTERVAL = 0.05

local texts = {}   -- bar -> FontString
local elapsedOf = {}
local shown = {}   -- bar -> tenths currently displayed, -1 = empty

local function clear(bar)
    if shown[bar] ~= -1 then
        shown[bar] = -1
        texts[bar]:SetText("")
    end
end

local function onUpdate(bar, elapsed)
    local acc = elapsedOf[bar] + elapsed
    if acc < INTERVAL then
        elapsedOf[bar] = acc
        return
    end
    elapsedOf[bar] = 0

    local casting, channeling = bar.casting, bar.channeling
    if (not casting and not channeling) or not CB.Active(bar, F.db) then
        return clear(bar)
    end
    local value = bar:GetValue()
    local _, maxValue = bar:GetMinMaxValues()
    if not CanAccess(value) or not CanAccess(maxValue) or not maxValue then
        return clear(bar)
    end
    local remaining = value
    if casting or bar.reverseChanneling then
        remaining = maxValue - value
    end
    local tenths = floor(remaining * 10 + 0.5)
    if tenths < 0 then
        tenths = 0
    end
    if shown[bar] ~= tenths then
        shown[bar] = tenths
        texts[bar]:SetFormattedText("%.1f", tenths / 10)
    end
end

function F:OnLoad()
    local players = {}
    local list = CB.PlayerBars()
    for i = 1, #list do
        players[list[i]] = true
    end
    local bars = CB.AllBars()
    for i = 1, #bars do
        local bar = bars[i]
        local text = bar:CreateFontString(nil, "OVERLAY")
        if players[bar] then
            text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
            text:SetPoint("LEFT", bar, "RIGHT", 5, 0)
        else
            text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            text:SetPoint("LEFT", bar, "RIGHT", 4, 0)
        end
        text:Hide()
        texts[bar] = text
        elapsedOf[bar] = 0
        shown[bar] = -1
        self:HookScript(bar, "OnUpdate", onUpdate)
    end
end

function F:OnEnable()
    for bar, text in pairs(texts) do
        shown[bar] = -1
        text:SetText("")
        text:Show()
    end
end

function F:OnDisable()
    for _, text in pairs(texts) do
        text:Hide()
    end
end
