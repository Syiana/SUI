local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        theme = SUI.db.profile.general.theme
    }
    local isClassic = db.unitframes.style == "Classic"

    -- Set Target/Focus Textures
    local function healthTexture(self)
        if self:IsForbidden() then return end
        
        -- Set Textures
        self.healthbar:SetStatusBarTexture(db.texture)
        self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
        if self.myHealPrediction then
            self.myHealPredictionBar:SetTexture(db.texture)
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

    local function StyleTargetBuff(buff)
        buff:SetSize(db.unitframes.buffs.size, db.unitframes.buffs.size)
        OffsetAuraPosition(buff, db.unitframes.buffs.targetx or 0, db.unitframes.buffs.targety or 0)

        if buff.Count then
            buff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            buff.Count:ClearAllPoints()
            buff.Count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 2, 0)
        end
    end

    local function StyleTargetDebuff(debuff)
        debuff:SetSize(db.unitframes.debuffs.size, db.unitframes.debuffs.size)
        OffsetAuraPosition(debuff, db.unitframes.debuffs.targetx or 0, db.unitframes.debuffs.targety or 0)

        if debuff.Count then
            debuff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            debuff.Count:ClearAllPoints()
            debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 2, 0)
        end
    end

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
        for aura, _ in self.auraPools:EnumerateActive() do
            UpdateFrameAuras(aura)
        end
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
        for aura, _ in self.auraPools:EnumerateActive() do
            UpdateFrameAuras(aura)
        end
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
        if not frame or not frame.auraPools then
            return
        end

        for aura, _ in frame.auraPools:EnumerateActive() do
            UpdateFrameAuras(aura)

            if aura.Border then
                StyleTargetDebuff(aura)
            else
                StyleTargetBuff(aura)
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

    hooksecurefunc(TargetFrame, "UpdateAuras", RefreshFrameAuras)
    hooksecurefunc(FocusFrame, "UpdateAuras", RefreshFrameAuras)

    -- Set TargetFrame Buff/Debuff SetSize
    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, buff)
        CacheAuraAnchor(buff)
        StyleTargetBuff(buff)
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, debuff)
        CacheAuraAnchor(debuff)
        StyleTargetDebuff(debuff)
    end)
end
