--[[
    SUI 2.0 - Features/CastBars/Icon.lua

    Spell icons on cast bars in the "Custom" style. With icons on, the player
    bar shows its (normally hidden) icon; with icons off, target, focus and boss bars
    hide theirs while that unit's custom castbar is on (as in SUI 1.x). Blizzard toggles icon visibility per cast, so the icon's own
    Show/Hide/SetShown methods are hooked. With a tinting theme every visible
    icon gets the SUI 1.x frame: a gloss edge and an outer shadow in the
    theme colour.
]]

local _, ns = ...
local SUI = ns.SUI
local CB = ns.CastBars

local F = SUI:NewFeature("CastBars.Icon", {
    category = "castbars",
    toggle = function(db)
        return db.style == "Custom"
    end,
    watch = { "general" },
})

local GLOSS = [[Interface\AddOns\SUI\Media\Textures\Core\gloss]]
local SHADOW = {
    edgeFile = [[Interface\AddOns\SUI\Media\Textures\Core\outer_shadow]],
    edgeSize = 4,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

local icons = {}   -- array of { icon, bar, player }
local want = {}    -- icon -> true (force shown) | false (force hidden) | nil
local glossOf = {}  -- icon -> frame holding the gloss edge
local shadowOf = {} -- icon -> BackdropTemplate frame with the outer shadow
local themed = false
local inactive = {} -- icon -> true for boss bars while boss cast bars are off

local function sync(icon)
    local w = want[icon]
    if w == true and not icon:IsShown() then
        icon:Show()
    elseif w == false and icon:IsShown() then
        icon:Hide()
    end
    local gloss = glossOf[icon]
    if gloss then
        local show = themed and not inactive[icon] and icon:IsShown()
        gloss:SetShown(show)
        shadowOf[icon]:SetShown(show)
    end
end

function F:OnLoad()
    local bars = CB.AllBars()
    local players = {}
    local list = CB.PlayerBars()
    for i = 1, #list do
        players[list[i]] = true
    end
    for i = 1, #bars do
        local bar = bars[i]
        local icon = bar.Icon
        if icon then
            -- SUI 1.x icon frame (Modules/CastBars/_Icon.lua).
            local gloss = CreateFrame("Frame", nil, bar)
            local edge = gloss:CreateTexture(nil, "BACKGROUND", nil, -7)
            edge:SetTexture(GLOSS)
            edge:SetTexCoord(0, 1, 0, 1)
            edge:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
            edge:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
            gloss:Hide()

            local shadow = CreateFrame("Frame", nil, bar, "BackdropTemplate")
            shadow:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
            shadow:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
            shadow:SetFrameLevel(math.max(gloss:GetFrameLevel() - 1, 0))
            shadow:SetBackdrop(SHADOW)
            SUI:ProtectBackdrop(shadow)
            shadow:SetAlpha(0.9)
            shadow:Hide()

            glossOf[icon], shadowOf[icon] = gloss, shadow
            local unitKey
            if bar == TargetFrameSpellBar then
                unitKey = "targetCastbar"
            elseif bar == FocusFrameSpellBar then
                unitKey = "focusCastbar"
            elseif CB.boss[bar] then
                unitKey = "bossCastbar"
            end
            icons[#icons + 1] = { icon = icon, bar = bar, player = players[bar], unitKey = unitKey }
            self:Hook(icon, "Show", sync)
            self:Hook(icon, "Hide", sync)
            self:Hook(icon, "SetShown", sync)
            if bar.SetLook then
                -- SetLook resets the icon size of the player bar.
                self:Hook(bar, "SetLook", function()
                    F:Apply()
                end)
            end
        end
    end
end

function F:Apply()
    local showIcons = self.db.icon
    themed = SUI.db.profile.general.theme ~= "Blizzard"
    local r, g, b = SUI.Theme:Color(0.25)
    for i = 1, #icons do
        local entry = icons[i]
        local icon = entry.icon
        inactive[icon] = not CB.Active(entry.bar, self.db) or nil
        if inactive[icon] then
            want[icon] = nil
            icon:SetTexCoord(0, 1, 0, 1)
        elseif entry.player then
            want[icon] = showIcons or nil
            if showIcons then
                icon:SetSize(20, 20)
            end
        elseif not showIcons and entry.unitKey and self.db[entry.unitKey] then
            want[icon] = false
        else
            want[icon] = nil
        end
        if not inactive[icon] then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
        shadowOf[icon]:SetBackdropBorderColor(r, g, b)
        sync(icon)
    end
end

function F:OnEnable()
    self:Apply()
end

function F:OnRefresh()
    self:Apply()
end

function F:OnThemeChanged()
    self:Apply()
end

function F:OnDisable()
    themed = false
    for i = 1, #icons do
        local entry = icons[i]
        local icon = entry.icon
        local forced = want[icon]
        want[icon] = nil
        icon:SetTexCoord(0, 1, 0, 1)
        glossOf[icon]:Hide()
        shadowOf[icon]:Hide()
        if forced == true then
            icon:Hide()
        elseif forced == false then
            icon:Show()
        end
    end
end
