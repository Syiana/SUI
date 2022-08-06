local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_MacroUI" then
        for i, v in pairs({
          MacroFrameTopEdge,
          MacroFrameRightEdge,
          MacroFrameBottomEdge,
          MacroFrameLeftEdge,
          MacroFrameTopRightCorner,
          MacroFrameTopLeftCorner,
          MacroFrameBottomLeftCorner,
          MacroFrameBottomRightCorner
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
          MacroFrameInsetTopEdge,
          MacroFrameInsetTopRightCorner,
          MacroFrameInsetRightEdge,
          MacroFrameInsetBottomRightCorner,
          MacroFrameInsetBottomEdge,
          MacroFrameInsetBottomLeftCorner,
          MacroFrameInsetLeftEdge,
          MacroFrameInsetTopLeftCorner, }) do
            v:SetVertexColor(unpack(SUI:Color()))
        end
        for i, v in pairs({
          MacroFrameBg,
          MacroFrameTitleBg
        }) do
            v:SetVertexColor(unpack(SUI:Color()))
        end
        for i, v in pairs({
          MacroButtonScrollFrameTop,
          MacroButtonScrollFrameMiddle,
          MacroButtonScrollFrameBottom,
          MacroButtonScrollFrameScrollBarThumbTexture,
          MacroButtonScrollFrameScrollBarScrollUpButtonNormal,
          MacroButtonScrollFrameScrollBarScrollDownButtonNormal,
          MacroButtonScrollFrameScrollBarScrollUpButtonDisabled,
          MacroButtonScrollFrameScrollBarScrollDownButtonDisabled,
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