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
				CompactPartyFrame:SetScale(db.size)
			end)
		end
	end
end