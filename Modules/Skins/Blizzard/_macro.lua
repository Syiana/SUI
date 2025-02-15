local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_MacroUI" then
                SUI:Skin(MacroFrame)
                SUI:Skin(MacroFrame.NineSlice)
                SUI:Skin(MacroFrameInset)
                SUI:Skin(MacroFrameInset.NineSlice)
                SUI:Skin(MacroFrameTextBackground)
                SUI:Skin(MacroFrameTextBackground.NineSlice)
                SUI:Skin({
                    MacroButtonScrollFrameTop,
                    MacroButtonScrollFrameMiddle,
                    MacroButtonScrollFrameBottom,
                    MacroButtonScrollFrameScrollBarThumbTexture
                }, false, true)

                -- Tabs
                SUI:Skin(MacroFrameTab1)
                SUI:Skin(MacroFrameTab2)
            end
        end)
    end
end
