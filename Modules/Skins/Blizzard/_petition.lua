local Module = SUI:NewModule("Skins.Petition");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ PetitionFrame.NineSlice.TopEdge,
            PetitionFrame.NineSlice.RightEdge,
            PetitionFrame.NineSlice.BottomEdge,
            PetitionFrame.NineSlice.LeftEdge,
            PetitionFrame.NineSlice.TopRightCorner,
            PetitionFrame.NineSlice.TopLeftCorner,
            PetitionFrame.NineSlice.BottomLeftCorner,
            PetitionFrame.NineSlice.BottomRightCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            PetitionFrame.Bg,
            PetitionFrame.TitleBg,
            PetitionFrameInset.Bg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
