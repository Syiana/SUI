local Edit = SUI:NewModule("Config.Edit");

function Edit:OnEnable()
	local Window = LibStub("LibWindow-1.1")
	local SUIConfig = LibStub('SUIConfig');
	SUIConfig.config = {
	  font = {
		  family    = "Interface\\AddOns\\SUI_Config\\Media\\Fonts\\Prototype.ttf",
		  size      = 12,
		  titleSize = 16,
		  effect    = 'NONE',
		  strata    = 'OVERLAY',
		  color     = {
		  normal   = { r = 1, g = 1, b = 1, a = 1 },
		  disabled = { r = 1, g = 1, b = 1, a = 1 },
		  header   = { r = 1, g = 0.9, b = 0, a = 1 },
		}
	  },
	  backdrop = {
		texture        = [[Interface\Buttons\WHITE8X8]],
		highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
		panel          = { r = 0.065, g = 0.065, b = 0.065, a = 0.9 },
		slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
		checkbox	     = { r = 0.125, g = 0.125, b = 0.125, a = 1 },
		dropdown	     = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
		button         = { r = 0.055, g = 0.055, b = 0.055, a = 1 },
		buttonDisabled = { r = 0, g = 0.55, b = 1, a = 0.5 },
		border         = { r = 0.01, g = 0.01, b = 0.01, a = 1 },
		borderDisabled = { r = 0, g = 0.50, b = 1, a = 1 },
	  },
	  progressBar = {
		color = { r = 1, g = 0.9, b = 0, a = 0.5 },
	  },
	  highlight = {
		color = { r = 0, g = 0.55, b = 1, a = 0.5 },
		blank = { r = 0, g = 0, b = 0 }
	  },
	  dialog = {
		width  = 400,
		height = 100,
		button = {
		  width  = 100,
		  height = 20,
		  margin = 5
		}
	  },
	  tooltip = {
		padding = 10
	  }
	};

	local Locked = true
	local Frames = { -- Only Frames with UIParent as Parent!
    "CastingBarFrame",
    "MenuFrame",
    "BuffDragFrame",
    "DebuffDragFrame",
    "PlayerFrame",
    "TargetFrame",
    "FocusFrame",
    "TooltipFrame",
    "StatsFrame",
    "TargetFrameDragFrame",
    --{ name = "TargetFrameDragFrame", label = "Target Castbar" },
	}

	-- Create DragFrame for Elements
	local function dragFrame(frame)
		-- Frame
    local self = nil
    if (type(frame) == 'table') then
      self = _G[frame.name]
    else
      self = _G[frame]
    end

		if not (self) then return end

		self:SetClampedToScreen(true)
		self:SetMovable(true)
		self:SetUserPlaced(true)

		-- Panel
		self.DragFrame = SUIConfig:Panel(UIParent)
		self.DragFrame:SetAllPoints(self)
		self.DragFrame:SetFrameStrata("TOOLTIP")
		self.DragFrame:Hide()

		-- Label
		SUIConfig:AddLabel(self.DragFrame, self.DragFrame, self:GetName(), 'TOP')
		self.DragFrame.label:SetAllPoints(true)
		self.DragFrame.label:SetJustifyH("TOP")
		self.DragFrame.label:SetJustifyV("TOP")

		-- Tooltip
		SUIConfig:FrameTooltip(self.DragFrame, 'Hold ALT to move the Frame!', 'Tooltip', 'TOP', true)

    -- Create DB
    if not (SUI.db.profile.edit[frame]) then SUI.db.profile.edit[frame] = {} end
    Window.RegisterConfig(self,  SUI.db.profile.edit[frame])
    if (SUI.db.profile.edit[frame].point) then Window.RestorePosition(self) end
		self.DragFrame:SetScript("OnDragStart", function() if IsAltKeyDown() then _G[frame]:StartMoving() end end)
		self.DragFrame:SetScript("OnDragStop", function()
			_G[frame]:StopMovingOrSizing()
      Window.SavePosition(self)
    end)
	end

	-- Unlock
	local function unlockFrame(frame)
    -- Frame
		self = _G[frame]
		if not (self and self:IsUserPlaced()) then return end
		if (Locked) then
			self.DragFrame:Show()
			self.DragFrame:EnableMouse(true)
			self.DragFrame:RegisterForDrag("LeftButton")
		else
			self.DragFrame:Hide()
		end
	end

	-- Grid
  local Grid
	local function showGrid(hide)
		if hide then
			Grid:Hide()
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
					Texture:SetColorTexture(1, 1, 1, 0.2)
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
					Texture:SetColorTexture(1, 1, 1, 0.2)
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
	local EditFrame = SUIConfig:PanelWithTitle(UIParent, 220, 100, 'Edit', 200, 32)
	EditFrame:SetPoint('CENTER');
	EditFrame.titlePanel:SetPoint('LEFT', 10, 0)
	EditFrame.titlePanel:SetPoint('RIGHT', -10, 0)
  EditFrame:Hide()

	local GridCheckbox = SUIConfig:Checkbox(EditFrame, 'Show Grid')
	SUIConfig:GlueTop(GridCheckbox, EditFrame, 0, -40, 'CENTER')
  GridCheckbox:SetChecked(true)
	GridCheckbox:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		if checked then showGrid(true) else showGrid(false) end
    self:SetChecked(not checked)
	end)

	local SaveButton = SUIConfig:Button(EditFrame, 90, 20, 'Save')
	SUIConfig:GlueBottom(SaveButton, EditFrame, 10, 10, 'LEFT')
	SaveButton:SetScript('OnClick', function()
		SUI:Edit()
		SUI:Config()
	end)

	local ResetButton = SUIConfig:Button(EditFrame, 90, 20, 'Reset')
	SUIConfig:GlueBottom(ResetButton, EditFrame, -10, 10, 'RIGHT')
	ResetButton:SetScript('OnClick', function()
    local buttons = {
      ok = {
        text    = 'Confirm',
        onClick = function() SUI.db.profile.edit = {} ReloadUI() end
      },
      cancel = {
        text    = 'Cancel',
        onClick = function(self) self:GetParent():Hide(); end
      }
    }
    SUIConfig:Confirm('Reset Frames', 'This will reset your frames', buttons)
	end)

	function SUI:Edit()
		if (Locked) then
      EditFrame:Show()
			for i , v in pairs (Frames) do unlockFrame(v) end
			Locked = false
			showGrid()
		else
      EditFrame:Hide()
			for i , v in pairs (Frames) do unlockFrame(v) end
			Locked = true
			showGrid(true)
		end
	end

	-- Command
	SLASH_SUIEDIT1 = '/suiedit'
	function SlashCmdList.SUIEDIT()
		SUI:Edit()
	end
end