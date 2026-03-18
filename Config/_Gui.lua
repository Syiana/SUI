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
    local util = SUIConfig.Util
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
    SUIConfig:GlueLeft(version, config.titlePanel, 36, 0)

    local logo = SUIConfig:Texture(config.titlePanel, 120, 35, "Interface\\AddOns\\SUI\\Media\\Textures\\Config\\Logo")
    SUIConfig:GlueAbove(logo, config, 0, -35)

    local searchBox
    local clearSearchButton
    local isClearingSearch = false
    local refreshSearchResults
    local syncOriginalElement

    local function normalizeSearchText(text)
        return ((text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""))
    end

    local function cloneConfigElement(element)
        local copy = {}
        for key, value in pairs(element) do
            copy[key] = value
        end
        copy.column = 12
        copy.order = 1
        return copy
    end

    local function getDatabaseValue(dbRef, key)
        if not dbRef or not key then
            return nil
        end

        local startPos = dbRef
        for subKey in string.gmatch(key, "[^%.]+") do
            if type(startPos) ~= "table" then
                return nil
            end
            startPos = startPos[subKey]
            if startPos == nil then
                return nil
            end
        end

        return startPos
    end

    local function setDatabaseValue(dbRef, key, value)
        if not dbRef or not key then
            return
        end

        local accessor = {}
        for subKey in string.gmatch(key, "[^%.]+") do
            accessor[#accessor + 1] = subKey
        end

        if #accessor == 0 then
            return
        end

        local startPos = dbRef
        for index = 1, #accessor - 1 do
            local subKey = accessor[index]
            if type(startPos[subKey]) ~= "table" then
                startPos[subKey] = {}
            end
            startPos = startPos[subKey]
        end

        startPos[accessor[#accessor]] = value
    end

    local function getWidgetValue(_, value)
        return value
    end

    local searchableTypes = {
        checkbox = true,
        dropdown = true,
        slider = true,
        sliderWithBox = true,
        editBox = true
    }

    local function fadeConfig(visible, toggleMenu)
        if not visible and searchBox then
            isClearingSearch = true
            searchBox:SetText('')
            isClearingSearch = false
            if refreshSearchResults then
                refreshSearchResults('')
            end
        end

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

    config.closeBtn:SetScript('OnClick', function()
        fadeConfig(false, false)
    end)

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

    local categoryLookup = {}
    for _, category in ipairs(categories) do
        categoryLookup[category.name] = category
    end

    local searchCategory = {
        title = 'Search',
        name = 'Search',
        hiddenButton = true
    }

    local function buildSearchLayout(query)
        local rows = {}
        local normalizedQuery = normalizeSearchText(query)
        local resultCount = 0

        if normalizedQuery == "" then
            rows[#rows + 1] = {
                info = {
                    type = 'label',
                    label = 'Type above to search the config.'
                },
            }
        else
            for _, entry in ipairs(layoutModules) do
                local layout = entry.module.layout
                local sectionLabel

                if layout and layout.rows then
                    for _, row in ipairs(layout.rows) do
                        for rowKey, element in util.orderedPairs(row) do
                            if type(element) == 'table' then
                                if element.type == 'header' then
                                    sectionLabel = element.label
                                elseif searchableTypes[element.type] and element.label then
                                    local labelText = normalizeSearchText(element.label)
                                    local isMatch = labelText ~= "" and labelText:find(normalizedQuery, 1, true)

                                    if isMatch then
                                        rows[#rows + 1] = {
                                            category = {
                                                type = 'label',
                                                label = entry.title
                                            },
                                        }

                                        rows[#rows + 1] = {
                                            result = (function()
                                                local resultElement = cloneConfigElement(element)
                                                local sourceDb = layout.database
                                                local sourceKey = element.key or rowKey

                                                resultElement.initialValue = getDatabaseValue(sourceDb, sourceKey)
                                                resultElement.onValueChanged = function(widget, value)
                                                    local newValue = getWidgetValue(widget, value)
                                                    setDatabaseValue(sourceDb, sourceKey, newValue)
                                                    if syncOriginalElement then
                                                        syncOriginalElement(entry.title, rowKey, newValue)
                                                    end
                                                    if element.onChange then
                                                        element.onChange(newValue)
                                                    end
                                                end

                                                return resultElement
                                            end)()
                                        }
                                        resultCount = resultCount + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if resultCount == 0 then
                rows[#rows + 1] = {
                    info = {
                        type = 'label',
                        label = 'No matching settings found.'
                    },
                }
            end
        end

        return {
            layoutConfig = { padding = { top = 15 } },
            rows = rows
        }
    end

    local function buildTabs(query)
        if normalizeSearchText(query) == "" then
            return categories
        end

        searchCategory.layout = buildSearchLayout(query)

        local tabsWithSearch = {
            searchCategory
        }

        for _, category in ipairs(categories) do
            tabsWithSearch[#tabsWithSearch + 1] = category
        end

        return tabsWithSearch
    end

    -- Tabs
    local tabs = SUIConfig:TabPanel(config, nil, nil, categories, true, 141, 26)
    SUIConfig:GlueAcross(tabs, config, 10, -35, -10, 10)

    local lastSelectedTab = categories[1] and categories[1].name or nil

    syncOriginalElement = function(tabName, rowKey, value)
        local category = categoryLookup[tabName]
        if not category or not category.frame or not category.frame.elements then
            return
        end

        local widget = category.frame.elements[rowKey]
        if not widget then
            return
        end

        if widget.SetChecked then
            widget:SetChecked(value, true)
        elseif widget.SetValue then
            widget:SetValue(value)
        end
    end

    refreshSearchResults = function(query)
        if clearSearchButton then
            if normalizeSearchText(query) ~= "" then
                clearSearchButton:Show()
            else
                clearSearchButton:Hide()
            end
        end

        local selectedTab = tabs:GetSelectedTab()
        if selectedTab and selectedTab.name ~= searchCategory.name then
            lastSelectedTab = selectedTab.name
        end

        tabs:Update(buildTabs(query))

        if normalizeSearchText(query) ~= "" then
            tabs:SelectTab(searchCategory.name)
        elseif lastSelectedTab then
            tabs:SelectTab(lastSelectedTab)
        end
    end

    searchBox = SUIConfig:SearchEditBox(config.titlePanel, 165, 20, 'Search settings')
    searchBox:SetPoint('RIGHT', config.closeBtn, 'LEFT', -4, 0)
    searchBox:SetTextInsets(3, 22, 3, 3)
    searchBox.OnValueChanged = function(self, value)
        if isClearingSearch then
            return
        end
        refreshSearchResults(value)
    end

    clearSearchButton = SUIConfig:Button(searchBox, 16, 16, 'X')
    clearSearchButton.text:SetFontSize(11)
    clearSearchButton:SetPoint('RIGHT', searchBox, 'RIGHT', -2, 0)
    clearSearchButton:Hide()
    clearSearchButton:SetScript('OnClick', function()
        isClearingSearch = true
        searchBox:SetText('')
        isClearingSearch = false
        refreshSearchResults('')
        searchBox:ClearFocus()
    end)

    local originalSelectTab = tabs.SelectTab
    tabs.SelectTab = function(self, name)
        if name ~= searchCategory.name and searchBox and normalizeSearchText(searchBox:GetText()) ~= "" then
            isClearingSearch = true
            searchBox:SetText('')
            isClearingSearch = false
            refreshSearchResults('')
        end

        return originalSelectTab(self, name)
    end

    -- Scroll tab list
    local scrollTabs = SUIConfig:ScrollFrame(config, 160, 300, tabs.buttonContainer)
    SUIConfig:GlueTop(scrollTabs, config, 10, -35, 'LEFT')

    -- Scroll tab content
    local scrollContainer = SUIConfig:ScrollFrame(config, 515, 370, tabs.container)
    SUIConfig:GlueTop(scrollContainer, config, -10, -35, 'RIGHT')

    local save = SUIConfig:Button(config, 160, 28, 'Save')
    SUIConfig:GlueBottom(save, config, 10, 10, 'LEFT')
    save:SetScript('OnClick', function()
        ReloadUI()
    end)

    local edit = SUIConfig:Button(config, 160, 28, 'Edit Mode')
    SUIConfig:GlueAbove(edit, save, 0, 6, 'LEFT')
    edit:SetScript('OnClick', function()
        fadeConfig(false, false)
        if EditModeManagerFrame then
            ShowUIPanel(EditModeManagerFrame)
        end
    end)

end
