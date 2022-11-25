local Module = SUI:NewModule("Skins.ScrappingMachine");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ScrappingMachineUI" then
                for i, v in pairs({ ScrappingMachineFrame.NineSlice.TopEdge,
                    ScrappingMachineFrame.NineSlice.RightEdge,
                    ScrappingMachineFrame.NineSlice.BottomEdge,
                    ScrappingMachineFrame.NineSlice.LeftEdge,
                    ScrappingMachineFrame.NineSlice.TopRightCorner,
                    ScrappingMachineFrame.NineSlice.TopLeftCorner,
                    ScrappingMachineFrame.NineSlice.BottomLeftCorner,
                    ScrappingMachineFrame.NineSlice.BottomRightCorner, }) do
                    v:SetVertexColor(.15, .15, .15)
                end
            end
        end)
    end
end
