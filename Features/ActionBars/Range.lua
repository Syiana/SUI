--[[
    SUI 2.0 - Features/ActionBars/Range.lua

    Tints action button icons: red out of range, blue without mana, grey when
    unusable. Retail pushes range changes per slot (ACTION_RANGE_CHECK_UPDATE);
    the classic clients are polled by a 0.2s loop that only runs while visible
    buttons with an action exist. The applied colour is cached per button, so
    unchanged states never touch the texture.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local next = next
local Compat = SUI.Compat
local HasAction, IsUsableAction, IsActionInRange = Compat.HasAction, Compat.IsUsableAction, Compat.IsActionInRange

local F = SUI:NewFeature("ActionBars.Range", {
    category = "actionbar",
    toggle = "buttons.range",
})

-- state: 1 normal, 2 out of range, 3 out of mana, 4 unusable
local R = { 1, 0.8, 0.5, 0.3 }
local G = { 1, 0.1, 0.5, 0.3 }
local B = { 1, 0.1, 1, 0.3 }

local buttons = {} -- array of action buttons
local state = {}   -- button -> applied state
local polled = {}  -- classic: visible buttons with an action
local pollCount = 0

local function setState(button, s)
    if state[button] ~= s then
        state[button] = s
        button.icon:SetVertexColor(R[s], G[s], B[s])
    end
end

-- inRange: true/false when known (event), nil to ask the API.
local function update(button, inRange)
    local action = button.action
    if not action or not button.icon or not HasAction(action) then
        return
    end
    local usable, noMana = IsUsableAction(action)
    if usable then
        if inRange == nil then
            inRange = IsActionInRange(action)
        end
        setState(button, inRange == false and 2 or 1)
    elseif noMana then
        setState(button, 3)
    else
        setState(button, 4)
    end
end

-- Blizzard recoloured the icon: forget the cache and colour again.
local function onUsable(button)
    state[button] = nil
    update(button)
end

local function poll()
    for button in next, polled do
        update(button)
    end
end

-- Classic: keep the polled set in sync with visibility and actions.
local function track(button)
    local want = button:IsVisible() and button.action ~= nil and HasAction(button.action) or nil
    if polled[button] ~= want then
        polled[button] = want
        pollCount = pollCount + (want and 1 or -1)
        if pollCount == 1 and want then
            F:StartUpdate(poll, 0.2)
        elseif pollCount == 0 then
            F:StopUpdate()
        end
    end
    if want then
        onUsable(button)
    end
end

-- Retail: make sure the client reports range changes for this slot. The
-- check is only ever switched on; Blizzard's own buttons manage the rest.
local enableRangeCheck
local function watch(button)
    local action = button.action
    if action and button:IsVisible() then
        enableRangeCheck(action, true)
    end
    onUsable(button)
end

function F:OnLoad()
    buttons = AB.AllButtons(true)
    local onChange = track
    if Compat.HasRangeEvents then
        enableRangeCheck = C_ActionBar.EnableActionRangeCheck
        onChange = watch
    end
    for i = 1, #buttons do
        local button = buttons[i]
        if button.UpdateUsable then
            self:Hook(button, "UpdateUsable", onUsable)
        end
        if button.Update then
            self:Hook(button, "Update", onChange)
        end
        self:HookScript(button, "OnShow", onChange)
        if not Compat.HasRangeEvents then
            self:HookScript(button, "OnHide", track)
        end
    end
    if not buttons[1] or not buttons[1].UpdateUsable then
        if ActionButton_UpdateUsable then
            self:Hook("ActionButton_UpdateUsable", onUsable)
        end
    end
end

function F:OnRangeEvent(_, slot, isInRange, checksRange)
    local inRange = true
    if checksRange then
        inRange = isInRange
    end
    for i = 1, #buttons do
        local button = buttons[i]
        if button.action == slot and button:IsVisible() then
            update(button, inRange)
        end
    end
end

function F:OnEnable()
    if Compat.HasRangeEvents then
        self:RegisterEvent("ACTION_RANGE_CHECK_UPDATE", "OnRangeEvent")
        for i = 1, #buttons do
            watch(buttons[i])
        end
    else
        pollCount = 0
        wipe(polled)
        for i = 1, #buttons do
            track(buttons[i])
        end
    end
end

function F:OnDisable()
    wipe(polled)
    pollCount = 0
    for i = 1, #buttons do
        local button = buttons[i]
        if state[button] and button.icon then
            button.icon:SetVertexColor(1, 1, 1)
        end
        state[button] = nil
    end
end
