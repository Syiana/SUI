local Module = SUI:NewModule("Chat.Core");

function Module:OnEnable()
    local db = {
        style = SUI.db.profile.chat.style,
        top = SUI.db.profile.chat.top,
        outline = SUI.db.profile.chat.outline,
        module = SUI.db.profile.modules.chat
    }

    if (db.module) then
        ChatFrame1:SetClampRectInsets(0, 0, 0, 0)

        if (db.style == 'Custom') then
            CHAT_FRAME_FADE_TIME = 0.15
            CHAT_FRAME_FADE_OUT_TIME = 1
            CHAT_TAB_HIDE_DELAY = 0
            CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
            CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
            CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
            CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1
            CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
            CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

            local chatFrame = CreateFrame("Frame")
            chatFrame:RegisterEvent("UPDATE_CHAT_WINDOWS")
            chatFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            chatFrame:RegisterEvent("UPDATE_CHAT_COLOR")
            chatFrame:RegisterEvent("UPDATE_CHAT_WINDOWS")
            chatFrame:RegisterEvent("CHAT_MSG_CHANNEL")
            chatFrame:RegisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")
            chatFrame:RegisterEvent("CHAT_MSG_WHISPER")
            chatFrame:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
            chatFrame:RegisterEvent("CHAT_SERVER_DISCONNECTED")
            chatFrame:RegisterEvent("CHAT_SERVER_RECONNECTED")
            chatFrame:RegisterEvent("BN_CONNECTED")
            chatFrame:RegisterEvent("BN_DISCONNECTED")
            chatFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
            chatFrame:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")
            chatFrame:HookScript("OnEvent", function(self, event)
                for _, frameName in pairs(CHAT_FRAMES) do
                    local frame = _G[frameName]
                    local editBox = _G[frameName .. "EditBox"]
                    local editBoxHead = _G[frameName .. "EditBoxHeader"]

                    if (db.outline) then
                        local frameFont, framePath = frame:GetFont()
                        local editBoxFont, editBoxPath = editBox:GetFont()
                        local editBoxHeadFont, editBoxHeadPath = editBoxHead:GetFont()

                        frame:SetFading(1)
                        frame:SetFont(frameFont, framePath, 'THINOUTLINE')
                        editBox:SetFont(editBoxFont, editBoxPath, 'THINOUTLINE')
                        editBoxHead:SetFont(editBoxHeadFont, editBoxHeadPath, 'THINOUTLINE')
                    end

                    Mixin(editBox, BackdropTemplateMixin)
                    editBox:SetBackdrop({
                        bgFile = "Interface\\Buttons\\WHITE8x8",
                        insets = {
                            left = 3, right = 3, top = 2, bottom = 2
                        }
                    })

                    editBox:SetBackdropColor(0, 0, 0, 0.5)
                    CreateBorder(editBox, 11)
                    editBox:SetBorderPadding(-2, -1, -2, -1, -2, -1, -2, -1)
                    --editBox:SetBorderTexture("Interface\\AddOns\\SUI\\Libs\\!Beautycase\\media\\textureNormalWhite")
                    editBox:SetBorderTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border")
                end
            end)

            hooksecurefunc("ChatEdit_UpdateHeader", function(frame)
                local chatType = frame:GetAttribute("chatType")
                if not chatType then return end

                for _, frameName in pairs(CHAT_FRAMES) do
                    local editBox = _G[frameName .. "EditBox"]
                    local info = ChatTypeInfo[chatType]
                    ColorBorder(editBox, info.r, info.g, info.b)
                end
            end)

            BNToastFrame:SetClampedToScreen(true)
            BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)

            ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
            ChatFrameMenuButton:Hide()



            local frames = {}

            local function ProcessFrame(frame)
                if frames[frame] then
                    return
                end

                frame:SetClampRectInsets(0, 0, 0, 0)
                --frame:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
                --frame:SetMinResize(250, 100)

                local name = frame:GetName()
                --_G[name .. "ButtonFrame"]:Hide()
                _G[name .. "EditBoxLeft"]:Hide()
                _G[name .. "EditBoxMid"]:Hide()
                _G[name .. "EditBoxRight"]:Hide()

                local editbox = _G[name .. "EditBox"]
                editbox:ClearAllPoints()
                if (db.top) then
                    editbox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -7, 25)
                    editbox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, 25)
                end

                if (not db.top) then
                    editbox:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", -7, -5)
                    editbox:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMRIGHT", 10, -5)
                end
                editbox:SetAltArrowKeyMode(false)

                local cf = _G[name]

                local s2bb = cf["ScrollToBottomButton"]
                s2bb:Hide()
                s2bb.Show = function()
                end

                cf:EnableMouse(1)
                ChatFrameChannelButton:EnableMouse(1)
                ChatFrameChannelButton:SetAlpha(0)

                _G[name .. "ButtonFrameUpButton"]:EnableMouse(1)
                _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)

                _G[name .. "ButtonFrameDownButton"]:EnableMouse(1)
                _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)

                _G[name .. "ButtonFrameBottomButton"]:EnableMouse(1)
                _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)

                cf:SetScript("OnEnter", function()
                    ChatFrameChannelButton:SetAlpha(0.8)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0.8)
                end)
                cf:SetScript("OnLeave", function()
                    ChatFrameChannelButton:SetAlpha(0)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)
                end)

                ChatFrameChannelButton:SetScript("OnEnter", function()
                    ChatFrameChannelButton:SetAlpha(0.8)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0.8)
                end)
                ChatFrameChannelButton:SetScript("OnLeave", function()
                    ChatFrameChannelButton:SetAlpha(0)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)
                end)

                _G[name .. "ButtonFrameUpButton"]:SetScript("OnEnter", function()
                    ChatFrameChannelButton:SetAlpha(0.8)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0.8)
                end)

                _G[name .. "ButtonFrameUpButton"]:SetScript("OnLeave", function()
                    ChatFrameChannelButton:SetAlpha(0)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)
                end)

                _G[name .. "ButtonFrameDownButton"]:SetScript("OnEnter", function()
                    ChatFrameChannelButton:SetAlpha(0.8)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0.8)
                end)

                _G[name .. "ButtonFrameDownButton"]:SetScript("OnLeave", function()
                    ChatFrameChannelButton:SetAlpha(0)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)
                end)

                _G[name .. "ButtonFrameBottomButton"]:SetScript("OnEnter", function()
                    ChatFrameChannelButton:SetAlpha(0.8)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0.8)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0.8)
                end)

                _G[name .. "ButtonFrameBottomButton"]:SetScript("OnLeave", function()
                    ChatFrameChannelButton:SetAlpha(0)
                    _G[name .. "ButtonFrameUpButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameDownButton"]:SetAlpha(0)
                    _G[name .. "ButtonFrameBottomButton"]:SetAlpha(0)
                end)

                frames[frame] = true
            end

            for i = 1, NUM_CHAT_WINDOWS do
                ProcessFrame(_G["ChatFrame" .. i])
                local chatWindowName = _G["ChatFrame" .. i]:GetName()
                local chatTab = _G[chatWindowName .. "Tab"]
                _G[chatWindowName .. "TabLeft"]:SetTexture(nil)
                _G[chatWindowName .. "TabMiddle"]:SetTexture(nil)
                _G[chatWindowName .. "TabRight"]:SetTexture(nil)
                _G[chatWindowName .. "TabSelectedLeft"]:SetTexture(nil)
                _G[chatWindowName .. "TabSelectedMiddle"]:SetTexture(nil)
                _G[chatWindowName .. "TabSelectedRight"]:SetTexture(nil)
                chatTab:SetAlpha(1.0)
            end

            local faneifyTab = function(frame, sel)
                local i = frame:GetID()

                if (not frame.Fane) then
                    frame.leftTexture:Hide()
                    frame.middleTexture:Hide()
                    frame.rightTexture:Hide()

                    frame.leftSelectedTexture:Hide()
                    frame.middleSelectedTexture:Hide()
                    frame.rightSelectedTexture:Hide()

                    frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
                    frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
                    frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

                    frame.Fane = true
                end
            end

            hooksecurefunc("FCFTab_UpdateColors", faneifyTab)
            for i = 1, 7 do
                faneifyTab(_G["ChatFrame" .. i .. "Tab"])
            end

            local old_OpenTemporaryWindow = FCF_OpenTemporaryWindow
            FCF_OpenTemporaryWindow = function(...)
                local frame = old_OpenTemporaryWindow(...)
                ProcessFrame(frame)
                return frame
            end

            function FloatingChatFrame_OnMouseScroll(self, delta)
                if delta > 0 then
                    if IsShiftKeyDown() then
                        self:ScrollToTop()
                    else
                        self:ScrollUp()
                    end
                elseif delta < 0 then
                    if IsShiftKeyDown() then
                        self:ScrollToBottom()
                    else
                        self:ScrollDown()
                    end
                end
            end
        end
    end
end
