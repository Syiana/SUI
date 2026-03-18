local Module = SUI:NewModule("UnitFrames.Classic")

function Module:OnEnable()
    if SUI.db.profile.unitframes.style ~= "Classic" then
        return
    end

    local targetTexture = "Interface\\TargetingFrame\\UI-TargetingFrame"
    local playerTexture = "Interface\\TargetingFrame\\UI-TargetingFrame"
    local totTexture = "Interface\\TargetingFrame\\UI-TargetofTargetFrame"
    local smallTexture = "Interface\\TargetingFrame\\UI-SmallTargetingFrame"
    local darkColor = SUI:Color(0.1) or { 0.2, 0.2, 0.2, 1 }
    local hiddenFrame = SUI.HiddenFrame
    if not hiddenFrame then
        hiddenFrame = CreateFrame("Frame")
        hiddenFrame:Hide()
        SUI.HiddenFrame = hiddenFrame
    end

    local function SetXYPoint(region, xOffset, yOffset)
        if not region then
            return
        end

        local point, relativeTo, relativePoint, xOfs, yOfs = region:GetPoint()
        if point then
            region:ClearAllPoints()
            region:SetPoint(point, relativeTo, relativePoint, xOffset or xOfs or 0, yOffset or yOfs or 0)
        end
    end

    local function GetFrameName(frame)
        return frame and (frame.bbfName or frame.name or frame.Name)
    end

    local function StyleFrameName(frame, anchor, width)
        local name = GetFrameName(frame)
        if not name or not anchor then
            return
        end

        name:SetParent(frame.SUIClassicFrame or frame)
        name:ClearAllPoints()
        name:SetPoint("BOTTOM", anchor, "TOP", 0, -5)
        name:SetWidth(width or 69)
        name:SetScale(0.9)
        name:SetJustifyH("CENTER")
        name:SetWordWrap(false)
    end

    local function EnsureBackdrop(frame, healthBar, manaBar, leftInset, topInset, rightInset, bottomInset)
        if not frame.ClassicBackdrop then
            frame.ClassicBackdrop = frame:CreateTexture(nil, "BACKGROUND")
            frame.ClassicBackdrop:SetColorTexture(0, 0, 0, 0.45)
        end

        if healthBar and manaBar then
            frame.ClassicBackdrop:ClearAllPoints()
            frame.ClassicBackdrop:SetPoint("TOPLEFT", healthBar, "TOPLEFT", leftInset or 0, topInset or 10)
            frame.ClassicBackdrop:SetPoint("BOTTOMRIGHT", manaBar, "BOTTOMRIGHT", rightInset or -4, bottomInset or 0)
        end
    end

    local function EnsureTextureFrame(frame)
        if not frame.SUIClassicFrame then
            frame.SUIClassicFrame = CreateFrame("Frame", nil, frame)
            frame.SUIClassicFrame:SetAllPoints(frame)
            frame.SUIClassicFrame:SetFrameStrata("HIGH")
            frame.SUIClassicFrame.Texture = frame.SUIClassicFrame:CreateTexture(nil, "OVERLAY")
        end

        return frame.SUIClassicFrame.Texture
    end

    local function RaiseAuras(frame)
        if not frame then
            return
        end

        local main = frame.TargetFrameContent and frame.TargetFrameContent.TargetFrameContentMain
        local aurasFrame = main and main.AurasFrame
        if aurasFrame then
            aurasFrame:SetAlpha(1)
            aurasFrame:Show()
            aurasFrame:SetFrameStrata("FULLSCREEN")
            aurasFrame:SetFrameLevel(frame:GetFrameLevel() + 19)
        end

        if not frame.auraPools then
            return
        end

        for aura in frame.auraPools:EnumerateActive() do
            aura:SetAlpha(1)
            aura:Show()
            aura:SetFrameStrata("FULLSCREEN")
            aura:SetFrameLevel(frame:GetFrameLevel() + 20)
        end
    end

    local function ForceTextureHidden(texture)
        if not texture or texture.SUIClassicHidden then
            return
        end

        texture.SUIClassicHidden = true
        texture:SetParent(hiddenFrame)
        texture:SetAlpha(0)
        texture:Hide()

        hooksecurefunc(texture, "SetAlpha", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self.SUIClassicChanging = false
        end)

        hooksecurefunc(texture, "Show", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetParent(hiddenFrame)
            self:SetAlpha(0)
            self:Hide()
            self.SUIClassicChanging = false
        end)
    end

    local function ForceTextureAlphaZero(texture)
        if not texture or texture.SUIClassicZeroed then
            return
        end

        texture.SUIClassicZeroed = true
        texture:SetAlpha(0)

        hooksecurefunc(texture, "SetAlpha", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self.SUIClassicChanging = false
        end)

        hooksecurefunc(texture, "Show", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self.SUIClassicChanging = false
        end)
    end

    local function ForcePlayerFrameTextureHidden(texture)
        if not texture or texture.SUIClassicPlayerHidden then
            return
        end

        texture.SUIClassicPlayerHidden = true
        texture:SetParent(hiddenFrame)
        texture:SetAlpha(0)
        texture:Hide()

        hooksecurefunc(texture, "SetAlpha", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self.SUIClassicChanging = false
        end)

        hooksecurefunc(texture, "Show", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetParent(hiddenFrame)
            self:SetAlpha(0)
            self:Hide()
            self.SUIClassicChanging = false
        end)
    end

    local function HookTargetFrameTexture(texture)
        if not texture or texture.SUIClassicTargetHooked then
            return
        end

        texture.SUIClassicTargetHooked = true
        texture:SetAlpha(0)
        texture:Hide()

        hooksecurefunc(texture, "SetAlpha", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self.SUIClassicChanging = false
        end)

        hooksecurefunc(texture, "Show", function(self)
            if self.SUIClassicChanging then
                return
            end

            self.SUIClassicChanging = true
            self:SetAlpha(0)
            self:Hide()
            self.SUIClassicChanging = false
        end)
    end

    local function StyleTargetLike(frame)
        if not frame or not frame.TargetFrameContent or not frame.TargetFrameContainer then
            return
        end

        local content = frame.TargetFrameContent
        local main = content.TargetFrameContentMain
        local context = content.TargetFrameContentContextual
        local hp = main.HealthBarsContainer
        local mana = main.ManaBar
        local container = frame.TargetFrameContainer
        local texture = EnsureTextureFrame(frame)

        if container.FrameTexture then
            container.FrameTexture:ClearAllPoints()
            container.FrameTexture:SetPoint("TOPLEFT", 20.5, -18)
            HookTargetFrameTexture(container.FrameTexture)
            container.FrameTexture:Hide()
        end
        texture:SetTexture(targetTexture)
        texture:SetTexCoord(0.09375, 1, 0, 0.78125)
        texture:SetSize(232, 100)
        texture:ClearAllPoints()
        texture:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -8)
        texture:SetDrawLayer("BORDER")
        texture:SetVertexColor(unpack(darkColor))

        EnsureBackdrop(frame, hp.HealthBar, mana, 3, 9, -7, 0)
        StyleFrameName(frame, hp, 69)

        if hp.HealthBarMask then
            hp.HealthBarMask:SetSize(125, 17)
            SetXYPoint(hp.HealthBarMask, 1, -6)
        end
        if hp.HealthBar and hp.HealthBar.OverAbsorbGlow then
            SetXYPoint(hp.HealthBar.OverAbsorbGlow, -7)
        end
        if mana.ManaBarMask then
            mana.ManaBarMask:SetWidth(253)
            SetXYPoint(mana.ManaBarMask, -59)
        end

        container.Portrait:SetSize(62, 62)
        container.Portrait:ClearAllPoints()
        container.Portrait:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -23, -22)
        if container.Flash then
            container.Flash:SetDrawLayer("BACKGROUND")
            container.Flash:SetParent(frame)
            container.Flash:ClearAllPoints()
            container.Flash:SetPoint("TOPLEFT", -2.5, -8)
            container.Flash:SetSize(240.5, 93)
        end

        if container.PortraitMask then
            container.PortraitMask:SetSize(61, 61)
            container.PortraitMask:ClearAllPoints()
            container.PortraitMask:SetPoint("CENTER", container.Portrait, "CENTER")
        end
        if container.BossPortraitFrameTexture then
            container.BossPortraitFrameTexture:SetAlpha(0)
        end

        hp.LeftText:SetParent(frame.SUIClassicFrame)
        hp.LeftText:ClearAllPoints()
        hp.LeftText:SetPoint("LEFT", texture, "LEFT", 7, 3)
        hp.RightText:SetParent(frame.SUIClassicFrame)
        hp.RightText:ClearAllPoints()
        hp.RightText:SetPoint("RIGHT", texture, "RIGHT", -108, 3)
        hp.HealthBarText:SetParent(frame.SUIClassicFrame)
        hp.HealthBarText:ClearAllPoints()
        hp.HealthBarText:SetPoint("CENTER", texture, "LEFT", 66, 3)

        mana.LeftText:SetParent(frame.SUIClassicFrame)
        mana.LeftText:ClearAllPoints()
        mana.LeftText:SetPoint("LEFT", texture, "LEFT", 7, -8.5)
        mana.RightText:SetParent(frame.SUIClassicFrame)
        mana.RightText:ClearAllPoints()
        mana.RightText:SetPoint("RIGHT", texture, "RIGHT", -108, -8.5)
        mana.ManaBarText:SetParent(frame.SUIClassicFrame)
        mana.ManaBarText:ClearAllPoints()
        mana.ManaBarText:SetPoint("CENTER", texture, "LEFT", 66, -8.5)

        if main.LevelText then
            main.LevelText:SetParent(frame.SUIClassicFrame)
            main.LevelText:ClearAllPoints()
            main.LevelText:SetPoint("CENTER", frame, "BOTTOMRIGHT", -34, 25.5)
        end
        if main.ReputationColor then
            main.ReputationColor:SetSize(119, 18)
            main.ReputationColor:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")
            main.ReputationColor:ClearAllPoints()
            main.ReputationColor:SetPoint("TOPRIGHT", -87, -31)
        end
        if context.HighLevelTexture then
            context.HighLevelTexture:SetParent(frame.SUIClassicFrame)
            context.HighLevelTexture:ClearAllPoints()
            context.HighLevelTexture:SetPoint("CENTER", frame, "BOTTOMRIGHT", -34, 25)
        end
        if context.PetBattleIcon then
            context.PetBattleIcon:SetParent(frame.SUIClassicFrame)
            context.PetBattleIcon:ClearAllPoints()
            context.PetBattleIcon:SetPoint("CENTER", frame, "BOTTOMRIGHT", -35, 25)
        end

        if context.LeaderIcon then
            context.LeaderIcon:SetParent(frame.SUIClassicFrame)
            context.LeaderIcon:ClearAllPoints()
            context.LeaderIcon:SetPoint("TOPRIGHT", -84, -13.5)
        end
        if context.RaidTargetIcon then
            context.RaidTargetIcon:SetParent(frame.SUIClassicFrame)
            context.RaidTargetIcon:ClearAllPoints()
            context.RaidTargetIcon:SetPoint("CENTER", container.Portrait, "TOP", 1.5, 1)
        end
        if frame.threatIndicator then
            frame.threatIndicator:SetAlpha(0)
        end
        if context.NumericalThreat then
            context.NumericalThreat:SetAlpha(0)
        end

        if frame.totFrame then
            local tot = frame.totFrame
            tot:SetFrameStrata("DIALOG")
            tot.FrameTexture:SetTexture(totTexture)
            tot.FrameTexture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
            tot.FrameTexture:SetSize(93, 45)
            tot.FrameTexture:ClearAllPoints()
            tot.FrameTexture:SetPoint("TOPLEFT", 0, 0)
            tot.FrameTexture:SetVertexColor(unpack(darkColor))
            tot.Portrait:SetSize(37, 37)
            tot.Portrait:ClearAllPoints()
            tot.Portrait:SetPoint("TOPLEFT", 4, -5)
            tot.HealthBar:SetSize(47, 7)
            tot.HealthBar:ClearAllPoints()
            tot.HealthBar:SetPoint("TOPRIGHT", -29, -15)
            tot.ManaBar:SetSize(49, 7)
            tot.ManaBar:ClearAllPoints()
            tot.ManaBar:SetPoint("TOPRIGHT", -29, -23)
        end

        RaiseAuras(frame)

    end

    local function StylePlayer()
        local frame = PlayerFrame
        if not frame or not frame.PlayerFrameContent or not frame.PlayerFrameContainer then
            return
        end

        local content = frame.PlayerFrameContent
        local main = content.PlayerFrameContentMain
        local context = content.PlayerFrameContentContextual
        local hp = main.HealthBarsContainer
        local mana = main.ManaBarArea and main.ManaBarArea.ManaBar
        local container = frame.PlayerFrameContainer
        local texture = EnsureTextureFrame(frame)

        if container.FrameTexture then
            container.FrameTexture:ClearAllPoints()
            container.FrameTexture:SetPoint("TOPLEFT", -19, 7)
            ForcePlayerFrameTextureHidden(container.FrameTexture)
        end
        if container.AlternatePowerFrameTexture then
            container.AlternatePowerFrameTexture:ClearAllPoints()
            container.AlternatePowerFrameTexture:SetPoint("TOPLEFT", -19, -8)
            ForceTextureAlphaZero(container.AlternatePowerFrameTexture)
        end
        if container.VehicleFrameTexture then
            container.VehicleFrameTexture:ClearAllPoints()
            container.VehicleFrameTexture:SetPoint("TOPLEFT", -3, 1)
            ForceTextureAlphaZero(container.VehicleFrameTexture)
        end
        texture:SetTexture(playerTexture)
        texture:SetTexCoord(1, 0.09375, 0, 0.78125)
        texture:SetSize(232, 100)
        texture:ClearAllPoints()
        texture:SetPoint("TOPLEFT", frame, "TOPLEFT", -19, -8)
        texture:SetDrawLayer("BORDER")
        texture:SetVertexColor(unpack(darkColor))

        if mana then
            EnsureBackdrop(frame, hp.HealthBar, mana, 0, 11, -1, 0)
            if mana.FullPowerFrame then
                mana.FullPowerFrame:SetParent(frame.SUIClassicFrame)
            end
        end
        StyleFrameName(frame, hp, 76)

        if hp.HealthBarMask then
            hp.HealthBarMask:SetSize(126, 17)
            SetXYPoint(hp.HealthBarMask, 0, -6)
        end
        if hp.HealthBar and hp.HealthBar.OverAbsorbGlow then
            SetXYPoint(hp.HealthBar.OverAbsorbGlow, -3)
        end
        if mana and mana.ManaBarMask then
            mana.ManaBarMask:SetSize(126, 19)
            SetXYPoint(mana.ManaBarMask, 0, 2)
        end

        container.PlayerPortrait:SetSize(62, 62)
        container.PlayerPortrait:ClearAllPoints()
        container.PlayerPortrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 26, -23)

        if container.PlayerPortraitMask then
            container.PlayerPortraitMask:SetSize(62, 62)
            container.PlayerPortraitMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
            container.PlayerPortraitMask:ClearAllPoints()
            container.PlayerPortraitMask:SetPoint("CENTER", container.PlayerPortrait, "CENTER")
        end
        if container.FrameFlash then
            container.FrameFlash:SetParent(frame)
            container.FrameFlash:SetDrawLayer("BACKGROUND")
            container.FrameFlash:SetSize(240.5, 93)
            container.FrameFlash:ClearAllPoints()
            container.FrameFlash:SetPoint("TOPLEFT", -4.5, -8)
        end

        hp.LeftText:SetParent(frame.SUIClassicFrame)
        hp.LeftText:ClearAllPoints()
        hp.LeftText:SetPoint("LEFT", texture, "LEFT", 108, 3)
        hp.RightText:SetParent(frame.SUIClassicFrame)
        hp.RightText:ClearAllPoints()
        hp.RightText:SetPoint("RIGHT", texture, "RIGHT", -7, 3)
        hp.HealthBarText:SetParent(frame.SUIClassicFrame)
        hp.HealthBarText:ClearAllPoints()
        hp.HealthBarText:SetPoint("CENTER", texture, "CENTER", 52, 3)

        if mana then
            mana.LeftText:SetParent(frame.SUIClassicFrame)
            mana.LeftText:ClearAllPoints()
            mana.LeftText:SetPoint("LEFT", texture, "LEFT", 108, -8.5)
            mana.RightText:SetParent(frame.SUIClassicFrame)
            mana.RightText:ClearAllPoints()
            mana.RightText:SetPoint("RIGHT", texture, "RIGHT", -7, -8.5)
            mana.ManaBarText:SetParent(frame.SUIClassicFrame)
            mana.ManaBarText:ClearAllPoints()
            mana.ManaBarText:SetPoint("CENTER", texture, "CENTER", 52, -8.5)
        end

        if PlayerLevelText then
            PlayerLevelText:SetParent(frame.SUIClassicFrame)
            PlayerLevelText:ClearAllPoints()
            PlayerLevelText:SetPoint("CENTER", frame, "CENTER", -81, -24.5)
        end

        if context.AttackIcon then
            context.AttackIcon:SetParent(frame.SUIClassicFrame)
            context.AttackIcon:ClearAllPoints()
            context.AttackIcon:SetPoint("CENTER", -80, -23.5)
            context.AttackIcon:SetSize(32, 31)
            context.AttackIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
            context.AttackIcon:SetTexCoord(0.5, 1.0, 0, 0.484375)
            context.AttackIcon:SetDrawLayer("OVERLAY")
        end
        if context.PlayerPortraitCornerIcon then
            context.PlayerPortraitCornerIcon:SetAtlas(nil)
        end
        if frame.threatIndicator then
            frame.threatIndicator:SetAlpha(0)
        end
        if context.RoleIcon then
            context.RoleIcon:SetParent(frame.SUIClassicFrame)
            context.RoleIcon:ClearAllPoints()
            context.RoleIcon:SetPoint("TOPLEFT", 192, -34)
        end
        if context.GroupIndicator then
            context.GroupIndicator:SetParent(frame.SUIClassicFrame)
            context.GroupIndicator:ClearAllPoints()
            context.GroupIndicator:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -21, -33.5)
        end
        if PlayerFrameGroupIndicatorText and context.GroupIndicator and context.GroupIndicator.GroupIndicatorLeft then
            PlayerFrameGroupIndicatorText:ClearAllPoints()
            PlayerFrameGroupIndicatorText:SetPoint("LEFT", context.GroupIndicator.GroupIndicatorLeft, "LEFT", 20, 2.5)
        end
        if main.StatusTexture then
            main.StatusTexture:SetSize(191, 77)
            main.StatusTexture:SetTexture("Interface\\CharacterFrame\\UI-Player-Status")
            main.StatusTexture:SetTexCoord(0, 0.74609375, 0, 0.58125)
            main.StatusTexture:ClearAllPoints()
            main.StatusTexture:SetPoint("TOPLEFT", 17, -15)
            main.StatusTexture:SetBlendMode("ADD")
        end
    end

    local function StylePet()
        if not PetFrame then
            return
        end

        PetFrame:SetSize(128, 53)
        if PetPortrait then
            PetPortrait:ClearAllPoints()
            PetPortrait:SetPoint("TOPLEFT", 7, -6)
        end
        if PetFrameTexture then
            PetFrameTexture:SetSize(128, 64)
            PetFrameTexture:SetTexture(smallTexture)
            PetFrameTexture:SetVertexColor(unpack(darkColor))
        end
    end

    local function ApplyClassic()
        if SUI.db.profile.unitframes.style ~= "Classic" then
            return
        end

        StylePlayer()
        StyleTargetLike(TargetFrame)
        StyleTargetLike(FocusFrame)
        StylePet()
    end

    ApplyClassic()
    C_Timer.After(0, ApplyClassic)
    hooksecurefunc("PlayerFrame_ToPlayerArt", ApplyClassic)
    hooksecurefunc(TargetFrame, "CheckClassification", function() ApplyClassic() end)
    hooksecurefunc(FocusFrame, "CheckClassification", function() ApplyClassic() end)
    hooksecurefunc(TargetFrame, "UpdateAuras", function() RaiseAuras(TargetFrame) end)
    hooksecurefunc(FocusFrame, "UpdateAuras", function() RaiseAuras(FocusFrame) end)
end
