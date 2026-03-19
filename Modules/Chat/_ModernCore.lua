local SUIAddon = SUI
local Style = SUIAddon:NewModule("Chat.Modern", "AceHook-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local _G = getfenv(0)
local error = _G.error
local ipairs = _G.ipairs
local m_floor = _G.math.floor
local next = _G.next
local pcall = _G.pcall
local select = _G.select
local s_format = _G.string.format
local t_insert = _G.table.insert
local type = _G.type

local DEFAULT_CHAT_FONT = "Fonts\\FRIZQT__.TTF"
local FRAME_TEXTURE_PARTS = {
    "Center",
    "TopEdge",
    "BottomEdge",
    "LeftEdge",
    "RightEdge",
    "TopLeftCorner",
    "TopRightCorner",
    "BottomLeftCorner",
    "BottomRightCorner"
}
local BUTTON_FRAME_PARTS = {
    "ScrollToBottomButton",
    "ScrollToTopButton",
    "upButton",
    "downButton",
    "bottomButton"
}

local function eachChatFrame(callback)
    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        callback(_G["ChatFrame" .. index], index)
    end
end

local function clearTextureRegion(region)
    if not region then
        return
    end

    region:SetTexture(nil)
    region:Hide()
end

local function clearFrameTextures(frame)
    if not frame then
        return
    end

    for regionIndex = 1, frame:GetNumRegions() do
        local region = select(regionIndex, frame:GetRegions())
        if region and region:GetObjectType() == "Texture" then
            clearTextureRegion(region)
        end
    end
end

local function clearNamedRegions(frame, names)
    if not frame then
        return
    end

    for _, name in ipairs(names) do
        clearTextureRegion(frame[name])
    end
end

local function resolveFontSettings(fontConfig)
    local fontPath = LSM:Fetch("font", SUIAddon.db.profile.general.font) or SUIAddon.db.profile.general.font or DEFAULT_CHAT_FONT
    local fontSize = fontConfig.size or 12
    local fontOutline = fontConfig.outline and "OUTLINE" or ""

    return fontPath, fontSize, fontOutline, fontConfig.shadow
end

local function applyFontStyle(target, fontPath, fontSize, fontOutline, useShadow)
    if not target then
        return
    end

    if target.SetFont then
        target:SetFont(fontPath, fontSize, fontOutline)
    end

    if not target.SetShadowOffset then
        return
    end

    if useShadow then
        target:SetShadowOffset(1, -1)
        target:SetShadowColor(0, 0, 0, 1)
    else
        target:SetShadowOffset(0, 0)
    end
end

local function updateBottomScrollButton(frame, shouldAnimate)
    local button = frame and frame.SUIScrollToBottomButton
    if not button then
        return
    end

    if frame:AtBottom() then
        if shouldAnimate then
            Style:FadeOut(button, 0, 0.2, function()
                button:Hide()
            end)
        else
            button:Hide()
        end
        return
    end

    if button:IsShown() then
        return
    end

    if shouldAnimate then
        button:SetAlpha(0)
        button:Show()
        Style:FadeIn(button, 0.2)
    else
        button:Show()
    end
end

local function attachScrollButton(button, anchor, relativeAnchor)
    button:SetPoint("BOTTOMRIGHT", anchor, relativeAnchor, 0, 4)
    button:SetParent(anchor:GetParent())
    button:SetFrameLevel(anchor:GetParent():GetFrameLevel() + 10)
end

function Style:OnInitialize()
    Style.db = SUIAddon.db.profile.chat.settings
end

----------------------
-- HIDE SCROLLBAR --
----------------------

function Style:HideDefaultScrollbar(chatFrame)
    if not chatFrame then
        return
    end

    for _, framePart in ipairs({"ScrollBar", "ScrollToBottomButton", "ScrollToTopButton", "ResizeButton"}) do
        if chatFrame[framePart] then
            Style:ForceHide(chatFrame[framePart])
        end
    end

    if chatFrame.buttonFrame then
        for _, buttonPart in ipairs(BUTTON_FRAME_PARTS) do
            if chatFrame.buttonFrame[buttonPart] then
                Style:ForceHide(chatFrame.buttonFrame[buttonPart])
            end
        end
    end
end

-------------------------------
-- HIDE CHATFRAME BACKGROUND --
-------------------------------

function Style:HideChatFrameBackground(chatFrame)
    if not chatFrame then
        return
    end

    clearFrameTextures(chatFrame)

    if chatFrame.buttonFrame then
        if chatFrame.buttonFrame.SetBackdrop then
            chatFrame.buttonFrame:SetBackdrop(nil)
        end
        clearFrameTextures(chatFrame.buttonFrame)
    end

    if chatFrame.SetBackdrop then
        chatFrame:SetBackdrop(nil)
    end

    clearNamedRegions(chatFrame, FRAME_TEXTURE_PARTS)
end

-----------------------------
-- ADD CHATFRAME BACKGROUND --
-----------------------------

function Style:AddChatFrameBackground(chatFrame)
    if not chatFrame then
        return
    end

    -- Create a custom backdrop for the chat frame with insets to create padding
    if not chatFrame.SUIBackdrop then
        chatFrame.SUIBackdrop = Style:CreateBackdrop(chatFrame, Style.db.chat.alpha, -4, -4)
    end
end

function Style:UpdateChatBackgroundAlpha()
    local alpha = Style.db.chat.alpha

    eachChatFrame(function(chatFrame)
        if chatFrame and chatFrame.SUIBackdrop then
            chatFrame.SUIBackdrop:UpdateAlpha(alpha)
        end
    end)
end

------------------------------
-- SETUP SCROLL BUTTONS --
------------------------------

function Style:SetupScrollButtons(chatFrame)
    if not chatFrame or chatFrame.SUIScrollButtonsSetup then
        return
    end

    chatFrame.SUIScrollToBottomButton = Style:CreateScrollToBottomButton(chatFrame)
    chatFrame.SUIScrollToBottomButton:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", -4, 4)
    chatFrame.SUIScrollToBottomButton:SetParent(chatFrame)
    chatFrame.SUIScrollToBottomButton:SetFrameLevel(chatFrame:GetFrameLevel() + 10)
    chatFrame.SUIScrollToBottomButton:Hide()

    chatFrame.SUIScrollDownButton = Style:CreateScrollButton(chatFrame, 3)
    attachScrollButton(chatFrame.SUIScrollDownButton, chatFrame.SUIScrollToBottomButton, "TOPRIGHT")

    chatFrame.SUIScrollUpButton = Style:CreateScrollButton(chatFrame, 4)
    attachScrollButton(chatFrame.SUIScrollUpButton, chatFrame.SUIScrollDownButton, "TOPRIGHT")

    chatFrame:HookScript("OnMouseWheel", function(self)
        updateBottomScrollButton(self, false)
    end)

    if not chatFrame.SUIMouseWheelHooked then
        chatFrame:SetScript("OnMouseWheel", function(self, delta)
            if delta > 0 then
                self:ScrollUp()
            else
                self:ScrollDown()
            end

            updateBottomScrollButton(self, true)
        end)
        chatFrame.SUIMouseWheelHooked = true
    end

    chatFrame.ToggleScrollButtons = function(self)
        local shouldShow = Style.db.buttons.up_and_down
        if self.SUIScrollUpButton then
            self.SUIScrollUpButton:SetShown(shouldShow)
        end
        if self.SUIScrollDownButton then
            self.SUIScrollDownButton:SetShown(shouldShow)
        end
        if self.SUIScrollToBottomButton then
            if not shouldShow then
                self.SUIScrollToBottomButton:Hide()
            end
        end
    end

    chatFrame:ToggleScrollButtons()
    chatFrame.SUIScrollButtonsSetup = true
end

---------------------------------
-- UPDATE MESSAGE FONTS --
---------------------------------

function Style:UpdateEditBoxFont()
    eachChatFrame(function(_, index)
        local editBox = _G["ChatFrame" .. index .. "EditBox"]
        if editBox then
            Style:ApplyEditBoxFont(editBox)
        end
    end)
end

function Style:ApplyEditBoxFont(editBox)
    if not editBox then
        return
    end

    local fontPath, fontSize, fontOutline, useShadow = resolveFontSettings(Style.db.edit.font)
    applyFontStyle(editBox, fontPath, fontSize, fontOutline, useShadow)

    local headerElements = {editBox.header, editBox.headerSuffix, editBox.prompt, editBox.NewcomerHint}
    for _, element in ipairs(headerElements) do
        applyFontStyle(element, fontPath, fontSize, fontOutline, useShadow)
    end
end

function Style:ApplyChatFrameFont(chatFrame)
    if not chatFrame then
        return
    end

    local fontPath, fontSize, fontOutline, useShadow = resolveFontSettings(Style.db.chat.font)

    local fontObject = chatFrame:GetFontObject()
    if fontObject then
        applyFontStyle(fontObject, fontPath, fontSize, fontOutline, useShadow)
    end

    if chatFrame.fontStringPool then
        for fontString in chatFrame.fontStringPool:EnumerateActive() do
            applyFontStyle(fontString, fontPath, fontSize, fontOutline, useShadow)
        end
    end
end

function Style:UpdateMessageFonts()
    eachChatFrame(function(chatFrame)
        if chatFrame then
            Style:ApplyChatFrameFont(chatFrame)
        end
    end)
end

function Style:ForMessageLinePool(id, method, ...)
    local chatFrame = _G["ChatFrame" .. id]
    if chatFrame and chatFrame.fontStringPool then
        for fontString in chatFrame.fontStringPool:EnumerateActive() do
            if fontString[method] then
                fontString[method](fontString, ...)
            end
        end
    end
end

local issecretvalue = canaccessvalue and function(v)
    return not canaccessvalue(v)
end or function()
    return false
end

--------------------
-- TEXT PROCESSOR --
--------------------

do
    local TEXT_PROCESSORS = { -- Shorten channel names by removing zone/city suffixes
    function(text)
        -- Helper function to trim whitespace
        local function trim(s)
            return s:match("^%s*(.-)%s*$")
        end

        -- Handle |Hchannel:channel:...|h[number. Trade (Services) - Zone]|h -> |Hchannel:channel:...|h[Services]|h
        text = text:gsub("(|Hchannel:channel:[^|]-|h)%[%d+%. Trade %(([^%)]+)%)%s*%-%s*[^%]]+%](|h)", function(prefix, name, suffix)
            return prefix .. "[" .. trim(name) .. "]" .. suffix
        end)

        -- Handle |Hchannel:channel:...|h[number. ChannelName - Zone]|h -> |Hchannel:channel:...|h[ChannelName]|h
        text = text:gsub("(|Hchannel:channel:[^|]-|h)%[%d+%. ([^%-%]]+)%s*%-%s*[^%]]+%](|h)", function(prefix, name, suffix)
            return prefix .. "[" .. trim(name) .. "]" .. suffix
        end)

        -- Abbreviate Instance/Instance Leader -> [I]
        text = text:gsub("(|Hchannel:INSTANCE_CHAT|h)%[.-%](|h)", "%1[I]%2")

        -- Abbreviate Raid/Raid Leader -> [R]
        text = text:gsub("(|Hchannel:RAID|h)%[.-%](|h)", "%1[R]%2")

        -- Abbreviate Party/Party Leader -> [P]
        text = text:gsub("(|Hchannel:PARTY|h)%[.-%](|h)", "%1[P]%2")

        -- Abbreviate Guild -> [G]
        text = text:gsub("(|Hchannel:GUILD|h)%[.-%](|h)", "%1[G]%2")

        -- Abbreviate Officer -> [G]
        text = text:gsub("(|Hchannel:OFFICER|h)%[.-%](|h)", "%1[G]%2")

        return text
    end}

    function Style:ProcessText(text)
        for _, processor in ipairs(TEXT_PROCESSORS) do
            local isOK, val = pcall(processor, text)
            if isOK then
                text = val
            end
        end

        return text
    end

    function Style:EnableTextProcessing()
        -- Hook AddMessage for all chat frames
        for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame and not chatFrame.SUITextProcessingHooked then
                Style:RawHook(chatFrame, "AddMessage", function(frame, text, ...)
                    if text and type(text) == "string" then
                        text = Style:ProcessText(text)
                    end
                    return Style.hooks[frame].AddMessage(frame, text, ...)
                end, true)
                chatFrame.SUITextProcessingHooked = true
            end
        end
    end
end

------------
-- EVENTS --
------------

do
    local listeners = {}

    function Style:Subscribe(messageType, listener)
        if not listeners[messageType] then
            listeners[messageType] = {}
        end

        t_insert(listeners[messageType], listener)
    end

    function Style:Dispatch(messageType, payload)
        if not listeners[messageType] then
            return
        end

        for _, listener in ipairs(listeners[messageType]) do
            listener(payload)
        end
    end
end

do
    Style.oneTimeEvents = {
        ADDON_LOADED = false,
        PLAYER_LOGIN = false
    }
    Style.registeredEvents = {}

    Style.dispatcher = CreateFrame("Frame", "SUIChatEventFrame")

    function Style:RegisterEvent(event, func)
        if Style.oneTimeEvents[event] then
            error(s_format("Failed to register for '%s' event, already fired!", event), 3)
        end

        if not func or type(func) ~= "function" then
            error(s_format("Failed to register for '%s' event, no handler!", event), 3)
        end

        if not Style.registeredEvents[event] then
            Style.registeredEvents[event] = {}

            Style.dispatcher:RegisterEvent(event)
        end

        Style.registeredEvents[event][func] = true
    end

    function Style:UnregisterEvent(event, func)
        local funcs = Style.registeredEvents[event]

        if funcs and funcs[func] then
            funcs[func] = nil

            if not next(funcs) then
                Style.registeredEvents[event] = nil

                Style.dispatcher:UnregisterEvent(event)
            end
        end
    end

    function Style:EnableDispatcher()
        Style:SecureHookScript(Style.dispatcher, "OnEvent", function(_, event, ...)
            for func in next, Style.registeredEvents[event] do
                func(...)
            end

            if Style.oneTimeEvents[event] == false then
                Style.oneTimeEvents[event] = true
            end
        end)
    end
end

-----------
-- UTILS --
-----------

do
    local hidden = CreateFrame("Frame", nil, UIParent)
    hidden:Hide()

    function Style:ForceHide(object, skipEvents)
        if not object then
            return
        end

        object:Hide(true)
        object:SetParent(hidden)

        if object.EnableMouse then
            object:EnableMouse(false)
        end

        if object.UnregisterAllEvents then
            if not skipEvents then
                object:UnregisterAllEvents()
            end

            if object:GetName() then
                object.ignoreFramePositionManager = true
                object:SetAttribute("ignoreFramePositionManager", true)
            end

            object:SetAttribute("statehidden", true)
        end

        if object.SetUserPlaced then
            pcall(object.SetUserPlaced, object, true)
            pcall(object.SetDontSavePosition, object, true)
        end
    end
end

-----------
-- FADER --
-----------

do
    local function clamp(v)
        if v > 1 then
            return 1
        elseif v < 0 then
            return 0
        end

        return v
    end

    local function outCubic(t, b, c, d)
        t = t / d - 1
        return clamp(c * (t ^ 3 + 1) + b)
    end

    local FADE_IN = 1
    local FADE_OUT = -1

    local objects = {}
    local add, remove

    local updater = CreateFrame("Frame", "SUIChatFader")

    local function updater_OnUpdate(_, elapsed)
        for object, data in next, objects do
            data.fadeTimer = data.fadeTimer + elapsed
            if data.fadeTimer > 0 then
                data.initAlpha = data.initAlpha or object:GetAlpha()

                object:SetAlpha(outCubic(data.fadeTimer, data.initAlpha, data.finalAlpha - data.initAlpha, data.duration))

                if data.fadeTimer >= data.duration then
                    remove(object)

                    if data.callback then
                        data.callback(object)
                        data.callback = nil
                    end

                    object:SetAlpha(data.finalAlpha)
                end
            end
        end
    end

    function add(mode, object, delay, duration, callback)
        local initAlpha = object:GetAlpha()
        local finalAlpha = mode == FADE_IN and 1 or 0

        if delay == 0 and (duration == 0 or initAlpha == finalAlpha) then
            return callback and callback(object)
        end

        objects[object] = {
            mode = mode,
            fadeTimer = -delay,
            -- initAlpha = initAlpha,
            finalAlpha = finalAlpha,
            duration = duration,
            callback = callback
        }

        if not updater:GetScript("OnUpdate") then
            updater:SetScript("OnUpdate", updater_OnUpdate)
        end
    end

    function remove(object)
        objects[object] = nil

        if not next(objects) then
            updater:SetScript("OnUpdate", nil)
        end
    end

    function Style:FadeIn(object, duration, callback, delay)
        if not object then
            return
        end

        add(FADE_IN, object, delay or 0, duration * (1 - object:GetAlpha()), callback)
    end

    function Style:FadeOut(object, ...)
        if not object then
            return
        end

        add(FADE_OUT, object, ...)
    end

    function Style:StopFading(object, alpha)
        if not object then
            return
        end

        remove(object)

        object:SetAlpha(alpha or object:GetAlpha())
    end

    function Style:IsFading(object)
        local data = objects[object]
        if data then
            return data.mode
        end
    end
end

-------------
-- COLOURS --
-------------

do
    local color_proto = {}

    function color_proto:GetHex()
        return self.hex
    end

    -- override ColorMixin:GetRGBA
    function color_proto:GetRGBA(a)
        return self.r, self.g, self.b, a or self.a
    end

    -- override ColorMixin:SetRGBA
    function color_proto:SetRGBA(r, g, b, a)
        if r > 1 or g > 1 or b > 1 then
            r, g, b = r / 255, g / 255, b / 255
        end

        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.hex = s_format('ff%02x%02x%02x', self:GetRGBAsBytes())
    end

    -- override ColorMixin:WrapTextInColorCode
    function color_proto:WrapTextInColorCode(text)
        return "|c" .. self.hex .. text .. "|r"
    end

    function Style:CreateColor(r, g, b, a)
        local color = Mixin({}, ColorMixin, color_proto)
        color:SetRGBA(r, g, b, a)

        return color
    end
end

-----------
-- MATHS --
-----------

function Style:Round(v)
    return m_floor(v + 0.5)
end
