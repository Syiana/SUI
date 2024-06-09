local Module = SUI:NewModule("Skins.Dressup");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ 
            DressUpFrame.NineSlice.TopEdge,
            DressUpFrame.NineSlice.RightEdge,
            DressUpFrame.NineSlice.BottomEdge,
            DressUpFrame.NineSlice.LeftEdge,
            DressUpFrame.NineSlice.TopRightCorner,
            DressUpFrame.NineSlice.TopLeftCorner,
            DressUpFrame.NineSlice.BottomLeftCorner,
            DressUpFrame.NineSlice.BottomRightCorner,
            DressUpFrameInset.NineSlice.BottomEdge,
            DressUpFrame.OutfitDetailsPanel.BlackBackground,
            DressUpFrame.OutfitDetailsPanel.ClassBackground
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            DressUpFrame.Bg,
            DressUpFrame.TitleBg,
            DressUpFrameInset.Bg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            DressUpFrameInset.NineSlice.TopEdge,
            DressUpFrameInset.NineSlice.TopRightCorner,
            DressUpFrameInset.NineSlice.RightEdge,
            DressUpFrameInset.NineSlice.BottomRightCorner,
            DressUpFrameInset.NineSlice.BottomEdge,
            DressUpFrameInset.NineSlice.BottomLeftCorner,
            DressUpFrameInset.NineSlice.LeftEdge,
            DressUpFrameInset.NineSlice.TopLeftCorner
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
