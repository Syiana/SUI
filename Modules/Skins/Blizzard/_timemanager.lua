local Module = SUI:NewModule("Skins.TimeManager");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_TimeManager" then
                SUI:Skin(TimeManagerFrame)
                SUI:Skin(TimeManagerFrame.NineSlice)
                SUI:Skin(TimeManagerFrameInset)
                SUI:Skin(TimeManagerFrameInset.NineSlice)
                SUI:Skin({ StopwatchFrameBackgroundLeft }, false, true)
            end
        end)
    end
end
