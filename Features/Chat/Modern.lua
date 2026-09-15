--[[
    SUI 2.0 - Features/Chat/Modern.lua

    The "Modern" chat style: flat backdrops for chat, tabs, edit boxes and
    buttons, a slim tab dock, class coloured icons, SUI scroll buttons,
    configurable fonts and message fading. Tabs and buttons fade out after a
    delay when the mouse leaves; enter/leave hooks drive it and the update
    loop stops as soon as nothing animates. Blizzard's own tab and button
    frame fades are released for styled frames (12.x secret alpha taint).
    Blizzard's chat art cannot be put back live, so switching back to
    Default asks for a reload.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local _G, next, wipe, min, max, floor = _G, next, wipe, math.min, math.max, math.floor
local hooksecurefunc = hooksecurefunc
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Chat.Modern", {
    category = "chat",
    toggle = function(db)
        return db.style == "Modern"
    end,
    reload = true,
})

local TEX = SUI.mediaPath .. [[Textures\Chat\]]
local FADE_IN, FADE_OUT, FADE_DELAY = 0.2, 1, 3.5
local INACTIVE_TAB_ALPHA = 0.5
local HOLD_DELAY, HOLD_REPEAT = 0.3, 0.3

local BACKDROP = {
    bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
    edgeFile = TEX .. "border",
    tile = true, tileEdge = true, tileSize = 8, edgeSize = 8,
}

-- Texture coordinates in Chat\icons and Chat\scroll-buttons.
local ICON_MINIMIZE = { 0.25, 0.5, 0, 0.5 }
local ICON_MAXIMIZE = { 0.5, 0.75, 0, 0.5 }
local ICON_OVERFLOW = { 0, 0.25, 0, 0.5 }
local ICON_FRIENDS = { 0.5, 0.75, 0.5, 1 }
local ICON_CHANNEL = { 0, 0.25, 0.5, 1 }
local ICON_MENU = { 0.75, 1, 0, 0.5 }
local ICON_TTS = { 0.25, 0.5, 0.5, 1 }
local SCROLL_BOTTOM = { 0, 52 / 128, 0, 52 / 128 }
local SCROLL_DOWN = { 0, 52 / 128, 52 / 128, 104 / 128 }
local SCROLL_UP = { 52 / 128, 104 / 128, 52 / 128, 104 / 128 }

local TAB_ART = { "Left", "Middle", "Right", "leftTexture", "middleTexture", "rightTexture" }
local EDIT_ART = { "Left", "Mid", "Right", "FocusLeft", "FocusMid", "FocusRight" }
local EDIT_TEXT = { "header", "headerSuffix", "prompt", "NewcomerHint" }
local SCROLL_ART = { "ButtonFrameUpButton", "ButtonFrameDownButton", "ButtonFrameBottomButton" }

local hiddenParent, defaultFont
local classR, classG, classB = 1, 1, 1
local styled = {}        -- chat frame -> true
local editBoxes = {}     -- edit box -> chat frame
local backdrops = { chat = {}, edit = {}, dock = {} }
local scrollButtons = {} -- chat frame -> { up, down, bottom }
local skinned = {}       -- tabs, buttons, dock -> true
local tabs = {}          -- styled chat frame -> its tab (alpha owned by SUI, see setDockAlpha)
local fadeFrames = {}    -- frames that follow the dock alpha
local guard = false      -- true while SUI re-anchors from inside its own hooks

local function settings()
    return F.db.settings
end

-- Building blocks -----------------------------------------------------------------------
local function addBackdrop(parent, kind, x, y)
    x, y = x or 0, y or 0
    local backdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    backdrop:SetFrameLevel(max(parent:GetFrameLevel() - 1, 0))
    backdrop:SetPoint("TOPLEFT", x, -y)
    backdrop:SetPoint("BOTTOMRIGHT", -x, y)
    backdrop:SetBackdrop(BACKDROP)
    backdrop.Center:ClearAllPoints()
    backdrop.Center:SetPoint("TOPLEFT", backdrop.TopLeftCorner, "BOTTOMRIGHT")
    backdrop.Center:SetPoint("BOTTOMRIGHT", backdrop.BottomRightCorner, "TOPLEFT")
    SUI:ProtectBackdrop(backdrop)
    local alpha = settings()[kind].alpha
    backdrop:SetBackdropColor(0, 0, 0, alpha)
    backdrop:SetBackdropBorderColor(0, 0, 0, alpha)
    local list = backdrops[kind]
    list[#list + 1] = backdrop
end

local function paintBackdrops()
    local s = settings()
    for kind, list in next, backdrops do
        local alpha = s[kind].alpha
        for i = 1, #list do
            list[i]:SetBackdropColor(0, 0, 0, alpha)
            list[i]:SetBackdropBorderColor(0, 0, 0, alpha)
        end
    end
end

local function hide(object)
    if object then
        object:SetParent(hiddenParent)
    end
end

local function clearTexture(texture)
    if texture then
        texture:SetTexture(nil)
    end
end

local function hideTexture(texture)
    if texture then
        texture:SetTexture(nil)
        texture:SetAlpha(0)
        texture:Hide()
    end
end

local function stripTextures(frame)
    if not frame then
        return
    end
    local regions = { frame:GetRegions() }
    for i = 1, #regions do
        if regions[i]:GetObjectType() == "Texture" then
            regions[i]:SetTexture(nil)
        end
    end
end

-- Thin coloured line along the top edge (selected / highlighted state).
local function accent(left, middle, right, anchor)
    if not (left and middle and right) then
        return
    end
    local c = DEFAULT_TAB_SELECTED_COLOR_TABLE
    local r, g, b = c and c.r or 1, c and c.g or 0.5, c and c.b or 0.25
    local file = TEX .. "border-highlight"
    left:ClearAllPoints()
    left:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -2)
    left:SetTexture(file)
    left:SetTexCoord(0, 1, 0.5, 1)
    left:SetSize(8, 8)
    left:SetVertexColor(r, g, b)
    right:ClearAllPoints()
    right:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 0, -2)
    right:SetTexture(file)
    right:SetTexCoord(1, 0, 0.5, 1)
    right:SetSize(8, 8)
    right:SetVertexColor(r, g, b)
    middle:ClearAllPoints()
    middle:SetPoint("TOPLEFT", left, "TOPRIGHT")
    middle:SetPoint("TOPRIGHT", right, "TOPLEFT")
    middle:SetTexture(file)
    middle:SetTexCoord(0, 1, 0, 0.5)
    middle:SetHeight(8)
    middle:SetVertexColor(r, g, b)
end

local function placeIcon(texture, coords, left, top, right, bottom, alpha)
    texture:SetAlpha(alpha)
    texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", left, -top)
    texture:SetPoint("BOTTOMRIGHT", -right, bottom)
    texture:SetVertexColor(classR, classG, classB)
end

local function setIcon(button, file, coords, inset, alpha)
    alpha = alpha or 1
    if button.SetFlattensRenderLayers then
        button:SetFlattensRenderLayers(true)
    end
    button:SetNormalTexture(file)
    button:SetPushedTexture(file)
    if button.ClearHighlightTexture then
        button:ClearHighlightTexture()
    end
    placeIcon(button:GetNormalTexture(), coords, inset, inset, inset, inset, alpha)
    placeIcon(button:GetPushedTexture(), coords, inset + 1, inset + 1, inset - 1, inset - 1, alpha)
    accent(button:CreateTexture(nil, "HIGHLIGHT"), button:CreateTexture(nil, "HIGHLIGHT"), button:CreateTexture(nil, "HIGHLIGHT"), button)
end

-- Dock fading ----------------------------------------------------------------------------
local dockAlpha, dockTarget, dockDelay = 1, 1, 0
local hovered, running = false, false
local smoothJobs = {} -- chat frame -> true while easing to the bottom
local holdButton, holdTime = nil, 0

-- Tab alpha as in 1.x: with tab fading on, the selected tab is opaque and
-- the others dimmed; flashing tabs never fade out. Without fading all are opaque.
local function setTabAlpha(frame, tab, alpha)
    if not (F.enabled and settings().dock.fade.enabled) then
        tab:SetAlpha(1)
        return
    end
    local base = frame == SELECTED_DOCK_FRAME and 1 or INACTIVE_TAB_ALPHA
    if tab.alerting or (tab.glow and tab.glow:IsShown()) then
        tab:SetAlpha(base)
    else
        tab:SetAlpha(base * alpha)
    end
end

local function setDockAlpha(alpha)
    for frame in next, fadeFrames do
        frame:SetAlpha(alpha)
    end
    for frame, tab in next, tabs do
        setTabAlpha(frame, tab, alpha)
    end
end

local function refreshTabAlpha()
    if F.enabled then
        setDockAlpha(dockAlpha)
    end
end

local function hideFaded(button)
    button.fadingOut = nil
    button:Hide()
end

-- Shows or hides the jump-to-bottom button, faded like 1.x unless instant.
local function setBottomShown(button, show, instant, duration)
    if instant then
        SUI:StopFading(button)
        button.fadingOut = nil
        button:SetAlpha(1)
        button:SetShown(show)
    elseif show then
        if button:IsShown() and not button.fadingOut then
            return
        end
        button.fadingOut = nil
        SUI:FadeFrame(button, { mode = "IN", timeToFade = 0.2, startAlpha = 0, endAlpha = 1 })
    elseif button:IsShown() and not button.fadingOut then
        button.fadingOut = true
        SUI:FadeFrame(button, { mode = "OUT", timeToFade = duration or 0.2, startAlpha = 1, endAlpha = 0,
                                finishedFunc = hideFaded, finishedArg1 = button })
    end
end

local function updateBottomButton(frame, instant)
    local set = scrollButtons[frame]
    if set then
        setBottomShown(set.bottom, not frame:AtBottom(), instant)
    end
end

local function step(button)
    local frame = button.chatFrame
    if button.direction > 0 then
        frame:ScrollUp()
    else
        frame:ScrollDown()
    end
    updateBottomButton(frame)
end

local function tick(elapsed)
    local busy = false
    if dockTarget == 1 then
        if dockAlpha < 1 then
            dockAlpha = min(1, dockAlpha + elapsed / FADE_IN)
            setDockAlpha(dockAlpha)
            busy = true
        end
    elseif dockDelay > 0 then
        dockDelay = dockDelay - elapsed
        busy = true
    elseif dockAlpha > 0 then
        dockAlpha = max(0, dockAlpha - elapsed / FADE_OUT)
        setDockAlpha(dockAlpha)
        busy = true
    end

    for frame in next, smoothJobs do
        local offset = frame:GetScrollOffset()
        if offset <= 1 then
            smoothJobs[frame] = nil
            frame:ScrollToBottom()
        else
            frame:SetScrollOffset(floor(offset * 0.6))
            busy = true
        end
    end

    if holdButton then
        holdTime = holdTime - elapsed
        if holdTime <= 0 then
            holdTime = HOLD_REPEAT
            step(holdButton)
        end
        busy = true
    end

    if not busy then
        running = false
        F:StopUpdate()
    end
end

local function wake()
    if not running then
        running = true
        F:StartUpdate(tick)
    end
end

local function reveal()
    hovered = true
    if settings().dock.fade.enabled then
        dockTarget = 1
        wake()
    end
end

local function conceal()
    hovered = false
    if settings().dock.fade.enabled then
        dockTarget, dockDelay = 0, FADE_DELAY
        wake()
    end
end

local function enterHook()
    if F.enabled then
        reveal()
    end
end

local function leaveHook()
    if F.enabled then
        conceal()
    end
end

local hoverHooked = {}
local function watchHover(frame)
    if frame and not hoverHooked[frame] then
        hoverHooked[frame] = true
        frame:HookScript("OnEnter", enterHook)
        frame:HookScript("OnLeave", leaveHook)
    end
end

-- The dock strip and button frames take no mouse input, so hovering their
-- empty space would not reveal the tabs (1.x polled IsMouseOver for that).
-- A motion-only overlay reports enter/leave and lets clicks through.
local function watchArea(frame)
    if not frame or hoverHooked[frame] then
        return
    end
    hoverHooked[frame] = true
    local overlay = CreateFrame("Frame", nil, frame)
    if not overlay.SetMouseMotionEnabled then
        return
    end
    overlay:SetAllPoints(frame)
    overlay:SetFrameLevel(frame:GetFrameLevel())
    overlay:SetMouseMotionEnabled(true)
    overlay:SetMouseClickEnabled(false)
    overlay:SetScript("OnEnter", enterHook)
    overlay:SetScript("OnLeave", leaveHook)
end

-- Blizzard's FCF_OnUpdate fades every chat tab and button frame through the
-- shared FADEFRAMES list and does arithmetic on the alpha it reads back. On
-- 12.x that alpha is secret for objects SUI styles, so Blizzard's fade errors
-- (FrameUtil.lua "startAlpha"). Take the tab and button frame of styled chat
-- frames back out of that list right after Blizzard adds them and set SUI's
-- own alpha instead (setDockAlpha). UIFrameFadeRemoveFrame
-- securecalls the removal, so no taint spreads into FADEFRAMES. (1.x e17487c)
local function releaseNativeFades(frame)
    if not styled[frame] then
        return
    end
    local tab = tabs[frame]
    if tab then
        UIFrameFadeRemoveFrame(tab)
        setTabAlpha(frame, tab, dockAlpha)
    end
    local buttonFrame = frame.buttonFrame
    if buttonFrame then
        UIFrameFadeRemoveFrame(buttonFrame)
        buttonFrame:SetAlpha(dockAlpha)
    end
end

-- Scroll buttons ---------------------------------------------------------------------------
local function holdStart(button)
    step(button)
    holdButton, holdTime = button, HOLD_DELAY
    wake()
end

local function holdStop()
    holdButton = nil
end

local function scrollToBottom(button)
    local frame = button.chatFrame
    setBottomShown(button, false, false, 0.1)
    if settings().smooth then
        smoothJobs[frame] = true
        wake()
    else
        frame:ScrollToBottom()
    end
end

local function wheelHook(frame)
    if F.enabled and not smoothJobs[frame] then
        updateBottomButton(frame)
    end
end

local function scrollButton(frame, coords, direction)
    local button = CreateFrame("Button", nil, frame)
    button.chatFrame = frame
    button.direction = direction
    button:SetSize(24, 24)
    button:SetFrameLevel(frame:GetFrameLevel() + 10)
    addBackdrop(button, "dock")
    setIcon(button, TEX .. "scroll-buttons", coords, 3, 0.8)
    if direction ~= 0 then
        button:SetScript("OnMouseDown", holdStart)
        button:SetScript("OnMouseUp", holdStop)
        button:SetScript("OnHide", holdStop)
        fadeFrames[button] = true
    end
    watchHover(button)
    return button
end

local function clampIcon(texture, owner)
    if texture then
        texture:ClearAllPoints()
        texture:SetPoint("TOPLEFT", owner, "TOPLEFT", 3, -3)
        texture:SetPoint("BOTTOMRIGHT", owner, "BOTTOMRIGHT", -3, 3)
    end
end

local function skinButton(button, coords)
    if not button or skinned[button] then
        return false
    end
    skinned[button] = true
    addBackdrop(button, "dock")
    button:SetSize(20, 20)
    setIcon(button, TEX .. "icons", coords, 1)
    button.highlightAtlas = nil
    clampIcon(button.Icon, button)
    clampIcon(button.IconTexture, button)
    watchHover(button)
    return true
end

-- Side buttons (1.x layout) ----------------------------------------------------------------
local function removeAlertSubsystem(anchor)
    local list = ChatAlertFrame and ChatAlertFrame.alertFrameSubSystems
    for i = list and #list or 0, 1, -1 do
        if list[i].anchorFrame == anchor then
            tremove(list, i)
        end
    end
end

local function friendCountText(button)
    local count = button.FriendCount
    local value = count and tonumber(count:GetText())
    if count and (not value or value > 99) then
        count:SetText("++")
    end
end

local function toastSetPoint(toast, _, relativeTo)
    if guard or not F.enabled or relativeTo ~= QuickJoinToastButton then
        return
    end
    guard = true
    toast:ClearAllPoints()
    toast:SetPoint("BOTTOMLEFT", ChatAlertFrame, "BOTTOMRIGHT", 2, 0)
    guard = false
end

-- QuickJoin (or the classic friends button), channel, menu and text to speech
-- buttons stacked in ChatFrame1's button frame, 1px apart.
local function styleSideButtons()
    local holder = ChatFrame1 and ChatFrame1.buttonFrame
    if not holder then
        return
    end
    local previous

    local quickJoin = QuickJoinToastButton or FriendsMicroButton
    if skinButton(quickJoin, ICON_FRIENDS) then
        removeAlertSubsystem(quickJoin)
        quickJoin:SetParent(holder)
        quickJoin:ClearAllPoints()
        quickJoin:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 2, 0)
        if quickJoin == QuickJoinToastButton then
            quickJoin:SetSize(20, 30)
            local normal, pushed = quickJoin:GetNormalTexture(), quickJoin:GetPushedTexture()
            normal:ClearAllPoints()
            normal:SetPoint("TOPLEFT", quickJoin, "TOPLEFT", 1, -1)
            normal:SetPoint("BOTTOMRIGHT", quickJoin, "TOPLEFT", 19, -19)
            pushed:ClearAllPoints()
            pushed:SetPoint("TOPLEFT", quickJoin, "TOPLEFT", 2, -2)
            pushed:SetPoint("BOTTOMRIGHT", quickJoin, "TOPLEFT", 20, -20)
            hideTexture(quickJoin.FriendsButton)
            hideTexture(quickJoin.QueueButton)
            hideTexture(quickJoin.FlashingLayer)
            for _, toast in next, { quickJoin.Toast, quickJoin.Toast2 } do
                toast:ClearAllPoints()
                toast:SetPoint("TOPLEFT", ChatAlertFrame, "BOTTOMLEFT", 0, -2)
            end
            ChatAlertFrame:ClearAllPoints()
            ChatAlertFrame:SetPoint("BOTTOMLEFT", holder, "TOPRIGHT", -18, 56)
        end
        local count = quickJoin.FriendCount or FriendsMicroButtonCount
        if count then
            count:ClearAllPoints()
            count:SetPoint("BOTTOMLEFT", quickJoin, "BOTTOMLEFT", -1.5, 4)
            count:SetPoint("BOTTOMRIGHT", quickJoin, "BOTTOMRIGHT", 2.5, 4)
            count:SetTextColor(classR, classG, classB)
        end
        if quickJoin.QueueCount then
            quickJoin.QueueCount:SetTextColor(classR, classG, classB)
        end
    end
    previous = quickJoin

    local channel = ChatFrameChannelButton
    if skinButton(channel, ICON_CHANNEL) then
        hideTexture(channel.Icon)
        if channel.Flash then
            channel.Flash:ClearAllPoints()
            channel.Flash:SetPoint("TOPLEFT", -3, 3)
            channel.Flash:SetPoint("BOTTOMRIGHT", 3, -3)
        end
    end
    local menu = ChatFrameMenuButton
    skinButton(menu, ICON_MENU)
    local tts = TextToSpeechButton
    local ttsFrame = tts and tts:GetParent()
    if skinButton(tts, ICON_TTS) then
        removeAlertSubsystem(ttsFrame)
        hideTexture(tts.Icon)
        hideTexture(tts.Background)
        tts:ClearAllPoints()
        tts:SetPoint("TOPLEFT", ttsFrame, "TOPLEFT", 0, 0)
        ttsFrame:SetSize(20, 20)
    end

    for _, button in next, { channel, menu, ttsFrame } do
        if button then
            if button:GetParent() ~= holder then
                button:SetParent(holder)
            end
            button:ClearAllPoints()
            if previous then
                button:SetPoint("TOPRIGHT", previous, "BOTTOMRIGHT", 0, -1)
            else
                button:SetPoint("TOPRIGHT", holder, "TOPRIGHT", 2, 0)
            end
            previous = button
        end
    end
end

-- Tabs, dock and buttons -------------------------------------------------------------------
local function tabSetPoint(tab, _, relativeTo)
    if guard or not F.enabled then
        return
    end
    local scroll = GeneralDockManager and GeneralDockManager.scrollFrame
    if scroll and relativeTo == scroll.child then
        guard = true
        tab:ClearAllPoints()
        tab:SetPoint("BOTTOMLEFT", relativeTo, "BOTTOMLEFT", 0, 0)
        guard = false
    end
end

local function tabTextSetPoint(text, point, relativeTo, relativePoint, x, y)
    if guard or not F.enabled or type(relativeTo) == "number" or not CanAccess(point) then
        return
    end
    guard = true
    text:SetPoint(point, relativeTo, relativePoint or point, point == "LEFT" and 8 or (x or 0), point == "CENTER" and 0 or (y or 0))
    guard = false
end

local function tabTextSetColor(text, r, g, b)
    local normal = NORMAL_FONT_COLOR
    if guard or not F.enabled or r ~= normal.r or g ~= normal.g or b ~= normal.b then
        return
    end
    guard = true
    text:SetTextColor(classR, classG, classB)
    guard = false
end

local function reanchor(region)
    local point, relativeTo, relativePoint, x, y = region:GetPoint(1)
    if point and CanAccess(point) then
        region:SetPoint(point, relativeTo, relativePoint, x, y)
    end
end

-- Look that FCFTab_UpdateColors can undo; re-applied from that hook.
local function applyTabLook(tab)
    for i = 1, #TAB_ART do
        clearTexture(tab[TAB_ART[i]])
    end
    tab:SetHeight(20)
    if tab.glow then
        tab.glow:ClearAllPoints()
        tab.glow:SetPoint("BOTTOMLEFT", 8, 2)
        tab.glow:SetPoint("BOTTOMRIGHT", -8, 2)
    end
    accent(tab.ActiveLeft or tab.leftSelectedTexture, tab.ActiveMiddle or tab.middleSelectedTexture,
        tab.ActiveRight or tab.rightSelectedTexture, tab)
    accent(tab.HighlightLeft or tab.leftHighlightTexture, tab.HighlightMiddle or tab.middleHighlightTexture,
        tab.HighlightRight or tab.rightHighlightTexture, tab)
    local text = tab.Text
    if tab.conversationIcon and text then
        tab.conversationIcon:SetPoint("RIGHT", text, "LEFT", 0, 0)
    end
    reanchor(tab)
    if text then
        if not tab.selectedColorTable then
            text:SetTextColor(classR, classG, classB)
        end
        reanchor(text)
    end
end

local function styleTab(tab)
    if not tab or skinned[tab] then
        return
    end
    skinned[tab] = true
    addBackdrop(tab, "dock")
    watchHover(tab)
    hooksecurefunc(tab, "SetPoint", tabSetPoint)
    if tab.Text then
        hooksecurefunc(tab.Text, "SetPoint", tabTextSetPoint)
        hooksecurefunc(tab.Text, "SetTextColor", tabTextSetColor)
    end
    applyTabLook(tab)
end

local function styleMinimizedTab(tab)
    if not tab or skinned[tab] then
        return
    end
    skinned[tab] = true
    addBackdrop(tab, "dock")
    for i = 1, #TAB_ART do
        clearTexture(tab[TAB_ART[i]])
    end
    tab:SetHeight(20)
    if tab.glow then
        tab.glow:ClearAllPoints()
        tab.glow:SetPoint("BOTTOMLEFT", 8, 2)
        tab.glow:SetPoint("BOTTOMRIGHT", -24, 2)
    end
    accent(tab.HighlightLeft or tab.leftHighlightTexture, tab.HighlightMiddle or tab.middleHighlightTexture,
        tab.HighlightRight or tab.rightHighlightTexture, tab)
    local text = tab.Text
    if text then
        hooksecurefunc(text, "SetTextColor", tabTextSetColor)
        if not tab.selectedColorTable then
            text:SetTextColor(classR, classG, classB)
        end
        if tab.conversationIcon then
            tab.conversationIcon:SetPoint("RIGHT", text, "LEFT", 0, 0)
        end
    end
    local name = tab:GetName()
    local maximize = name and _G[name .. "MaximizeButton"]
    if skinButton(maximize, ICON_MAXIMIZE) then
        maximize:ClearAllPoints()
        maximize:SetPoint("BOTTOMLEFT", tab, "BOTTOMRIGHT", 1, 0)
    end
end

local function styleDock()
    local dock = GeneralDockManager
    if not dock or skinned[dock] then
        return
    end
    skinned[dock] = true
    fadeFrames[dock] = true
    watchArea(dock)
    dock:SetHeight(20)
    local scroll = dock.scrollFrame
    if scroll then
        scroll:SetHeight(20)
        if scroll.child then
            scroll.child:SetHeight(20)
        end
        -- Blizzard lifts the tab strip a few pixels; keep it on the bottom edge.
        hooksecurefunc(scroll, "SetPoint", function(frame, point, relativeTo, relativePoint, x, y)
            if guard or not F.enabled or point ~= "BOTTOMRIGHT" or relativeTo ~= dock or y == 0 then
                return
            end
            guard = true
            frame:SetPoint(point, relativeTo, relativePoint, x, 0)
            guard = false
        end)
        scroll:SetPoint("BOTTOMRIGHT", dock, "BOTTOMRIGHT", 0, 0)
    end
    skinButton(dock.overflowButton, ICON_OVERFLOW)
end

local function styleEditBox(frame)
    local box = frame.editBox or _G[frame:GetName() .. "EditBox"]
    if not box or editBoxes[box] then
        return
    end
    editBoxes[box] = frame
    local name = box:GetName()
    for i = 1, #EDIT_ART do
        clearTexture(name and _G[name .. EDIT_ART[i]])
    end
    addBackdrop(box, "edit", 0, 2)
    box:SetAltArrowKeyMode(false)
end

-- Settings -----------------------------------------------------------------------------------
local function setFont(object, path, size, flags, shadow)
    object:SetFont(path, size, flags)
    if object.SetShadowOffset then
        if shadow then
            object:SetShadowOffset(1, -1)
            object:SetShadowColor(0, 0, 0, 1)
        else
            object:SetShadowOffset(0, 0)
        end
    end
end

local writingSize = false

local function applyFonts()
    local s = settings()
    local font = s.chat.font
    local path, flags = Chat.ResolveFont(font.name, defaultFont), font.outline and "OUTLINE" or ""
    for frame in next, styled do
        -- Store SUI's size as Blizzard's window font size, so its menu and
        -- login code agree with it (1.x did the same).
        local _, blizzardSize = GetChatWindowInfo(frame:GetID())
        if FCF_SetChatWindowFontSize and blizzardSize ~= font.size then
            writingSize = true
            FCF_SetChatWindowFontSize(nil, frame, font.size)
            writingSize = false
        end
        local pool = frame.fontStringPool
        if pool then
            for line in pool:EnumerateActive() do
                setFont(line, path, font.size, flags, font.shadow)
            end
        end
    end
    font = s.edit.font
    path, flags = Chat.ResolveFont(font.name, defaultFont), font.outline and "OUTLINE" or ""
    for box in next, editBoxes do
        setFont(box, path, font.size, flags, font.shadow)
        for i = 1, #EDIT_TEXT do
            local text = box[EDIT_TEXT[i]]
            if text then
                setFont(text, path, font.size, flags, font.shadow)
            end
        end
    end
end

local function placeEditBoxes()
    local edit = settings().edit
    local offset = edit.offset
    for box, frame in next, editBoxes do
        box:ClearAllPoints()
        if edit.position == "top" then
            box:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, offset)
            box:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 4, offset)
        else
            box:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -4, -offset)
            box:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -offset)
        end
    end
end

function F:Apply()
    local s = settings()
    paintBackdrops()
    placeEditBoxes()
    applyFonts()
    local showButtons = s.buttons.up_and_down
    for frame, set in next, scrollButtons do
        frame:SetFading(s.fade.enabled)
        frame:SetTimeVisible(s.fade.out_delay)
        set.up:SetShown(showButtons)
        set.down:SetShown(showButtons)
        updateBottomButton(frame, true)
    end
    if not s.dock.fade.enabled then
        dockTarget, dockAlpha = 1, 1
    end
    setDockAlpha(dockAlpha)
end

-- Chat frames ----------------------------------------------------------------------------------
function F:StyleFrame(frame)
    if styled[frame] then
        return
    end
    styled[frame] = true
    local name = frame:GetName()
    local buttonFrame = frame.buttonFrame
    local tab = _G[name .. "Tab"]

    stripTextures(frame)
    stripTextures(buttonFrame)
    hide(frame.ScrollBar)
    hide(frame.ScrollToBottomButton)
    hide(frame.ScrollToTopButton)
    hide(frame.ResizeButton)
    for i = 1, #SCROLL_ART do
        hide(_G[name .. SCROLL_ART[i]])
    end
    addBackdrop(frame, "chat", -4, -4)
    styleTab(tab)
    styleEditBox(frame)
    tabs[frame] = tab
    if buttonFrame then
        fadeFrames[buttonFrame] = true -- holds the minimize and side buttons
        watchArea(buttonFrame)
    end

    local minimize = _G[name .. "ButtonFrameMinimizeButton"] or (buttonFrame and buttonFrame.minimizeButton)
    if minimize and tab then
        skinButton(minimize, ICON_MINIMIZE)
        minimize:ClearAllPoints()
        minimize:SetPoint("BOTTOMLEFT", tab, "BOTTOMRIGHT", 1, 0)
    end

    local bottom = scrollButton(frame, SCROLL_BOTTOM, 0)
    bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
    bottom:SetScript("OnClick", scrollToBottom)
    local down = scrollButton(frame, SCROLL_DOWN, -1)
    down:SetPoint("BOTTOMRIGHT", bottom, "TOPRIGHT", 0, 4)
    local up = scrollButton(frame, SCROLL_UP, 1)
    up:SetPoint("BOTTOMRIGHT", down, "TOPRIGHT", 0, 4)
    scrollButtons[frame] = { up = up, down = down, bottom = bottom }

    setBottomShown(bottom, false, true)
    frame:HookScript("OnMouseWheel", wheelHook)
    if frame.ScrollToBottom then
        hooksecurefunc(frame, "ScrollToBottom", wheelHook)
    end
    watchHover(frame)
    if UIFrameFadeRemoveFrame then
        releaseNativeFades(frame)
    end
end

function F:AddFrame(frame)
    self:StyleFrame(frame)
    self:Apply()
end

-- Lifecycle ------------------------------------------------------------------------------------
function F:OnLoad()
    hiddenParent = CreateFrame("Frame")
    hiddenParent:Hide()
    local _, class = UnitClass("player")
    classR, classG, classB = SUI.Compat.GetClassColor(class)
    defaultFont = ChatFontNormal and ChatFontNormal:GetFont() or STANDARD_TEXT_FONT

    Chat.OnNewFrame(self, "AddFrame")
    -- Blizzard re-applies its per-window font size on login and from the tab menu.
    if FCF_SetChatWindowFontSize then
        self:Hook("FCF_SetChatWindowFontSize", function(_, frame)
            frame = frame or (FCF_GetCurrentChatFrame and FCF_GetCurrentChatFrame())
            if not writingSize and styled[frame] then
                applyFonts()
            end
        end)
    end
    if FCF_MinimizeFrame then
        self:Hook("FCF_MinimizeFrame", function(frame)
            styleMinimizedTab(frame.minFrame)
        end)
    end
    -- A flashing tab (new whisper) keeps the dock visible.
    if UIFrameFadeRemoveFrame then
        if FCF_FadeInChatFrame then
            self:Hook("FCF_FadeInChatFrame", releaseNativeFades)
        end
        if FCF_FadeOutChatFrame then
            self:Hook("FCF_FadeOutChatFrame", releaseNativeFades)
        end
    end
    if FCF_StartAlertFlash then
        self:Hook("FCF_StartAlertFlash", function()
            if settings().dock.fade.enabled then
                dockTarget = 1
                wake()
            end
        end)
    end
    if FCF_StopAlertFlash then
        self:Hook("FCF_StopAlertFlash", function()
            refreshTabAlpha()
            if not hovered then
                conceal()
            end
        end)
    end
    if FCFTab_UpdateColors then
        local refreshing = false
        self:Hook("FCFTab_UpdateColors", function(tab)
            if skinned[tab] and not refreshing then
                refreshing = true
                applyTabLook(tab)
                refreshing = false
            end
        end)
    end
    local quickJoin = QuickJoinToastButton
    if quickJoin then
        if quickJoin.UpdateDisplayedFriendCount then
            self:Hook(quickJoin, "UpdateDisplayedFriendCount", friendCountText)
        end
        if quickJoin.FriendToToastAnim then
            self:HookScript(quickJoin.FriendToToastAnim, "OnPlay", function()
                quickJoin.FriendCount:SetAlpha(0)
            end)
        end
        if quickJoin.ToastToFriendAnim then
            self:HookScript(quickJoin.ToastToFriendAnim, "OnFinished", function()
                quickJoin.FriendCount:SetAlpha(1)
            end)
        end
        for _, toast in next, { quickJoin.Toast, quickJoin.Toast2 } do
            self:Hook(toast, "SetPoint", toastSetPoint)
        end
    end
    -- Selecting a tab changes which one is dimmed; Blizzard also writes tab alpha there.
    for _, fn in next, { "FCFDock_SelectWindow", "FCFTab_UpdateAlpha" } do
        if _G[fn] then
            self:Hook(fn, refreshTabAlpha)
        end
    end
end

function F:OnEnable()
    styleDock()
    Chat.EachFrame(self.StyleFrame, self)
    styleSideButtons()
    self:RegisterEvent("UPDATE_CHAT_WINDOWS", applyFonts)
    self:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS", applyFonts)
    self:Apply()
    conceal()
end

function F:OnRefresh(key)
    self:Apply()
    if key == "settings.dock.fade.enabled" and not hovered then
        conceal()
    end
end

function F:OnDisable()
    running, holdButton = false, nil
    wipe(smoothJobs)
    dockTarget, dockAlpha = 1, 1
    setDockAlpha(1)
end
