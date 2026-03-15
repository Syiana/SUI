local Module = SUI:NewModule("Tooltip.Core");

function Module:OnEnable()
    local db = SUI.db.profile.tooltip

    local TooltipFrame = CreateFrame('Frame', "TooltipFrame", UIParent)
    TooltipFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 120)
    TooltipFrame:SetSize(150, 25)

    -- tooltip anchor
    if (db.mouseanchor) then
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_CURSOR")
        end)
    else
        hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
        end)
    end

    if (db.style == "Custom") then
        FONT = STANDARD_TEXT_FONT
        local classColorHex, factionColorHex = {}, {}

        local cfg = {
            textColor = { 0.4, 0.4, 0.4 },
            bossColor = { 1, 0, 0 },
            eliteColor = { 1, 0, 0.5 },
            rareeliteColor = { 1, 0.5, 0 },
            rareColor = { 1, 0.5, 0 },
            levelColor = { 0.8, 0.8, 0.5 },
            deadColor = { 0.5, 0.5, 0.5 },
            targetColor = { 1, 0.5, 0.5 },
            guildColor = { 0.8, 0.0, 0.6 },
            afkColor = { 0, 1, 1 },
            scale = 0.95,
            fontFamily = STANDARD_TEXT_FONT,
        }

        if (db) then
            GameTooltipStatusBar:SetStatusBarTexture(
                "Interface\\Addons\\SUI\\Media\\Textures\\Tooltip\\UI-TargetingFrame-BarFill_test")
        end

        local function GetHexColor(color)
            if color.r then
                return ("%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
            else
                local r, g, b, a = unpack(color)
                return ("%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
            end
        end

        local function GetTarget(unit)
            if not unit or not canaccessvalue(unit) then
                return nil
            end

            local isPlayer = UnitIsPlayer(unit)
            if isPlayer and canaccessvalue(isPlayer) then
                local unitName = UnitName(unit)
                local playerName = UnitName("player")

                if unitName and playerName and canaccessvalue(unitName) and canaccessvalue(playerName) and unitName == playerName then
                    return ("|cffff0000%s|r"):format("<YOU>")
                end

                local _, class = UnitClass(unit)
                if class and classColorHex[class] and unitName and canaccessvalue(unitName) then
                    return ("|cff%s%s|r"):format(classColorHex[class], unitName)
                end
            else
                local reaction = UnitReaction(unit, "player")
                local targetName = UnitName(unit)
                if reaction and canaccessvalue(reaction) and targetName and canaccessvalue(targetName) then
                    return ("|cff%s%s|r"):format(factionColorHex[reaction], targetName)
                elseif targetName and canaccessvalue(targetName) then
                    return ("|cffffffff%s|r"):format(targetName)
                end
                return nil
            end

            return nil
        end

        local function OnTooltipSetUnit(self)
            if self ~= _G.GameTooltip then
                return
            end

            local unitName, unit = self:GetUnit()
            if not unit or not canaccessvalue(unit) then return end
            if unitName and not canaccessvalue(unitName) then unitName = nil end
            
            --color tooltip textleft
            for i = 2, GameTooltip:NumLines() do
                local line = _G["GameTooltipTextLeft" .. i]
                if line and i ~= 4 then
                    line:SetTextColor(unpack(cfg.textColor))
                end
            end
            --position raidicon
            if unit and canaccessvalue(unit) then
                local raidIconIndex = GetRaidTargetIndex(unit)
                if raidIconIndex and canaccessvalue(raidIconIndex) then
                    if raidIconIndex == 16 then
                        GameTooltipTextLeft1:SetText(("%s"):format(unitName or ""))
                    else
                        GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex] .. "14|t", unitName or ""))
                    end
                end
            end
            if not UnitIsPlayer(unit) then
                local reaction = UnitReaction(unit, "player")
                if reaction then
                    local color = FACTION_BAR_COLORS[reaction]
                    if color then
                        cfg.barColor = color
                        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
                        GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
                    end
                end
                --color textleft2 by classificationcolor
                local unitClassification = UnitClassification(unit)
                local levelLine
                local text2 = GameTooltipTextLeft2:GetText()
                if text2 and text2:match("%a%s%d") then
                    levelLine = GameTooltipTextLeft2
                elseif GameTooltipTextLeft3 then
                    local text3 = GameTooltipTextLeft3:GetText()
                    if text3 and text3:match("%a%s%d") then
                        GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor))
                        levelLine = GameTooltipTextLeft3
                    end
                end
                if levelLine then
                    local l = UnitLevel(unit)
                    local color = GetCreatureDifficultyColor((l > 0) and l or 999)
                    levelLine:SetTextColor(color.r, color.g, color.b)
                end
                if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
                    self:AppendText(" |cffff0000[B]|r")
                    GameTooltipTextLeft2:SetTextColor(unpack(cfg.bossColor))
                elseif unitClassification == "rare" then
                    self:AppendText(" |cffff9900[R]|r")
                elseif unitClassification == "rareelite" then
                    self:AppendText(" |cffff0000[R+]|r")
                elseif unitClassification == "elite" then
                    self:AppendText(" |cffff6666[E]|r")
                end
            else
                --unit is any player
                local _, unitClass = UnitClass(unit)
                --color textleft1 and statusbar by class color
                local color = RAID_CLASS_COLORS[unitClass]
                cfg.barColor = color
                GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
                _G["GameTooltipTextLeft1"]:SetTextColor(color.r, color.g, color.b)
                --color textleft2 by guildcolor
                local guildName, guildRank = GetGuildInfo(unit)
                if guildName then
                    _G["GameTooltipTextLeft2"]:SetText("<" .. guildName .. "> [" .. guildRank .. "]")
                    _G["GameTooltipTextLeft2"]:SetTextColor(unpack(cfg.guildColor))
                end
                local levelLine = guildName and _G["GameTooltipTextLeft3"] or _G["GameTooltipTextLeft2"]
                local l = UnitLevel(unit)
                local color = GetCreatureDifficultyColor((l > 0) and l or 999)
                levelLine:SetTextColor(color.r, color.g, color.b)
                --afk?
                local isAFK = UnitIsAFK(unit)
                if canaccessvalue(isAFK) and isAFK then
                    self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
                end
            end
            --dead?
            local isDead = UnitIsDeadOrGhost(unit)
            if canaccessvalue(isDead) and isDead then
                _G["GameTooltipTextLeft1"]:SetTextColor(unpack(cfg.deadColor))
            end
            --target line
            local targetUnit = unit and (unit .. "target") or nil
            local targetExists = targetUnit and UnitExists(targetUnit)
            if canaccessvalue(targetExists) and targetExists then
                GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"),
                    GetTarget(targetUnit) or "Unknown")
            end
        end

        local function SetStatusBarColor(self, r, g, b)
            if not cfg.barColor then return end
            if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
            self:SetStatusBarColor(cfg.barColor.r, cfg.barColor.g, cfg.barColor.b)
        end

        --hex class colors
        for class, color in next, RAID_CLASS_COLORS do
            classColorHex[class] = GetHexColor(color)
        end
        --hex reaction colors
        --for idx, color in next, FACTION_BAR_COLORS do
        for i = 1, #FACTION_BAR_COLORS do
            factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
        end

        cfg.targetColorHex = GetHexColor(cfg.targetColor)
        cfg.afkColorHex = GetHexColor(cfg.afkColor)

        --GameTooltipHeaderText:SetFont(cfg.fontFamily, 14)
        --GameTooltipHeaderText:SetShadowOffset(1,-2)
        --GameTooltipHeaderText:SetShadowColor(0,0,0,0.75)
        --GameTooltipText:SetFont(cfg.fontFamily, 12, "NONE")
        --GameTooltipText:SetShadowOffset(1,-2)
        --GameTooltipText:SetShadowColor(0,0,0,0.75)
        --Tooltip_Small:SetFont(cfg.fontFamily, 11, "NONE")
        --Tooltip_Small:SetShadowOffset(1,-2)
        --Tooltip_Small:SetShadowColor(0,0,0,0.75)

        if (db.lifeontop) then
            GameTooltipStatusBar:ClearAllPoints()
            GameTooltipStatusBar:SetPoint("LEFT", 4.5, 0)
            GameTooltipStatusBar:SetPoint("RIGHT", -4.5, 0)
            GameTooltipStatusBar:SetPoint("TOP", 0, -3)
            GameTooltipStatusBar:SetHeight(4)
        else
            GameTooltipStatusBar:ClearAllPoints()
            GameTooltipStatusBar:SetPoint("LEFT", 4.5, 0)
            GameTooltipStatusBar:SetPoint("RIGHT", -4.5, 0)
            GameTooltipStatusBar:SetPoint("BOTTOM", 0, 3)
            GameTooltipStatusBar:SetHeight(4)
        end

        --gametooltip statusbar bg
        GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
        GameTooltipStatusBar.bg:SetAllPoints()
        GameTooltipStatusBar.bg:SetColorTexture(1, 1, 1)
        GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.5)

        --GameTooltipStatusBar:SetStatusBarColor()
        hooksecurefunc(GameTooltipStatusBar, "SetStatusBarColor", SetStatusBarColor)
        --OnTooltipSetUnit
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipSetUnit)
        --GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

        --loop over menues
        local menues = {
            DropDownList1MenuBackdrop,
            DropDownList2MenuBackdrop,
        }
        for i, menu in next, menues do
            menu:SetScale(cfg.scale)
        end

        --TooltipAddSpellID
        local function TooltipAddSpellID(self, spellid)
            if not spellid then return end
            if type(spellid) == "table" and #spellid == 1 then spellid = spellid[1] end
            
            -- Check if ID already exists in tooltip
            local tooltipName = self:GetName()
            if tooltipName and canaccessvalue(tooltipName) then
                for i = 1, 15 do
                    local frame = _G[tooltipName .. "TextLeft" .. i]
                    if frame then 
                        local success, text = pcall(frame.GetText, frame)
                        if success and text and canaccessvalue(text) and type(text) == "string" and text:find("|cff0099ffID|r", 1, true) then 
                            return 
                        end
                    end
                end
            end
            self:AddDoubleLine("|cff0099ffID|r", spellid)
            self:Show()
        end

        --hooksecurefunc SetItemRef
        hooksecurefunc("SetItemRef", function(link)
            local type, value = link:match("(%a+):(.+)")
            if type == "spell" then
                TooltipAddSpellID(ItemRefTooltip, value:match("([^:]+)"))
            end
        end)

        --OnTooltipSetSpell callback
        local function OnTooltipSetSpell(self, data)
            if data and canaccessvalue(data) and data.id and canaccessvalue(data.id) then
                TooltipAddSpellID(self, data.id)
            end
        end

        --OnMacroTooltipSetSpell callback
        local function OnMacroTooltipSetSpell(self)
            if not canaccessvalue(self) then return end
            
            local tooltipData = self:GetTooltipData()
            if tooltipData and tooltipData.lines and tooltipData.lines[2] then
                local leftText = tooltipData.lines[2].leftText
                if leftText and canaccessvalue(leftText) then
                    local spellInfo = C_Spell.GetSpellInfo(leftText)
                    if spellInfo and spellInfo.spellID then
                        TooltipAddSpellID(self, spellInfo.spellID)
                    end
                end
            end
        end

        -- Register tooltip callbacks
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, OnMacroTooltipSetSpell)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, OnTooltipSetSpell)
        -- Note: UnitAura callback disabled due to secret value errors in secure contexts
    end

    if (db.hideincombat) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_REGEN_DISABLED")
        f:RegisterEvent("PLAYER_REGEN_ENABLED")
        f:SetScript("OnEvent", function(self, event, ...)
            if event == "PLAYER_REGEN_DISABLED" then
                GameTooltip:SetScript('OnShow', GameTooltip.Hide)
            else
                GameTooltip:SetScript('OnShow', GameTooltip.Show)
            end
        end)
    end
end
