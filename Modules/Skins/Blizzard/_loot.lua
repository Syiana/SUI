local Module = SUI:NewModule("Skins.Loot");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            LootFrame.NineSlice.TopEdge,
            LootFrame.NineSlice.RightEdge,
            LootFrame.NineSlice.BottomEdge,
            LootFrame.NineSlice.LeftEdge,
            LootFrame.NineSlice.TopRightCorner,
            LootFrame.NineSlice.TopLeftCorner,
            LootFrame.NineSlice.BottomLeftCorner,
            LootFrame.NineSlice.BottomRightCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
