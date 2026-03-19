local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

local _G = getfenv(0)
local next = _G.next
local unpack = _G.unpack

local ICON_TEXTURE = "Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\scroll-buttons"
local REPEAT_DELAY = 0.3
local ICONS = {
    [1] = {0 / 128, 52 / 128, 0 / 128, 52 / 128},
    [2] = {52 / 128, 104 / 128, 0 / 128, 52 / 128},
    [3] = {0 / 128, 52 / 128, 52 / 128, 104 / 128},
    [4] = {52 / 128, 104 / 128, 52 / 128, 104 / 128}
}

local trackedButtons = setmetatable({}, {__mode = "k"})
local buttonPrototype = {}

local _, class = UnitClass("player")
local color = RAID_CLASS_COLORS[class]

local function setTextureLayout(texture, offsets)
    texture:SetTexture(ICON_TEXTURE)
    texture:ClearAllPoints()
    texture:SetPoint("TOPLEFT", offsets[1], offsets[2])
    texture:SetPoint("BOTTOMRIGHT", offsets[3], offsets[4])
    texture:SetAlpha(0.8)
    texture:SetVertexColor(color.r, color.g, color.b)
end

local function applyIconState(button, state)
    local texCoord = ICONS[state]
    button.NormalTexture:SetTexCoord(unpack(texCoord))
    button.PushedTexture:SetTexCoord(unpack(texCoord))
end

local function stopButtonRepeat(button)
    button.repeatTicker = nil
    button:SetScript("OnUpdate", nil)
end

local function stepScroll(frame, state)
    local delta = state == 3 and -1 or 1

    if frame.OnMouseWheel then
        frame:OnMouseWheel(-delta)
        return
    end

    if delta < 0 and frame.ScrollDown then
        frame:ScrollDown()
        return
    end

    if delta > 0 and frame.ScrollUp then
        frame:ScrollUp()
    end
end

function buttonPrototype:SetState(state, instant)
    if self.state == state then
        return
    end

    self.state = state

    if instant then
        applyIconState(self, state)
        return
    end

    Style:StopFading(self.NormalTexture, 1)
    Style:FadeOut(self.NormalTexture, 0, 0.1, function()
        applyIconState(self, state)
        Style:FadeIn(self.NormalTexture, 0.1)
    end)
end

local function createBaseButton(parent, state)
    local button = Mixin(CreateFrame("Button", nil, parent), buttonPrototype)
    button:SetFlattensRenderLayers(true)
    button:SetSize(24, 24)
    button:Hide()
    button.Backdrop = Style:CreateBackdrop(button, Style.db.dock.alpha)

    button:SetNormalTexture(0)
    button:SetPushedTexture(0)
    button:SetHighlightTexture(0)

    button.NormalTexture = button:GetNormalTexture()
    button.PushedTexture = button:GetPushedTexture()

    setTextureLayout(button.NormalTexture, {3, -3, -3, 3})
    setTextureLayout(button.PushedTexture, {4, -4, -2, 2})

    Style:ApplyBorderAccent(
        button:CreateTexture(nil, "HIGHLIGHT"),
        button:CreateTexture(nil, "HIGHLIGHT"),
        button:CreateTexture(nil, "HIGHLIGHT"),
        button
    )

    button:SetState(state, true)
    trackedButtons[button] = true

    return button
end

local function bindRepeatHandlers(button)
    button:RegisterForClicks("LeftButtonDown", "RightButtonDown")

    button:SetScript("OnHide", function(self)
        stopButtonRepeat(self)
    end)

    button:SetScript("OnMouseUp", function(self)
        stopButtonRepeat(self)
    end)

    button:SetScript("OnMouseDown", function(self)
        local frame = self:GetParent()
        if not frame then
            return
        end

        stepScroll(frame, self.state)
        self.repeatTicker = 0
        self:SetScript("OnUpdate", function(activeButton, elapsed)
            activeButton.repeatTicker = (activeButton.repeatTicker or 0) + elapsed
            if activeButton.repeatTicker < REPEAT_DELAY then
                return
            end

            activeButton.repeatTicker = 0
            stepScroll(activeButton:GetParent(), activeButton.state)
        end)
    end)
end

function Style:CreateScrollToBottomButton(parent)
    local button = createBaseButton(parent, 1)
    button:SetAlpha(0)

    button:SetScript("OnClick", function(self)
        local frame = self:GetParent()
        if not frame then
            return
        end

        if frame.ScrollToBottom then
            frame:ScrollToBottom()
        elseif frame.FastForward then
            frame:FastForward()
        end

        Style:FadeOut(self, 0, 0.1, function()
            self:SetState(1, true)
            self:Hide()
        end)
    end)

    return button
end

function Style:CreateScrollButton(parent, state)
    local button = createBaseButton(parent, state)
    button:SetAlpha(1)
    bindRepeatHandlers(button)
    return button
end

function Style:UpdateScrollButtonAlpha()
    local alpha = Style.db.dock.alpha

    for button in next, trackedButtons do
        button.Backdrop:UpdateAlpha(alpha)
    end
end
