local Module = SUI:NewModule("Skins.Dungeon");

function Module:OnEnable()
  if (SUI:Color()) then
    local frames = {
      GameMenuFrame.Border.TopEdge,
      GameMenuFrame.Border.RightEdge,
      GameMenuFrame.Border.BottomEdge,
      GameMenuFrame.Border.LeftEdge,
      GameMenuFrame.Border.TopRightCorner,
      GameMenuFrame.Border.TopLeftCorner,
      GameMenuFrame.Border.BottomLeftCorner,
      GameMenuFrame.Border.BottomRightCorner,
      StaticPopup1.Border.TopEdge,
      StaticPopup1.Border.RightEdge,
      StaticPopup1.Border.BottomEdge,
      StaticPopup1.Border.LeftEdge,
      StaticPopup1.Border.TopRightCorner,
      StaticPopup1.Border.TopLeftCorner,
      StaticPopup1.Border.BottomLeftCorner,
      StaticPopup1.Border.BottomRightCorner
    } SUI:Skin(frames, color.secondary)
  end
end