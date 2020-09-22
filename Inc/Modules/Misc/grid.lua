--[[SUI SGRID v1.0]]

local CF=CreateFrame("Frame")
CF:RegisterEvent("PLAYER_LOGIN")
CF:SetScript("OnEvent", function(self, event)

SLASH_GRID1 = "/grid"

local f
local w
local h
SlashCmdList["GRID"] = function(msg, editbox)
	if f then
		f:Hide()
		f = nil
	else
		f = CreateFrame('Frame', nil, UIParent)
		f:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', i * w - 1, 0)
			t:SetPoint('BOTTOMRIGHT', f, 'BOTTOMLEFT', i * w + 1, 0)
			f:SetFrameStrata("HIGH")
		end
		for i = 0, 36 do
			local t = f:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				t:SetColorTexture(1, 1, 0, 0.5)
			else
				t:SetColorTexture(1, 1, 1, 0.15)
			end
			t:SetPoint('TOPLEFT', f, 'TOPLEFT', 0, -i * h + 1)
			t:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT', 0, -i * h - 1)
			f:SetFrameStrata("LOW")
		end
		
	end
end

end)