local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      AddonList.NineSlice.TopEdge,
      AddonList.NineSlice.RightEdge,
      AddonList.NineSlice.BottomEdge,
      AddonList.NineSlice.LeftEdge,
      AddonList.NineSlice.TopRightCorner,
      AddonList.NineSlice.TopLeftCorner,
      AddonList.NineSlice.BottomLeftCorner,
      AddonList.NineSlice.BottomRightCorner, }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      AddonListInset.NineSlice.TopEdge,
      AddonListInset.NineSlice.TopRightCorner,
      AddonListInset.NineSlice.RightEdge,
      AddonListInset.NineSlice.BottomRightCorner,
      AddonListInset.NineSlice.BottomEdge,
      AddonListInset.NineSlice.BottomLeftCorner,
      AddonListInset.NineSlice.LeftEdge,
      AddonListInset.NineSlice.TopLeftCorner, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    for i, v in pairs({
      AddonListBg,
      AddonList.TitleBg, }) do
        v:SetVertexColor(.3, .3, .3)
    end
    -- for i, v in pairs({
    --   AddonListScrollFrameScrollBarTop,
    --   AddonListScrollFrameScrollBarMiddle,
    --   AddonListScrollFrameScrollBarBottom,
    --   AddonListScrollFrameScrollBarThumbTexture,
    --   AddonListScrollFrameScrollBarScrollUpButton.Normal,
    --   AddonListScrollFrameScrollBarScrollDownButton.Normal,
    --   AddonListScrollFrameScrollBarScrollUpButton.Disabled,
    --   AddonListScrollFrameScrollBarScrollDownButton.Disabled,

    -- }) do
    --   v:SetVertexColor(.4, .4, .4)
    -- end
  end
end