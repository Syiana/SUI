--[[
    SUI 2.0 - Features/CastBars/Texture.lua

    Replaces the cast bar fill with a SharedMedia statusbar texture. Retail
    swaps the fill atlas per cast type, so SetStatusBarTexture is hooked and
    the chosen texture put back, coloured by the bar type (Blizzard's atlases
    carry the colour, a flat texture does not).
]]

local _, ns = ...
local SUI = ns.SUI
local CB = ns.CastBars

local F = SUI:NewFeature("CastBars.Texture", {
    category = "castbars",
    toggle = "texture", -- "Disabled" = Blizzard texture
    reload = true,
})

-- Retail bar types -> colour
local TYPE_R = { standard = 1, channel = 0, uninterruptable = 0.7, interrupted = 1, empowered = 1 }
local TYPE_G = { standard = 0.7, channel = 1, uninterruptable = 0.7, interrupted = 0, empowered = 0.7 }
local TYPE_B = { standard = 0, channel = 0, uninterruptable = 0.7, interrupted = 0, empowered = 0 }

local applying = false

local function apply(bar)
    if applying then
        return
    end
    applying = true
    bar:SetStatusBarTexture(F.db.texture)
    local barType = bar.barType
    if barType and TYPE_R[barType] then
        bar:SetStatusBarColor(TYPE_R[barType], TYPE_G[barType], TYPE_B[barType])
    end
    applying = false
end

function F:OnLoad()
    self.bars = CB.AllBars()
    for i = 1, #self.bars do
        self:Hook(self.bars[i], "SetStatusBarTexture", apply)
    end
end

function F:OnEnable()
    for i = 1, #self.bars do
        apply(self.bars[i])
    end
end

function F:OnRefresh(key)
    if key == "texture" then
        self:OnEnable()
    end
end
