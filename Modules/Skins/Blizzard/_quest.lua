local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
  if (SUI:Color()) then
    SUI:Skin(QuestLogFrame)
    SUI:Skin(QuestFrame)
    SUI:Skin(QuestFrameDetailPanel)
    SUI:Skin(QuestFrameAcceptButton)
    SUI:Skin(QuestFrameDeclineButton)

    if not QuestFrameDetailPanel.ParchmentFrame then
      QuestFrameDetailPanel.ParchmentFrame = QuestFrameDetailPanel:CreateTexture(nil, "OVERLAY", nil, 1)
      QuestFrameDetailPanel.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
      QuestFrameDetailPanel.ParchmentFrame:SetAllPoints(QuestDetailScrollFrame)
    end

    if not QuestFrameRewardPanel.ParchmentFrame then
        QuestFrameRewardPanel.ParchmentFrame = QuestFrameRewardPanel:CreateTexture(nil, "OVERLAY", nil, 1)
        QuestFrameRewardPanel.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
        QuestFrameRewardPanel.ParchmentFrame:SetAllPoints(QuestRewardScrollFrame)
    end

    if not QuestFrameProgressPanel.ParchmentFrame then
        QuestFrameProgressPanel.ParchmentFrame = QuestFrameProgressPanel:CreateTexture(nil, "OVERLAY", nil, 1)
        QuestFrameProgressPanel.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
        QuestFrameProgressPanel.ParchmentFrame:SetAllPoints(QuestProgressScrollFrame)
    end

    if not QuestFrameGreetingPanel.ParchmentFrame then
        QuestFrameGreetingPanel.ParchmentFrame = QuestFrameGreetingPanel:CreateTexture(nil, "OVERLAY", nil, 1)
        QuestFrameGreetingPanel.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
        QuestFrameGreetingPanel.ParchmentFrame:SetAllPoints(QuestGreetingScrollChildFrame)
    end

    if not QuestLogFrame.ParchmentFrame then
      QuestLogFrame.ParchmentFrame = QuestLogFrame:CreateTexture(nil, "OVERLAY", nil, 1)
      QuestLogFrame.ParchmentFrame:SetTexture("Interface\\Stationery\\StationeryTest1.blp")
      QuestLogFrame.ParchmentFrame:SetAllPoints(QuestLogDetailScrollFrame)
    end
  end
end