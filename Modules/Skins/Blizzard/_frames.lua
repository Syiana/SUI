local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in ipairs({
            GameMenuFrame.Header.CenterBG,
            GameMenuFrame.Header.LeftBG,
            GameMenuFrame.Header.RightBG,
            GameMenuFrame.Border.TopEdge,
            GameMenuFrame.Border.RightEdge,
            GameMenuFrame.Border.BottomEdge,
            GameMenuFrame.Border.LeftEdge,
            GameMenuFrame.Border.TopRightCorner,
            GameMenuFrame.Border.TopLeftCorner,
            GameMenuFrame.Border.BottomLeftCorner,
            GameMenuFrame.Border.BottomRightCorner,
            StaticPopup1.Border.TopEdge,
            StaticPopup1.Border.RightEdge,
            StaticPopup1.Border.BottomEdge,
            StaticPopup1.Border.LeftEdge,
            StaticPopup1.Border.TopRightCorner,
            StaticPopup1.Border.TopLeftCorner,
            StaticPopup1.Border.BottomLeftCorner,
            StaticPopup1.Border.BottomRightCorner,
            EditModeManagerFrame.Border.Bg,
            EditModeManagerFrame.Border.TopEdge,
            EditModeManagerFrame.Border.BottomEdge,
            EditModeManagerFrame.Border.LeftEdge,
            EditModeManagerFrame.Border.RightEdge,
            EditModeManagerFrame.Border.TopLeftCorner,
            EditModeManagerFrame.Border.TopRightCorner,
            EditModeManagerFrame.Border.BottomLeftCorner,
            EditModeManagerFrame.Border.BottomRightCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
