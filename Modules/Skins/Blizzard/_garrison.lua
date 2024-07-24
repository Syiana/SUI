local Module = SUI:NewModule("Skins.Garrison");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GarrisonUI" then
                for i, v in pairs({
                    GarrisonCapacitiveDisplayFrame.NineSlice.TopEdge,
                    GarrisonCapacitiveDisplayFrame.NineSlice.RightEdge,
                    GarrisonCapacitiveDisplayFrame.NineSlice.BottomEdge,
                    GarrisonCapacitiveDisplayFrame.NineSlice.LeftEdge,
                    GarrisonCapacitiveDisplayFrame.NineSlice.TopRightCorner,
                    GarrisonCapacitiveDisplayFrame.NineSlice.TopLeftCorner,
                    GarrisonCapacitiveDisplayFrame.NineSlice.BottomLeftCorner,
                    GarrisonCapacitiveDisplayFrame.NineSlice.BottomRightCorner,
                    GarrisonCapacitiveDisplayFrameInset.NineSlice.BottomEdge,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    GarrisonCapacitiveDisplayFrame.Bg,
                    GarrisonCapacitiveDisplayFrame.TitleBg
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
