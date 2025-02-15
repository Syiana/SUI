local Module = SUI:NewModule("Skins.Quest");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(QuestFrame, true)
        SUI:Skin(QuestFrame.NineSlice, true)
        SUI:Skin(QuestFrameInset, true)
        SUI:Skin(QuestFrameInset.NineSlice, true)
        SUI:Skin(QuestLogPopupDetailFrame, true)
        SUI:Skin(QuestLogPopupDetailFrame.NineSlice, true)
        SUI:Skin(ObjectiveTrackerFrame, true)
        SUI:Skin(ObjectiveTrackerFrame.Header, true)
        SUI:Skin(CampaignQuestObjectiveTracker, true)
        SUI:Skin(CampaignQuestObjectiveTracker.Header, true)
        SUI:Skin(QuestObjectiveTracker, true)
        SUI:Skin(QuestObjectiveTracker.Header, true)
        SUI:Skin(ProfessionsRecipeTracker, true)
        SUI:Skin(ProfessionsRecipeTracker.Header, true)
        SUI:Skin(ScenarioObjectiveTracker, true)
        SUI:Skin(ScenarioObjectiveTracker.Header, true)
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
        }, true, true)
    end
end
