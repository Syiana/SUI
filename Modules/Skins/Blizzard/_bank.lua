local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ BankFrame.NineSlice.TopEdge,
            BankFrame.NineSlice.RightEdge,
            BankFrame.NineSlice.BottomEdge,
            BankFrame.NineSlice.LeftEdge,
            BankFrame.NineSlice.TopRightCorner,
            BankFrame.NineSlice.TopLeftCorner,
            BankFrame.NineSlice.BottomLeftCorner,
            BankFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
            BankFrame.Bg,
            BankFrame.TitleBg
        }) do
            v:SetVertexColor(.3, .3, .3)
        end
    end
end
