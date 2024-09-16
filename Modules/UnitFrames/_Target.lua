local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        theme = SUI.db.profile.general.theme
    }

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

    -- Hooks

    hooksecurefunc(TargetFrame, "OnEvent", function(self)
        -- Set Health Texture
        if db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        -- Recolor Reputation Bar
        if (SUI:Color()) then
            SUIColorRepBar(self)
        end

        -- Style Buffs & Debuffs
        for aura, _ in self.auraPools:EnumerateActive() do
            UpdateFrameAuras(aura)
        end
    end)

    hooksecurefunc(FocusFrame, "OnEvent", function(self)
        -- Set Health Texture
        if db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end

        -- Recolor Reputation Bar
        if (SUI:Color()) then
            SUIColorRepBar(self)
        end

        -- Style Buffs & Debuffs
        for aura, _ in self.auraPools:EnumerateActive() do
            UpdateFrameAuras(aura)
        end
    end)

    hooksecurefunc(TargetFrameToT, "Update", function(self)
        -- Set Health Texture
        if db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end
    end)

    hooksecurefunc(FocusFrameToT, "Update", function(self)
        -- Set Health Texture
        if db.texture ~= [[Interface\Default]] then
            healthTexture(self)
        end
    end)

    -- Set TargetFrame Buff/Debuff SetSize
    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, buff)
        buff:SetSize(db.unitframes.buffs.size, db.unitframes.buffs.size)

        if buff.Count then
            local fontSize = db.unitframes.buffs.size / 2.75
            buff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            buff.Count:ClearAllPoints()
            buff.Count:SetPoint("BOTTOMRIGHT", buff, "BOTTOMRIGHT", 2, 0)
        end
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, debuff)
        debuff:SetSize(db.unitframes.debuffs.size, db.unitframes.debuffs.size)

        if debuff.Count then
            local fontSize = db.unitframes.debuffs.size / 2.75
            debuff.Count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            debuff.Count:ClearAllPoints()
            debuff.Count:SetPoint("BOTTOMRIGHT", debuff, "BOTTOMRIGHT", 2, 0)
        end
    end)
end
