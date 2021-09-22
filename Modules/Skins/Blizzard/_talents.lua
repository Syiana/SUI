local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
  local f = CreateFrame("Frame")
  f:RegisterEvent("ADDON_LOADED")
  f:SetScript("OnEvent", function(self, event, name)
    if name == "Blizzard_TalentUI" then
      for i, v in pairs({
        PlayerTalentFrame.NineSlice.TopEdge,
        PlayerTalentFrame.NineSlice.RightEdge,
        PlayerTalentFrame.NineSlice.BottomEdge,
        PlayerTalentFrame.NineSlice.LeftEdge,
        PlayerTalentFrame.NineSlice.TopRightCorner,
        PlayerTalentFrame.NineSlice.TopLeftCorner,
        PlayerTalentFrame.NineSlice.BottomLeftCorner,
        PlayerTalentFrame.NineSlice.BottomRightCorner,
        PlayerTalentFrame.NineSlice.BottomEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.RightEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.LeftEdge,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopRightCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.TopLeftCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomLeftCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomRightCorner,
        PlayerTalentFrameTalentsPvpTalentFrameTalentList.NineSlice.BottomEdge, }) do
          v:SetVertexColor(.15, .15, .15)
      end
      for i, v in pairs({
      PlayerTalentFrameInset.NineSlice.RightEdge,
      PlayerTalentFrameInset.NineSlice.BottomEdge,
      PlayerTalentFrameInset.NineSlice.LeftEdge,
      PlayerTalentFrameInset.NineSlice.TopRightCorner,
      PlayerTalentFrameInset.NineSlice.TopLeftCorner,
      PlayerTalentFrameInset.NineSlice.BottomLeftCorner,
      PlayerTalentFrameInset.NineSlice.BottomRightCorner,
      PlayerTalentFrameInset.NineSlice.BottomEdge,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopEdge,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.RightEdge,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomEdge,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.LeftEdge,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopRightCorner,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.TopLeftCorner,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomLeftCorner,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomRightCorner,
      PlayerTalentFrameTalentsPvpTalentFrameTalentList.Inset.NineSlice.BottomEdge, }) do
        v:SetVertexColor(.3, .3, .3)
      end
      for i, v in pairs({
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarThumbTexture,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarTop,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarMiddle,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarBottom,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollUpButton.Normal,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollDownButton.Normal,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollUpButton.Disabled,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarScrollDownButton.Disabled }) do
        v:SetVertexColor(.4, .4, .4)
      end
      for i, v in pairs({
        PVEFrameTopFiligree,
        PVEFrameBottomFiligree,
        PVEFrameBlueBg,
        LFGListFrame.CategorySelection.Inset.CustomBG }) do
          v:SetVertexColor(.5, .5, .5)
      end
      for i, v in pairs({
        PlayerTalentFrame.Bg,
        PlayerTalentFrame.TitleBg,
        PlayerTalentFrameInset.Bg,
        PlayerTalentFrameTalentsPvpTalentFrameTalentListBg }) do
          v:SetVertexColor(.3, .3, .3)
      end
      for i, v in pairs({
        PlayerTalentFrameTalents.bg }) do
          v:SetVertexColor(.5, .5, .5)
      end
      _G.select(1, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.4, .4, .4)
      _G.select(5, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.5, .5, .5)
      _G.select(6, PlayerTalentFrameSpecialization:GetRegions()):SetVertexColor(.5, .5, .5)
    end
  end)
end