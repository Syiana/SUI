local Module = SUI:NewModule("UnitFrames.Party");

function Module:OnEnable()
    local db = {
        unitframes = SUI.db.profile.unitframes,
        texture = SUI.db.profile.general.texture,
        module = SUI.db.profile.modules.unitframes
    }

    local textureSet = {}

    function SUIPartyFrames(self)
        local useCompact = GetCVarBool("useCompactPartyFrames")
        if (IsInGroup() and (not IsInRaid()) and (not useCompact)) then
            if ((self and self.healthbar and self.manabar) and (db.texture ~= 'Default')) then
                if (textureSet[self.unit]) then return end
                self.healthbar:SetStatusBarTexture(db.texture)
                self.manabar:SetStatusBarTexture(db.texture)

                textureSet[self.unit] = self.unit
            end
            if (db.unitframes.style == 'Big') then
                self.name:SetSize(75, 10)
                self.HealthBar:ClearAllPoints()
                self.HealthBar:SetPoint("TOPLEFT", 45, -13)
                self.HealthBar:SetHeight(12)
                self.ManaBar:ClearAllPoints()
                self.ManaBar:SetPoint("TOPLEFT", 45, -26)
                self.ManaBar:SetHeight(5)

                for i = 1, MAX_PARTY_MEMBERS do
                    local texture = _G["PartyMemberFrame" .. i .. "Texture"]
                    local flash = _G["PartyMemberFrame" .. i .. "Flash"]
                    local healthBarText = _G["PartyMemberFrame" .. i .. "HealthBarText"]
                    local manaBarText = _G["PartyMemberFrame" .. i .. "ManaBarText"]
                    local healthBarTextLeft = _G["PartyMemberFrame" .. i .. "HealthBarTextLeft"]
                    local healthBarTextRight = _G["PartyMemberFrame" .. i .. "HealthBarTextRight"]
                    local manaBarTextLeft = _G["PartyMemberFrame" .. i .. "ManaBarTextLeft"]
                    local manaBarTextRight = _G["PartyMemberFrame" .. i .. "ManaBarTextRight"]

                    if (texture and flash) then
                        texture:SetTexture([[Interface\Addons\SUI\Media\Textures\unitframes\UI-PartyFrame]])
                        flash:SetTexture([[Interface\Addons\SUI\Media\Textures\unitframes\UI-PARTYFRAME-FLASH]])
                    end

                    if (healthBarText and manaBarText) then
                        -- HealthBar Text
                        healthBarTextLeft:ClearAllPoints()
                        healthBarTextLeft:SetPoint("LEFT", self.HealthBar, "LEFT", 0, 0)
                        healthBarTextRight:ClearAllPoints()
                        healthBarTextRight:SetPoint("RIGHT", self.HealthBar, "RIGHT", 0, 0)
                        healthBarText:ClearAllPoints()
                        healthBarText:SetPoint("CENTER", self.HealthBar, "CENTER", 0, 0)

                        -- ManaBar Text
                        manaBarTextLeft:ClearAllPoints()
                        manaBarTextLeft:SetPoint("LEFT", self.ManaBar, "LEFT", 0, 0)
                        manaBarTextRight:ClearAllPoints()
                        manaBarTextRight:SetPoint("RIGHT", self.ManaBar, "RIGHT", 0, 0)
                        manaBarText:ClearAllPoints()
                        manaBarText:SetPoint("CENTER", self.ManaBar, "CENTER", 0, 0)
                    end
                end
            end
        end
    end

    if (db.module) then
        hooksecurefunc("PartyMemberFrame_OnUpdate", SUIPartyFrames)
    end
end
