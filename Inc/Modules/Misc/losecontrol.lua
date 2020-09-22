local SUI=CreateFrame("Frame")
SUI:RegisterEvent("PLAYER_LOGIN")
SUI:SetScript("OnEvent", function(self, event)

if not SUIDB.MODULES.LOSECONTROL == true then return end

LossOfControlFrame:ClearAllPoints()
LossOfControlFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
select(1, LossOfControlFrame:GetRegions()):SetAlpha(0)
select(2, LossOfControlFrame:GetRegions()):SetAlpha(0)
select(3, LossOfControlFrame:GetRegions()):SetAlpha(0)

end)