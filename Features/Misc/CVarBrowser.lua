--[[
    SUI 2.0 - Features/Misc/CVarBrowser.lua

    A searchable list of every console variable with its current and
    default value. Select a row to edit the value or reset it to the
    default. Opened from the Misc tab; the window is built on first use and
    the list is read fresh each time it opens.
]]

local _, ns = ...
local SUI = ns.SUI

local SUIConfig = LibStub("SUIConfig")
local Compat = SUI.Compat

local Browser = {}
ns.MiscCVarBrowser = Browser

local window, list, valueBox, helpLabel
local query = ""

local function collect()
    local rows = {}
    local commands = C_Console and C_Console.GetAllCommands and C_Console.GetAllCommands()
    if not commands then
        return rows
    end
    local cvarType = Enum and Enum.ConsoleCommandType and Enum.ConsoleCommandType.Cvar or 0
    local getDefault = SUI.Compat.GetCVarDefault
    for i = 1, #commands do
        local command = commands[i]
        local name = command.command
        if command.commandType == cvarType and name then
            rows[#rows + 1] = {
                cvar = name,
                value = tostring(Compat.GetCVar(name) or ""),
                default = tostring(getDefault and getDefault(name) or ""),
                help = command.help or "",
                search = name:lower(),
            }
        end
    end
    table.sort(rows, function(a, b)
        return a.search < b.search
    end)
    return rows
end

local function onSelect()
    local row = list:GetSelectedItem()
    valueBox:SetText(row and row.value or "")
    helpLabel:SetText(row and row.help or "")
end

local function apply(value)
    local row = list:GetSelectedItem()
    if not row then
        return
    end
    if InCombatLockdown() then
        SUI:Print("CVars cannot be changed in combat.")
        return
    end
    Compat.SetCVar(row.cvar, value)
    row.value = tostring(Compat.GetCVar(row.cvar) or "")
    list:Refresh()
    onSelect()
end

local function filter(_, row)
    return query == "" or row.search:find(query, 1, true) ~= nil
end

local function create()
    window = SUIConfig:Window(UIParent, 540, 440, "CVar Browser")
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")

    local search = SUIConfig:SearchEditBox(window, 520, 24, "Search")
    SUIConfig:GlueTop(search, window, 10, -40, "LEFT")
    search.OnValueChanged = function(_, text)
        query = strtrim(text or ""):lower()
        list:SetFilter(filter)
    end

    list = SUIConfig:ScrollTable(window, {
        { name = "CVar", width = 260, align = "LEFT", index = "cvar", format = "string" },
        { name = "Value", width = 110, align = "LEFT", index = "value", format = "string" },
        { name = "Default", width = 110, align = "LEFT", index = "default", format = "string" },
    }, 15, 18)
    list:EnableSelection(true)
    SUIConfig:GlueTop(list, window, 0, -95)
    hooksecurefunc(list, "SetSelection", onSelect)

    helpLabel = SUIConfig:Label(window, "", nil, nil, 520, 30)
    SUIConfig:GlueTop(helpLabel, window, 10, -380, "LEFT")

    valueBox = SUIConfig:SimpleEditBox(window, 300, 24, "")
    SUIConfig:GlueBottom(valueBox, window, 10, 10, "LEFT")
    valueBox:SetScript("OnEnterPressed", function(box)
        apply(box:GetText())
        box:ClearFocus()
    end)

    local set = SUIConfig:Button(window, 100, 24, "Set")
    SUIConfig:GlueRight(set, valueBox, 5, 0)
    set:SetScript("OnClick", function()
        apply(valueBox:GetText())
    end)

    local reset = SUIConfig:Button(window, 100, 24, "Default")
    SUIConfig:GlueRight(reset, set, 5, 0)
    reset:SetScript("OnClick", function()
        local row = list:GetSelectedItem()
        if row then
            apply(row.default)
        end
    end)

    window:Hide()
end

function Browser:Toggle()
    if not window then
        create()
    end
    if window:IsShown() then
        window:Hide()
        return
    end
    list:ClearSelection()
    list:SetData(collect())
    window:Show()
end
