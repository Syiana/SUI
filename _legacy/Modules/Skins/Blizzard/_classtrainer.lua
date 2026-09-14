local Module = SUI:NewModule("Skins.ClassTrainer");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TrainerUI" then
                SUI:Skin(ClassTrainerFrame, true)
                SUI:Skin(ClassTrainerFrame.NineSlice, true)
                SUI:Skin(ClassTrainerFrameBottomInset.NineSlice, true)
                SUI:Skin(ClassTrainerFrameInset.NineSlice, true)
            end
        end)
    end
end
