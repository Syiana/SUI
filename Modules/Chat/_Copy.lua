local Module = SUI:NewModule("Chat.Copy");

function Module:OnEnable()
    local function CreatCopyFrame()
        local _G = _G
        local string_find = string.find
        local string_format = string.format
        local string_gsub = string.gsub
        local table_insert = table.insert
        local CreateFrame, UIParent = _G.CreateFrame, _G.UIParent
        local GetSpellInfo = _G.GetSpellInfo
        local ToggleFrame = _G.ToggleFrame
        local lines = {}
        local frame = nil
        local editBox = nil
        local font = nil
        local isf = nil
        local sizes = {
            ":14:14",
            ":15:15",
            ":16:16",
            ":12:20",
            ":14"
        }
        local frame = CreateFrame("Frame", "CopyFrame", UIParent, "BackdropTemplate")
        frame:SetBackdrop(
            {
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = false,
                tileSize = 32,
                edgeSize = 15,
                insets = {
                    left = 1,
                    right = 1,
                    top = 1,
                    bottom = 1
                }
            }
        )
        frame:SetBackdropBorderColor(0, 0, 0, 1)
        frame:SetBackdropColor(0, 0, 0, 1)
        frame:SetSize(540, 300)
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        frame:SetFrameStrata("DIALOG")
        table_insert(UISpecialFrames, "CopyFrame")
        frame:Hide()

        editBox = CreateFrame("EditBox", "CopyBox", frame)
        editBox:SetMultiLine(true)
        editBox:SetMaxLetters(99999)
        editBox:EnableMouse(true)
        editBox:SetAutoFocus(false)
        editBox:SetFontObject(ChatFontNormal)
        editBox:SetSize(500, 300)
        editBox:SetScript(
            "OnEscapePressed",
            function()
                frame:Hide()
            end
        )

        local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
        scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -10)
        scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
        scrollArea:SetScrollChild(editBox)

        editBox:SetScript("OnTextSet", function(self)
            local text = self:GetText()

            for _, size in pairs(sizes) do
                if string.find(text, size) and not string.find(text, size.."]") then
                    self:SetText(string.gsub(text, size, ":12:12"))
                end
            end
        end)

        font = frame:CreateFontString(nil, nil, "GameFontNormal")
        font:Hide()

        isf = true
    end

    local function MessageIsProtected(message)
        return strmatch(message, '[^|]-|K[vq]%d-[^|]-|k')
    end

    local scrollDown = function()
        CopyScroll:SetVerticalScroll((CopyScroll:GetVerticalScrollRange()) or 0)
    end

    local function Copy(cf)
        if not isf then CreatCopyFrame() end
        local text = ""
        for i = 1, cf:GetNumMessages() do
            local line = cf:GetMessageInfo(i)
            if not MessageIsProtected(line) then
                font:SetFormattedText("%s\n", line)
                local cleanLine = font:GetText() or ""
                text = text..cleanLine
            end
        end
        text = text:gsub("|T[^\\]+\\[^\\]+\\[Uu][Ii]%-[Rr][Aa][Ii][Dd][Tt][Aa][Rr][Gg][Ee][Tt][Ii][Nn][Gg][Ii][Cc][Oo][Nn]_(%d)[^|]+|t", "{rt%1}")
        text = text:gsub("|T13700([1-8])[^|]+|t", "{rt%1}")
        text = text:gsub("|T[^|]+|t", "")
        if frame:IsShown() then frame:Hide() return end
        frame:Show()
        editBox:SetText(text)

        editBox:SetScript("OnTextChanged", function(_, userInput)
            if userInput then return end
            local _, max = CopyScrollScrollBar:GetMinMaxValues()
            for _ = 1, max do
                ScrollFrameTemplate_OnMouseWheel(CopyScroll, -1)
            end
        end)
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G[string.find("ChatFrame%d", i)]
        local function CreateCopyButton(self)
            self.Copy = CreateFrame("Button", nil, _G[self:GetName()])
            self.Copy:SetSize(20, 20)
            self.Copy:SetPoint("TOPRIGHT", self, 10, -5)

            self.Copy:SetNormalTexture("Interface\\AddOns\\SUI\\inc\\media\\core\\copynormal")
            self.Copy:GetNormalTexture():SetSize(20, 20)

            self.Copy:SetHighlightTexture("Interface\\AddOns\\SUI\\inc\\media\\core\\copyhighlight")
            self.Copy:GetHighlightTexture():SetAllPoints(self.Copy:GetNormalTexture())

            local tab = _G[self:GetName() .. "Tab"]
            hooksecurefunc(
                tab,
                "SetAlpha",
                function()
                    self.Copy:SetAlpha(tab:GetAlpha() * 0.55)
                end
            )

            self.Copy:SetScript(
                "OnMouseUp",
                function()
                    Copy(cf)
                end
            )
        end

        local function EnableCopyButton()
            for _, v in pairs(CHAT_FRAMES) do
                local chat = _G[v]
                if (chat and not chat.Copy) then
                    CreateCopyButton(chat)
                end
            end
        end
        EnableCopyButton()
    end
end