local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		--BLACK SKIN
		local function update()
			local i = 1
			local x = 1
			local hbar
			local rbar
			local Divider
			local vleftseparator 
			local vrightseparator
			local htopseparator
			local hbotseparator
			local bordertopleft
			local bordertop
			local bordertopright
			local borderleft
			local borderright
			local borderbottomleft
			local borderbottom
			local borderbottomright
			-- check if raid or party
			if UnitInRaid("player") then
				frame = "CompactRaidFrame"
			else
				frame = "CompactPartyFrameMember"
			end

			-- Check if Raid is being displayed as Combined Group or seperate groups
			if UnitInRaid("player") and not CompactRaidFrameContainer:UseCombinedGroups() then
				repeat
					bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
					bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
					bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
					borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
					borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
					borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
					borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
					borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]
					for x=1, 5 do
						hbar = _G["CompactRaidGroup" .. i .. "Member" .. x .. "HealthBar"]
						rbar = _G["CompactRaidGroup" .. i .. "Member" .. x .. "PowerBar"]

						if hbar and rbar then
							if (db.texture ~= [[Interface\Default]]) then
								hbar:SetStatusBarTexture(db.texture)
								rbar:SetStatusBarTexture(db.texture)
								print(i)
							end
						end
					end

					bordertopleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperLeft]])
					bordertop:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperMiddle]])
					bordertopright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-UpperRight]])
					borderleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Left]])
					borderright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-Right]])
					borderbottomleft:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomLeft]])
					borderbottom:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomMiddle]])
					borderbottomright:SetTexture([[Interface\Addons\SUI\Media\Textures\RaidFrames\RaidBorder-BottomRight]])
				i = i + 1 until not hbar
			else
				repeat
					hbar = _G[frame .. i .. "HealthBar"]
					rbar = _G[frame .. i .. "PowerBar"]
					Divider = _G[frame .. i .. "HorizDivider"]
					vleftseparator = _G[frame .. i .. "VertLeftBorder"]
					vrightseparator = _G[frame .. i .. "VertRightBorder"]
					htopseparator = _G[frame .. i .. "HorizTopBorder"]
					hbotseparator = _G[frame .. i .. "HorizBottomBorder"]
					bordertopleft = _G["CompactRaidFrameContainerBorderFrameBorderTopLeft"]
					bordertop = _G["CompactRaidFrameContainerBorderFrameBorderTop"]
					bordertopright = _G["CompactRaidFrameContainerBorderFrameBorderTopRight"]
					borderleft = _G["CompactRaidFrameContainerBorderFrameBorderLeft"]
					borderright = _G["CompactRaidFrameContainerBorderFrameBorderRight"]
					borderbottomleft = _G["CompactRaidFrameContainerBorderFrameBorderBottomLeft"]
					borderbottom = _G["CompactRaidFrameContainerBorderFrameBorderBottom"]
					borderbottomright = _G["CompactRaidFrameContainerBorderFrameBorderBottomRight"]

					-- check if the frame exists
					if (hbar and rbar) then
						--STATUSBAR
						if (db.texture ~= [[Interface\Default]]) then
							hbar:SetStatusBarTexture(db.texture)
							rbar:SetStatusBarTexture(db.texture)
						end
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
				i = i + 1 until not hbar
			end
		end

		local setTexture = CreateFrame("Frame")
		setTexture:RegisterEvent("ADDON_LOADED")
		setTexture:RegisterEvent("PLAYER_LOGIN")
		setTexture:RegisterEvent("VARIABLES_LOADED")
		setTexture:RegisterEvent("PLAYER_ENTERING_WORLD")
		setTexture:RegisterEvent("GROUP_ROSTER_UPDATE")
		setTexture:RegisterEvent("PLAYER_REGEN_ENABLED")
		setTexture:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
		setTexture:RegisterEvent("UPDATE_EXPANSION_LEVEL")
		setTexture:RegisterEvent("ARTIFACT_XP_UPDATE")
		setTexture:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")
		setTexture:RegisterUnitEvent("UNIT_LEVEL", "player")
		setTexture:SetScript("OnEvent", update)

		-- Hide Titles
		CompactPartyFrameTitle:Hide()
		if (db.size and db.height and db.width) then
			local Size = CreateFrame("Frame")
			Size:RegisterEvent("ADDON_LOADED")
			Size:RegisterEvent("PLAYER_LOGIN")
			Size:RegisterEvent("VARIABLES_LOADED")
			Size:RegisterEvent("PLAYER_ENTERING_WORLD")
			Size:RegisterEvent("GROUP_ROSTER_UPDATE")
			Size:RegisterEvent("PLAYER_REGEN_ENABLED")
			Size:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
			Size:RegisterEvent("UPDATE_EXPANSION_LEVEL")
			Size:RegisterEvent("ARTIFACT_XP_UPDATE")
			Size:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")
			Size:RegisterUnitEvent("UNIT_LEVEL", "player")
			Size:SetScript("OnEvent", function()
				for i=1,5 do
					_G["CompactPartyFrameMember" ..i]:SetWidth(db.width)
					_G["CompactPartyFrameMember" ..i]:SetHeight(db.height)
					_G["CompactPartyFrameMember" ..i.."StatusText"]:ClearAllPoints()
					_G["CompactPartyFrameMember" ..i.."StatusText"]:SetPoint("CENTER", _G["CompactPartyFrameMember" ..i], "CENTER")
				end
			end)

			hooksecurefunc(C_EditMode, "OnEditModeExit", function()
				for i=1,5 do
					_G["CompactPartyFrameMember" ..i]:SetWidth(db.width)
					_G["CompactPartyFrameMember" ..i]:SetHeight(db.height)
					_G["CompactPartyFrameMember" ..i.."StatusText"]:ClearAllPoints()
					_G["CompactPartyFrameMember" ..i.."StatusText"]:SetPoint("CENTER", _G["CompactPartyFrameMember" ..i], "CENTER")
				end
			end)
		end
	end
end