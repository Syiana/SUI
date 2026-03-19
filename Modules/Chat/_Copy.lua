local Module = SUI:NewModule("Chat.Copy");

local container
local title
local copyBox
local scroll
local chatButtons = {}

local function ensureContainer()
    if container then
        return
    end

    container = CreateFrame("Frame", "SUIChatCopyFrame", UIParent, "BackdropTemplate")
    container:SetSize(540, 300)
    container:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    container:SetFrameStrata("DIALOG")
    container:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeSize = 16,
        tile = true, tileSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    container:SetBackdropColor(0, 0, 0)
    container:Hide()

    title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", 8, -8)
    title:SetFont(STANDARD_TEXT_FONT, 18)
    title:SetTextColor(1, 1, 0)
    title:SetShadowOffset(1, -1)
    title:SetJustifyH("LEFT")

    local closeButton = CreateFrame("Button", nil, container, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 0, -1)

    copyBox = CreateFrame("EditBox", nil, container)
    copyBox:SetSize(540, 300)
    copyBox:SetMultiLine(true)
    copyBox:SetAutoFocus(false)
    copyBox:SetScript("OnEscapePressed", function()
        container:Hide()
    end)

    scroll = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -30)
    scroll:SetPoint("BOTTOMRIGHT", -30, 8)
    scroll:SetScrollChild(copyBox)

    scroll.ScrollBar:SetScript("OnMinMaxChanged", function(self, _, max)
        C_Timer.After(0, function()
            self:SetValue(max)
        end)
    end)
end

local function getChatLines(chatFrame)
    local lines = {}
    for messageIndex = 1, chatFrame:GetNumMessages() do
        lines[messageIndex] = chatFrame:GetMessageInfo(messageIndex)
    end
    return lines
end

local function showChatCopy(chatFrame)
    ensureContainer()

    local lines = getChatLines(chatFrame)
    local text = table.concat(lines, "\n")
    local fontName, fontSize, fontFlags = chatFrame:GetFont()

    title:SetText(chatFrame.name or chatFrame:GetName() or "Chat")
    copyBox:SetFont(fontName, fontSize, fontFlags)
    copyBox:SetMaxLetters(#text + 1)
    copyBox:SetText(text)
    copyBox:HighlightText()

    container:Show()
end

local function updateButtonAlpha(chatFrame)
    local button = chatButtons[chatFrame]
    local tab = _G[chatFrame:GetName() .. "Tab"]
    if button and tab then
        button:SetAlpha(tab:GetAlpha() * 0.55)
    end
end

local function attachCopyButton(chatFrame)
    if not chatFrame or chatButtons[chatFrame] then
        return
    end

    local button = CreateFrame("Button", nil, chatFrame)
    button:SetSize(20, 20)
    button:SetPoint("TOPRIGHT", chatFrame, 15, -5)
    button:SetNormalTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\copynormal")
    button:GetNormalTexture():SetSize(20, 20)
    button:SetHighlightTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\copyhighlight")
    button:GetHighlightTexture():SetAllPoints(button:GetNormalTexture())

    local tab = _G[chatFrame:GetName() .. "Tab"]
    if tab and not tab.SUICopyAlphaHooked then
        hooksecurefunc(tab, "SetAlpha", function()
            updateButtonAlpha(chatFrame)
        end)
        tab.SUICopyAlphaHooked = true
    end

    button:SetScript("OnMouseDown", function(self)
        self:GetNormalTexture():ClearAllPoints()
        self:GetNormalTexture():SetPoint("CENTER", 1, -1)
    end)

    button:SetScript("OnMouseUp", function(self)
        self:GetNormalTexture():ClearAllPoints()
        self:GetNormalTexture():SetPoint("CENTER")
        if self:IsMouseOver() then
            showChatCopy(chatFrame)
        end
    end)

    chatButtons[chatFrame] = button
    updateButtonAlpha(chatFrame)
end

function Module:RefreshButtons()
    for _, chatName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatName]
        if chatFrame then
            attachCopyButton(chatFrame)
            if chatButtons[chatFrame] then
                chatButtons[chatFrame]:Show()
                updateButtonAlpha(chatFrame)
            end
        end
    end
end

function Module:OnEnable()
    if not SUI.db.profile.chat.copy then
        return
    end

    ensureContainer()
    Module:RefreshButtons()

    if not Module.tempWindowHooked then
        hooksecurefunc("FCF_OpenTemporaryWindow", function()
            if Module:IsEnabled() then
                C_Timer.After(0, function()
                    Module:RefreshButtons()
                end)
            end
        end)
        Module.tempWindowHooked = true
    end
end

function Module:OnDisable()
    if container then
        container:Hide()
    end

    for _, button in pairs(chatButtons) do
        button:Hide()
    end
end
