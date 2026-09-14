--[[
    SUI 2.0 - Features/Misc/SafeQueue.lua

    Shows how long a popped battleground/arena queue stays open and removes
    the leave button from the queue pop, so nobody drops a queue by accident.
    The countdown runs only while a queue is waiting for confirmation and
    stops at zero (1.x kept ticking forever). Clients that confirm through a
    StaticPopup get the countdown as a line below that popup.
]]

local _, ns = ...
local SUI = ns.SUI

local format = string.format

local F = SUI:NewFeature("Misc.SafeQueue", {
    category = "misc",
    toggle = "safequeue",
})

local function expiresText(secs)
    local color = secs > 20 and "20ff20" or secs > 10 and "ffff00" or "ff0000"
    return format("Queue expires in |cff%s%s|r", color, SecondsToTime(secs))
end

function F:OnLoad()
    self.queued = {} -- battlefield id -> GetTime() when the queue started
    self.tick = function()
        F:Tick()
    end

    local dialog = PVPReadyDialog
    if dialog and PVPReadyDialog_Display then
        self.dialog = dialog
        if dialog.enterButton then
            self.enterPoint = { dialog.enterButton:GetPoint(1) }
        end
        self:Hook("PVPReadyDialog_Display", function()
            F:StyleDialog()
        end)
    else
        local holder = CreateFrame("Frame", nil, UIParent)
        holder:SetFrameStrata("DIALOG")
        holder:SetSize(1, 1)
        self.label = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        self.label:Hide()
    end
end

function F:OnEnable()
    self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "Scan")
    self:Scan()
end

function F:OnDisable()
    self:Stop()
    local dialog, point = self.dialog, self.enterPoint
    if dialog and point and point[1] then
        dialog.enterButton:ClearAllPoints()
        dialog.enterButton:SetPoint(unpack(point, 1, 5))
    end
end

function F:StyleDialog()
    local dialog = self.dialog
    if dialog.hideButton then
        dialog.hideButton:Hide()
    end
    if dialog.leaveButton then
        dialog.leaveButton:Hide()
    end
    if dialog.enterButton then
        dialog.enterButton:ClearAllPoints()
        dialog.enterButton:SetPoint("BOTTOM", dialog, "BOTTOM", 0, 25)
    end
    if dialog.label then
        dialog.label:SetWidth(250)
    end
    self:Scan()
end

function F:Scan()
    local queued, confirm = self.queued, nil
    local count = GetMaxBattlefieldID and GetMaxBattlefieldID() or MAX_BATTLEFIELD_QUEUES or 3
    for i = 1, count do
        local status = GetBattlefieldStatus(i)
        if status == "queued" then
            queued[i] = queued[i] or GetTime() - (GetBattlefieldTimeWaited(i) or 0) / 1000
        elseif status == "confirm" then
            if queued[i] then
                local secs = GetTime() - queued[i]
                SUI:Print(secs < 1 and "Queue popped instantly!" or ("Queue popped after " .. SecondsToTime(secs)))
                queued[i] = nil
            end
            confirm = confirm or i
        else
            queued[i] = nil
        end
    end

    self.confirm = confirm
    if confirm then
        self:Tick()
        if self.confirm then
            self:StartUpdate(self.tick, 0.5)
        end
    else
        self:Stop()
    end
end

function F:Tick()
    local id = self.confirm
    local secs = id and GetBattlefieldStatus(id) == "confirm" and GetBattlefieldPortExpiration(id)
    if not secs or secs <= 0 then
        self:Stop()
        return
    end

    local dialog = self.dialog
    if dialog then
        local text = dialog.label or dialog.text
        if text and dialog:IsShown() then
            text:SetText(expiresText(secs))
        end
        return
    end

    local label = self.label
    local popup = StaticPopup_FindVisible and StaticPopup_FindVisible("CONFIRM_BATTLEFIELD_ENTRY")
    if popup then
        label:ClearAllPoints()
        label:SetPoint("TOP", popup, "BOTTOM", 0, -4)
        label:SetText(expiresText(secs))
        label:Show()
    else
        label:Hide()
    end
end

function F:Stop()
    self.confirm = nil
    self:StopUpdate()
    if self.label then
        self.label:Hide()
    end
end
