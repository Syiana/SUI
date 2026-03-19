local SUIAddon = SUI
local Style = SUIAddon:GetModule("Chat.Modern")

-- Lua
local _G = getfenv(0)
local next = _G.next
local unpack = _G.unpack

-- Mine
local ICONS = {{0 / 128, 52 / 128, 0 / 128, 52 / 128}, -- 1, "to bottom"
{52 / 128, 104 / 128, 0 / 128, 52 / 128}, -- 2, "new"
{0 / 128, 52 / 128, 52 / 128, 104 / 128}, -- 3, "down"
{52 / 128, 104 / 128, 52 / 128, 104 / 128} -- 4, "up"
}

local buttons = {}

local button_proto = {}

local _, class = UnitClass("player")
local color = RAID_CLASS_COLORS[class]

function button_proto:SetState(state, isInstant)
    if state ~= self.state then
        self.state = state

        if isInstant then
            self.NormalTexture:SetTexCoord(unpack(ICONS[state]))
            self.PushedTexture:SetTexCoord(unpack(ICONS[state]))
        else
            Style:StopFading(self.NormalTexture, 1)
            Style:FadeOut(self.NormalTexture, 0, 0.1, function()
                self.NormalTexture:SetTexCoord(unpack(ICONS[state]))
                self.PushedTexture:SetTexCoord(unpack(ICONS[state]))

                Style:FadeIn(self.NormalTexture, 0.1)
            end)
        end
    end
end

local function setUpBaseButton(button, state)
    button:SetFlattensRenderLayers(true)
    button:SetSize(24, 24)
    button:Hide()

    button.Backdrop = Style:CreateBackdrop(button, Style.db.dock.alpha)

    button:SetNormalTexture(0)
    button:SetPushedTexture(0)
    button:SetHighlightTexture(0)

    local normalTexture = button:GetNormalTexture()
    normalTexture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\scroll-buttons")
    normalTexture:ClearAllPoints()
    normalTexture:SetPoint("TOPLEFT", 3, -3)
    normalTexture:SetPoint("BOTTOMRIGHT", -3, 3)
    normalTexture:SetAlpha(0.8)
    normalTexture:SetVertexColor(color.r, color.g, color.b)
    button.NormalTexture = normalTexture

    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\Chat\\scroll-buttons")
    pushedTexture:ClearAllPoints()
    pushedTexture:SetPoint("TOPLEFT", 4, -4)
    pushedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
    pushedTexture:SetAlpha(0.8)
    pushedTexture:SetVertexColor(color.r, color.g, color.b)
    button.PushedTexture = pushedTexture

    local highlightLeft = button:CreateTexture(nil, "HIGHLIGHT")
    local highlightMiddle = button:CreateTexture(nil, "HIGHLIGHT")
    local highlightRight = button:CreateTexture(nil, "HIGHLIGHT")
    Style:ApplyBorderAccent(highlightLeft, highlightMiddle, highlightRight, button)

    button:SetState(state)

    buttons[button] = true

    return button
end

do
    local scroll_to_bottom_button_proto = {}

    function scroll_to_bottom_button_proto:OnClick()
        local frame = self:GetParent()
        if frame then
            -- Use ScrollToBottom for standard WoW chat frames
            if frame.ScrollToBottom then
                frame:ScrollToBottom()
            elseif frame.FastForward then
                frame:FastForward()
            end

            Style:FadeOut(self, 0, 0.1, function()
                self:SetState(1, true)
                self:Hide()
            end)
        end
    end

    function Style:CreateScrollToBottomButton(parent)
        local button = Mixin(CreateFrame("Button", nil, parent), button_proto, scroll_to_bottom_button_proto)
        Style:RawHookScript(button, "OnClick", button.OnClick)
        button:SetAlpha(0)

        return setUpBaseButton(button, 1)
    end
end

do
    local scroll_button_proto = {}

    function scroll_button_proto:OnHide()
        self:SetScript("OnUpdate", nil)
    end

    function scroll_button_proto:OnMouseDown()
        local frame = self:GetParent()
        if frame then
            -- Scroll line by line for standard WoW chat frames
            local direction = self.state == 3 and -1 or 1 -- down = -1, up = 1

            if frame.OnMouseWheel then
                frame:OnMouseWheel(-1 * direction)
            elseif direction == -1 and frame.ScrollDown then
                frame:ScrollDown()
            elseif direction == 1 and frame.ScrollUp then
                frame:ScrollUp()
            end

            self.elapsed = 0
            self:SetScript("OnUpdate", self.OnUpdate)
        end
    end

    function scroll_button_proto:OnMouseUp()
        self:SetScript("OnUpdate", nil)
    end

    function scroll_button_proto:OnUpdate(elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed > 0.3 then -- SCROLL_DURATION + POST_SCROLL_DELAY
            self.elapsed = 0

            self:OnMouseDown()
        end
    end

    function Style:CreateScrollButton(parent, state)
        local button = Mixin(CreateFrame("Button", nil, parent), button_proto, scroll_button_proto)
        button:RegisterForClicks("LeftButtonDown", "RightButtonDown")
        Style:RawHookScript(button, "OnMouseDown", button.OnMouseDown)
        Style:RawHookScript(button, "OnMouseUp", button.OnMouseUp)
        Style:RawHookScript(button, "OnHide", button.OnHide)
        button:SetAlpha(1)

        return setUpBaseButton(button, state)
    end
end

function Style:UpdateScrollButtonAlpha()
    local alpha = Style.db.dock.alpha

    for button in next, buttons do
        button.Backdrop:UpdateAlpha(alpha)
    end
end
