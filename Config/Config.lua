--[[
    SUI 2.0 - Config/Config.lua

    The options window. Feature folders register their tabs:

        SUI.Config:RegisterLayout("Actionbar", {
            order = 40,
            category = "actionbar",   -- keys below are relative to this category
            rows = function() return { ... } end,
        })

    Set bind = false for tabs whose widgets do not store settings.

    Rows use the SUIConfig element format (type, key, label, column, order,
    options, min, max, step, tooltip). Extra fields understood by SUI:
        clients = { Mainline = true }  show only on these clients
        hidden  = function(info) end   hide dynamically (evaluated on build)
        reload  = true                 ask for a reload after changing
        onChange = function(value) end extra action after the setting was applied

    Every change goes through SUI:Set, which applies it to the running
    features immediately. The window is built the first time it is opened.
]]

local _, ns = ...
local SUI = ns.SUI

local SUIConfig = LibStub("SUIConfig")

local Config = { layouts = {} }
SUI.Config = Config

local WIDTH, HEIGHT = 700, 415
local window, tabs, searchBox, clearButton, reloadButton

-- Registry ----------------------------------------------------------------------
function Config:RegisterLayout(name, spec)
    spec.name = name
    spec.title = spec.title or name
    spec.order = spec.order or 500
    self.layouts[#self.layouts + 1] = spec
    table.sort(self.layouts, function(a, b)
        return a.order < b.order
    end)
    if window then
        self:RebuildTabs()
    end
end

local function prefixed(spec, key)
    return spec.category and (spec.category .. "." .. key) or key
end

local function copyValue(value)
    if type(value) == "table" then
        local copy = {}
        for k, v in pairs(value) do
            copy[k] = v
        end
        return copy
    end
    return value
end

-- Turns a registered spec into a SUIConfig window description.
local function buildLayout(spec)
    local rows = type(spec.rows) == "function" and spec.rows() or spec.rows
    if spec.bind == false then
        return { layoutConfig = { padding = { top = 15 } }, rows = rows }
    end
    return {
        layoutConfig = { padding = { top = 15 } },
        rows = rows,
        get = function(key)
            return SUI:Get(prefixed(spec, key))
        end,
        set = function(key, value, info)
            SUI:Set(prefixed(spec, key), copyValue(value))
            if info and info.reload then
                SUI:RequestReload(key)
            end
        end,
    }
end

-- Search --------------------------------------------------------------------------
local SEARCHABLE = { checkbox = true, dropdown = true, slider = true, sliderWithBox = true, editBox = true, color = true }

local function normalize(text)
    return ((text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""))
end

local function orderedPairs(t)
    return SUIConfig.Util.orderedPairs(t)
end

local function searchLayout(query)
    local rows = {}
    local q = normalize(query)
    local found = 0

    for _, spec in ipairs(Config.layouts) do
        local specRows = type(spec.rows) == "function" and spec.rows() or spec.rows
        for _, row in ipairs(specRows or {}) do
            for rowKey, element in orderedPairs(row) do
                if SEARCHABLE[element.type] and element.label and SUIConfig.IsElementVisible(SUIConfig, element) then
                    local label = normalize(element.label)
                    local tip = normalize(element.tooltip)
                    if label:find(q, 1, true) or (tip ~= "" and tip:find(q, 1, true)) then
                        found = found + 1
                        rows[#rows + 1] = { ["category" .. found] = { type = "label", label = "|cff00a2ff" .. spec.title .. "|r" } }
                        local copy = {}
                        for k, v in pairs(element) do
                            copy[k] = v
                        end
                        copy.key = prefixed(spec, element.key or rowKey)
                        copy.column = 12
                        copy.order = 1
                        rows[#rows + 1] = { ["result" .. found] = copy }
                    end
                end
            end
        end
    end

    if found == 0 then
        rows[1] = { info = { type = "label", label = "No matching settings found." } }
    end

    return {
        layoutConfig = { padding = { top = 15 } },
        rows = rows,
        get = function(key)
            return SUI:Get(key)
        end,
        set = function(key, value, info)
            SUI:Set(key, copyValue(value))
            if info and info.reload then
                SUI:RequestReload(key)
            end
            -- Tabs showing the same option are rebuilt on next open.
            for _, tab in ipairs(tabs.tabs) do
                tab.builtLayout = nil
            end
        end,
    }
end

-- Window --------------------------------------------------------------------------
local function fade(visible)
    UIFrameFade(window, {
        mode = visible and "IN" or "OUT",
        timeToFade = 0.2,
        finishedFunc = function()
            window:SetShown(visible)
        end,
    })
end

local function tabList(query)
    local list = {}
    if normalize(query) ~= "" then
        list[1] = { name = "Search", title = "Search", hiddenButton = true, layout = searchLayout(query) }
    end
    for _, spec in ipairs(Config.layouts) do
        if SUI:SupportsClient(spec.clients) then
            list[#list + 1] = {
                name = spec.name,
                title = spec.title,
                layout = function()
                    return buildLayout(spec)
                end,
            }
        end
    end
    return list
end

function Config:RebuildTabs(query)
    local selected = tabs:GetSelectedTab()
    tabs:Update(tabList(query))
    if normalize(query) ~= "" then
        tabs:SelectTab("Search")
    elseif selected and selected.name ~= "Search" and tabs:GetTabByName(selected.name) then
        tabs:SelectTab(selected.name)
    elseif tabs.tabs[1] then
        tabs:SelectTab(tabs.tabs[1].name)
    end
end

local function create()
    window = SUIConfig:Window(UIParent, WIDTH, HEIGHT)
    window:SetPoint("CENTER")
    window:SetFrameStrata("HIGH")
    window.titlePanel:SetPoint("LEFT", 10, 0)
    window.titlePanel:SetPoint("RIGHT", -35, 0)
    window:Hide()
    _G.SUIConfigWindow = window -- UISpecialFrames needs a global name for Escape to close it
    tinsert(UISpecialFrames, "SUIConfigWindow")

    local version = SUIConfig:Label(window.titlePanel, SUI.version)
    SUIConfig:GlueLeft(version, window.titlePanel, 36, 0)

    local logo = SUIConfig:Texture(window.titlePanel, 120, 35, SUI.Media.logo)
    SUIConfig:GlueAbove(logo, window, 0, -35)

    window.closeBtn:SetScript("OnClick", function()
        fade(false)
    end)

    tabs = SUIConfig:TabPanel(window, nil, nil, tabList(), true, 141, 26)
    SUIConfig:GlueAcross(tabs, window, 10, -35, -10, 10)

    local scrollTabs = SUIConfig:ScrollFrame(window, 160, 300, tabs.buttonContainer)
    SUIConfig:GlueTop(scrollTabs, window, 10, -35, "LEFT")

    local scrollContent = SUIConfig:ScrollFrame(window, 515, 370, tabs.container)
    SUIConfig:GlueTop(scrollContent, window, -10, -35, "RIGHT")

    -- Search
    searchBox = SUIConfig:SearchEditBox(window.titlePanel, 165, 20, "Search settings")
    searchBox:SetPoint("RIGHT", window.closeBtn, "LEFT", -4, 0)
    searchBox:SetTextInsets(3, 22, 3, 3)
    searchBox.OnValueChanged = function(_, value)
        clearButton:SetShown(normalize(value) ~= "")
        Config:RebuildTabs(value)
    end

    clearButton = SUIConfig:Button(searchBox, 16, 16, "X")
    clearButton.text:SetFontSize(11)
    clearButton:SetPoint("RIGHT", searchBox, "RIGHT", -2, 0)
    clearButton:Hide()
    clearButton:SetScript("OnClick", function()
        searchBox:SetText("")
        searchBox:ClearFocus()
    end)

    -- Bottom buttons: settings apply live, reloading is only needed for a
    -- few options, so the button lights up when that is the case.
    reloadButton = SUIConfig:Button(window, 160, 28, "Reload UI")
    SUIConfig:GlueBottom(reloadButton, window, 10, 10, "LEFT")
    reloadButton:SetScript("OnClick", ReloadUI)

    local edit = SUIConfig:Button(window, 160, 28, SUI.HasEditMode and "Edit Mode" or "Move Frames")
    SUIConfig:GlueAbove(edit, reloadButton, 0, 6, "LEFT")
    edit:SetScript("OnClick", function()
        fade(false)
        SUI.Movers:Toggle()
    end)

    Config:UpdateReloadButton()
end

function Config:UpdateReloadButton()
    if not reloadButton then
        return
    end
    if SUI.reloadPending then
        reloadButton.text:SetTextColor(1, 0.9, 0)
        reloadButton:SetText("Reload UI *")
    else
        reloadButton.text:SetTextColor(1, 1, 1)
        reloadButton:SetText("Reload UI")
    end
end

SUI.callbacks.RegisterCallback(Config, "ReloadRequested", function()
    Config:UpdateReloadButton()
end)

SUI.callbacks.RegisterCallback(Config, "ProfileChanged", function()
    if tabs then
        for _, tab in ipairs(tabs.tabs) do
            tab.builtLayout = nil
        end
        Config:RebuildTabs(searchBox and searchBox:GetText())
    end
end)

-- Public API ------------------------------------------------------------------------
function Config:Toggle()
    if InCombatLockdown() then
        SUI:Print("The options open after combat.")
        SUI:RunAfterCombat(function()
            Config:Toggle()
        end)
        return
    end
    if not window then
        create()
    end
    fade(not window:IsShown())
end

-- Opens a tab by (case insensitive) name.
function Config:Open(name)
    if not window then
        create()
    end
    if name then
        name = name:lower()
        for _, tab in ipairs(tabs.tabs) do
            if tab.name:lower() == name then
                tabs:SelectTab(tab.name)
                break
            end
        end
    end
    if not window:IsShown() then
        fade(true)
    end
end

function Config:Close()
    if window and window:IsShown() then
        fade(false)
    end
end

function Config:IsShown()
    return window ~= nil and window:IsShown()
end
