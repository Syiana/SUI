local Module = SUI:NewModule("Misc.Safequeue");

function Module:OnEnable()
    local db = SUI.db.profile.misc.safequeue
    if (db) then
        local SafeQueue = SafeQueue
        local CreateFrame = CreateFrame
        local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
        local GetBattlefieldPortExpiration = GetBattlefieldPortExpiration
        local GetBattlefieldStatus = GetBattlefieldStatus
        local GetBattlefieldTimeWaited = GetBattlefieldTimeWaited
        local GetMaxBattlefieldID = GetMaxBattlefieldID
        local GetTime = GetTime
        local PVPReadyDialog = PVPReadyDialog
        local PVPReadyDialog_Display = PVPReadyDialog_Display
        local SecondsToTime = SecondsToTime
        local TOOLTIP_UPDATE_TIME = TOOLTIP_UPDATE_TIME
        local WOW_PROJECT_ID = WOW_PROJECT_ID
        local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
        local format = format
        local hooksecurefunc = hooksecurefunc

        function SafeQueue:SetExpiresText()
            local battlefieldId = self.battlefieldId
            if (not battlefieldId) then return end
            local secs = GetBattlefieldPortExpiration(battlefieldId)
            if secs <= 0 then secs = 1 end
            local color
            if secs > 20 then
                color = "20ff20"
            elseif secs > 10 then
                color = "ffff00"
            else
                color = "ff0000"
            end
            local text = "SafeQueue expires in |cff" .. color .. SecondsToTime(secs) .. "|r"
            self.text:SetText(text)
            if PVPReadyDialog then
                if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                    -- retail: just show expiration
                    PVPReadyDialog.label:SetText(text)
                elseif PVPReadyDialog.text and self.color and self.battleground then
                    text = format("\n%s\n\n|cff%s%s|r", text, self.color, self.battleground)
                    PVPReadyDialog.text:SetText(text)
                end
            end
        end

        function SafeQueue:Print(message)
            DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SafeQueue|r: " .. message)
        end

        local update = CreateFrame("Frame")
        update.timer = TOOLTIP_UPDATE_TIME
        update:SetScript("OnUpdate", function(self, elapsed)
            local battlefieldId = SafeQueue.battlefieldId
            if (not battlefieldId) then return end
            local timer = self.timer
            timer = timer - elapsed
            if timer <= 0 then
                if GetBattlefieldStatus(battlefieldId) ~= "confirm" then
                    SafeQueue.battlefieldId = nil
                    if SafeQueue.HidePopup then SafeQueue:HidePopup() end
                    return
                end
                SafeQueue:SetExpiresText()
            end
            self.timer = timer
        end)

        function SafeQueue:UPDATE_BATTLEFIELD_STATUS()
            local isConfirm = nil
            for i = 1, GetMaxBattlefieldID() do
                local status = GetBattlefieldStatus(i)
                if status == "queued" then
                    self.queues[i] = self.queues[i] or GetTime() - (GetBattlefieldTimeWaited(i) / 1000)
                elseif status == "confirm" then
                    if self.queues[i] then
                        local secs = GetTime() - self.queues[i]
                        local message
                        if secs < 1 then
                            message = "Queue popped instantly!"
                        else
                            message = "Queue popped after " .. SecondsToTime(secs)
                        end
                        self:Print(message)
                        self.queues[i] = nil
                    end
                    isConfirm = true
                else
                    self.queues[i] = nil
                end
            end
            if (not isConfirm) then
                self.battlefieldId = nil
                if self.HidePopup then self:HidePopup() end
            end
        end

        if PVPReadyDialog_Display then
            if PVPReadyDialog.label then PVPReadyDialog.label:SetWidth(250) end
            hooksecurefunc("PVPReadyDialog_Display", function(self, i)
                self = self or PVPReadyDialog
                if self.hideButton then self.hideButton:Hide() end
                if self.leaveButton then self.leaveButton:Hide() end
                self.enterButton:ClearAllPoints()
                self.enterButton:SetPoint("BOTTOM", self, "BOTTOM", 0, 25)
                SafeQueue.battlefieldId = i
                if SafeQueue.ShowPopup then SafeQueue:ShowPopup() end
                SafeQueue:SetExpiresText()
            end)
        end
    end
end
