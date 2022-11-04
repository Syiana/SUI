local Menu = SUI:NewModule("ActionBars.Menu");

function Menu:OnEnable()
  local db = SUI.db.profile.actionbar
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

  local menuOpt = db.menu.menumouseover

  if menuOpt == "mouse_over" then
    MicroButtonAndBagsBar:SetAlpha(0)

    for _, buttons in pairs(MicroButtonAndBagsBarButtons) do
      buttons:SetScript('OnEnter', function()
        MicroButtonAndBagsBar:SetAlpha(1)
      end)
      buttons:SetScript('OnLeave', function()
        if not (MouseIsOver(buttons)) then
          MicroButtonAndBagsBar:SetAlpha(0)
          end
      end)
    end
  end

  if menuOpt == "hide" then
    MicroButtonAndBagsBar:SetAlpha(0)
    MicroButtonAndBagsBar:Hide()
  end
end