local Debuffs = SUI:NewModule("Buffs.Debuffs");

function Debuffs:OnEnable()
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

    HookDurationUpdates(DebuffFrame.auraFrames)

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
        if DebuffFrame.AuraContainer.isHorizontal then
            if DebuffFrame.AuraContainer.addIconsToTop then
                border:SetPoint("CENTER", button, "CENTER", 0, -5)
            else
                border:SetPoint("CENTER", button, "CENTER", 0, 5)
            end
        elseif not DebuffFrame.AuraContainer.isHorizontal then
            if not DebuffFrame.AuraContainer.addIconsToRight then
                border:SetPoint("CENTER", button, "CENTER", 15, 0)
            else
                border:SetPoint("CENTER", button, "CENTER", -15, 0)
            end
        end

        border:SetFrameLevel(8)

        border.texture = border:CreateTexture()
        border.texture:SetAllPoints()
        border.texture:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss_border_w")
        --border.texture:SetVertexColor(0.20, 0.60, 1.00)
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:SetTexCoord(0, 1, 0, 1)


        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetBackdrop(Backdrop)
        border.shadow:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))

        button.SUIBorder = border
    end

    function updateDebuffs()
        local Children = { DebuffFrame.AuraContainer:GetChildren() }

        for index, child in pairs(Children) do
            local frame = select(index, DebuffFrame.AuraContainer:GetChildren())
            local icon = frame.Icon

            if child.Border then
                child.Border:Hide()
            end


            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            if frame.SUIBorder == nil then
                ButtonDefault(frame)
            end

            -- Set the color of the Debuff Border
            local debuffType
            if (child.buttonInfo) then
                debuffType = child.buttonInfo.debuffType
            end
            if (frame.SUIBorder) then
                local color
                if (debuffType) then
                    color = DebuffColor[debuffType]
                else
                    color = DebuffColor["none"]
                end

                if color ~= nil then
                    frame.SUIBorder.texture:SetVertexColor(color.r, color.g, color.b, 1)
                else
                    frame.SUIBorder.texture:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end
    end

    if theme ~= 'Blizzard' then
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_ENTERING_WORLD", self, "Update")
        frame:RegisterUnitEvent("UNIT_AURA", self, "Update")
        frame:RegisterEvent("GROUP_ROSTER_UPDATE")
        frame:SetScript("OnEvent", function(self, event, ...)
            updateDebuffs()
        end)

        hooksecurefunc(AuraFrameMixin, "Update", function(self)
            -- Set Duration Font size and reposition it
            if DebuffFrame.AuraContainer.isHorizontal then
                if DebuffFrame.AuraContainer.addIconsToTop then
                    for i = 1, #DebuffFrame.auraFrames do
                        if DebuffFrame.auraFrames[i].Count then
                            local count = DebuffFrame.auraFrames[i].Count

                            count:SetPoint("TOPRIGHT", 0, 12)
                        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        end

                        if DebuffFrame.auraFrames[i].Duration then
                            local duration = DebuffFrame.auraFrames[i].Duration
                            if duration.SetFont then
                                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            end

                            duration:ClearAllPoints()
                            duration:SetPoint("CENTER", 0, -15)
                        end
                    end
                else
                    for i = 1, #DebuffFrame.auraFrames do
                        if DebuffFrame.auraFrames[i].Count then
                            local count = DebuffFrame.auraFrames[i].Count

                            count:SetPoint("TOPRIGHT", 0, 12)
                            count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        end

                        if DebuffFrame.auraFrames[i].Duration then
                            local duration = DebuffFrame.auraFrames[i].Duration
                            if duration.SetFont then
                                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            end

                            duration:ClearAllPoints()
                            duration:SetPoint("CENTER", 0, -5)
                        end
                    end
                end
            elseif not DebuffFrame.AuraContainer.isHorizontal then
                if not DebuffFrame.AuraContainer.addIconsToRight then
                    for i = 1, #DebuffFrame.auraFrames do
                        if DebuffFrame.auraFrames[i].Count then
                            local count = DebuffFrame.auraFrames[i].Count

                            count:SetPoint("TOPRIGHT", 0, 12)
                            count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        end

                        if DebuffFrame.auraFrames[i].Duration then
                            local duration = DebuffFrame.auraFrames[i].Duration
                            if duration.SetFont then
                                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            end

                            duration:ClearAllPoints()
                            duration:SetPoint("CENTER", 15, -10)
                        end
                    end
                else
                    for i = 1, #DebuffFrame.auraFrames do
                        if DebuffFrame.auraFrames[i].Count then
                            local count = DebuffFrame.auraFrames[i].Count

                            count:SetPoint("TOPRIGHT", -30, 12)
                            count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                        end

                        if DebuffFrame.auraFrames[i].Duration then
                            local duration = DebuffFrame.auraFrames[i].Duration
                            if duration.SetFont then
                                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                            end

                            duration:ClearAllPoints()
                            duration:SetPoint("CENTER", -13.5, -10)
                        end
                    end
                end
            end

            for i = 1, #DebuffFrame.auraFrames do
                if DebuffFrame.auraFrames[i].DebuffBorder then
                    DebuffFrame.auraFrames[i].DebuffBorder:SetAlpha(0)
                end
            end
        end)
    end
end
