local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates

    local function nameplateCastbar(self)
        if self.castBar then
            self.castBar.Icon:ClearAllPoints();
            PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
            self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        end
    end
    
    local function nameplateHealthText(unit, healthBar)
        if not healthBar.text then
            healthBar.text = healthBar:CreateFontString(nil, "ARTWORK")
            healthBar.text:SetPoint("CENTER")
            healthBar.text:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
        else
            local _, maxHealth = healthBar:GetMinMaxValues()
            local currentHealth = healthBar:GetValue()
            healthBar.text:SetText(string.format(math.floor((currentHealth / maxHealth) * 100 )) .. "%")
        end
    end

    local function nameplateHealthTextFrame(self)
        if self.unit and self.unit:find('nameplate%d') then
            if self.healthBar then
                local unit = self.unit
                local healthBar = self.healthBar
                nameplateHealthText(unit, healthBar)
            end
        end
    end

    local function nameplatePlayerName(self)
        if ShouldShowName(self) then
            if self.optionTable.colorNameBySelection then
                -- Classcolor Playername
                if db.color then
                    local _, class = UnitClass(self.unit)
                    local color = RAID_CLASS_COLORS[class]
                    if UnitIsPlayer(self.unit) then
                        self.name:SetVertexColor(color.r, color.g, color.b)
                    end
                end

                -- Hide Servername
                if db.server then
                    if self.name then
                        local name, server = UnitName(self.unit)
                        self.name:SetText(name)
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
        if self.UnitFrame then
            if self.UnitFrame.healthBar then
                if db.texture ~=[[Interface\Default]] then
                    self.UnitFrame.healthBar:SetStatusBarTexture(db.texture)
                end
            end
        end
    end

    if db.style ~= 'Default' then
        -- Set Nameplate Texture
        hooksecurefunc(NamePlateBaseMixin, "OnAdded", nameplateTexture)
        

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