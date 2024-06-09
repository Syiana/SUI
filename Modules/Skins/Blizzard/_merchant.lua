local Module = SUI:NewModule("Skins.Merchant");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ MerchantFrame.NineSlice.TopEdge,
            MerchantFrame.NineSlice.RightEdge,
            MerchantFrame.NineSlice.BottomEdge,
            MerchantFrame.NineSlice.LeftEdge,
            MerchantFrame.NineSlice.TopRightCorner,
            MerchantFrame.NineSlice.TopLeftCorner,
            MerchantFrame.NineSlice.BottomLeftCorner,
            MerchantFrame.NineSlice.BottomRightCorner,
            StackSplitFrame.SingleItemSplitBackground,
            MerchantFrameTab1.Left,
            MerchantFrameTab1.Middle,
            MerchantFrameTab1.Right,
            MerchantFrameTab1.LeftActive,
            MerchantFrameTab1.MiddleActive,
            MerchantFrameTab1.RightActive,
            MerchantFrameTab1.LeftHighlight,
            MerchantFrameTab1.MiddleHighlight,
            MerchantFrameTab1.RightHighlight,
            MerchantFrameTab2.Left,
            MerchantFrameTab2.Middle,
            MerchantFrameTab2.Right,
            MerchantFrameTab2.LeftActive,
            MerchantFrameTab2.MiddleActive,
            MerchantFrameTab2.RightActive,
            MerchantFrameTab2.LeftHighlight,
            MerchantFrameTab2.MiddleHighlight,
            MerchantFrameTab2.RightHighlight,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            MerchantFrame.Bg,
            MerchantFrame.TitleBg,
            MerchantFrameInset.Bg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
