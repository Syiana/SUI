local Module = SUI:NewModule("Skins.Communities");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_Communities" then
        SUI:Skin(CommunitiesFrame)
        SUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame)
        SUI:Skin(CommunitiesFrameInset)
        SUI:Skin(CommunitiesFrame.ChatEditBox)
        SUI:Skin(CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton)
        SUI:Skin(CommunitiesFrame.InviteButton)
      end
    end)
  end
end