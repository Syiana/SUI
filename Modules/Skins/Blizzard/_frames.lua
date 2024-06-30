local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame)
        SUI:Skin(StaticPopup1)
        SUI:Skin(StaticPopup1EditBox)
        SUI:Skin(StaticPopup2)
        SUI:Skin(StaticPopup2EditBox)
        SUI:Skin(StaticPopup3)
        SUI:Skin(StaticPopup3EditBox)

        SUI:Skin(HelpFrame)
        SUI:Skin(HelpFrame.NineSlice)

        SUI:Skin(SettingsPanel)
        SUI:Skin(SettingsPanel.NineSlice)
        SUI:Skin(SettingsPanel.CategoryList)
        SUI:Skin(SettingsPanel.CategoryList.ScrollBox)
        SUI:Skin(SettingsPanel.Bg)
        SUI:Skin(SettingsPanel.GameTab)
        SUI:Skin(SettingsPanel.AddOnsTab)
        SUI:Skin(SettingsPanel.Container.SettingsList.ScrollBox.ScrollTarget)
        SUI:Skin(SettingsPanel.SearchBox)

        SUI:Skin(StackSplitFrame)
        
        SUI:Skin(PVPReadyDialog)

        SUI:Skin(ReadyCheckListenerFrame)
        SUI:Skin(ReadyCheckFrameYesButton)
        SUI:Skin(ReadyCheckFrameNoButton)

        SUI:Skin(DropDownList1)
        SUI:Skin(DropDownList1Backdrop)
        SUI:Skin(DropDownList1MenuBackdrop.NineSlice)
        SUI:Skin(DropDownList2)
        SUI:Skin(DropDownList2Backdrop)
        SUI:Skin(DropDownList2MenuBackdrop.NineSlice)
        SUI:Skin(DropDownList3)
        SUI:Skin(DropDownList3Backdrop)
        SUI:Skin(DropDownList3MenuBackdrop.NineSlice)

        -- Set GameMenuText Point
        local gameMenuText = select(2, GameMenuFrame:GetRegions())
        gameMenuText:ClearAllPoints()
        gameMenuText:SetPoint("TOP", GameMenuFrame, "TOP", 0, 5)

        -- Buttons
        SUI:Skin({
            GameMenuButtonHelp.Left,
            GameMenuButtonHelp.Middle,
            GameMenuButtonHelp.Right,
            GameMenuButtonStore.Left,
            GameMenuButtonStore.Middle,
            GameMenuButtonStore.Right,
            GameMenuButtonOptions.Left,
            GameMenuButtonOptions.Middle,
            GameMenuButtonOptions.Right,
            GameMenuButtonMacros.Left,
            GameMenuButtonMacros.Middle,
            GameMenuButtonMacros.Right,
            GameMenuButtonAddons.Left,
            GameMenuButtonAddons.Middle,
            GameMenuButtonAddons.Right,
            GameMenuButtonLogout.Left,
            GameMenuButtonLogout.Middle,
            GameMenuButtonLogout.Right,
            GameMenuButtonQuit.Left,
            GameMenuButtonQuit.Middle,
            GameMenuButtonQuit.Right,
            GameMenuButtonContinue.Left,
            GameMenuButtonContinue.Middle,
            GameMenuButtonContinue.Right,
            select(3, StaticPopup1Button1:GetRegions()),
            select(3, StaticPopup1Button2:GetRegions()),
            select(3, StaticPopup1Button3:GetRegions()),
            select(3, StaticPopup2Button1:GetRegions()),
            select(3, StaticPopup2Button2:GetRegions()),
            select(3, StaticPopup2Button3:GetRegions()),
            select(3, StaticPopup3Button1:GetRegions()),
            select(3, StaticPopup3Button2:GetRegions()),
            select(3, StaticPopup3Button3:GetRegions()),
            select(3, StaticPopup1ExtraButton:GetRegions()),
            select(3, StaticPopup2ExtraButton:GetRegions()),
            select(3, StaticPopup3ExtraButton:GetRegions()),
            SettingsPanel.Container.SettingsList.Header.DefaultsButton.Left,
            SettingsPanel.Container.SettingsList.Header.DefaultsButton.Middle,
            SettingsPanel.Container.SettingsList.Header.DefaultsButton.Right,
            SettingsPanel.CloseButton.Left,
            SettingsPanel.CloseButton.Middle,
            SettingsPanel.CloseButton.Right,
            StackSplitOkayButton.Left,
            StackSplitOkayButton.Middle,
            StackSplitOkayButton.Right,
            StackSplitCancelButton.Left,
            StackSplitCancelButton.Middle,
            StackSplitCancelButton.Right,
            PVPReadyDialogEnterBattleButton.Left,
            PVPReadyDialogEnterBattleButton.Middle,
            PVPReadyDialogEnterBattleButton.Right,
            PVPReadyDialogHideButton.Left,
            PVPReadyDialogHideButton.Middle,
            PVPReadyDialogHideButton.Right
        }, false, true, false, true)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_DebugTools" then
                SUI:Skin(TableAttributeDisplay)
                SUI:Skin(TableAttributeDisplay.TitleButton)
            end
        end)

        if MICRO_BUTTONS then
            for _, name in pairs(MICRO_BUTTONS) do
                local button = _G[name]
                if button and _G[button:GetName() .. "Border"] == nil then
                    local border = button:CreateTexture(name .. "Border", "OVERLAY")
                    border:SetTexture([[Interface\AddOns\SUI\Media\Textures\UnitFrames\MicroButtonBorder]])
                    border:SetAllPoints(button)
                    SUI:Skin({ border }, true, true)
                end
            end
        end
    end
end
