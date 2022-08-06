local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_TalentUI" then
        for i, v in pairs({
          PlayerTalentFrameTopEdge,
          PlayerTalentFrameRightEdge,
          PlayerTalentFrameBottomEdge,
          PlayerTalentFrameLeftEdge,
          PlayerTalentFrameTopRightCorner,
          PlayerTalentFrameTopLeftCorner,
          PlayerTalentFrameBottomLeftCorner,
          PlayerTalentFrameBottomRightCorner,
          PlayerTalentFrameBottomEdge,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListTopEdge,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListRightEdge,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListBottomEdge,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListLeftEdge,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListTopRightCorner,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListTopLeftCorner,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListBottomLeftCorner,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListBottomRightCorner,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListBottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
        PlayerTalentFrameInsetRightEdge,
        PlayerTalentFrameInsetBottomEdge,
        PlayerTalentFrameInsetLeftEdge,
        PlayerTalentFrameInsetTopRightCorner,
        PlayerTalentFrameInsetTopLeftCorner,
        PlayerTalentFrameInsetBottomLeftCorner,
        PlayerTalentFrameInsetBottomRightCorner,
        PlayerTalentFrameInsetBottomEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetTopEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetRightEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetBottomEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetLeftEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetTopRightCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetTopLeftCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetBottomLeftCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetBottomRightCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListInsetBottomEdge, }) do
          v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          PVEFrameTopFiligree,
          PVEFrameBottomFiligree,
          PVEFrameBlueBg,
        }) do
        v:SetVertexColor(.5, .5, .5)
        end
        for i, v in pairs({
          PlayerTalentFrameBg,
          PlayerTalentFrameTitleBg,
          PlayerTalentFrameInsetBg,
          PlayerTalentFrameTalentsPvpTalentFrameTalentListBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          PlayerTalentFrameTalentsbg }) do
            v:SetVertexColor(.5, .5, .5)
        end
      end
    end)
  end
end