local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ QuestFrame.NineSlice.TopEdge,
            QuestFrame.NineSlice.RightEdge,
            QuestFrame.NineSlice.BottomEdge,
            QuestFrame.NineSlice.LeftEdge,
            QuestFrame.NineSlice.TopRightCorner,
            QuestFrame.NineSlice.TopLeftCorner,
            QuestFrame.NineSlice.BottomLeftCorner,
            QuestFrame.NineSlice.BottomRightCorner,
            QuestFrameInset.NineSlice.BottomEdge,
            QuestLogPopupDetailFrame.NineSlice.TopEdge,
            QuestLogPopupDetailFrame.NineSlice.RightEdge,
            QuestLogPopupDetailFrame.NineSlice.BottomEdge,
            QuestLogPopupDetailFrame.NineSlice.LeftEdge,
            QuestLogPopupDetailFrame.NineSlice.TopRightCorner,
            QuestLogPopupDetailFrame.NineSlice.TopLeftCorner,
            QuestLogPopupDetailFrame.NineSlice.BottomLeftCorner,
            QuestLogPopupDetailFrame.NineSlice.BottomRightCorner,
            QuestLogPopupDetailFrame.NineSlice.BottomEdge,
            QuestNPCModelTopBorder,
            QuestNPCModelRightBorder,
            QuestNPCModelTopRightCorner,
            QuestNPCModelBottomRightCorner,
            QuestNPCModelBottomBorder,
            QuestNPCModelBottomLeftCorner,
            QuestNPCModelLeftBorder,
            QuestNPCModelTopLeftCorner,
            QuestNPCModelTextTopBorder,
            QuestNPCModelTextRightBorder,
            QuestNPCModelTextTopRightCorner,
            QuestNPCModelTextBottomRightCorner,
            QuestNPCModelTextBottomBorder,
            QuestNPCModelTextBottomLeftCorner,
            QuestNPCModelTextLeftBorder,
            QuestNPCModelTextTopLeftCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
            QuestFrame.Bg,
            QuestFrame.TitleBg,
            QuestFrameInset.Bg
        }) do
            v:SetVertexColor(.3, .3, .3)
        end
    end
end
