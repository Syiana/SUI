--[[
    SUI 2.0 - Features/ActionBars/Style.lua

    The SUI action button look: button borders and the main bar art tinted
    with the theme, icons cropped. Runs only with a tinting theme; SUI.Theme
    repaints the textures on theme changes by itself. Masque owns the look
    when it is loaded.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local _G = _G

local F = SUI:NewFeature("ActionBars.Style", {
    category = "actionbar",
    toggle = function()
        return SUI.db.profile.general.theme ~= "Blizzard"
    end,
    watch = { "general" },
    conflicts = { "Masque" },
    reload = true,
})

-- Bar art. Paths that do not exist on a client are skipped.
local ART = {
    -- Retail
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

local function styleButton(button, moveCooldown)
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
    if moveCooldown and cooldown then
        cooldown:ClearAllPoints()
        cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2.5)
        cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)
    end
end

function F:Apply()
    -- The cooldown inset matches the retail button art only.
    local retailArt = SUI.IsRetail
    for b = 1, #AB.bars do
        local bar = AB.bars[b]
        local buttons = AB.Buttons(bar)
        for i = 1, #buttons do
            styleButton(buttons[i], retailArt and bar.action)
        end
    end
    local addon = AB.AddonButtons()
    for i = 1, #addon do
        styleButton(addon[i], false)
    end

    SUI.Skin:Apply(ART, true)
    local main = MainActionBar
    if main then
        self:PaintPageText()
        -- Retail bar background pieces live on unnamed children.
        local children = { main:GetChildren() }
        for i = 1, #children do
            local child = children[i]
            SUI.Skin:Texture(child.TopEdge, true)
            SUI.Skin:Texture(child.BottomEdge, true)
            SUI.Skin:Texture(child.Center, true)
        end
    end
end

-- A FontString, which SUI.Theme:Paint cannot repaint (no SetDesaturated).
function F:PaintPageText()
    local page = MainActionBar and MainActionBar.ActionBarPageNumber
    if page and page.Text then
        page.Text:SetVertexColor(SUI.Theme:Color(0.15))
    end
end

function F:OnThemeChanged()
    self:PaintPageText()
end

function F:OnEnable()
    SUI:RunAfterCombat(function()
        F:Apply()
    end)
end
