local Module = SUI:NewModule("Skins.Mail");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            MailFrame.NineSlice.TopEdge,
            MailFrame.NineSlice.TopRightCorner,
            MailFrame.NineSlice.RightEdge,
            MailFrame.NineSlice.BottomRightCorner,
            MailFrame.NineSlice.BottomEdge,
            MailFrame.NineSlice.BottomLeftCorner,
            MailFrame.NineSlice.LeftEdge,
            MailFrame.NineSlice.TopLeftCorner,
            OpenMailFrame.NineSlice.TopEdge,
            OpenMailFrame.NineSlice.TopRightCorner,
            OpenMailFrame.NineSlice.RightEdge,
            OpenMailFrame.NineSlice.BottomRightCorner,
            OpenMailFrame.NineSlice.BottomEdge,
            OpenMailFrame.NineSlice.BottomLeftCorner,
            OpenMailFrame.NineSlice.LeftEdge,
            OpenMailFrame.NineSlice.TopLeftCorner,
            MailFrameTab1.Left,
            MailFrameTab1.Middle,
            MailFrameTab1.Right,
            MailFrameTab1.LeftActive,
            MailFrameTab1.MiddleActive,
            MailFrameTab1.RightActive,
            MailFrameTab1.LeftHighlight,
            MailFrameTab1.MiddleHighlight,
            MailFrameTab1.RightHighlight,
            MailFrameTab2.Left,
            MailFrameTab2.Middle,
            MailFrameTab2.Right,
            MailFrameTab2.LeftActive,
            MailFrameTab2.MiddleActive,
            MailFrameTab2.RightActive,
            MailFrameTab2.LeftHighlight,
            MailFrameTab2.MiddleHighlight,
            MailFrameTab2.RightHighlight,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            MailFrameInset.NineSlice.TopEdge,
            MailFrameInset.NineSlice.TopRightCorner,
            MailFrameInset.NineSlice.RightEdge,
            MailFrameInset.NineSlice.BottomRightCorner,
            MailFrameInset.NineSlice.BottomEdge,
            MailFrameInset.NineSlice.BottomLeftCorner,
            MailFrameInset.NineSlice.LeftEdge,
            MailFrameInset.NineSlice.TopLeftCorner,
            OpenMailFrameInset.NineSlice.TopEdge,
            OpenMailFrameInset.NineSlice.TopRightCorner,
            OpenMailFrameInset.NineSlice.RightEdge,
            OpenMailFrameInset.NineSlice.BottomRightCorner,
            OpenMailFrameInset.NineSlice.BottomEdge,
            OpenMailFrameInset.NineSlice.BottomLeftCorner,
            OpenMailFrameInset.NineSlice.LeftEdge,
            OpenMailFrameInset.NineSlice.TopLeftCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            MailFrame.Bg,
            MailFrame.TitleBg,
            OpenMailFrame.Bg,
            OpenMailFrame.TitleBg
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
    end
end
