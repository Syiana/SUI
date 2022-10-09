local Module = SUI:NewModule("Misc.Safequeue");

function Module:OnEnable()
  local db = SUI.db.profile.misc.safequeue
  if (db) then
    -- Core
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

    -- Wrath Classic
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then return end
    local CreateFrame = CreateFrame
    local ENTER_BATTLE = ENTER_BATTLE
    local GetBattlefieldStatus = GetBattlefieldStatus
    local GetMapInfo = C_Map.GetMapInfo
    local GetMaxBattlefieldID = GetMaxBattlefieldID
    local InCombatLockdown = InCombatLockdown
    local PVPReadyDialog = PVPReadyDialog
    local PlaySound = PlaySound
    local REQUIRES_RELOAD = REQUIRES_RELOAD
    local SOUNDKIT = SOUNDKIT
    local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
    local StaticPopup_Hide = StaticPopup_Hide
    local format = format
    local hooksecurefunc = hooksecurefunc
    local issecurevariable = issecurevariable

    local ALTERAC_VALLEY = GetMapInfo(1459).name
    local WARSONG_GULCH = GetMapInfo(1460).name
    local ARATHI_BASIN = GetMapInfo(1461).name

    local BATTLEGROUND_COLORS = {
        default = "ffd100",
        [ALTERAC_VALLEY] = "007fff",
        [WARSONG_GULCH] = "00ff00",
        [ARATHI_BASIN] = "ffd100",
    }

    if PVPReadyDialog then
        PVPReadyDialog:SetHeight(120)
        -- add a minimize button
        local hideButton = CreateFrame("Button", nil, PVPReadyDialog, "UIPanelCloseButton")
        hideButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up")
        hideButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down")
        hideButton:SetPoint("TOPRIGHT", PVPReadyDialog, "TOPRIGHT", -3, -3)
        hideButton:SetScript("OnHide", function() PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) end)
    else
        -- Classic Era
        hooksecurefunc("StaticPopup_Show", function(name, _,_, i)
            if name ~= "CONFIRM_BATTLEFIELD_ENTRY" then return end
            SafeQueue.battlefieldId = i
            SafeQueue:ShowPopup()
        end)
    end

    SafeQueue:RegisterEvent("ADDON_ACTION_FORBIDDEN")

    function SafeQueue:ADDON_ACTION_FORBIDDEN(_, func)
        if (not self:IsVisible()) then return end
        if func == "AcceptBattlefieldPort()" then self.popupTainted = true end
        if func == "func()" then self.minimapTainted = true end
        if (not self.popupTainted) or (not self.minimapTainted) then return end
        StaticPopup_Hide("ADDON_ACTION_FORBIDDEN")
        self:SetMacroText()
    end

    function SafeQueue:HideBlizzardPopup()
        if PVPReadyDialog then
            StaticPopupSpecial_Hide(PVPReadyDialog)
        else
            StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
        end
    end

    SafeQueue:SetScript("OnShow", function(self)
        if (not self.battlefieldId) then return end
        if InCombatLockdown() then
            self.showPending = true
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        local status, battleground = GetBattlefieldStatus(self.battlefieldId)

        if status ~= "confirm" then return end

        self:HideBlizzardPopup()

        self.showPending = nil
        self.hidePending = nil

        self:SetExpiresText()
        self.SubText:SetText(format("|cff%s%s|r", self.color, battleground))
        local color = self.color and self.color.rgb
        if color then self.SubText:SetTextColor(color.r, color.g, color.b) end

        self:SetMacroText()
    end)

    SafeQueue:SetScript("OnHide", function(self)
        self.battleground = nil
        self.battlefieldId = nil
        self.EnterButton:SetAttribute("macrotext", "")
        self.EnterButton:SetText(ENTER_BATTLE)
    end)

    function SafeQueue:ShowPopup()
        local battlefieldId = self.battlefieldId
        if (not battlefieldId) then return end
        local status, battleground = GetBattlefieldStatus(battlefieldId)
        if status ~= "confirm" then return end
        self.battleground = battleground
        self.color = BATTLEGROUND_COLORS[battleground] or BATTLEGROUND_COLORS.default
        self:SetExpiresText()
        if InCombatLockdown() then
            self.showPending = true
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end
        self:Show()
    end

    function SafeQueue:HidePopup()
        self:HideBlizzardPopup()
        if InCombatLockdown() then
            self.hidePending = true
            self:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end
        self:Hide()
    end

    function SafeQueue:PLAYER_REGEN_ENABLED()
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        if self.hidePending then self:Hide() end
        if self.showPending then self:Show() end
    end

    local function GetDropDownListEnterButton(battlefieldId)
        local index = -1
        for i = 1, GetMaxBattlefieldID() do
            local status = GetBattlefieldStatus(i)
            if status ~= "none" then index = index + 3 end
            if i == battlefieldId then return "DropDownList1Button" .. index end
        end
    end

    function SafeQueue:SetMacroText()
        if InCombatLockdown() then return end
        if (not self.battlefieldId) then return end
        if (not issecurevariable("CURRENT_BATTLEFIELD_QUEUES")) then self.popupTainted = true end
        if self.popupTainted and self.minimapTainted then
            self.EnterButton:SetText(REQUIRES_RELOAD)
            self.EnterButton:SetAttribute("macrotext", "/reload")
        else
            local macrotext = "/click PVPReadyDialogEnterBattleButton\n"
            local button = GetDropDownListEnterButton(self.battlefieldId)
            if button then
                macrotext = macrotext .. "/click MiniMapBattlefieldFrame RightButton\n/click " .. button
            end
            self.EnterButton:SetAttribute("macrotext", macrotext)
        end
    end
	end
end