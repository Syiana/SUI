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
            end
        end)
    end
end
