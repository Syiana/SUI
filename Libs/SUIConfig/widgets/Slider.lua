--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'Slider', 7;
if not SUIConfig:UpgradeNeeded(module, version) then return end

----------------------------------------------------
--- SliderButton
----------------------------------------------------

function SUIConfig:SliderButton(parent, width, height, direction)
	local button = self:Button(parent, width, height);

	local texture = self:ArrowTexture(button, direction);
	texture:SetPoint('CENTER');

	local textureDisabled = self:ArrowTexture(button, direction);
	textureDisabled:SetPoint('CENTER');
	textureDisabled:SetDesaturated(0);

	button:SetNormalTexture(texture);
	button:SetDisabledTexture(textureDisabled);

	return button;
end

----------------------------------------------------
--- StyleScrollBar
----------------------------------------------------

--- This is only useful for scrollBars not created using SUIConfig
function SUIConfig:StyleScrollBar(scrollBar)
	local buttonUp, buttonDown = scrollBar:GetChildren();

	scrollBar.background = SUIConfig:Panel(scrollBar);
	scrollBar.background:SetFrameLevel(scrollBar:GetFrameLevel() - 1);
	scrollBar.background:SetWidth(scrollBar:GetWidth());
	self:GlueAcross(scrollBar.background, scrollBar, 0, 1, 0, -1);

	self:StripTextures(buttonUp);
	self:StripTextures(buttonDown);

	self:ApplyBackdrop(buttonUp, 'button');
	self:ApplyBackdrop(buttonDown, 'button');

	buttonUp:SetWidth(scrollBar:GetWidth());
	buttonDown:SetWidth(scrollBar:GetWidth());

	local upTex = self:ArrowTexture(buttonUp, 'UP');
	upTex:SetPoint('CENTER');

	local upTexDisabled = self:ArrowTexture(buttonUp, 'UP');
	upTexDisabled:SetPoint('CENTER');
	upTexDisabled:SetDesaturated(0);

	buttonUp:SetNormalTexture(upTex);
	buttonUp:SetDisabledTexture(upTexDisabled);

	local downTex = self:ArrowTexture(buttonDown, 'DOWN');
	downTex:SetPoint('CENTER');

	local downTexDisabled = self:ArrowTexture(buttonDown, 'DOWN');
	downTexDisabled:SetPoint('CENTER');
	downTexDisabled:SetDesaturated(0);

	buttonDown:SetNormalTexture(downTex);
	buttonDown:SetDisabledTexture(downTexDisabled);

	local thumbSize = scrollBar:GetWidth();
	scrollBar:GetThumbTexture():SetWidth(thumbSize);

	self:StripTextures(scrollBar);

	scrollBar.thumb = self:Panel(scrollBar);
	scrollBar.thumb:SetAllPoints(scrollBar:GetThumbTexture());
	self:ApplyBackdrop(scrollBar.thumb, 'button');
end

----------------------------------------------------
--- Slider
----------------------------------------------------

local SliderMethods = {
	SetPrecision = function(self, numberOfDecimals)
		self.precision = numberOfDecimals;
	end,

	GetPrecision = function(self)
		return self.precision;
	end,

	GetValue = function(self)
		local minimum, maximum = self:GetMinMaxValues();
		return Clamp(SUIConfig.Util.roundPrecision(self:OriginalGetValue(), self.precision), minimum, maximum);
	end
};

local SliderEvents = {
	OnValueChanged = function(self, value, ...)
		if self.lock then return end
		self.lock = true;

		value = self:GetValue();

		if self.OnValueChanged then
			self:OnValueChanged(value, ...);
		end

		self.lock = false;
	end
}

function SUIConfig:Slider(parent, width, height, value, vertical, min, max)
	local slider = CreateFrame('Slider', nil, parent);
	self:InitWidget(slider);
	self:ApplyBackdrop(slider, 'panel');
	self:SetObjSize(slider, width, height);

	slider.vertical = vertical;
	slider.precision = 0;

	local thumbWidth = vertical and width or 20;
	local thumbHeight = vertical and 20 or height;

	slider.ThumbTexture = self:Texture(slider, thumbWidth, thumbHeight, self.config.backdrop.texture);
	slider:SetThumbTexture(slider.ThumbTexture);

	slider.thumb = self:Frame(slider);
	slider.thumb:SetAllPoints(slider:GetThumbTexture());
	self:ApplyBackdrop(slider.thumb, 'slider');

	if vertical then
		slider:SetOrientation('VERTICAL');
		slider.ThumbTexture:SetPoint('LEFT');
		slider.ThumbTexture:SetPoint('RIGHT');
	else
		slider:SetOrientation('HORIZONTAL');
		slider.ThumbTexture:SetPoint('TOP');
		slider.ThumbTexture:SetPoint('BOTTOM');
	end

	slider.OriginalGetValue = slider.GetValue;

	for k, v in pairs(SliderMethods) do
		slider[k] = v;
	end

	slider:SetMinMaxValues(min or 0, max or 100);
	slider:SetValue(value or min or 0);

	for k, v in pairs(SliderEvents) do
		slider:HookScript(k, v);
	end

	return slider;
end

----------------------------------------------------
--- SliderWithBox
----------------------------------------------------

local SliderWithBoxMethods = {
	SetValue = function(self, v)
		self.lock = true;
		self.slider:SetValue(v);
		v = self.slider:GetValue();
		self.editBox:SetValue(v);
		self.value = v;
		self.lock = false;

		if self.OnValueChanged then
			self.OnValueChanged(self, v);
		end
	end,

	GetValue = function(self)
		return self.value;
	end,

	SetValueStep = function(self, step)
		self.slider:SetValueStep(step);
	end,

	SetPrecision = function(self, numberOfDecimals)
		self.slider.precision = numberOfDecimals;
	end,

	GetPrecision = function(self)
		return self.slider.precision;
	end,

	SetMinMaxValues = function(self, min, max)
		self.min = min;
		self.max = max;

		self.editBox:SetMinMaxValue(min, max);
		self.slider:SetMinMaxValues(min, max);
		self.leftLabel:SetText(min);
		self.rightLabel:SetText(max);
	end
};

local SliderWithBoxOnValueChanged = function(self, val)
	if self.widget.lock then return end;

	self.widget:SetValue(val);
end

function SUIConfig:SliderWithBox(parent, width, height, value, min, max)
	local widget = CreateFrame('Frame', nil, parent);
	self:SetObjSize(widget, width, height);

	widget.slider = self:Slider(widget, 100, 12, value, false);
	widget.editBox = self:NumericBox(widget, 80, 16, value);
	widget.value = value;
	widget.editBox:SetNumeric(false);
	widget.leftLabel = self:Label(widget, '');
	widget.rightLabel = self:Label(widget, '');

	widget.slider.widget = widget;
	widget.editBox.widget = widget;

	for k, v in pairs(SliderWithBoxMethods) do
		widget[k] = v;
	end

	if min and max then
		widget:SetMinMaxValues(min, max);
	end

	widget.slider.OnValueChanged = SliderWithBoxOnValueChanged;
	widget.editBox.OnValueChanged = SliderWithBoxOnValueChanged;

	widget.slider:SetPoint('TOPLEFT', widget, 'TOPLEFT', 0, 0);
	widget.slider:SetPoint('TOPRIGHT', widget, 'TOPRIGHT', 0, 0);
	self:GlueBelow(widget.editBox, widget.slider, 0, -5, 'CENTER');
	widget.leftLabel:SetPoint('TOPLEFT', widget.slider, 'BOTTOMLEFT', 0, 0);
	widget.rightLabel:SetPoint('TOPRIGHT', widget.slider, 'BOTTOMRIGHT', 0, 0);

	return widget;
end

----------------------------------------------------
--- ScrollBar
----------------------------------------------------

function SUIConfig:ScrollBar(parent, width, height, horizontal)
	local panel = self:Panel(parent, width, height);
	local scrollBar = self:Slider(parent, width, height, 0, not horizontal);

	scrollBar.ScrollDownButton = self:SliderButton(parent, width, 16, 'DOWN');
	scrollBar.ScrollUpButton = self:SliderButton(parent, width, 16, 'UP');
	scrollBar.panel = panel;

	scrollBar.ScrollUpButton.scrollBar = scrollBar;
	scrollBar.ScrollDownButton.scrollBar = scrollBar;

	if horizontal then
		--@TODO do this
		--scrollBar.ScrollUpButton:SetPoint('TOPLEFT', panel, 'TOPLEFT', 0, 0);
		--scrollBar.ScrollUpButton:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', 0, 0);
		--
		--scrollBar.ScrollDownButton:SetPoint('BOTTOMLEFT', panel, 'BOTTOMLEFT', 0, 0);
		--scrollBar.ScrollDownButton:SetPoint('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', 0, 0);
		--
		--scrollBar:SetPoint('TOPLEFT', scrollBar.ScrollUpButton, 'TOPLEFT', 0, 1);
		--scrollBar:SetPoint('TOPRIGHT', scrollBar.ScrollUpButton, 'TOPRIGHT', 0, 1);
		--scrollBar:SetPoint('BOTTOMLEFT', scrollBar.ScrollDownButton, 'BOTTOMLEFT', 0, -1);
		--scrollBar:SetPoint('BOTTOMRIGHT', scrollBar.ScrollDownButton, 'BOTTOMRIGHT', 0, -1);
	else
		scrollBar.ScrollUpButton:SetPoint('TOPLEFT', panel, 'TOPLEFT', 0, 0);
		scrollBar.ScrollUpButton:SetPoint('TOPRIGHT', panel, 'TOPRIGHT', 0, 0);

		scrollBar.ScrollDownButton:SetPoint('BOTTOMLEFT', panel, 'BOTTOMLEFT', 0, 0);
		scrollBar.ScrollDownButton:SetPoint('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', 0, 0);

		scrollBar:SetPoint('TOPLEFT', scrollBar.ScrollUpButton, 'BOTTOMLEFT', 0, 1);
		scrollBar:SetPoint('TOPRIGHT', scrollBar.ScrollUpButton, 'BOTTOMRIGHT', 0, 1);
		scrollBar:SetPoint('BOTTOMLEFT', scrollBar.ScrollDownButton, 'TOPLEFT', 0, -1);
		scrollBar:SetPoint('BOTTOMRIGHT', scrollBar.ScrollDownButton, 'TOPRIGHT', 0, -1);
	end

	return scrollBar, panel;
end

SUIConfig:RegisterModule(module, version);
