local Module = SUI:NewModule("UnitFrames.Target");

function Module:OnEnable()

    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        theme = SUI.db.profile.general.theme
    }

    -- Set Target/Focus Textures
    if db.texture ~= [[Interface\Default]] then
        local function updateTextures(self)
            -- Target/Focus
            -- Get Power Color
            local powerColor = GetPowerBarColor(self.manabar.powerType)

            -- Set Textures
            self.healthbar:SetStatusBarTexture(db.texture)
            self.healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
            self.myHealPredictionBar:SetTexture(db.texture)
            self.manabar.texture:SetTexture(db.texture)
            if self.manabar.powerType == 0 then
                self.manabar:SetStatusBarColor(0, 0.5, 1)
            else
                self.manabar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
            end

            -- Target of Target
            -- Get Power Color
            local totPowerColor = GetPowerBarColor(self.totFrame.manabar.powerType)

            -- Set Textures
            self.totFrame.healthbar:SetStatusBarTexture(db.texture)
            self.totFrame.manabar.texture:SetTexture(db.texture)
            if self.totFrame.manabar.powerType == 0 then
                self.totFrame.manabar:SetStatusBarColor(0, 0.5, 1)
            else
                self.totFrame.manabar:SetStatusBarColor(totPowerColor.r, totPowerColor.g, totPowerColor.b)
            end
        end

        hooksecurefunc(TargetFrame, "Update", function(self)
            updateTextures(self)
        end)

        hooksecurefunc(FocusFrame, "Update", function(self)
            updateTextures(self)
        end)
    end

    local hooked = {}
    local function UpdateFrameAuras(pool)
        if db.theme ~= 'Blizzard' then
            for frame, _ in pairs(pool.activeObjects) do
                if not hooked[frame] then
                    hooked[frame] = true

                    local icon = frame.Icon
                    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                    icon:SetDrawLayer("BACKGROUND", -8)

                    if not frame.border then
                        local border = frame.border or
                            frame:CreateTexture(frame.border, "BACKGROUND", nil, -7)

                        border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
                        border:SetTexCoord(0, 1, 0, 1)
                        border:SetDrawLayer("BACKGROUND", -7)
                        border:ClearAllPoints()
                        border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
                        border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
                        frame.border = border

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
                        local back = CreateFrame("Frame", nil, frame, "BackdropTemplate")
                        back:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 4)
                        back:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
                        back:SetFrameLevel(frame:GetFrameLevel() - 1)
                        back:SetBackdrop(backdrop)
                        back:SetBackdropBorderColor(unpack(SUI:Color(0.25, 0.9)))
                        frame.bg = back
                    end
                end
            end
        end
    end

    for poolKey, pool in pairs(TargetFrame.auraPools.pools) do
        hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
    end

    for poolKey, pool in pairs(FocusFrame.auraPools.pools) do
        hooksecurefunc(pool, "Acquire", UpdateFrameAuras)
    end

    local function SUIColorRepBar(self)
        if (SUI:Color()) then
            local reputationBar = self.TargetFrameContent.TargetFrameContentMain.ReputationColor
            reputationBar:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end

    -- On Update Target Frame
    hooksecurefunc(TargetFrame, "Update", SUIColorRepBar)

    -- On Update Focus Frame
    hooksecurefunc(FocusFrame, "Update", SUIColorRepBar)

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
