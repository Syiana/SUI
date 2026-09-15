--[[
    SUI 2.0 - Features/Chat/Modern.lua

    The "Modern" chat style: flat backdrops for chat, tabs, edit boxes and
    buttons, a slim tab dock, class coloured icons, SUI scroll buttons,
    configurable fonts and message fading. Tabs and buttons fade out after a
    delay when the mouse leaves; enter/leave hooks drive it and the update
    loop stops as soon as nothing animates. Blizzard's own tab and button
    frame fades are released for styled frames (12.x secret alpha taint). Blizzard's chat art cannot be put
    back live, so switching back to Default asks for a reload.
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
local HOLD_DELAY, HOLD_REPEAT = 0.3, 0.05

local BACKDROP = {
    bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
    edgeFile = TEX .. "border",
    tile = true, tileEdge = true, tileSize = 8, edgeSize = 8,
}

-- Texture coordinates in Chat\icons and Chat\scroll-buttons.
local ICON_MINIMIZE = { 0.25, 0.5, 0, 0.5 }
local ICON_MAXIMIZE = { 0.5, 0.75, 0, 0.5 }
local ICON_OVERFLOW = { 0, 0.25, 0, 0.5 }
local SIDE_BUTTONS = {
    QuickJoinToastButton = { 0.5, 0.75, 0.5, 1 },
    FriendsMicroButton = { 0.5, 0.75, 0.5, 1 },
    ChatFrameChannelButton = { 0, 0.25, 0.5, 1 },
    ChatFrameMenuButton = { 0.75, 1, 0, 0.5 },
    TextToSpeechButton = { 0.25, 0.5, 0.5, 1 },
}
local SCROLL_BOTTOM = { 0, 52 / 128, 0, 52 / 128 }
local SCROLL_DOWN = { 0, 52 / 128, 52 / 128, 104 / 128 }
local SCROLL_UP = { 52 / 128, 104 / 128, 52 / 128, 104 / 128 }

local TAB_ART = { "Left", "Middle", "Right", "leftTexture", "middleTexture", "rightTexture" }
local EDIT_ART = { "Left", "Mid", "Right", "FocusLeft", "FocusMid", "FocusRight" }
local EDIT_TEXT = { "header", "headerSuffix", "prompt", "NewcomerHint" }
local BUTTON_ART = { "Icon", "FriendsButton", "QueueButton", "FlashingLayer", "Background" }
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

local function placeIcon(texture, coords, left, top, right, bottom)
    texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", left, -top)
    texture:SetPoint("BOTTOMRIGHT", -right, bottom)
    texture:SetVertexColor(classR, classG, classB)
end

local function setIcon(button, file, coords, inset)
    button:SetNormalTexture(file)
    button:SetPushedTexture(file)
    if button.ClearHighlightTexture then
        button:ClearHighlightTexture()
    end
    placeIcon(button:GetNormalTexture(), coords, inset, inset, inset, inset)
    placeIcon(button:GetPushedTexture(), coords, inset + 1, inset + 1, inset - 1, inset - 1)
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
    -- Chat.QuickJoin owns that button's alpha while it is on.
    local quickJoin = F.db.quickjoin and QuickJoinToastButton
    for frame in next, fadeFrames do
        if frame ~= quickJoin then
            frame:SetAlpha(alpha)
        end
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

local function updateBottomButton(frame)
    local set = scrollButtons[frame]
    if set then
        set.bottom:SetShown(not frame:AtBottom())
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
            frame:ScrollToBottom()
            smoothJobs[frame] = nil
            updateBottomButton(frame)
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
    if settings().smooth then
        smoothJobs[frame] = true
        wake()
    else
        frame:ScrollToBottom()
    end
    button:Hide()
end

local function wheelHook(frame)
    if F.enabled then
        smoothJobs[frame] = nil
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
    setIcon(button, TEX .. "scroll-buttons", coords, 3)
    if direction ~= 0 then
        button:SetScript("OnMouseDown", holdStart)
        button:SetScript("OnMouseUp", holdStop)
        button:SetScript("OnHide", holdStop)
        fadeFrames[button] = true
    end
    watchHover(button)
    return button
end

local function skinButton(button, coords)
    if not button or skinned[button] then
        return
    end
    skinned[button] = true
    addBackdrop(button, "dock")
    button:SetSize(20, 20)
    setIcon(button, TEX .. "icons", coords, 1)
    for i = 1, #BUTTON_ART do
        local region = button[BUTTON_ART[i]]
        if region then
            region:SetAlpha(0)
        end
    end
    watchHover(button)
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

local function styleTab(tab, minimized)
    if not tab or skinned[tab] then
        return
    end
    skinned[tab] = true
    for i = 1, #TAB_ART do
        clearTexture(tab[TAB_ART[i]])
    end
    tab:SetHeight(20)
    accent(tab.HighlightLeft or tab.leftHighlightTexture, tab.HighlightMiddle or tab.middleHighlightTexture,
        tab.HighlightRight or tab.rightHighlightTexture, tab)
    addBackdrop(tab, "dock")
    if minimized then
        local name = tab:GetName()
        local maximize = name and _G[name .. "MaximizeButton"]
        skinButton(maximize, ICON_MAXIMIZE)
        return
    end
    accent(tab.ActiveLeft or tab.leftSelectedTexture, tab.ActiveMiddle or tab.middleSelectedTexture,
        tab.ActiveRight or tab.rightSelectedTexture, tab)
    if tab.glow then
        tab.glow:ClearAllPoints()
        tab.glow:SetPoint("BOTTOMLEFT", 8, 2)
        tab.glow:SetPoint("BOTTOMRIGHT", -8, 2)
    end
    watchHover(tab)
    hooksecurefunc(tab, "SetPoint", tabSetPoint)
    reanchor(tab)
    local text = tab.Text
    if text then
        hooksecurefunc(text, "SetPoint", tabTextSetPoint)
        hooksecurefunc(text, "SetTextColor", tabTextSetColor)
        reanchor(text)
        if not tab.selectedColorTable then
            text:SetTextColor(classR, classG, classB)
        end
    end
end

local function styleDock()
    local dock = GeneralDockManager
    if not dock or skinned[dock] then
        return
    end
    skinned[dock] = true
    fadeFrames[dock] = true
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

local function applyFonts()
    local s = settings()
    local font = s.chat.font
    local path, flags = Chat.ResolveFont(font.name, defaultFont), font.outline and "OUTLINE" or ""
    for frame in next, styled do
        setFont(frame, path, font.size, flags, font.shadow)
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
        updateBottomButton(frame)
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
    for i = 1, #SCROLL_ART do
        hide(_G[name .. SCROLL_ART[i]])
    end
    addBackdrop(frame, "chat", -4, -4)
    styleTab(tab)
    styleEditBox(frame)
    tabs[frame] = tab
    if buttonFrame then
        fadeFrames[buttonFrame] = true -- holds the minimize button
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
    bottom:Hide()
    local down = scrollButton(frame, SCROLL_DOWN, -1)
    down:SetPoint("BOTTOMRIGHT", bottom, "TOPRIGHT", 0, 4)
    local up = scrollButton(frame, SCROLL_UP, 1)
    up:SetPoint("BOTTOMRIGHT", down, "TOPRIGHT", 0, 4)
    scrollButtons[frame] = { up = up, down = down, bottom = bottom }

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
            if styled[frame] then
                applyFonts()
            end
        end)
    end
    if FCF_MinimizeFrame then
        self:Hook("FCF_MinimizeFrame", function(frame)
            styleTab(frame.minFrame, true)
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
    -- Selecting a tab changes which one is dimmed; Blizzard also writes tab alpha there.
    for _, fn in next, { "FCFDock_SelectWindow", "FCFTab_UpdateAlpha" } do
        if _G[fn] then
            self:Hook(fn, refreshTabAlpha)
        end
    end
end

function F:OnEnable()
    styleDock()
    for buttonName, coords in next, SIDE_BUTTONS do
        local button = _G[buttonName]
        if button then
            skinButton(button, coords)
            fadeFrames[button] = true
        end
    end
    Chat.EachFrame(self.StyleFrame, self)
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
