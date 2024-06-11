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
        border:SetDrawLayer("BACKGROUND", -7)
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
        back:SetBackdropBorderColor(.15, .15, .15)
        back:SetAlpha(0.9)
        icon.bg = back
        icon.styled = true
    end

    local function nameplateCastbar(self)
        if self.unit and self.unit:find('nameplate%d') then
            if self:IsForbidden() then return end

            if self and self.Icon then
                self.Icon:ClearAllPoints();
                PixelUtil.SetPoint(self.Icon, "CENTER", self, "LEFT", -11.25, 2.5);
                self.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                iconSkin(self.Icon, self)

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

    local function nameplateTexture(self)
        if self:IsForbidden() then return end
        if self.unit and self.unit:find('nameplate%d') then
            if self.healthBar then
                self.healthBar:SetStatusBarTexture(db.texture)
                self.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                self.CastBar:SetStatusBarTexture(db.texture)
                self.CastBar:GetStatusBarTexture():SetDrawLayer("BORDER")

                if not self.barFixed then
                    self.healthBar:SetHeight(self.healthBar:GetHeight()-0.4)
                    self.healthBar:SetWidth(self.healthBar:GetWidth()-0.5)
                    self.CastBar:SetHeight(self.CastBar:GetHeight() - 0.05)
                    self.CastBar:SetWidth(self.CastBar:GetWidth() - 0.02)

                    self.barFixed = true
                end
            end
        end
    end

    local function nameplatePlayerName(self)
        if ShouldShowName(self) then
            if self:IsForbidden() then return end

            -- Classcolor Playername
            if self.unit then
                local _, class = UnitClass(self.unit)
                local color = RAID_CLASS_COLORS[class]
                if color then
                    if UnitIsPlayer(self.unit) and self.name then
                        self.name:SetVertexColor(color.r, color.g, color.b)
                    end
                end
            end

            -- Font Size Function
            local function SetFont(obj, optSize)
                local fontName = obj:GetFont()
                obj:SetFont(fontName, optSize, "OUTLINE")
            end

            -- Set Font Size for Nameplate Names
            SetFont(SystemFont_LargeNamePlate, 10)
            SetFont(SystemFont_NamePlate, 10)
            SetFont(SystemFont_LargeNamePlateFixed, 10)
            SetFont(SystemFont_NamePlateFixed, 10)
        end
    end

    if db.style ~= 'Default' then
        if db.texture ~= 'Default' then
            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateStatusText", nameplateTexture)
        end

        if db.classcolor then
            hooksecurefunc("CompactUnitFrame_UpdateName", nameplatePlayerName)
        end

        hooksecurefunc("CastingBarFrame_OnUpdate", nameplateCastbar)
    end
end
