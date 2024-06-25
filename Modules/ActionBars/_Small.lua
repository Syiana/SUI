local Module = SUI:NewModule("ActionBars.Small")

function Module:OnEnable()
	local db = SUI.db.profile.actionbar

	if (db.style == 'Small') then
		local size = db.buttons.size
		local spacing = db.buttons.padding

		local invisible = CreateFrame("Frame", nil)
		invisible:EnableMouse(false)
		invisible:Hide()

		local BlizzArt = {
			MainMenuBarTexture0,
			MainMenuBarTexture1,
			MainMenuBarTexture2,
			MainMenuBarTexture3,
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
			SlidingActionBarTexture0,
			SlidingActionBarTexture1,
			MainMenuBarTextureExtender,
			MainMenuBarMaxLevelBar
		}

		for _, frame in pairs(BlizzArt) do
			frame:SetParent(invisible)
			MainMenuExpBar:SetAlpha(0)
		end

		SUIMainMenuBar = CreateFrame("Frame", "SUIMainMenuBar", UIParent)
		SUIMainMenuBar:SetSize(size * 12 + spacing * 13, size)
		SUIMainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
		SUIMainMenuBar:SetMovable(true)

		SUIMultiBarBottomLeft = CreateFrame("Frame", "SUIMultiBarBottomLeft", UIParent)
		SUIMultiBarBottomLeft:SetSize(size * 12 + spacing * 13, size)
		SUIMultiBarBottomLeft:SetPoint("TOP", SUIMainMenuBar, "TOP", 0, 0)

		SUIMultiBarBottomRight = CreateFrame("Frame", "SUIMultiBarBottomRight", UIParent)
		SUIMultiBarBottomRight:SetSize(size * 12 + spacing * 13, size)
		SUIMultiBarBottomRight:SetPoint("TOP", SUIMultiBarBottomLeft, "TOP", 0, 0)

		SUIStanceBar = CreateFrame("Frame", "SUIStanceBar", UIParent)
		SUIStanceBar:SetSize(18 * NUM_STANCE_SLOTS, size)
		SUIStanceBar:SetPoint("TOP", SUIMultiBarBottomRight, "TOP", -45, 150)
		SUIStanceBar:SetMovable(true)

		SUIPetActionBar = CreateFrame("Frame", "SUIPetActionBar", UIParent)
		SUIPetActionBar:SetSize(14 * 10, size)
		SUIPetActionBar:SetPoint("TOP", SUIMultiBarBottomRight, "TOP", -45, 150)
		SUIPetActionBar:SetMovable(true)

		MultiCastActionBarFrame:SetMovable(true)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame:SetParent(UIParent)
		MultiCastActionBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 45, 150)

		hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", function()
			MainMenuBarVehicleLeaveButton:ClearAllPoints()
			MainMenuBarVehicleLeaveButton:SetPoint("LEFT", SUIMainMenuBar, "LEFT", -35, 25)
		end)

		MainMenuBarVehicleLeaveButton:ClearAllPoints()
		MainMenuBarVehicleLeaveButton:SetParent(UIParent)
		MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", UIParent, "BOTTOM", 45, 150)

		hooksecurefunc("MultiCastActionBarFrame_Update", function()
			MultiCastActionBarFrame.SetPoint = function() end
		end)

		hooksecurefunc("StanceBar_Update", function()
			StanceBarLeft:Hide()
			StanceBarMiddle:Hide()
			StanceBarRight:Hide()
		end)

		local function updatePositions()
			if (GetNumShapeshiftForms() > 0) then
				SUIStanceBar:Show()
			else
				SUIStanceBar:Hide()
			end
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G["ActionButton" .. i]
				local prevButton = _G["ActionButton" .. i - 1]

				button:ClearAllPoints()

				if (i == 1) then
					button:SetPoint("LEFT", SUIMainMenuBar, 0, 0)
				else
					button:SetPoint("LEFT", prevButton, size+spacing, 0)
				end
			end

			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G["MultiBarBottomLeftButton" .. i]
				local prevButton = _G["MultiBarBottomLeftButton" .. i - 1]

				button:ClearAllPoints()

				if (i == 1) then
					button:SetPoint("LEFT", SUIMultiBarBottomLeft, 0, 0)
				else
					button:SetPoint("LEFT", prevButton, size+spacing, 0)
				end
			end

			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G["MultiBarBottomRightButton" .. i]
				local prevButton = _G["MultiBarBottomRightButton" .. i - 1]

				button:ClearAllPoints()

				if (i == 1) then
					button:SetPoint("LEFT", SUIMultiBarBottomRight, 0, 0)
				else
					button:SetPoint("LEFT", prevButton, size+spacing, 0)
				end
			end

			for i = 1, NUM_STANCE_SLOTS do
				local button = _G["StanceButton"..i]
				local prevButton = _G["StanceButton"..i-1]

				button:ClearAllPoints()
				button:SetParent(SUIStanceBar)

				if (i == 1) then
					button:SetPoint("LEFT", SUIStanceBar, 0, 0)
				else
					button:SetPoint("LEFT", prevButton, 37.5, 0)
				end
			end

			for i = 1, NUM_PET_ACTION_SLOTS do
				local button = _G["PetActionButton"..i]
				local prevButton = _G["PetActionButton"..i-1]

				button:ClearAllPoints()

				if (i == 1) then
					button:SetPoint("LEFT", SUIPetActionBar, 0, 0)
				else
					button:SetPoint("LEFT", prevButton, 37.5, 0)
				end
			end

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
		end

		updatePositions()
		hooksecurefunc("SetActionBarToggles", updatePositions)

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
			mbl:SetSize(38, 38)
			mbr:SetSize(38, 38)

			if pb then
				pb:SetSize(size, size)
			end
		end
	end
end
