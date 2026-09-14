--[[
    SUI 2.0 - Core/Movers.lua

    Makes SUI-owned frames movable. Retail uses Blizzard Edit Mode through
    LibEditMode and stores one position per Edit Mode layout. The classic
    clients have no Edit Mode, so SUI shows its own drag handles
    (/sui unlock, or the Edit Mode button in the options).

        SUI.Movers:Add(frame, "statsframe", { point = "BOTTOMLEFT", x = 5, y = 3 }, {
            label = "Stats",
            settings = { ... },  -- optional LibEditMode settings (retail only)
        })

    Positions live in profile.movers[key][layoutName]; classic uses the
    layout name "_".
]]

local _, ns = ...
local SUI = ns.SUI

local Movers = { frames = {} }
SUI.Movers = Movers

SUI:RegisterDefaults("movers", {})

local LEM = SUI.HasEditMode and LibStub("LibEditMode", true)
Movers.lib = LEM

local CLASSIC_LAYOUT = "_"

local function store(key)
    local all = SUI.db.profile.movers
    local entry = all[key]
    if not entry then
        entry = {}
        all[key] = entry
    end
    return entry
end

local function position(key, layout, default)
    local entry = store(key)
    return entry[layout] or entry[CLASSIC_LAYOUT] or default
end

local function place(frame, pos)
    frame:ClearAllPoints()
    frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
end

-- Retail ------------------------------------------------------------------------
if LEM then
    local function currentLayout()
        return LEM:GetActiveLayoutName() or CLASSIC_LAYOUT
    end

    function Movers:Add(frame, key, default, opts)
        self.frames[key] = { frame = frame, default = default, opts = opts }
        place(frame, position(key, currentLayout(), default))
        LEM:AddFrame(frame, function(_, layoutName, point, x, y)
            store(key)[layoutName] = { point = point, x = x, y = y }
        end, default)
        if opts and opts.settings then
            LEM:AddFrameSettings(frame, opts.settings)
        end
    end

    LEM:RegisterCallback("layout", function(layoutName)
        for key, info in pairs(Movers.frames) do
            place(info.frame, position(key, layoutName, info.default))
        end
    end)

    function Movers:SetUnlocked(unlocked)
        if not EditModeManagerFrame then
            return
        end
        if unlocked then
            ShowUIPanel(EditModeManagerFrame)
        else
            HideUIPanel(EditModeManagerFrame)
        end
    end

    function Movers:Toggle()
        self:SetUnlocked(not EditModeManagerFrame:IsShown())
    end

    function Movers:Reapply()
        local layout = currentLayout()
        for key, info in pairs(self.frames) do
            place(info.frame, position(key, layout, info.default))
        end
    end
else
    -- Classic -------------------------------------------------------------------
    local unlocked = false

    local function createHandle(frame, key, info)
        local handle = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        handle:SetFrameStrata("DIALOG")
        handle:SetAllPoints(frame)
        handle:SetBackdrop({ bgFile = SUI.Media.blank, edgeFile = SUI.Media.blank, edgeSize = 1 })
        handle:SetBackdropColor(0, 0.55, 1, 0.35)
        handle:SetBackdropBorderColor(0, 0.55, 1, 1)
        handle:EnableMouse(true)
        handle:SetMovable(true)
        handle:RegisterForDrag("LeftButton")
        handle.label = handle:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        handle.label:SetPoint("CENTER")
        handle.label:SetText(info.opts and info.opts.label or key)
        handle:SetScript("OnDragStart", function()
            frame:SetMovable(true)
            frame:StartMoving()
        end)
        handle:SetScript("OnDragStop", function()
            frame:StopMovingOrSizing()
            local point, _, _, x, y = frame:GetPoint(1)
            store(key)[CLASSIC_LAYOUT] = { point = point, x = x, y = y }
        end)
        handle:SetScript("OnMouseUp", function(_, button)
            if button == "RightButton" then
                store(key)[CLASSIC_LAYOUT] = nil
                place(frame, info.default)
            end
        end)
        handle:Hide()
        return handle
    end

    function Movers:Add(frame, key, default, opts)
        local info = { frame = frame, default = default, opts = opts }
        self.frames[key] = info
        place(frame, position(key, CLASSIC_LAYOUT, default))
        info.handle = createHandle(frame, key, info)
        if unlocked then
            info.handle:Show()
        end
    end

    function Movers:SetUnlocked(state)
        if InCombatLockdown() then
            SUI:Print("Frames cannot be unlocked in combat.")
            return
        end
        unlocked = state
        for _, info in pairs(self.frames) do
            info.handle:SetShown(state)
        end
        if state then
            SUI:Print("Frames unlocked. Drag to move, right-click to reset. Type /sui lock when done.")
        end
    end

    function Movers:Toggle()
        self:SetUnlocked(not unlocked)
    end

    function Movers:Reapply()
        for key, info in pairs(self.frames) do
            place(info.frame, position(key, CLASSIC_LAYOUT, info.default))
        end
    end
end

SUI.callbacks.RegisterCallback(Movers, "ProfileChanged", function()
    Movers:Reapply()
end)

-- SUI 1.x stored two fixed positions under profile.edit.
SUI:RegisterMigration("core-1x-movers", function(profile)
    local edit = rawget(profile, "edit")
    if type(edit) ~= "table" then
        return
    end
    local movers = rawget(profile, "movers") or {}
    for key, pos in pairs(edit) do
        if type(pos) == "table" and pos.point then
            movers[key] = movers[key] or {}
            movers[key][CLASSIC_LAYOUT] = { point = pos.point, x = pos.x, y = pos.y }
        end
    end
    profile.movers = movers
    profile.edit = nil
end)
