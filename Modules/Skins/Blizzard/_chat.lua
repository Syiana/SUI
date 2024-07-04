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

        -- Buttons
        SUI:Skin({
            ChannelFrame.NewButton.Left,
            ChannelFrame.NewButton.Middle,
            ChannelFrame.NewButton.Right,
            ChannelFrame.SettingsButton.Left,
            ChannelFrame.SettingsButton.Middle,
            ChannelFrame.SettingsButton.Right,
            ChatConfigFrameDefaultButton.Left,
            ChatConfigFrameDefaultButton.Middle,
            ChatConfigFrameDefaultButton.Right,
            ChatConfigFrameRedockButton.Left,
            ChatConfigFrameRedockButton.Middle,
            ChatConfigFrameRedockButton.Right,
            ChatConfigFrame.ToggleChatButton.Left,
            ChatConfigFrame.ToggleChatButton.Middle,
            ChatConfigFrame.ToggleChatButton.Right,
            ChatConfigFrameOkayButton.Left,
            ChatConfigFrameOkayButton.Middle,
            ChatConfigFrameOkayButton.Right,
            CombatLogDefaultButton.Left,
            CombatLogDefaultButton.Middle,
            CombatLogDefaultButton.Right,
            ChatConfigCombatSettingsFiltersCopyFilterButton.Left,
            ChatConfigCombatSettingsFiltersCopyFilterButton.Middle,
            ChatConfigCombatSettingsFiltersCopyFilterButton.Right,
            ChatConfigCombatSettingsFiltersAddFilterButton.Left,
            ChatConfigCombatSettingsFiltersAddFilterButton.Middle,
            ChatConfigCombatSettingsFiltersAddFilterButton.Right,
            ChatConfigCombatSettingsFiltersDeleteButton.Left,
            ChatConfigCombatSettingsFiltersDeleteButton.Middle,
            ChatConfigCombatSettingsFiltersDeleteButton.Right,
            CombatConfigSettingsSaveButton.Left,
            CombatConfigSettingsSaveButton.Middle,
            CombatConfigSettingsSaveButton.Right,
        }, false, true, false, true)
    end
end
