local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		--BLACK SKIN
		local function updateCombined()
			local i = 1
			repeat

			local inInstance, instanceType = IsInInstance("player")

			-- check if raid or party
			if inInstance then
				if instanceType == 'arena' then
					frame = "CompactPartyFrameMember"
				else
					if UnitInRaid("player") then
						frame = "CompactRaidFrame"
					else
						frame = "CompactPartyFrameMember"
					end
				end
			else
				if UnitInRaid("player") then
					frame = "CompactRaidFrame"
				else
					frame = "CompactPartyFrameMember"
				end
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
				if (db.texture ~= [[Interface\Default]]) then
					hbar:SetStatusBarTexture(db.texture)
					hbar:GetStatusBarTexture():SetDrawLayer("BORDER")
					rbar:SetStatusBarTexture(db.texture)
					rbar:GetStatusBarTexture():SetDrawLayer("BORDER")
				end

				--DARK
				bordertopleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperLeft]])
				bordertop:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperMiddle]])
				bordertopright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperRight]])
				borderleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Left]])
				borderright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Right]])
				borderbottomleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomLeft]])
				borderbottom:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomMiddle]])
				borderbottomright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomRight]])
				vleftseparator:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-VSeparator]])
				vrightseparator:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-VSeparator]])
				htopseparator:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-HSeparator]])
				hbotseparator:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\Raid-HSeparator]])

				Divider:SetVertexColor(.3, .3, .3)
			end
			i = i + 1 until not hbar
		end

		local function updateSeperate()
			local i = 1
			repeat

			local hbar
			local rbar
			local bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
			local bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
			local bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
			local borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
			local borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
			local borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
			local borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
			local borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]
			for x=1, 5 do
				hbar = _G["CompactRaidGroup" .. i .. "Member" .. x .. "HealthBar"]
				rbar = _G["CompactRaidGroup" .. i .. "Member" .. x .. "PowerBar"]

				if hbar and rbar then
					if (db.texture ~= [[Interface\Default]]) then
						hbar:SetStatusBarTexture(db.texture)
						hbar:GetStatusBarTexture():SetDrawLayer("BORDER")
						rbar:SetStatusBarTexture(db.texture)
						rbar:GetStatusBarTexture():SetDrawLayer("BORDER")
					end

					bordertopleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperLeft]])
					bordertop:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperMiddle]])
					bordertopright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperRight]])
					borderleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Left]])
					borderright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Right]])
					borderbottomleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomLeft]])
					borderbottom:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomMiddle]])
					borderbottomright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomRight]])
				end
			end
			i = i + 1 until not hbar
		end

		local setTexture = CreateFrame("Frame")
		setTexture:RegisterEvent("ADDON_LOADED")
		setTexture:RegisterEvent("PLAYER_LOGIN")
		setTexture:RegisterEvent("VARIABLES_LOADED")
		setTexture:RegisterEvent("PLAYER_ENTERING_WORLD")
		setTexture:RegisterEvent("GROUP_ROSTER_UPDATE")
		setTexture:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
		setTexture:RegisterUnitEvent("UNIT_LEVEL", "player")
		if UnitInRaid("player") and not CompactRaidFrameContainer:UseCombinedGroups() then
			setTexture:SetScript("OnEvent", updateSeperate)
		else
			setTexture:SetScript("OnEvent", updateCombined)
		end

		hooksecurefunc(C_EditMode, "OnEditModeExit", function()
			if UnitInRaid("player") and not CompactRaidFrameContainer:UseCombinedGroups() then
				updateSeperate()
			else
				updateCombined()
			end
		end)

		local function updateSize()
			for i=1,5 do
				_G["CompactPartyFrameMember" ..i]:SetWidth(db.width)
				_G["CompactPartyFrameMember" ..i]:SetHeight(db.height)
				_G["CompactPartyFrameMember" ..i.."StatusText"]:ClearAllPoints()
				_G["CompactPartyFrameMember" ..i.."StatusText"]:SetPoint("CENTER", _G["CompactPartyFrameMember" ..i], "CENTER")
				_G["CompactPartyFrameMember" ..i.."CenterStatusIcon"]:ClearAllPoints()
				_G["CompactPartyFrameMember" ..i.."CenterStatusIcon"]:SetPoint("CENTER", _G["CompactPartyFrameMember" ..i], "CENTER")
			end
		end

		-- Hide Titles
		CompactPartyFrameTitle:Hide()

		-- Update PartyFrame Size
		if (db.size) then
			local Size = CreateFrame("Frame")
			Size:RegisterEvent("ADDON_LOADED")
			Size:RegisterEvent("PLAYER_LOGIN")
			Size:RegisterEvent("VARIABLES_LOADED")
			Size:RegisterEvent("PLAYER_ENTERING_WORLD")
			Size:RegisterEvent("GROUP_ROSTER_UPDATE")
			Size:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
			Size:SetScript("OnEvent", updateSize)

			hooksecurefunc(C_EditMode, "OnEditModeExit", updateSize)
		end
	end
end