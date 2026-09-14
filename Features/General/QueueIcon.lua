--[[
    SUI 2.0 - Features/General/QueueIcon.lua

    Makes the retail queue status eye movable. Blizzard re-anchors and
    rescales QueueStatusButton from several places, so the button is never
    moved directly: it is pinned to the centre of a holder SUI owns, and Edit
    Mode moves the holder (position key "queueicon", as in 1.x).
]]

local _, ns = ...
local SUI = ns.SUI

local F = SUI:NewFeature("General.QueueIcon", {
    clients = { Mainline = true },
})

local SCALE = 0.8

function F:OnLoad()
    local button = QueueStatusButton
    if not button then
        return
    end
    local holder = CreateFrame("Frame", nil, UIParent)
    holder:SetSize(button:GetWidth(), button:GetHeight())
    holder.editModeName = "SUI Queue Status"
    self.holder = holder
    SUI.Movers:Add(holder, "queueicon", { point = "CENTER", x = 0, y = 0 }, { label = "Queue Status" })

    local pinning = false
    local function pin()
        if pinning then
            return
        end
        pinning = true
        button:ClearAllPoints()
        button:SetPoint("CENTER", holder)
        pinning = false
    end
    self.pin = pin

    self:Hook(button, "SetPoint", pin)
    self:Hook(button, "SetScale", function(_, scale)
        if scale ~= SCALE then
            button:SetScale(SCALE)
        end
    end)

    -- Show the eye while editing so there is something to aim at.
    local lib = SUI.Movers.lib
    if lib then
        local wasShown
        lib:RegisterCallback("enter", function()
            wasShown = button:IsShown()
            button:Show()
        end)
        lib:RegisterCallback("exit", function()
            if not wasShown then
                button:Hide()
            end
        end)
    end
end

function F:OnEnable()
    if not self.holder then
        return
    end
    SUI:RunAfterCombat(function()
        QueueStatusButton:SetParent(self.holder)
        QueueStatusButton:SetScale(SCALE)
        self.pin()
    end)
end
