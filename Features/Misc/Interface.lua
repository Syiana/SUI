--[[
    SUI 2.0 - Features/Misc/Interface.lua

    Blizzard interface tweaks: an SUI button in the Escape game menu, a
    centred Loss of Control alert without its dark background, and hiding
    the wing decoration of the skyriding vigor bar.
]]

local _, ns = ...
local SUI = ns.SUI

local select = select

-- Game menu button --------------------------------------------------------------------
local MenuButton = SUI:NewFeature("Misc.MenuButton", {
    category = "misc",
    toggle = "menubutton",
})

local function openOptions()
    -- ToggleGameMenu() runs the protected SpellStopCasting() and taints.
    if GameMenuFrame:IsShown() then
        HideUIPanel(GameMenuFrame)
    end
    SUI.Config:Toggle()
end

function MenuButton:OnLoad()
    local menu = GameMenuFrame
    if not menu then
        return
    end
    if menu.InitButtons then
        self:Hook(menu, "InitButtons", function(frame)
            if not InCombatLockdown() then
                frame:AddSection()
                frame:AddButton(SUI.brand, openOptions)
            end
        end)
    else
        -- Old menu layout: hang the button below the frame instead of
        -- re-anchoring Blizzard's buttons, so nothing of theirs is touched.
        local button = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        button:SetSize(144, 21)
        button:SetText(SUI.brand)
        button:SetPoint("TOP", menu, "BOTTOM", 0, -4)
        button:SetScript("OnClick", openOptions)
        button:Hide()
        self.button = button
    end
end

function MenuButton:OnEnable()
    if self.button then
        self.button:Show()
    end
end

function MenuButton:OnDisable()
    if self.button then
        self.button:Hide()
    end
end

-- Loss of control -----------------------------------------------------------------------
local LossOfControl = SUI:NewFeature("Misc.LossOfControl", {
    category = "misc",
    toggle = "losecontrol",
})

local function setBackgroundAlpha(frame, alpha)
    local bg, top, bottom = frame.blackBg, frame.RedLineTop, frame.RedLineBottom
    if not bg then
        bg, top, bottom = frame:GetRegions()
    end
    if bg then
        bg:SetAlpha(alpha)
    end
    if top then
        top:SetAlpha(alpha)
    end
    if bottom then
        bottom:SetAlpha(alpha)
    end
end

function LossOfControl:OnLoad()
    if LossOfControlFrame then
        self.point = { LossOfControlFrame:GetPoint(1) }
    end
end

function LossOfControl:OnEnable()
    local frame = LossOfControlFrame
    if not frame then
        return
    end
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    setBackgroundAlpha(frame, 0)
end

function LossOfControl:OnDisable()
    local frame, point = LossOfControlFrame, self.point
    if not frame then
        return
    end
    if point and point[1] then
        frame:ClearAllPoints()
        frame:SetPoint(unpack(point, 1, 5))
    end
    setBackgroundAlpha(frame, 1)
end

-- Skyriding bar decoration ----------------------------------------------------------------
local SkyridingDecor = SUI:NewFeature("Misc.SkyridingDecor", {
    category = "misc",
    toggle = "dragonflying",
    clients = { Mainline = true },
})

local decorShown = true

local function setDecor(...)
    for i = 1, select("#", ...) do
        local child = select(i, ...)
        if child.DecorLeft and child.DecorRight then
            child.DecorLeft:SetShown(decorShown)
            child.DecorRight:SetShown(decorShown)
        end
    end
end

local function updateDecor()
    local container = UIWidgetPowerBarContainerFrame
    if container then
        setDecor(container:GetChildren())
    end
end

function SkyridingDecor:OnEnable()
    decorShown = false
    self:RegisterEvent("UPDATE_UI_WIDGET", updateDecor)
    updateDecor()
end

function SkyridingDecor:OnDisable()
    decorShown = true
    updateDecor()
end
