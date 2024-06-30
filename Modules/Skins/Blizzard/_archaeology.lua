local Module = SUI:NewModule("Skins.Archaeology");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ArchaeologyUI" then
                SUI:Skin(ArchaeologyFrame)
                SUI:Skin(ArchaeologyFrameRaceFilter)
                SUI:Skin({ArchaeologyFrameRankBarBorder}, false, true)

                -- Buttons
                SUI:Skin({
                    ArchaeologyFrameArtifactPageSolveFrameSolveButton.Left,
                    ArchaeologyFrameArtifactPageSolveFrameSolveButton.Middle,
                    ArchaeologyFrameArtifactPageSolveFrameSolveButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
