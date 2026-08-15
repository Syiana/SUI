local Module = SUI:NewModule("UnitFrames.Target");

local function ApplyPredictionTexture(bar, texture)
    if not bar then
        return
    end

    if bar.SetStatusBarTexture then
        bar:SetStatusBarTexture(texture)
        if bar.GetStatusBarTexture and bar:GetStatusBarTexture() then
            bar:GetStatusBarTexture():SetDrawLayer("BORDER")
        end
        return
    end

    if bar.SetTexture then
        bar:SetTexture(texture)
    end
end

function Module:RefreshTextures()
    local texture = SUI.db.profile.general.texture
    if SUI.db.profile.unitframes.style == "Classic" or texture == [[Interface\Default]] then
        return
    end

    local function Apply(frame)
        if not frame or frame:IsForbidden() or not frame.healthbar then
            return
        end

        frame.healthbar:SetStatusBarTexture(texture)
        frame.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
        if frame.myHealPredictionBar then
            ApplyPredictionTexture(frame.myHealPredictionBar, texture)
        end
    end

    Apply(TargetFrame)
    Apply(FocusFrame)
    Apply(TargetFrameToT)
    Apply(FocusFrameToT)
end

function Module:OnEnable()

    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        theme = SUI.db.profile.general.theme
    }
    local isClassic = db.unitframes.style == "Classic"

    local function MigrateTargetAuraRows()
        if db.unitframes.targetaurarowslayoutv2 then
            return
        end

        if db.unitframes.buffs and (db.unitframes.buffs.perrow == 6 or db.unitframes.buffs.perrow == 8) then
            db.unitframes.buffs.perrow = 7
        end

        if db.unitframes.debuffs and (db.unitframes.debuffs.perrow == 6 or db.unitframes.debuffs.perrow == 8) then
            db.unitframes.debuffs.perrow = 7
        end

        db.unitframes.targetaurarowsmigrated = true
        db.unitframes.targetaurarowslayoutv2 = true
    end

    MigrateTargetAuraRows()

    -- Set Target/Focus Textures
    local function healthTexture(self)
        if self:IsForbidden() then return end
        
        -- Set Textures
        self.healthbar:SetStatusBarTexture(db.texture)
        self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
        if self.myHealPrediction then
            ApplyPredictionTexture(self.myHealPredictionBar, db.texture)
        end
    end

    local hooked = {}
    local function UpdateFrameAuras(aura)
        if db.theme ~= 'Blizzard' then
            if not hooked[aura] then
                hooked[aura] = true

                local icon = aura.Icon
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                icon:SetDrawLayer("BACKGROUND", -8)

                if not aura.border then
                    local border = aura.border or
                        aura:CreateTexture(aura.border, "BACKGROUND", nil, -7)

                    border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
                    border:SetTexCoord(0, 1, 0, 1)
                    border:SetDrawLayer("BACKGROUND", -7)
                    border:ClearAllPoints()
                    border:SetPoint("TOPLEFT", aura, "TOPLEFT", -1, 1)
                    border:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 1, -1)
                    aura.border = border

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
                    local back = CreateFrame("Frame", nil, aura, "BackdropTemplate")
                    back:SetPoint("TOPLEFT", aura, "TOPLEFT", -4, 4)
                    back:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 4, -4)
                    back:SetFrameLevel(aura:GetFrameLevel() - 1)
                    back:SetBackdrop(backdrop)
                    back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
                    aura.bg = back
                end
            end
        end
    end

    local function SafeCall(object, method, ...)
        if object and object[method] then
            return pcall(object[method], object, ...)
        end

        return false
    end

    local function SUIColorRepBar(self)
        local reputationBar = self.TargetFrameContent.TargetFrameContentMain.ReputationColor
        reputationBar:SetVertexColor(unpack(SUI:Color(0.15)))
    end

    local function CacheAuraAnchor(aura)
        local point, relativeTo, relativePoint, x, y = aura:GetPoint(1)
        if not point then
            return
        end

        aura.SUIOriginalAnchor = {
            point = point,
            relativeTo = relativeTo,
            relativePoint = relativePoint,
            x = x or 0,
            y = y or 0,
        }
    end

    local function ShouldOffsetAura(aura)
        local _, relativeTo = aura:GetPoint(1)
        return not (relativeTo and relativeTo.Icon)
    end

    local function OffsetAuraPosition(aura, xOffset, yOffset)
        if not ShouldOffsetAura(aura) then
            return
        end

        local anchor = aura.SUIOriginalAnchor
        if not anchor then
            CacheAuraAnchor(aura)
            anchor = aura.SUIOriginalAnchor
        end

        if not anchor then
            return
        end

        aura:ClearAllPoints()
        aura:SetPoint(anchor.point, anchor.relativeTo, anchor.relativePoint, anchor.x + xOffset, anchor.y + yOffset)
    end

    local function StyleTargetBuff(buff, skipOffset)
        buff:SetSize(db.unitframes.buffs.size, db.unitframes.buffs.size)
        if not skipOffset then
            OffsetAuraPosition(buff, db.unitframes.buffs.targetx or 0, db.unitframes.buffs.targety or 0)
        end

        if buff.Count then
            buff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            buff.Count:ClearAllPoints()
            buff.Count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 2, 0)
        end
    end

    local function StyleTargetDebuff(debuff, skipOffset)
        debuff:SetSize(db.unitframes.debuffs.size, db.unitframes.debuffs.size)
        if not skipOffset then
            OffsetAuraPosition(debuff, db.unitframes.debuffs.targetx or 0, db.unitframes.debuffs.targety or 0)
        end

        if debuff.Count then
            debuff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            debuff.Count:ClearAllPoints()
            debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 2, 0)
        end
    end

    local function DisableDefaultUnitAuraContainer(frame)
        if not frame or not frame.GetAuraContainer then
            return
        end

        local ok, defaultAuraContainer = pcall(frame.GetAuraContainer, frame)
        if not ok or not defaultAuraContainer then
            return
        end

        frame.maxBuffs = 0
        frame.maxDebuffs = 0
        SafeCall(defaultAuraContainer, "SetEnabled", false)
        SafeCall(defaultAuraContainer, "Hide")
    end

    local function InitializeUnitAuraButton(auraFrame, isDebuff, size)
        auraFrame:SetSize(size, size)

        if not auraFrame.Icon then
            auraFrame.Icon = auraFrame:CreateTexture(nil, "BACKGROUND")
            auraFrame.Icon:SetAllPoints(auraFrame)
            auraFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            auraFrame:SetIcon(auraFrame.Icon)
        end

        if not auraFrame.Cooldown then
            auraFrame.Cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
            auraFrame.Cooldown:SetAllPoints(auraFrame.Icon)
            auraFrame.Cooldown:SetDrawBling(false)
            auraFrame.Cooldown:SetReverse(true)
            auraFrame:SetDurationCooldown(auraFrame.Cooldown)
        end

        if auraFrame.Cooldown.GetCountdownFontString then
            auraFrame.CooldownText = auraFrame.Cooldown:GetCountdownFontString()
            if auraFrame.CooldownText then
                auraFrame.CooldownText:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
                auraFrame.CooldownText:ClearAllPoints()
                auraFrame.CooldownText:SetPoint("CENTER", auraFrame.Icon, "CENTER", 0, 0)
            end
        end

        if not auraFrame.SUIBorderOverlay then
            auraFrame.SUIBorderOverlay = CreateFrame("Frame", nil, auraFrame)
            auraFrame.SUIBorderOverlay:SetAllPoints(auraFrame)
            auraFrame.SUIBorderOverlay:SetFrameLevel(auraFrame.Cooldown:GetFrameLevel() + 1)
        end

        if not auraFrame.Count then
            auraFrame.Count = auraFrame.SUIBorderOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
            auraFrame.Count:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
            auraFrame.Count:SetPoint("BOTTOMRIGHT", auraFrame.Icon, "BOTTOMRIGHT", 1, 0)
            auraFrame:SetApplicationCount(auraFrame.Count)
        end

        UpdateFrameAuras(auraFrame)
        if auraFrame.border and auraFrame.SUIBorderOverlay then
            auraFrame.border:SetParent(auraFrame.SUIBorderOverlay)
            auraFrame.border:SetDrawLayer("OVERLAY", 1)
        end

        if isDebuff then
            StyleTargetDebuff(auraFrame, true)
        else
            StyleTargetBuff(auraFrame, true)
        end
    end

    local function GetUnitAuraParent(frame)
        return frame and frame.TargetFrameContent and frame.TargetFrameContent.TargetFrameContentContextual or frame
    end

    local function GetUnitAuraAnchor(frame)
        return frame and frame.TargetFrameContainer and frame.TargetFrameContainer.FrameTexture or frame
    end

    local function GetAuraLineSize(size, perRow)
        perRow = tonumber(perRow) or 7
        if perRow < 1 then
            perRow = 1
        end

        return perRow * size + math.max(perRow - 1, 0) * 3
    end

    local function GetAuraGroupFrameCount(container, ...)
        if not container or not container.GetAuraGroupFrameCount then
            return 0
        end

        local count = 0
        for i = 1, select("#", ...) do
            local ok, groupCount = pcall(container.GetAuraGroupFrameCount, container, select(i, ...))
            if ok and groupCount then
                count = count + groupCount
            end
        end

        return count
    end

    local function GetAuraStackOffset(container, size, perRow, mirrorVertically, ...)
        perRow = tonumber(perRow) or 7
        if perRow < 1 then
            perRow = 1
        end

        local count = GetAuraGroupFrameCount(container, ...)
        local rows = math.max(math.ceil(count / perRow), 1)
        local offset = rows * size + math.max(rows - 1, 0) * 3 + 1
        return mirrorVertically and offset or -offset
    end

    local function HideSUIAuraContainers(frame)
        if not frame then
            return
        end

        if frame.SUIBuffContainer then
            frame.SUIBuffContainer:SetEnabled(false)
            frame.SUIBuffContainer:Hide()
        end

        if frame.SUIDebuffContainer then
            frame.SUIDebuffContainer:SetEnabled(false)
            frame.SUIDebuffContainer:Hide()
        end
    end

    local function BetterBlizzOwnsUnitAuras(unit)
        local bbf = _G.BBF
        local hosts = type(bbf) == "table" and bbf.auraHosts or nil
        local host = type(hosts) == "table" and hosts[unit] or nil
        if type(host) ~= "table" then
            return false
        end

        return host.spacer or host.blockTop or host.blockBottom or host.filtered
    end

    local function ReflowUnitAuraContainers(frame)
        if not frame or not frame.SUIBuffContainer or not frame.SUIDebuffContainer or not AnchorUtil then
            return
        end

        local mirrorVertically = frame.buffsOnTop == true
        local point = mirrorVertically and "BOTTOMLEFT" or "TOPLEFT"
        local relativePoint = mirrorVertically and "TOPLEFT" or "BOTTOMLEFT"
        local verticalGrowth = mirrorVertically and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down
        local yOffset = mirrorVertically and -2 or 18
        local buffX = db.unitframes.buffs.targetx or 0
        local buffY = db.unitframes.buffs.targety or 0
        local debuffX = db.unitframes.debuffs.targetx or 0
        local debuffY = db.unitframes.debuffs.targety or 0

        frame.SUIBuffContainer:ClearAllPoints()
        frame.SUIBuffContainer:SetPoint(point, GetUnitAuraAnchor(frame), relativePoint, 5 + buffX, yOffset + buffY)
        frame.SUIBuffContainer:SetFlowLayoutAnchorPoint(point)
        frame.SUIBuffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, verticalGrowth)
        frame.SUIBuffContainer:SetFlowLayoutMaximumLineSize(
            GetAuraLineSize(db.unitframes.buffs.size, db.unitframes.buffs.perrow))

        frame.SUIDebuffContainer:ClearAllPoints()
        frame.SUIDebuffContainer:SetPoint(point, GetUnitAuraAnchor(frame), relativePoint, 5 + debuffX,
            yOffset + debuffY +
            GetAuraStackOffset(frame.SUIBuffContainer, db.unitframes.buffs.size, db.unitframes.buffs.perrow,
                mirrorVertically, "Buffs", "BuffsStealable"))
        frame.SUIDebuffContainer:SetFlowLayoutAnchorPoint(point)
        frame.SUIDebuffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, verticalGrowth)
        frame.SUIDebuffContainer:SetFlowLayoutMaximumLineSize(
            GetAuraLineSize(db.unitframes.debuffs.size, db.unitframes.debuffs.perrow))
    end

    local function UpdateUnitDebuffCasterFilter(frame)
        local debuffContainer = frame and frame.SUIDebuffContainer
        if not debuffContainer then
            return
        end

        local unit = frame.unit or debuffContainer:GetUnit()
        local showAllCasters = unit and (UnitIsUnit(unit, "player") or UnitIsFriend("player", unit)) == true
        if debuffContainer.SUIShowAllCasters == showAllCasters then
            return
        end

        debuffContainer.SUIShowAllCasters = showAllCasters
        debuffContainer:SetAuraGroupCandidateFilters("Debuffs", {
            isFromPlayerOrPlayerPet = not showAllCasters or nil
        })
        debuffContainer:SetAuraGroupMaxFrameCount("DebuffsAlwaysShown", showAllCasters and 0 or 16)
    end

    local function CreateUnitAuraContainers(frame, unit)
        if not frame or not frame.GetAuraContainer or frame.SUIBuffContainer or frame.SUIDebuffContainer or
            not AuraUtil or type(AuraUtil.CreateFilterString) ~= "function" then
            return
        end

        DisableDefaultUnitAuraContainer(frame)

        local parent = GetUnitAuraParent(frame)
        local buffContainer = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
        if parent and parent.GetFrameLevel then
            buffContainer:SetFrameLevel(math.max(parent:GetFrameLevel() + 2, 0))
        end
        buffContainer:SetSize(1, 1)
        buffContainer:SetFlowLayoutPadding(0, 0, 0, 0)
        buffContainer:SetUnit(unit)
        buffContainer:SetEnabled(true)
        frame.SUIBuffContainer = buffContainer

        local debuffContainer = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
        if parent and parent.GetFrameLevel then
            debuffContainer:SetFrameLevel(math.max(parent:GetFrameLevel() + 2, 0))
        end
        debuffContainer:SetSize(1, 1)
        debuffContainer:SetFlowLayoutPadding(0, 0, 0, 0)
        debuffContainer:SetUnit(unit)
        debuffContainer:SetEnabled(true)
        frame.SUIDebuffContainer = debuffContainer

        buffContainer:AddAuraGroup("Buffs", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
            maxFrameCount = 32,
            candidateFilters = {
                isStealable = false
            },
            initializeFrame = function(auraFrame)
                InitializeUnitAuraButton(auraFrame, false, db.unitframes.buffs.size)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        buffContainer:AddAuraGroup("BuffsStealable", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
            maxFrameCount = 32,
            candidateFilters = {
                isStealable = true
            },
            initializeFrame = function(auraFrame)
                InitializeUnitAuraButton(auraFrame, false, db.unitframes.buffs.size)
                if auraFrame.border then
                    auraFrame.border:SetVertexColor(0.8, 0.3, 1)
                end
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        local debuffFilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful)
        debuffContainer:AddAuraGroup("Debuffs", debuffFilter, {
            maxFrameCount = 16,
            candidateFilters = {
                isFromPlayerOrPlayerPet = true
            },
            initializeFrame = function(auraFrame)
                InitializeUnitAuraButton(auraFrame, true, db.unitframes.debuffs.size)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        debuffContainer:AddAuraGroup("DebuffsAlwaysShown", debuffFilter, {
            maxFrameCount = 16,
            candidateFilters = {
                nameplateShowAll = true,
                isFromPlayerOrPlayerPet = false
            },
            initializeFrame = function(auraFrame)
                InitializeUnitAuraButton(auraFrame, true, db.unitframes.debuffs.size)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        ReflowUnitAuraContainers(frame)
        UpdateUnitDebuffCasterFilter(frame)
    end

    local function UpdateUnitAuraContainers(frame, unit)
        if not frame then
            return
        end

        unit = unit or frame.unit
        if not unit then
            return
        end

        if BetterBlizzOwnsUnitAuras(unit) then
            HideSUIAuraContainers(frame)
            return
        end

        CreateUnitAuraContainers(frame, unit)
        DisableDefaultUnitAuraContainer(frame)
        UpdateUnitDebuffCasterFilter(frame)

        if frame.SUIBuffContainer then
            frame.SUIBuffContainer:SetEnabled(true)
            frame.SUIBuffContainer:Show()
            frame.SUIBuffContainer:SetUnit(unit)
            frame.SUIBuffContainer:UpdateAllAuras()
        end

        ReflowUnitAuraContainers(frame)

        if frame.SUIDebuffContainer then
            frame.SUIDebuffContainer:SetEnabled(true)
            frame.SUIDebuffContainer:Show()
            frame.SUIDebuffContainer:SetUnit(unit)
            frame.SUIDebuffContainer:UpdateAllAuras()
        end
    end

    local function RefreshTargetAndFocusAuras()
        UpdateUnitAuraContainers(TargetFrame, "target")
        UpdateUnitAuraContainers(FocusFrame, "focus")
    end

    local function PositionTargetOfTargetFrames()
        if TargetFrameToT then
            TargetFrameToT:ClearAllPoints()
            TargetFrameToT:SetPoint("RIGHT", TargetFrame, "RIGHT", 45, -55)
        end

        if FocusFrameToT then
            FocusFrameToT:ClearAllPoints()
            FocusFrameToT:SetPoint("RIGHT", FocusFrame, "RIGHT", 45, -55)
        end
    end

    local bbfHooked
    local function HookBetterBlizzFrames()
        if bbfHooked or type(_G.BBF) ~= "table" then
            return
        end

        local hooked = false
        if type(_G.BBF.HookPlayerAndTargetAuras) == "function" then
            hooksecurefunc(_G.BBF, "HookPlayerAndTargetAuras", RefreshTargetAndFocusAuras)
            hooked = true
        end

        if type(_G.BBF.RestyleAuraButtons) == "function" then
            hooksecurefunc(_G.BBF, "RestyleAuraButtons", RefreshTargetAndFocusAuras)
            hooked = true
        end

        bbfHooked = hooked
    end

    HookBetterBlizzFrames()

    local bbfLoadWatcher = CreateFrame("Frame")
    bbfLoadWatcher:RegisterEvent("ADDON_LOADED")
    bbfLoadWatcher:SetScript("OnEvent", function(_, _, addonName)
        if addonName == "BetterBlizzFrames" then
            HookBetterBlizzFrames()
            RefreshTargetAndFocusAuras()
        end
    end)

    -- Hooks

    hooksecurefunc(TargetFrame, "OnEvent", function(self)
        -- Set Health Texture
        if not isClassic and db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        -- Recolor Reputation Bar
        if not isClassic and (SUI:Color()) then
            SUIColorRepBar(self)
        end

        -- Style Buffs & Debuffs
        UpdateUnitAuraContainers(self, self.unit or "target")
    end)

    hooksecurefunc(FocusFrame, "OnEvent", function(self)
        -- Set Health Texture
        if not isClassic and db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        -- Recolor Reputation Bar
        if not isClassic and (SUI:Color()) then
            SUIColorRepBar(self)
        end

        -- Style Buffs & Debuffs
        UpdateUnitAuraContainers(self, self.unit or "focus")
    end)

    hooksecurefunc(TargetFrameToT, "Update", function(self)
        -- Set Health Texture
        if not isClassic and db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        PositionTargetOfTargetFrames()
    end)

    hooksecurefunc(FocusFrameToT, "Update", function(self)
        -- Set Health Texture
        if not isClassic and db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        PositionTargetOfTargetFrames()
    end)

    local function RefreshFrameAuras(frame)
        if not frame then
            return
        end

        UpdateUnitAuraContainers(frame, frame.unit)

        if frame.auraPools then
            for aura, _ in frame.auraPools:EnumerateActive() do
                UpdateFrameAuras(aura)

                if aura.Border then
                    StyleTargetDebuff(aura)
                else
                    StyleTargetBuff(aura)
                end
            end
        end
    end

    function Module:RefreshAuras()
        if type(TargetFrame_UpdateAuras) == "function" then
            TargetFrame_UpdateAuras(TargetFrame)
            if FocusFrame then
                TargetFrame_UpdateAuras(FocusFrame)
            end
        end

        if TargetFrame and type(TargetFrame.UpdateAuras) == "function" then
            TargetFrame:UpdateAuras()
        else
            RefreshFrameAuras(TargetFrame)
        end

        if FocusFrame and type(FocusFrame.UpdateAuras) == "function" then
            FocusFrame:UpdateAuras()
        else
            RefreshFrameAuras(FocusFrame)
        end
    end

    if TargetFrame and type(TargetFrame.UpdateAuras) == "function" then
        hooksecurefunc(TargetFrame, "UpdateAuras", RefreshFrameAuras)
    end

    if FocusFrame and type(FocusFrame.UpdateAuras) == "function" then
        hooksecurefunc(FocusFrame, "UpdateAuras", RefreshFrameAuras)
    end

    -- Set TargetFrame Buff/Debuff SetSize
    if type(TargetFrame_UpdateBuffAnchor) == "function" then
        hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, buff)
            CacheAuraAnchor(buff)
            StyleTargetBuff(buff)
        end)
    end

    if type(TargetFrame_UpdateDebuffAnchor) == "function" then
        hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, debuff)
            CacheAuraAnchor(debuff)
            StyleTargetDebuff(debuff)
        end)
    end

    RefreshTargetAndFocusAuras()
    PositionTargetOfTargetFrames()
end
