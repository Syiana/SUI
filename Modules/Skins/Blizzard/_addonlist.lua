local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      AddonListTopEdge,
      AddonListRightEdge,
      AddonListBottomEdge,
      AddonListLeftEdge,
      AddonListTopRightCorner,
      AddonListTopLeftCorner,
      AddonListBottomLeftCorner,
      AddonListBottomRightCorner, }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      AddonListInsetTopEdge,
      AddonListInsetTopRightCorner,
      AddonListInsetRightEdge,
      AddonListInsetBottomRightCorner,
      AddonListInsetBottomEdge,
      AddonListInsetBottomLeftCorner,
      AddonListInsetLeftEdge,
      AddonListInsetTopLeftCorner, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      AddonListBg,
      AddonList.TitleBg, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      AddonListScrollFrameScrollBarTop,
      AddonListScrollFrameScrollBarMiddle,
      AddonListScrollFrameScrollBarBottom,
      AddonListScrollFrameScrollBarThumbTexture,
      AddonListScrollFrameScrollBarScrollUpButton.Normal,
      AddonListScrollFrameScrollBarScrollDownButton.Normal,
      AddonListScrollFrameScrollBarScrollUpButton.Disabled,
      AddonListScrollFrameScrollBarScrollDownButton.Disabled,

    }) do
      v:SetVertexColor(.4, .4, .4)
    end
  end
end