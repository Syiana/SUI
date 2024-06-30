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
                SUI:Skin(ClassTrainerListScrollFrame)
                SUI:Skin(ClassTrainerDetailScrollFrame)
                SUI:Skin(ClassTrainerCollapseAllButton)
                SUI:Skin(ClassTrainerFrameFilterDropDown)

                -- Buttons
                SUI:Skin({
                    ClassTrainerTrainButton.Left,
                    ClassTrainerTrainButton.Middle,
                    ClassTrainerTrainButton.Right,
                    ClassTrainerCancelButton.Left,
                    ClassTrainerCancelButton.Middle,
                    ClassTrainerCancelButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
