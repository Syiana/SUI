--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'Button', 6;
if not SUIConfig:UpgradeNeeded(module, version) then return end;

local SquareButtonCoords = {
	UP = {     0.45312500,    0.64062500,     0.01562500,     0.20312500};
	DOWN = {   0.45312500,    0.64062500,     0.20312500,     0.01562500};
	LEFT = {   0.23437500,    0.42187500,     0.01562500,     0.20312500};
	RIGHT = {  0.42187500,    0.23437500,     0.01562500,     0.20312500};
	DELETE = { 0.01562500,    0.20312500,     0.01562500,     0.20312500};
};

local SquareButtonMethods = {
	SetIconDisabled = function(self, texture, iconWidth, iconHeight)
		self.iconDisabled = self.SUIConfig:Texture(self, iconWidth, iconHeight, texture);
		self.iconDisabled:SetDesaturated(true);
		self.iconDisabled:SetPoint('CENTER', 0, 0);

		self:SetDisabledTexture(self.iconDisabled);
	end,

	SetIcon = function(self, texture, iconWidth, iconHeight, alsoDisabled)
		self.icon = self.SUIConfig:Texture(self, iconWidth, iconHeight, texture);
		self.icon:SetPoint('CENTER', 0, 0);

		self:SetNormalTexture(self.icon);

		if alsoDisabled then
			self:SetIconDisabled(texture, iconWidth, iconHeight);
		end
	end
};

function SUIConfig:SquareButton(parent, width, height, icon)
	local button = CreateFrame('Button', nil, parent);
	button.SUIConfig = self;

	self:InitWidget(button);
	self:SetObjSize(button, width, height);

	self:ApplyBackdrop(button);
	self:HookDisabledBackdrop(button);
	self:HookHoverBorder(button);

	for k, v in pairs(SquareButtonMethods) do
		button[k] = v;
	end

	local coords = SquareButtonCoords[icon];
	if coords then
		button:SetIcon([[Interface\Buttons\SquareButtonTextures]], 16, 16, true);
		button.icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
		button.iconDisabled:SetTexCoord(coords[1], coords[2], coords[3], coords[4]);
	end

	return button;
end

function SUIConfig:ButtonLabel(parent, text)
	local label = self:Label(parent, text);
	label:SetJustifyH('CENTER');
	self:GlueAcross(label, parent, 2, -2, -2, 2);
	parent:SetFontString(label);
	label:SetFont(self.config.font.family, self.config.font.size)

	return label;
end

function SUIConfig:HighlightButtonTexture(button)
	local hTex = self:Texture(button, nil, nil, nil);
	hTex:SetColorTexture(
		self.config.highlight.color.r,
		self.config.highlight.color.g,
		self.config.highlight.color.b,
		self.config.highlight.color.a
	);
	hTex:SetAllPoints();

	return hTex;
end

--- Creates a button with only a highlight
--- @return Button
function SUIConfig:HighlightButton(parent, width, height, text, inherit)
	local button = CreateFrame('Button', nil, parent, inherit);
	self:InitWidget(button);
	self:SetObjSize(button, width, height);
	button.text = self:ButtonLabel(button, text);

	function button:SetFontSize(newSize)
		self.text:SetFontSize(newSize);
	end

	local hTex = self:HighlightButtonTexture(button);
	hTex:SetBlendMode('ADD');

	button:SetHighlightTexture(hTex);
	button.highlightTexture = hTex;

	return button;
end

--- @return Button
function SUIConfig:Button(parent, width, height, text, inherit)
	local button = self:HighlightButton(parent, width, height, text, inherit)
	button.SUIConfig = self;
	--button:SetHighlightTexture(nil);

	self:ApplyBackdrop(button);
	if not (parent.scrollBarWidth) then self:HookDisabledBackdrop(button) end;
	self:HookHoverBorder(button);

	return button;
end

function SUIConfig:ButtonAutoWidth(button, padding)
	padding = padding or 5;
	button:SetWidth(button.text:GetStringWidth() + padding * 2);
end

SUIConfig:RegisterModule(module, version);