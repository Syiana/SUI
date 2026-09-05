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
        if not db.unitframes.targetauralayoutv3 then
            if db.unitframes.buffs and (db.unitframes.buffs.perrow == 6 or db.unitframes.buffs.perrow == 8) then
                db.unitframes.buffs.perrow = 7
            end

            if db.unitframes.debuffs and (db.unitframes.debuffs.perrow == 6 or db.unitframes.debuffs.perrow == 8) then
                db.unitframes.debuffs.perrow = 7
            end

            if db.unitframes.buffs and db.unitframes.buffs.size == 20 then
                db.unitframes.buffs.size = 18
            end

            if db.unitframes.debuffs and db.unitframes.debuffs.size == 20 then
                db.unitframes.debuffs.size = 18
            end

            db.unitframes.targetaurarowsmigrated = true
            db.unitframes.targetaurarowslayoutv2 = true
            db.unitframes.targetauralayoutv3 = true
        end

        if not db.unitframes.targetauralayoutv4 then
            if db.unitframes.buffs then
                db.unitframes.buffs.targetx = 0
                db.unitframes.buffs.targety = 0
            end

            if db.unitframes.debuffs then
                db.unitframes.debuffs.targetx = 0
                db.unitframes.debuffs.targety = 0
            end

            db.unitframes.targetauralayoutv4 = true
        end
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

    local function GetAuraTextSize(isDebuff)
        local settings = db.unitframes[isDebuff and "debuffs" or "buffs"]

        return (settings and settings.targettextsize) or 10
    end

    -- The countdown sits centered on the icon, so a value like "30m" bleeds past the edges at
    -- full text size on small icons. Cap it against the icon; the stack count is one or two
    -- digits in a corner and keeps the configured size.
    local function GetAuraCountdownTextSize(isDebuff)
        local settings = db.unitframes[isDebuff and "debuffs" or "buffs"]
        local iconSize = (settings and settings.size) or 18

        return math.max(math.min(GetAuraTextSize(isDebuff), math.floor(iconSize * 0.5)), 6)
    end

    -- A plain SetFont on the countdown string does not survive: the Cooldown frame re-applies
    -- its own font whenever it restarts. Handing it a font object is the route it honours, and
    -- resizing that object propagates to every icon already using it.
    local auraCountdownFonts = {}

    local function GetAuraCountdownFont(isDebuff)
        local name = isDebuff and "SUIAuraDebuffCountdownFont" or "SUIAuraBuffCountdownFont"
        local font = auraCountdownFonts[name]
        if not font then
            font = CreateFont(name)
            auraCountdownFonts[name] = font
        end

        font:SetFont(STANDARD_TEXT_FONT, GetAuraCountdownTextSize(isDebuff), "OUTLINE")

        return font, name
    end

    local function ApplyAuraTextSize(aura, isDebuff)
        if not aura then
            return
        end

        if aura.Count then
            aura.Count:SetFont(STANDARD_TEXT_FONT, GetAuraTextSize(isDebuff), "OUTLINE")
        end

        if aura.CooldownText then
            local font, fontName = GetAuraCountdownFont(isDebuff)
            local applied = false
            if aura.Cooldown and type(aura.Cooldown.SetCountdownFont) == "function" then
                applied = pcall(aura.Cooldown.SetCountdownFont, aura.Cooldown, fontName)
            end

            if not applied then
                aura.CooldownText:SetFontObject(font)
            end
        end
    end

    local function StyleTargetBuff(buff, skipOffset)
        buff:SetSize(db.unitframes.buffs.size, db.unitframes.buffs.size)
        if not skipOffset then
            OffsetAuraPosition(buff, db.unitframes.buffs.targetx or 0, db.unitframes.buffs.targety or 0)
        end

        if buff.Count then
            ApplyAuraTextSize(buff, false)
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
            ApplyAuraTextSize(debuff, true)
            debuff.Count:ClearAllPoints()
            debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 2, 0)
        end
    end

    local fallbackDebuffColors = {
        none = { r = 0.8, g = 0, b = 0 },
        Magic = { r = 0.2, g = 0.6, b = 1 },
        Curse = { r = 0.6, g = 0, b = 1 },
        Disease = { r = 0.6, g = 0.4, b = 0 },
        Poison = { r = 0, g = 0.6, b = 0 }
    }

    local function GetDebuffBorderColor(debuffType)
        if DebuffTypeColor and DebuffTypeColor[debuffType] then
            return DebuffTypeColor[debuffType]
        end

        return fallbackDebuffColors[debuffType] or fallbackDebuffColors.none
    end

    local function ApplyAuraBorderColor(auraFrame, color)
        if not auraFrame or not color then
            return
        end

        local r = color.r or color[1]
        local g = color.g or color[2]
        local b = color.b or color[3]

        if not r or not g or not b then
            return
        end

        if auraFrame.border then
            auraFrame.border:SetVertexColor(r, g, b, 1)
        end

        if auraFrame.DebuffBorder then
            auraFrame.DebuffBorder:SetAlpha(0)
        end

        if auraFrame.SUIBorderOverlay and not auraFrame.SUIDebuffTypeBorder then
            auraFrame.SUIDebuffTypeBorder = auraFrame.SUIBorderOverlay:CreateTexture(nil, "OVERLAY", nil, 2)
            auraFrame.SUIDebuffTypeBorder:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss_border_w")
            auraFrame.SUIDebuffTypeBorder:SetTexCoord(0, 1, 0, 1)
            auraFrame.SUIDebuffTypeBorder:ClearAllPoints()
            auraFrame.SUIDebuffTypeBorder:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -2, 2)
            auraFrame.SUIDebuffTypeBorder:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 2, -2)
            auraFrame.SUIDebuffTypeBorder:SetDesaturated(true)
        end

        if auraFrame.SUIDebuffTypeBorder then
            auraFrame.SUIDebuffTypeBorder:SetVertexColor(r, g, b, 1)
            auraFrame.SUIDebuffTypeBorder:Show()
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

    local function InitializeUnitAuraButton(auraFrame, isDebuff, size, borderColor)
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
                auraFrame.CooldownText:ClearAllPoints()
                -- Pin both edges instead of just CENTER so the string can never bleed far past
                -- the icon. A few pixels of overhang keep "58m" from being cut to "5...".
                auraFrame.CooldownText:SetPoint("LEFT", auraFrame.Icon, "LEFT", -4, 0)
                auraFrame.CooldownText:SetPoint("RIGHT", auraFrame.Icon, "RIGHT", 4, 0)
                auraFrame.CooldownText:SetJustifyH("CENTER")
                auraFrame.CooldownText:SetWordWrap(false)
            end
        end

        if not auraFrame.SUIBorderOverlay then
            auraFrame.SUIBorderOverlay = CreateFrame("Frame", nil, auraFrame)
            auraFrame.SUIBorderOverlay:SetAllPoints(auraFrame)
            auraFrame.SUIBorderOverlay:SetFrameLevel(auraFrame.Cooldown:GetFrameLevel() + 1)
        end

        if not auraFrame.Count then
            auraFrame.Count = auraFrame.SUIBorderOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
            auraFrame.Count:SetFont(STANDARD_TEXT_FONT, GetAuraTextSize(isDebuff), "OUTLINE")
            auraFrame.Count:SetPoint("BOTTOMRIGHT", auraFrame.Icon, "BOTTOMRIGHT", 1, 0)
            auraFrame:SetApplicationCount(auraFrame.Count)
        end

        UpdateFrameAuras(auraFrame)
        if auraFrame.border and auraFrame.SUIBorderOverlay then
            auraFrame.border:SetParent(auraFrame.SUIBorderOverlay)
            auraFrame.border:SetDrawLayer("OVERLAY", 1)
            if borderColor then
                ApplyAuraBorderColor(auraFrame, borderColor)
            end
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
        local main = frame and frame.TargetFrameContent and frame.TargetFrameContent.TargetFrameContentMain
        return main and ((main.ManaBarArea and main.ManaBarArea.ManaBar) or main.ManaBar) or
            (frame and frame.TargetFrameContainer and frame.TargetFrameContainer.FrameTexture) or frame
    end

    local function GetAuraLineSize(size, perRow)
        perRow = tonumber(perRow) or 7
        if perRow < 1 then
            perRow = 1
        end

        return perRow * size + math.max(perRow - 1, 0) * 3
    end

    -- Buff modes:   all | normal | purgeable | hide
    -- Debuff modes: all | own | hide
    local function GetBuffMode()
        local settings = db.unitframes.buffs

        return (settings and settings.mode) or "purgeable"
    end

    local function GetDebuffMode()
        local settings = db.unitframes.debuffs

        return (settings and settings.mode) or "all"
    end

    local function AuraDisplayEnabled(kind)
        if kind == "debuffs" then
            return GetDebuffMode() ~= "hide"
        end

        local mode = GetBuffMode()
        if kind == "stealable" then
            return mode == "all" or mode == "purgeable"
        end

        return mode == "all" or mode == "normal"
    end

    -- Order defines the vertical stacking away from the unit frame. Stealable buffs live in
    -- their own container so they can be toggled without touching the regular buffs.
    local auraContainerOrder = {
        { field = "SUIDebuffContainer",    kind = "debuffs",   sizeKey = "debuffs" },
        { field = "SUIBuffContainer",      kind = "buffs",     sizeKey = "buffs" },
        { field = "SUIStealableContainer", kind = "stealable", sizeKey = "buffs" }
    }

    local function EnumerateSUIAuraContainers(frame)
        local containers = {}
        if not frame then
            return containers
        end

        for _, info in ipairs(auraContainerOrder) do
            local container = frame[info.field]
            if container then
                containers[#containers + 1] = {
                    container = container,
                    sizeKey = info.sizeKey,
                    enabled = AuraDisplayEnabled(info.kind)
                }
            end
        end

        return containers
    end

    local function HideSUIAuraContainers(frame)
        for _, entry in ipairs(EnumerateSUIAuraContainers(frame)) do
            entry.container:SetEnabled(false)
            entry.container:Hide()
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

        -- frameOffsetY compensates for the transparent border of the unit frame texture.
        -- Chaining container to container needs its own value: when the stack grows upwards the
        -- same negative offset would pull the next block down into the previous one instead of
        -- leaving a gap, and the flow layout padding sits on the far side in that direction.
        local mirrorVertically = frame.buffsOnTop == true
        local point, relativePoint, frameOffsetY, chainOffsetY
        if mirrorVertically then
            point, relativePoint, frameOffsetY, chainOffsetY = "BOTTOMLEFT", "TOPLEFT", -6, 0
        else
            point, relativePoint, frameOffsetY, chainOffsetY = "TOPLEFT", "BOTTOMLEFT", 4, 4
        end

        local verticalGrowth = mirrorVertically and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down
        local auraStartX = 5
        local anchor = frame.TargetFrameContainer and frame.TargetFrameContainer.FrameTexture or GetUnitAuraAnchor(frame)
        local previous, previousX, lastVisible

        for _, entry in ipairs(EnumerateSUIAuraContainers(frame)) do
            local container = entry.container
            local settings = db.unitframes[entry.sizeKey] or {}
            local offsetX = settings.targetx or 0
            local extraY = settings.targety or 0

            container:ClearAllPoints()
            if entry.enabled and previous then
                -- previousX is already baked into the anchor, so subtract it to keep offsetX absolute.
                container:SetPoint(point, previous, relativePoint, offsetX - previousX, chainOffsetY + extraY)
            else
                container:SetPoint(point, anchor, relativePoint, auraStartX + offsetX, frameOffsetY + extraY)
            end

            if entry.enabled then
                previous, previousX = container, offsetX
                lastVisible = container
            end

            container:SetFlowLayoutAnchorPoint(point)
            container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, verticalGrowth)
            container:SetFlowLayoutMaximumLineSize(GetAuraLineSize(settings.size or 18, settings.perrow))
        end

        frame.SUIAuraAnchorContainer = lastVisible or frame.SUIBuffContainer
    end

    local AnchorSpellbarBelowAuras

    AnchorSpellbarBelowAuras = function(frame)
        local castbars = SUI.db.profile.castbars
        if not frame or not castbars then
            return
        end

        local isTarget = frame == TargetFrame
        local isFocus = frame == FocusFrame
        if (isTarget and (not castbars.targetCastbar or castbars.targetOnTop)) or
            (isFocus and (not castbars.focusCastbar or castbars.focusOnTop)) or
            (not isTarget and not isFocus) then
            return
        end

        local spellbar = _G[frame:GetName() .. "SpellBar"]
        if not spellbar or not frame.SUIBuffContainer then
            return
        end
        frame.SUISpellbar = spellbar

        if spellbar.IsForbidden then
            local ok, forbidden = pcall(spellbar.IsForbidden, spellbar)
            if ok and forbidden then
                return
            end
        end

        if not spellbar.SUISpellbarAnchorHooked then
            spellbar.SUISpellbarAnchorHooked = true
            hooksecurefunc(spellbar, "SetPoint", function(bar)
                if not bar.SUIReanchoring then
                    AnchorSpellbarBelowAuras(frame)
                end
            end)
        end

        local _, relTo = spellbar:GetPoint()
        local container = frame.SUIAuraAnchorContainer or frame.SUIBuffContainer

        spellbar.SUIReanchoring = true
        if frame.buffsOnTop == true then
            if relTo ~= container then
                spellbar.SUIReanchoring = false
                return
            end

            local pointX = frame.smallSize and 38 or 43
            local pointY = frame.smallSize and 3 or 5
            if frame.haveToT then
                pointY = frame.smallSize and -48 or -46
            end

            spellbar:ClearAllPoints()
            spellbar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", pointX, pointY)
            spellbar.SUIReanchoring = false
            return
        else
            if relTo == container then
                spellbar.SUIReanchoring = false
                return
            end

            spellbar:ClearAllPoints()
            spellbar:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 18, -2)
        end
        spellbar.SUIReanchoring = false
    end

    local function UpdateUnitDebuffCasterFilter(frame)
        local debuffContainer = frame and frame.SUIDebuffContainer
        if not debuffContainer then
            return
        end

        local showAllCasters = GetDebuffMode() ~= "own"
        if debuffContainer.SUIShowAllCasters == showAllCasters then
            return
        end

        debuffContainer.SUIShowAllCasters = showAllCasters
        local filterString = showAllCasters and AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful) or
            AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player)

        for _, groupInfo in ipairs(debuffContainer.SUIDebuffGroups or {}) do
            debuffContainer:SetAuraGroupFilterString(groupInfo.key, filterString)
            local candidateFilters = {
                includeDispelTypes = groupInfo.includeDispelTypes,
                excludeDispelTypes = groupInfo.excludeDispelTypes
            }
            if not showAllCasters then
                candidateFilters.isFromPlayerOrPlayerPet = true
            end
            debuffContainer:SetAuraGroupCandidateFilters(groupInfo.key, candidateFilters)
        end
    end

    local function CreateUnitAuraContainers(frame, unit)
        if not frame or not frame.GetAuraContainer or frame.SUIBuffContainer or frame.SUIDebuffContainer or
            not AuraUtil or type(AuraUtil.CreateFilterString) ~= "function" then
            return
        end

        DisableDefaultUnitAuraContainer(frame)

        local parent = GetUnitAuraParent(frame)
        local function NewAuraContainer()
            local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
            if parent and parent.GetFrameLevel then
                container:SetFrameLevel(math.max(parent:GetFrameLevel() + 2, 0))
            end
            container:SetSize(1, 1)
            container:SetFlowLayoutPadding(0, 0, 0, 10)
            container:SetUnit(unit)
            container:SetEnabled(true)

            return container
        end

        local buffContainer = NewAuraContainer()
        frame.SUIBuffContainer = buffContainer

        local stealableContainer = NewAuraContainer()
        frame.SUIStealableContainer = stealableContainer

        local debuffContainer = NewAuraContainer()
        frame.SUIDebuffContainer = debuffContainer

        ReflowUnitAuraContainers(frame)
        local spellbar = _G[frame:GetName() .. "SpellBar"]
        if spellbar then
            spellbar:ClearAllPoints()
            spellbar:SetPoint("TOPLEFT", frame.SUIAuraAnchorContainer or buffContainer, "BOTTOMLEFT", 18, -2)
        end
        AnchorSpellbarBelowAuras(frame)

        -- Split by dispel type rather than isStealable: that flag is class dependent (it only
        -- reports true for specs with an offensive dispel), so it stays empty for everyone else.
        buffContainer:AddAuraGroup("Buffs", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
            maxFrameCount = 32,
            candidateFilters = {
                excludeDispelTypes = {
                    Magic = true
                }
            },
            initializeFrame = function(auraFrame)
                InitializeUnitAuraButton(auraFrame, false, db.unitframes.buffs.size)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        stealableContainer:AddAuraGroup("BuffsStealable", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
            maxFrameCount = 32,
            candidateFilters = {
                includeDispelTypes = {
                    Magic = true
                }
            },
            initializeFrame = function(auraFrame)
                -- Every other group hands the button a border colour; without one the
                -- gloss border stays uncoloured and reads as a black ring, which left
                -- purgeable buffs looking exactly like ordinary ones. This group only
                -- ever holds Magic auras, so give it the same blue as magic debuffs.
                InitializeUnitAuraButton(auraFrame, false, db.unitframes.buffs.size, GetDebuffBorderColor("Magic"))
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })

        local debuffFilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player)
        local debuffGroups = {{
            key = "DebuffsNone",
            excludeDispelTypes = {
                Magic = true,
                Curse = true,
                Disease = true,
                Poison = true
            },
            color = GetDebuffBorderColor("none")
        }, {
            key = "DebuffsMagic",
            includeDispelTypes = {
                Magic = true
            },
            color = GetDebuffBorderColor("Magic")
        }, {
            key = "DebuffsCurse",
            includeDispelTypes = {
                Curse = true
            },
            color = GetDebuffBorderColor("Curse")
        }, {
            key = "DebuffsDisease",
            includeDispelTypes = {
                Disease = true
            },
            color = GetDebuffBorderColor("Disease")
        }, {
            key = "DebuffsPoison",
            includeDispelTypes = {
                Poison = true
            },
            color = GetDebuffBorderColor("Poison")
        }}
        debuffContainer.SUIDebuffGroups = debuffGroups

        for _, groupInfo in ipairs(debuffGroups) do
            debuffContainer:AddAuraGroup(groupInfo.key, debuffFilter, {
                maxFrameCount = 16,
                candidateFilters = {
                    includeDispelTypes = groupInfo.includeDispelTypes,
                    excludeDispelTypes = groupInfo.excludeDispelTypes,
                    isFromPlayerOrPlayerPet = true
                },
                initializeFrame = function(auraFrame)
                    InitializeUnitAuraButton(auraFrame, true, db.unitframes.debuffs.size, groupInfo.color)
                end,
                layout = {
                    elementSpacing = 3,
                    lineSpacing = 3
                }
            })
        end

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

        for _, entry in ipairs(EnumerateSUIAuraContainers(frame)) do
            local container = entry.container
            if entry.enabled then
                container:SetEnabled(true)
                container:Show()
                container:SetUnit(unit)
                container:UpdateAllAuras()
            else
                container:SetEnabled(false)
                container:Hide()
            end
        end

        ReflowUnitAuraContainers(frame)
        AnchorSpellbarBelowAuras(frame)
    end

    local function RefreshTargetAndFocusAuras()
        UpdateUnitAuraContainers(TargetFrame, "target")
        UpdateUnitAuraContainers(FocusFrame, "focus")
    end

    local function PositionTargetOfTargetFrames()
        if InCombatLockdown() then
            return
        end

        local function Position(frame, parent)
            if not frame or not parent then
                return
            end

            if frame.IsForbidden then
                local ok, forbidden = pcall(frame.IsForbidden, frame)
                if ok and forbidden then
                    return
                end
            end

            local ok = pcall(frame.ClearAllPoints, frame)
            if ok then
                pcall(frame.SetPoint, frame, "RIGHT", parent, "RIGHT", 45, -55)
            end
        end

        Position(TargetFrameToT, TargetFrame)
        Position(FocusFrameToT, FocusFrame)
    end

    local function QueueTargetOfTargetPosition()
        C_Timer.After(0, PositionTargetOfTargetFrames)
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

    local totPositionWatcher = CreateFrame("Frame")
    totPositionWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
    totPositionWatcher:RegisterEvent("PLAYER_TARGET_CHANGED")
    totPositionWatcher:RegisterEvent("PLAYER_FOCUS_CHANGED")
    totPositionWatcher:RegisterEvent("PLAYER_REGEN_ENABLED")
    totPositionWatcher:SetScript("OnEvent", QueueTargetOfTargetPosition)

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

    end)

    hooksecurefunc(FocusFrameToT, "Update", function(self)
        -- Set Health Texture
        if not isClassic and db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

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
    QueueTargetOfTargetPosition()
end
