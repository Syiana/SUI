local Module = SUI:NewModule("Skins.Chat");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({ ChatFrame1EditBoxLeft,
            ChatFrame1EditBoxRight,
            ChatFrame1EditBoxMid,
            ChatFrame2EditBoxLeft,
            ChatFrame2EditBoxRight,
            ChatFrame2EditBoxMid,
            ChatFrame3EditBoxLeft,
            ChatFrame3EditBoxRight,
            ChatFrame3EditBoxMid,
            ChatFrame4EditBoxLeft,
            ChatFrame4EditBoxRight,
            ChatFrame4EditBoxMid,
            ChatFrame5EditBoxLeft,
            ChatFrame5EditBoxRight,
            ChatFrame5EditBoxMid,
            ChatFrame6EditBoxLeft,
            ChatFrame6EditBoxRight,
            ChatFrame6EditBoxMid,
            ChatFrame7EditBoxLeft,
            ChatFrame7EditBoxRight,
            ChatFrame7EditBoxMid, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({ ChannelFrame.NineSlice.TopEdge,
            ChannelFrame.NineSlice.TopEdge,
            ChannelFrame.NineSlice.TopRightCorner,
            ChannelFrame.NineSlice.RightEdge,
            ChannelFrame.NineSlice.BottomRightCorner,
            ChannelFrame.NineSlice.BottomEdge,
            ChannelFrame.NineSlice.BottomLeftCorner,
            ChannelFrame.NineSlice.LeftEdge,
            ChannelFrame.NineSlice.TopLeftCorner,
            ChannelFrame.LeftInset.NineSlice.BottomEdge,
            ChannelFrame.LeftInset.NineSlice.BottomLeftCorner,
            ChannelFrame.LeftInset.NineSlice.BottomRightCorner,
            ChannelFrame.RightInset.NineSlice.BottomEdge,
            ChannelFrame.RightInset.NineSlice.BottomLeftCorner,
            ChannelFrame.RightInset.NineSlice.BottomRightCorner,
            ChannelFrameInset.NineSlice.BottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
            ChannelFrame.Bg,
            ChannelFrame.TitleBg,
            ChannelFrameInset.Bg
        }) do
            v:SetVertexColor(.3, .3, .3)
        end
    end
end
