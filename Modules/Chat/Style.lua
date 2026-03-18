local SUIAddon = SUI
local Style = SUIAddon:GetModule("SUI.Modules.Chat.Style")

-- Store chat frame references at module level for config updates
local chatFrames = {}
local tempChatFrames = {}

function Style:UpdateAllScrollButtons()
    -- Update scroll buttons on all static chat frames
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame and chatFrame.ToggleScrollButtons then
            chatFrame:ToggleScrollButtons()
        end
    end

    -- Update scroll buttons on all temporary chat frames
    for frame in next, tempChatFrames do
        if frame and frame.ToggleScrollButtons then
            frame:ToggleScrollButtons()
        end
    end
end

function Style:OnEnable()
    if not SUIAddon.db or not SUIAddon.db.profile or not SUIAddon.db.profile.chat then
        return
    end

    if SUIAddon.db.profile.chat.style ~= "Modern" then
        return
    end

    Style.db = SUIAddon.db.profile.chat.settings

    -- Disable Altkeys for EditBox
    ChatFrame1EditBox:SetAltArrowKeyMode(false)

    -- Create Fonts
    -- Style:CreateFonts()

    -- Handle Dock
    Style:HandleDock(GeneralDockManager)

    -- static chat frames
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local frame = _G["ChatFrame" .. i]
        if frame then
            chatFrames[frame] = true

            -- Set fading based on config
            frame:SetFading(Style.db.fade.enabled)
            if Style.db.fade.enabled then
                frame:SetTimeVisible(Style.db.fade.out_delay)
            end
        end

        Style:HandleChatTab(_G["ChatFrame" .. i .. "Tab"])
        Style:HandleEditBox(_G["ChatFrame" .. i .. "EditBox"])
        Style:HandleMinimizeButton(_G["ChatFrame" .. i .. "ButtonFrameMinimizeButton"], _G["ChatFrame" .. i .. "Tab"])
        Style:HideDefaultScrollbar(_G["ChatFrame" .. i])
        Style:HideChatFrameBackground(_G["ChatFrame" .. i])
        Style:AddChatFrameBackground(_G["ChatFrame" .. i])
        Style:SetupScrollButtons(_G["ChatFrame" .. i])

        if i == 1 then
            Style:HandleQuickJoinToastButton(QuickJoinToastButton)
            Style:HandleChannelButton(ChatFrameChannelButton)
            Style:HandleMenuButton(ChatFrameMenuButton)
            Style:HandleTTSButton(TextToSpeechButton)
        end
    end

    -- temporary chat frames
    -- FCF_SetTemporaryWindowType always fires with the actual chatFrame, so we hook
    -- it instead of the old two-hook pendingTempFrame relay.
    --
    -- IMPORTANT: FCF_OpenTemporaryWindow calls FCF_DockFrame() AFTER
    -- FCF_SetTemporaryWindowType returns, which triggers FCFDock_UpdateTabs →
    -- FCFTab_UpdateColors + PanelTemplates_TabResize and resets the tab visuals on
    -- top of whatever we applied synchronously. We therefore defer all visual
    -- skinning one frame with C_Timer.After(0) so it always runs AFTER the full
    -- FCF_OpenTemporaryWindow call stack has finished.
    Style:SecureHook("FCF_SetTemporaryWindowType", function(chatFrame, chatType, chatTarget)
        -- Non-visual setup can happen immediately.
        chatFrame:SetFading(Style.db.fade.enabled)
        if Style.db.fade.enabled then
            chatFrame:SetTimeVisible(Style.db.fade.out_delay)
        end

        if not chatFrame.SUIHyperlinkHooked then
            chatFrame:SetScript("OnHyperlinkEnter", function(self, link, text, region, left, bottom, width, height)
                if not Style.db.tooltips then
                    return
                end
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(link)
                GameTooltip:Show()
            end)

            chatFrame:SetScript("OnHyperlinkLeave", function(self)
                if not Style.db.tooltips then
                    return
                end
                GameTooltip:Hide()
            end)

            chatFrame.SUIHyperlinkHooked = true
        end

        tempChatFrames[chatFrame] = true

        -- Defer visual skinning so it runs after FCF_DockFrame (and its
        -- FCFDock_UpdateTabs call) has finished overwriting tab state.
        C_Timer.After(0, function()
            if not chatFrame:GetName() then
                return
            end

            Style:HandleChatTab(_G[chatFrame:GetName() .. "Tab"])
            Style:HandleEditBox(_G[chatFrame:GetName() .. "EditBox"])
            Style:HandleMinimizeButton(_G[chatFrame:GetName() .. "ButtonFrameMinimizeButton"], _G[chatFrame:GetName() .. "Tab"])
            Style:HideDefaultScrollbar(chatFrame)
            Style:HideChatFrameBackground(chatFrame)
            Style:AddChatFrameBackground(chatFrame)

            if not chatFrame.SUIScrollButtonsSetup then
                Style:SetupScrollButtons(chatFrame)
            else
                if chatFrame.ToggleScrollButtons then
                    chatFrame:ToggleScrollButtons()
                end
            end

            Style:ApplyChatFrameFont(chatFrame)
            local editBox = _G[chatFrame:GetName() .. "EditBox"]
            if editBox then
                Style:ApplyEditBoxFont(editBox)
            end
        end)
    end)

    -- Disable font size change from right-click menu
    Style:SecureHook("FCF_SetChatWindowFontSize", function(chatFrame, size)
        -- Revert to the configured font size
        C_Timer.After(0, function()
            Style:UpdateMessageFonts()
        end)
    end)

    Style:SecureHook("FCF_MinimizeFrame", function(chatFrame)
        if chatFrame.minFrame then
            Style:HandleMinimizedTab(chatFrame.minFrame)
        end
    end)

    -- Tab and button fading on mouse enter/leave
    if Style.db.dock.fade.enabled then
        Style:SetupTabAndButtonFading()
    end

    -- Enable hyperlink tooltips
    Style:EnableHyperlinkTooltips()

    -- ? consider moving it elsewhere as well
    Style:RegisterEvent("GLOBAL_MOUSE_DOWN", function(button)
        if Style.db.fade.enabled then
            if button == "LeftButton" and Style.db.fade.click then
                for frame in next, chatFrames do
                    if frame:IsShown() and frame:IsMouseOver() and not frame:IsMouseOverHyperlink() then
                        if frame:IsScrolling() then
                            frame:ResetFadingTimer()
                        else
                            frame:FadeInMessages()
                        end
                    end
                end

                for frame in next, tempChatFrames do
                    if frame:IsShown() and frame:IsMouseOver() and not frame:IsMouseOverHyperlink() then
                        if frame:IsScrolling() then
                            frame:ResetFadingTimer()
                        else
                            frame:FadeInMessages()
                        end
                    end
                end
            end
        end
    end)

    -- Re-skin tabs after Blizzard resets their visuals via FCFTab_UpdateColors
    -- (called by FCFDock_UpdateTabs on tab click, dock changes, etc.)
    local isReskinning = false
    Style:SecureHook("FCFTab_UpdateColors", function(tab)
        if isReskinning then
            return
        end
        isReskinning = true
        Style:HandleChatTab(tab)
        isReskinning = false
    end)

    Style:EnableDispatcher()
    Style:EnableDragHook()
    Style:EnableAlerts()
    Style:EnableTextProcessing()

    -- Apply font settings immediately and after a delay to catch initial messages
    Style:UpdateMessageFonts()
    Style:UpdateEditBoxFont()
    C_Timer.After(0.5, function()
        Style:UpdateMessageFonts()
        Style:UpdateEditBoxFont()
    end)
end

function Style:OnDisable()
    Style:UnhookAll()
end

-- Constants for fading
local DOCK_FADE_IN_DURATION = 0.2
local DOCK_FADE_OUT_DURATION = 1.0
local DOCK_FADE_OUT_DELAY = 3.5
local INACTIVE_TAB_ALPHA = 0.5

local function isTabAlerting(chatFrame)
    if not chatFrame then
        return false
    end
    local tab = _G[chatFrame:GetName() .. "Tab"]
    return tab and tab.glow and tab.glow:IsShown()
end

local function isMouseOverDockOrTabs()
    -- Check if mouse is over the dock manager
    if GeneralDockManager:IsMouseOver() then
        return true
    end

    -- Check if mouse is over any tab
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local tab = _G["ChatFrame" .. i .. "Tab"]
        if tab and tab:IsShown() and tab:IsMouseOver() then
            return true
        end
    end

    -- Check if mouse is over any chat frame
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame and chatFrame:IsShown() and chatFrame:IsMouseOver() then
            return true
        end
    end

    -- Check if mouse is over any button frame
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame and chatFrame.buttonFrame and chatFrame.buttonFrame:IsShown() and chatFrame.buttonFrame:IsMouseOver() then
            return true
        end
    end

    return false
end

function Style:SetupTabAndButtonFading()
    local lastDockMouseOver = false

    local function updateTabsAndDockFading()
        local isDockMouseOver = isMouseOverDockOrTabs()

        -- Only update if state changed
        if isDockMouseOver ~= lastDockMouseOver then
            lastDockMouseOver = isDockMouseOver

            if isDockMouseOver then
                -- Mouse is over dock/tabs - show everything
                Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
                Style:StopFading(GeneralDockManager, 1)

                -- Show all tabs and buttons
                for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
                    local chatFrame = _G["ChatFrame" .. i]
                    local tab = _G["ChatFrame" .. i .. "Tab"]

                    if tab and tab:IsShown() then
                        -- Only active tab gets full alpha, inactive tabs get reduced alpha
                        local isActive = chatFrame and chatFrame == SELECTED_DOCK_FRAME
                        local targetAlpha = isActive and 1 or INACTIVE_TAB_ALPHA

                        Style:FadeIn(tab, DOCK_FADE_IN_DURATION)
                        Style:StopFading(tab, targetAlpha)
                    end

                    if chatFrame and chatFrame.buttonFrame then
                        Style:FadeIn(chatFrame.buttonFrame, DOCK_FADE_IN_DURATION)
                        Style:StopFading(chatFrame.buttonFrame, 1)
                    end
                end
            else
                -- Mouse left - fade out everything except alerting tabs
                -- Collect all elements to fade them simultaneously
                local elementsToFade = {}

                -- Add dock manager
                table.insert(elementsToFade, GeneralDockManager)

                -- Add tabs and button frames
                for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
                    local chatFrame = _G["ChatFrame" .. i]
                    local tab = _G["ChatFrame" .. i .. "Tab"]

                    -- Only add tabs that are not alerting
                    if tab and tab:IsShown() and not isTabAlerting(chatFrame) then
                        table.insert(elementsToFade, tab)
                    elseif tab and isTabAlerting(chatFrame) then
                        -- Keep alerting tabs visible at appropriate alpha
                        local isActive = chatFrame and chatFrame == SELECTED_DOCK_FRAME
                        local targetAlpha = isActive and 1 or INACTIVE_TAB_ALPHA
                        Style:StopFading(tab, targetAlpha)
                    end

                    if chatFrame and chatFrame.buttonFrame then
                        table.insert(elementsToFade, chatFrame.buttonFrame)
                    end
                end

                -- Fade all elements at the same time
                for _, element in ipairs(elementsToFade) do
                    Style:FadeOut(element, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                end
            end
        end
    end

    local function updateChatFrameScrollButtons(chatFrame)
        if not chatFrame or not chatFrame:IsShown() then
            return
        end

        local isMouseOver = chatFrame:IsMouseOver()
        if isMouseOver ~= chatFrame.SUIIsMouseOver then
            chatFrame.SUIIsMouseOver = isMouseOver

            if isMouseOver then
                -- Fade in scroll buttons when hovering chat frame
                if chatFrame.SUIScrollUpButton then
                    Style:FadeIn(chatFrame.SUIScrollUpButton, DOCK_FADE_IN_DURATION, function()
                        if chatFrame.SUIIsMouseOver then
                            Style:StopFading(chatFrame.SUIScrollUpButton, 1)
                        else
                            Style:FadeOut(chatFrame.SUIScrollUpButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                        end
                    end)
                end

                if chatFrame.SUIScrollDownButton then
                    Style:FadeIn(chatFrame.SUIScrollDownButton, DOCK_FADE_IN_DURATION, function()
                        if chatFrame.SUIIsMouseOver then
                            Style:StopFading(chatFrame.SUIScrollDownButton, 1)
                        else
                            Style:FadeOut(chatFrame.SUIScrollDownButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                        end
                    end)
                end
            else
                -- Fade out scroll buttons
                if chatFrame.SUIScrollUpButton then
                    Style:FadeOut(chatFrame.SUIScrollUpButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                end

                if chatFrame.SUIScrollDownButton then
                    Style:FadeOut(chatFrame.SUIScrollDownButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                end
            end
        end
    end

    -- Set up OnUpdate handler for mouse tracking
    local fadeUpdater = CreateFrame("Frame")
    fadeUpdater:SetScript("OnUpdate", function()
        if not Style.db.dock.fade.enabled then
            return
        end

        -- Update dock and tabs fading (global check)
        updateTabsAndDockFading()

        -- Update scroll buttons for each chat frame
        for frame in next, chatFrames do
            updateChatFrameScrollButtons(frame)
        end

        for frame in next, tempChatFrames do
            updateChatFrameScrollButtons(frame)
        end
    end)

    -- Initial fade-out on load if mouse is not over chat area
    C_Timer.After(0.5, function()
        if not isMouseOverDockOrTabs() then
            -- Collect all elements to fade them simultaneously
            local elementsToFade = {}

            -- Add dock manager
            table.insert(elementsToFade, GeneralDockManager)

            for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
                local chatFrame = _G["ChatFrame" .. i]
                local tab = _G["ChatFrame" .. i .. "Tab"]

                -- Only add tabs that are not alerting
                if tab and tab:IsShown() and not isTabAlerting(chatFrame) then
                    table.insert(elementsToFade, tab)
                end

                if chatFrame and chatFrame.buttonFrame then
                    table.insert(elementsToFade, chatFrame.buttonFrame)
                end

                -- Add scroll buttons if not hovering frame
                if chatFrame and not chatFrame:IsMouseOver() then
                    if chatFrame.SUIScrollUpButton then
                        table.insert(elementsToFade, chatFrame.SUIScrollUpButton)
                    end

                    if chatFrame.SUIScrollDownButton then
                        table.insert(elementsToFade, chatFrame.SUIScrollDownButton)
                    end
                end
            end

            -- Fade all elements at the same time
            for _, element in ipairs(elementsToFade) do
                Style:FadeOut(element, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
            end
        end
    end)
end

function Style:UpdateTabAndButtonFading(enabled)
    if enabled then
        Style:SetupTabAndButtonFading()
    else
        -- Fade in all tabs and buttons when fading is disabled
        for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame then
                local tab = _G["ChatFrame" .. i .. "Tab"]
                if tab then
                    Style:StopFading(tab, 1)
                    tab:SetAlpha(1)
                end

                if chatFrame.buttonFrame then
                    Style:StopFading(chatFrame.buttonFrame, 1)
                    chatFrame.buttonFrame:SetAlpha(1)
                end

                if chatFrame.SUIScrollUpButton then
                    Style:StopFading(chatFrame.SUIScrollUpButton, 1)
                    chatFrame.SUIScrollUpButton:SetAlpha(1)
                end

                if chatFrame.SUIScrollDownButton then
                    Style:StopFading(chatFrame.SUIScrollDownButton, 1)
                    chatFrame.SUIScrollDownButton:SetAlpha(1)
                end
            end
        end

        Style:StopFading(GeneralDockManager, 1)
        GeneralDockManager:SetAlpha(1)
    end
end

function Style:EnableHyperlinkTooltips()
    -- Hook hyperlink events for all chat frames
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            chatFrame:SetScript("OnHyperlinkEnter", function(self, link, text, region, left, bottom, width, height)
                if not Style.db.tooltips then
                    return
                end
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(link)
                GameTooltip:Show()
            end)

            chatFrame:SetScript("OnHyperlinkLeave", function(self)
                if not Style.db.tooltips then
                    return
                end
                GameTooltip:Hide()
            end)
        end
    end
end
