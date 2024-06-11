local Module = SUI:NewModule("Skins.Calendar");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Calendar" then
        SUI:Skin(CalendarFrame)
      end
    end)
  end
end