local Buffs = SUI:NewModule("Buffs.Buffs");

function Buffs:OnEnable()
    if C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then return end

    local db = SUI.db.profile.unitframes.buffs
    local theme = SUI.db.profile.general.theme

    -- Update Duration Text for Buffs
    local function UpdateDuration(self, timeLeft)
        if timeLeft >= 86400 then
            self.Duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
        elseif timeLeft >= 3600 then
            self.Duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
        elseif timeLeft >= 60 then
            self.Duration:SetFormattedText("%dm", ceil(timeLeft / 60))
        else
            self.Duration:SetFormattedText("%ds", timeLeft)
        end
    end

    local function HookDurationUpdates(auraFrames)
        for _, auraFrame in pairs(auraFrames) do
            if auraFrame.SetFormattedText then
                --hooksecurefunc(auraFrame.Duration, "SetFormattedText", UpdateDuration)
                hooksecurefunc(auraFrame, "UpdateDuration", function(self)
                    UpdateDuration(self, self.timeLeft)
                end)
            end
        end
    end

    HookDurationUpdates(BuffFrame.auraFrames)

    local function ButtonDefault(button)
        local Backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 6,
            insets = { left = 6, right = 6, top = 6, bottom = 6 },
        }

        local icon = button.Icon

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth() + 4, icon:GetHeight() + 4)
        if BuffFrame.AuraContainer.isHorizontal then
            if BuffFrame.AuraContainer.addIconsToTop then
                border:SetPoint("CENTER", button, "CENTER", 0, -5)
            else
                border:SetPoint("CENTER", button, "CENTER", 0, 5)
            end
        elseif not BuffFrame.AuraContainer.isHorizontal then
            if not BuffFrame.AuraContainer.addIconsToRight then
                border:SetPoint("CENTER", button, "CENTER", 15, 0)
            else
                border:SetPoint("CENTER", button, "CENTER", -15, 0)
            end
        end


        border.texture = border:CreateTexture()
        border.texture:SetAllPoints()
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
        border.texture:SetTexCoord(0, 1, 0, 1)
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:SetVertexColor(0.4, 0.35, 0.35)

        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetBackdrop(Backdrop)
        border.shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))

        button.SUIBorder = border
    end

    local function ButtonBackdrop(button)
        local Backdrop = {
            bgFile = "",
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 5,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        }

        local icon = button.Icon
        local point, relativeTo, relativePoint, xOfs, yOfs = icon:GetPoint()

        local border = CreateFrame("Frame", nil, button)
        border:SetSize(icon:GetWidth(), icon:GetHeight())
        border:SetPoint("CENTER", button, "CENTER", 0, 5)

        local shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        shadow:SetBackdrop(Backdrop)
        shadow:SetBackdropBorderColor(0, 0, 0)

        button.SUIBorder = border
    end

    local function ButtonBordered(button)

    end

    function updateBuffs()
        local Children = BuffFrame.auraFrames

        for index, child in pairs(Children) do
            local frame = select(index, BuffFrame.AuraContainer:GetChildren())
            local icon = frame.Icon
            local count = frame.count

            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if frame.TempEnchantBorder then frame.TempEnchantBorder:Hide() end

            if frame.SUIBorder == nil then
                ButtonDefault(frame)
            end
        end
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterUnitEvent("UNIT_AURA", "player")
        frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", updateBuffs)

        hooksecurefunc(AuraFrameMixin, "Update", function(self)
            -- Set Duration Font size and reposition it
            if BuffFrame.AuraContainer.isHorizontal then
                if BuffFrame.AuraContainer.addIconsToTop then
                    for i = 1, #BuffFrame.auraFrames do
                        local duration = BuffFrame.auraFrames[i].Duration
                        local count = BuffFrame.auraFrames[i].Count
    
                        count:SetPoint("TOPRIGHT", 0, 12)
                        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        duration:ClearAllPoints()
                        duration:SetPoint("CENTER", 0, -15)
                    end
                else
                    for i = 1, #BuffFrame.auraFrames do
                        local duration = BuffFrame.auraFrames[i].Duration
                        local count = BuffFrame.auraFrames[i].Count
                        
                        count:SetPoint("TOPRIGHT", 0, 12)
                        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        duration:ClearAllPoints()
                        duration:SetPoint("CENTER", 0, -5)
                    end
                end
            elseif not BuffFrame.AuraContainer.isHorizontal then
                if not BuffFrame.AuraContainer.addIconsToRight then
                    for i = 1, #BuffFrame.auraFrames do
                        local duration = BuffFrame.auraFrames[i].Duration
                        local count = BuffFrame.auraFrames[i].Count
    
                        count:SetPoint("TOPRIGHT", 0, 12)
                        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        duration:ClearAllPoints()
                        duration:SetPoint("CENTER", 15, -10)
                    end
                else
                    for i = 1, #BuffFrame.auraFrames do
                        local duration = BuffFrame.auraFrames[i].Duration
                        local count = BuffFrame.auraFrames[i].Count
    
                        count:SetPoint("TOPRIGHT", -30, 12)
                        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        duration:ClearAllPoints()
                        duration:SetPoint("CENTER", -13.5, -10)
                    end
                end
            end
    
            for i = 1, #BuffFrame.auraFrames do
                local duration = BuffFrame.auraFrames[i].Duration
                duration:SetDrawLayer("OVERLAY")
            end
        end)
    end

    -- Collapse Button
    if not db.collapse then
        local hideCollapse = CreateFrame("Frame")
        hideCollapse:RegisterEvent("PLAYER_ENTERING_WORLD")
        hideCollapse:RegisterUnitEvent("UNIT_AURA", "player")
        hideCollapse:SetScript("OnEvent", function()
            BuffFrame.CollapseAndExpandButton:Hide()
        end)

        hooksecurefunc(C_EditMode, "OnEditModeExit", function()
            BuffFrame.CollapseAndExpandButton:Hide()
        end)
    end
end
