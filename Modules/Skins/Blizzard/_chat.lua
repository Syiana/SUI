local Module = SUI:NewModule("Skins.Chat");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(ChatFrame1EditBox, true)
        SUI:Skin(ChatFrame2EditBox, true)
        SUI:Skin(ChatFrame3EditBox, true)
        SUI:Skin(ChatFrame4EditBox, true)
        SUI:Skin(ChatFrame5EditBox, true)
        SUI:Skin(ChatFrame6EditBox, true)
        SUI:Skin(ChatFrame7EditBox, true)
        SUI:Skin(ChannelFrame, true)
        SUI:Skin(ChannelFrame.NineSlice, true)
        SUI:Skin(ChannelFrame.LeftInset.NineSlice, true)
        SUI:Skin(ChannelFrame.RightInset.NineSlice, true)
        SUI:Skin(ChannelFrameInset.NineSlice, true)
        SUI:Skin(ChatConfigFrame, true)
        SUI:Skin(ChatConfigFrame.Header, true)
        SUI:Skin(ChatConfigFrame.Border, true)
        SUI:Skin(ChatConfigBackgroundFrame, true)
        SUI:Skin(ChatConfigBackgroundFrame.NineSlice, true)
        SUI:Skin(ChatConfigCategoryFrame, true)
        SUI:Skin(ChatConfigCategoryFrame.NineSlice, true)
    end
end
