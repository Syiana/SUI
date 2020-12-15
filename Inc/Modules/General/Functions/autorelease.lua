local SUI=CreateFrame("Frame")
SUI:RegisterEvent("PLAYER_LOGIN")
SUI:SetScript("OnEvent", function(self, event)

if not SUIDB.MODULES.AUTORELEASE == true then return end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:SetScript("OnEvent", function(self, event)
	RepopMe()
end)
end)