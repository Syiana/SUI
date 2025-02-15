local Module = SUI:NewModule("Skins.Chat");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(ChatFrame1EditBox)
        SUI:Skin(ChatFrame2EditBox)
        SUI:Skin(ChatFrame3EditBox)
        SUI:Skin(ChatFrame4EditBox)
        SUI:Skin(ChatFrame5EditBox)
        SUI:Skin(ChatFrame6EditBox)
        SUI:Skin(ChatFrame7EditBox)
        SUI:Skin(ChannelFrame)
        SUI:Skin(ChannelFrame.NineSlice)
        SUI:Skin(ChannelFrame.LeftInset.NineSlice)
        SUI:Skin(ChannelFrame.RightInset.NineSlice)
        SUI:Skin(ChannelFrameInset.NineSlice)
        SUI:Skin(ChatConfigFrame)
        SUI:Skin(ChatConfigFrame.Header)
        SUI:Skin(ChatConfigFrame.Border)
        SUI:Skin(ChatConfigBackgroundFrame)
        SUI:Skin(ChatConfigBackgroundFrame.NineSlice)
        SUI:Skin(ChatConfigCategoryFrame)
        SUI:Skin(ChatConfigCategoryFrame.NineSlice)
    end
end
