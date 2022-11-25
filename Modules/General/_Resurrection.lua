local Module = SUI:NewModule("General.Resurrection");

function Module:OnEnable() ------------------------------------------------------
	local resurrect = CreateFrame("Frame")
	resurrect:RegisterEvent("RESURRECT_REQUEST")
	resurrect:SetScript("OnEvent", function(_, event, name)
		if event == "RESURRECT_REQUEST" then
			if not UnitAffectingCombat(name) then
				AcceptResurrect()
				StaticPopup_Hide("RESURRECT_NO_TIMER")
			end
		end
	end)
end
