--[[
    SUI 2.0 - Features/Chat/Copy.lua

    A small button on every chat frame opens its history in a copy window,
    laid out like 1.x. Secret (12.x restricted) lines are skipped. The button
    sits inside the Modern backdrop or just outside the Blizzard frame,
    depending on style.
]]

local _, ns = ...
local SUI = ns.SUI
local Chat = ns.Chat

local next, wipe, concat = next, wipe, table.concat
local CanAccess = SUI.Compat.CanAccess

local F = SUI:NewFeature("Chat.Copy", {
    category = "chat",
    toggle = "copy",
})

local TEX = SUI.mediaPath .. [[Textures\Chat\]]
local buttons = {} -- chat frame -> button
local lines = {}
local window, title, box, scroll

local function scrollToEnd()
    scroll:SetVerticalScroll(scroll:GetVerticalScrollRange())
end

local function createWindow()
    window = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    window:SetSize(540, 300)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetBackdrop({
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeSize = 16, tile = true, tileSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    window:SetBackdropColor(0, 0, 0)
    window:Hide()

    title = window:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", 8, -8)
    title:SetFont(STANDARD_TEXT_FONT, 18)
    title:SetTextColor(1, 1, 0)
    title:SetShadowOffset(1, -1)
    title:SetJustifyH("LEFT")

    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, -1)

    box = CreateFrame("EditBox", nil, window)
    box:SetSize(540, 300)
    box:SetMultiLine(true)
    box:SetAutoFocus(false)
    box:SetScript("OnEscapePressed", function()
        window:Hide()
    end)

    scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -30)
    scroll:SetPoint("BOTTOMRIGHT", -30, 8)
    scroll:SetScrollChild(box)
end

local function copyHistory(frame)
    if not window then
        createWindow()
    end
    wipe(lines)
    for i = 1, frame:GetNumMessages() do
        local msg = frame:GetMessageInfo(i)
        if msg and CanAccess(msg) then
            lines[#lines + 1] = msg
        end
    end
    local text = concat(lines, "\n")
    wipe(lines)
    title:SetText(frame.name or frame:GetName() or "Chat")
    box:SetFont(frame:GetFont())
    box:SetMaxLetters(#text + 1)
    box:SetText(text)
    box:HighlightText()
    window:Show()
    C_Timer.After(0, scrollToEnd)
end

local function pressed(button)
    local icon = button:GetNormalTexture()
    icon:ClearAllPoints()
    icon:SetPoint("CENTER", 1, -1)
end

local function released(button)
    local icon = button:GetNormalTexture()
    icon:ClearAllPoints()
    icon:SetPoint("CENTER")
    if button:IsMouseOver() then
        copyHistory(button.chatFrame)
    end
end

function F:Place(button)
    button:ClearAllPoints()
    if self.db.style == "Modern" then
        button:SetPoint("TOPRIGHT", button.chatFrame, "TOPRIGHT", -4, -4)
    else
        button:SetPoint("TOPRIGHT", button.chatFrame, "TOPRIGHT", 10, -5)
    end
end

function F:AddButton(frame)
    local button = buttons[frame]
    if not button then
        button = CreateFrame("Button", nil, frame)
        button.chatFrame = frame
        button:SetSize(20, 20)
        button:SetNormalTexture(TEX .. "copynormal")
        button:GetNormalTexture():SetSize(20, 20)
        button:SetHighlightTexture(TEX .. "copyhighlight")
        button:GetHighlightTexture():SetAllPoints(button:GetNormalTexture())
        button:SetAlpha(0.55)
        button:SetScript("OnMouseDown", pressed)
        button:SetScript("OnMouseUp", released)
        buttons[frame] = button
    end
    self:Place(button)
    button:Show()
end

function F:OnLoad()
    Chat.OnNewFrame(self, "AddButton")
end

function F:OnEnable()
    Chat.EachFrame(self.AddButton, self)
end

function F:OnRefresh()
    for _, button in next, buttons do
        self:Place(button)
    end
end

function F:OnDisable()
    for _, button in next, buttons do
        button:Hide()
    end
    if window then
        window:Hide()
    end
end
