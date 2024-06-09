local Module = SUI:NewModule("Skins.Map");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ WorldMapFrame.BorderFrame.NineSlice.TopEdge,
            WorldMapFrame.BorderFrame.NineSlice.TopEdge,
            WorldMapFrame.BorderFrame.NineSlice.TopEdge,
            WorldMapFrame.BorderFrame.NineSlice.TopRightCorner,
            WorldMapFrame.BorderFrame.NineSlice.RightEdge,
            WorldMapFrame.BorderFrame.NineSlice.BottomRightCorner,
            WorldMapFrame.BorderFrame.NineSlice.BottomEdge,
            WorldMapFrame.BorderFrame.NineSlice.BottomLeftCorner,
            WorldMapFrame.BorderFrame.NineSlice.LeftEdge,
            WorldMapFrame.BorderFrame.NineSlice.TopLeftCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            WorldMapFrame.NavBar.InsetBorderBottom,
            WorldMapFrame.NavBar.InsetBorderBottomLeft,
            WorldMapFrame.NavBar.InsetBorderBottomRight,
            WorldMapFrame.NavBar.InsetBorderLeft,
            WorldMapFrame.NavBar.InsetBorderRight,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            WorldMapFrame.BorderFrame.Bg,
            WorldMapFrame.BorderFrame.TitleBg,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
