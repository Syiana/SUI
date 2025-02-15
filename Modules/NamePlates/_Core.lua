local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    if C_AddOns.IsAddOnLoaded('Plater') or C_AddOns.IsAddOnLoaded('TidyPlates_ThreatPlates') or C_AddOns.IsAddOnLoaded('TidyPlates') or C_AddOns.IsAddOnLoaded('Kui_Nameplates') then return end
    local db = SUI.db.profile.nameplates

    local focusTexture = [[Interface\AddOns\SUI\Media\Textures\Nameplates\focusTexture]]

    -- NPC Colors Table
    SUI_NPCColors = {}

    -- Insert NPC Colors with Keyvalues
    for _, npc in pairs(db.npccolors) do
        SUI_NPCColors[npc.id] = npc.color
    end

    -- Get Player Roles
    local getRoles = CreateFrame("Frame")
    local playerRole
    getRoles:RegisterEvent("PLAYER_ENTERING_WORLD")
    getRoles:RegisterEvent("GROUP_ROSTER_UPDATE")
    getRoles:RegisterEvent("PLAYER_ROLES_ASSIGNED")
    getRoles:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    getRoles:RegisterEvent("PET_DISMISS_START")
    getRoles:RegisterEvent("PET_DISMISS_START")

    getRoles:HookScript("OnEvent", function()
        playerRole = UnitGroupRolesAssigned("player")
    end)

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
        if SUI:Color() then
            back:SetBackdropBorderColor(unpack(SUI:Color(0.25)))
        end
        back:SetAlpha(0.9)
        icon.bg = back
        icon.styled = true
    end

    local function nameplateCastbar(self)
        if self:IsForbidden() then return end
        if self.unit and self.unit:find('nameplate%d') then
            local _, _, _, _, _, _, _, castInterrupt = UnitCastingInfo(self.unit);
            local _, _, _, _, _, _, channelInterrupt, _, _, _ = UnitChannelInfo(self.unit);

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

    local function nameplateCastbarIcon(self)
        if self:IsForbidden() then return end

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

    local function nameplateHealth(self)
        if self:IsForbidden() then return end

        if self.unit and self.unit:find('nameplate%d') then
            if self.healthBar and self.unit then
                if UnitName("player") ~= UnitName(self.unit) then
                    local unit = self.unit
                    local healthBar = self.healthBar

                    if not healthBar.text then
                        healthBar.text = healthBar:CreateFontString(nil, "ARTWORK", nil)
                        healthBar.text:SetPoint("CENTER")
                        healthBar.text:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
                    else
                        local maxHealth = UnitHealthMax(self.unit)
                        local currentHealth = UnitHealth(self.unit)
                        --local _, maxHealth = healthBar:GetMinMaxValues()
                        --local currentHealth = healthBar:GetValue()
                        healthBar.text:SetText(string.format("%." .. db.decimals .. "f",
                            (currentHealth / maxHealth) * 100) .. "%")
                    end

                    if db.colors then
                        if UnitIsPlayer(self.unit) or (not UnitCanAttack("player", self.unit)) then return end
                        local _, _, _, _, _, id = strsplit("-", UnitGUID(self.unit) or "")
                        local _, status = UnitDetailedThreatSituation("player", self.unit)
                        local color = SUI_NPCColors[tonumber(id)] or { r = 0, g = 1, b = 0.6, a = 1 }
                        local nColor = SUI_NPCColors[tonumber(id)] or { r = 1, g = 0, b = 0.3, a = 1 }

                        if playerRole == "TANK" then
                            if status and status == 3 then
                                healthBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                            elseif status and status == 2 then
                                healthBar:SetStatusBarColor(1, 0.8, 0, 1)
                            elseif status and (status == 1 or status == 0) then
                                healthBar:SetStatusBarColor(1, 0, 0.3, 1)
                            else
                                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                                    healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                                elseif (not UnitIsTapDenied(unit)) then
                                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                                    if reaction and UnitReaction(unit, "player") == 4 then
                                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                    elseif reaction and UnitReaction(unit, "player") == 2 then
                                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                    elseif reaction then
                                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                    else
                                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                    end
                                end
                            end
                        elseif playerRole == "HEALER" or playerRole == "DAMAGER" then
                            if status and status == 3 then
                                healthBar:SetStatusBarColor(1, 0, 0.3, 1)
                            elseif status and status == 2 then
                                healthBar:SetStatusBarColor(1, 0.8, 0, 1)
                            elseif status and (status == 1 or status == 0) then
                                healthBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                            else
                                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                                    healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                                elseif (not UnitIsTapDenied(unit)) then
                                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                                    if reaction and UnitReaction(unit, "player") == 4 then
                                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                    elseif reaction and UnitReaction(unit, "player") == 2 then
                                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                    elseif reaction then
                                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                    else
                                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                    end
                                end
                            end
                        else
                            if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                                healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                            elseif (not UnitIsTapDenied(unit)) then
                                local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                                if reaction and UnitReaction(unit, "player") == 4 then
                                    healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                elseif reaction and UnitReaction(unit, "player") == 2 then
                                    healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                elseif reaction then
                                    healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                                else
                                    healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function nameplatePlayerName(self)
        if self:IsForbidden() then return end
        if ShouldShowName(self) then
            if self.optionTable.colorNameBySelection then
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
    end

    local function nameplateTexture(self)
        if self:IsForbidden() then return end
        if self.unit and self.unit:find('nameplate%d') then
            if self.healthBar then
                if not UnitIsUnit(self.unit, "focus") then
                    self.healthBar:SetStatusBarTexture(db.texture)
                else
                    self.healthBar:SetStatusBarTexture(focusTexture)
                end

                ClassNameplateManaBarFrame:SetStatusBarTexture(db.texture)
            end
        end
    end

    if db.style ~= 'Default' then
        -- Set Nameplate Texture
        if db.texture ~= [[Interface\Default]] then
            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateTexture)
            hooksecurefunc("CompactUnitFrame_UpdateStatusText", nameplateTexture)
        end

        -- Set Heal Prediction Texture
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(self)
            if self:IsForbidden() then return end
            if not strfind(self.unit, "nameplate") then return end
            local inInstance, instanceType = IsInInstance()

            self.myHealPrediction:SetTexture(db.texture)
            self.myHealPrediction:SetVertexColor(16 / 510, 424 / 510, 400 / 510)
            self.otherHealPrediction:SetTexture(db.texture)
            self.otherHealPrediction:SetVertexColor(0 / 510, 325 / 510, 292 / 510)
        end)

        -- Set Nameplate Castbars
        hooksecurefunc(CastingBarMixin, "OnUpdate", nameplateCastbar)
        hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", nameplateCastbarIcon)

        -- Set Nameplate Health Percentage
        if db.healthtext then
            hooksecurefunc("CompactUnitFrame_UpdateHealthColor", nameplateHealth)
            hooksecurefunc("CompactUnitFrame_UpdateHealth", nameplateHealth)
            hooksecurefunc("CompactUnitFrame_UpdateStatusText", nameplateHealth)
        end

        -- Set Nameplate Name Color
        hooksecurefunc("CompactUnitFrame_UpdateName", nameplatePlayerName)

        -- Set Focus Texture
        local focus = CreateFrame("Frame")
        focus:RegisterEvent("PLAYER_FOCUS_CHANGED")
        focus:HookScript("OnEvent", function()
            if not db.focusHighlight then return end

            for _, nameplate in pairs(C_NamePlate.GetNamePlates()) do
                local unit = nameplate.namePlateUnitToken

                if UnitIsUnit(unit, "focus") then
                    nameplate.UnitFrame.HealthBarsContainer.healthBar:SetStatusBarTexture(focusTexture)
                else
                    nameplate.UnitFrame.HealthBarsContainer.healthBar:SetStatusBarTexture(db.texture)
                end
            end
        end)
    end
end
