local Locked = true;
local Frames = { 
	"PlayerFrame", 
	"TargetFrame", 
	"FocusFrame", 
	"ObjectiveTrackerFrame", 
	"MinimapCluster",
	"MenuFrame",
	"CastingBarFrame",
	"TargetFrameSpellBar",
	"BuffDragFrame",
	"DebuffDragFrame"
}

local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = false,
	tileSize = 0,
	edgeSize = 1
}

-- Drag
function dragFrame(frame)
	self = _G[frame]
	local DragFrame = CreateFrame("Frame", "DragFrame", self, "BackdropTemplate")
	DragFrame:SetAllPoints(self)
	DragFrame:SetFrameStrata("HIGH")
	DragFrame:SetHitRectInsets(0,0,0,0)

	DragFrame:SetBackdrop(backdrop);
	DragFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.5);
	DragFrame:SetBackdropBorderColor(0, 0, 0, 0.8);
	DragFrame:Hide()

	DragFrame:SetScript("OnDragStart", function(self) if IsAltKeyDown() then self:GetParent():StartMoving() end end)
	DragFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
	DragFrame:SetScript("OnMouseDown", function (self, button)
		if IsShiftKeyDown() then
			if (button == "LeftButton") then 
				self:GetParent():SetScale(self:GetParent():GetScale() + 0.1)
			elseif (button == "RightButton") then
				self:GetParent():SetScale(self:GetParent():GetScale() - 0.1)
			end
		end
	end)

    DragFrame.text = DragFrame.text or DragFrame:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
	DragFrame.text:SetAllPoints(true)
	DragFrame.text:SetJustifyH("TOP")
	DragFrame.text:SetJustifyV("TOP")
    DragFrame.text:SetText(self:GetName())
	DragFrame.text:SetFont(STANDARD_TEXT_FONT, 14, "THICKOUTLINE")

	self.DragFrame = DragFrame
	self:SetClampedToScreen(true)
	self:SetMovable(true)
	self:SetUserPlaced(true)
end

-- Unlock
local function unlockFrame(frame)	
	self = _G[frame]
	if not self:IsUserPlaced() then return end
	if (Locked) then
		self:Show()
		self:SetAlpha(1)
		self.DragFrame:Show()
		self.DragFrame:EnableMouse(true)
		self.DragFrame:RegisterForDrag("LeftButton")
		self.DragFrame:SetScript("OnEnter", function(self)
		  GameTooltip:SetOwner(self, "ANCHOR_TOP")
		  GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
		  GameTooltip:AddLine("Hold down ALT to drag!", 1, 1, 1, 1, 1, 1)
		  GameTooltip:Show()
		end)
		self.DragFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)


		MenuFrame:SetScript('OnUpdate', function()
			MoveMicroButtons('BOTTOMLEFT', MenuFrame, 'BOTTOMLEFT', 6, 3)
		end)

		CastingBarFrame:SetScript('OnUpdate', function(self)
			self:Show()
		end)
		
		TargetFrameSpellBar:SetScript('OnUpdate', function(self)
			self:Show()
		end)

	else
		self.DragFrame:Hide()

		MenuFrame:SetScript("OnUpdate", nil)
		CastingBarFrame:SetScript("OnUpdate", nil)
		TargetFrameSpellBar:SetScript("OnUpdate", nil)
	end
end

-- Grid
local function showGrid()
	if Locked then 
		Grid:Hide()
		Gridf = nil
	else
		Grid = CreateFrame('Frame', nil, UIParent)
		Grid:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 100
		local h = GetScreenHeight() / 50
		for i = 0, 100 do
			local Texture = Grid:CreateTexture(nil, 'BACKGROUND')
			if i == 50 then
				Texture:SetColorTexture(1, 1, 0, 0.5)
			else
				Texture:SetColorTexture(1, 1, 1, 0.1)
			end
			Texture:SetPoint('TOPLEFT', Grid, 'TOPLEFT', i * w - 1, 0)
			Texture:SetPoint('BOTTOMRIGHT', Grid, 'BOTTOMLEFT', i * w + 1, 0)
			Grid:SetFrameStrata("HIGH")
		end
		for i = 0, 50 do
			local Texture = Grid:CreateTexture(nil, 'BACKGROUND')
			if i == 25 then
				Texture:SetColorTexture(1, 1, 0, 0.5)
			else
				Texture:SetColorTexture(1, 1, 1, 0.15)
			end
			Texture:SetPoint('TOPLEFT', Grid, 'TOPLEFT', 0, -i * h + 1)
			Texture:SetPoint('BOTTOMRIGHT', Grid, 'TOPRIGHT', 0, -i * h - 1)
			Grid:SetFrameStrata("LOW")
		end
	end
end

-- Init
for i, v in pairs (Frames) do dragFrame(v) end

-- Slash
SLASH_SUIEDIT1 = '/suiedit'
function SlashCmdList.SUIEDIT()
	if (Locked) then
		for i , v in pairs (Frames) do unlockFrame(v) end
		Locked = false
		showGrid()
	else 
		for i , v in pairs (Frames) do unlockFrame(v) end
		Locked = true
		showGrid()
	end
end
MoveMicroButtons('BOTTOMLEFT', MenuFrame, 'BOTTOMLEFT', 6, 3)