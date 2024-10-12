local Gui = SUI:NewModule("Config.Gui")

local General = SUI:GetModule("Config.Layout.General")
local Unitframes = SUI:GetModule("Config.Layout.Unitframes")
local Nameplates = SUI:GetModule("Config.Layout.Nameplates")
local Actionbar = SUI:GetModule("Config.Layout.Actionbar")
local Castbars = SUI:GetModule("Config.Layout.Castbars")
local Map = SUI:GetModule("Config.Layout.Map")
local Misc = SUI:GetModule("Config.Layout.Misc")
local FAQ = SUI:GetModule("Config.Layout.FAQ")
local Tooltip = SUI:GetModule("Config.Layout.Tooltip")
local Chat = SUI:GetModule("Config.Layout.Chat")
local Buffs = SUI:GetModule("Config.Layout.Buffs")
local Profiles = SUI:GetModule("Config.Layout.Profiles")

function Gui:OnEnable()
    local SUIConfig = LibStub('SUIConfig')
    SUIConfig.config = {
        font = {
            family    = STANDARD_TEXT_FONT,
            size      = 12,
            titleSize = 16,
            effect    = 'NONE',
            strata    = 'OVERLAY',
            color     = {
                normal   = { r = 1, g = 1, b = 1, a = 1 },
                disabled = { r = 1, g = 1, b = 1, a = 1 },
                header   = { r = 1, g = 0.9, b = 0, a = 1 },
            }
        },
        backdrop = {
            texture        = [[Interface\Buttons\WHITE8X8]],
            highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
            panel          = { r = 0.065, g = 0.065, b = 0.065, a = 0.95 },
            slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
            checkbox       = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
            dropdown       = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
            button         = { r = 0.055, g = 0.055, b = 0.055, a = 1 },
            buttonDisabled = { r = 0, g = 0.55, b = 1, a = 0.5 },
            border         = { r = 0.01, g = 0.01, b = 0.01, a = 1 },
            borderDisabled = { r = 0, g = 0.50, b = 1, a = 1 },
        },
        progressBar = {
            color = { r = 1, g = 0.9, b = 0, a = 0.5 },
        },
        highlight = {
            color = { r = 0, g = 0.55, b = 1, a = 0.5 },
            blank = { r = 0, g = 0, b = 0 }
        },
        dialog = {
            width  = 400,
            height = 100,
            button = {
                width  = 100,
                height = 20,
                margin = 5
            }
        },
        tooltip = {
            padding = 10
        }
    }

    -- Database
    local db = SUI.db

    -- Config
    local config = SUIConfig:Window(UIParent, 700, 415)
    config:SetPoint('CENTER')
    config.titlePanel:SetPoint('LEFT', 10, 0)
    config.titlePanel:SetPoint('RIGHT', -35, 0)
    config:Hide()

    local version = SUIConfig:Label(config.titlePanel, C_AddOns.GetAddOnMetadata("SUI", "version"))
    SUIConfig:GlueLeft(version, config.titlePanel, 50, 0)

    local logo = SUIConfig:Texture(config.titlePanel, 120, 35, "Interface\\AddOns\\SUI\\Media\\Textures\\Config\\Logo")
    SUIConfig:GlueAbove(logo, config, 0, -35)

    function SUI:Config(toggle)
        if (toggle) then
            return function()
                if (config:IsVisible()) then
                    local fadeInfo = {}
                    fadeInfo.mode = "OUT"
                    fadeInfo.timeToFade = 0.2
                    fadeInfo.finishedFunc = function()
                        config:Hide()
                    end
                    UIFrameFade(config, fadeInfo)
                    ToggleGameMenu()
                else
                    local fadeInfo = {}
                    fadeInfo.mode = "IN"
                    fadeInfo.timeToFade = 0.2
                    fadeInfo.finishedFunc = function()
                        config:Show()
                    end
                    UIFrameFade(config, fadeInfo)
                    ToggleGameMenu()
                end
            end
        else
            if (config:IsVisible()) then
                local fadeInfo = {}
                fadeInfo.mode = "OUT"
                fadeInfo.timeToFade = 0.2
                fadeInfo.finishedFunc = function()
                    config:Hide()
                end
                UIFrameFade(config, fadeInfo)
            else
                local fadeInfo = {}
                fadeInfo.mode = "IN"
                fadeInfo.timeToFade = 0.2
                fadeInfo.finishedFunc = function()
                    config:Show()
                end
                UIFrameFade(config, fadeInfo)
            end
        end
    end

    -- GameMenu
    if db.profile.misc.menubutton then
        local function SUIGameMenuButton(self)
            self:AddSection();
            self:AddButton("|cffea00ffS|r|cff00a2ffUI|r", SUI:Config(true))
        end

        hooksecurefunc(GameMenuFrame, "InitButtons", SUIGameMenuButton)
    end

    -- Minimap AddOns Option
    _G.SUI_Options = function()
        SUI:Config()
     end

    --Options
    local options = {
        General = General.layout,
        Unitframes = Unitframes.layout,
        Nameplates = Nameplates.layout,
        Actionbar = Actionbar.layout,
        Castbars = Castbars.layout,
        Tooltip = Tooltip.layout,
        Buffs = Buffs.layout,
        Map = Map.layout,
        Chat = Chat.layout,
        Misc = Misc.layout,
        Profiles = Profiles.layout,
        FAQ = FAQ.layout
    }

    --Categories
    local categories = {
        { title = 'General', name = 'General', layout = options['General'] },
        { title = 'Unitframes', name = 'Unitframes', layout = options['Unitframes'] },
        { title = 'Nameplates', name = 'Nameplates', layout = options['Nameplates'] },
        { title = 'Actionbar', name = 'Actionbar', layout = options['Actionbar'] },
        { title = 'Castbars', name = 'Castbars', layout = options['Castbars'] },
        { title = 'Tooltip', name = 'Tooltip', layout = options['Tooltip'] },
        { title = 'Buffs', name = 'Buffs', layout = options['Buffs'] },
        { title = 'Map', name = 'Map', layout = options['Map'] },
        { title = 'Chat', name = 'Chat', layout = options['Chat'] },
        { title = 'Misc', name = 'Misc', layout = options['Misc'] },
        { title = 'Profiles', name = 'Profiles', layout = options['Profiles'] },
        { title = 'FAQ', name = 'FAQ', layout = options['FAQ'] }
    }

    -- Tabs
    local tabs = SUIConfig:TabPanel(config, nil, nil, categories, true, 160, 27)
    SUIConfig:GlueAcross(tabs, config, 10, -35, -10, 10)

    --local scrollContainer = SUIConfig:Panel(config, 515, 370, tabs.container)
    --SUIConfig:GlueTop(scrollContainer, config, -10, -35, 'RIGHT')

    -- SCROLL FRAMES BUGGY
    local scrollTabs = SUIConfig:ScrollFrame(config,  160, 315, tabs.buttonContainer)
    SUIConfig:GlueTop(scrollTabs, config, 10, -35, 'LEFT')

    local scrollContainer = SUIConfig:ScrollFrame(config, 515, 370, tabs.container)
    SUIConfig:GlueTop(scrollContainer, config, -10, -35, 'RIGHT')

    --Save
    local save = SUIConfig:Button(config, 160, 30, 'Save')
    SUIConfig:GlueBottom(save, config, 10, 10, 'LEFT')
    save:SetScript('OnClick', function()
        ReloadUI()
    end)
end
