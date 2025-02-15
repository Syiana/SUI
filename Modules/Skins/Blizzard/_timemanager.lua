local Module = SUI:NewModule("Skins.TimeManager");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TimeManager" then
                SUI:Skin(TimeManagerFrame, true)
                SUI:Skin(TimeManagerFrame.NineSlice, true)
                SUI:Skin(TimeManagerFrameInset, true)
                SUI:Skin(TimeManagerFrameInset.NineSlice, true)
                SUI:Skin({ StopwatchFrameBackgroundLeft }, true, true)
            end
        end)
    end
end
