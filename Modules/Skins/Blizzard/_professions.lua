local Module = SUI:NewModule("Skins.Professions");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Professions" then
                for i, v in pairs({
                    ProfessionsFrame.NineSlice.BottomEdge,
                    ProfessionsFrame.NineSlice.BottomLeftCorner,
                    ProfessionsFrame.NineSlice.BottomRightCorner,
                    ProfessionsFrame.NineSlice.Center,
                    ProfessionsFrame.NineSlice.LeftEdge,
                    ProfessionsFrame.NineSlice.RightEdge,
                    ProfessionsFrame.NineSlice.TopEdge,
                    ProfessionsFrame.NineSlice.TopLeftCorner,
                    ProfessionsFrame.NineSlice.TopRightCorner,
                    ProfessionsFrame.TabSystem.tabs[1].Left,
                    ProfessionsFrame.TabSystem.tabs[1].Middle,
                    ProfessionsFrame.TabSystem.tabs[1].Right,
                    ProfessionsFrame.TabSystem.tabs[1].LeftActive,
                    ProfessionsFrame.TabSystem.tabs[1].MiddleActive,
                    ProfessionsFrame.TabSystem.tabs[1].RightActive,
                    ProfessionsFrame.TabSystem.tabs[1].LeftHighlight,
                    ProfessionsFrame.TabSystem.tabs[1].MiddleHighlight,
                    ProfessionsFrame.TabSystem.tabs[1].RightHighlight,
                    ProfessionsFrame.TabSystem.tabs[2].Left,
                    ProfessionsFrame.TabSystem.tabs[2].Middle,
                    ProfessionsFrame.TabSystem.tabs[2].Right,
                    ProfessionsFrame.TabSystem.tabs[2].LeftActive,
                    ProfessionsFrame.TabSystem.tabs[2].MiddleActive,
                    ProfessionsFrame.TabSystem.tabs[2].RightActive,
                    ProfessionsFrame.TabSystem.tabs[2].LeftHighlight,
                    ProfessionsFrame.TabSystem.tabs[2].MiddleHighlight,
                    ProfessionsFrame.TabSystem.tabs[2].RightHighlight,
                    ProfessionsFrame.TabSystem.tabs[3].Left,
                    ProfessionsFrame.TabSystem.tabs[3].Middle,
                    ProfessionsFrame.TabSystem.tabs[3].Right,
                    ProfessionsFrame.TabSystem.tabs[3].LeftActive,
                    ProfessionsFrame.TabSystem.tabs[3].MiddleActive,
                    ProfessionsFrame.TabSystem.tabs[3].RightActive,
                    ProfessionsFrame.TabSystem.tabs[3].LeftHighlight,
                    ProfessionsFrame.TabSystem.tabs[3].MiddleHighlight,
                    ProfessionsFrame.TabSystem.tabs[3].RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end