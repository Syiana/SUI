local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates

    local function nameplateCastbar(self)
        local inInstance, instanceType = IsInInstance("player")
        if inInstance then
            if self.unit and not UnitIsFriend("player", self.unit) then
                if self.castBar and self.castBar.Icon then
                    self.castBar.Icon:ClearAllPoints();
                    PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
                    self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                end
            elseif instanceType == 'arena' or instanceType == 'pvp' then
                if self.castBar and self.castBar.Icon then
                    self.castBar.Icon:ClearAllPoints();
                    PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
                    self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                end
            end
        else
            if self.castBar and self.castBar.Icon then
                self.castBar.Icon:ClearAllPoints();
                PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
                self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            end
        end
    end

    local function nameplateHealthText(unit, healthBar)
        if not healthBar.text then
            healthBar.text = healthBar:CreateFontString(nil, "ARTWORK", nil)
            healthBar.text:SetPoint("CENTER")
            healthBar.text:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
        else
            local _, maxHealth = healthBar:GetMinMaxValues()
            local currentHealth = healthBar:GetValue()
            healthBar.text:SetText(string.format(math.floor((currentHealth / maxHealth) * 100 )) .. "%")
        end
    end

    local function nameplateHealthTextFrame(self)
        local inInstance, instanceType = IsInInstance("player")
        if inInstance then
            if self.unit and not UnitIsFriend("player", self.unit) then
                if self.unit and self.unit:find('nameplate%d') then
                    if self.healthBar and self.unit then
                        local unit = self.unit
                        local healthBar = self.healthBar
                        nameplateHealthText(unit, healthBar)
                    end
                end
            elseif instanceType == 'arena' or instanceType == 'pvp' then
                if self.unit and self.unit:find('nameplate%d') then
                    if self.healthBar and self.unit then
                        local unit = self.unit
                        local healthBar = self.healthBar
                        nameplateHealthText(unit, healthBar)
                    end
                end
            end
        else
            if self.unit and self.unit:find('nameplate%d') then
                if self.healthBar and self.unit then
                    local unit = self.unit
                    local healthBar = self.healthBar
                    nameplateHealthText(unit, healthBar)
                end
            end
        end
    end

    local function nameplatePlayerName(self)
        if ShouldShowName(self) then
            if self.optionTable.colorNameBySelection then
                local inInstance, instanceType = IsInInstance("player")
                if not inInstance then
                    -- Classcolor Playername
                    if db.color and self.unit then
                        local _, class = UnitClass(self.unit)
                        local color = RAID_CLASS_COLORS[class]
                        if UnitIsPlayer(self.unit) and self.name then
                            self.name:SetVertexColor(color.r, color.g, color.b)
                        end
                    end

                    -- Hide Servername
                    if db.server then
                        if self.name and self.unit then
                            if UnitIsPlayer(self.unit) then
                                local name, server = UnitName(self.unit)
                                self.name:SetText(name)
                            end
                        end
                    end
                elseif instanceType == 'arena' or instanceType == 'pvp' then
                    -- Classcolor Playername
                    if db.color and self.unit then
                        local _, class = UnitClass(self.unit)
                        local color = RAID_CLASS_COLORS[class]
                        if UnitIsPlayer(self.unit) and self.name then
                            self.name:SetVertexColor(color.r, color.g, color.b)
                        end
                    end

                    -- Hide Servername
                    if db.server then
                        if self.name and self.unit then
                            if UnitIsPlayer(self.unit) then
                                local name, server = UnitName(self.unit)
                                self.name:SetText(name)
                            end
                        end
                    end
                end

                -- Font Size Function
                local function SetFont(obj, optSize)
                    local fontName = obj:GetFont()   
                    obj:SetFont(fontName,optSize,"OUTLINE")
                end

                -- Set Font Size for Nameplate Names
                SetFont(SystemFont_LargeNamePlate,10)
                SetFont(SystemFont_NamePlate,10)
                SetFont(SystemFont_LargeNamePlateFixed,10)
                SetFont(SystemFont_NamePlateFixed,10)
            end
        end
    end

    local function nameplateTexture(self)
        local inInstance, instanceType = IsInInstance("player")
        if inInstance then
            if self.unit and not UnitIsFriend("player", self.unit) then
                if self.unit and self.unit:find('nameplate%d') then
                    if self.healthBar then
                        self.healthBar:SetStatusBarTexture(db.texture)
                    end
                end
            elseif instanceType == 'arena' or instanceType == 'pvp' then
                if self.unit and self.unit:find('nameplate%d') then
                    if self.healthBar then
                        self.healthBar:SetStatusBarTexture(db.texture)
                    end
                end
            end
        else
            if self.unit and self.unit:find('nameplate%d') then
                if self.healthBar then
                    self.healthBar:SetStatusBarTexture(db.texture)
                end
            end
        end
    end

    if db.style ~= 'Default' then
        -- Set Nameplate Texture
        if db.texture ~= 'Default' then
            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateStatusText", nameplateTexture)
        end

        --hooksecurefunc(NamePlateBaseMixin, "OnAdded", nameplateTexture)

        -- Set Nameplate Castbars
        hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", nameplateCastbar)

        -- Set Nameplate Health Percentage
        if db.healthtext then
            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateHealthTextFrame)
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateHealthTextFrame)
            hooksecurefunc("CompactUnitFrame_UpdateStatusText", nameplateHealthTextFrame)
        end

        -- Set Nameplate Name Color
        hooksecurefunc("CompactUnitFrame_UpdateName", nameplatePlayerName)
    end
end