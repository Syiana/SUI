local Module = SUI:NewModule("RaidFrames.Core");

function Module:OnEnable()
  local db = SUI.db.profile.raidframes
	if (db) then
		-- Hide Titles
		CompactPartyFrameTitle:Hide()
		if (db.size) then
			local Size = CreateFrame("Frame")
			Size:RegisterEvent("ADDON_LOADED")
			Size:RegisterEvent("PLAYER_LOGIN")
			Size:RegisterEvent("PLAYER_ENTERING_WORLD")
			Size:RegisterEvent("VARIABLES_LOADED")
			Size:SetScript("OnEvent", function()
				for i=1,5 do
					_G["CompactPartyFrameMember" ..i]:SetWidth(db.width)
					_G["CompactPartyFrameMember" ..i]:SetHeight(db.height)
					_G["CompactPartyFrameMember" ..i.."StatusText"]:ClearAllPoints()
					_G["CompactPartyFrameMember" ..i.."StatusText"]:SetPoint("CENTER", _G["CompactPartyFrameMember" ..i], "CENTER")
					_G["CompactPartyFrameMember" ..i.."StatusText"]:SetFont(STANDARD_TEXT_FONT, 20, "")
				end
			end)
		end
	end
end