--[[
    SUI 2.0 - Features/ActionBars/ProcGlow.lua

    Spell proc highlight on action buttons. "Hide" fades out Blizzard's
    spell activation overlay, "Custom" replaces it with a LibCustomGlow glow
    (pixel, autocast or button style). Works by hooking Blizzard's overlay
    show/hide calls: ActionButtonSpellAlertManager on retail,
    ActionButton_ShowOverlayGlow/HideOverlayGlow on the classic clients.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local next = next

local F = SUI:NewFeature("ActionBars.ProcGlow", {
    category = "actionbar",
    toggle = function(db)
        return db.buttons.procglow == "Custom" or db.buttons.procglow == "Hide"
    end,
    watch = { "general" },
})

local Glow
local color = { 1, 1, 1, 1 } -- reused colour table handed to LibCustomGlow
local active = {}            -- button -> true while Blizzard wants a proc highlight
local started = {}           -- button -> glow style SUI started on it
local muted = {}             -- Blizzard overlay frames SUI faded out (classic pools them)

local function blizzardAlert(button)
    return button.SpellActivationAlert or button.overlay
end

local function stopGlow(button)
    local style = started[button]
    if not style then
        return
    end
    started[button] = nil
    if style == "Pixel" then
        Glow.PixelGlow_Stop(button)
    elseif style == "Autocast" then
        Glow.AutoCastGlow_Stop(button)
    else
        Glow.ButtonGlow_Stop(button)
    end
end

local function startGlow(button)
    local style = F.db.buttons.procglowstyle
    if started[button] == style then
        return
    end
    stopGlow(button)
    started[button] = style
    if style == "Pixel" then
        Glow.PixelGlow_Start(button, color, 8, 0.25, nil, 2)
    elseif style == "Autocast" then
        Glow.AutoCastGlow_Start(button, color, 4, 0.125)
    else
        Glow.ButtonGlow_Start(button, color)
    end
end

-- Brings one button in line with the current mode.
local function sync(button)
    local mode = F.db.buttons.procglow
    if active[button] then
        -- Faded, not hidden: a hidden overlay never finishes its out
        -- animation, so classic would never release it back to its pool.
        local alert = blizzardAlert(button)
        if alert and not muted[alert] then
            muted[alert] = true
            alert:SetAlpha(0)
        end
        if mode == "Custom" and Glow then
            startGlow(button)
        else
            stopGlow(button)
        end
    else
        stopGlow(button)
    end
end

local function onShow(button)
    if button then
        active[button] = true
        sync(button)
    end
end

local function onHide(button)
    if button then
        active[button] = nil
        stopGlow(button)
    end
end

function F:OnLoad()
    Glow = LibStub("LibCustomGlow-1.0", true)
    local manager = ActionButtonSpellAlertManager
    if manager and manager.ShowAlert then
        self:Hook(manager, "ShowAlert", function(_, button)
            onShow(button)
        end)
        self:Hook(manager, "HideAlert", function(_, button)
            onHide(button)
        end)
    elseif ActionButton_ShowOverlayGlow then
        self:Hook("ActionButton_ShowOverlayGlow", onShow)
        self:Hook("ActionButton_HideOverlayGlow", onHide)
    end
end

function F:UpdateColor()
    local buttons = self.db.buttons
    local r, g, b
    if buttons.procglowtheme then
        local theme = SUI.Theme
        if theme.name == "Custom" or theme.name == "Class" then
            r, g, b = theme.r, theme.g, theme.b
        else
            local _, class = UnitClass("player")
            r, g, b = SUI.Compat.GetClassColor(class)
        end
    else
        local c = buttons.procglowcolor
        r, g, b = c.r, c.g, c.b
    end
    color[1], color[2], color[3], color[4] = r, g, b, 1
end

-- Restarts every glow (colour and style are read when a glow starts).
function F:Restart()
    self:UpdateColor()
    for button in next, started do
        stopGlow(button)
    end
    for button in next, active do
        sync(button)
    end
end

function F:OnEnable()
    -- Pick up procs that are already showing.
    local buttons = AB.AllButtons(true)
    for i = 1, #buttons do
        local button = buttons[i]
        local alert = blizzardAlert(button)
        if alert and alert:IsShown() then
            active[button] = true
        end
    end
    self:Restart()
end

function F:OnRefresh()
    self:Restart()
end

function F:OnThemeChanged()
    self:Restart()
end

function F:OnDisable()
    for button in next, started do
        stopGlow(button)
    end
    for alert in next, muted do
        alert:SetAlpha(1)
    end
    wipe(muted)
    wipe(active)
end
