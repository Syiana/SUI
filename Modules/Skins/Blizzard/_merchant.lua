local Module = SUI:NewModule("Skins.Merchant");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      MerchantFrameTopEdge,
      MerchantFrameRightEdge,
      MerchantFrameBottomEdge,
      MerchantFrameLeftEdge,
      MerchantFrameTopRightCorner,
      MerchantFrameTopLeftCorner,
      MerchantFrameBottomLeftCorner,
      MerchantFrameBottomRightCorner,
      StackSplitFrameSingleItemSplitBackground,
    }) do
      v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      MerchantFrameBg,
      MerchantFrameTitleBg,
      MerchantFrameInsetBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end