--[[
    SUI 2.0 - Features/ActionBars/Art.lua

    Hides decoration around the action bars: the gryphons / end caps (retail
    and classic art) and the XP, reputation and honor bars (1.x misc.repbar).
    End caps are faded out through alpha, which Blizzard never resets; status
    bars are hidden and re-hidden whenever Blizzard shows them again.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

-- Gryphons ------------------------------------------------------------------------
local Gryphons = SUI:NewFeature("ActionBars.Gryphons", {
    category = "actionbar",
    toggle = "gryphons",
})

local function endCaps()
    local list = {}
    local function add(obj)
        if obj then
            list[#list + 1] = obj
        end
    end
    add(MainActionBar and MainActionBar.EndCaps)                  -- retail 12.x
    add(MainMenuBar and MainMenuBar.EndCaps)                      -- retail 10.x/11.x
    add(MainMenuBarLeftEndCap)                                    -- classic
    add(MainMenuBarRightEndCap)
    add(MainMenuBarArtFrame and MainMenuBarArtFrame.LeftEndCap)   -- classic, newer art frame
    add(MainMenuBarArtFrame and MainMenuBarArtFrame.RightEndCap)
    return list
end

local function setAlpha(list, alpha)
    for i = 1, #list do
        list[i]:SetAlpha(alpha)
    end
end

function Gryphons:OnEnable()
    setAlpha(endCaps(), 0)
end

function Gryphons:OnDisable()
    setAlpha(endCaps(), 1)
end

-- XP / reputation / honor bars ---------------------------------------------------------
local StatusBar = SUI:NewFeature("ActionBars.StatusBar", {
    category = "actionbar",
    toggle = "statusbar",
})

local STATUS_BARS = {
    "StatusTrackingBarManager", -- retail and Mists
    "MainMenuExpBar", "ReputationWatchBar", "MainMenuBarMaxLevelBar", "HonorWatchBar",
}

local hidden = {}

local function hideAll()
    if not StatusBar.enabled then
        return
    end
    for i = 1, #StatusBar.frames do
        local frame = StatusBar.frames[i]
        if frame:IsShown() then
            hidden[frame] = true
            frame:Hide()
        end
    end
end

local function onShow()
    SUI:RunAfterCombat(hideAll)
end

local function onSetShown(_, shown)
    if shown then
        SUI:RunAfterCombat(hideAll)
    end
end

function StatusBar:OnLoad()
    self.frames = {}
    for i = 1, #STATUS_BARS do
        local frame = AB.First({ STATUS_BARS[i] })
        if frame then
            self.frames[#self.frames + 1] = frame
            self:Hook(frame, "Show", onShow)
            self:Hook(frame, "SetShown", onSetShown)
        end
    end
end

function StatusBar:OnEnable()
    SUI:RunAfterCombat(hideAll)
end

function StatusBar:OnDisable()
    SUI:RunAfterCombat(function()
        for frame in pairs(hidden) do
            frame:Show()
        end
        wipe(hidden)
    end)
end
