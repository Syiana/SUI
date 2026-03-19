local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

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
local TAB_TEXTURES = {"Left", "Middle", "Right"}

local function clearTabTextures(frame, textureList)
    for _, texture in next, textureList do
        frame[texture]:SetTexture(0)
    end
end

local function applyGlowAnchor(glow, rightOffset)
    glow:ClearAllPoints()
    glow:SetPoint("BOTTOMLEFT", 8, 2)
    glow:SetPoint("BOTTOMRIGHT", rightOffset, 2)
end

local function restoreTabAnchor(frame)
    local point, relativeTo, relativePoint, offsetX, offsetY = frame:GetPoint()
    if not point then
        return
    end

    if relativeTo and type(relativeTo) == "table" then
        frame:SetPoint(point, relativeTo, relativePoint, offsetX or 0, offsetY or 0)
        return
    end

    frame:SetPoint(point, offsetX or 0, offsetY or 0)
end

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

    clearTabTextures(frame, TAB_TEXTURES)

    frame:SetHeight(20)
    applyGlowAnchor(frame.glow, -8)

    Style:ApplyBorderAccent(frame.ActiveLeft, frame.ActiveMiddle, frame.ActiveRight, frame)
    Style:ApplyBorderAccent(frame.HighlightLeft, frame.HighlightMiddle, frame.HighlightRight, frame)

    if frame.conversationIcon then
        frame.conversationIcon:SetPoint("RIGHT", frame.Text, "LEFT", 0, 0)
    end

    restoreTabAnchor(frame)

    if not frame.selectedColorTable then
        frame.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end

    -- it can be "CENTER" or "LEFT", so just use the index
    frame.Text:SetPoint(frame.Text:GetPoint())
end

local handledMiniTabs = {}
local MINI_TAB_TEXTURES = {"Left", "Middle", "Right"}

function Style:HandleMinimizedTab(frame)
    if not handledMiniTabs[frame] then
        frame.Backdrop = Style:CreateBackdrop(frame, Style.db.dock.alpha)

        Style:HandleMaximizeButton(_G[frame:GetName() .. "MaximizeButton"])

        Style:SecureHook(frame.Text, "SetTextColor", chatTabText_SetTextColor)

        handledMiniTabs[frame] = true
    end

    clearTabTextures(frame, MINI_TAB_TEXTURES)

    frame:SetHeight(20)
    applyGlowAnchor(frame.glow, -24)

    Style:ApplyBorderAccent(frame.HighlightLeft, frame.HighlightMiddle, frame.HighlightRight, frame)

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
