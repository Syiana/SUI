local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		--BLACK SKIN
		local function update()
			local i = 1
			repeat

			-- check if raid or party
			if (UnitInRaid("player")) then
				frame = "CompactRaidFrame"
			else
				frame = "CompactPartyFrameMember"
			end

			local hbar = _G[frame .. i .. "HealthBar"]
			local rbar = _G[frame .. i .. "PowerBar"]
			local Divider = _G[frame .. i .. "HorizDivider"]
			local vleftseparator = _G[frame .. i .. "VertLeftBorder"]
			local vrightseparator = _G[frame .. i .. "VertRightBorder"]
			local htopseparator = _G[frame .. i .. "HorizTopBorder"]
			local hbotseparator = _G[frame .. i .. "HorizBottomBorder"]
			local bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
			local bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
			local bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
			local borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
			local borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
			local borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
			local borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
			local borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]

			-- check if the frame exists
			if (hbar and rbar) then
				--STATUSBAR
				if (db.texture ~= 'Default') then
					hbar:SetStatusBarTexture(db.texture)
					rbar:SetStatusBarTexture(db.texture)
				end
				--DARK
				bordertopleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperLeft")
				bordertop:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperMiddle")
				bordertopright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-UpperRight")
				borderleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-Left")
				borderright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-Right")
				borderbottomleft:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomLeft")
				borderbottom:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomMiddle")
				borderbottomright:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\RaidBorder-BottomRight")
				vleftseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-VSeparator")
				vrightseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-VSeparator")
				htopseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-HSeparator")
				hbotseparator:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\RaidFrames\\Raid-HSeparator")

				Divider:SetVertexColor(.3, .3, .3)
			end
			i = i + 1 until not hbar
		end

		--hook
		hooksecurefunc(CompactRaidFrameContainer, "AddUnitFrame", update)
		hooksecurefunc("CompactUnitFrame_UpdateAll", update)

		-- Hide Titles
		CompactPartyFrameTitle:Hide()
	end
end