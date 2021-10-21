local Module = SUI:NewModule("Skins.Challenges");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_ChallengesUI" then
        for i, v in pairs({
          ChallengesFrameInset.NineSlice.TopEdge,
          ChallengesFrameInset.NineSlice.TopRightCorner,
          ChallengesFrameInset.NineSlice.RightEdge,
          ChallengesFrameInset.NineSlice.BottomRightCorner,
          ChallengesFrameInset.NineSlice.BottomEdge,
          ChallengesFrameInset.NineSlice.BottomLeftCorner,
          ChallengesFrameInset.NineSlice.LeftEdge,
          ChallengesFrameInset.NineSlice.TopLeftCorner,}) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end