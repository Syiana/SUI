local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates

    local function iconSkin(icon, parent)
        if not icon or (icon and icon.styled) then return end

        local backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 4,
            insets = {
                left = 4,
                right = 4,
                top = 4,
                bottom = 4,
            },
        }

        local frame = CreateFrame("Frame", nil, parent)

        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

        local border = frame:CreateTexture(nil, "BACKGROUND")
        border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer("BACKGROUND",- 7)
        --border:SetVertexColor(unpack(SUI:Color()))
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        icon.border = border

        local back = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        back:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
        back:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
        back:SetFrameLevel(frame:GetFrameLevel() - 1)
        back:SetBackdrop(backdrop)
        back:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
        back:SetAlpha(0.9)
        icon.bg = back
        icon.styled = true
    end

    local function nameplateCastbar(self, elapsed)
        if self.unit and self.unit:find('nameplate%d') then
            local _, _, _, _, _, _, _, castInterrupt = UnitCastingInfo(self.unit);
            local _, _, _, _, _, _, channelInterrupt, _, _, _ = UnitChannelInfo(self.unit);
            local inInstance, instanceType = IsInInstance("player")
            if inInstance then
                if not UnitIsFriend("player", self.unit) then
                    if self and self.Icon then
                        if self.BorderShield then
                            self.BorderShield:ClearAllPoints()
                            PixelUtil.SetPoint(self.BorderShield, "CENTER", self, "LEFT", -10, 0)
                        end
    
                        self.Icon:ClearAllPoints();
                        PixelUtil.SetPoint(self.Icon, "CENTER", self, "LEFT", -10, 0);
                        self.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                        iconSkin(self.Icon, self)
    
                        if castInterrupt or channelInterrupt then
                            self.Icon:Hide()
                            self.Icon.border:Hide()
                            self.Icon.bg:Hide()
                        else
                            self.Icon:Show()
                            self.Icon.border:Show()
                            self.Icon.bg:Show()
                        end

                        if db.casttime then
                            if not self.timer then
                                self.timer = self:CreateFontString(nil)
                                self.timer:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
                                self.timer:SetPoint("CENTER", self.Icon, "BOTTOM", 0, -5)
                                self.timer:SetDrawLayer("OVERLAY")
                            else
                                if self.casting then
                                    self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
                                elseif self.channeling then
                                    self.timer:SetText(format("%.1f", max(self.value, 0)))
                                else
                                    self.timer:SetText("")
                                end
                            end
                        end
                    end
                elseif instanceType == 'arena' or instanceType == 'pvp' then
                    if self and self.Icon then
                        if self.BorderShield then
                            self.BorderShield:ClearAllPoints()
                            PixelUtil.SetPoint(self.BorderShield, "CENTER", self, "LEFT", -10, 0)
                        end

                        self.Icon:ClearAllPoints();
                        PixelUtil.SetPoint(self.Icon, "CENTER", self, "LEFT", -10, 0);
                        self.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                        iconSkin(self.Icon, self)

                        if castInterrupt or channelInterrupt then
                            self.Icon:Hide()
                            self.Icon.border:Hide()
                            self.Icon.bg:Hide()
                        else
                            self.Icon:Show()
                            self.Icon.border:Show()
                            self.Icon.bg:Show()
                        end

                        if db.casttime then
                            if not self.timer then
                                self.timer = self:CreateFontString(nil)
                                self.timer:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
                                self.timer:SetPoint("CENTER", self.Icon, "BOTTOM", 0, -5)
                                self.timer:SetDrawLayer("OVERLAY")
                            else
                                if self.casting then
                                    self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
                                elseif self.channeling then
                                    self.timer:SetText(format("%.1f", max(self.value, 0)))
                                else
                                    self.timer:SetText("")
                                end
                            end
                        end
                    end
                end
            else
                if self and self.Icon then
                    if self.BorderShield then
                        self.BorderShield:ClearAllPoints()
                        PixelUtil.SetPoint(self.BorderShield, "CENTER", self, "LEFT", -10, 0)
                    end

                    self.Icon:ClearAllPoints();
                    PixelUtil.SetPoint(self.Icon, "CENTER", self, "LEFT", -10, 0);
                    self.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                    iconSkin(self.Icon, self)

                    if castInterrupt or channelInterrupt then
                        self.Icon:Hide()
                        self.Icon.border:Hide()
                        self.Icon.bg:Hide()
                    else
                        self.Icon:Show()
                        self.Icon.border:Show()
                        self.Icon.bg:Show()
                    end

                    if db.casttime then
                        if not self.timer then
                            self.timer = self:CreateFontString(nil)
                            self.timer:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
                            self.timer:SetPoint("CENTER", self.Icon, "BOTTOM", 0, -5)
                            self.timer:SetDrawLayer("OVERLAY")
                        else
                            if self.casting then
                                self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
                            elseif self.channeling then
                                self.timer:SetText(format("%.1f", max(self.value, 0)))
                            else
                                self.timer:SetText("")
                            end
                        end
                    end
                end
            end
        end
    end

    local function nameplateCastbarIcon(self)
        local inInstance, instanceType = IsInInstance("player")
        if inInstance then
            if not UnitIsFriend("player", self.unit) then
                if self.castBar and self.castBar.Icon then
                    if self.castBar.BorderShield then
                        self.castBar.BorderShield:ClearAllPoints()
                        PixelUtil.SetPoint(self.castBar.BorderShield, "CENTER", self.castBar, "LEFT", -10, 0)
                    end

                    self.castBar.Icon:ClearAllPoints();
                    PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
                    self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                end
            elseif instanceType == 'arena' or instanceType == 'pvp' then
                if self.castBar and self.castBar.Icon then
                    if self.castBar.BorderShield then
                        self.castBar.BorderShield:ClearAllPoints()
                        PixelUtil.SetPoint(self.castBar.BorderShield, "CENTER", self.castBar, "LEFT", -10, 0)
                    end

                    self.castBar.Icon:ClearAllPoints();
                    PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
                    self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                end
            end
        else
            if self.castBar and self.castBar.Icon then
                if self.castBar.BorderShield then
                    self.castBar.BorderShield:ClearAllPoints()
                    PixelUtil.SetPoint(self.castBar.BorderShield, "CENTER", self.castBar, "LEFT", -10, 0)
                end

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

        -- Set Nameplate Castbars
        hooksecurefunc(CastingBarMixin, "OnUpdate", nameplateCastbar)
        hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", nameplateCastbarIcon)

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