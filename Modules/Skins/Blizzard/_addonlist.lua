local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      AddonListBg,
      AddonList.TitleBg,
      AddonListTopBorder,
      AddonListRightBorder,
      AddonListLeftBorder,
      AddonListBottomBorder,
      AddonListTopLeftCorner,
      AddonListTopRightCorner,
      AddonListBotLeftCorner,
      AddonListBotRightCorner,
      AddonListBtnCornerLeft,
      AddonListBtnCornerRight,
      AddonListInsetInsetLeftBorder,
      AddonListInsetInsetRightBorder,
      AddonListInsetInsetTopBorder,
      AddonListInsetInsetBottomBorder,
      AddonListInsetInsetTopLeftCorner,
      AddonListInsetInsetTopRightCorner,
      AddonListInsetInsetBotLeftCorner,
      AddonListInsetInsetBotRightCorner,
      AddonListScrollFrameScrollBarTop,
      AddonListScrollFrameScrollBarMiddle,
      AddonListScrollFrameScrollBarBottom,
      AddonListBg,
      AddonListButtonBottomBorder,
      AddonListEnableAllButton_RightSeparator,
      AddonListDisableAllButton_RightSeparator,
      AddonListOkayButton_LeftSeparator,
      AddonListCancelButton_LeftSeparator
    }) do
        v:SetVertexColor(.15, .15, .15)
    end
  end
end