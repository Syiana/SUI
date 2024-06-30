local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(QuestLogFrame)
        SUI:Skin(QuestFrame)
        SUI:Skin(QuestLogDetailFrame)
        SUI:Skin(QuestFrameDetailPanel)
        SUI:Skin(QuestDetailScrollFrame)
        SUI:Skin(QuestFrameRewardPanel)
        SUI:Skin(QuestRewardScrollFrame)
        SUI:Skin(QuestFrameProgressPanel)
        SUI:Skin(QuestProgressScrollFrame)
        SUI:Skin(QuestFrameGreetingPanel)
        SUI:Skin(EmptyQuestLogFrame)
        SUI:Skin(QuestModelScene)

        -- Buttons
        SUI:Skin({
            QuestFrameAcceptButton.Left,
            QuestFrameAcceptButton.Middle,
            QuestFrameAcceptButton.Right,
            QuestFrameDeclineButton.Left,
            QuestFrameDeclineButton.Middle,
            QuestFrameDeclineButton.Right,
            QuestLogFrameAbandonButton.Left,
            QuestLogFrameAbandonButton.Middle,
            QuestLogFrameAbandonButton.Right,
            QuestFramePushQuestButton.Left,
            QuestFramePushQuestButton.Middle,
            QuestFramePushQuestButton.Right,
            QuestLogFrameTrackButton.Left,
            QuestLogFrameTrackButton.Middle,
            QuestLogFrameTrackButton.Right,
            QuestLogFrameCancelButton.Left,
            QuestLogFrameCancelButton.Middle,
            QuestLogFrameCancelButton.Right,
            QuestFrameCompleteButton.Left,
            QuestFrameCompleteButton.Middle,
            QuestFrameCompleteButton.Right,
            QuestFrameGoodbyeButton.Left,
            QuestFrameGoodbyeButton.Middle,
            QuestFrameGoodbyeButton.Right,
            QuestFrameCompleteQuestButton.Left,
            QuestFrameCompleteQuestButton.Middle,
            QuestFrameCompleteQuestButton.Right,
            QuestFrameCancelButton.Left,
            QuestFrameCancelButton.Middle,
            QuestFrameCancelButton.Right
        }, false, true, false, true)

        if not QuestFrameDetailPanel.ParchmentFrame then
            QuestFrameDetailPanel.ParchmentFrame = QuestFrameDetailPanel:CreateTexture(nil, "OVERLAY", nil, 1)
            QuestFrameDetailPanel.ParchmentFrame:SetTexture([[Interface\Stationery\StationeryTest1.blp]])
            QuestFrameDetailPanel.ParchmentFrame:SetAllPoints(QuestDetailScrollFrame)
        end

        if not QuestFrameRewardPanel.ParchmentFrame then
            QuestFrameRewardPanel.ParchmentFrame = QuestFrameRewardPanel:CreateTexture(nil, "OVERLAY", nil, 1)
            QuestFrameRewardPanel.ParchmentFrame:SetTexture([[Interface\Stationery\StationeryTest1.blp]])
            QuestFrameRewardPanel.ParchmentFrame:SetAllPoints(QuestRewardScrollFrame)
        end

        if not QuestFrameProgressPanel.ParchmentFrame then
            QuestFrameProgressPanel.ParchmentFrame = QuestFrameProgressPanel:CreateTexture(nil, "OVERLAY", nil, 1)
            QuestFrameProgressPanel.ParchmentFrame:SetTexture([[Interface\Stationery\StationeryTest1.blp]])
            QuestFrameProgressPanel.ParchmentFrame:SetAllPoints(QuestProgressScrollFrame)
        end

        if not QuestFrameGreetingPanel.ParchmentFrame then
            QuestFrameGreetingPanel.ParchmentFrame = QuestFrameGreetingPanel:CreateTexture(nil, "OVERLAY", nil, 1)
            QuestFrameGreetingPanel.ParchmentFrame:SetTexture([[Interface\Stationery\StationeryTest1.blp]])
            QuestFrameGreetingPanel.ParchmentFrame:SetAllPoints(QuestGreetingScrollChildFrame)
        end

        if not QuestLogFrame.ParchmentFrame then
            QuestLogFrame.ParchmentFrame = QuestLogFrame:CreateTexture(nil, "OVERLAY", nil, 1)
            QuestLogFrame.ParchmentFrame:SetTexture([[Interface\Stationery\StationeryTest1.blp]])
            QuestLogFrame.ParchmentFrame:SetAllPoints(QuestLogDetailScrollFrame)
        end
    end
end
