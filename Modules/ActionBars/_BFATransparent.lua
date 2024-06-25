local Module = SUI:NewModule("ActionBars.BFATransparent");

function Module:OnEnable()
  local db = SUI.db.profile.actionbar

  if not (db.style == 'BFATransparent' or db.style == 'BFA') then
    RetailUIArtFrame:Hide()
    RetailUIStatusBars:Hide()
    MicroButtonAndBagsBar:Hide()
  end

  -- Get Player class
  local playerClass = UnitClass("player")

  if (db.style == 'BFATransparent') then
	MicroButtonAndBagsBar:Hide()
    MainMenuBarTextureExtender:Hide()
    --------------------==≡≡[ HIDE DEFAULT BLIZZARD ART ]≡≡==-----------------------------------
	local function HideDefaultBlizzardArt()
		-- Hide default Blizzard bar textures
		for i = 0,  3 do
			_G["MainMenuBarTexture" .. i]:Hide()
		end
		MainMenuBarPerformanceBar:Hide()
		MainMenuBarPageNumber:Hide()
	end
	--------------------==≡≡[ ACTIONBARS/BUTTONS POSITIONING AND SCALING ]≡≡==-----------------------------------
	-- Only needs to be run once, or when leaving combat.
	local function Initial_ActionBarPositioning()
		-- Ensures these frames don't move up when player is max level
		UIPARENT_MANAGED_FRAME_POSITIONS.PossessBarFrame.maxLevel = 0
		UIPARENT_MANAGED_FRAME_POSITIONS.MultiCastActionBarFrame.maxLevel = 0

		-- Ensures these bars don't move when reputation bar is toggled, or when
		-- player is max level
		UIPARENT_MANAGED_FRAME_POSITIONS.StanceBarFrame = nil
		UIPARENT_MANAGED_FRAME_POSITIONS.MultiBarBottomLeft = nil

		if not InCombatLockdown() then
			-- Bottom left action button Position
			MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 13)

			-- Bottom right action button Position
			MultiBarBottomRight:SetPoint("LEFT", MultiBarBottomLeft, "RIGHT", 43, 0)

			-- Bottom right action button Wrapping
			MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomRight, 0, -50)

			-- Action bar page arrow Positions
			ActionBarUpButton:SetPoint("CENTER", MainMenuBar, "BOTTOMLEFT", 521, 30)
			ActionBarDownButton:SetPoint("CENTER", ActionBarUpButton, "BOTTOM", 0, -3)

			-- Pet bar texture Position (Visibility when bottom left bar is hidden)
			SlidingActionBarTexture0:SetAlpha(0)
			SlidingActionBarTexture1:SetAlpha(0)
		end
	end

	local shortBarActive

	local function ActivateShortBar()
		shortBarActive = true

		-- Toggle art
		RetailUIArtFrame.BackgroundSmall:Hide()
		RetailUIArtFrame.BackgroundLarge:Hide()

		-- Main menu bar Size
		MainMenuBar:SetSize(550, 53)

		-- Action bar page number Position
		MainMenuBarPageNumber:SetPoint("BOTTOMLEFT", MainMenuBar, 537, 16.5)

		-- Gryphon Positions
		MainMenuBarLeftEndCap:ClearAllPoints()
		MainMenuBarLeftEndCap:SetPoint("RIGHT", RetailUIArtFrame, "LEFT", 30, 20)
		MainMenuBarRightEndCap:ClearAllPoints()
		MainMenuBarRightEndCap:SetPoint("LEFT", RetailUIArtFrame, "RIGHT", -30, 20)

		-- Status bars background
		RetailUIStatusBars.Background:SetWidth(540)
		RetailUIStatusBars.Background:Hide()
	end

	local function ActivateLongBar()
		shortBarActive = false

		-- Toggle art
		RetailUIArtFrame.BackgroundSmall:Hide()
		RetailUIArtFrame.BackgroundLarge:Hide()

		-- Main menu bar Size
		MainMenuBar:SetSize(804, 53)

		-- Action bar page number Position
		MainMenuBarPageNumber:SetPoint("BOTTOMLEFT", MainMenuBar, 536, 16.5)

		-- Gryphon positions
		MainMenuBarLeftEndCap:ClearAllPoints()
		MainMenuBarLeftEndCap:SetPoint("RIGHT", RetailUIArtFrame, "LEFT", -97, 20)
		MainMenuBarRightEndCap:ClearAllPoints()
		MainMenuBarRightEndCap:SetPoint("LEFT", RetailUIArtFrame, "RIGHT", 97, 20)

		-- Status bars background
		RetailUIStatusBars.Background:SetWidth(798)
	end

	local function Update_ActionBars()
		if not InCombatLockdown() then
			if MultiBarBottomLeft:IsShown() then
				if (playerClass == "Druid") then
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 10.5, 98)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 80)
				elseif (playerClass == "Death Knight") then
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 175, 98)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 41)
				else
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 10.5, 98)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 41)
				end
			else
				if (playerClass == "Druid") then
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 10.5, 52)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 32)
				elseif (playerClass == "Death Knight") then
					PetActionButton1:ClearAllPoints()
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 175, 52)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, -5)
				else
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 10.5, 52)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, -5)
				end
			end

			if MultiBarBottomRight:IsShown() then
				ActivateLongBar()
				if (playerClass == "Druid") then
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 425, 97)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 41)
				elseif (playerClass == "Death Knight") then
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 425, 97)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 41)
				else
					PetActionButton1:SetPoint("BOTTOMLEFT", MainMenuBar, "BOTTOMLEFT", 10, 97)
					StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBar, "TOPLEFT", 0, 41)
				end
				SlidingActionBarTexture0:SetAlpha(0)
				SlidingActionBarTexture1:SetAlpha(0)
				StanceBarLeft:SetAlpha(0)
				StanceBarRight:SetAlpha(0)
				StanceBarMiddle:SetAlpha(0)
			else
				ActivateShortBar()
				SlidingActionBarTexture0:SetAlpha(0)
				SlidingActionBarTexture1:SetAlpha(0)
				StanceBarLeft:SetAlpha(0)
				StanceBarRight:SetAlpha(0)
				StanceBarMiddle:SetAlpha(0)
			end

			Update_StatusBars()
		end
	end
	hooksecurefunc("MultiActionBar_Update", Update_ActionBars)

	-- Updates exhaustion tick position on experience bar width change
	local function Update_ExhaustionTick()
		if GetXPExhaustion() and ExhaustionTick ~= nil and ExhaustionTick:IsShown() then
			ExhaustionTick_OnEvent(ExhaustionTick, "UPDATE_EXHAUSTION")
		end
	end
	MainMenuExpBar:HookScript('OnSizeChanged', Update_ExhaustionTick)

	local function Toggle_StatusBars(SmallUpper, Small, LargeUpper, Large)
		if SmallUpper then
			RetailUIStatusBars.SingleBarSmallUpper:Hide()
		else
			RetailUIStatusBars.SingleBarSmallUpper:Hide()
		end
		if Small then
			RetailUIStatusBars.SingleBarSmall:Hide()
		else
			RetailUIStatusBars.SingleBarSmall:Hide()
		end
		if LargeUpper then
			RetailUIStatusBars.SingleBarLargeUpper:Show()
		else
			RetailUIStatusBars.SingleBarLargeUpper:Hide()
		end
		if Large then
			RetailUIStatusBars.SingleBarLarge:Show()
		else
			RetailUIStatusBars.SingleBarLarge:Hide()
		end

		-- StatusBars' Widths
		if shortBarActive then
			ReputationWatchBar.StatusBar:SetWidth(540)
		else
			ReputationWatchBar.StatusBar:SetWidth(798)
		end
		if shortBarActive then
			MainMenuExpBar:SetWidth(540)
		else
			MainMenuExpBar:SetWidth(798)
		end

		local point, relativeTo, relativePoint, xOfs = RetailUIStatusBars:GetPoint()
		-- Two Status Bars are shown
		if (LargeUpper and Large) or (SmallUpper and Small) then
			-- Reputation bar text Position
			ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
			ReputationWatchBar.OverlayFrame.Text:SetPoint("CENTER", ReputationWatchBar, 0, 3)

			-- Reputation bar Size and Position
			ReputationWatchBar.StatusBar:SetHeight(7)
			ReputationWatchBar:ClearAllPoints()
			ReputationWatchBar:SetPoint("BOTTOM", UIParent, 0, 7)

			-- Experience bar Size and Position
			MainMenuExpBar:SetHeight(8)
			MainMenuExpBar:ClearAllPoints()
			MainMenuExpBar:SetPoint("BOTTOM", UIParent, 0, 0)

			-- StatusBars' Textures
			RetailUIStatusBars.SingleBarLargeUpper:SetHeight(10)
			RetailUIStatusBars.SingleBarLarge:SetHeight(10)
			RetailUIStatusBars.SingleBarSmallUpper:SetHeight(10)
			RetailUIStatusBars.SingleBarSmall:SetHeight(10)
			RetailUIStatusBars:SetPoint(point, relativeTo, relativePoint, xOfs, -1)

			-- Reputation texture Position
			RetailUIStatusBars.SingleBarLargeUpper:ClearAllPoints()
			RetailUIStatusBars.SingleBarLargeUpper:SetPoint(point, relativeTo, relativePoint, xOfs, 9)
			RetailUIStatusBars.SingleBarSmallUpper:SetPoint(point, relativeTo, relativePoint, xOfs, 9)

		-- Only reputation bar is shown (Max level)
		elseif (LargeUpper or SmallUpper) and not (Large and Small) then
			-- Reputation bar text Position
			ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
			ReputationWatchBar.OverlayFrame.Text:SetPoint("CENTER", ReputationWatchBar, 0, 2)

			-- Reputation bar Size and Position
			ReputationWatchBar.StatusBar:SetHeight(12)
			ReputationWatchBar:ClearAllPoints()
			ReputationWatchBar:SetPoint("BOTTOM", UIParent, 0, 0)

			-- Experience bar Size and Position
			MainMenuExpBar:SetHeight(12)
			MainMenuExpBar:ClearAllPoints()
			MainMenuExpBar:SetPoint("BOTTOM", UIParent, 0, 0)

			-- StatusBars' Texture Visilibity
			if shortBarActive then
				RetailUIStatusBars.SingleBarSmallUpper:Hide()
				RetailUIStatusBars.SingleBarSmall:Show()
			else
				RetailUIStatusBars.SingleBarLargeUpper:Hide()
				RetailUIStatusBars.SingleBarLarge:Show()
			end

			RetailUIStatusBars.SingleBarLargeUpper:SetHeight(14)
			RetailUIStatusBars.SingleBarLarge:SetHeight(14)
			RetailUIStatusBars.SingleBarSmallUpper:SetHeight(14)
			RetailUIStatusBars.SingleBarSmall:SetHeight(14)
			RetailUIStatusBars:SetPoint(point, relativeTo, relativePoint, xOfs, 1)

			-- Reputation texture Position
			RetailUIStatusBars.SingleBarLarge:ClearAllPoints()
			RetailUIStatusBars.SingleBarLarge:SetPoint(point, relativeTo, relativePoint, xOfs, 0)
			RetailUIStatusBars.SingleBarSmall:SetPoint(point, relativeTo, relativePoint, xOfs, 0)

		else
			-- Reputation bar text Position
			ReputationWatchBar.OverlayFrame.Text:ClearAllPoints()
			ReputationWatchBar.OverlayFrame.Text:SetPoint("CENTER", ReputationWatchBar, 0, 2)

			-- Reputation bar Size and Position
			ReputationWatchBar.StatusBar:SetHeight(12)
			ReputationWatchBar:ClearAllPoints()
			ReputationWatchBar:SetPoint("BOTTOM", UIParent, 0, 0)

			-- Experience bar Size and Position
			MainMenuExpBar:SetHeight(12)
			MainMenuExpBar:ClearAllPoints()
			MainMenuExpBar:SetPoint("BOTTOM", UIParent, 0, 0)

			-- StatusBars' Textures
			RetailUIStatusBars.SingleBarLargeUpper:SetHeight(14)
			RetailUIStatusBars.SingleBarLarge:SetHeight(14)
			RetailUIStatusBars.SingleBarSmallUpper:SetHeight(14)
			RetailUIStatusBars.SingleBarSmall:SetHeight(14)
			RetailUIStatusBars:SetPoint(point, relativeTo, relativePoint, xOfs, 1)

			-- Reputation texture Position
			RetailUIStatusBars.SingleBarLargeUpper:ClearAllPoints()
			RetailUIStatusBars.SingleBarLargeUpper:SetPoint(point, relativeTo, relativePoint, xOfs, 0)
			RetailUIStatusBars.SingleBarSmallUpper:SetPoint(point, relativeTo, relativePoint, xOfs, 0)
		end
	end

	local function ActionBar_SetYOffset(yOffset)
		-- Get current positions
		local bGPoint, bGRelTo, bGRelPoint, bGOffsetX = RetailUIArtFrame.BackgroundSmall:GetPoint()
		local actionsPoint, actionsRelTo, actionsRelPoint, actionsOffsetX = MainMenuBar:GetPoint()

		-- Reposition Background
		RetailUIArtFrame.BackgroundSmall:SetPoint(bGPoint, bGRelTo, bGRelPoint, bGOffsetX, yOffset)
		RetailUIArtFrame.BackgroundLarge:SetPoint(bGPoint, bGRelTo, bGRelPoint, bGOffsetX, yOffset)

		-- Reposition MainMenuBar (moves all actions)
		MainMenuBar:SetPoint(actionsPoint, actionsRelTo, actionsRelPoint, actionsOffsetX, yOffset)
	end

	function Update_StatusBars()
		-- Reputation bar Font
		ReputationWatchBar.OverlayFrame.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")

		-- Hide default reputation and experience bar textures
		for i = 0, 3 do
			_G["MainMenuXPBarTexture" .. i]:Hide()
			_G.ReputationWatchBar.StatusBar["WatchBarTexture" .. i]:Hide()
			-- Max level stuff to hide (When experience bar is hidden)
			_G["MainMenuMaxLevelBar" .. i]:Hide()
			_G.ReputationWatchBar.StatusBar["XPBarTexture" .. i]:Hide()
		end
		MainMenuExpBar:SetFrameStrata("LOW")
		ExhaustionTick:SetFrameStrata("MEDIUM")

		-- Experience bar text Position
		MainMenuBarExpText:ClearAllPoints()
		MainMenuBarExpText:SetPoint("CENTER", MainMenuExpBar, 0, 1)
		-- Experience bar Font
		MainMenuBarExpText:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
		-- Experience bar text Strata
		MainMenuBarOverlayFrame:SetFrameStrata("MEDIUM")

		if ReputationWatchBar:IsShown() and MainMenuExpBar:IsShown() then
			if shortBarActive then
				Toggle_StatusBars(true, true)
			else
				Toggle_StatusBars(false, false, true, true)
			end
			ActionBar_SetYOffset(19)

		elseif ReputationWatchBar:IsShown() then
			if shortBarActive then
				Toggle_StatusBars(true)
			else
				Toggle_StatusBars(false, false, true)
			end
			ActionBar_SetYOffset(13)

		elseif MainMenuExpBar:IsShown() then
			if shortBarActive then
				Toggle_StatusBars(false, true)
			else
				Toggle_StatusBars(false, false, false, true)
			end
			ActionBar_SetYOffset(13)

		else -- No status bar is shown (Shown at Max level with no reputation bar)
			Toggle_StatusBars()
			ActionBar_SetYOffset(0)
		end
	end
	ReputationWatchBar:HookScript('OnShow', Update_StatusBars)
	ReputationWatchBar:HookScript('OnHide', Update_StatusBars)
	MainMenuExpBar:HookScript('OnShow', Update_StatusBars)
	MainMenuExpBar:HookScript('OnHide', Update_StatusBars)
	hooksecurefunc("MainMenuTrackingBar_Configure", Update_StatusBars)



	--------------------==≡≡[ PET ACTION BAR ]≡≡==-----------------------------------

	-- Disallow Pet Action Bar offset if player is at max level
	local function PetActionBar_DisallowMaxLevelOffset()
		UIPARENT_MANAGED_FRAME_POSITIONS.PETACTIONBAR_YPOS.maxLevel = 0
	end

	-- Disallow Pet Action Bar offset if the reputation watch bar is shown
	-- NOTE: Unsafe to call in combat
	local function PetActionBar_DisallowReputationOffset()
		UIPARENT_MANAGED_FRAME_POSITIONS.PETACTIONBAR_YPOS.watchBar = 0
	end

	local function SetYOffset(Frame, yOffset)
		local point, relativeTo, relativePoint, xOffset = Frame:GetPoint()
		Frame:ClearAllPoints()
		Frame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
	end

	-- Safely calls PetActionBar_DisallowReputationOffset once when leaving combat
	local function PetActionBar_SafelyDisallowReputationOffset()
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")
		f:SetScript("OnEvent", function(self)
			PetActionBar_DisallowReputationOffset()
			MultiActionBar_Update()
			self:UnregisterAllEvents()
		end)
	end

	PetActionBar_DisallowMaxLevelOffset()

	-- Timer ensures "inCombat" boolean is accurate on load
	-- This is crucial to prevent pet action bar becoming stuck and taint occuring
	C_Timer.After(0, function()
		-- See https://authors.curseforge.com/forums/world-of-warcraft/general-chat/lua-code-discussion/225680-problem-with-incombatlockdown
		local inCombat = UnitAffectingCombat("player") or InCombatLockdown()
		if inCombat then
			PetActionBar_SafelyDisallowReputationOffset()
		else
			PetActionBar_DisallowReputationOffset()
		end
	end)

	--------------------==≡≡[ GENERAL EVENTS ]≡≡==-----------------------------------

	-- Runs on Login
	-- Most information about the game world should now be available to the UI
	SESSION_XPBARTEXT_CVAR = GetCVarBool("xpBarText")
	HideDefaultBlizzardArt()
	Initial_ActionBarPositioning()
	Update_ActionBars()

	local function ShowAsExperienceBarCheckbox_Disable()
		ReputationDetailMainScreenCheckBox:Disable()
		ReputationDetailMainScreenCheckBoxText:SetTextColor(0.5, 0.5, 0.5)
		ReputationDetailMainScreenCheckBoxText:SetText("(Can't toggle in combat)")
	end

	local function ActionBarCheckboxes_Disable()
		InterfaceOptionsActionBarsPanelBottomLeft:Disable()
		_G[InterfaceOptionsActionBarsPanelBottomLeft:GetName() .. "Text"]:SetText(
			"Show Bottom Left ActionBar (can't toggle in combat)"
		)
		InterfaceOptionsActionBarsPanelBottomRight:Disable()
		_G[InterfaceOptionsActionBarsPanelBottomRight:GetName() .. "Text"]:SetText(
			"Show Bottom Right ActionBar (can't toggle in combat)"
		)
	end

	local function PlayerEnteredCombat()
		ShowAsExperienceBarCheckbox_Disable()
		ActionBarCheckboxes_Disable()
	end
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:SetScript("OnEvent", PlayerEnteredCombat)

	local ShowAsExperienceBarCheckbox_Text = ReputationDetailMainScreenCheckBoxText:GetText()

	local function ShowAsExperienceBarCheckbox_Enable()
		ReputationDetailMainScreenCheckBox:Enable()
		ReputationDetailMainScreenCheckBoxText:SetTextColor(1, 0.82, 0)
		ReputationDetailMainScreenCheckBoxText:SetText(
			ShowAsExperienceBarCheckbox_Text
		)
	end

	local function ActionBarCheckboxes_Enable()
		InterfaceOptionsActionBarsPanelBottomLeft:Enable()
		_G[InterfaceOptionsActionBarsPanelBottomLeft:GetName() .. "Text"]:SetText(
			"Show Bottom Left ActionBar"
		)
		InterfaceOptionsActionBarsPanelBottomRight:Enable()
		_G[InterfaceOptionsActionBarsPanelBottomRight:GetName() .. "Text"]:SetText(
			"Show Bottom Right ActionBar"
		)
	end

	local function PlayerLeftCombat()
		ShowAsExperienceBarCheckbox_Enable()
		ActionBarCheckboxes_Enable()

		-- Update layout
		Initial_ActionBarPositioning()
		Update_ActionBars()
	end
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:SetScript("OnEvent", PlayerLeftCombat)
  end
end