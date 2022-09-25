local Module = SUI:NewModule("Skins.ClassTrainer");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_TrainerUI" then
        for i, v in pairs({ ClassTrainerFrameTopEdge,
          ClassTrainerFrameRightEdge,
          ClassTrainerFrameBottomEdge,
          ClassTrainerFrameLeftEdge,
          ClassTrainerFrameTopRightCorner,
          ClassTrainerFrameTopLeftCorner,
          ClassTrainerFrameBottomLeftCorner,
          ClassTrainerFrameBottomRightCorner }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          ClassTrainerFrame.Bg,
          ClassTrainerFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end