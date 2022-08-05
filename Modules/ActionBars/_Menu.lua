local Module = SUI:NewModule("ActionBars.Menu");

function Module:OnEnable()
  local db = SUI.db.profile.actionbar
  if (db.style == 'Small') then
    -- MicroMenu
    if UnitLevel("player") < SHOW_SPEC_LEVEL then
      CharacterMicroButton:ClearAllPoints()
      CharacterMicroButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -160, 5.5)
    else
      CharacterMicroButton:ClearAllPoints()
      CharacterMicroButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -185, 5.5)
    end

    -- Bag buttons
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -5, 50)

    local BagButtons = {
      MainMenuBarBackpackButton,
      CharacterBag0Slot,
      CharacterBag1Slot,
      CharacterBag2Slot,
      CharacterBag3Slot,
      MainMenuBarBackpackButton.Back,
      CharacterBag0Slot.Back,
      CharacterBag1Slot.Back,
      CharacterBag2Slot.Back,
      CharacterBag3Slot.Back,
      KeyRingButton,
      KeyRingButton.Back,
    }

    for _, frame in pairs(BagButtons) do
      frame:SetScale(0.75)
    end

    local MicroMenu = {
      CharacterMicroButton,
      SpellbookMicroButton,
      TalentMicroButton,
      QuestLogMicroButton,
      SocialsMicroButton,
      LFGMicroButton,
      MainMenuMicroButton,
      HelpMicroButton
    }

    for _, frame in pairs(MicroMenu) do
      frame:SetScale(0.75)
      LFGMicroButton:SetPoint("BOTTOMRIGHT", SocialsMicroButton, 26, 0)
      MainMenuMicroButton:ClearAllPoints()
      MainMenuMicroButton:SetPoint("BOTTOMRIGHT", LFGMicroButton, 26, 0)
    end

    -- Show/Hide on Mouseover
    if (db.menu.mouseovermicro) then
      -- MicroMenu
      local ignore

      local function setAlphaMicroMenu(b, a)
        if ignore then return end
        ignore = true
        if b:IsMouseOver() then
          b:SetAlpha(1)
        else
          b:SetAlpha(0)
        end
        ignore = nil
      end

      local function showMicroMenu(self)
          for _, v in ipairs(MICRO_BUTTONS) do
              ignore = true
              _G[v]:SetAlpha(1)
              ignore = nil
          end
      end
      
      local function hideMicroMenu(self)
          for _, v in ipairs(MICRO_BUTTONS) do
              ignore = true
              _G[v]:SetAlpha(0)
              ignore = nil
          end
      end
      
      for _, v in ipairs(MICRO_BUTTONS) do
          v = _G[v]
          hooksecurefunc(v, "SetAlpha", setAlphaMicroMenu)
          v:HookScript("OnEnter", showMicroMenu)
          v:HookScript("OnLeave", hideMicroMenu)
          v:SetAlpha(0)
      end
    end

    if (db.menu.mouseoverbags) then
      -- Bags bar
      for _, frame in pairs(BagButtons) do
        frame:SetAlpha(0)
        frame:SetScript('OnEnter', function()
        MainMenuBarBackpackButton:SetAlpha(1)
        CharacterBag0Slot:SetAlpha(1)
        CharacterBag1Slot:SetAlpha(1)
        CharacterBag2Slot:SetAlpha(1)
        CharacterBag3Slot:SetAlpha(1)
        KeyRingButton:SetAlpha(1)
      end)
      frame:SetScript('OnLeave', function()
        if not (MouseIsOver(frame)) then
          MainMenuBarBackpackButton:SetAlpha(0)
          CharacterBag0Slot:SetAlpha(0)
          CharacterBag1Slot:SetAlpha(0)
          CharacterBag2Slot:SetAlpha(0)
          CharacterBag3Slot:SetAlpha(0)
          KeyRingButton:SetAlpha(0)
          end
        end)
      end
    end
  end

  if (db.style == 'Shadowlands') then
    -- MicroMenu
    if UnitLevel("player") < SHOW_SPEC_LEVEL then
      CharacterMicroButton:ClearAllPoints()
      CharacterMicroButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -160, 5.5)
    else
      CharacterMicroButton:ClearAllPoints()
      CharacterMicroButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -185, 5.5)
    end

    -- Bag buttons
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MicroButtonAndBagsBar, -5, 50)  

    local BagButtons = {
      MainMenuBarBackpackButton,
      CharacterBag0Slot,
      CharacterBag1Slot,
      CharacterBag2Slot,
      CharacterBag3Slot,
      MainMenuBarBackpackButton.Back,
      CharacterBag0Slot.Back,
      CharacterBag1Slot.Back,
      CharacterBag2Slot.Back,
      CharacterBag3Slot.Back,
      KeyRingButton,
      KeyRingButton.Back,
    }

    for _, frame in pairs(BagButtons) do
      frame:SetScale(0.75)
    end

    local MicroMenu = {
      CharacterMicroButton,
      SpellbookMicroButton,
      TalentMicroButton,
      QuestLogMicroButton,
      SocialsMicroButton,
      LFGMicroButton,
      MainMenuMicroButton,
      HelpMicroButton
    }

    for _, frame in pairs(MicroMenu) do
      frame:SetScale(0.75)
      LFGMicroButton:SetPoint("BOTTOMRIGHT", SocialsMicroButton, 26, 0)
      MainMenuMicroButton:ClearAllPoints()
      MainMenuMicroButton:SetPoint("BOTTOMRIGHT", LFGMicroButton, 26, 0)
    end

    -- Show/Hide on Mouseover
    if (db.menu.mouseovermicro) then
      -- MicroMenu
      local ignore

      local function setAlphaMicroMenu(b, a)
        if ignore then return end
        ignore = true
        if b:IsMouseOver() then
          b:SetAlpha(1)
        else
          b:SetAlpha(0)
        end
        ignore = nil
      end

      local function showMicroMenu(self)
          for _, v in ipairs(MICRO_BUTTONS) do
              ignore = true
              _G[v]:SetAlpha(1)
              ignore = nil
          end
      end
      
      local function hideMicroMenu(self)
          for _, v in ipairs(MICRO_BUTTONS) do
              ignore = true
              _G[v]:SetAlpha(0)
              ignore = nil
          end
      end
      
      for _, v in ipairs(MICRO_BUTTONS) do
          v = _G[v]
          hooksecurefunc(v, "SetAlpha", setAlphaMicroMenu)
          v:HookScript("OnEnter", showMicroMenu)
          v:HookScript("OnLeave", hideMicroMenu)
          v:SetAlpha(0)
      end
    end

    if (db.menu.mouseoverbags) then
      -- Bags bar
      for _, frame in pairs(BagButtons) do
        frame:SetAlpha(0)
        frame:SetScript('OnEnter', function()
        MainMenuBarBackpackButton:SetAlpha(1)
        CharacterBag0Slot:SetAlpha(1)
        CharacterBag1Slot:SetAlpha(1)
        CharacterBag2Slot:SetAlpha(1)
        CharacterBag3Slot:SetAlpha(1)
        KeyRingButton:SetAlpha(1)
      end)
      frame:SetScript('OnLeave', function()
        if not (MouseIsOver(frame)) then
          MainMenuBarBackpackButton:SetAlpha(0)
          CharacterBag0Slot:SetAlpha(0)
          CharacterBag1Slot:SetAlpha(0)
          CharacterBag2Slot:SetAlpha(0)
          CharacterBag3Slot:SetAlpha(0)
          KeyRingButton:SetAlpha(0)
          end
        end)
      end
    end
  end
end
