local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    local db = SUI.db.profile.nameplates

    local function nameplateTexture(self)
        if self.UnitFrame then
            if self.UnitFrame.healthBar then
                if db.texture ~=[[Interface\Default]] then
                    self.UnitFrame.healthBar:SetStatusBarTexture(db.texture)
                end
            end
        end
    end

    local function nameplateCastbar(self)
        if self.castBar then
            self.castBar.Icon:ClearAllPoints();
            PixelUtil.SetPoint(self.castBar.Icon, "CENTER", self.castBar, "LEFT", -10, 0);
            self.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        end
    end

    if db.style ~= 'Default' then
        -- Set Nameplate Texture
        hooksecurefunc(NamePlateBaseMixin, "OnAdded", nameplateTexture)

        -- Set Nameplate Castbars
        hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", nameplateCastbar)

        -- Set Nameplate Color
        hooksecurefunc("CompactUnitFrame_UpdateName", function(self)
            if ShouldShowName(self) then
                if self.optionTable.colorNameBySelection then
                    -- Classcolor Playername
                    local _, class = UnitClass(self.unit)
                    local color = RAID_CLASS_COLORS[class]
                    if UnitIsPlayer(self.unit) then
                        self.name:SetVertexColor(color.r, color.g, color.b)
                    end
                    
                    -- Hide Servername
                    if self.name then
                        local name, server = UnitName(self.unit)
                        self.name:SetText(name)
                    end
                end
            end
        end)
    end
end