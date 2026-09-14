--[[
    SUI 2.0 - Features/ActionBars/Buttons.lua

    Shared knowledge of the Blizzard action bars for this folder: which bar
    frames and buttons exist. Names differ between clients (MainActionBar vs
    MainMenuBar, PetActionBar vs PetActionBarFrame), so everything is looked
    up at runtime and missing frames are skipped.
]]

local _, ns = ...

local _G = _G

local AB = {}
ns.ActionBars = AB

-- key = setting under actionbar.bars; frames = candidate bar frame names;
-- prefix/count = button globals; action = buttons carry an action slot.
AB.bars = {
    { key = "bar1", frames = { "MainActionBar", "MainMenuBar" }, prefix = "ActionButton", count = 12, action = true, perButton = true },
    { key = "bar2", frames = { "MultiBarBottomLeft" }, prefix = "MultiBarBottomLeftButton", count = 12, action = true },
    { key = "bar3", frames = { "MultiBarBottomRight" }, prefix = "MultiBarBottomRightButton", count = 12, action = true },
    { key = "bar4", frames = { "MultiBarRight" }, prefix = "MultiBarRightButton", count = 12, action = true },
    { key = "bar5", frames = { "MultiBarLeft" }, prefix = "MultiBarLeftButton", count = 12, action = true },
    { key = "bar6", frames = { "MultiBar5" }, prefix = "MultiBar5Button", count = 12, action = true },
    { key = "bar7", frames = { "MultiBar6" }, prefix = "MultiBar6Button", count = 12, action = true },
    { key = "bar8", frames = { "MultiBar7" }, prefix = "MultiBar7Button", count = 12, action = true },
    { key = "petbar", frames = { "PetActionBar", "PetActionBarFrame" }, prefix = "PetActionButton", count = 10 },
    { key = "stancebar", frames = { "StanceBar", "StanceBarFrame" }, prefix = "StanceButton", count = 10 },
}

-- Button names of bar add-ons SUI 1.x styled as well.
local ADDON_BUTTONS = {
    { "BT4Button", 180 }, { "BT4PetButton", 10 }, { "BT4StanceButton", 10 },
    { "DominosActionButton", 140 }, { "DominosPetActionButton", 10 }, { "DominosStanceButton", 10 },
}

function AB.First(names)
    for i = 1, #names do
        local obj = _G[names[i]]
        if obj then
            return obj
        end
    end
end

function AB.BarFrame(bar)
    return AB.First(bar.frames)
end

function AB.Exists(key)
    for i = 1, #AB.bars do
        local bar = AB.bars[i]
        if bar.key == key then
            return AB.BarFrame(bar) ~= nil or _G[bar.prefix .. "1"] ~= nil
        end
    end
    return false
end

-- Array of the buttons of one bar (built on demand, call from OnLoad/OnEnable).
function AB.Buttons(bar)
    local list = {}
    for i = 1, bar.count do
        local button = _G[bar.prefix .. i]
        if button then
            list[#list + 1] = button
        end
    end
    return list
end

-- Array of every Blizzard button; actionOnly limits it to bars 1-8.
function AB.AllButtons(actionOnly)
    local list = {}
    for b = 1, #AB.bars do
        local bar = AB.bars[b]
        if bar.action or not actionOnly then
            for i = 1, bar.count do
                local button = _G[bar.prefix .. i]
                if button then
                    list[#list + 1] = button
                end
            end
        end
    end
    return list
end

-- Array of Bartender4/Dominos buttons that exist.
function AB.AddonButtons()
    local list = {}
    for n = 1, #ADDON_BUTTONS do
        local prefix, count = ADDON_BUTTONS[n][1], ADDON_BUTTONS[n][2]
        for i = 1, count do
            local button = _G[prefix .. i]
            if button then
                list[#list + 1] = button
            end
        end
    end
    return list
end

-- A button region by parentKey, falling back to the <Name><suffix> global.
function AB.Region(button, key, suffix)
    local region = button[key]
    if region then
        return region
    end
    local name = button:GetName()
    return name and _G[name .. suffix]
end
