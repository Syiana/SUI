local Locked = true
local Frames = { 
	"PlayerFrame", 
	"TargetFrame", 
	"FocusFrame",
	"TooltipFrame",
	"ObjectiveTrackerFrame", 
	"MinimapCluster",
	"MenuFrame",
	"CastingBarFrame",
	"TargetFrameSpellBar",
	"BuffDragFrame",
	"DebuffDragFrame",
	"ChatFrame"
}

local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = false,
	tileSize = 0,
	edgeSize = 2
}

local function SUICreateButton(text, point1, anchor, point2, pos1, pos2, width, height)
	local Button = CreateFrame("Button", nil, _G[anchor], "UIPanelButtonTemplate")
	Button:SetPoint(point1, anchor, point2, pos1, pos2)
	Button:SetSize(width, height)
	Button:SetText(text)

	Button:SetNormalTexture("Interface\\Common\\bluemenu-main")
	Button:GetNormalTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
	Button:GetNormalTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
	Button:SetHighlightTexture("Interface\\Common\\bluemenu-main")
	Button:GetHighlightTexture():SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
	Button:GetHighlightTexture():SetVertexColor(0.265, 0.320, 0.410, 1)
end

-- Drag
local function dragFrame(frame) 
	self = _G[frame]
	local DragFrame = CreateFrame("Frame", "DragFrame", self, "BackdropTemplate")
	DragFrame:SetBackdrop(backdrop)
	DragFrame:SetBackdropColor(0.01, 0.01, 0.01, 0.8)
	DragFrame:SetBackdropBorderColor(0.135, 0.175, 0.250)
	DragFrame:SetAllPoints(self)
	DragFrame:SetFrameStrata("TOOLTIP")
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
		EditFrame:Show()
		self:Show()
		self:SetAlpha(1)
		self.DragFrame:Show()
		self.DragFrame:EnableMouse(true)
		self.DragFrame:RegisterForDrag("LeftButton")
		self.DragFrame:SetScript("OnEnter", function(self)
		  GameTooltip:SetOwner(self, "ANCHOR_TOP")
		  GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5)
		  GameTooltip:AddLine("Hold ALT to move the Frame!", 1, 1, 1)
		  GameTooltip:SetWidth(500)
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
		EditFrame:Hide()
		self.DragFrame:Hide()
		MenuFrame:SetScript("OnUpdate", nil)
		CastingBarFrame:SetScript("OnUpdate", nil)
		TargetFrameSpellBar:SetScript("OnUpdate", nil)
	end
end

-- Grid
local function showGrid(hide)
	if Grid or hide then 
		Grid:Hide()
		Grid = nil
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
			Grid:SetFrameStrata("BACKGROUND")
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

-- Edit
local EditFrame = CreateFrame("Frame", "EditFrame", UIParent, "BasicFrameTemplate")
EditFrame:SetWidth(200)
EditFrame:SetHeight(100)
EditFrame:SetPoint("CENTER")
EditFrame:Hide()
EditFrame.text = EditFrame.text or EditFrame:CreateFontString(nil, "ARTWORK", "QuestMapRewardsFont")
EditFrame.text:SetText("Edit")
EditFrame.text:SetPoint("TOP",0,-4)
EditFrame.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")

GridButton = CreateFrame("CheckButton", "GridButton", EditFrame, "ChatConfigCheckButtonTemplate");
GridButton:SetPoint("BOTTOMRIGHT", -40, 0)
GridButton:SetChecked(true)
GridButton.text = GridButton:CreateFontString(nil,"GameFontHighlight")
GridButton.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
GridButton.text:SetPoint("LEFT", GridButton, "RIGHT", 0, 1)
GridButton.text:SetText("Grid")
GridButton.tooltip = "Show/Hide Background."
GridButton:SetScript("OnClick", function(self) 
	checked = self:GetChecked()
	if checked then showGrid(true) else showGrid(false) end 
end)

for i, v in pairs({
	EditFrame.Bg,
	EditFrame.TitleBg}) 
	do v:SetVertexColor(0.175, 0.2, 0.250)
end
for i, v in pairs({
	EditFrame.TopBorder,
	EditFrame.TopLeftCorner,
	EditFrame.TopRightCorner,
	EditFrame.BottomBorder,
	EditFrame.BotLeftCorner,
	EditFrame.BotRightCorner,
	EditFrame.LeftBorder,
	EditFrame.RightBorder}) 
	do v:SetVertexColor(0.135, 0.175, 0.250)
end

SUICreateButton('Save', 'BOTTOMLEFT', 'EditFrame', "BOTTOMLEFT", 5, 5, 80, 25)

function suitest()
	if (Locked) then
		for i , v in pairs (Frames) do unlockFrame(v) end
		Locked = false
		showGrid()
	else 
		for i , v in pairs (Frames) do unlockFrame(v) end
		Locked = true
		showGrid(true)
	end
end

-- Slash
SLASH_SUIEDIT1 = '/suiedit'
function SlashCmdList.SUIEDIT()
	suitest()
end