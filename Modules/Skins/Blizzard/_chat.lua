local Module = SUI:NewModule("Skins.Chat");

function Module:OnEnable()
    if (SUI:Color()) then
        for i = 1, 10 do
            SUI:Skin(_G["ChatFrame" .. i])
            SUI:Skin({
                _G["ChatFrame" .. i .. "EditBoxLeft"],
                _G["ChatFrame" .. i .. "EditBoxMid"],
                _G["ChatFrame" .. i .. "EditBoxRight"],
            }, false, true)
            --SUI:Skin(_G["ChatFrame"..i.."EditBox"])
        end

        SUI:Skin(ChatConfigFrame)
        SUI:Skin(ChatConfigFrameDefaultButton)
        SUI:Skin(ChatConfigFrameRedockButton)
        SUI:Skin(ChatConfigFrame.ToggleChatButton)
        SUI:Skin(ChatConfigFrameOkayButton)
        SUI:Skin(ChannelFrame)
        SUI:Skin(ChannelFrameInset)
        SUI:Skin(ChannelFrame.NewButton)
        SUI:Skin(ChannelFrame.SettingsButton)
        SUI:Skin(ChannelFrame.ChannelList)
        SUI:Skin(ChannelFrame.LeftInset)
        SUI:Skin(ChannelFrame.RightInset)
        SUI:Skin(ChannelFrame.ChannelList)
    end
end
