--[[
    SUI 2.0 - Config/Config.lua

    The options window. Feature folders register their tabs:

        SUI.Config:RegisterLayout("Actionbar", {
            group = "interface",       -- sidebar group (interface, units, social, system)
            order = 40,                -- position inside the group
            category = "actionbar",    -- keys below are relative to this category
            rows = function() return { ... } end,
        })

    Set bind = false for tabs whose widgets do not store settings, and
    reset = false to hide the "reset this tab" button.

    Rows use the SUIConfig element format (type, key, label, column, order,
    options, min, max, step, tooltip). Extra fields understood by SUI:
        clients = { Mainline = true }  show only on these clients
        hidden  = function(info) end   hide dynamically; re-evaluated whenever
                                       an element with rebuild = true changes
        rebuild = true                 rebuild the tab after changing (use on
                                       options that other rows depend on)
        reload  = true                 ask for a reload after changing
        onChange = function(self, value) end  extra action after applying

    Every change goes through SUI:Set, which applies it to the running
    features immediately. The window is built the first time it is opened and
    each tab is built the first time it is shown.
]]

local _, ns = ...
local SUI = ns.SUI

local SUIConfig = LibStub("SUIConfig")

local Config = { layouts = {} }
SUI.Config = Config

-- Window geometry. Everything else is derived from these values, so the
-- sidebar, content area and buttons grow with the window.
local WIDTH, HEIGHT = 900, 580
local MARGIN, TOP, GAP = 10, 35, 5
local SIDEBAR = 190                  -- sidebar and bottom button width
local TAB_HEIGHT, BUTTON_HEIGHT = 28, 28
local SCROLLBAR = 19                 -- room the sidebar scrollbar takes
local BOTTOM = MARGIN + 2 * BUTTON_HEIGHT + 6 + 8

-- Sidebar order of the layout groups (no captions are shown).
local groupOrder = { interface = 1, units = 2, social = 3, system = 4 }

local window, tabs, searchBox, clearButton, reloadButton, scrollContent

-- Registry ----------------------------------------------------------------------
local function sortLayouts(a, b)
    local ga, gb = groupOrder[a.group] or 99, groupOrder[b.group] or 99
    if ga ~= gb then
        return ga < gb
    end
    return a.order < b.order
end

function Config:RegisterLayout(name, spec)
    spec.name = name
    spec.title = spec.title or name
    spec.order = spec.order or 500
    spec.group = spec.group or "interface"
    self.layouts[#self.layouts + 1] = spec
    table.sort(self.layouts, sortLayouts)
    if window then
        self:RebuildTabs(searchBox and searchBox:GetText())
    end
end

function Config:GetLayout(name)
    for _, spec in ipairs(self.layouts) do
        if spec.name == name then
            return spec
        end
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

local function confirm(title, message, onConfirm)
    SUIConfig:Confirm(title, message, {
        ok = {
            text = "Confirm",
            onClick = function(self)
                self:GetParent():Hide()
                onConfirm()
            end,
        },
        cancel = {
            text = "Cancel",
            onClick = function(self)
                self:GetParent():Hide()
            end,
        },
    })
end

-- Rebuilds the visible tab after the current widget callback has returned.
local rebuildQueued = false
local function queueRebuild()
    if rebuildQueued then
        return
    end
    rebuildQueued = true
    C_Timer.After(0, function()
        rebuildQueued = false
        Config:RebuildCurrent()
    end)
end

local function applySetting(path, value, info)
    SUI:Set(path, copyValue(value))
    if info and info.reload then
        SUI:RequestReload(path)
    end
    if info and info.rebuild then
        queueRebuild()
    end
end

-- Turns a registered spec into a SUIConfig window description.
local function buildLayout(spec)
    local rows = type(spec.rows) == "function" and spec.rows() or spec.rows or {}
    if spec.bind == false then
        return { layoutConfig = { padding = { top = 15 } }, rows = rows }
    end

    if spec.category and spec.reset ~= false and SUI:GetDefaults(spec.category) then
        rows[#rows + 1] = { resetHeader = { type = "header", label = "Reset" } }
        rows[#rows + 1] = {
            resetTab = {
                type = "button",
                text = "Reset " .. spec.title,
                column = 4,
                order = 1,
                onClick = function()
                    confirm("Reset " .. spec.title, "Reset all " .. spec.title .. " settings of this profile to their defaults?", function()
                        SUI:ResetCategory(spec.category)
                        Config:RebuildCurrent()
                    end)
                end,
            },
        }
    end

    return {
        layoutConfig = { padding = { top = 15 } },
        rows = rows,
        get = function(key)
            return SUI:Get(prefixed(spec, key))
        end,
        set = function(key, value, info)
            applySetting(prefixed(spec, key), value, info)
        end,
    }
end

-- Search --------------------------------------------------------------------------
local SEARCHABLE = { checkbox = true, dropdown = true, slider = true, sliderWithBox = true, editBox = true, color = true }

local function normalize(text)
    return ((text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""))
end

local function searchLayout(query)
    local rows = {}
    local q = normalize(query)
    local found = 0

    for _, spec in ipairs(Config.layouts) do
        if SUI:SupportsClient(spec.clients) and spec.bind ~= false then
            local specRows = type(spec.rows) == "function" and spec.rows() or spec.rows
            local section
            for _, row in ipairs(specRows or {}) do
                for rowKey, element in SUIConfig.Util.orderedPairs(row) do
                    if element.type == "header" then
                        section = element.label
                    elseif SEARCHABLE[element.type] and element.label and SUIConfig.IsElementVisible(SUIConfig, element) then
                        local label = normalize(element.label)
                        local tip = normalize(element.tooltip)
                        if label:find(q, 1, true) or (tip ~= "" and tip:find(q, 1, true)) then
                            found = found + 1
                            local where = "|cff00a2ff" .. spec.title .. "|r" .. (section and (" > " .. section) or "")
                            rows[#rows + 1] = { ["where" .. found] = { type = "label", label = where } }
                            local copy = {}
                            for k, v in pairs(element) do
                                copy[k] = v
                            end
                            copy.key = prefixed(spec, element.key or rowKey)
                            copy.rebuild = nil
                            copy.column = 12
                            copy.order = 1
                            rows[#rows + 1] = { ["result" .. found] = copy }
                        end
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
            applySetting(key, value, info)
            -- Tabs showing the same option are rebuilt when opened next.
            Config:MarkTabsDirty()
        end,
    }
end

-- Tabs ------------------------------------------------------------------------------
-- Tab entries are cached by name: SUIConfig keeps a frame per entry, so new
-- tables on every rebuild would leave the old frames behind.
local tabCache = {}

local function tabEntry(name, fields)
    local entry = tabCache[name]
    if not entry then
        entry = { name = name }
        tabCache[name] = entry
    end
    for k, v in pairs(fields) do
        entry[k] = v
    end
    return entry
end

local function tabList(query)
    local list = {}
    if normalize(query) ~= "" then
        list[1] = tabEntry("Search", { title = "Search", hiddenButton = true, layout = searchLayout(query) })
    end
    for _, spec in ipairs(Config.layouts) do
        if SUI:SupportsClient(spec.clients) then
            local entry = tabCache[spec.name]
            local generator = entry and entry.generator
            if not generator then
                generator = function()
                    return buildLayout(spec)
                end
            end
            entry = tabEntry(spec.name, { title = spec.title, generator = generator })
            if not entry.layout then
                entry.layout = generator
            end
            list[#list + 1] = entry
        end
    end
    return list
end

local function firstTab()
    for _, tab in ipairs(tabs.tabs) do
        if not tab.hiddenButton then
            return tab.name
        end
    end
end

function Config:MarkTabsDirty()
    for _, tab in pairs(tabCache) do
        if tab.generator and tab ~= tabs:GetSelectedTab() then
            tab.layout = tab.generator
        end
    end
end

function Config:RebuildTabs(query)
    local selected = tabs:GetSelectedTab()
    tabs:Update(tabList(query))
    if normalize(query) ~= "" then
        tabs:SelectTab("Search")
    elseif selected and selected.name ~= "Search" and tabs:GetTabByName(selected.name) then
        tabs:SelectTab(selected.name)
    else
        local name = firstTab()
        if name then
            tabs:SelectTab(name)
        end
    end
end

-- Rebuilds the visible tab and keeps the scroll position.
function Config:RebuildCurrent()
    if not tabs then
        return
    end
    local tab = tabs:GetSelectedTab()
    if not tab then
        return
    end
    local scroll = tonumber(scrollContent and scrollContent.scrollBar and scrollContent.scrollBar:GetValue()) or 0
    if tab.name == "Search" then
        self:RebuildTabs(searchBox:GetText())
    else
        self:MarkTabsDirty()
        tabs:RebuildTab(tab)
    end
    C_Timer.After(0, function()
        if scrollContent and scrollContent.scrollBar then
            local _, maxValue = scrollContent.scrollBar:GetMinMaxValues()
            scrollContent.scrollBar:SetValue(math.min(scroll, tonumber(maxValue) or 0))
        end
    end)
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

    local logo = SUIConfig:Texture(window.titlePanel, 150, 44, SUI.Media.logo)
    SUIConfig:GlueAbove(logo, window, 0, -35)

    window.closeBtn:SetScript("OnClick", function()
        fade(false)
    end)

    tabs = SUIConfig:TabPanel(window, nil, nil, tabList(), true, SIDEBAR - SCROLLBAR, TAB_HEIGHT)
    SUIConfig:GlueAcross(tabs, window, MARGIN, -TOP, -MARGIN, MARGIN)

    local scrollTabs = SUIConfig:ScrollFrame(window, SIDEBAR, HEIGHT - TOP - BOTTOM, tabs.buttonContainer)
    SUIConfig:GlueTop(scrollTabs, window, MARGIN, -TOP, "LEFT")

    local contentWidth = WIDTH - 2 * MARGIN - SIDEBAR - GAP
    scrollContent = SUIConfig:ScrollFrame(window, contentWidth, HEIGHT - TOP - MARGIN, tabs.container)
    SUIConfig:GlueTop(scrollContent, window, -MARGIN, -TOP, "RIGHT")

    -- Search
    searchBox = SUIConfig:SearchEditBox(window.titlePanel, 200, 20, "Search settings")
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
    reloadButton = SUIConfig:Button(window, SIDEBAR, BUTTON_HEIGHT, "Reload UI")
    SUIConfig:GlueBottom(reloadButton, window, MARGIN, MARGIN, "LEFT")
    reloadButton:SetScript("OnClick", ReloadUI)

    local edit = SUIConfig:Button(window, SIDEBAR, BUTTON_HEIGHT, SUI.HasEditMode and "Edit Mode" or "Move Frames")
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
        Config:RebuildCurrent()
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

-- Opens a tab by (case insensitive) name or title.
function Config:Open(name)
    if not window then
        create()
    end
    if name then
        name = name:lower()
        for _, tab in ipairs(tabs.tabs) do
            if (tab.name:lower() == name or (tab.title or ""):lower() == name) then
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
