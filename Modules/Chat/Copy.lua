local SUIAddon = SUI
local Copy = SUIAddon:NewModule("SUI.Modules.Chat.Copy", "AceHook-3.0")

function Copy:OnInitialize()
    -- Create Frame
    Copy.frame = CreateFrame("Frame", "SUIChatCopyContainer", UIParent, "BackdropTemplate")
    Copy.frame:SetSize(600, 350)
    Copy.frame:SetPoint("CENTER", UIParent, "CENTER")
    Copy.frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeSize = 16,
        tile = true,
        tileSize = 16,
        insets = {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3
        }
    })
    Copy.frame:SetBackdropColor(0, 0, 0)
    Copy.frame:Hide()

    -- Enable dragging
    Copy.frame:EnableMouse(true)
    Copy.frame:SetMovable(true)
    Copy.frame:RegisterForDrag("LeftButton")
    Copy.frame:SetScript("OnDragStart", Copy.frame.StartMoving)
    Copy.frame:SetScript("OnDragStop", Copy.frame.StopMovingOrSizing)

    -- Create Title
    Copy.title = Copy.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Copy.title:SetPoint("TOP", Copy.frame, "TOP", 0, -8)
    Copy.title:SetTextColor(1, 1, 0)
    Copy.title:SetShadowOffset(1, -1)

    -- Create Close Button
    Copy.closeButton = CreateFrame("Button", nil, Copy.frame, "UIPanelCloseButton")
    Copy.closeButton:SetPoint("TOPRIGHT", 0, -1)

    -- Create Scrollbar
    Copy.scroll = CreateFrame("ScrollFrame", nil, Copy.frame, "UIPanelScrollFrameTemplate")
    Copy.scroll:SetPoint("TOPLEFT", 10, -30)
    Copy.scroll:SetPoint("BOTTOMRIGHT", -30, 10)

    Copy.editbox = CreateFrame("EditBox", nil, Copy.scroll)
    Copy.editbox:SetMultiLine(true)
    Copy.editbox:SetFontObject("ChatFontNormal")
    Copy.editbox:SetSize(Copy.frame:GetWidth() - 40, Copy.frame:GetHeight() - 60)
    Copy.editbox:SetAutoFocus(false)
    Copy.editbox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    Copy.scroll:SetScrollChild(Copy.editbox)
    Copy.editbox:SetScript("OnEscapePressed", function()
        Copy.frame:Hide()
    end)

    -- Create Button
    Copy.button = CreateFrame("Button", nil, UIParent) -- Set UIParent as the parent frame
    Copy.button:SetPoint("TOPLEFT", ChatFrame1, -27.5, 27.5)
    Copy.button:SetSize(20, 20)
    Copy.button:SetNormalTexture([[Interface\AddOns\SUI\Media\Textures\Chat\copynormal.png]])
    Copy.button:GetNormalTexture():SetSize(20, 20)
    Copy.button:SetHighlightTexture([[Interface\AddOns\SUI\Media\Textures\Chat\copyhighlight.png]])
    Copy.button:GetHighlightTexture():SetAllPoints(Copy.button:GetNormalTexture())
    Copy.button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(Copy.button, "ANCHOR_TOP")
        GameTooltip:SetText("Copy Chat Log")
        GameTooltip:Show()
    end)
    Copy.button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    function Copy:PositionButton()
        if not Copy.button or not ChatFrame1 then
            return
        end

        Copy.button:ClearAllPoints()
        Copy.button:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", -4, -4)
        Copy.button:SetFrameStrata("HIGH")
        Copy.button:SetFrameLevel(ChatFrame1:GetFrameLevel() + 20)
    end

    function Copy:Chatlog()
        local chatFrame = SELECTED_DOCK_FRAME
        if not chatFrame then
            return
        end

        local chatHistory = ""
        for i = 1, chatFrame:GetNumMessages() do
            local message = chatFrame:GetMessageInfo(i)
            if message then
                chatHistory = chatHistory .. message .. "\n"
            end
        end

        -- Add a delay before setting the text in the editbox
        C_Timer.After(0.1, function()
            Copy.editbox:SetText(chatHistory)
            Copy.title:SetText("Chat Log (" .. chatFrame.name .. ")")
            Copy.frame:Show()
        end)
    end

    Copy.button:Hide()
end

function Copy:OnEnable()
    if not SUIAddon.db or not SUIAddon.db.profile or not SUIAddon.db.profile.chat or not SUIAddon.db.profile.chat.copy then
        if Copy.button then
            Copy.button:Hide()
        end
        return
    end

    local function showButton()
        Copy.button:SetAlpha(1)
        Copy.button:Show()
    end

    local function hideButton()
        if Copy.button:IsMouseOver() or ChatFrame1:IsMouseOver() then
            return
        end
        Copy.button:SetAlpha(0)
        Copy.button:Show()
    end

    Copy:PositionButton()
    Copy.button:SetAlpha(0)
    Copy.button:Show()
    Copy:RawHookScript(Copy.button, "OnClick", Copy.Chatlog)

    if not Copy.button.suiHoverHooked then
        ChatFrame1:HookScript("OnEnter", showButton)
        ChatFrame1:HookScript("OnLeave", hideButton)
        Copy:RawHookScript(Copy.button, "OnEnter", showButton)
        Copy:RawHookScript(Copy.button, "OnLeave", hideButton)
        Copy.button.suiHoverHooked = true
    end

    C_Timer.After(0, function()
        Copy:PositionButton()
        hideButton()
    end)
end

function Copy:OnDisable()
    Copy:UnhookAll()
    Copy.frame:Hide()
    Copy.button:Hide()
end
