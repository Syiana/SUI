local SUIAddon = SUI
local Style = SUIAddon:GetModule("SUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)
local hooksecurefunc = _G.hooksecurefunc
local next = _G.next

local _, class = UnitClass("player")
local color = RAID_CLASS_COLORS[class]

local function chatTab_SetPoint(self, _, anchor, _, _, _, shouldIgnore)
    if anchor == GeneralDockManager.scrollFrame.child and not shouldIgnore then
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0, true)
    end
end

local function chatTab_OnDragStart(self)
    local frame = _G["ChatFrame" .. self:GetID()]
    if frame then
        frame.isDragging = true
    end
end

local function chatTabText_SetPoint(self, p, anchor, rP, x, y, shouldIgnore)
    if not shouldIgnore then
        self:SetPoint(p, anchor, rP, p == "LEFT" and 8 or x, p == "CENTER" and 0 or y, true)
    end
end

local function chatTabText_SetTextColor(self, r, g, b)
    if r == NORMAL_FONT_COLOR.r and g == NORMAL_FONT_COLOR.g and b == NORMAL_FONT_COLOR.b then
        self:SetTextColor(color.r, color.g, color.b)
    end
end

local handledTabs = {}

local TAB_TEXTURES

TAB_TEXTURES = {"Left", "Middle", "Right" -- "ActiveLeft",
-- "ActiveMiddle",
-- "ActiveRight",
-- "HighlightLeft",
-- "HighlightMiddle",
-- "HighlightRight",
}

function Style:HandleChatTab(frame)
    if not handledTabs[frame] then
        frame.Backdrop = Style:CreateBackdrop(frame, Style.db.dock.alpha)

        Style:SecureHook(frame, "SetPoint", chatTab_SetPoint)
        Style:SecureHookScript(frame, "OnDragStart", chatTab_OnDragStart)
        Style:SecureHook(frame.Text, "SetPoint", chatTabText_SetPoint)
        Style:SecureHook(frame.Text, "SetTextColor", chatTabText_SetTextColor)

        -- Hook tab click to update fonts when switching tabs
        Style:SecureHookScript(frame, "OnClick", function(self)
            C_Timer.After(0, function()
                Style:UpdateMessageFonts()
            end)
        end)

        handledTabs[frame] = true
    end

    for _, texture in next, TAB_TEXTURES do
        frame[texture]:SetTexture(0)
    end

    frame:SetHeight(20)

    frame.glow:ClearAllPoints()
    frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
    frame.glow:SetPoint("BOTTOMRIGHT", -8, 2)

    frame.ActiveLeft:ClearAllPoints()
    frame.ActiveLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
    frame.ActiveLeft:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.ActiveLeft:SetTexCoord(0, 1, 0.5, 1)
    frame.ActiveLeft:SetSize(8, 8)

    frame.ActiveRight:ClearAllPoints()
    frame.ActiveRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
    frame.ActiveRight:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.ActiveRight:SetTexCoord(1, 0, 0.5, 1)
    frame.ActiveRight:SetSize(8, 8)

    frame.ActiveMiddle:ClearAllPoints()
    frame.ActiveMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
    frame.ActiveMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
    frame.ActiveMiddle:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.ActiveMiddle:SetTexCoord(0, 1, 0, 0.5)
    frame.ActiveMiddle:SetSize(8, 8)

    frame.HighlightLeft:ClearAllPoints()
    frame.HighlightLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
    frame.HighlightLeft:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightLeft:SetTexCoord(0, 1, 0.5, 1)
    frame.HighlightLeft:SetSize(8, 8)

    frame.HighlightRight:ClearAllPoints()
    frame.HighlightRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
    frame.HighlightRight:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightRight:SetTexCoord(1, 0, 0.5, 1)
    frame.HighlightRight:SetSize(8, 8)

    frame.HighlightMiddle:ClearAllPoints()
    frame.HighlightMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
    frame.HighlightMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
    frame.HighlightMiddle:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightMiddle:SetTexCoord(0, 1, 0, 0.5)
    frame.HighlightMiddle:SetSize(8, 8)

    if frame.conversationIcon then
        frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
    end

    -- reset the tab
    local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
    if point then
        if relativeTo and type(relativeTo) == "table" then
            frame:SetPoint(point, relativeTo, relativePoint, offsetX or 0, offsetY or 0)
        else
            frame:SetPoint(point, offsetX or 0, offsetY or 0)
        end
    end

    if not frame.selectedColorTable then
        frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end

    -- it can be "CENTER" or "LEFT", so just use the index
    frame.Text:SetPoint(frame.Text:GetPoint())
end

local handledMiniTabs = {}

local MINI_TAB_TEXTURES

MINI_TAB_TEXTURES = {"Left", "Middle", "Right" -- "ActiveLeft",
-- "ActiveMiddle",
-- "ActiveRight",
-- "HighlightLeft",
-- "HighlightMiddle",
-- "HighlightRight",
}

function Style:HandleMinimizedTab(frame)
    if not handledMiniTabs[frame] then
        frame.Backdrop = Style:CreateBackdrop(frame, Style.db.dock.alpha)

        Style:HandleMaximizeButton(_G[frame:GetName() .. "MaximizeButton"])

        Style:SecureHook(frame.Text, "SetTextColor", chatTabText_SetTextColor)

        handledMiniTabs[frame] = true
    end

    for _, texture in next, MINI_TAB_TEXTURES do
        frame[texture]:SetTexture(0)
    end

    frame:SetHeight(20)

    frame.glow:ClearAllPoints()
    frame.glow:SetPoint("BOTTOMLEFT", 8, 2)
    frame.glow:SetPoint("BOTTOMRIGHT", -24, 2)

    frame.HighlightLeft:ClearAllPoints()
    frame.HighlightLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
    frame.HighlightLeft:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightLeft:SetTexCoord(0, 1, 0.5, 1)
    frame.HighlightLeft:SetSize(8, 8)

    frame.HighlightRight:ClearAllPoints()
    frame.HighlightRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
    frame.HighlightRight:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightRight:SetTexCoord(1, 0, 0.5, 1)
    frame.HighlightRight:SetSize(8, 8)

    frame.HighlightMiddle:ClearAllPoints()
    frame.HighlightMiddle:SetPoint("TOPLEFT", frame.HighlightLeft, "TOPRIGHT", 0, 0)
    frame.HighlightMiddle:SetPoint("TOPRIGHT", frame.HighlightRight, "TOPLEFT", 0, 0)
    frame.HighlightMiddle:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\border-highlight")
    frame.HighlightMiddle:SetTexCoord(0, 1, 0, 0.5)
    frame.HighlightMiddle:SetSize(8, 8)

    -- reset the tab
    if not frame.selectedColorTable then
        frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end

    frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
end

function Style:UpdateTabAlpha()
    local alpha = Style.db.dock.alpha

    for tab in next, handledTabs do
        tab.Backdrop:UpdateAlpha(alpha)
    end
end

function Style:EnableDragHook()
    Style:SecureHook("FCFTab_OnDragStop", function(self)
        local frame = _G["ChatFrame" .. self:GetID()]
        if frame then
            if frame.isMouseOver then
                frame.isMouseOver = nil
            end

            frame.isDragging = nil
        end
    end)
end
