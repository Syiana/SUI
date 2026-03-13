local Gui = SUI:NewModule("Config.Gui")

local General = SUI:GetModule("Config.Layout.General")
local Unitframes = SUI:GetModule("Config.Layout.Unitframes")
local Actionbar = SUI:GetModule("Config.Layout.Actionbar")
local Castbars = SUI:GetModule("Config.Layout.Castbars")
local Map = SUI:GetModule("Config.Layout.Map")
local Misc = SUI:GetModule("Config.Layout.Misc")
local FAQ = SUI:GetModule("Config.Layout.FAQ")
local Tooltip = SUI:GetModule("Config.Layout.Tooltip")
local Chat = SUI:GetModule("Config.Layout.Chat")
local Buffs = SUI:GetModule("Config.Layout.Buffs")
local Profiles = SUI:GetModule("Config.Layout.Profiles")
local Theme = SUI:GetModule("Config.Components.Theme")

function Gui:OnEnable()
    local SUIConfig = LibStub('SUIConfig')
    Theme:Apply()

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

    local function fadeConfig(visible, toggleMenu)
        local fadeInfo = {
            mode = visible and "IN" or "OUT",
            timeToFade = 0.2,
            finishedFunc = function()
                if visible then
                    config:Show()
                else
                    config:Hide()
                end
            end
        }

        UIFrameFade(config, fadeInfo)
        if toggleMenu then
            ToggleGameMenu()
        end
    end

    function SUI:Config(toggle)
        if toggle then
            return function()
                fadeConfig(not config:IsVisible(), true)
            end
        end

        fadeConfig(not config:IsVisible(), false)
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

    local layoutModules = {
        { title = 'General', module = General },
        { title = 'Unitframes', module = Unitframes },
        { title = 'Actionbar', module = Actionbar },
        { title = 'Castbars', module = Castbars },
        { title = 'Tooltip', module = Tooltip },
        { title = 'Buffs', module = Buffs },
        { title = 'Map', module = Map },
        { title = 'Chat', module = Chat },
        { title = 'Misc', module = Misc },
        { title = 'Profiles', module = Profiles },
        { title = 'FAQ', module = FAQ }
    }

    local categories = {}
    for _, entry in ipairs(layoutModules) do
        categories[#categories + 1] = {
            title = entry.title,
            name = entry.title,
            layout = entry.module.layout
        }
    end

    -- Tabs
    local tabs = SUIConfig:TabPanel(config, nil, nil, categories, true, 141, 27)
    SUIConfig:GlueAcross(tabs, config, 10, -35, -10, 10)

    -- Scroll tab list
    local scrollTabs = SUIConfig:ScrollFrame(config, 160, 311, tabs.buttonContainer)
    SUIConfig:GlueTop(scrollTabs, config, 10, -35, 'LEFT')

    -- Scroll tab content
    local scrollContainer = SUIConfig:ScrollFrame(config, 515, 370, tabs.container)
    SUIConfig:GlueTop(scrollContainer, config, -10, -35, 'RIGHT')

    --Save
    local save = SUIConfig:Button(config, 160, 30, 'Save')
    SUIConfig:GlueBottom(save, config, 10, 10, 'LEFT')
    save:SetScript('OnClick', function()
        ReloadUI()
    end)

end
