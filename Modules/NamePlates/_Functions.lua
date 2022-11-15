local _, nPlates = ...
local L = nPlates.L

local len = string.len
local gsub = string.gsub
local lower = string.lower
local format = string.format
local floor = math.floor
local ceil = math.ceil

local texturePath = "Interface\\AddOns\\nPlates\\media\\"

local pvpIcons = {
    ["Alliance"] = "\124TInterface/PVPFrame/PVP-Currency-Alliance:16\124t",
    ["Horde"] = "\124TInterface/PVPFrame/PVP-Currency-Horde:16\124t",
}

nPlates.statusBar = texturePath.."UI-StatusBar"
nPlates.border = texturePath.."borderTexture"
nPlates.shadow = texturePath.."textureShadow"
nPlates.defaultBorderColor = CreateColor(0.40, 0.40, 0.40, 1)
nPlates.interruptibleColor = CreateColor(0.0, 0.75, 0.0, 1)
nPlates.nonInterruptibleColor = CreateColor(0.75, 0.0, 0.0, 1)

nPlates.markerColors = {
    [1] = { r = 1.0, g = 1.0, b = 0.0 },
    [2] = { r = 1.0, g = 127/255, b = 63/255 },
    [3] = { r = 163/255, g = 53/255, b = 238/255 },
    [4] = { r = 30/255, g = 1.0, b = 0.0 },
    [5] = { r = 170/255, g = 170/255, b = 221/255 },
    [6] = { r = 0.0, g = 112/255, b = 221/255 },
    [7] = { r = 1.0, g = 32/255, b = 32/255 },
    [8] = { r = 1.0, g = 1.0, b = 1.0 },
}

    -- RBG to Hex Colors

function nPlates:RGBToHex(r, g, b)
    if ( type(r) == "table" ) then
        return RGBTableToColorCode(r)
    end

    return RGBToColorCode(r, g, b)
end

    -- Format Health

function nPlates:FormatValue(number)
    if ( number < 1e3 ) then
        return floor(number)
    elseif ( number >= 1e12 ) then
        return format("%.3ft", number/1e12)
    elseif ( number >= 1e9 ) then
        return format("%.3fb", number/1e9)
    elseif ( number >= 1e6 ) then
        return format("%.2fm", number/1e6)
    elseif ( number >= 1e3 ) then
        return format("%.1fk", number/1e3)
    end
end

    -- Format Time

function nPlates:FormatTime(seconds)
    if ( seconds > 86400 ) then
        -- Days
        return ceil(seconds/86400) .. "d", seconds%86400
    elseif ( seconds >= 3600 ) then
        -- Hours
        return ceil(seconds/3600) .. "h", seconds%3600
    elseif ( seconds >= 60 ) then
        -- Minutes
        return ceil(seconds/60) .. "m", seconds%60
    elseif ( seconds <= 10 ) then
        -- Seconds
        return format("%.1f", seconds)
    end

    return floor(seconds), seconds - floor(seconds)
end

    -- Setup Setings

function nPlates:RegisterDefaultSetting(key, value)
    if ( nPlatesDB == nil ) then
        nPlatesDB = {}
    end
    if ( nPlatesDB[key] == nil ) then
        nPlatesDB[key] = value
    end
end

local oldHealthOptions = {
    [1] = "HealthDisable",
    [2] = "HealthBoth",
    [3] = "HealthValueOnly",
    [4] = "HealthPercOnly",
}

function nPlates:SetDefaultOptions()
    for setting, value in pairs(nPlates.defaultOptions) do
        nPlates:RegisterDefaultSetting(setting, value)
    end

    local currentHealthOption = nPlatesDB["CurrentHealthOption"]

    if ( type(currentHealthOption) == "number" ) then
        nPlatesDB["CurrentHealthOption"] = oldHealthOptions[currentHealthOption]
    end
end

    -- Set Cvars

function nPlates:CVarCheck()
    if ( not nPlates:IsTaintable() ) then
        -- Combat Plates
        if ( nPlatesDB.CombatPlates ) then
            C_CVar.SetCVar("nameplateShowEnemies", UnitAffectingCombat("player") and 1 or 0)
        else
            C_CVar.SetCVar("nameplateShowEnemies", 1)
        end

        -- Set min and max scale.
        C_CVar.SetCVar("namePlateMinScale", 0.8)
        C_CVar.SetCVar("namePlateMaxScale", 1)

        -- Set sticky nameplates.
        if ( not nPlatesDB.DontClamp ) then
            C_CVar.SetCVar("nameplateOtherTopInset", -1)
            C_CVar.SetCVar("nameplateOtherBottomInset", -1)
        else
            for _, v in pairs({"nameplateOtherTopInset", "nameplateOtherBottomInset"}) do
                C_CVar.SetCVar(v, GetCVarDefault(v))
            end
        end

        -- Set small stacking nameplates.
        if ( nPlatesDB.SmallStacking ) then
            C_CVar.SetCVar("nameplateOverlapH", 1.1)
            C_CVar.SetCVar("nameplateOverlapV", 0.9)
        else
            for _, v in pairs({"nameplateOverlapH", "nameplateOverlapV"}) do
                C_CVar.SetCVar(v, GetCVarDefault(v))
            end
        end
    end
end

    -- Update All Nameplates

function nPlates:UpdateAllNameplates()
    for _, frame in ipairs(C_NamePlate.GetNamePlates(issecure())) do
        if ( not frame:IsForbidden() ) then
            CompactUnitFrame_UpdateAll(frame.UnitFrame)
        end
    end
end

    -- Update Single Nameplate

function nPlates:UpdateNameplate(namePlateFrameBase)
    local unitFrame = namePlateFrameBase.UnitFrame

    unitFrame.isNameplate = true

    nPlates.UpdateName(unitFrame)
end

    -- Setup Nameplate Hooks

function nPlates:SetupNameplate(namePlateFrameBase)
    hooksecurefunc(namePlateFrameBase, "ApplyOffsets", function(frame)
        nPlates:UpdateBuffFrameAnchorsByFrame(frame.UnitFrame)
    end)
end

    -- Update BuffFrame Anchors

function nPlates:UpdateBuffFrameAnchorsByFrame(self)
    if ( not self or self:IsForbidden() ) then
        return
    end

    if ( self.BuffFrame ) then
        if ( self.displayedUnit and UnitShouldDisplayName(self.displayedUnit) ) then
            if ( not nPlates:IsUsingLargerNamePlateStyle() ) then
                self.BuffFrame.baseYOffset = self.name:GetHeight()-7
            else
                self.BuffFrame.baseYOffset = self.name:GetHeight()-28
            end
        elseif ( self.displayedUnit ) then
            self.BuffFrame.baseYOffset = 0
        end

        self.BuffFrame:UpdateAnchor()
    end
end

    -- Raid Marker Coloring Update

function nPlates:UpdateRaidMarkerColoring()
    if ( not nPlatesDB.RaidMarkerColoring ) then return end

    for _, frame in pairs(C_NamePlate.GetNamePlates(issecure())) do
        if ( not frame:IsForbidden() ) then
            CompactUnitFrame_UpdateHealthColor(frame.UnitFrame)
        end
    end
end

    -- Check for Combat

function nPlates:IsTaintable()
    return (InCombatLockdown() or (UnitAffectingCombat("player") or UnitAffectingCombat("pet")))
end

    -- Check for "Larger Nameplates"

function nPlates:IsUsingLargerNamePlateStyle()
    local namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"))
    return namePlateVerticalScale > 1.0
end

    -- Set Name Size

function nPlates:UpdateNameSize(self)
    if ( not self ) then
        return
    end

    local size = nPlatesDB.NameSize or 10
    self.name:SetFontObject("nPlate_NameFont"..size)
    self.name:SetJustifyV("BOTTOM")
end

    -- Abbreviate Long Strings

function nPlates:Abbreviate(text)
    if ( not text ) then
        return UNKNOWN
    end

    text = (len(text) > 20) and gsub(text, "%s?(.[\128-\191]*)%S+%s", "%1. ") or text
    return text
end

    -- PvP Icon

function nPlates:PvPIcon(unit)
    if ( not nPlatesDB.ShowPvP or not UnitIsPlayer(unit) ) then
        return ""
    end

    local faction = UnitFactionGroup(unit)
    local icon = (UnitIsPVP(unit) and faction) and pvpIcons[faction] or ""

    return icon
end

    -- Check if class colors should be used.

function nPlates:UseClassColors(playerFaction, unit)
    local inArena = IsActiveBattlefieldArena()

    if ( inArena and nPlatesDB.ShowEnemyClassColors ) then
        return true
    end

    local targetFaction, _ = UnitFactionGroup(unit)
    return ( playerFaction == targetFaction and nPlatesDB.ShowFriendlyClassColors) or ( playerFaction ~= targetFaction and nPlatesDB.ShowEnemyClassColors )
end

    -- Check for threat.

function nPlates:IsOnThreatListWithPlayer(unit)
    local _, threatStatus = UnitDetailedThreatSituation("player", unit)
    return threatStatus ~= nil
end

    -- Checks to see if unit has tank role.

local function PlayerIsTank(unit)
    local assignedRole = UnitGroupRolesAssigned(unit)
    return assignedRole == "TANK"
end

    -- Off Tank Color Checks

function nPlates:UseOffTankColor(unit)
    if ( not nPlatesDB.UseOffTankColor or not PlayerIsTank("player") ) then
        return
    end

    if ( UnitPlayerOrPetInRaid(unit) or UnitPlayerOrPetInParty(unit) ) then
        if ( not UnitIsUnit("player", unit) and PlayerIsTank(unit) ) then
            return true
        end
    end

    return false
end

    -- Execute Range Check

function nPlates:IsInExecuteRange(unit)
    if ( not unit or not UnitCanAttack("player", unit) ) then
        return
    end

    local executeValue = nPlatesDB.ExecuteValue or 35
    local perc = floor(100*(UnitHealth(unit)/UnitHealthMax(unit)))

    return perc < executeValue
end

    -- Fixes the border when using the Personal Resource Display.

function nPlates:FixPlayerBorder(unit)
    local showSelf = GetCVar("nameplateShowSelf")
    if ( showSelf == "0" ) then
        return
    end

    if ( not UnitIsUnit(unit, "player") ) then
        return
    end

    local frame = C_NamePlate.GetNamePlateForUnit("player", issecure())

    if ( frame ) then
        local HealthBar = frame.UnitFrame.healthBar

        if ( HealthBar.beautyBorder and HealthBar.beautyShadow ) then
            for i = 1, 8 do
                HealthBar.beautyBorder[i]:Hide()
                HealthBar.beautyShadow[i]:Hide()
            end
            HealthBar.border:Show()
            HealthBar.beautyBorder = nil
            HealthBar.beautyShadow = nil
        end
    end
end

    -- Set Border

function nPlates:SetBorder(self)
    if ( self.beautyBorder ) then
        return
    end

    local padding = 2.5
    local size = 8
    local space = size/3.5
    local objectType = self:GetObjectType()
    local textureParent = (objectType == "Frame" or objectType == "StatusBar" and self) or self:GetParent()

    self.beautyBorder = {}
    self.beautyShadow = {}

    for i = 1, 8 do
        -- Border
        self.beautyBorder[i] = textureParent:CreateTexture("$parentBeautyBorder"..i, "OVERLAY")
        self.beautyBorder[i]:SetParent(textureParent)

        self.beautyBorder[i]:SetTexture(nPlates.border)
        self.beautyBorder[i]:SetSize(size, size)
        self.beautyBorder[i]:SetVertexColor(nPlates.defaultBorderColor:GetRGB())
        self.beautyBorder[i]:ClearAllPoints()

        -- Shadow
        self.beautyShadow[i] = textureParent:CreateTexture("$parentBeautyShadow"..i, "BORDER")
        self.beautyShadow[i]:SetParent(textureParent)

        self.beautyShadow[i]:SetTexture(nPlates.shadow)
        self.beautyShadow[i]:SetSize(size, size)
        self.beautyShadow[i]:SetVertexColor(0, 0, 0, 1)
        self.beautyShadow[i]:ClearAllPoints()
    end

    -- TOPLEFT
    self.beautyBorder[1]:SetTexCoord(0, 1/3, 0, 1/3)
    self.beautyBorder[1]:SetPoint("TOPLEFT", self, -padding, padding)
    -- TOPRIGHT
    self.beautyBorder[2]:SetTexCoord(2/3, 1, 0, 1/3)
    self.beautyBorder[2]:SetPoint("TOPRIGHT", self, padding, padding)
    -- BOTTOMLEFT
    self.beautyBorder[3]:SetTexCoord(0, 1/3, 2/3, 1)
    self.beautyBorder[3]:SetPoint("BOTTOMLEFT", self, -padding, -padding)
    -- BOTTOMRIGHT
    self.beautyBorder[4]:SetTexCoord(2/3, 1, 2/3, 1)
    self.beautyBorder[4]:SetPoint("BOTTOMRIGHT", self, padding, -padding)
    -- TOP
    self.beautyBorder[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
    self.beautyBorder[5]:SetPoint("TOPLEFT", self.beautyBorder[1], "TOPRIGHT")
    self.beautyBorder[5]:SetPoint("TOPRIGHT", self.beautyBorder[2], "TOPLEFT")
    -- BOTTOM
    self.beautyBorder[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
    self.beautyBorder[6]:SetPoint("BOTTOMLEFT", self.beautyBorder[3], "BOTTOMRIGHT")
    self.beautyBorder[6]:SetPoint("BOTTOMRIGHT", self.beautyBorder[4], "BOTTOMLEFT")
    -- LEFT
    self.beautyBorder[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
    self.beautyBorder[7]:SetPoint("TOPLEFT", self.beautyBorder[1], "BOTTOMLEFT")
    self.beautyBorder[7]:SetPoint("BOTTOMLEFT", self.beautyBorder[3], "TOPLEFT")
    -- RIGHT
    self.beautyBorder[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
    self.beautyBorder[8]:SetPoint("TOPRIGHT", self.beautyBorder[2], "BOTTOMRIGHT")
    self.beautyBorder[8]:SetPoint("BOTTOMRIGHT", self.beautyBorder[4], "TOPRIGHT")

    -- TOPLEFT
    self.beautyShadow[1]:SetTexCoord(0, 1/3, 0, 1/3)
    self.beautyShadow[1]:SetPoint("TOPLEFT", self, -padding-space, padding+space)
    -- TOPRIGHT
    self.beautyShadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
    self.beautyShadow[2]:SetPoint("TOPRIGHT", self, padding+space, padding+space)
    -- BOTTOMLEFT
    self.beautyShadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
    self.beautyShadow[3]:SetPoint("BOTTOMLEFT", self, -padding-space, -padding-space)
    -- BOTTOMRIGHT
    self.beautyShadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
    self.beautyShadow[4]:SetPoint("BOTTOMRIGHT", self, padding+space, -padding-space)
    -- TOP
    self.beautyShadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
    self.beautyShadow[5]:SetPoint("TOPLEFT", self.beautyShadow[1], "TOPRIGHT")
    self.beautyShadow[5]:SetPoint("TOPRIGHT", self.beautyShadow[2], "TOPLEFT")
    -- BOTTOM
    self.beautyShadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
    self.beautyShadow[6]:SetPoint("BOTTOMLEFT", self.beautyShadow[3], "BOTTOMRIGHT")
    self.beautyShadow[6]:SetPoint("BOTTOMRIGHT", self.beautyShadow[4], "BOTTOMLEFT")
    -- LEFT
    self.beautyShadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
    self.beautyShadow[7]:SetPoint("TOPLEFT", self.beautyShadow[1], "BOTTOMLEFT")
    self.beautyShadow[7]:SetPoint("BOTTOMLEFT", self.beautyShadow[3], "TOPLEFT")
    -- RIGHT
    self.beautyShadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
    self.beautyShadow[8]:SetPoint("TOPRIGHT", self.beautyShadow[2], "BOTTOMRIGHT")
    self.beautyShadow[8]:SetPoint("BOTTOMRIGHT", self.beautyShadow[4], "TOPRIGHT")
end

    -- Set Healthbar Border Color

function nPlates:SetHealthBorderColor(self, r, g, b)
    if ( not self ) then
        return
    end

    local border = self.healthBar.beautyBorder

    if ( border ) then
        if ( not r ) then
            r, g, b = self.healthBar:GetStatusBarColor()
        end

        for _, texture in ipairs(border) do
            if ( UnitIsUnit(self.displayedUnit, "target") ) then
                if ( nPlatesDB.WhiteSelectionColor ) then
                    texture:SetVertexColor(1, 1, 1, 1)
                else
                    texture:SetVertexColor(r, g, b, 1)
                end
            else
                texture:SetVertexColor(nPlates.defaultBorderColor:GetRGB())
            end
        end
    end
end

    -- Set Castbar Border Colors

function nPlates:SetCastbarBorderColor(self, color)
    if ( not self or not color ) then
        return
    end

    if ( self.castBar.beautyBorder ) then
        for _, texture in ipairs(self.castBar.beautyBorder) do
            texture:SetVertexColor(color:GetRGB())
        end
    end

    if ( self.castBar.Icon.beautyBorder ) then
        for _, texture in ipairs(self.castBar.Icon.beautyBorder) do
            texture:SetVertexColor(color:GetRGB())
        end
    end
end

function nPlates:UpdateInterruptibleState(self, notInterruptible)
    if ( not self ) then
        return
    end

    if ( self.casting or self.channeling ) then
        local color = notInterruptible and nPlates.nonInterruptibleColor or nPlates.interruptibleColor

        if ( self.beautyBorder ) then
            for _, texture in ipairs(self.beautyBorder) do
                texture:SetVertexColor(color:GetRGB())
            end
        end

        if ( self.Icon.beautyBorder ) then
            for _, texture in ipairs(self.Icon.beautyBorder) do
                texture:SetVertexColor(color:GetRGB())
            end
        end
    end
end

function nPlates:COMBAT_LOG_EVENT_UNFILTERED()
	local _, event, _, sourceGUID, sourceName, _, _, targetGUID = CombatLogGetCurrentEventInfo()
	if ( event == "SPELL_INTERRUPT" or event == "SPELL_PERIODIC_INTERRUPT") and targetGUID and (sourceName and sourceName ~= "" ) then
        local unit, classColor = nPlates.plateGUIDS[targetGUID]

        if ( not unit ) then
            return
        end

        local frame = C_NamePlate.GetNamePlateForUnit(unit, issecure())

		if ( frame ) then
            local name = strmatch(sourceName, "([^%-]+).*")
            local class = select(2, GetPlayerInfoByGUID(sourceGUID))

            if ( class )  then
                classColor = select(4, GetClassColor(class))
            end

            frame.UnitFrame.castBar.Text:SetFormattedText("%s - %s", INTERRUPTED, classColor and strjoin("", "|c", classColor, name) or name)
		end
	end
end
