local Module = SUI:NewModule("UnitFrames.Auras");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes

    if (db) then
        local AURA_START_X = 5
        local AURA_START_Y = 28
        local LARGE_AURA_SIZE = db.buffs.size --	Default 21.
        local SMALL_AURA_SIZE = db.debuffs.size --	Default 17.
        local AURA_OFFSET_Y = 3
        local AURA_ROW_WIDTH = 122
        local NUM_TOT_AURA_ROWS = 2
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

        local function applySkin(b)
            if not b or (b and b.styled) then return end

            local name = b:GetName()
            if (name:match("Debuff")) then
                b.debuff = true
            else
                b.buff = true
            end

            local icon = _G[name .. "Icon"]
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            icon:SetDrawLayer("BACKGROUND", -8)
            b.icon = icon

            local border = _G[name .. "Border"] or b:CreateTexture(name .. "Border", "BACKGROUND", nil, -7)
            --gloss default color is black
            border:SetTexture([[Interface\Addons\SUI\Media\Textures\Core\gloss]])
            border:SetTexCoord(0, 1, 0, 1)
            border:SetDrawLayer("BACKGROUND", -7)
            if b.buff then
                border:SetVertexColor(0.4, 0.35, 0.35)
            end
            border:ClearAllPoints()
            border:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
            border:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
            b.border = border

            local back = CreateFrame("Frame", nil, b, "BackdropTemplate")
            back:SetPoint("TOPLEFT", b, "TOPLEFT", -4, 4)
            back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
            back:SetFrameLevel(b:GetFrameLevel() - 1)
            back:SetBackdrop(backdrop)
            back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
            b.bg = back

            b.styled = true
        end

        if (SUI:Color()) then
            hooksecurefunc("TargetFrame_UpdateAuras", function(self)
                for i = 1, MAX_TARGET_BUFFS do
                    b = _G["TargetFrameBuff" .. i]
                    applySkin(b)
                end
                for i = 1, MAX_TARGET_DEBUFFS do
                    b = _G["TargetFrameDebuff" .. i]
                    applySkin(b)
                end
                for i = 1, MAX_TARGET_BUFFS do
                    b = _G["FocusFrameBuff" .. i]
                    applySkin(b)
                end
                for i = 1, MAX_TARGET_DEBUFFS do
                    b = _G["FocusFrameDebuff" .. i]
                    applySkin(b)
                end
            end)
        end


        function SUIAuraResize(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth,
                               offsetX, mirrorAurasVertically)
            local size;
            local offsetY = AURA_OFFSET_Y;
            local rowWidth = 0;
            local firstBuffOnRow = 1;
            for i = 1, numAuras do
                if (largeAuraList[i]) then
                    size = LARGE_AURA_SIZE;
                    offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y;
                else
                    size = SMALL_AURA_SIZE;
                end
                if (i == 1) then
                    rowWidth = size;
                    self.auraRows = self.auraRows + 1;
                else
                    rowWidth = rowWidth + size + offsetX;
                end
                if (rowWidth > maxRowWidth) then
                    updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY,
                        mirrorAurasVertically);
                    rowWidth = size;
                    self.auraRows = self.auraRows + 1;
                    firstBuffOnRow = i;
                    offsetY = AURA_OFFSET_Y;
                    if (self.auraRows > NUM_TOT_AURA_ROWS) then
                        maxRowWidth = AURA_ROW_WIDTH;
                    end
                else
                    updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically);
                end
            end
        end

        hooksecurefunc("TargetFrame_UpdateAuraPositions", SUIAuraResize)

        --BUFF ANCHOR
        function SUIBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
            local point, relativePoint
            local startY, auraOffsetY

            if (mirrorVertically) then
                point = "BOTTOM"
                relativePoint = "TOP"
                startY = -6
                offsetY = -offsetY
                auraOffsetY = -AURA_OFFSET_Y
            else
                point = "TOP"
                relativePoint = "BOTTOM"
                startY = AURA_START_Y
                auraOffsetY = AURA_OFFSET_Y
            end

            local buff = _G[buffName .. index]
            if (index == 1) then
                if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
                    buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY)
                else
                    buff:SetPoint(point .. "LEFT", self.debuffs, relativePoint .. "LEFT", 0, -offsetY)
                end
                self.buffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
                self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
                self.spellbarAnchor = buff
            elseif (anchorIndex ~= (index - 1)) then
                buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
                self.buffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
                self.spellbarAnchor = buff
            else
                buff:SetPoint(point .. "LEFT", _G[buffName .. anchorIndex], point .. "RIGHT", offsetX, 0)
            end
        end

        hooksecurefunc("TargetFrame_UpdateBuffAnchor", SUIBuffAnchor)

        --DEBUFF ANCHOR
        function SUIDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
            local buff = _G[debuffName .. index]
            local isFriend = UnitIsFriend("player", self.unit)

            local point = "TOP"
            local relativePoint = "BOTTOM"
            local startY = AURA_START_Y
            local auraOffsetY = AURA_OFFSET_Y

            if (mirrorVertically) then
                point = "BOTTOM"
                relativePoint = "TOP"
                startY = -8
                offsetY = -offsetY
                auraOffsetY = -AURA_OFFSET_Y
            end

            if (index == 1) then
                if (isFriend and numBuffs > 0) then
                    buff:SetPoint(point .. "LEFT", self.buffs, relativePoint .. "LEFT", 0, -offsetY)
                else
                    buff:SetPoint(point .. "LEFT", self, relativePoint .. "LEFT", AURA_START_X, startY)
                end
                self.debuffs:SetPoint(point .. "LEFT", buff, point .. "LEFT", 0, 0)
                self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
                if ((isFriend) or (not isFriend and numBuffs == 0)) then
                    self.spellbarAnchor = buff
                end
            elseif (anchorIndex ~= (index - 1)) then
                buff:SetPoint(point .. "LEFT", _G[debuffName .. anchorIndex], relativePoint .. "LEFT", 0, -offsetY)
                self.debuffs:SetPoint(relativePoint .. "LEFT", buff, relativePoint .. "LEFT", 0, -auraOffsetY)
                if ((isFriend) or (not isFriend and numBuffs == 0)) then
                    self.spellbarAnchor = buff
                end
            else
                buff:SetPoint(point .. "LEFT", _G[debuffName .. (index - 1)], point .. "RIGHT", offsetX, 0)
            end
        end

        hooksecurefunc("TargetFrame_UpdateDebuffAnchor", SUIDebuffAnchor)
    end
end
