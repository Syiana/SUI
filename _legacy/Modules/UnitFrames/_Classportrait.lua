local Module = SUI:NewModule("Misc.Classportrait");

function Module:OnEnable()
    local db = SUI.db.profile.unitframes.portrait
    if (db == 'ClassIcon') then
        local TEXTURE_NAME = "Interface\\AddOns\\SUI\\Media\\Textures\\ClassPortraits\\%s.tga"
        hooksecurefunc("UnitFramePortrait_Update", function(self)
            if self.portrait then
                if UnitIsPlayer(self.unit) then
                    local _, class = UnitClass(self.unit)
                    if class then
                        self.portrait:SetTexture(TEXTURE_NAME:format(class))
                    end
                end
            end
        end)
    end
end
