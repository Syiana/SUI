--[[
    SUI 2.0 - Config/Install.lua

    Welcome screen shown once per account (global.installed).
]]

local _, ns = ...
local SUI = ns.SUI

local Config = SUI.Config
local screen

local function create()
    screen = CreateFrame("Frame", nil, UIParent)
    screen:SetAllPoints(UIParent)
    screen:EnableMouse(true)
    screen:SetFrameStrata("FULLSCREEN_DIALOG")

    local bg = screen:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture([[Interface\DialogFrame\UI-DialogBox-Background]])
    bg:SetAllPoints()

    local title = screen:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
    title:SetScale(4)
    title:SetPoint("CENTER", 0, 30)
    title:SetText("Welcome to " .. SUI.brand)

    -- Unscaled holders keep the scaled texts where 1.x placed them.
    local subtitle = CreateFrame("Frame", nil, screen)
    subtitle:SetSize(250, 50)
    subtitle:SetPoint("CENTER", screen, 0, 90)
    subtitle.text = subtitle:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
    subtitle.text:SetPoint("CENTER", 0, 0)
    subtitle.text:SetText("The Dark Side of World of Warcraft")
    subtitle.text:SetScale(1.4)

    local author = CreateFrame("Frame", nil, screen)
    author:SetSize(250, 50)
    author:SetPoint("CENTER", subtitle, 0, -15)
    author.text = author:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
    author.text:SetPoint("CENTER", 0, 0)
    author.text:SetText("created by |cff00a2ffSyiana|r")
    author.text:SetScale(0.9)

    local start = CreateFrame("Button", nil, screen, "UIPanelButtonTemplate")
    start:SetPoint("CENTER", 0, 25)
    start:SetSize(100, 25)
    start:SetText("Start")
    for _, getter in ipairs({ "SetNormalTexture", "SetHighlightTexture" }) do
        start[getter](start, [[Interface\Common\bluemenu-main]])
    end
    for _, texture in ipairs({ start:GetNormalTexture(), start:GetHighlightTexture() }) do
        texture:SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
        texture:SetVertexColor(0.265, 0.320, 0.410, 1)
    end
    start:SetScript("OnClick", function()
        SUI.db.global.installed = true
        SUI:FadeFrame(screen, {
            mode = "OUT",
            timeToFade = 0.4,
            finishedFunc = function()
                screen:Hide()
                Config:Open()
            end,
        })
    end)
end

function Config:ShowInstall()
    if not screen then
        create()
    end
    screen:SetAlpha(1)
    screen:Show()
end

SUI.callbacks.RegisterCallback(Config, "Ready", function()
    if not SUI.db.global.installed then
        Config:ShowInstall()
    end
end)
