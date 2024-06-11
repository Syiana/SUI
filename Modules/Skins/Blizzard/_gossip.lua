local Module = SUI:NewModule("Skins.Gossip");

function Module:OnEnable()
  if (SUI:Color()) then
    SUI:Skin(GossipFrame)
    SUI:Skin(GossipFrame.GreetingPanel)
    SUI:Skin(GossipFrame.GreetingPanel.ScrollBar.Background)
    SUI:Skin(GossipFrame.GreetingPanel.GoodbyeButton)

    if not GossipFrame.ParchmentFrame then
      GossipFrame.ParchmentFrame = GossipFrame.GreetingPanel:CreateTexture(nil, "BACKGROUND", nil, 1)
      GossipFrame.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
      GossipFrame.ParchmentFrame:SetAllPoints(GossipFrame.GreetingPanel.ScrollBox)
      GossipFrame.ParchmentFrame:SetPoint("BOTTOM", GossipFrame, "BOTTOM", 0,95)
    end
  end
end