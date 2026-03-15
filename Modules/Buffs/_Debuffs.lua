local Debuffs = SUI:NewModule("Buffs.Debuffs")

function Debuffs:OnEnable()
    if C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then return end

    local db = SUI.db.profile.unitframes.debuffs
    local theme = SUI.db.profile.general.theme

    -- Update Duration Text for Debuffs
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

    -- Hook duration updates for all debuff frames
    for _, auraFrame in pairs(DebuffFrame.auraFrames) do
        if auraFrame.SetFormattedText then
            hooksecurefunc(auraFrame, "UpdateDuration", function(self)
                UpdateDuration(self, self.timeLeft)
            end)
        end
    end

    -- DebuffType Colors for the Debuff Border
    local DebuffColor      = {}
    DebuffColor["none"]    = { r = 0.80, g = 0, b = 0 };
    DebuffColor["Magic"]   = { r = 0.20, g = 0.60, b = 1.00 };
    DebuffColor["Curse"]   = { r = 0.60, g = 0.00, b = 1.00 };
    DebuffColor["Disease"] = { r = 0.60, g = 0.40, b = 0 };
    DebuffColor["Poison"]  = { r = 0.00, g = 0.60, b = 0 };

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
            border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss_border_w")
            border:SetTexCoord(0, 1, 0, 1)
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

    local function UpdateDebuffs()
        local Children = { DebuffFrame.AuraContainer:GetChildren() }

        for index, child in pairs(Children) do
            if canaccessvalue(index) and canaccessvalue(child) then
                local frame = select(index, DebuffFrame.AuraContainer:GetChildren())
                if frame and canaccessvalue(frame) then
                    if child.Border then
                        child.Border:Hide()
                    end

                    if frame.Icon and canaccessvalue(frame.Icon) then
                        frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    end

                    if not frame.SUIBorder then
                        ButtonDefault(frame)
                    end

                    -- Set the color of the Debuff Border
                    local debuffType = nil
                    if child.buttonInfo and canaccessvalue(child.buttonInfo) then
                        -- Use pcall to safely access potentially protected data
                        local success, result = pcall(function() return child.buttonInfo.debuffType end)
                        if success and canaccessvalue(result) then
                            debuffType = result
                        end
                    end
                    
                    if frame.SUIBorder then
                        local color = DebuffColor[debuffType or "none"]
                        if color then
                            frame.SUIBorder:SetVertexColor(color.r, color.g, color.b, 1)
                        else
                            frame.SUIBorder:SetVertexColor(unpack(SUI:Color(0.15)))
                        end
                    end
                end
            end
        end
    end

    -- Update debuff text positions
    local function UpdateAuraPositions()
        for i = 1, #DebuffFrame.auraFrames do
            local aura = DebuffFrame.auraFrames[i]
            
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

            -- Hide default debuff border
            if aura.DebuffBorder then
                aura.DebuffBorder:SetAlpha(0)
            end
        end
    end

    function Debuffs:Refresh()
        if theme == 'Blizzard' then
            return
        end

        UpdateDebuffs()
        UpdateAuraPositions()
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
        frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", function()
            Debuffs:Refresh()
        end)

        -- Hook to update positions whenever debuffs update
        hooksecurefunc(AuraFrameMixin, "Update", function()
            C_Timer.After(0, function()
                Debuffs:Refresh()
            end)
        end)
    end
end
