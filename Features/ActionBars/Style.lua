--[[
    SUI 2.0 - Features/ActionBars/Style.lua

    The SUI 1.x action button look (Modules/ActionBars/_Buttons.lua) and bar
    art tint (Modules/Skins/Blizzard/_actionbar.lua). Buttons: border tinted
    with the theme, icon cropped, cooldown inset, Bartender4 border sizes.
    Masque keeps the buttons it skins: the main bar with MasqueBlizzBars,
    Bartender4/Dominos buttons with Masque. The bar art is a separate feature
    so it is tinted regardless of other add-ons. Both run only with a tinting
    theme; SUI.Theme repaints the textures on theme changes.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local _G = _G
local IsAddOnLoaded = SUI.Compat.IsAddOnLoaded

local function themed()
    return SUI.db.profile.general.theme ~= "Blizzard"
end

-- Buttons -----------------------------------------------------------------------------
local F = SUI:NewFeature("ActionBars.Style", {
    category = "actionbar",
    toggle = themed,
    watch = { "general" },
    reload = true,
})

-- bartender: Bartender4 loaded; small: Bartender4 pet/stance button (1.x "Pet"/"Stance").
local function styleButton(button, bartender, small)
    local normal = button:GetNormalTexture()
    SUI.Skin:Texture(normal, true)
    local name = button:GetName()
    if name then
        SUI.Skin:Texture(_G[name .. "NormalTexture2"], true) -- classic pet/stance buttons
    end
    local icon = AB.Region(button, "icon", "Icon")
    if icon then
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
    local cooldown = AB.Region(button, "cooldown", "Cooldown")
    if cooldown then
        cooldown:ClearAllPoints()
        cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2.5)
        cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    end
    if bartender and normal then
        local width, height = button:GetSize()
        if small then
            normal:SetSize(width + 2, height + 1)
        else
            normal:SetTexCoord(0, 1, 0, 1)
            normal:SetSize(width + 6, height + 5)
        end
    end
end

function F:Apply()
    local masque = IsAddOnLoaded("Masque")
    local bartender = IsAddOnLoaded("Bartender4")
    local skipMain = masque and IsAddOnLoaded("MasqueBlizzBars")
    for b = 1, #AB.bars do
        local bar = AB.bars[b]
        if not (skipMain and bar.key == "bar1") then
            local buttons = AB.Buttons(bar)
            for i = 1, #buttons do
                styleButton(buttons[i], bartender, false)
            end
        end
    end
    if not masque then
        local addon = AB.AddonButtons()
        for i = 1, #addon do
            local button = addon[i]
            local name = button:GetName() or ""
            local small = name:find("^BT4PetButton") or name:find("^BT4StanceButton")
            styleButton(button, bartender, small ~= nil)
        end
    end
end

function F:OnEnable()
    SUI:RunAfterCombat(function()
        F:Apply()
    end)
end

-- Bar art -----------------------------------------------------------------------------
local Art = SUI:NewFeature("ActionBars.BarArt", {
    category = "actionbar",
    toggle = themed,
    watch = { "general" },
})

-- Paths that do not exist on a client are skipped.
local ART = {
    -- Retail (1.x Skins/Blizzard/_actionbar.lua)
    "MainActionBar", "MainActionBar.EndCaps",
    "MainActionBar.ActionBarPageNumber.UpButton", "MainActionBar.ActionBarPageNumber.DownButton",
    "MainMenuBar.EndCaps",
    "StatusTrackingBarManager", "StatusTrackingBarManager.BottomBarFrameTexture",
    "StatusTrackingBarManager.MainStatusTrackingBarContainer",
    "StatusTrackingBarManager.SecondaryStatusTrackingBarContainer",
    -- Classic
    "MainMenuBarArtFrame", "MainMenuBarArtFrameBackground",
    "MainMenuBarLeftEndCap", "MainMenuBarRightEndCap",
    "MainMenuBarTexture0", "MainMenuBarTexture1", "MainMenuBarTexture2", "MainMenuBarTexture3",
    "MainMenuMaxLevelBar0", "MainMenuMaxLevelBar1", "MainMenuMaxLevelBar2", "MainMenuMaxLevelBar3",
    "MainMenuXPBarTexture0", "MainMenuXPBarTexture1", "MainMenuXPBarTexture2", "MainMenuXPBarTexture3",
}

-- A FontString, which SUI.Theme:Paint cannot repaint (no SetDesaturated).
local function paintPageText()
    local page = MainActionBar and MainActionBar.ActionBarPageNumber
    if page and page.Text then
        if SUI.Theme.enabled then
            page.Text:SetVertexColor(SUI.Theme:Color(0.15))
        else
            page.Text:SetVertexColor(1, 1, 1)
        end
    end
end

function Art:OnEnable()
    SUI.Skin:Apply(ART, true)
    paintPageText()
    local main = MainActionBar
    if main then
        -- Retail bar background pieces live on unnamed children (1.x _Buttons.lua).
        local children = { main:GetChildren() }
        for i = 1, #children do
            local child = children[i]
            SUI.Skin:Texture(child.TopEdge, true)
            SUI.Skin:Texture(child.BottomEdge, true)
            SUI.Skin:Texture(child.Center, true)
        end
    end
end

function Art:OnThemeChanged()
    paintPageText()
end

function Art:OnDisable()
    paintPageText()
end
