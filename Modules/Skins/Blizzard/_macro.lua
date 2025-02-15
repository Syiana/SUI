local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_MacroUI" then
                SUI:Skin(MacroFrame, true)
                SUI:Skin(MacroFrame.NineSlice, true)
                SUI:Skin(MacroFrameInset, true)
                SUI:Skin(MacroFrameInset.NineSlice, true)
                SUI:Skin(MacroFrameTextBackground, true)
                SUI:Skin(MacroFrameTextBackground.NineSlice, true)
                SUI:Skin({
                    MacroButtonScrollFrameTop,
                    MacroButtonScrollFrameMiddle,
                    MacroButtonScrollFrameBottom,
                    MacroButtonScrollFrameScrollBarThumbTexture
                }, true, true)

                -- Tabs
                SUI:Skin(MacroFrameTab1, true)
                SUI:Skin(MacroFrameTab2, true)
            end
        end)
    end
end
