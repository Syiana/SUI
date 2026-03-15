local Buffs = SUI:NewModule("Buffs.Buffs")

function Buffs:OnEnable()
    if C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then return end

    local db = SUI.db.profile.unitframes.buffs
    local theme = SUI.db.profile.general.theme

    -- Update Duration Text for Buffs
    local function UpdateDuration(self, timeLeft)
        local success, result = pcall(function()
            if not timeLeft or timeLeft < 0 then
                return
            end
            
            if timeLeft >= 86400 then
                self.Duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
            elseif timeLeft >= 3600 then
                self.Duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
            elseif timeLeft >= 60 then
                self.Duration:SetFormattedText("%dm", ceil(timeLeft / 60))
            else
                self.Duration:SetFormattedText("%ds", timeLeft)
            end
        end)
        
        if not success then
            -- Silently fail if value is tainted/secret
            return
        end
    end

    -- Hook duration updates for all buff frames
    for _, auraFrame in pairs(BuffFrame.auraFrames) do
        if auraFrame.SetFormattedText then
            hooksecurefunc(auraFrame, "UpdateDuration", function(self)
                UpdateDuration(self, self.timeLeft)
            end)
        end
    end

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
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)

        -- Position border based on buff container orientation
        if BuffFrame.AuraContainer.isHorizontal then
            local yOffset = BuffFrame.AuraContainer.addIconsToTop and -5 or 5
            border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2 + yOffset)
            border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2 + yOffset)
        else
            local xOffset = BuffFrame.AuraContainer.addIconsToRight and -15 or 15
            border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2 + xOffset, 2)
            border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2 + xOffset, -2)
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

    local function UpdateBuffs()
        for index, child in pairs(BuffFrame.auraFrames) do
            local frame = select(index, BuffFrame.AuraContainer:GetChildren())
            
            frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            if frame.TempEnchantBorder then 
                frame.TempEnchantBorder:Hide() 
            end

            if not frame.SUIBorder then
                ButtonDefault(frame)
            end
        end
    end

    -- Update buff text positions
    local function UpdateAuraPositions()
        for i = 1, #BuffFrame.auraFrames do
            local aura = BuffFrame.auraFrames[i]
            
            -- Duration styling
            if aura.Duration and aura.Duration.SetDrawLayer then
                aura.Duration:ClearAllPoints()
                aura.Duration:SetPoint("TOP", aura, "BOTTOM", 0, db.durationoffset or 2)
                aura.Duration:SetDrawLayer("ARTWORK")
                aura.Duration:SetFont(STANDARD_TEXT_FONT, db.textsize or 11, "OUTLINE")
            end

            -- Count styling
            if aura.Count and aura.Count.SetDrawLayer then
                aura.Count:ClearAllPoints()
                aura.Count:SetPoint("TOPRIGHT", aura, "TOPRIGHT", db.countx or -1, db.county or -1)
                aura.Count:SetDrawLayer("ARTWORK")
                aura.Count:SetFont(STANDARD_TEXT_FONT, db.textsize or 11, "OUTLINE")
            end
        end
    end

    function Buffs:Refresh()
        if theme == 'Blizzard' then
            return
        end

        UpdateBuffs()
        UpdateAuraPositions()

        if db.collapse then
            BuffFrame.CollapseAndExpandButton:Show()
        else
            BuffFrame.CollapseAndExpandButton:Hide()
        end
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterUnitEvent("UNIT_AURA", "player")
        frame:RegisterEvent("WEAPON_ENCHANT_CHANGED")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", function()
            Buffs:Refresh()
        end)

        -- Hook to update positions whenever buffs update
        hooksecurefunc(AuraFrameMixin, "Update", function()
            C_Timer.After(0, function()
                Buffs:Refresh()
            end)
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
