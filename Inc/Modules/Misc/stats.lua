StatsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
local movable = true --false/true

if movable == false then
	StatsFrame:ClearAllPoints()
	StatsFrame:SetPoint('BOTTOMLEFT', UIParent, "BOTTOMLEFT", 5, 5)
end
StatsFrame:EnableMouse(true)

if movable == true then
	StatsFrame:ClearAllPoints()
	StatsFrame:SetPoint('BOTTOMLEFT', UIParent, "BOTTOMLEFT", 5, 3)
	StatsFrame:SetClampedToScreen(true)
	StatsFrame:SetMovable(true)
	StatsFrame:SetUserPlaced(true)
	StatsFrame:SetFrameLevel(4)
	StatsFrame:SetScript("OnMouseDown",	function()
		StatsFrame:ClearAllPoints()
		StatsFrame:StartMoving()
	end)
	StatsFrame:SetScript("OnMouseUp", function()
		StatsFrame:StopMovingOrSizing()
	end)
end

local SUI=CreateFrame("Frame")
SUI:RegisterEvent("PLAYER_LOGIN")
SUI:SetScript("OnEvent", function(self, event)


if not SUIDB.MODULES.STATS == true then return end 

local font = STANDARD_TEXT_FONT
local fontSize = SUIDB.STATS.SIZE
local fontFlag = "THINOUTLINE"
local textAlign = "CENTER"
local customColor = SUIDB.STATS.COLOR
local useShadow = true

local color
if customColor == false then
	color = {r = 1, g = 1, b = 1}
else
	local _, class = UnitClass("player")
	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
end

local function getFPS()
	return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps"
end

local function getLatencyWorld()
	return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms"
end

local function getLatency()
	return "|c00ffffff" .. select(3, GetNetStats()) .. "|r ms"
end

StatsFrame:SetWidth(50)
StatsFrame:SetHeight(fontSize)
StatsFrame.text = StatsFrame:CreateFontString(nil, "BACKGROUND")
StatsFrame.text:SetPoint(textAlign, StatsFrame)
StatsFrame.text:SetFont(font, fontSize, fontFlag)
if useShadow then
	StatsFrame.text:SetShadowOffset(1, -1)
	StatsFrame.text:SetShadowColor(0, 0, 0)
end
StatsFrame.text:SetTextColor(color.r, color.g, color.b)

local lastUpdate = 0

local function update(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	if lastUpdate > 1 then
		lastUpdate = 0
		if showClock == true then
			StatsFrame.text:SetText(getFPS() .. " " .. getLatency())
		else
			StatsFrame.text:SetText(getFPS() .. " " .. getLatency())
		end
		self:SetWidth(StatsFrame.text:GetStringWidth())
		self:SetHeight(StatsFrame.text:GetStringHeight())
	end
end

StatsFrame:SetScript("OnUpdate", update)

end)