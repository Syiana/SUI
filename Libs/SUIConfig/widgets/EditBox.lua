--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'EditBox', 9;
if not SUIConfig:UpgradeNeeded(module, version) then return end;

local pairs = pairs;
local strlen = strlen;

----------------------------------------------------
--- SimpleEditBox
----------------------------------------------------

local SimpleEditBoxMethods = {
	SetFontSize = function(self, newSize)
		self:SetFont(self:GetFont(), newSize, self.SUIConfig.config.font.effect);
	end
};

local SimpleEditBoxEvents = {
	OnEscapePressed = function (self)
		self:ClearFocus();
	end
}

--- @return EditBox
function SUIConfig:SimpleEditBox(parent, width, height, text)
	--- @type EditBox
	local editBox = CreateFrame('EditBox', nil, parent);
	editBox.SUIConfig = self;
	self:InitWidget(editBox);

	editBox:SetTextInsets(3, 3, 3, 3);
	editBox:SetFontObject(ChatFontNormal);
	editBox:SetAutoFocus(false);

	for k, v in pairs(SimpleEditBoxMethods) do
		editBox[k] = v;
	end

	for k, v in pairs(SimpleEditBoxEvents) do
		editBox:SetScript(k, v);
	end

	if text then
		editBox:SetText(text);
	end

	self:HookDisabledBackdrop(editBox);
	self:HookHoverBorder(editBox);
	self:ApplyBackdrop(editBox);
	self:SetObjSize(editBox, width, height);

	return editBox;
end

----------------------------------------------------
--- ApplyPlaceholder
----------------------------------------------------

local ApplyPlaceholderOnTextChanged = function(self)
	if strlen(self:GetText()) > 0 then
		self.placeholder.icon:Hide();
		self.placeholder.label:Hide();
	else
		self.placeholder.icon:Show();
		self.placeholder.label:Show();
	end
end

function SUIConfig:ApplyPlaceholder(widget, placeholderText, icon, iconColor)
	widget.placeholder = {};

	local label = self:Label(widget, placeholderText);
	self:SetTextColor(label, 'disabled');
	widget.placeholder.label = label;

	if icon then
		local texture = self:Texture(widget, 14, 14, icon);
		local c = iconColor or self.config.font.color.disabled;
		texture:SetVertexColor(c.r, c.g, c.b, c.a);

		self:GlueLeft(texture, widget, 5, 0, true);
		self:GlueRight(label, texture, 2, 0);
		widget.placeholder.icon = texture;
	else
		self:GlueLeft(label, widget, 2, 0, true);
	end

	widget:HookScript('OnTextChanged', ApplyPlaceholderOnTextChanged);
end

----------------------------------------------------
--- SearchEditBox
----------------------------------------------------

local SearchEditBoxOnTextChanged = function(self)
	if self.OnValueChanged then
		self:OnValueChanged(self:GetText());
	end
end

function SUIConfig:SearchEditBox(parent, width, height, placeholderText)
	local editBox = self:SimpleEditBox(parent, width, height, '');

	editBox:SetScript('OnTextChanged', SearchEditBoxOnTextChanged);
	
	self:ApplyPlaceholder(editBox, placeholderText, [[Interface\Common\UI-Searchbox-Icon]]);

	return editBox;
end

----------------------------------------------------
--- SearchEditBox
----------------------------------------------------

local EditBoxMethods = {
	GetValue = function(self)
		return self.value;
	end,

	SetValue = function(self, value)
		self.value = value;
		self:SetText(value);
		self:Validate();
		self.button:Hide();
	end,

	IsValid = function(self)
		return self.isValid;
	end,

	Validate = function(self)
		self.isValidated = true;
		self.isValid = self.validator(self);

		if self.isValid then
			if self.button then
				self.button:Hide();
			end

			if self.OnValueChanged and tostring(self.lastValue) ~= tostring(self.value) then
				self:OnValueChanged(self.value);
				self.lastValue = self.value;
			end
		end

		self.isValidated = false;
	end;
}

local EditBoxButtonOnClick = function(self)
	self.editBox:Validate(self.editBox);
end

local EditBoxEvents = {
	OnEnterPressed = function(self)
		self:Validate();
	end,

	OnTextChanged = function(self, isUserInput)
		local value = SUIConfig.Util.stripColors(self:GetText());
		if tostring(value) ~= tostring(self.value) then
			if not self.isValidated and self.button and isUserInput then
				self.button:Show();
			end
		else
			self.button:Hide();
		end
	end
}

--- @return EditBox
function SUIConfig:EditBox(parent, width, height, text, validator)
	validator = validator or SUIConfig.Util.editBoxValidator;

	local editBox = self:SimpleEditBox(parent, width, height, text);
	editBox.validator = validator;

	local button = self:Button(editBox, 40, height - 4, OKAY);
	button:SetPoint('RIGHT', -2, 0);
	button:Hide();
	button.editBox = editBox;
	editBox.button = button;

	for k, v in pairs(EditBoxMethods) do
		editBox[k] = v;
	end

	button:SetScript('OnClick', EditBoxButtonOnClick);

	for k, v in pairs(EditBoxEvents) do
		editBox:SetScript(k, v);
	end

	return editBox;
end

----------------------------------------------------
--- SearchEditBox
----------------------------------------------------

local NumericBoxEvents = {
	OnEnterPressed = function(self)
		self:Validate();
	end
}

local NumericBoxMethods = {
	SetMaxValue = function(self, value)
		self.maxValue = value;
		self:Validate();
	end;

	SetMinValue = function(self, value)
		self.minValue = value;
		self:Validate();
	end;

	SetMinMaxValue = function(self, min, max)
		self.minValue = min;
		self.maxValue = max;
		self:Validate();
	end
}

function SUIConfig:NumericBox(parent, width, height, text, validator)
	validator = validator or self.Util.numericBoxValidator;

	local editBox = self:EditBox(parent, width, height, text, validator);
	editBox:SetNumeric(true);

	local button = self:Button(editBox, 40, height - 4, OKAY);
	button:SetPoint('RIGHT', -2, 0);
	button:Hide();
	button.editBox = editBox;
	editBox.button = button;

	for k, v in pairs(NumericBoxMethods) do
		editBox[k] = v;
	end

	button:SetScript('OnClick', EditBoxButtonOnClick);

	for k, v in pairs(NumericBoxEvents) do
		editBox:SetScript(k, v);
	end

	return editBox;
end

----------------------------------------------------
--- MoneyBox
----------------------------------------------------

local MoneyBoxMethods = {
	SetValue = function(self, value)
		self.value = value;
		local formatted = self.SUIConfig.Util.formatMoney(value);
		self:SetText(formatted);
		self:Validate();
		self.button:Hide();
	end;
};

function SUIConfig:MoneyBox(parent, width, height, text, validator, excludeCopper)
	if excludeCopper then
		validator = validator or self.Util.moneyBoxValidatorExC;
	else
		validator = validator or self.Util.moneyBoxValidator;
	end

	local editBox = self:EditBox(parent, width, height, text, validator);
	editBox.SUIConfig = self;
	editBox:SetMaxLetters(20);

	for k, v in pairs(MoneyBoxMethods) do
		editBox[k] = v;
	end

	return editBox;
end

----------------------------------------------------
--- MultiLineBox
----------------------------------------------------

local MultiLineBoxMethods = {
	SetValue = function(self, value)
		self.editBox:SetText(value);

		if self.OnValueChanged then
			self:OnValueChanged(value);
		end
	end,

	GetValue = function(self)
		return self.editBox:GetText();
	end,

	SetFont = function(self, font, size, flags)
		self.editBox:SetFont(font, size, flags);
	end,

	Enable = function(self)
		self.editBox:Enable();
	end,

	Disable = function(self)
		self.editBox:Disable();
	end,

	SetFocus = function(self)
		self.editBox:SetFocus();
	end,

	ClearFocus = function(self)
		self.editBox:ClearFocus();
	end,

	HasFocus = function(self)
		return self.editBox:HasFocus();
	end
};

local MultiLineBoxOnCursorChanged = function(self, _, y, _, cursorHeight)
	local sf, newY = self.scrollFrame, -y;
	local offset = sf:GetVerticalScroll();

	if newY < offset then
		sf:SetVerticalScroll(newY);
	else
		newY = newY + cursorHeight - sf:GetHeight() + 6; --text insets
		if newY > offset then
			sf:SetVerticalScroll(math.ceil(newY));
		end
	end
end

local MultiLineBoxOnTextChanged = function(self)
	if self.panel.OnValueChanged then
		self.panel.OnValueChanged(self.panel, self:GetText());
	end
end

local MultiLineBoxScrollOnMouseDown = function(self, button)
	self.scrollChild:SetFocus();
end

local MultiLineBoxScrollOnVerticalScroll = function(self, offset)
	self.scrollChild:SetHitRectInsets(0, 0, offset, self.scrollChild:GetHeight() - offset - self:GetHeight());
end

function SUIConfig:MultiLineBox(parent, width, height, text, readOnly)
	local editBox = CreateFrame('EditBox');
	local widget = self:ScrollFrame(parent, width, height, editBox);
	editBox.SUIConfig = self;

	local scrollFrame = widget.scrollFrame;
	scrollFrame.editBox = editBox;
	widget.editBox = editBox;
	editBox.panel = widget;

	self:ApplyBackdrop(widget, 'button');
	self:HookHoverBorder(scrollFrame);
	self:HookHoverBorder(editBox);

	editBox:SetWidth(scrollFrame:GetWidth());
	self:GlueAcross(scrollFrame, widget, 2, -2, -widget.scrollBarWidth - 2, 3);
	--editBox:SetHeight(scrollFrame:GetHeight());

	editBox:SetTextInsets(3, 3, 3, 3);
	editBox:SetFontObject(ChatFontNormal);
	editBox:SetAutoFocus(false);
	editBox:SetScript('OnEscapePressed', editBox.ClearFocus);
	editBox:SetMultiLine(true);
	editBox:EnableMouse(true);
	editBox:SetAutoFocus(false);
	editBox:SetCountInvisibleLetters(false);
	editBox:SetAllPoints();

	editBox.scrollFrame = scrollFrame;
	editBox.panel = widget;

	for k, v in pairs(MultiLineBoxMethods) do
		widget[k] = v;
	end

	if text then
		editBox:SetText(text);
	end

	editBox:SetScript('OnCursorChanged', MultiLineBoxOnCursorChanged)
	editBox:SetScript('OnTextChanged', MultiLineBoxOnTextChanged);

	scrollFrame:HookScript('OnMouseDown', MultiLineBoxScrollOnMouseDown);
	scrollFrame:HookScript('OnVerticalScroll', MultiLineBoxScrollOnVerticalScroll);

	widget.SetText = widget.SetValue;
	widget.GetText = widget.GetValue;

	return widget;
end

SUIConfig:RegisterModule(module, version);