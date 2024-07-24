local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            BankFrameTab1.Left,
            BankFrameTab1.Middle,
            BankFrameTab1.Right,
            BankFrameTab1.LeftActive,
            BankFrameTab1.MiddleActive,
            BankFrameTab1.RightActive,
            BankFrameTab1.LeftHighlight,
            BankFrameTab1.MiddleHighlight,
            BankFrameTab1.RightHighlight,
            BankFrameTab2.Left,
            BankFrameTab2.Middle,
            BankFrameTab2.Right,
            BankFrameTab2.LeftActive,
            BankFrameTab2.MiddleActive,
            BankFrameTab2.RightActive,
            BankFrameTab2.LeftHighlight,
            BankFrameTab2.MiddleHighlight,
            BankFrameTab2.RightHighlight,
            BankFrameTab3.Left,
            BankFrameTab3.Middle,
            BankFrameTab3.Right,
            BankFrameTab3.LeftActive,
            BankFrameTab3.MiddleActive,
            BankFrameTab3.RightActive,
            BankFrameTab3.LeftHighlight,
            BankFrameTab3.MiddleHighlight,
            BankFrameTab3.RightHighlight,
            BankFrame.NineSlice.TopEdge,
            BankFrame.NineSlice.RightEdge,
            BankFrame.NineSlice.BottomEdge,
            BankFrame.NineSlice.LeftEdge,
            BankFrame.NineSlice.TopRightCorner,
            BankFrame.NineSlice.TopLeftCorner,
            BankFrame.NineSlice.BottomLeftCorner,
            BankFrame.NineSlice.BottomRightCorner,
            BankFrame.Background,
            BankFrameMoneyFrameBorderLeft,
            BankFrameMoneyFrameBorderMiddle,
            BankFrameMoneyFrameBorderRight,
            BankFrameBg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            BankFrame.Bg,
            BankFrame.TitleBg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
