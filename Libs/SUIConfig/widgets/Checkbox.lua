--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'Checkbox', 5;
if not SUIConfig:UpgradeNeeded(module, version) then
	return
end

----------------------------------------------------
--- Checkbox
----------------------------------------------------

local CheckboxMethods = {
	--- Set checkbox state
	---
	--- @param flag boolean
	--- @param internal boolean - indicates to not run OnValueChanged
	SetChecked = function(self, flag, internal)
		self.isChecked = flag;

		if not internal and self.OnValueChanged then
			self:OnValueChanged(flag, self.value);
		end

		if not flag then
			self.checkedTexture:Hide();
			self.disabledCheckedTexture:Hide();
			return
		end

		if self.isDisabled then
			self.checkedTexture:Hide();
			self.disabledCheckedTexture:Show();
		else
			self.checkedTexture:Show();
			self.disabledCheckedTexture:Hide();
		end
	end,

	GetChecked = function(self)
		return self.isChecked;
	end,

	SetText    = function(self, t)
		self.text:SetText(t);
	end,

	SetValue   = function(self, value)
		self.value = value;
	end,

	GetValue   = function(self)
		if self:GetChecked() then
			return self.value;
		else
			return nil;
		end
	end,

	Disable    = function(self)
		self.isDisabled = true;
		self:SetChecked(self.isChecked);
	end,

	Enable     = function(self)
		self.isDisabled = false;
		self:SetChecked(self.isChecked);
	end,

	AutoWidth  = function(self)
		self:SetWidth(self.target:GetWidth() + 15 + self.text:GetWidth());
	end
};

local CheckboxEvents = {
	OnClick = function(self)
		if not self.isDisabled then
			self:SetChecked(not self:GetChecked());
		end
	end
}

--@return CheckButton
function SUIConfig:Checkbox(parent, text, width, height, tooltip)
	local checkbox = CreateFrame('Button', nil, parent);
	checkbox.SUIConfig = self;

	checkbox:EnableMouse(true);
	self:SetObjSize(checkbox, width, height or 20);
	self:InitWidget(checkbox);

	checkbox.target = self:Panel(checkbox, 16, 16);
	checkbox.target.SUIConfig = self;
	checkbox.target:SetPoint('LEFT', 0, 0);

	checkbox.value = true;
	checkbox.isChecked = false;

	checkbox.text = self:Label(checkbox, text);
	checkbox.text:SetPoint('LEFT', checkbox.target, 'RIGHT', 5, 0);
	checkbox.text:SetPoint('RIGHT', checkbox, 'RIGHT', -5, 0);
	checkbox.target.text = checkbox.text; -- reference for disabled

	checkbox.checkedTexture = self:Texture(checkbox.target, nil, nil, [[Interface\AddOns\SUI\Libs\SUIConfig\media\Checked]]);
	checkbox.checkedTexture:SetAllPoints();
	checkbox.checkedTexture:SetVertexColor(3, 2, 5)
	checkbox.checkedTexture:Hide();

	checkbox.disabledCheckedTexture = self:Texture(checkbox.target, nil, nil, [[Interface\Buttons\UI-CheckBox-Check-Disabled]]);
	checkbox.disabledCheckedTexture:SetAllPoints();
	checkbox.disabledCheckedTexture:Hide();

	for k, v in pairs(CheckboxMethods) do
		checkbox[k] = v;
	end

	self:ApplyBackdrop(checkbox.target, 'checkbox');
	self:HookDisabledBackdrop(checkbox);
	self:HookHoverBorder(checkbox);

	if width == nil then
		checkbox:AutoWidth();
	end

	for k, v in pairs(CheckboxEvents) do
		checkbox:SetScript(k, v);
	end

	if (tooltip) then self:FrameTooltip(checkbox, tooltip, 'simp_tooltip', 'TOP', true) end

	return checkbox;
end

----------------------------------------------------
--- IconCheckbox
----------------------------------------------------

function SUIConfig:IconCheckbox(parent, icon, text, width, height, iconSize)
	iconSize = iconSize or 16
	local checkbox = self:Checkbox(parent, text, width, height);
	checkbox.icon = self:Texture(checkbox, iconSize, iconSize, icon);
	checkbox.icon:SetPoint('LEFT', checkbox.target, 'RIGHT', 5, 0);

	checkbox.text:ClearAllPoints();
	checkbox.text:SetPoint('LEFT', checkbox.target, 'RIGHT', iconSize + 5, 0);
	checkbox.text:SetPoint('RIGHT', checkbox, 'RIGHT', -5, 0);

	return checkbox;
end

----------------------------------------------------
--- Radio
----------------------------------------------------

local RadioEvents = {
	OnClick = function(self)
		if not self.isDisabled then
			self:SetChecked(true);
		end
	end
};

--@return CheckButton
function SUIConfig:Radio(parent, text, groupName, width, height)
	local radio = self:Checkbox(parent, text, width, height);

	radio.checkedTexture = self:Texture(radio.target, nil, nil, [[Interface\Buttons\UI-RadioButton]]);
	radio.checkedTexture:SetAllPoints(radio.target);
	radio.checkedTexture:Hide();
	radio.checkedTexture:SetTexCoord(0.25, 0.5, 0, 1);

	radio.disabledCheckedTexture = self:Texture(radio.target, nil, nil,
		[[Interface\Buttons\UI-RadioButton]]);
	radio.disabledCheckedTexture:SetAllPoints(radio.target);
	radio.disabledCheckedTexture:Hide();
	radio.disabledCheckedTexture:SetTexCoord(0.75, 1, 0, 1);

	for k, v in pairs(RadioEvents) do
		radio:SetScript(k, v);
	end

	if groupName then
		self:AddToRadioGroup(radio, groupName);
	end

	return radio;
end

SUIConfig.radioGroups = {};
SUIConfig.radioGroupValues = {};

--@return CheckButton[]
function SUIConfig:RadioGroup(groupName)
	if not self.radioGroups[groupName] then
		self.radioGroups[groupName] = {};
	end

	if not self.radioGroupValues[groupName] then
		self.radioGroupValues[groupName] = {};
	end

	return self.radioGroups[groupName];
end

function SUIConfig:GetRadioGroupValue(groupName)
	local group = self:RadioGroup(groupName);

	for i = 1, #group do
		local radio = group[i];
		if radio:GetChecked() then
			return radio:GetValue();
		end
	end

	return nil;
end

function SUIConfig:SetRadioGroupValue(groupName, value)
	local group = self:RadioGroup(groupName);

	for i = 1, #group do
		local radio = group[i];
		radio:SetChecked(radio.value == value)
	end

	return nil;
end

local radioGroupOnValueChanged = function(radio)
	radio.notified = true;
	local group = radio.radioGroup;
	local groupName = radio.radioGroupName;

	-- We must get all notifications from group
	for i = 1, #group do
		if not group[i].notified then
			return
		end
	end

	local newValue = radio.SUIConfig:GetRadioGroupValue(groupName);
	if radio.SUIConfig.radioGroupValues[groupName] ~= newValue then
		radio.OnValueChangedCallback(newValue, groupName);
	end
	radio.SUIConfig.radioGroupValues[groupName] = newValue;

	for i = 1, #group do
		group[i].notified = false;
	end
end

function SUIConfig:OnRadioGroupValueChanged(groupName, callback)
	local group = self:RadioGroup(groupName);

	for i = 1, #group do
		local radio = group[i];
		radio.OnValueChangedCallback = callback;
		radio.OnValueChanged = radioGroupOnValueChanged;
	end

	return nil;
end

local RadioGroupEvents = {
	OnClick = function(radio)
		for i = 1, #radio.radioGroup do
			local otherRadio = radio.radioGroup[i];

			if otherRadio ~= radio then
				otherRadio:SetChecked(false);
			end
		end
	end
};

function SUIConfig:AddToRadioGroup(radio, groupName)
	local group = self:RadioGroup(groupName);
	tinsert(group, radio);
	radio.radioGroup = group;
	radio.radioGroupName = groupName;

	for k, v in pairs(RadioGroupEvents) do
		radio:HookScript(k, v);
	end
end

SUIConfig:RegisterModule(module, version);