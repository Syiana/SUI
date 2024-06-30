local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    if IsAddOnLoaded('Plater') or IsAddOnLoaded('TidyPlates_ThreatPlates') or IsAddOnLoaded('TidyPlates') or IsAddOnLoaded('Kui_Nameplates') then return end
    local db = SUI.db.profile.nameplates

    local totems = {
        -- NPC ID, SpellID, Totem Name
        ["10467"] = { 16190, "Mana Tide Totem" },
        ["5913"] = { 8143, "Tremor Totem" },
        ["2630"] = { 2484, "Earthbind Totem" },
        ["3527"] = { 5394, "Healing Stream Totem" },
        ["5925"] = { 8177, "Grounding Totem" },
        ["53006"] = { 98008, "Spirit Link Totem" },
        ["5950"] = { 8227, "Flametongue Totem" },
        ["6112"] = { 8512, "Windfury Totem" },
        ["15447"] = { 3738, "Wrath of Air Totem" },
        ["2523"] = { 3599, "Searing Totem" },
        ["3573"] = { 5675, "Mana Spring Totem" }
    }

    local hiddenTotems = {
        -- NPC ID, SpellID, Totem Name
        ["15430"] = { 2062, "Earth Elemental Totem" },
        ["15439"] = { 2894, "Fire Elemental Totem" },
        ["3579"] = { 5730, "Stoneclaw Totem" },
        ["5873"] = { 8071, "Stoneskin Totem" },
        ["5874"] = { 8075, "Strength of Earth Totem" },
        ["5929"] = { 8190, "Magma Totem" },
        ["5927"] = { 8184, "Elemental Resistance Totem" },
        ["47069"] = { 87718, "Totem of Tranquil Mind" },
    }

    local activeTotems = {}

    local function createIcon(nameplate)
        local frame = CreateFrame("Frame")
        frame:SetSize(30, 30)
        frame:SetPoint("BOTTOM", nameplate, "TOP", 0, -30)

        local icon = frame:CreateTexture(nil, "ARTWORK")
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetAllPoints()

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
        bg:SetVertexColor(0, 0, 0, 0.5)
        bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
        bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)

        frame.icon = icon
        frame.bg = bg

        return frame
    end

    local function iconSkin(icon, parent)
        if not icon or (icon and icon.styled) then return end

        local backdrop = {
            bgFile = nil,
            edgeFile = [[Interface\Addons\SUI\Media\Textures\Core\outer_shadow]],
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
        border:SetTexture([[Interface\Addons\SUI\Media\Textures\Core\gloss]])
        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer("BACKGROUND", -7)
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

                self.Border:ClearAllPoints()
                self.Border:SetPoint("CENTER", self, -8.6, 8)

                if not self.castText then
                    self.castText = self:CreateFontString(nil)
                    self.castText:SetPoint("CENTER", 0, 1.2)
                    self.castText:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
                else
                    local nameChannel = UnitChannelInfo(self.unit)
                    local nameSpell   = UnitCastingInfo(self.unit)
                    self.castText:SetText(nameChannel or nameSpell)
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

                local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo(self.unit)
                local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo(self.unit)

                if (notInterruptibleCast) then
                    self:SetStatusBarColor(.7, .7, .7)
                elseif (notInterruptibleChannel) then
                    self:SetStatusBarColor(.7, .7, .7)
                else
                    local color
                    local isChannel = UnitChannelInfo("player");

                    if (isChannel) then
                        color = self.startChannelColor
                    else
                        color = self.startCastColor
                    end

                    self:SetStatusBarColor(color.r, color.g, color.b)
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

                if (db.totems) then
                    if (self.totemIcon) then
                        self.totemIcon:Hide()
                    end

                    self.name:SetAlpha(1)
                    self.healthBar:Show()
                    self.LevelFrame:Show()

                    if (not UnitIsPlayer(self.unit)) and (UnitPlayerControlled(self.unit)) then
                        if (UnitCanAttack("player", self.unit)) then
                            local _, _, _, _, _, id = strsplit("-", UnitGUID(self.unit) or "")

                            if (id and hiddenTotems[id]) then
                                self.healthBar:Hide()
                                self.name:SetAlpha(0)
                                self.LevelFrame:Hide()
                            elseif (id and totems[id]) then
                                if not (self.totemIcon) then
                                    self.totemIcon = createIcon(self)
                                end

                                local iconFrame = self.totemIcon
                                iconFrame:Show()

                                local spellID = unpack(totems[id])
                                local texture = GetSpellTexture(spellID)

                                iconFrame.icon:SetTexture(texture)
                                self.name:SetAlpha(0)
                                self.healthBar:Hide()
                                self.LevelFrame:Hide()
                            end
                        end
                    end
                end

                if not self.barFixed then
                    self.healthBar:SetWidth(self.healthBar:GetWidth() - 0.7)
                    self.barFixed = true
                end
            end
        end
    end

    local function nameplatePlayerName(self)
        if ShouldShowName(self) then
            if self:IsForbidden() then return end

            -- Classcolor Playername
            if self.unit and self.unit:find('nameplate%d') then
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

    local function nameplateBorderColor(self)
        if self:IsForbidden() then return end

        if self.unit and self.unit:find('nameplate%d') then
            if db.highlight then
                if (UnitIsUnit("target", self.unit)) then
                    SUI:Skin(self.healthBar.border, false, false, {r = .6, g = .6, b = .6})
                else
                    SUI:Skin(self.healthBar.border)
                end
            else
                SUI:Skin(self.healthBar.border)
            end

            SUI:Skin({ self.CastBar.Border, self.CastBar.BorderShield }, false, true)
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

        if SUI:Color() then
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateBorderColor)
            hooksecurefunc("CompactUnitFrame_OnEvent", nameplateBorderColor)
        end
    end
end
