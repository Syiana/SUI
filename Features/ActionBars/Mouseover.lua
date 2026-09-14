--[[
    SUI 2.0 - Features/ActionBars/Mouseover.lua

    Fades action bars, the micro menu and the bag bar until the mouse is over
    one of their buttons. Driven by OnEnter/OnLeave hooks (a short delay on
    leave lets the mouse move between buttons); nothing polls. The micro menu
    and bag bar can also be hidden. Bars are revealed while dragging spells.
]]

local _, ns = ...
local SUI = ns.SUI
local AB = ns.ActionBars

local _G = _G
local After = C_Timer.After

-- Fallback button names for clients without the MicroMenu/BagsBar containers.
local MICRO_FALLBACK = {
    "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton",
    "QuestLogMicroButton", "SocialsMicroButton", "GuildMicroButton", "PVPMicroButton", "LFGMicroButton",
    "WorldMapMicroButton", "MainMenuMicroButton", "HelpMicroButton",
}
local BAG_FALLBACK = {
    "MainMenuBarBackpackButton", "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot",
    "CharacterBag3Slot", "KeyRingButton", "CharacterReagentBag0Slot", "BagBarExpandToggle",
}

-- Fader groups ----------------------------------------------------------------
-- mode: "show" | "mouse_over" | "hide"
local grid = false

local function wanted(g)
    if g.mode ~= "mouse_over" or g.over or grid then
        return 1
    end
    if KeybindFrames_InQuickKeybindMode and KeybindFrames_InQuickKeybindMode() then
        return 1
    end
    return 0
end

local function setAlpha(g, alpha, force)
    if g.alpha == alpha and not force then
        return
    end
    g.alpha = alpha
    for i = 1, #g.targets do
        g.targets[i]:SetAlpha(alpha)
    end
    local bling = alpha > 0
    for i = 1, #g.cooldowns do
        g.cooldowns[i]:SetDrawBling(bling)
    end
end

local function names(list)
    local out = {}
    for i = 1, #list do
        local obj = _G[list[i]]
        if obj then
            out[#out + 1] = obj
        end
    end
    return out
end

local function newGroup(feature, key, targets, hover)
    local g = { key = key, targets = targets, hover = hover, cooldowns = {}, mode = "show", alpha = 1, over = false, hidden = {} }

    local function check()
        if not g.over then
            setAlpha(g, wanted(g))
        end
    end
    local function onEnter()
        if g.mode == "mouse_over" then
            g.over = true
            setAlpha(g, 1)
        end
    end
    local function onLeave()
        if g.mode == "mouse_over" then
            g.over = false
            After(0.1, check)
        end
    end

    -- Hide mode: hide what is shown, restore only what SUI hid.
    function g.applyHidden()
        for i = 1, #g.targets do
            local target = g.targets[i]
            if g.mode == "hide" then
                if target:IsShown() then
                    g.hidden[target] = true
                    target:Hide()
                end
            elseif g.hidden[target] then
                g.hidden[target] = nil
                target:Show()
            end
        end
    end
    local function onShow()
        if g.mode == "hide" then
            SUI:RunAfterCombat(g.applyHidden)
        end
    end

    for i = 1, #hover do
        local button = hover[i]
        feature:HookScript(button, "OnEnter", onEnter)
        feature:HookScript(button, "OnLeave", onLeave)
        local cooldown = button.cooldown
        if cooldown and cooldown.SetDrawBling then
            g.cooldowns[#g.cooldowns + 1] = cooldown
        end
    end
    if feature.canHide then
        for i = 1, #targets do
            feature:Hook(targets[i], "Show", onShow)
        end
    end
    return g
end

local function applyGroup(g, mode, force)
    g.mode = mode
    SUI:RunAfterCombat(g.applyHidden)
    setAlpha(g, wanted(g), force)
end

-- Action bars -------------------------------------------------------------------
local Bars = SUI:NewFeature("ActionBars.Mouseover", {
    category = "actionbar",
    toggle = function(db)
        for _, on in pairs(db.bars) do
            if on then
                return true
            end
        end
        return false
    end,
    conflicts = { "Bartender4", "Dominos" },
})

function Bars:OnLoad()
    self.groups = {}
    for b = 1, #AB.bars do
        local bar = AB.bars[b]
        local buttons = AB.Buttons(bar)
        local frame = not bar.perButton and AB.BarFrame(bar)
        if buttons[1] then
            self.groups[#self.groups + 1] = newGroup(self, bar.key, frame and { frame } or buttons, buttons)
        end
    end
end

function Bars:Apply(force)
    local bars = self.db.bars
    for i = 1, #self.groups do
        local g = self.groups[i]
        applyGroup(g, bars[g.key] and "mouse_over" or "show", force)
    end
end

function Bars:OnGrid(event)
    grid = event == "ACTIONBAR_SHOWGRID"
    for i = 1, #self.groups do
        local g = self.groups[i]
        setAlpha(g, wanted(g))
    end
end

function Bars:OnEnable()
    self:RegisterEvent("ACTIONBAR_SHOWGRID", "OnGrid")
    self:RegisterEvent("ACTIONBAR_HIDEGRID", "OnGrid")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        Bars:Apply(true)
    end)
    self:Apply(true)
end

function Bars:OnRefresh()
    self:Apply()
end

function Bars:OnDisable()
    grid = false
    for i = 1, #self.groups do
        applyGroup(self.groups[i], "show")
    end
end

-- Micro menu and bag bar ----------------------------------------------------------
local Menu = SUI:NewFeature("ActionBars.Menu", {
    category = "actionbar",
    toggle = function(db)
        return db.menu.micromenu ~= "show" or db.menu.bagbar ~= "show"
    end,
})
Menu.canHide = true

local function container(frame, fallback)
    if frame then
        local hover = { frame:GetChildren() }
        return { frame }, hover
    end
    local buttons = names(fallback)
    return buttons, buttons
end

function Menu:OnLoad()
    local microNames = type(MICRO_BUTTONS) == "table" and MICRO_BUTTONS or MICRO_FALLBACK
    self.micro = newGroup(self, "micromenu", container(MicroMenu, microNames))
    self.bags = newGroup(self, "bagbar", container(BagsBar, BAG_FALLBACK))
end

function Menu:Apply(force)
    local menu = self.db.menu
    applyGroup(self.micro, menu.micromenu, force)
    applyGroup(self.bags, menu.bagbar, force)
end

function Menu:OnEnable()
    self:Apply(true)
end

function Menu:OnRefresh()
    self:Apply()
end

function Menu:OnDisable()
    applyGroup(self.micro, "show")
    applyGroup(self.bags, "show")
end
