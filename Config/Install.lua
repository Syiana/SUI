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

    local subtitle = screen:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
    subtitle:SetScale(1.4)
    subtitle:SetPoint("CENTER", 0, 90)
    subtitle:SetText("The Dark Side of World of Warcraft")

    local author = screen:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
    author:SetScale(0.9)
    author:SetPoint("CENTER", 0, 60)
    author:SetText("created by |cff00a2ffSyiana|r")

    local start = CreateFrame("Button", nil, screen, "UIPanelButtonTemplate")
    start:SetPoint("CENTER", 0, 25)
    start:SetSize(100, 25)
    start:SetText("Start")
    start:SetScript("OnClick", function()
        SUI.db.global.installed = true
        UIFrameFade(screen, {
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
