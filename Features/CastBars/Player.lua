--[[
    SUI 2.0 - Features/CastBars/Player.lua

    The "Custom" player cast bar: larger bar without the text frame and glow,
    outlined spell name, background tinted with the theme. Styled once and
    re-applied only when Blizzard changes the look (SetLook) or the size.
]]

local _, ns = ...
local SUI = ns.SUI
local CB = ns.CastBars

local abs = math.abs

local F = SUI:NewFeature("CastBars.Player", {
    category = "castbars",
    toggle = function(db)
        return db.style == "Custom"
    end,
    reload = true,
})

local WIDTH, HEIGHT = 209, 18

local function hideRegion(region)
    region:Hide()
end

local function style(bar)
    local text = bar.Text
    if bar.TextBorder then
        -- Retail art
        if abs(bar:GetWidth() - WIDTH) > 0.5 or abs(bar:GetHeight() - HEIGHT) > 0.5 then
            bar:SetSize(WIDTH, HEIGHT)
        end
        bar.TextBorder:SetAlpha(0)
        if bar.Border then
            bar.Border:SetAlpha(0)
        end
        if bar.StandardGlow then
            bar.StandardGlow:Hide()
        end
        if text then
            text:ClearAllPoints()
            text:SetPoint("TOP", bar, "TOP", 0, -1)
        end
    end
    CB.TintBar(bar)
    if text then
        text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    end
end

local function onShow(bar)
    if bar.TextBorder and abs(bar:GetWidth() - WIDTH) > 0.5 then
        style(bar)
    end
end

function F:OnLoad()
    self.bars = CB.PlayerBars()
    for i = 1, #self.bars do
        local bar = self.bars[i]
        if bar.SetLook then
            self:Hook(bar, "SetLook", style)
        end
        if bar.StandardGlow then
            self:Hook(bar.StandardGlow, "Show", hideRegion)
        end
        self:HookScript(bar, "OnShow", onShow)
    end
end

function F:OnEnable()
    for i = 1, #self.bars do
        style(self.bars[i])
    end
end

function F:OnThemeChanged()
    for i = 1, #self.bars do
        CB.TintBar(self.bars[i])
    end
end
