local Buffs = SUI:NewModule("Buffs.Core");

function Buffs:OnEnable()
    local db = {
        buff = SUI.db.profile.buffs.buff,
        debuff = SUI.db.profile.buffs.debuff,
        fading = SUI.db.profile.buffs.fading,
        debufftype = SUI.db.profile.buffs.debufftype,
        module = SUI.db.profile.modules.buffs
    }

    if (db.module) then        
        -- DebuffType Colors for the Debuff Border
        local debuffColor      = {}
        debuffColor["none"]    = { r = 0.80, g = 0, b = 0 };
        debuffColor["Magic"]   = { r = 0.20, g = 0.60, b = 1.00 };
        debuffColor["Curse"]   = { r = 0.60, g = 0.00, b = 1.00 };
        debuffColor["Disease"] = { r = 0.60, g = 0.40, b = 0 };
        debuffColor["Poison"]  = { r = 0.00, g = 0.60, b = 0 };

        FONT = STANDARD_TEXT_FONT

        -- Prevent Buff Fading Animation
        if (db.fading) then
            BuffFrame:HookScript("OnUpdate", function(self)
                self.BuffAlphaValue = 1
            end)
        end

        --Buffs
        local bf = CreateFrame("Frame", "BuffDragFrame", UIParent)
        bf:SetSize(32, 32)
        bf:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -35, 0)

        --Debuffs
        local df = CreateFrame("Frame", "DebuffDragFrame", UIParent)
        df:SetSize(34, 34)
        df:SetPoint("TOPRIGHT", "Minimap", "TOPLEFT", -35, -125)

        -- Consodilated Buffs Icon
        ConsolidatedBuffs:ClearAllPoints()
        ConsolidatedBuffs:SetParent(BuffDragFrame)
        ConsolidatedBuffs:SetPoint("TOPRIGHT", BuffDragFrame, "TOPRIGHT", 40, -4)

        HOUR_ONELETTER_ABBR = "%dh"
        DAY_ONELETTER_ABBR = "%dd"
        MINUTE_ONELETTER_ABBR = "%dm"
        SECOND_ONELETTER_ABBR = "%ds"

        local backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 6,
            insets = { left = 6, right = 6, top = 6, bottom = 6 },
        }

        local settings

        local ceil, min, max = ceil, min, max
        local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame

        local buffFrameHeight = 0

        local function applySkin(b, debuffType)
            if not b then return end

            local color = false
            local name = b:GetName()
            local tempenchant, consolidated, debuff = false, false, false

            -- Get Debuff Color and set Debuff Color before we return on an already styled frame
            if (debuffType) then
                color = debuffColor[debuffType]

                local border = _G[name .. "Backdrop"]
                if (border and db.debufftype) then
                    border:SetBackdropBorderColor(color.r, color.g, color.b)
                end
            end

            if (b and b.styled) then return end

            if (name:match("TempEnchant")) then
                tempenchant = true
            elseif (name:match("Consolidated")) then
                consolidated = true
            elseif (name:match("Debuff")) then
                debuff = true
            end

            if debuff then
                settings = {
                    pos = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = -125 },
                    gap = 10,
                    userplaced = true,
                    rowSpacing = 10,
                    colSpacing = 7,
                    buttonsPerRow = db.debuff.icons,
                    button = {
                        size = db.debuff.size
                    },
                    icon = {
                        padding = -2
                    },
                    border = {
                        texture = [[Interface\Addons\SUI\Media\Textures\Core\gloss]],
                        color = { r = 0.4, g = 0.35, b = 0.35 },
                        classcolored = false
                    },
                    background = {
                        show = true,
                        edgeFile = [[Interface\Addons\SUI\Media\Textures\Core\outer_shadow]],
                        color = { r = 0, g = 0, b = 0, a = 0.9 },
                        classcolored = false,
                        inset = 6,
                        padding = 4
                    },
                    duration = {
                        font = STANDARD_TEXT_FONT,
                        size = 12,
                        pos = { a1 = "BOTTOM", x = 0, y = 0 }
                    },
                    count = {
                        font = STANDARD_TEXT_FONT,
                        size = 11,
                        pos = { a1 = "TOPRIGHT", x = 0, y = 0 }
                    }
                }
            else
                settings = {
                    pos = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
                    gap = 30,
                    userplaced = true,
                    rowSpacing = 10,
                    colSpacing = 7,
                    buttonsPerRow = db.buff.icons,
                    button = {
                        size = db.buff.size
                    },
                    icon = {
                        padding = -2
                    },
                    border = {
                        texture = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss",
                        color = { r = 0.4, g = 0.35, b = 0.35 },
                        classcolored = false
                    },
                    background = {
                        show = true,
                        edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
                        color = { r = 0, g = 0, b = 0, a = 0.9 },
                        classcolored = false,
                        inset = 6,
                        padding = 4
                    },
                    duration = {
                        font = STANDARD_TEXT_FONT,
                        size = 12,
                        pos = { a1 = "BOTTOM", x = 0, y = 0 }
                    },
                    count = {
                        font = STANDARD_TEXT_FONT,
                        size = 11,
                        pos = { a1 = "TOPRIGHT", x = 0, y = 0 }
                    }
                }
            end

            b:SetSize(settings.button.size, settings.button.size)


            if not (SUI:Color()) then return end
            local icon = _G[name .. "Icon"]
            if consolidated then
                if select(1, UnitFactionGroup("player")) == "Alliance" then
                    icon:SetTexture(select(3, GetSpellInfo(61573)))
                elseif select(1, UnitFactionGroup("player")) == "Horde" then
                    icon:SetTexture(select(3, GetSpellInfo(61574)))
                end
            end
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            icon:ClearAllPoints()
            icon:SetPoint("TOPLEFT", b, "TOPLEFT", -settings.icon.padding, settings.icon.padding)
            icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", settings.icon.padding, -settings.icon.padding)
            icon:SetDrawLayer("BACKGROUND", -8)
            b.icon = icon

            local border = _G[name .. "Border"] or b:CreateTexture(name .. "Border", "BACKGROUND", nil, -7)
            border:SetTexture(settings.border.texture)
            border:SetTexCoord(0, 1, 0, 1)
            border:SetDrawLayer("BACKGROUND", -7)
            if tempenchant then
                border:SetVertexColor(0.7, 0, 1)
            elseif not debuff then
                border:SetVertexColor(settings.border.color.r, settings.border.color.g, settings.border.color.b)
            end
            border:ClearAllPoints()
            border:SetAllPoints(b)
            b.border = border

            b.duration:SetFont(FONT, settings.duration.size, "THINOUTLINE")
            b.duration:ClearAllPoints()
            b.duration:SetPoint(settings.duration.pos.a1, settings.duration.pos.x, settings.duration.pos.y)

            b.count:SetFont(settings.count.font, settings.count.size, "THINOUTLINE")
            b.count:ClearAllPoints()
            b.count:SetPoint(settings.count.pos.a1, settings.count.pos.x, settings.count.pos.y)

            if settings.background.show then
                local back = _G[name .. "Backdrop"] or CreateFrame("Frame", name .. "Backdrop", b, "BackdropTemplate")
                back:SetPoint("TOPLEFT", b, "TOPLEFT", -settings.background.padding, settings.background.padding)
                back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", settings.background.padding, -settings.background.padding)
                back:SetFrameLevel(b:GetFrameLevel() - 1)
                back:SetBackdrop(backdrop)

                -- Set Debuff Color
                if (db.debufftype and color) then
                    back:SetBackdropBorderColor(color.r, color.g, color.b)
                else
                    back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
                end
                b.bg = back
            end

            b.styled = true
        end

        local function updateDebuffAnchors(buttonName, index)
            local button = _G[buttonName .. index]
            if not button then return end

            -- Get Button Name and Debuff Type
            local name = button:GetName()
            local debuffType = select(4, UnitDebuff("player", index))

            if name:match("Debuff") then applySkin(button, debuffType or "none") end
            button:ClearAllPoints()
            if index == 1 then
                button:SetPoint("TOPRIGHT", DebuffDragFrame, "TOPRIGHT", 0, 0)
            elseif index > 1 and mod(index, settings.buttonsPerRow) == 1 then
                button:SetPoint("TOPRIGHT", _G[buttonName .. (index - settings.buttonsPerRow)], "BOTTOMRIGHT", 0,
                    -settings.rowSpacing)
            else
                button:SetPoint("TOPRIGHT", _G[buttonName .. (index - 1)], "TOPLEFT", -settings.colSpacing, 0)
            end
        end

        local function updateAllBuffAnchors()
            local buttonName  = "BuffButton"
            local numEnchants = BuffFrame.numEnchants
            local numBuffs    = BUFF_ACTUAL_DISPLAY
            local offset      = numEnchants
            local realIndex, previousButton, aboveButton

            TempEnchant1:ClearAllPoints()
            TempEnchant1:SetPoint("TOPRIGHT", BuffDragFrame, "TOPRIGHT", 0, 0)

            if BuffFrame.numEnchants > 0 then
                previousButton = _G["TempEnchant" .. numEnchants]
            end

            if numEnchants > 0 then aboveButton = TempEnchant1 end
            local buffCounter = 0
            for index = 1, numBuffs do
                local button = _G[buttonName .. index]
                if not button then return end
                if not button.consolidated then
                    button.BuffFrameFlashState = 0
                    buffCounter = buffCounter + 1
                    if not button.styled then applySkin(button) end
                    button:ClearAllPoints()
                    realIndex = buffCounter + offset
                    if realIndex == 1 then
                        button:SetPoint("TOPRIGHT", BuffDragFrame, "TOPRIGHT", 0, 0)
                        aboveButton = button
                    elseif realIndex > 1 and mod(realIndex, settings.buttonsPerRow) == 1 then
                        button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -10)
                        aboveButton = button
                    else
                        button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -7, 0)
                    end
                    previousButton = button
                end
            end
            local rows = ceil((buffCounter + offset) / settings.buttonsPerRow)
            local height = settings.button.size * rows + 10 * rows + settings.gap * min(1, rows)
            buffFrameHeight = height
        end

        applySkin(TempEnchant1)
        applySkin(TempEnchant2)
        applySkin(TempEnchant3)

        TempEnchant1:ClearAllPoints()
        TempEnchant1:SetPoint("TOPRIGHT", BuffDragFrame, "TOPRIGHT", 0, 0)
        TempEnchant2:ClearAllPoints()
        TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -7, 0)
        TempEnchant3:ClearAllPoints()
        TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -7, 0)

        hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffAnchors)
        hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
    end
end
