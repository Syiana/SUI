local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ GuildRegistrarFrame.NineSlice.TopEdge,
            GuildRegistrarFrame.NineSlice.RightEdge,
            GuildRegistrarFrame.NineSlice.BottomEdge,
            GuildRegistrarFrame.NineSlice.LeftEdge,
            GuildRegistrarFrame.NineSlice.TopRightCorner,
            GuildRegistrarFrame.NineSlice.TopLeftCorner,
            GuildRegistrarFrame.NineSlice.BottomLeftCorner,
            GuildRegistrarFrame.NineSlice.BottomRightCorner,
            TabardFrame.NineSlice.TopEdge,
            TabardFrame.NineSlice.RightEdge,
            TabardFrame.NineSlice.BottomEdge,
            TabardFrame.NineSlice.LeftEdge,
            TabardFrame.NineSlice.TopRightCorner,
            TabardFrame.NineSlice.TopLeftCorner,
            TabardFrame.NineSlice.BottomLeftCorner,
            TabardFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
            GuildRegistrarFrame.Bg,
            GuildRegistrarFrame.TitleBg,
            GuildRegistrarFrameInset.Bg,
            TabardFrame.Bg,
            TabardFrame.TitleBg,
            TabardFrameInset.Bg
        }) do
            v:SetVertexColor(.3, .3, .3)
        end
    end
end
