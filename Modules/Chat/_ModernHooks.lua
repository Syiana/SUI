local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

local _G = getfenv(0)
local ipairs = _G.ipairs
local next = _G.next
local pcall = _G.pcall
local t_insert = _G.table.insert

local DOCK_FADE_IN_DURATION = 0.2
local DOCK_FADE_OUT_DURATION = 1.0
local DOCK_FADE_OUT_DELAY = 3.5
local INACTIVE_TAB_ALPHA = 0.5

local staticFrames = setmetatable({}, {__mode = "k"})
local dynamicFrames = setmetatable({}, {__mode = "k"})
local fadeDriver
local dockMouseState = false

local function frameName(frame)
    return frame and frame:GetName()
end

local function getFrameParts(frame)
    local name = frameName(frame)
    if not name then
        return
    end

    return _G[name .. "Tab"], _G[name .. "EditBox"], _G[name .. "ButtonFrameMinimizeButton"]
end

local function eachKnownFrame(handler)
    for frame in next, staticFrames do
        handler(frame, false)
    end

    for frame in next, dynamicFrames do
        handler(frame, true)
    end
end

local function setupTooltip(frame)
    if not frame or frame.SUITooltipBound then
        return
    end

    frame:SetScript("OnHyperlinkEnter", function(owner, link)
        if not Style.db.tooltips then
            return
        end

        GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
        local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, link)
        if ok then
            GameTooltip:Show()
        else
            GameTooltip:Hide()
        end
    end)

    frame:SetScript("OnHyperlinkLeave", function()
        GameTooltip:Hide()
    end)

    frame.SUITooltipBound = true
end

local function configureFade(frame)
    if not frame then
        return
    end

    frame:SetFading(Style.db.fade.enabled)
    if Style.db.fade.enabled then
        frame:SetTimeVisible(Style.db.fade.out_delay)
    end
end

local function trackFrame(frame, isDynamic)
    if not frame then
        return
    end

    if isDynamic then
        dynamicFrames[frame] = true
    else
        staticFrames[frame] = true
    end

    configureFade(frame)
    setupTooltip(frame)
end

local function refreshFrame(frame)
    if not frame then
        return
    end

    local tab, editBox, minimizeButton = getFrameParts(frame)
    if not tab then
        return
    end

    Style:HandleChatTab(tab)
    Style:HandleEditBox(editBox)
    Style:HandleMinimizeButton(minimizeButton, tab)
    Style:HideDefaultScrollbar(frame)
    Style:HideChatFrameBackground(frame)
    Style:AddChatFrameBackground(frame)

    if frame.SUIScrollButtonsSetup then
        frame:ToggleScrollButtons()
    else
        Style:SetupScrollButtons(frame)
    end

    Style:ApplyChatFrameFont(frame)
    Style:ApplyEditBoxFont(editBox)
end

local function activeTabAlpha(chatFrame)
    return chatFrame == SELECTED_DOCK_FRAME and 1 or INACTIVE_TAB_ALPHA
end

local function tabForFrame(frame)
    local name = frameName(frame)
    return name and _G[name .. "Tab"] or nil
end

local function isAlerting(frame)
    local tab = tabForFrame(frame)
    return tab and tab.glow and tab.glow:IsShown() or false
end

local function addDockElements(target)
    t_insert(target, GeneralDockManager)

    eachKnownFrame(function(frame)
        local tab = tabForFrame(frame)
        if tab and tab:IsShown() and not isAlerting(frame) then
            t_insert(target, tab)
        elseif tab and tab:IsShown() then
            Style:StopFading(tab, activeTabAlpha(frame))
        end

        if frame.buttonFrame then
            t_insert(target, frame.buttonFrame)
        end
    end)
end

local function fadeElements(elements, mode)
    for _, element in ipairs(elements) do
        if mode == "out" then
            Style:FadeOut(element, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
        else
            Style:FadeIn(element, DOCK_FADE_IN_DURATION)
        end
    end
end

local function revealDock()
    Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
    Style:StopFading(GeneralDockManager, 1)

    eachKnownFrame(function(frame)
        local tab = tabForFrame(frame)
        if tab and tab:IsShown() then
            Style:FadeIn(tab, DOCK_FADE_IN_DURATION)
            Style:StopFading(tab, activeTabAlpha(frame))
        end

        if frame.buttonFrame then
            Style:FadeIn(frame.buttonFrame, DOCK_FADE_IN_DURATION)
            Style:StopFading(frame.buttonFrame, 1)
        end
    end)
end

local function concealDock()
    local elements = {}
    addDockElements(elements)
    fadeElements(elements, "out")
end

local function syncFrameButtons(frame)
    if not frame or not frame:IsShown() then
        return
    end

    local hovering = frame:IsMouseOver()
    if hovering == frame.SUIHoveringButtons then
        return
    end

    frame.SUIHoveringButtons = hovering

    local buttons = {frame.SUIScrollUpButton, frame.SUIScrollDownButton}
    if hovering then
        for _, button in ipairs(buttons) do
            if button then
                Style:FadeIn(button, DOCK_FADE_IN_DURATION)
                Style:StopFading(button, 1)
            end
        end
        return
    end

    for _, button in ipairs(buttons) do
        if button then
            Style:FadeOut(button, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
        end
    end
end

local function dockIsHovered()
    if GeneralDockManager:IsMouseOver() then
        return true
    end

    local hovered = false
    eachKnownFrame(function(frame)
        if hovered then
            return
        end

        local tab = tabForFrame(frame)
        hovered = (tab and tab:IsShown() and tab:IsMouseOver()) or (frame:IsShown() and frame:IsMouseOver()) or
            (frame.buttonFrame and frame.buttonFrame:IsShown() and frame.buttonFrame:IsMouseOver()) or false
    end)

    return hovered
end

local function startFadeDriver()
    if fadeDriver then
        return
    end

    fadeDriver = CreateFrame("Frame")
    fadeDriver:SetScript("OnUpdate", function()
        if not Style.db.dock.fade.enabled then
            return
        end

        local hovering = dockIsHovered()
        if hovering ~= dockMouseState then
            dockMouseState = hovering
            if hovering then
                revealDock()
            else
                concealDock()
            end
        end

        eachKnownFrame(function(frame)
            syncFrameButtons(frame)
        end)
    end)
end

local function stopFadeDriver()
    if not fadeDriver then
        return
    end

    fadeDriver:SetScript("OnUpdate", nil)
    fadeDriver = nil
end

local function clearTrackedFrames()
    for frame in next, staticFrames do
        staticFrames[frame] = nil
    end

    for frame in next, dynamicFrames do
        dynamicFrames[frame] = nil
    end
end

local function applyInitialDockFade()
    C_Timer.After(0.5, function()
        if dockIsHovered() then
            return
        end

        local elements = {}
        addDockElements(elements)

        eachKnownFrame(function(frame)
            if frame:IsMouseOver() then
                return
            end

            if frame.SUIScrollUpButton then
                t_insert(elements, frame.SUIScrollUpButton)
            end

            if frame.SUIScrollDownButton then
                t_insert(elements, frame.SUIScrollDownButton)
            end
        end)

        fadeElements(elements, "out")
    end)
end

local function refreshFonts()
    Style:UpdateMessageFonts()
    Style:UpdateEditBoxFont()
end

local function enableTemporaryFrames()
    Style:SecureHook("FCF_SetTemporaryWindowType", function(frame)
        trackFrame(frame, true)
        C_Timer.After(0, function()
            refreshFrame(frame)
        end)
    end)
end

local function enableStaticFrames()
    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local frame = _G["ChatFrame" .. index]
        if frame then
            trackFrame(frame, false)
            refreshFrame(frame)
        end

        if index == 1 then
            Style:HandleQuickJoinToastButton(QuickJoinToastButton)
            Style:HandleChannelButton(ChatFrameChannelButton)
            Style:HandleMenuButton(ChatFrameMenuButton)
            Style:HandleTTSButton(TextToSpeechButton)
        end
    end
end

function Style:UpdateAllScrollButtons()
    eachKnownFrame(function(frame)
        if frame.ToggleScrollButtons then
            frame:ToggleScrollButtons()
        end
    end)
end

function Style:OnEnable()
    if not SUIAddon.db or not SUIAddon.db.profile or not SUIAddon.db.profile.chat then
        return
    end

    if SUIAddon.db.profile.chat.style ~= "Modern" then
        return
    end

    Style.db = SUIAddon.db.profile.chat.settings
    ChatFrame1EditBox:SetAltArrowKeyMode(false)

    Style:HandleDock(GeneralDockManager)
    enableStaticFrames()
    enableTemporaryFrames()

    Style:SecureHook("FCF_SetChatWindowFontSize", function()
        C_Timer.After(0, refreshFonts)
    end)

    Style:SecureHook("FCF_MinimizeFrame", function(frame)
        if frame.minFrame then
            Style:HandleMinimizedTab(frame.minFrame)
        end
    end)

    if Style.db.dock.fade.enabled then
        startFadeDriver()
        applyInitialDockFade()
    end

    Style:RegisterEvent("GLOBAL_MOUSE_DOWN", function(button)
        if button ~= "LeftButton" or not Style.db.fade.enabled or not Style.db.fade.click then
            return
        end

        eachKnownFrame(function(frame)
            if not frame:IsShown() or not frame:IsMouseOver() or frame:IsMouseOverHyperlink() then
                return
            end

            if frame:IsScrolling() then
                frame:ResetFadingTimer()
            else
                frame:FadeInMessages()
            end
        end)
    end)

    local lockTabRefresh = false
    Style:SecureHook("FCFTab_UpdateColors", function(tab)
        if lockTabRefresh then
            return
        end

        lockTabRefresh = true
        Style:HandleChatTab(tab)
        lockTabRefresh = false
    end)

    Style:EnableDispatcher()
    Style:EnableDragHook()
    Style:EnableAlerts()
    Style:EnableTextProcessing()

    refreshFonts()
    C_Timer.After(0.5, refreshFonts)
end

function Style:OnDisable()
    stopFadeDriver()
    clearTrackedFrames()
    Style:UnhookAll()
end

function Style:SetupTabAndButtonFading()
    startFadeDriver()
    applyInitialDockFade()
end

function Style:UpdateTabAndButtonFading(enabled)
    if enabled then
        Style:SetupTabAndButtonFading()
        return
    end

    stopFadeDriver()

    eachKnownFrame(function(frame)
        local tab = tabForFrame(frame)
        if tab then
            Style:StopFading(tab, 1)
            tab:SetAlpha(1)
        end

        if frame.buttonFrame then
            Style:StopFading(frame.buttonFrame, 1)
            frame.buttonFrame:SetAlpha(1)
        end

        if frame.SUIScrollUpButton then
            Style:StopFading(frame.SUIScrollUpButton, 1)
            frame.SUIScrollUpButton:SetAlpha(1)
        end

        if frame.SUIScrollDownButton then
            Style:StopFading(frame.SUIScrollDownButton, 1)
            frame.SUIScrollDownButton:SetAlpha(1)
        end
    end)

    Style:StopFading(GeneralDockManager, 1)
    GeneralDockManager:SetAlpha(1)
end
