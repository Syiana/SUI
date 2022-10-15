local Module = SUI:NewModule("ActionBars.Small");

function Module:OnEnable()
  local db = SUI.db.profile.actionbar

  if (db.style == 'Small') then
    local size = db.buttons.size
    local spacing = 5
    MainMenuBar:SetWidth(1)

    local invisible = CreateFrame("Frame", nil)
    invisible:EnableMouse(false)
    invisible:Hide()

    local BlizzArt = {
      MainMenuBarArtFrameBackground,
      MainMenuBarTexture0,
      MainMenuBarTexture1,
      MainMenuBarTexture2,
      MainMenuBarTexture3,
      MainMenuBarLeftEndCap,
      MainMenuBarRightEndCap,
      ActionBarUpButton,
      ActionBarDownButton,
      ReputationWatchBar,
      MainMenuExpBar,
      ArtifactWatchBar,
      HonorWatchBar,
      MainMenuBarPageNumber,
      MainMenuBarPerformanceBar,
      MainMenuBarPerformanceBarFrameButton,
      SlidingActionBarTexture0,
      SlidingActionBarTexture1,
      MainMenuMaxLevelBar0,
      MainMenuMaxLevelBar1,
      MainMenuMaxLevelBar2,
      MainMenuMaxLevelBar3,
      StanceButton1.bg,
      StanceButton2.bg,
      StanceButton3.bg,
      StanceButton4.bg,
      StanceButton5.bg,
      StanceButton6.bg,
      StanceButton7.bg,
      StanceButton8.bg,
      StanceBarLeft,
      StanceBarMiddle,
      StanceBarRight,
    }

    for _, frame in pairs(BlizzArt) do
      frame:SetParent(invisible)
    end

    local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent)
    holder:SetSize(size * 12 + spacing * 11, size)
    holder:SetPoint("BOTTOM", UIParent, 0, 22)

    local function updatePositions()
      ActionButton1:ClearAllPoints()
      ActionButton1:SetPoint("BOTTOMLEFT", holder, 0, 0)

      MultiBarBottomLeftButton1:ClearAllPoints()
      MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 5)

      MultiBarBottomRightButton1:ClearAllPoints()
      MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6)

      MultiBarBottomRightButton7:ClearAllPoints()
      MultiBarBottomRightButton7:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton7, "TOPLEFT", 0, 6)

      MultiBarLeftButton1:ClearAllPoints()
      MultiBarLeftButton1:SetPoint("TOPLEFT", MultiBarRightButton1, "TOPLEFT", -43, 0)

      MultiBarRightButton1:ClearAllPoints()
      MultiBarRightButton1:SetPoint("RIGHT", UIParent, "RIGHT", -2, 150)

      -- Get Player class
      local playerClass = UnitClass("player")

      -- Pet Action Bar
      if (SHOW_MULTI_ACTIONBAR_2) then
        if (playerClass == "Druid") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, 11)
        elseif (playerClass == "Death Knight") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 150, 5)
        else
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, 11)
        end
      elseif (SHOW_MULTI_ACTIONBAR_1) then
        if (playerClass == "Druid") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, -33)
        elseif (playerClass == "Death Knight" or playerClass == "Paladin") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 150, -35)
        else
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, -33)
        end
      else
        if (playerClass == "Druid") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, -75)
        elseif (playerClass == "Death Knight") then
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 150, -73)
        else
          PetActionButton1:ClearAllPoints()
          PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 3, -75)
        end
      end

      -- Stance Bar
      StanceButton2:SetPoint("TOPLEFT", StanceButton1, 32.5, 0)
      StanceButton3:SetPoint("TOPLEFT", StanceButton1, 65, 0)
      StanceButton4:SetPoint("TOPLEFT", StanceButton1, 97.5, 0)
      StanceButton5:SetPoint("TOPLEFT", StanceButton1, 130, 0)
      StanceButton6:SetPoint("TOPLEFT", StanceButton1, 162.5, 0)
      StanceButton7:SetPoint("TOPLEFT", StanceButton1, 195, 0)
      StanceButton8:SetPoint("TOPLEFT", StanceButton1, 227.5, 0)

      StanceBarFrame:SetMovable(true)
      StanceBarFrame:ClearAllPoints()
      StanceBarFrame:SetUserPlaced(true)
      if (SHOW_MULTI_ACTIONBAR_2) then
        if (playerClass == "Druid") then
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, 75)
        else
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, 35)
        end
      elseif (SHOW_MULTI_ACTIONBAR_1) then
        if (playerClass == "Druid") then
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, 30)
        else
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, -5)
        end
      else
        if (playerClass == "Druid") then
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, -12)
        else
          StanceBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", -8, -45)
        end
      end
    end
    updatePositions()
    hooksecurefunc("SetActionBarToggles", updatePositions)

    -- Shaman Totem Bar
    local fixing -- flag to prevent infinite looping
    hooksecurefunc(MultiCastActionBarFrame, "SetPoint", function()
        -- if this call came from your hook, or you're in combat, exit:
        if fixing or InCombatLockdown() then
              return
        end
        -- set the flag so our SetPoint call doesn't trigger an infinite loop:
        fixing = true
        -- move the frame as desired:
        if (SHOW_MULTI_ACTIONBAR_2) then
          MultiCastActionBarFrame:ClearAllPoints()
          MultiCastActionBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 45)
        elseif (SHOW_MULTI_ACTIONBAR_1) then
          MultiCastActionBarFrame:ClearAllPoints()
          MultiCastActionBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 0)
        else
          MultiCastActionBarFrame:ClearAllPoints()
          MultiCastActionBarFrame:SetPoint("TOPLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, -45)
        end
        -- unset the flag so the next call from Blizzard code will trigger your hook:
        fixing = nil
    end)

    for i = 1, NUM_ACTIONBAR_BUTTONS do
      local ab = _G["ActionButton" .. i]
      local mbbl = _G["MultiBarBottomLeftButton" .. i]
      local mbbr = _G["MultiBarBottomRightButton" .. i]
      local mbl = _G["MultiBarLeftButton" .. i]
      local mbr = _G["MultiBarRightButton" .. i]
      local pab = _G["PetActionButton" .. i]
      local mcab = _G["MultiCastActionButton" .. i]
      local pb = _G["PossessButton" .. i]

      ab:SetSize(size, size)
      mbbl:SetSize(size, size)
      mbbr:SetSize(size, size)
      mbl:SetSize(size, size)
      mbr:SetSize(size, size)

      if pab then
      --pab:SetSize(size, size)
      end

      if pb then
      pb:SetSize(size, size)
      end
    end

    local Module = CreateFrame('Frame')
    local _G = _G
    local next = _G.next
    local pairs = _G.pairs
    local unpack = _G.unpack

    local HasAction = _G.HasAction
    local IsActionInRange = _G.IsActionInRange
    local IsUsableAction = _G.IsUsableAction

    local UPDATE_DELAY = .2
    local buttonColors, buttonsToUpdate = {}, {}
    local updater = CreateFrame("Frame")

    local colors = {
      ["normal"] = {1, 1, 1},
      ["oor"] = {.8, .1, .1},
      ["oom"] = {.5, .5, 1},
      ["unusable"] = {.3, .3, .3}
    }

    function Module:OnUpdateRange(elapsed)
      self.elapsed = (self.elapsed or UPDATE_DELAY) - elapsed
      if self.elapsed <= 0 then
        self.elapsed = UPDATE_DELAY

        if not Module:UpdateButtons() then
          self:Hide()
        end
      end
    end
    updater:SetScript("OnUpdate", Module.OnUpdateRange)

    function Module:UpdateButtons()
      if next(buttonsToUpdate) then
        for button in pairs(buttonsToUpdate) do
          self.UpdateButtonUsable(button)
        end
        return true
      end

      return false
    end

    function Module:UpdateButtonStatus()
      local action = self.action

      if action and self:IsVisible() and HasAction(action) then
        buttonsToUpdate[self] = true
      else
        buttonsToUpdate[self] = nil
      end

      if next(buttonsToUpdate) then
        updater:Show()
      end
    end

    function Module:UpdateButtonUsable(force)
      if force then
        buttonColors[self] = nil
      end

      local action = self.action
      local isUsable, notEnoughMana = IsUsableAction(action)

      if isUsable then
        local inRange = IsActionInRange(action)
        if inRange == false then
          Module.SetButtonColor(self, "oor")
        else
          Module.SetButtonColor(self, "normal")
        end
      elseif notEnoughMana then
        Module.SetButtonColor(self, "oom")
      else
        Module.SetButtonColor(self, "unusable")
      end
    end

    function Module:SetButtonColor(colorIndex)
      if buttonColors[self] == colorIndex then
        return
      end
      buttonColors[self] = colorIndex

      local r, g, b = unpack(colors[colorIndex])
      self.icon:SetVertexColor(r, g, b)
    end

    function Module:Register()
      self:HookScript("OnShow", Module.UpdateButtonStatus)
      self:HookScript("OnHide", Module.UpdateButtonStatus)
      self:SetScript("OnUpdate", nil)
      Module.UpdateButtonStatus(self)
    end

    local function button_UpdateUsable(button)
      Module.UpdateButtonUsable(button, true)
    end

    function Module:RegisterButtonRange(button)
      if button.Update then
        Module.Register(button)
        hooksecurefunc(button, "Update", Module.UpdateButtonStatus)
        hooksecurefunc(button, "UpdateUsable", button_UpdateUsable)
      end
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
      Module:RegisterButtonRange(_G["ActionButton" .. i])
      Module:RegisterButtonRange(_G["MultiBarBottomLeftButton" .. i])
      Module:RegisterButtonRange(_G["MultiBarBottomRightButton" .. i])
      Module:RegisterButtonRange(_G["MultiBarRightButton" .. i])
      Module:RegisterButtonRange(_G["MultiBarLeftButton" .. i])
    end
  end
end