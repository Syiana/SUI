local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_AuctionUI" then
        SUI:Skin(AuctionFrame)
      end
    end)
  end
end