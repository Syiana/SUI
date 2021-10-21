local Module = SUI:NewModule("Skins.EncounterJournal");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_EncounterJournal" then
        for i, v in pairs({ EncounterJournal.NineSlice.TopEdge,
          EncounterJournal.NineSlice.RightEdge,
          EncounterJournal.NineSlice.BottomEdge,
          EncounterJournal.NineSlice.LeftEdge,
          EncounterJournal.NineSlice.TopRightCorner,
          EncounterJournal.NineSlice.TopLeftCorner,
          EncounterJournal.NineSlice.BottomLeftCorner,
          EncounterJournal.NineSlice.BottomRightCorner,
          EncounterJournalInset.NineSlice.BottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        EncounterJournalInset:SetAlpha(0)
        for i, v in pairs({
          EncounterJournal.Bg,
          EncounterJournal.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end