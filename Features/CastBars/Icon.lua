--[[
    SUI 2.0 - Features/CastBars/Icon.lua

    Spell icons on cast bars in the "Custom" style. With icons on, the player
    bar shows its (normally hidden) icon; with icons off, target and focus bars
    hide theirs. Blizzard toggles icon visibility per cast, so the icon's own
    Show/Hide/SetShown methods are hooked. A theme-tinted border frames every
    visible icon.
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

local BORDER = [[Interface\AddOns\SUI\Media\Textures\Core\gloss.tga]]

local icons = {}   -- array of { icon, border, player }
local want = {}    -- icon -> true (force shown) | false (force hidden) | nil
local borderOf = {}
local themed = false
local inactive = {} -- icon -> true for boss bars while boss cast bars are off

local function sync(icon)
    local w = want[icon]
    if w == true and not icon:IsShown() then
        icon:Show()
    elseif w == false and icon:IsShown() then
        icon:Hide()
    end
    local border = borderOf[icon]
    if border then
        border:SetShown(themed and not inactive[icon] and icon:IsShown())
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
            local border = bar:CreateTexture(nil, "BACKGROUND", nil, -7)
            border:SetTexture(BORDER)
            border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
            border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
            border:Hide()
            SUI.Theme:Paint(border, true, 0.25)
            borderOf[icon] = border
            icons[#icons + 1] = { icon = icon, bar = bar, player = players[bar] }
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
        else
            if showIcons then
                want[icon] = nil
            else
                want[icon] = false
            end
        end
        if not inactive[icon] then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
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
        borderOf[icon]:Hide()
        if forced == true then
            icon:Hide()
        elseif forced == false then
            icon:Show()
        end
    end
end
