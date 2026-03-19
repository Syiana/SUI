local SUIAddon = SUI
local Modules = SUIAddon:NewModule("SUI.Modules.Chat")
local LSM = LibStub("LibSharedMedia-3.0")

local DEFAULT_CHAT_FONT = "Fonts\\FRIZQT__.TTF"

local function resolveSharedChatFont()
    local general = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.general or {}
    local chatSettings = SUIAddon.db and SUIAddon.db.profile and SUIAddon.db.profile.chat and SUIAddon.db.profile.chat.settings
    local chatFont = chatSettings and chatSettings.chat and chatSettings.chat.font or {}
    local fontPath = LSM:Fetch("font", general.font) or general.font or DEFAULT_CHAT_FONT
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

    if not Modules.tempWindowFontHooked then
        hooksecurefunc("FCF_OpenTemporaryWindow", function()
            if Modules:IsEnabled() then
                C_Timer.After(0, function()
                    Modules:UpdateSharedMessageFonts()
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
