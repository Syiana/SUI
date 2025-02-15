local Module = SUI:NewModule("Skins.TradeSkill");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TradeSkillUI" then
                SUI:Skin(TradeSkillFrame)
                SUI:Skin(TradeSkillFrame.NineSlice)
            end
        end)
    end
end
