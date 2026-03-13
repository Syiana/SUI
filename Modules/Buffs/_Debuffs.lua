local Debuffs = SUI:NewModule("Buffs.Debuffs")

function Debuffs:OnEnable()
    if C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then return end

    local db = SUI.db.profile.unitframes.buffs
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
        
        -- Position border based on debuff container orientation
        if DebuffFrame.AuraContainer.isHorizontal then
            local yOffset = DebuffFrame.AuraContainer.addIconsToTop and -5 or 5
            border:SetPoint("CENTER", button, "CENTER", 0, yOffset)
        else
            local xOffset = DebuffFrame.AuraContainer.addIconsToRight and -15 or 15
            border:SetPoint("CENTER", button, "CENTER", xOffset, 0)
        end

        border:SetFrameLevel(8)

        border.texture = border:CreateTexture()
        border.texture:SetAllPoints()
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss_border_w")
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:SetTexCoord(0, 1, 0, 1)

        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetBackdrop(Backdrop)
        border.shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))

        button.SUIBorder = border
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
                            frame.SUIBorder.texture:SetVertexColor(color.r, color.g, color.b, 1)
                        else
                            frame.SUIBorder.texture:SetVertexColor(unpack(SUI:Color(0.15)))
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
                aura.Duration:SetPoint("CENTER", 0, -17.5)
                aura.Duration:SetDrawLayer("ARTWORK")
                aura.Duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            end

            -- Count styling
            if aura.Count and aura.Count.SetDrawLayer then
                aura.Count:ClearAllPoints()
                aura.Count:SetPoint("BOTTOMRIGHT", 0, 11)
                aura.Count:SetDrawLayer("ARTWORK")
                aura.Count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
            end

            -- Hide default debuff border
            if aura.DebuffBorder then
                aura.DebuffBorder:SetAlpha(0)
            end
        end
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
        frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", function()
            UpdateDebuffs()
            UpdateAuraPositions()
        end)

        -- Hook to update positions whenever debuffs update
        hooksecurefunc(AuraFrameMixin, "Update", function()
            C_Timer.After(0, UpdateAuraPositions)
        end)
    end
end
