local ADDON, SUI = ...
SUI.MODULES.BUFFS.Buffs = function(DB) 
	if (DB and DB.STATE) then
        FONT = STANDARD_TEXT_FONT

        if SUIDB.adjustOneletterAbbrev then
            HOUR_ONELETTER_ABBR = "%dh"
            DAY_ONELETTER_ABBR = "%dd"
            MINUTE_ONELETTER_ABBR = "%dm"
            SECOND_ONELETTER_ABBR = "%ds"
        end

        local backdropDebuff = {
            bgFile = nil,
            edgeFile = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 6,
            insets = {
                left = 6,
                right = 6,
                top = 6,
                bottom = 6,
            },
        }

        local backdropBuff = {
            bgFile = nil,
            edgeFile = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 6,
            insets = {
                left = 6,
                right = 6,
                top = 6,
                bottom = 6,
            },
        }

        local ceil, min, max = ceil, min, max
        local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame

        local buffFrameHeight = 0

        local function applySkin(b)
            if not b or (b and b.styled) then return end

            local name = b:GetName()

            local tempenchant, consolidated, debuff, buff = false, false, false, false
            if (name:match("TempEnchant")) then
                tempenchant = true
            elseif (name:match("Consolidated")) then
                consolidated = true
            elseif (name:match("Debuff")) then
                debuff = true
            else
                buff = true
            end

            if debuff then
                SUI = {
                    pos = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = -125},
                    gap = 10,
                    userplaced = true,
                    rowSpacing = 10,
                    colSpacing = 7,
                    buttonsPerRow = 10,
                    button = {
                      size = 34
                    },
                    icon = {
                      padding = -2
                    },
                    border = {
                      texture = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\gloss",
                      color = {r = 0.4, g = 0.35, b = 0.35},
                      classcolored = false
                    },
                    background = {
                      show = true,
                      edgeFile = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\outer_shadow",
                      color = {r = 0, g = 0, b = 0, a = 0.9},
                      classcolored = false,
                      inset = 6,
                      padding = 4
                    },
                    duration = {
                      font = STANDARD_TEXT_FONT,
                      size = 12,
                      pos = {a1 = "BOTTOM", x = 0, y = 0}
                    },
                    count = {
                      font = STANDARD_TEXT_FONT,
                      size = 11,
                      pos = {a1 = "TOPRIGHT", x = 0, y = 0}
                    }
                }
                backdrop = backdropDebuff
            else
                SUI = {
                    pos = {a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0},
                    gap = 30,
                    userplaced = true,
                    rowSpacing = 10,
                    colSpacing = 7,
                    buttonsPerRow = 10,
                    button = {
                      size = 32
                    },
                    icon = {
                      padding = -2
                    },
                    border = {
                      texture = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\gloss",
                      color = {r = 0.4, g = 0.35, b = 0.35},
                      classcolored = false
                    },
                    background = {
                      show = true,
                      edgeFile = "Interface\\AddOns\\SUI\\Inc\\Assets\\Media\\Core\\outer_shadow",
                      color = {r = 0, g = 0, b = 0, a = 0.9},
                      classcolored = false,
                      inset = 6,
                      padding = 4
                    },
                    duration = {
                      font = STANDARD_TEXT_FONT,
                      size = 12,
                      pos = {a1 = "BOTTOM", x = 0, y = 0}
                    },
                    count = {
                      font = STANDARD_TEXT_FONT,
                      size = 11,
                      pos = {a1 = "TOPRIGHT", x = 0, y = 0}
                    }
                }
                backdrop = backdropBuff
            end

            b:SetSize(SUI.button.size, SUI.button.size)

            local icon = _G[name.."Icon"]
            if consolidated then
                if select(1,UnitFactionGroup("player")) == "Alliance" then
                    icon:SetTexture(select(3,GetSpellInfo(61573)))
                elseif select(1,UnitFactionGroup("player")) == "Horde" then
                    icon:SetTexture(select(3,GetSpellInfo(61574)))
                end
            end
            icon:SetTexCoord(0.1,0.9,0.1,0.9)
            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT", b, "TOPLEFT", -SUI.icon.padding, SUI.icon.padding)
            icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", SUI.icon.padding, -SUI.icon.padding)
            icon:SetDrawLayer("BACKGROUND",-8)
            b.icon = icon

            local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
            border:SetTexture(SUI.border.texture)
            border:SetTexCoord(0,1,0,1)
            border:SetDrawLayer("BACKGROUND",-7)
            if tempenchant then
                border:SetVertexColor(0.7,0,1)
            elseif not debuff then
                border:SetVertexColor(SUI.border.color.r,SUI.border.color.g,SUI.border.color.b)
            end
            border:ClearAllPoints()
            border:SetAllPoints(b)
            b.border = border

            b.duration:SetFont(FONT, SUI.duration.size, "THINOUTLINE")
            b.duration:ClearAllPoints()
            b.duration:SetPoint(SUI.duration.pos.a1,SUI.duration.pos.x,SUI.duration.pos.y)

            b.count:SetFont(SUI.count.font, SUI.count.size, "THINOUTLINE")
            b.count:ClearAllPoints()
            b.count:SetPoint(SUI.count.pos.a1,SUI.count.pos.x,SUI.count.pos.y)

            if SUI.background.show then
                local back = CreateFrame("Frame", nil, b, "BackdropTemplate")
                back:SetPoint("TOPLEFT", b, "TOPLEFT", -SUI.background.padding, SUI.background.padding)
                back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", SUI.background.padding, -SUI.background.padding)
                back:SetFrameLevel(b:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)
                back:SetBackdropBorderColor(SUI.background.color.r,SUI.background.color.g,SUI.background.color.b,SUI.background.color.a)
                b.bg = back
            end

            b.styled = true
        end

        local function updateDebuffAnchors(buttonName,index)
            local button = _G[buttonName..index]
            if not button then return end

            if not button.styled then applySkin(button) end

            button:ClearAllPoints()
            if index == 1 then
                if SUIDB.combineBuffsAndDebuffs then
                    button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, -buffFrameHeight)
                else
                    button:SetPoint("TOPRIGHT", rBFS_DebuffDragFrame, "TOPRIGHT", 0, 0)
                end
            elseif index > 1 and mod(index, 10) == 1 then
                button:SetPoint("TOPRIGHT", _G[buttonName..(index-10)], "BOTTOMRIGHT", 0, -10)
            else
                button:SetPoint("TOPRIGHT", _G[buttonName..(index-1)], "TOPLEFT", -7, 0)
            end
        end

        local function updateAllBuffAnchors()

            local buttonName  = "BuffButton"
            local numEnchants = BuffFrame.numEnchants
            local numBuffs    = BUFF_ACTUAL_DISPLAY
            local offset      = numEnchants
            local realIndex, previousButton, aboveButton

            TempEnchant1:ClearAllPoints()
            TempEnchant1:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)

            if BuffFrame.numEnchants > 0 then
                previousButton = _G["TempEnchant"..numEnchants]
            end

            if numEnchants > 0 then
                aboveButton = TempEnchant1
            end

            local buffCounter = 0
            for index = 1, numBuffs do
                local button = _G[buttonName..index]
                if not button then return end
                if not button.consolidated then
                    buffCounter = buffCounter + 1

                    if not button.styled then applySkin(button) end

                    button:ClearAllPoints()
                    realIndex = buffCounter+offset
                    if realIndex == 1 then
                        button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)
                        aboveButton = button
                    elseif realIndex > 1 and mod(realIndex, 10) == 1 then
                        button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -10)
                        aboveButton = button
                    else
                        button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -7, 0)
                    end
                    previousButton = button

                end
            end

            local rows = ceil((buffCounter+offset)/10)
            local height = 32*rows + 10*rows + 30*min(1,rows)
            buffFrameHeight = height

            if DebuffButton1 and SUIDB.combineBuffsAndDebuffs then
                updateDebuffAnchors("DebuffButton", 1)
            end
        end

        local bf = CreateFrame("Frame", "rBFS_BuffDragFrame", UIParent)
        bf:SetSize(32, 32)
        bf:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -35, 0)

        if not SUIDB.combineBuffsAndDebuffs then
            local df = CreateFrame("Frame", "rBFS_DebuffDragFrame", UIParent)
            df:SetSize(34, 34)
            df:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -35, -125)
        end

        applySkin(TempEnchant1)
        applySkin(TempEnchant2)
        applySkin(TempEnchant3)

        TempEnchant1:ClearAllPoints()
        TempEnchant1:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)
        TempEnchant2:ClearAllPoints()
        TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -7, 0)
        TempEnchant3:ClearAllPoints()
        TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -7, 0)

        hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffAnchors)
        hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
    end
end