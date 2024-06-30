local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_MacroUI" then
                SUI:Skin(MacroFrame)
                SUI:Skin(MacroFrameInset)
                SUI:Skin(MacroDeleteButton)
                SUI:Skin(MacroNewButton)
                SUI:Skin(MacroExitButton)
                SUI:Skin(MacroFrameTab1)
                SUI:Skin(MacroFrameTab2)
                SUI:Skin(MacroFrame.MacroSelector.ScrollBar.Background)
                SUI:Skin(MacroFrameTextBackground.NineSlice)
                SUI:Skin(MacroFrameTextBackground)
                SUI:Skin(MacroEditButton)
                SUI:Skin(MacroSaveButton)
                SUI:Skin(MacroCancelButton)
                SUI:Skin(MacroFrame.MacroSelector.ScrollBox.Shadows)
                SUI:Skin(MacroPopupFrame.BorderBox)
                SUI:Skin(MacroPopupFrame.IconSelector.ScrollBar.Background)
                SUI:Skin(MacroPopupFrame.BorderBox.OkayButton)
                SUI:Skin(MacroPopupFrame.BorderBox.CancelButton)
                SUI:Skin(MacroPopupFrame.BorderBox.IconTypeDropDown.DropDownMenu)

                -- Buttons
                SUI:Skin({
                    MacroDeleteButton.Left,
                    MacroDeleteButton.Middle,
                    MacroDeleteButton.Right,
                    MacroNewButton.Left,
                    MacroNewButton.Middle,
                    MacroNewButton.Right,
                    MacroExitButton.Left,
                    MacroExitButton.Middle,
                    MacroExitButton.Right,
                    MacroEditButton.Left,
                    MacroEditButton.Middle,
                    MacroEditButton.Right,
                    MacroSaveButton.Left,
                    MacroSaveButton.Middle,
                    MacroSaveButton.Right,
                    MacroCancelButton.Left,
                    MacroCancelButton.Middle,
                    MacroCancelButton.Right,
                    MacroPopupFrame.BorderBox.OkayButton.Left,
                    MacroPopupFrame.BorderBox.OkayButton.Middle,
                    MacroPopupFrame.BorderBox.OkayButton.Right,
                    MacroPopupFrame.BorderBox.CancelButton.Left,
                    MacroPopupFrame.BorderBox.CancelButton.Middle,
                    MacroPopupFrame.BorderBox.CancelButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
