local _, nPlates = ...

local englishFaction, localizedFaction = UnitFactionGroup("player")
local _, playerClass = UnitClass("player")

nPlatesMixin = {}

nPlates.plateGUIDS = {}

function nPlatesMixin:OnLoad()
    self.plateGUIDS = {}

    local events = {
        "ADDON_LOADED",
        "NAME_PLATE_CREATED",
        "NAME_PLATE_UNIT_ADDED",
        "PLAYER_REGEN_DISABLED",
        "PLAYER_REGEN_ENABLED",
        "RAID_TARGET_UPDATE",
        -- "COMBAT_LOG_EVENT_UNFILTERED",
    }

    FrameUtil.RegisterFrameForEvents(self, events)
end

function nPlatesMixin:OnEvent(event, ...)
    if ( event == "ADDON_LOADED" ) then
        local name = ...

        if ( name == "nPlates" ) then
            nPlates:SetDefaultOptions()
            nPlates:CVarCheck()

            self:UnregisterEvent(event)
        end
    elseif ( event == "NAME_PLATE_CREATED" ) then
        local namePlateFrameBase = ...
        nPlates:SetupNameplate(namePlateFrameBase)
    elseif ( event == "NAME_PLATE_UNIT_ADDED" ) then
        local unit = ...
        nPlates:FixPlayerBorder(unit)

        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure())
        nPlates:UpdateNameplate(namePlateFrameBase)
        -- nPlates.plateGUIDS[UnitGUID(unit)] = unit

    elseif ( event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" ) then
        if ( not SUI.db.profile.nameplates.options.CombatPlates ) then
            return
        end
        C_CVar.SetCVar("nameplateShowEnemies", event == "PLAYER_REGEN_DISABLED" and 1 or 0)
    elseif ( event == "RAID_TARGET_UPDATE" ) then
        nPlates:UpdateRaidMarkerColoring()
    elseif ( event == "COMBAT_LOG_EVENT_UNFILTERED" ) then
        nPlates:COMBAT_LOG_EVENT_UNFILTERED()
    end
end

    -- Hook CompactUnitFrame OnEvent function.

local function CUF_OnEvents(self, event, ...)
    if ( self:IsForbidden() ) then return end
    if ( not self.isNameplate ) then return end

    local unit = ...

    if ( event == "PLAYER_TARGET_CHANGED" ) then
        nPlates:UpdateBuffFrameAnchorsByFrame(self)
    else
        -- local unitMatches = unit == self.unit or unit == self.displayedUnit
		-- if ( unitMatches ) then
            -- if ( event == "UNIT_AURA") then
            -- end
        -- end
    end
end

    -- Update Castbar Time

local function UpdateCastbarTimer(self)
    if ( self:IsForbidden() ) then return end

    if ( self.unit ) then
        if ( self.castBar.casting ) then
            local current = self.castBar.maxValue - self.castBar.value
            if ( current > 0 ) then
                self.castBar.CastTime:SetText(nPlates:FormatTime(current))
            end
        else
            if ( self.castBar.value > 0 ) then
                self.castBar.CastTime:SetText(nPlates:FormatTime(self.castBar.value))
            end
        end
    end
end

    --- Skin Castbar

local function UpdateCastbar(self)
    if ( self:IsForbidden() ) then return end

        -- Castbar Overlay Coloring

    local name, text, texture, isTradeSkill, notInterruptible

    if ( self.unit ) then
        if ( self.castBar.casting ) then
            name, text, texture, _, _, isTradeSkill, _, notInterruptible = UnitCastingInfo(self.unit)
        else
            name, text, texture, _, _, isTradeSkill, notInterruptible = UnitChannelInfo(self.unit)
        end

        if ( isTradeSkill or not UnitCanAttack("player", self.unit) ) then
            nPlates:SetCastbarBorderColor(self, nPlates.defaultBorderColor)
        else
            nPlates:UpdateInterruptibleState(self.castBar, notInterruptible)
        end
    end

    if ( self.castBar.Background ) then
        self.castBar.Background:SetShown(not self.castBar.Icon:IsVisible())
    end

        -- Abbreviate Long Spell Names

    if ( not nPlates:IsUsingLargerNamePlateStyle() ) then
        self.castBar.Text:SetText(nPlates:Abbreviate(text))
    end
end

    -- Updated Health Text

local function UpdateStatusText(self)
    if ( self:IsForbidden() ) then return end
    if ( self.statusText ) then return end

    if ( not self.healthBar.value ) then
        self.healthBar.value = self.healthBar:CreateFontString("$parentHeathValue", "OVERLAY")
        self.healthBar.value:SetPoint("CENTER", self.healthBar)
        self.healthBar.value:SetFontObject(GameFontNormal)
    end

    local option = SUI.db.profile.nameplates.options.CurrentHealthOption

    if ( option == "HealthDisabled" ) then
        self.healthBar.value:Hide()
    else
        local health = UnitHealth(self.displayedUnit)
        local maxHealth = UnitHealthMax(self.displayedUnit)

        if ( option == "HealthBoth" ) then
            local perc = math.floor((health/maxHealth) * 100)
            if ( perc >= 100 ) then
                self.healthBar.value:SetFormattedText("%s", nPlates:FormatValue(health))
                self.healthBar.value:Show()
            else
                self.healthBar.value:SetFormattedText("%s - %s%%", nPlates:FormatValue(health), perc)
                self.healthBar.value:Show()
            end
        elseif ( option == "PercentHealth" ) then
            local perc = math.floor((health/maxHealth) * 100)
            if ( perc >= 100 ) then
                self.healthBar.value:SetFormattedText("%s", nPlates:FormatValue(health))
                self.healthBar.value:Show()
            else
                self.healthBar.value:SetFormattedText("%s%% - %s", perc, nPlates:FormatValue(health))
                self.healthBar.value:Show()
            end
        elseif ( option == "HealthValueOnly" ) then
            self.healthBar.value:SetFormattedText("%s", nPlates:FormatValue(health))
            self.healthBar.value:Show()
        elseif ( option == "HealthPercOnly" ) then
            local perc = math.floor((health/maxHealth) * 100)
            self.healthBar.value:SetFormattedText("%s%%", perc)
            self.healthBar.value:Show()
        else
            self.healthBar.value:Hide()
        end
    end
end

    -- Update Health Color

local function UpdateHealthColor(self)
    if ( self:IsForbidden() ) then return end
    if ( not self.isNameplate ) then return end

    local r, g, b
    if ( not UnitIsConnected(self.unit) ) then
        r, g, b = 0.5, 0.5, 0.5
    else
        if ( self.optionTable.healthBarColorOverride ) then
            local healthBarColorOverride = self.optionTable.healthBarColorOverride
            r, g, b = healthBarColorOverride.r, healthBarColorOverride.g, healthBarColorOverride.b
        else
            local localizedClass, englishClass = UnitClass(self.unit)
            local classColor = RAID_CLASS_COLORS[englishClass]
            local raidMarker = GetRaidTargetIndex(self.displayedUnit)

            if ( (self.optionTable.allowClassColorsForNPCs or UnitIsPlayer(self.unit) or UnitTreatAsPlayerForDisplay(self.unit)) and classColor and nPlates:UseClassColors(englishFaction, self.unit) ) then
                r, g, b = classColor.r, classColor.g, classColor.b
            elseif ( CompactUnitFrame_IsTapDenied(self) ) then
                r, g, b = 0.1, 0.1, 0.1
            elseif ( SUI.db.profile.nameplates.options.RaidMarkerColoring and raidMarker ) then
                local markerColor = nPlates.markerColors[raidMarker]
                r, g, b = markerColor.r, markerColor.g, markerColor.b
            elseif ( SUI.db.profile.nameplates.options.FelExplosives and nPlates:IsPriority(self.displayedUnit) ) then
                r, g, b = SUI.db.profile.nameplates.options.FelExplosivesColor.r, SUI.db.profile.nameplates.options.FelExplosivesColor.g, SUI.db.profile.nameplates.options.FelExplosivesColor.b
            elseif ( self.optionTable.colorHealthBySelection ) then
                if ( self.optionTable.considerSelectionInCombatAsHostile and nPlates:IsOnThreatListWithPlayer(self.displayedUnit) ) then
                    if ( SUI.db.profile.nameplates.options.TankMode ) then
                        local target = self.displayedUnit.."target"
                        local isTanking, threatStatus = UnitDetailedThreatSituation("player", self.displayedUnit)
                        if ( isTanking and threatStatus ) then
                            if ( threatStatus >= 3 ) then
                                r, g, b = 0.0, 1.0, 0.0
                            elseif ( threatStatus == 2 ) then
                                r, g, b = 1.0, 0.6, 0.2
                            end
                        elseif ( nPlates:UseOffTankColor(target) ) then
                            r, g, b = SUI.db.profile.nameplates.options.OffTankColor.r, SUI.db.profile.nameplates.options.OffTankColor.g, SUI.db.profile.nameplates.options.OffTankColor.b
                        else
                            r, g, b = 1.0, 0.0, 0.0
                        end
                    else
                        r, g, b = 1.0, 0.0, 0.0
                    end
                else
                    r, g, b = UnitSelectionColor(self.unit, self.optionTable.colorHealthWithExtendedColors)
                end
            elseif ( UnitIsFriend("player", self.unit) ) then
                r, g, b = 0.0, 1.0, 0.0
            else
                r, g, b = 1.0, 0.0, 0.0
            end
        end
    end

    -- Execute Range Coloring

    if ( SUI.db.profile.nameplates.options.ShowExecuteRange and nPlates:IsInExecuteRange(self.displayedUnit) ) then
        r, g, b = SUI.db.profile.nameplates.options.ExecuteColor.r, SUI.db.profile.nameplates.options.ExecuteColor.g, SUI.db.profile.nameplates.options.ExecuteColor.b
    end

    -- Update Healthbar Color

    local currentR, currentG, currentB = self.healthBar:GetStatusBarColor()

    if ( r ~= currentR or g ~= currentG or b ~= currentB ) then
        self.healthBar:SetStatusBarColor(r, g, b)

        if ( self.optionTable.colorHealthWithExtendedColors ) then
            self.selectionHighlight:SetVertexColor(r, g, b)
        else
            self.selectionHighlight:SetVertexColor(1.0, 1.0, 1.0)
        end

        -- Update Border Color
        nPlates:SetHealthBorderColor(self, r, g, b)
    end
end

-- Update Border Color

local function UpdateSelectionHighlight(self)
    if ( self:IsForbidden() ) then return end
    if ( not self.isNameplate ) then return end

    nPlates:SetHealthBorderColor(self)
end

    -- Update Name

function nPlates.UpdateName(self)
    if ( self:IsForbidden() ) then return end
    if ( not self.isNameplate ) then return end

    if ( not ShouldShowName(self) ) then
        self.name:Hide()
    else
            -- Update Name Size

        nPlates:UpdateNameSize(self)

            -- PvP Icon

        local pvpIcon = nPlates:PvPIcon(self.displayedUnit)

            -- Class Color Names

        if ( UnitIsPlayer(self.displayedUnit) ) then
            local r, g, b = self.healthBar:GetStatusBarColor()
            self.name:SetTextColor(r, g, b)
        end

        local name, server = UnitName(self.displayedUnit)

            -- Shorten Long Names

        if ( SUI.db.profile.nameplates.options.AbrrevLongNames ) then
            name = nPlates:Abbreviate(name)
        end

            -- Server Name

        if ( SUI.db.profile.nameplates.options.ShowServerName ) then
            if ( server ) then
                name = name.." - "..server
            end
        end

            -- Level

        if ( SUI.db.profile.nameplates.options.ShowLevel ) then
            local targetLevel = UnitLevel(self.displayedUnit)

            if ( targetLevel == -1 ) then
                self.name:SetFormattedText("%s%s", pvpIcon, name)
            else
                local difficultyColor = GetDifficultyColor(C_PlayerInfo.GetContentDifficultyCreatureForPlayer(self.displayedUnit))
                self.name:SetFormattedText("%s%s%d|r %s", pvpIcon, ConvertRGBtoColorString(difficultyColor), targetLevel, name)
            end
        else
            self.name:SetFormattedText("%s%s", pvpIcon, name)
        end

            -- Color Name To Threat Status

        if ( SUI.db.profile.nameplates.options.ColorNameByThreat ) then
            local isTanking, threatStatus = UnitDetailedThreatSituation("player", self.displayedUnit)
            if ( isTanking and threatStatus ) then
                if ( threatStatus >= 3 ) then
                    self.name:SetTextColor(0.0, 1.0, 0.0)
                elseif ( threatStatus == 2 ) then
                    self.name:SetTextColor(1.0, 0.6, 0.2)
                end
            else
                local target = self.displayedUnit.."target"
                if ( nPlates:UseOffTankColor(target) ) then
                    self.name:SetTextColor(SUI.db.profile.nameplates.options.OffTankColor.r, SUI.db.profile.nameplates.options.OffTankColor.g, SUI.db.profile.nameplates.options.OffTankColor.b)
                end
            end
        end
    end
end

    -- Skin Nameplate

local function FrameSetup(self, options)
    if ( self:IsForbidden() ) then return end

        -- Healthbar

    self.healthBar:SetStatusBarTexture(nPlates.statusBar)
    self.healthBar.barTexture:SetTexture(nPlates.statusBar)

        -- Healthbar Border

    self.healthBar.border:Hide()

    if ( not self.healthBar.beautyBorder ) then
        nPlates:SetBorder(self.healthBar)
    end

        -- Castbar

    self.castBar:SetHeight(10)
    self.castBar:SetStatusBarTexture(nPlates.statusBar)

        -- Castbar Border

    if ( not self.castBar.beautyBorder ) then
        nPlates:SetBorder(self.castBar)
    end

        -- Spell Name

    self.castBar.Text:ClearAllPoints()
    self.castBar.Text:SetFontObject("nPlate_CastbarFont")
    self.castBar.Text:SetPoint("LEFT", self.castBar, 2, 0)

        -- Set Castbar Timer

    if ( not self.castBar.CastTime ) then
        self.castBar.CastTime = self.castBar:CreateFontString(nil, "OVERLAY")
        self.castBar.CastTime:SetFontObject("nPlate_CastbarTimerFont")
        self.castBar.CastTime:SetPoint("BOTTOMRIGHT", self.castBar.Icon)
    end

        -- Castbar Icon Border

    if ( not self.castBar.Icon.beautyBorder ) then
        nPlates:SetBorder(self.castBar.Icon)
    end

        -- Castbar Icon Background

    if ( not self.castBar.Background ) then
        self.castBar.Background = self.castBar:CreateTexture("$parent_Background", "BACKGROUND")
        self.castBar.Background:SetAllPoints(self.castBar.Icon)
        self.castBar.Background:SetTexture([[Interface\Icons\Ability_DualWield]])
        self.castBar.Background:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end

        -- Update Castbar

    self.castBar:SetScript("OnValueChanged", function()
        UpdateCastbarTimer(self)
    end)

    self.castBar:SetScript("OnShow", function()
        UpdateCastbar(self)
    end)
end

local function SetupAnchors(self, setupOptions)
    if ( self:IsForbidden() ) then return end

        -- Healthbar

    self.healthBar:SetHeight(11)

    if ( setupOptions.healthBarAlpha ~= 1 ) then
        self.healthBar:SetPoint("BOTTOMLEFT", self.castBar, "TOPLEFT", 0, 5)
        self.healthBar:SetPoint("BOTTOMRIGHT", self.castBar, "TOPRIGHT", 0, 5)
    end

        -- Castbar

    self.castBar.Icon:SetSize(26, 26)
    self.castBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    self.castBar.Icon:ClearAllPoints()
    self.castBar.Icon:SetIgnoreParentAlpha(false)
    self.castBar.Icon:SetPoint("BOTTOMLEFT", self.castBar, "BOTTOMLEFT", -32, 0)

        -- Hide Border Shield

    self.castBar.BorderShield:ClearAllPoints()
end

    -- Setup Hooks

hooksecurefunc("CompactUnitFrame_OnEvent", CUF_OnEvents)
hooksecurefunc("CompactUnitFrame_UpdateStatusText", UpdateStatusText)
hooksecurefunc("CompactUnitFrame_UpdateHealthColor", UpdateHealthColor)
hooksecurefunc("CompactUnitFrame_UpdateSelectionHighlight", UpdateSelectionHighlight)
hooksecurefunc("CompactUnitFrame_UpdateName", nPlates.UpdateName)
hooksecurefunc("DefaultCompactNamePlateFrameSetup", FrameSetup)
hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", SetupAnchors)
