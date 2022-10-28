local Menu = SUI:NewModule("ActionBars.Menu");

function Menu:OnEnable()
  local db = SUI.db.profile.actionbar
  if (db.menu.menumouseover) then
    QueueStatusButton:SetParent()
    QueueStatusButton:SetScale(0.8, 0.8)
    MicroButtonAndBagsBar:SetAlpha(0)
    MicroButtonAndBagsBar:SetScript('OnEnter', function()
      MicroButtonAndBagsBar:SetAlpha(1)
    end)
    MicroButtonAndBagsBar:SetScript('OnLeave', function()
      if not (MouseIsOver(MicroButtonAndBagsBar)) then
        MicroButtonAndBagsBar:SetAlpha(0)
        end
    end)
  end
end