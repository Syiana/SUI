local Module = SUI:NewModule("Skins.ClassTrainer");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_TrainerUI" then
        SUI:Skin(ClassTrainerFrame)
        SUI:Skin(ClassTrainerTrainButton)
        SUI:Skin(ClassTrainerCancelButton)
      end
    end)
  end
end