local Module = SUI:NewModule("Skins.Frames");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GameMenuFrame)
        SUI:Skin(GameMenuButtonHelp)
        SUI:Skin(GameMenuButtonStore)
        SUI:Skin(GameMenuButtonOptions)
        SUI:Skin(GameMenuButtonMacros)
        SUI:Skin(GameMenuButtonAddons)
        SUI:Skin(GameMenuButtonLogout)
        SUI:Skin(GameMenuButtonQuit)
        SUI:Skin(GameMenuButtonContinue)
        SUI:Skin(StaticPopup1)
        SUI:Skin(StaticPopup1Button1)
        SUI:Skin(StaticPopup1Button2)
        SUI:Skin(StaticPopup1Button3)
        SUI:Skin(HelpFrame)
        SUI:Skin(HelpFrame.NineSlice)
        SUI:Skin(SettingsPanel)
        SUI:Skin(SettingsPanel.NineSlice)
        SUI:Skin(SettingsPanel.CategoryList)
        SUI:Skin(SettingsPanel.CategoryList.ScrollBox)
        SUI:Skin(SettingsPanel.Bg)
        SUI:Skin(SettingsPanel.GameTab)
        SUI:Skin(SettingsPanel.AddOnsTab)
        SUI:Skin(SettingsPanel.Container.SettingsList.Header.DefaultsButton)
        SUI:Skin(SettingsPanel.CloseButton)
        SUI:Skin(SettingsPanel.Container.SettingsList.ScrollBox.ScrollTarget)
        SUI:Skin(StackSplitFrame)
        SUI:Skin(StackSplitOkayButton)
        SUI:Skin(StackSplitCancelButton)

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
                    border:SetTexture("Interface\\AddOns\\SUI\\Media\\Textures\\UnitFrames\\MicroButtonBorder")
                    border:SetAllPoints(button)
                    SUI:Skin({ border }, true, true)
                end
            end
        end
    end
end
