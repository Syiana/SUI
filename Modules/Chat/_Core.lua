local Module = SUI:NewModule("Chat.Core")

function Module:OnEnable()
    local db = SUI.db.profile.chat
    if db.style ~= "Custom" then
        return
    end

    local _, class = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[class]
    local fontPath = SUI.db.profile.general.font or STANDARD_TEXT_FONT

    CHAT_FRAME_FADE_TIME = 0.3
    CHAT_FRAME_FADE_OUT_TIME = 1
    CHAT_TAB_HIDE_DELAY = 0.3
    CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
    CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

    local styledFrames = {}

    local function hideObject(object)
        if not object then
            return
        end

        object:Hide()
        if object.SetAlpha then
            object:SetAlpha(0)
        end
    end

    local function createBackdrop(frame)
        if not frame or frame.suiBackdrop then
            return
        end

        local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", -4, 4)
        backdrop:SetPoint("BOTTOMRIGHT", 4, -4)
        backdrop:SetFrameLevel(math.max(frame:GetFrameLevel() - 1, 0))
        backdrop:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss",
            tile = true,
            tileSize = 8,
            edgeSize = 1,
        })
        backdrop:SetBackdropColor(0, 0, 0, 0.5)
        if SUI:Color() then
            backdrop:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
        else
            backdrop:SetBackdropBorderColor(0.25, 0.25, 0.25, 1)
        end

        frame.suiBackdrop = backdrop
    end

    local function accentBackdrop(frame)
        if not frame then
            return
        end

        createBackdrop(frame)
        if frame.suiBackdrop and SUI:Color() then
            frame.suiBackdrop:SetBackdropBorderColor(unpack(SUI:Color(0.15)))
        end
    end

    local function hideChatFrameBackground(frame)
        if not frame then
            return
        end

        for i = 1, frame:GetNumRegions() do
            local region = select(i, frame:GetRegions())
            if region and region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
                region:Hide()
            end
        end

        if frame.buttonFrame then
            for i = 1, frame.buttonFrame:GetNumRegions() do
                local region = select(i, frame.buttonFrame:GetRegions())
                if region and region:GetObjectType() == "Texture" then
                    region:SetTexture(nil)
                    region:Hide()
                end
            end
        end

        if frame.SetBackdrop then
            frame:SetBackdrop(nil)
        end
    end

    local function createScrollButton(parent, direction)
        local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
        button:SetSize(18, 18)
        button:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss",
            tile = true,
            tileSize = 8,
            edgeSize = 1,
        })
        button:SetBackdropColor(0, 0, 0, 0.7)
        if SUI:Color() then
            button:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
        end

        local text = button:CreateFontString(nil, "OVERLAY")
        text:SetFont(fontPath, 12, "OUTLINE")
        text:SetPoint("CENTER")
        text:SetTextColor(classColor.r, classColor.g, classColor.b)
        text:SetText(direction == "up" and "^" or "v")
        button.text = text

        button:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b, 1)
        end)

        button:SetScript("OnLeave", function(self)
            if SUI:Color() then
                self:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
            end
        end)

        button:Hide()
        return button
    end

    local function styleTab(tab)
        if not tab then
            return
        end

        accentBackdrop(tab)
        tab:SetHeight(20)

        hideObject(tab.Left)
        hideObject(tab.Middle)
        hideObject(tab.Right)

        if tab.ActiveLeft then
            tab.ActiveLeft:SetTexture(nil)
            tab.ActiveMiddle:SetTexture(nil)
            tab.ActiveRight:SetTexture(nil)
        end

        if tab.HighlightLeft then
            tab.HighlightLeft:SetTexture(nil)
            tab.HighlightMiddle:SetTexture(nil)
            tab.HighlightRight:SetTexture(nil)
        end

        if tab.Text then
            tab.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
            tab.Text:ClearAllPoints()
            tab.Text:SetPoint("CENTER")
        end

        if tab.glow then
            tab.glow:ClearAllPoints()
            tab.glow:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 8, 2)
            tab.glow:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -8, 2)
        end

        if tab.conversationIcon then
            tab.conversationIcon:SetPoint("RIGHT", tab.Text, "LEFT", 0, 0)
        end
    end

    local function styleDockButton(button, symbol, anchor, relativeTo, relativePoint, x, y)
        if not button then
            return
        end

        accentBackdrop(button)
        button:SetSize(20, 20)
        button:SetNormalTexture(0)
        button:SetPushedTexture(0)
        button:SetHighlightTexture(0)

        if not button.suiIcon then
            local text = button:CreateFontString(nil, "OVERLAY")
            text:SetFont(fontPath, 12, "OUTLINE")
            text:SetPoint("CENTER")
            text:SetTextColor(classColor.r, classColor.g, classColor.b)
            button.suiIcon = text
        end

        button.suiIcon:SetText(symbol)
        button:ClearAllPoints()
        button:SetPoint(anchor, relativeTo, relativePoint, x, y)
    end

    local function setupScrollButtons(frame)
        if not frame or frame.suiScrollButtons then
            return
        end

        local upButton = createScrollButton(frame, "up")
        local downButton = createScrollButton(frame, "down")

        downButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
        upButton:SetPoint("BOTTOMRIGHT", downButton, "TOPRIGHT", 0, 4)

        upButton:SetScript("OnClick", function()
            frame:ScrollUp()
        end)

        downButton:SetScript("OnClick", function()
            if frame.ScrollToBottom and frame:AtBottom() then
                frame:ScrollToBottom()
            else
                frame:ScrollDown()
            end
        end)

        frame:EnableMouseWheel(true)
        if not frame.suiMouseWheelHooked then
            frame:HookScript("OnMouseWheel", function(self, delta)
                if delta > 0 then
                    self:ScrollUp()
                else
                    self:ScrollDown()
                end
            end)
            frame.suiMouseWheelHooked = true
        end

        frame:HookScript("OnEnter", function(self)
            if self.suiScrollUpButton then
                self.suiScrollUpButton:Show()
            end
            if self.suiScrollDownButton then
                self.suiScrollDownButton:Show()
            end
        end)

        frame:HookScript("OnLeave", function(self)
            if self.suiScrollUpButton then
                self.suiScrollUpButton:Hide()
            end
            if self.suiScrollDownButton then
                self.suiScrollDownButton:Hide()
            end
        end)

        frame.suiScrollUpButton = upButton
        frame.suiScrollDownButton = downButton
        frame.suiScrollButtons = true
    end

    local function applyChatFont(frame)
        if not frame then
            return
        end

        local _, size = FCF_GetChatWindowInfo(frame:GetID())
        size = math.max(size or 12, 11)
        FCF_SetChatWindowFontSize(nil, frame, size)
        frame:SetFont(fontPath, size, "")
    end

    local function styleChatFrame(frame)
        if not frame or styledFrames[frame] then
            return
        end

        local id = frame:GetID()
        local chatName = frame:GetName()
        if not chatName then
            return
        end

        frame:SetFrameLevel(5)
        frame:SetClampedToScreen(false)
        frame:SetFading(true)

        local editBox = _G[chatName .. "EditBox"]
        if editBox then
            editBox:ClearAllPoints()
            if db.top then
                editBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -7, 25)
                editBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 10, 25)
            else
                editBox:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -7, -5)
                editBox:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 10, -5)
            end

            editBox:SetAltArrowKeyMode(false)
            editBox:Hide()

            if not editBox.suiStyled then
                editBox:HookScript("OnEditFocusGained", function(self)
                    self:Show()
                end)
                editBox:HookScript("OnEditFocusLost", function(self)
                    if self:GetText() == "" then
                        self:Hide()
                    end
                end)
                editBox.suiStyled = true
            end

            local left = _G[chatName .. "EditBoxLeft"]
            local mid = _G[chatName .. "EditBoxMid"]
            local right = _G[chatName .. "EditBoxRight"]
            hideObject(left)
            hideObject(mid)
            hideObject(right)

            local a, b, c = select(6, editBox:GetRegions())
            hideObject(a)
            hideObject(b)
            hideObject(c)

            accentBackdrop(editBox)
        end

        for j = 1, #CHAT_FRAME_TEXTURES do
            local texture = _G[chatName .. CHAT_FRAME_TEXTURES[j]]
            if texture and chatName .. CHAT_FRAME_TEXTURES[j] ~= chatName .. "Background" then
                texture:SetTexture(nil)
            end
        end

        local tab = _G["ChatFrame" .. id .. "Tab"]
        if tab then
            styleTab(tab)
            hideObject(_G["ChatFrame" .. id .. "TabGlow"])

            if tab.conversationIcon then
                tab.conversationIcon:Hide()
            end

            if not tab.suiHideEditHook then
                tab:HookScript("OnClick", function()
                    if editBox then
                        editBox:Hide()
                    end
                end)
                tab.suiHideEditHook = true
            end
        end

        local minimizeButton = _G["ChatFrame" .. id .. "ButtonFrameMinimizeButton"]
        local buttonFrame = _G["ChatFrame" .. id .. "ButtonFrame"]
        if buttonFrame then
            buttonFrame:Show()
            buttonFrame:SetAlpha(1)
        end
        if minimizeButton and tab then
            styleDockButton(minimizeButton, "-", "BOTTOMLEFT", tab, "BOTTOMRIGHT", 1, 0)
        end

        if frame.ScrollBar then
            hideObject(frame.ScrollBar)
            hideObject(frame.ScrollBar.Track)
            hideObject(frame.ScrollBar.Back)
            hideObject(frame.ScrollBar.Forward)
        end

        if frame.ScrollToBottomButton then
            hideObject(frame.ScrollToBottomButton)
        end

        if frame.buttonFrame then
            hideObject(frame.buttonFrame.ScrollToBottomButton)
            hideObject(frame.buttonFrame.ScrollToTopButton)
            hideObject(frame.buttonFrame.upButton)
            hideObject(frame.buttonFrame.downButton)
            hideObject(frame.buttonFrame.bottomButton)
        end

        hideChatFrameBackground(frame)
        createBackdrop(frame)
        setupScrollButtons(frame)
        applyChatFont(frame)

        styledFrames[frame] = true
    end

    local function setupAllChatFrames()
        for i = 1, NUM_CHAT_WINDOWS do
            styleChatFrame(_G["ChatFrame" .. i])
        end

        if QuickJoinToastButton then
            styleDockButton(QuickJoinToastButton, "Q", "TOPRIGHT", ChatFrame1, "TOPRIGHT", 24, 0)
            if QuickJoinToastButton.FriendsButton then
                QuickJoinToastButton.FriendsButton:SetTexture(0)
                QuickJoinToastButton.FriendsButton:Hide()
            end
            if QuickJoinToastButton.QueueButton then
                QuickJoinToastButton.QueueButton:SetTexture(0)
                QuickJoinToastButton.QueueButton:Hide()
            end
        end

        if ChatFrameChannelButton and QuickJoinToastButton then
            styleDockButton(ChatFrameChannelButton, "#", "TOPRIGHT", QuickJoinToastButton, "BOTTOMRIGHT", 0, -1)
            if ChatFrameChannelButton.Icon then
                ChatFrameChannelButton.Icon:SetTexture(0)
            end
        end

        if ChatFrameMenuButton and ChatFrameChannelButton then
            styleDockButton(ChatFrameMenuButton, "M", "TOPRIGHT", ChatFrameChannelButton, "BOTTOMRIGHT", 0, -1)
        end

        if TextToSpeechButton and TextToSpeechButton:GetParent() then
            local parent = TextToSpeechButton:GetParent()
            accentBackdrop(TextToSpeechButton)
            TextToSpeechButton:SetSize(20, 20)
            TextToSpeechButton:ClearAllPoints()
            TextToSpeechButton:SetPoint("TOPRIGHT", ChatFrameMenuButton or ChatFrame1, "BOTTOMRIGHT", 0, -1)
            if TextToSpeechButton.Icon then
                TextToSpeechButton.Icon:SetTexture(0)
            end
            if not TextToSpeechButton.suiIcon then
                local text = TextToSpeechButton:CreateFontString(nil, "OVERLAY")
                text:SetFont(fontPath, 12, "OUTLINE")
                text:SetPoint("CENTER")
                text:SetTextColor(classColor.r, classColor.g, classColor.b)
                text:SetText("T")
                TextToSpeechButton.suiIcon = text
            end
            parent:SetSize(20, 20)
        end
    end

    local function styleTempChat()
        local frame = FCF_GetCurrentChatFrame()
        if frame then
            C_Timer.After(0, function()
                styleChatFrame(frame)
            end)
        end
    end

    local function addLootIcons(_, _, message, ...)
        local function icon(link)
            local texture = GetItemIcon(link)
            return "\124T" .. texture .. ":12:12:0:0:64:64:5:59:5:59\124t" .. link
        end

        message = message:gsub("(\124c%x+\124Hitem:.-\124h\124r)", icon)
        return false, message, ...
    end

    hooksecurefunc("FCF_OpenTemporaryWindow", styleTempChat)
    hooksecurefunc("FCF_SetTemporaryWindowType", function(frame)
        C_Timer.After(0, function()
            styleChatFrame(frame)
        end)
    end)

    setupAllChatFrames()

    if db.looticons then
        ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", AddLootIcons)
    end
end
