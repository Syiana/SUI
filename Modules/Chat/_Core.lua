local Module = SUI:NewModule("Chat.Core");

ChatFrame1:SetClampRectInsets(0, 0, 0, 0)

function Module:OnEnable()
  local db = SUI.db.profile.chat
  if (db) then
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

      for i = 1, 7 do
        _G["ChatFrame" .. i]:SetFading(1)
      end

      BNToastFrame:SetClampedToScreen(true)
      BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)

      ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
      ChatFrameMenuButton:Hide()

      QuickJoinToastButton:Hide()
      QuickJoinToastButton.Show = function()
      end

      local frames = {}

      local function ProcessFrame(frame)
          if frames[frame] then
              return
          end

          frame:SetClampRectInsets(0, 0, 0, 0)
          frame:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
          frame:SetMinResize(250, 100)

          local name = frame:GetName()
          _G[name .. "ButtonFrame"]:Hide()
          _G[name .. "EditBoxLeft"]:Hide()
          _G[name .. "EditBoxMid"]:Hide()
          _G[name .. "EditBoxRight"]:Hide()

          local editbox = _G[name .. "EditBox"]
          editbox:ClearAllPoints()
          if (db.top) then
            editbox:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -7, 25)
            editbox:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 10, 25)
          end
          editbox:SetAltArrowKeyMode(false)

          local cf = _G[name]

          local tt = _G[name .. "ThumbTexture"]
          tt:Hide()
          tt.Show = function()
          end

          local sb = cf["ScrollBar"]
          sb:Hide()
          sb.Show = function()
          end

          local s2bb = cf["ScrollToBottomButton"]
          s2bb:Hide()
          s2bb.Show = function()
          end

          cf:EnableMouse(1)
          ChatFrameChannelButton:EnableMouse(1)
          ChatFrameToggleVoiceDeafenButton:EnableMouse(1)
          ChatFrameToggleVoiceMuteButton:EnableMouse(1)
          ChatFrameChannelButton:SetAlpha(0)
          ChatFrameToggleVoiceDeafenButton:SetAlpha(0)
          ChatFrameToggleVoiceMuteButton:SetAlpha(0)

          cf:SetScript("OnEnter", function(self)
            ChatFrameChannelButton:SetAlpha(0.8)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0.8)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0.8)
          end)
          cf:SetScript("OnLeave", function(self)
            ChatFrameChannelButton:SetAlpha(0)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0)
          end)

          ChatFrameChannelButton:SetScript("OnEnter", function(self)
            ChatFrameChannelButton:SetAlpha(0.8)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0.8)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0.8)
          end)
          ChatFrameChannelButton:SetScript("OnLeave", function(self)
            ChatFrameChannelButton:SetAlpha(0)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0)
          end)
          ChatFrameToggleVoiceDeafenButton:SetScript("OnEnter", function(self)
            ChatFrameChannelButton:SetAlpha(0.8)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0.8)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0.8)
          end)
          ChatFrameToggleVoiceDeafenButton:SetScript("OnLeave", function(self)
            ChatFrameChannelButton:SetAlpha(0)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0)
          end)
          ChatFrameToggleVoiceMuteButton:SetScript("OnEnter", function(self)
            ChatFrameChannelButton:SetAlpha(0.8)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0.8)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0.8)
          end)
          ChatFrameToggleVoiceMuteButton:SetScript("OnLeave", function(self)
            ChatFrameChannelButton:SetAlpha(0)
            ChatFrameToggleVoiceDeafenButton:SetAlpha(0)
            ChatFrameToggleVoiceMuteButton:SetAlpha(0)
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