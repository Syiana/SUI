local Menu = SUI:NewModule("ActionBars.Menu");

function Menu:OnEnable()
    if IsAddOnLoaded('Bartender4') or IsAddOnLoaded('Dominos') then return end
    local db = {
        micromenu = SUI.db.profile.actionbar.menu.micromenu,
        bagbar = SUI.db.profile.actionbar.menu.bagbar,
        bagPos = SUI.db.profile.edit.bagbar,
        microPos = SUI.db.profile.edit.micromenu
    }

    local MicroButtonAndBagsBarButtons = {
        CharacterMicroButton,
        SpellbookMicroButton,
        TalentMicroButton,
        AchievementMicroButton,
        QuestLogMicroButton,
        GuildMicroButton,
        LFDMicroButton,
        CollectionsMicroButton,
        EJMicroButton,
        StoreMicroButton,
        MainMenuMicroButton,
        MainMenuBarBackpackButton,
        CharacterBag0Slot,
        CharacterBag1Slot,
        CharacterBag2Slot,
        CharacterBag3Slot,
    }

    for _, button in pairs(MicroButtonAndBagsBarButtons) do
        button:GetNormalTexture():SetVertexColor(0.65, 0.65, 0.65)
    end
end
