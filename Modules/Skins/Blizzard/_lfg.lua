local Module = SUI:NewModule("Skins.LFG");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GroupFinderFrame)
        SUI:Skin(PVEFrame)
        SUI:Skin(LFDParentFrame)
        SUI:Skin(PVEFrameLeftInset)
        SUI:Skin(LFDParentFrameInset)
        SUI:Skin(PVEFrame.shadows)
        SUI:Skin(LFGListPVEStub)
        SUI:Skin(LFGListFrame.CategorySelection.Inset)
        SUI:Skin(LFGListFrame.CategorySelection.StartGroupButton)
        SUI:Skin(LFGListFrame.CategorySelection.FindGroupButton)
        SUI:Skin(LFGListFrame.SearchPanel.ScrollBox.Shadows)
        SUI:Skin(LFGListFrame.SearchPanel.ScrollBox)
        SUI:Skin(LFGListFrame.SearchPanel.ResultsInset)
        SUI:Skin(LFGListFrame.SearchPanel.BackButton)
        SUI:Skin(LFGListFrame.SearchPanel.SignUpButton)
        SUI:Skin(LFGListFrame.SearchPanel.ScrollBox.StartGroupButton)
        SUI:Skin(LFDQueueFrameFindGroupButton)
        SUI:Skin(LFGListFrame.EntryCreation.CancelButton)
        SUI:Skin(LFGListFrame.EntryCreation.ListGroupButton)
        SUI:Skin(LFGListFrame.EntryCreation.Inset)
    end
end
