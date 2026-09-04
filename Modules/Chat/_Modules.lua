local SUIAddon = SUI
local Modules = SUIAddon:NewModule("SUI.Modules.Chat")
local LSM = LibStub("LibSharedMedia-3.0")
local _G = getfenv(0)

local DEFAULT_CHAT_FONT = (SUIAddon.BlizzardFonts and SUIAddon.BlizzardFonts.chat) or "Fonts\\FRIZQT__.TTF"
local tooltipFrames = setmetatable({}, {__mode = "k"})

local function isDirectFontPath(fontName)
    return type(fontName) == "string" and (fontName:find("\\", 1, true) or fontName:find("/", 1, true))
end

local function getConfiguredFont(fontName, fallback)
    if not fontName or fontName == "Default" then
        return DEFAULT_CHAT_FONT
    end

    if isDirectFontPath(fontName) then
        return fontName
    end

    return LSM:Fetch("font", fontName) or fallback or DEFAULT_CHAT_FONT
end

local function resolveSharedChatFont()
    local chatSettings = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.chat and SUIAddon.db.profile.chat.settings
    local chatFont = chatSettings and chatSettings.chat and chatSettings.chat.font or {}
    local fontPath = getConfiguredFont(chatFont.name, DEFAULT_CHAT_FONT)
    local fontSize = chatFont.size or 12
    local fontOutline = chatFont.outline and "OUTLINE" or ""

    return fontPath, fontSize, fontOutline, chatFont.shadow
end

local function applySharedFontStyle(target, fontPath, fontSize, fontOutline, useShadow)
    if not target then
        return
    end

    if target.SetFont then
        target:SetFont(fontPath, fontSize, fontOutline)
    end

    if target.SetShadowOffset then
        if useShadow then
            target:SetShadowOffset(1, -1)
            target:SetShadowColor(0, 0, 0, 1)
        else
            target:SetShadowOffset(0, 0)
        end
    end
end

local function refreshChatFrameFont(chatFrame, fontPath, fontSize, fontOutline, useShadow)
    if not chatFrame then
        return
    end

    if FCF_SetChatWindowFontSize then
        FCF_SetChatWindowFontSize(nil, chatFrame, fontSize)
    end

    if SUIAddon.ChatFontObject then
        SUIAddon.ChatFontObject:SetFont(fontPath, fontSize, fontOutline)
        if SUIAddon.ChatFontObject.SetShadowOffset then
            if useShadow then
                SUIAddon.ChatFontObject:SetShadowOffset(1, -1)
                SUIAddon.ChatFontObject:SetShadowColor(0, 0, 0, 1)
            else
                SUIAddon.ChatFontObject:SetShadowOffset(0, 0)
            end
        end
        if chatFrame.SetFontObject then
            chatFrame:SetFontObject(SUIAddon.ChatFontObject)
        end
    end

    applySharedFontStyle(chatFrame, fontPath, fontSize, fontOutline, useShadow)

    local fontObject = chatFrame.GetFontObject and chatFrame:GetFontObject()
    if fontObject then
        applySharedFontStyle(fontObject, fontPath, fontSize, fontOutline, useShadow)
    end

    if chatFrame.fontStringPool then
        for fontString in chatFrame.fontStringPool:EnumerateActive() do
            applySharedFontStyle(fontString, fontPath, fontSize, fontOutline, useShadow)
        end
    end

    C_Timer.After(0, function()
        if chatFrame and chatFrame:IsObjectType("ScrollingMessageFrame") then
            if SUIAddon.ChatFontObject and chatFrame.SetFontObject then
                chatFrame:SetFontObject(SUIAddon.ChatFontObject)
            end
            applySharedFontStyle(chatFrame, fontPath, fontSize, fontOutline, useShadow)

            local fontObject = chatFrame.GetFontObject and chatFrame:GetFontObject()
            if fontObject then
                applySharedFontStyle(fontObject, fontPath, fontSize, fontOutline, useShadow)
            end

            if chatFrame.fontStringPool then
                for fontString in chatFrame.fontStringPool:EnumerateActive() do
                    applySharedFontStyle(fontString, fontPath, fontSize, fontOutline, useShadow)
                end
            end
        end
    end)
end

function Modules:OnInitialize()
    Modules.Legacy = SUIAddon:GetModule("Chat.Core", true)
    Modules.Style = SUIAddon:GetModule("Chat.Modern", true)
    Modules.Link = SUIAddon:GetModule("Chat.Url", true)
    Modules.Copy = SUIAddon:GetModule("Chat.Copy", true)
end

function Modules:UpdateSharedMessageFonts()
    if not Modules.db or Modules.db.style == "Default" then
        return
    end

    local fontPath, fontSize, fontOutline, useShadow = resolveSharedChatFont()

    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. index]
        if chatFrame then
            refreshChatFrameFont(chatFrame, fontPath, fontSize, fontOutline, useShadow)
        end
    end
end

function Modules:RestoreDefaultMessageFonts()
    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. index]
        if chatFrame then
            local fontObject = _G.ChatFontNormal
            if fontObject and chatFrame.SetFontObject then
                chatFrame:SetFontObject(fontObject)
            end

            local fontPath, fontSize, fontOutline = fontObject and fontObject:GetFont() or chatFrame:GetFont()
            applySharedFontStyle(chatFrame, fontPath or DEFAULT_CHAT_FONT, fontSize or 12, fontOutline or "", true)
        end
    end
end

function Modules:UpdateSharedChatBackgroundAlpha()
    local alpha = SUIAddon.db.profile.chat.settings.chat.alpha

    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. index]
        if chatFrame then
            local background = _G[chatFrame:GetName() .. "Background"]
            if background then
                background:SetAlpha(alpha)
            end
        end
    end
end

function Modules:EnableSharedTooltips()
    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. index]
        if chatFrame and not tooltipFrames[chatFrame] then
            chatFrame:SetScript("OnHyperlinkEnter", function(owner, link)
                if not SUIAddon.db.profile.chat.settings.tooltips then
                    return
                end

                if type(link) == "string" and link:match("^item:") then
                    return
                end

                GameTooltip:SetOwner(owner, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(link)
                GameTooltip:Show()
            end)

            chatFrame:SetScript("OnHyperlinkLeave", function()
                GameTooltip:Hide()
            end)

            tooltipFrames[chatFrame] = true
        end
    end
end

local function setModuleEnabled(module, enabled)
    if not module then
        return
    end

    if enabled then
        if not module:IsEnabled() then
            module:Enable()
        end
    else
        if module:IsEnabled() then
            module:Disable()
        end
    end
end

function Modules:OnEnable()
    Modules.db = SUIAddon.db.profile.chat

    setModuleEnabled(Modules.Legacy, Modules.db.style == "Custom")
    setModuleEnabled(Modules.Style, Modules.db.style == "Modern")
    setModuleEnabled(Modules.Link, Modules.db.link)
    setModuleEnabled(Modules.Copy, Modules.db.copy)

    if Modules.db.style == "Default" then
        Modules:RestoreDefaultMessageFonts()
    else
        Modules:UpdateSharedMessageFonts()
    end

    if Modules.db.style == "Custom" then
        Modules:UpdateSharedChatBackgroundAlpha()
        Modules:EnableSharedTooltips()
    end

    if not Modules.tempWindowFontHooked then
        hooksecurefunc("FCF_OpenTemporaryWindow", function()
            if Modules:IsEnabled() then
                C_Timer.After(0, function()
                    if Modules.db and Modules.db.style == "Default" then
                        Modules:RestoreDefaultMessageFonts()
                    elseif Modules.db then
                        Modules:UpdateSharedMessageFonts()
                    end
                    if Modules.db and Modules.db.style == "Custom" then
                        Modules:UpdateSharedChatBackgroundAlpha()
                        Modules:EnableSharedTooltips()
                    end
                end)
            end
        end)
        Modules.tempWindowFontHooked = true
    end

    if not Modules.fontEventFrame then
        -- Blizzard reloads its chat window settings on these and puts its own stored
        -- font size back on the frames, which is what made the size look reset after
        -- a login or a /reload.
        local eventFrame = CreateFrame("Frame")
        eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
        eventFrame:RegisterEvent("UPDATE_CHAT_WINDOWS")
        eventFrame:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
        eventFrame:SetScript("OnEvent", function()
            C_Timer.After(0, function()
                if not Modules:IsEnabled() or not Modules.db then
                    return
                end

                if Modules.db.style == "Default" then
                    Modules:RestoreDefaultMessageFonts()
                else
                    Modules:UpdateSharedMessageFonts()
                end
            end)
        end)

        Modules.fontEventFrame = eventFrame
    end
end

function Modules:OnDisable()
    setModuleEnabled(Modules.Legacy, false)
    setModuleEnabled(Modules.Style, false)
    setModuleEnabled(Modules.Link, false)
    setModuleEnabled(Modules.Copy, false)
end
