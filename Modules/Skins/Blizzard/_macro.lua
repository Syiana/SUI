local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_MacroUI" then
        for i, v in pairs({ MacroFrame.NineSlice.TopEdge,
          MacroFrame.NineSlice.RightEdge,
          MacroFrame.NineSlice.BottomEdge,
          MacroFrame.NineSlice.LeftEdge,
          MacroFrame.NineSlice.TopRightCorner,
          MacroFrame.NineSlice.TopLeftCorner,
          MacroFrame.NineSlice.BottomLeftCorner,
          MacroFrame.NineSlice.BottomRightCorner }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
          MacroFrameInset.NineSlice.TopEdge,
          MacroFrameInset.NineSlice.TopRightCorner,
          MacroFrameInset.NineSlice.RightEdge,
          MacroFrameInset.NineSlice.BottomRightCorner,
          MacroFrameInset.NineSlice.BottomEdge,
          MacroFrameInset.NineSlice.BottomLeftCorner,
          MacroFrameInset.NineSlice.LeftEdge,
          MacroFrameInset.NineSlice.TopLeftCorner, }) do
            v:SetVertexColor(unpack(SUI:Color()))
        end
        for i, v in pairs({
          MacroFrame.Bg,
          MacroFrame.TitleBg }) do
            v:SetVertexColor(unpack(SUI:Color()))
        end
        for i, v in pairs({
          MacroButtonScrollFrameTop,
          MacroButtonScrollFrameMiddle,
          MacroButtonScrollFrameBottom,
          MacroButtonScrollFrameScrollBarThumbTexture,
          MacroButtonScrollFrameScrollBarScrollUpButton.Normal,
          MacroButtonScrollFrameScrollBarScrollDownButton.Normal,
          MacroButtonScrollFrameScrollBarScrollUpButton.Disabled,
          MacroButtonScrollFrameScrollBarScrollDownButton.Disabled,
          }) do
          v:SetVertexColor(unpack(SUI:Color()))
        end
        MacroHorizontalBarLeft:Hide();
        --fix
        --_G.select(2, MacroFrame:GetRegions()):Hide()
      end
    end)
  end
end