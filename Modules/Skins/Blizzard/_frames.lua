local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in ipairs({
      GameMenuFrame.TopEdge,
      GameMenuFrame.RightEdge,
      GameMenuFrame.BottomEdge,
      GameMenuFrame.LeftEdge,
      GameMenuFrame.TopRightCorner,
      GameMenuFrame.TopLeftCorner,
      GameMenuFrame.BottomLeftCorner,
      GameMenuFrame.BottomRightCorner,
      StaticPopup1.TopEdge,
      StaticPopup1.RightEdge,
      StaticPopup1.BottomEdge,
      StaticPopup1.LeftEdge,
      StaticPopup1.TopRightCorner,
      StaticPopup1.TopLeftCorner,
      StaticPopup1.BottomLeftCorner,
      StaticPopup1.BottomRightCorner
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
  end
end