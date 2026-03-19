local SUIAddon = SUI
local Modules = SUIAddon:NewModule("SUI.Modules.Chat")
local LSM = LibStub("LibSharedMedia-3.0")
local _G = getfenv(0)
local next = _G.next

local DEFAULT_CHAT_FONT = "Fonts\\FRIZQT__.TTF"
local EDIT_BOX_TEXTURES = {"Left", "Mid", "Right", "FocusLeft", "FocusMid", "FocusRight"}
local sharedEditBoxes = setmetatable({}, {__mode = "k"})
local tooltipFrames = setmetatable({}, {__mode = "k"})

local function resolveSharedChatFont()
    local general = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.general or {}
    local chatSettings = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.chat and SUIAddon.db.profile.chat.settings
    local chatFont = chatSettings and chatSettings.chat and chatSettings.chat.font or {}
    local fontPath = LSM:Fetch("font", general.font) or general.font or DEFAULT_CHAT_FONT
    local fontSize = chatFont.size or 12
    local fontOutline = chatFont.outline and "OUTLINE" or ""

    return fontPath, fontSize, fontOutline, chatFont.shadow
end

local function resolveSharedEditFont()
    local general = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.general or {}
    local chatSettings = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.chat and SUIAddon.db.profile.chat.settings
    local editFont = chatSettings and chatSettings.edit and chatSettings.edit.font or {}
    local fontPath = LSM:Fetch("font", general.font) or general.font or DEFAULT_CHAT_FONT
    local fontSize = editFont.size or 12
    local fontOutline = editFont.outline and "OUTLINE" or ""

    return fontPath, fontSize, fontOutline, editFont.shadow
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

local function positionSharedEditBox(editBox)
    if not editBox then
        return
    end

    local settings = SUIAddon.db.profile.chat.settings
    local chatFrame = editBox.chatFrame or editBox:GetParent()
    if not chatFrame then
        return
    end

    editBox:ClearAllPoints()

    if settings.edit.position == "top" then
        editBox:SetPoint("TOPLEFT", chatFrame, "TOPLEFT", -4, settings.edit.offset)
        editBox:SetPoint("TOPRIGHT", chatFrame, "TOPRIGHT", 4, settings.edit.offset)
        return
    end

    editBox:SetPoint("BOTTOMLEFT", chatFrame, "BOTTOMLEFT", -4, -settings.edit.offset)
    editBox:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", 4, -settings.edit.offset)
end

function Modules:OnInitialize()
    Modules.Legacy = SUIAddon:GetModule("Chat.Core", true)
    Modules.Style = SUIAddon:GetModule("Chat.Modern", true)
    Modules.Link = SUIAddon:GetModule("Chat.Url", true)
    Modules.Copy = SUIAddon:GetModule("Chat.Copy", true)
end

function Modules:UpdateSharedMessageFonts()
    local fontPath, fontSize, fontOutline, useShadow = resolveSharedChatFont()

    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. index]
        if chatFrame then
            applySharedFontStyle(chatFrame, fontPath, fontSize, fontOutline, useShadow)

            if chatFrame.fontStringPool then
                for fontString in chatFrame.fontStringPool:EnumerateActive() do
                    applySharedFontStyle(fontString, fontPath, fontSize, fontOutline, useShadow)
                end
            end
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

function Modules:UpdateSharedEditBoxPosition()
    for editBox in next, sharedEditBoxes do
        positionSharedEditBox(editBox)
    end
end

function Modules:UpdateSharedEditBoxAlpha()
    local alpha = SUIAddon.db.profile.chat.settings.edit.alpha

    for editBox in next, sharedEditBoxes do
        if editBox.SUISharedBackdrop then
            editBox.SUISharedBackdrop:UpdateAlpha(alpha)
        end
    end
end

function Modules:UpdateSharedEditBoxFont()
    local fontPath, fontSize, fontOutline, useShadow = resolveSharedEditFont()

    for editBox in next, sharedEditBoxes do
        applySharedFontStyle(editBox, fontPath, fontSize, fontOutline, useShadow)

        for _, element in ipairs({editBox.header, editBox.headerSuffix, editBox.prompt, editBox.NewcomerHint}) do
            applySharedFontStyle(element, fontPath, fontSize, fontOutline, useShadow)
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

function Modules:SetupSharedEditBoxes()
    if not Modules.Style or not Modules.Style.CreateBackdrop then
        return
    end

    for index = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local editBox = _G["ChatFrame" .. index .. "EditBox"]
        if editBox then
            sharedEditBoxes[editBox] = true

            if not editBox.SUISharedBackdrop then
                editBox.SUISharedBackdrop = Modules.Style:CreateBackdrop(editBox, SUIAddon.db.profile.chat.settings.edit.alpha, 0, 2)
            end

            for _, textureName in ipairs(EDIT_BOX_TEXTURES) do
                local texture = _G[editBox:GetName() .. textureName]
                if texture then
                    texture:SetTexture(0)
                end
            end

            positionSharedEditBox(editBox)
        end
    end

    Modules:UpdateSharedEditBoxAlpha()
    Modules:UpdateSharedEditBoxFont()
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
    Modules:UpdateSharedMessageFonts()

    if Modules.db.style ~= "Modern" then
        Modules:SetupSharedEditBoxes()
        Modules:UpdateSharedChatBackgroundAlpha()
        Modules:EnableSharedTooltips()
    end

    if not Modules.tempWindowFontHooked then
        hooksecurefunc("FCF_OpenTemporaryWindow", function()
            if Modules:IsEnabled() then
                C_Timer.After(0, function()
                    Modules:UpdateSharedMessageFonts()
                    if Modules.db and Modules.db.style ~= "Modern" then
                        Modules:SetupSharedEditBoxes()
                        Modules:UpdateSharedChatBackgroundAlpha()
                        Modules:EnableSharedTooltips()
                    end
                end)
            end
        end)
        Modules.tempWindowFontHooked = true
    end
end

function Modules:OnDisable()
    setModuleEnabled(Modules.Legacy, false)
    setModuleEnabled(Modules.Style, false)
    setModuleEnabled(Modules.Link, false)
    setModuleEnabled(Modules.Copy, false)
end
