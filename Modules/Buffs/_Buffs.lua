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
        local icon = button.Icon
        local holder = button.SUIBorderFrame
        local border = button.SUIBorder
        local shadow = button.SUIShadow
        local size = 34

        if not holder then
            holder = CreateFrame("Frame", nil, button)
            holder:SetFrameLevel(button:GetFrameLevel() - 1)
            holder:SetPoint("CENTER", icon, "CENTER", 0, 0)
            button.SUIBorderFrame = holder
        end

        holder:ClearAllPoints()
        holder:SetPoint("CENTER", icon, "CENTER", 0, 0)
        holder:SetSize(size, size)

        if not border then
            border = holder:CreateTexture(nil, "BACKGROUND", nil, -7)
            border:SetAllPoints()
            border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
            border:SetTexCoord(0, 1, 0, 1)
            border:SetVertexColor(0.4, 0.35, 0.35)
            button.SUIBorder = border
        end

        if not shadow then
            shadow = holder:CreateTexture(nil, "BACKGROUND", nil, -8)
            shadow:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Nameplates\\textureShadow")
            shadow:SetVertexColor(0, 0, 0, 0.9)
            shadow:SetPoint("CENTER", holder, "CENTER", 0, 0)
            shadow:SetWidth(size + 8)
            shadow:SetHeight(size + 8)
            button.SUIShadow = shadow
        end

        if not button.SUIAlphaHooked then
            hooksecurefunc(icon, "SetAlpha", function(_, alpha)
                holder:SetAlpha(alpha)
            end)
            button.SUIAlphaHooked = true
        end

        holder:SetAlpha(icon:GetAlpha() or 1)
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
