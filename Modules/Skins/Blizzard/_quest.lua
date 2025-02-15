local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(QuestFrame)
        SUI:Skin(QuestFrame.NineSlice)
        SUI:Skin(QuestFrameInset)
        SUI:Skin(QuestFrameInset.NineSlice)
        SUI:Skin(QuestLogPopupDetailFrame)
        SUI:Skin(QuestLogPopupDetailFrame.NineSlice)
        SUI:Skin(ObjectiveTrackerFrame)
        SUI:Skin(ObjectiveTrackerFrame.Header)
        SUI:Skin(CampaignQuestObjectiveTracker)
        SUI:Skin(CampaignQuestObjectiveTracker.Header)
        SUI:Skin(QuestObjectiveTracker)
        SUI:Skin(QuestObjectiveTracker.Header)
        SUI:Skin(ProfessionsRecipeTracker)
        SUI:Skin(ProfessionsRecipeTracker.Header)
        SUI:Skin(ScenarioObjectiveTracker)
        SUI:Skin(ScenarioObjectiveTracker.Header)
        SUI:Skin({
            QuestNPCModelTopBorder,
            QuestNPCModelRightBorder,
            QuestNPCModelTopRightCorner,
            QuestNPCModelBottomRightCorner,
            QuestNPCModelBottomBorder,
            QuestNPCModelBottomLeftCorner,
            QuestNPCModelLeftBorder,
            QuestNPCModelTopLeftCorner,
            QuestNPCModelTextTopBorder,
            QuestNPCModelTextRightBorder,
            QuestNPCModelTextTopRightCorner,
            QuestNPCModelTextBottomRightCorner,
            QuestNPCModelTextBottomBorder,
            QuestNPCModelTextBottomLeftCorner,
            QuestNPCModelTextLeftBorder,
            QuestNPCModelTextTopLeftCorner
        }, false, true)
    end
end
