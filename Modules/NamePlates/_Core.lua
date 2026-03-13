local Module = SUI:NewModule("NamePlates.Core");

function Module:OnEnable()
    if C_AddOns.IsAddOnLoaded('Plater') or C_AddOns.IsAddOnLoaded('TidyPlates_ThreatPlates') or C_AddOns.IsAddOnLoaded('TidyPlates') or C_AddOns.IsAddOnLoaded('Kui_Nameplates') then return end
    local db = SUI.db.profile.nameplates
    local unitframes = SUI.db.profile.unitframes
    local _, playerClass = UnitClass("player")
    local playerClassColor = RAID_CLASS_COLORS[playerClass]

    local focusTexture = [[Interface\AddOns\SUI\Media\Textures\Nameplates\focusTexture]]

    local function personalBarConfig()
        local cfg = unitframes.personalbar or {}
        return {
            texture = cfg.texture or SUI.db.profile.general.texture,
            width = cfg.width or 110,
            height = cfg.height or 4,
            manaheight = cfg.manaheight or 4
        }
    end

    local function getPersonalHealthContainer()
        return PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.HealthBarsContainer or nil
    end

    local function getPersonalHealthBar()
        local container = getPersonalHealthContainer()
        if not container then
            return nil
        end

        if container.healthBar and container.healthBar.SetStatusBarColor then
            return container.healthBar
        end

        if container.SetStatusBarColor and container.SetStatusBarTexture then
            return container
        end

        return nil
    end

    local function getPersonalPowerBar()
        if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.PowerBar then
            return PersonalResourceDisplayFrame.PowerBar
        end

        if ClassNameplateManaBarFrame then
            return ClassNameplateManaBarFrame
        end

        return nil
    end

    local function getPersonalExtraBar()
        return ClassNameplateBrewmasterBarFrame
    end

    local function setTexture(textureObject, texturePath)
        if textureObject and textureObject.SetTexture then
            textureObject:SetTexture(texturePath)
        end
    end

    local function applyTextureToPredictionBar(bar)
        local cfg = personalBarConfig()
        if not bar or cfg.texture == [[Interface\Default]] then
            return
        end

        if bar.SetStatusBarTexture then
            bar:SetStatusBarTexture(cfg.texture)
        end

        if bar.GetStatusBarTexture and bar:GetStatusBarTexture() then
            bar:GetStatusBarTexture():SetDrawLayer("BORDER")
        end

        if bar.SetTexture then
            bar:SetTexture(cfg.texture)
        end
    end

    local function applyHealPredictionTextures(frame, usePersonalTexture)
        if not frame then
            return
        end

        local texture = usePersonalTexture and personalBarConfig().texture or db.texture
        if texture == [[Interface\Default]] then
            return
        end

        if frame.myHealPrediction then
            frame.myHealPrediction:SetTexture(texture)
            frame.myHealPrediction:SetVertexColor(16 / 510, 424 / 510, 400 / 510)
        end

        if frame.otherHealPrediction then
            frame.otherHealPrediction:SetTexture(texture)
            frame.otherHealPrediction:SetVertexColor(0 / 510, 325 / 510, 292 / 510)
        end

        if frame.totalAbsorb then
            frame.totalAbsorb:SetTexture(texture)
        end
    end

    local function applyBarTexture(bar)
        if not bar then return end
        local cfg = personalBarConfig()
        if cfg.texture == [[Interface\Default]] then return end

        if bar.SetStatusBarTexture then
            bar:SetStatusBarTexture(cfg.texture)
            if bar.GetStatusBarTexture and bar:GetStatusBarTexture() then
                bar:GetStatusBarTexture():SetDrawLayer("BORDER")
            end
        end

        if bar.Texture then
            setTexture(bar.Texture, cfg.texture)
        end

        if bar.texture then
            setTexture(bar.texture, cfg.texture)
        end

        if bar.GetRegions then
            for _, region in ipairs({ bar:GetRegions() }) do
                if region and region.GetObjectType and region:GetObjectType() == "Texture" and region.SetTexture then
                    local name = region.GetName and region:GetName() or ""
                    if name:find("Texture") or name:find("barTexture") or name:find("BarTexture") then
                        region:SetTexture(cfg.texture)
                    end
                end
            end
        end
    end

    local function enforceBarTexture(bar)
        if not bar or bar.suiTextureHooked or not bar.SetStatusBarTexture then
            return
        end

        hooksecurefunc(bar, "SetStatusBarTexture", function(self)
            local cfg = personalBarConfig()
            if self.suiApplyingTexture or cfg.texture == [[Interface\Default]] then
                return
            end

            self.suiApplyingTexture = true
            self:SetStatusBarTexture(cfg.texture)
            self.suiApplyingTexture = nil
        end)

        bar.suiTextureHooked = true
    end

    local function enforceBarWidth(bar)
        if not bar or bar.suiWidthHooked or not bar.SetWidth then
            return
        end

        hooksecurefunc(bar, "SetWidth", function(self)
            local width = personalBarConfig().width
            if self.suiApplyingWidth then
                return
            end

            self.suiApplyingWidth = true
            self:SetWidth(width)
            self.suiApplyingWidth = nil
        end)

        bar.suiWidthHooked = true
    end

    local function applyPersonalResourceSize()
        local root = PersonalResourceDisplayFrame
        local container = getPersonalHealthContainer()
        local healthBar = getPersonalHealthBar()
        local manaBar = getPersonalPowerBar()
        local extraBar = getPersonalExtraBar()
        local cfg = personalBarConfig()

        if C_NamePlate and C_NamePlate.SetNamePlateSelfSize then
            C_NamePlate.SetNamePlateSelfSize(cfg.width, 45)
        end

        if NamePlatePlayerResourceFrame and NamePlatePlayerResourceFrame.SetWidth then
            enforceBarWidth(NamePlatePlayerResourceFrame)
            NamePlatePlayerResourceFrame:SetWidth(cfg.width)
        end

        if root and root.SetWidth then
            enforceBarWidth(root)
            root:SetWidth(cfg.width)
        end

        if container and container.SetWidth then
            enforceBarWidth(container)
            container:SetWidth(cfg.width)
        end

        if healthBar and healthBar.SetWidth then
            enforceBarWidth(healthBar)
            healthBar:SetWidth(cfg.width)
        end

        if container and container.SetHeight then
            container:SetHeight(cfg.height)
        end

        if healthBar and healthBar.SetHeight then
            healthBar:SetHeight(cfg.height)
        end

        if manaBar and manaBar.SetWidth then
            enforceBarWidth(manaBar)
            manaBar:SetWidth(cfg.width)
        end

        if manaBar and manaBar.SetHeight then
            manaBar.bbpHeight = cfg.manaheight
            manaBar:SetHeight(cfg.manaheight)
        end

        if manaBar and manaBar.Texture and manaBar.Texture.SetWidth then
            manaBar.Texture:SetWidth(cfg.width)
        end

        if manaBar and manaBar.background and manaBar.background.SetWidth then
            manaBar.background:SetWidth(cfg.width)
        end

        if extraBar and extraBar.SetWidth then
            enforceBarWidth(extraBar)
            extraBar:SetWidth(cfg.width)
        end
    end

    local function updatePersonalResourceBars()
        local container = getPersonalHealthContainer()
        local healthBar = getPersonalHealthBar()
        local manaBar = getPersonalPowerBar()
        local manaAlias = ClassNameplateManaBarFrame
        local extraBar = getPersonalExtraBar()

        applyPersonalResourceSize()

        if healthBar and playerClassColor then
            enforceBarTexture(healthBar)
            applyBarTexture(healthBar)
            healthBar:SetStatusBarColor(playerClassColor.r, playerClassColor.g, playerClassColor.b)
        end

        applyHealPredictionTextures(NamePlatePlayerResourceFrame and NamePlatePlayerResourceFrame.UnitFrame, true)

        if container then
            applyTextureToPredictionBar(container.myHealPrediction)
            applyTextureToPredictionBar(container.otherHealPrediction)
            applyTextureToPredictionBar(container.totalAbsorb)
            applyTextureToPredictionBar(container.myHealAbsorb)
            applyTextureToPredictionBar(container.overAbsorbGlow)
            applyTextureToPredictionBar(container.overHealAbsorbGlow)
        end

        if manaBar then
            enforceBarTexture(manaBar)
            applyBarTexture(manaBar)

            if manaBar.FullPowerFrame then
                manaBar.FullPowerFrame:SetAlpha(0)
            end

            if manaBar.FeedbackFrame then
                manaBar.FeedbackFrame:SetAlpha(0)
            end

            applyTextureToPredictionBar(manaBar.ManaCostPredictionBar)
            applyTextureToPredictionBar(manaBar.ManaCostPredictionBarOverlay)

            local _, powerToken = UnitPowerType("player")
            local powerColor = PowerBarColor[powerToken] or PowerBarColor["MANA"]
            if powerColor then
                if manaBar.SetStatusBarColor then
                    manaBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                end
                if manaBar.Texture and manaBar.Texture.SetVertexColor then
                    manaBar.Texture:SetVertexColor(powerColor.r, powerColor.g, powerColor.b)
                end
            end
        end

        if manaAlias and manaAlias ~= manaBar then
            enforceBarTexture(manaAlias)
            applyBarTexture(manaAlias)
            manaAlias.bbpHeight = personalBarConfig().manaheight
            if manaAlias.SetHeight then
                manaAlias:SetHeight(manaAlias.bbpHeight)
            end
        end

        if extraBar then
            enforceBarTexture(extraBar)
            applyBarTexture(extraBar)
        end
    end

    local personalBarHooksInstalled = false
    local function installPersonalResourceHooks()
        if personalBarHooksInstalled then
            return
        end

        local healthBar = getPersonalHealthBar()
        if not healthBar then
            return
        end

        hooksecurefunc(healthBar, "SetStatusBarColor", function(bar)
            if bar.suiUpdatingColor or not playerClassColor then
                return
            end

            bar.suiUpdatingColor = true
            bar:SetStatusBarColor(playerClassColor.r, playerClassColor.g, playerClassColor.b)
            bar.suiUpdatingColor = nil
        end)

        local function hookManaBarHeight(bar)
            if not bar or bar.suiHeightHooked or not bar.SetHeight then
                return
            end

            hooksecurefunc(bar, "SetHeight", function(self)
                local height = self.bbpHeight or personalBarConfig().manaheight
                if self.changing then
                    return
                end

                self.changing = true
                self:SetHeight(height)
                self.changing = false
            end)
            bar.suiHeightHooked = true
        end

        hookManaBarHeight(getPersonalPowerBar())
        hookManaBarHeight(ClassNameplateManaBarFrame)

        personalBarHooksInstalled = true
    end

    local function isPersonalResourceFrame(self)
        if not self then return false end

        local parent = self:GetParent()
        local parentName = parent and parent.GetName and parent:GetName()

        return (self.unit == "player" or self.displayedUnit == "player") and
            (parent == NamePlatePlayerResourceFrame or parent == PersonalResourceDisplayFrame or
                parentName == "NamePlatePlayerResourceFrame" or parentName == "PersonalResourceDisplayFrame")
    end

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
                if isPersonalResourceFrame(self) then
                    applyBarTexture(self.healthBar)
                elseif not UnitIsUnit(self.unit, "focus") then
                    self.healthBar:SetStatusBarTexture(db.texture)
                else
                    self.healthBar:SetStatusBarTexture(focusTexture)
                end

                local manaBar = getPersonalPowerBar()
                if manaBar then
                    applyBarTexture(manaBar)
                end

                if ClassNameplateBrewmasterBarFrame and ClassNameplateBrewmasterBarFrame.SetStatusBarTexture then
                    ClassNameplateBrewmasterBarFrame:SetStatusBarTexture(db.texture)
                end
            end
        end
    end

    local function personalResourceStyle(self)
        if self:IsForbidden() then return end
        if not playerClassColor then return end
        if not self.healthBar then return end

        if isPersonalResourceFrame(self) then
            local manaBar = getPersonalPowerBar()
            local extraBar = getPersonalExtraBar()

            applyBarTexture(self.healthBar)
            self.healthBar:SetStatusBarColor(playerClassColor.r, playerClassColor.g, playerClassColor.b)

            if manaBar then
                applyBarTexture(manaBar)
                local powerType = select(2, UnitPowerType("player"))
                local powerColor = PowerBarColor[powerType] or PowerBarColor["MANA"]
                if powerColor then
                    if manaBar.SetStatusBarColor then
                        manaBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                    end
                    if manaBar.Texture and manaBar.Texture.SetVertexColor then
                        manaBar.Texture:SetVertexColor(powerColor.r, powerColor.g, powerColor.b)
                    end
                end
            end

            if extraBar then
                applyBarTexture(extraBar)
            end
        end
    end

    function Module:RefreshPersonalResource()
        installPersonalResourceHooks()
        if NamePlatePlayerResourceFrame and NamePlatePlayerResourceFrame.UnitFrame then
            personalResourceStyle(NamePlatePlayerResourceFrame.UnitFrame)
        end
        updatePersonalResourceBars()
    end

    local personalResource = CreateFrame("Frame")
    personalResource:RegisterEvent("PLAYER_LOGIN")
    personalResource:RegisterEvent("PLAYER_ENTERING_WORLD")
    personalResource:RegisterEvent("UNIT_POWER_UPDATE")
    personalResource:RegisterEvent("UNIT_DISPLAYPOWER")
    personalResource:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    personalResource:HookScript("OnEvent", function(_, _, unit)
        if unit and unit ~= "player" then return end
        installPersonalResourceHooks()
        if NamePlatePlayerResourceFrame and NamePlatePlayerResourceFrame.UnitFrame then
            personalResourceStyle(NamePlatePlayerResourceFrame.UnitFrame)
        end
        updatePersonalResourceBars()
    end)

    if type(UnitFramePersonalResourceBarMixin_UpdatePowerBarTextureAndColor) == "function" then
        hooksecurefunc("UnitFramePersonalResourceBarMixin_UpdatePowerBarTextureAndColor", updatePersonalResourceBars)
    end

    if type(UnitFrameManaBar_UpdateType) == "function" then
        hooksecurefunc("UnitFrameManaBar_UpdateType", updatePersonalResourceBars)
    end

    if PersonalResourceDisplayFrame and PersonalResourceDisplayFrame.HookScript then
        PersonalResourceDisplayFrame:HookScript("OnShow", updatePersonalResourceBars)
    end

    if C_NamePlate and C_NamePlate.SetNamePlateSelfSize then
        local widthEnforcer = CreateFrame("Frame")
        widthEnforcer:RegisterEvent("PLAYER_LOGIN")
        widthEnforcer:RegisterEvent("PLAYER_ENTERING_WORLD")
        widthEnforcer:RegisterEvent("PLAYER_TARGET_CHANGED")
        widthEnforcer:RegisterEvent("NAME_PLATE_UNIT_ADDED")
        widthEnforcer:SetScript("OnEvent", function(_, _, unit)
            if unit and unit ~= "player" then
                return
            end
            local cfg = personalBarConfig()
            C_NamePlate.SetNamePlateSelfSize(cfg.width, 45)
        end)
    end
    installPersonalResourceHooks()
    updatePersonalResourceBars()

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
            applyHealPredictionTextures(self, isPersonalResourceFrame(self))
        end)
        hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", function(self)
            if self:IsForbidden() then return end
            if not strfind(self.unit, "nameplate") then return end
            applyHealPredictionTextures(self, isPersonalResourceFrame(self))
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
        hooksecurefunc("CompactUnitFrame_UpdateHealthColor", personalResourceStyle)
        hooksecurefunc("CompactUnitFrame_UpdateHealth", personalResourceStyle)

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
