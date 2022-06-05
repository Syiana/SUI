--- @type SUIConfig
local SUIConfig = LibStub and LibStub('SUIConfig', true);
if not SUIConfig then
	return
end

local module, version = 'Dropdown', 4;
if not SUIConfig:UpgradeNeeded(module, version) then return end;

local TableInsert = tinsert;

-- reference to all other dropdowns to close them when new one opens
local dropdowns = SUIConfigDropdowns or {};
SUIConfigDropdowns = dropdowns;

local DropdownItemOnClick = function(self)
	self.dropdown:SetValue(self.value, self:GetText());
	self.dropdown.optsFrame:Hide();
end

local DropdownItemOnValueChanged = function(checkbox, isChecked)
	checkbox.dropdown:ToggleValue(checkbox.value, isChecked);
end

local DropdownMethods = {
	buttonCreate = function(parent)
		local dropdown = parent.dropdown;
		local optionButton;

		if dropdown.multi then
			optionButton = dropdown.SUIConfig:Checkbox(parent, '', parent:GetWidth(), 20);
		else
			optionButton = dropdown.SUIConfig:HighlightButton(parent, parent:GetWidth(), 20, '');
			optionButton.text:SetJustifyH('LEFT');
		end

		optionButton.dropdown = dropdown;
		optionButton:SetFrameLevel(parent:GetFrameLevel() + 2);
		if not dropdown.multi then
			optionButton:SetScript('OnClick', DropdownItemOnClick);
		else
			optionButton.OnValueChanged = DropdownItemOnValueChanged;
		end

		return optionButton;
	end,

	buttonUpdate = function(parent, itemFrame, data)
		itemFrame:SetWidth(parent:GetWidth());
		itemFrame:SetText(data.text);

		if itemFrame.dropdown.multi then
			itemFrame:SetValue(data.value);
		else
			itemFrame.value = data.value;
		end
	end,

	ShowOptions = function(self)
		for i = 1, #dropdowns do
			dropdowns[i]:HideOptions();
		end

		self.optsFrame:UpdateSize(self:GetWidth(), self.optsFrame:GetHeight());
		self.optsFrame:Show();
		self.optsFrame:Update();
		self:RepaintOptions();
	end,

	HideOptions = function(self)
		self.optsFrame:Hide();
	end,

	ToggleOptions = function(self)
		if self.optsFrame:IsShown() then
			self:HideOptions();
		else
			self:ShowOptions();
		end
	end,

	SetPlaceholder = function(self, placeholderText)
		if self:GetText() == '' or self:GetText() == self.placeholder then
			self:SetText(placeholderText);
		end

		self.placeholder = placeholderText;
	end,

	RepaintOptions = function(self)
		local scrollChild = self.optsFrame.scrollChild;
		self.SUIConfig:ObjectList(
			scrollChild,
			scrollChild.items,
			self.buttonCreate,
			self.buttonUpdate,
			self.options
		);
		self.optsFrame:UpdateItemsCount(#self.options);
	end,

	SetOptions = function(self, newOptions)
		self.options = newOptions;
		local optionsHeight = #newOptions * 20;
		local scrollChild = self.optsFrame.scrollChild;
		if not scrollChild.items then
			scrollChild.items = {};
		end

		self.optsFrame:SetHeight(math.min(optionsHeight + 4, 200));
		scrollChild:SetHeight(optionsHeight);

		self:RepaintOptions();
	end,

	ToggleValue = function(self, value, state)
		assert(self.multi, 'Single dropdown cannot have more than one value!');

		-- Treat is as associative array
		if self.assoc then
			self.value[value] = state;
		else
			if state then
				-- we are toggling it on
				if not tContains(self.value, value) then
					TableInsert(self.value, value);
				end
			else
				-- we are removing it from table
				if tContains(self.value, value) then
					tDeleteItem(self.value, value);
				end
			end
		end

		self:SetValue(self.value);
	end,

	SetValue = function(self, value, text)
		self.value = value;

		if text then
			self:SetText(text);
		else
			self:SetText(self:FindValueText(value));
		end

		if self.multi then
			for _, checkbox in pairs(self.optsFrame.scrollChild.items) do
				local isChecked = false;
				if self.assoc then
					isChecked = self.value[checkbox.value];
				else
					isChecked = tContains(self.value, checkbox.value);
				end

				checkbox:SetChecked(isChecked, true);
			end
		end

		if self.OnValueChanged then
			self.OnValueChanged(self, value, self:GetText());
		end
	end,

	GetValue = function(self)
		return self.value;
	end,

	FindValueText = function(self, value)
		if type(value) ~= 'table' then
			for i = 1, #self.options do
				local opt = self.options[i];

				if opt.value == value then
					return opt.text;
				end
			end

			return self.placeholder or '';
		else
			local result = '';

			for i = 1, #self.options do
				local opt = self.options[i];

				if self.assoc then
					for key, checked in pairs(value) do
						if checked and key == opt.value then
							if result == '' then
								result = opt.text;
							else
								result = result .. ', ' .. opt.text;
							end
						end
					end
				else
					for x = 1, #value do
						if value[x] == opt.value then
							if result == '' then
								result = opt.text;
							else
								result = result .. ', ' .. opt.text;
							end
						end
					end
				end
			end

			if result ~= '' then
				return result
			else
				return self.placeholder or '';
			end
		end
	end
};

local DropdownEvents = {
	OnClick = function(self)
		self:ToggleOptions();
	end
};

--- Creates a single level dropdown menu
--- local options = {
---		{text = 'some text', value = 10},
---		{text = 'some text2', value = 11},
---		{text = 'some text3', value = 12},
--- }
--- @return Dropdown
function SUIConfig:Dropdown(parent, width, height, options, value, multi, assoc)
	--- @class Dropdown
	local dropdown = self:Button(parent, width, height, '');
	dropdown.SUIConfig = self;

	dropdown.text:SetJustifyH('LEFT');
	-- make it shorter because of arrow
	dropdown.text:ClearAllPoints();
	self:GlueAcross(dropdown.text, dropdown, 2, -2, -16, 2);

	local dropTex = self:Texture(dropdown, 10, 12, [[Interface\Buttons\SquareButtonTextures]]);
	dropTex:SetTexCoord(0.45312500, 0.64062500, 0.20312500, 0.01562500);
	self:GlueRight(dropTex, dropdown, -4, 0, true);

	self:ApplyBackdrop(dropdown, 'dropdown');

	local optsFrame = self:FauxScrollFrame(dropdown, dropdown:GetWidth(), 200, 10, 20);
	optsFrame:Hide();
	self:GlueBelow(optsFrame, dropdown, 0, 1, 'LEFT');
	dropdown:SetFrameLevel(optsFrame:GetFrameLevel() + 1);

	dropdown.multi = multi;
	dropdown.assoc = assoc;

	dropdown.optsFrame = optsFrame;
	dropdown.dropTex = dropTex;
	dropdown.options = options;

	optsFrame.scrollChild.dropdown = dropdown;

	for k, v in pairs(DropdownMethods) do
		dropdown[k] = v;
	end

	if options then
		dropdown:SetOptions(options);
	end

	if value then
		dropdown:SetValue(value);
	elseif multi then
		dropdown.value = {};
	end

	for k, v in pairs(DropdownEvents) do
		dropdown:SetScript(k, v);
	end

	TableInsert(dropdowns, dropdown);

	return dropdown;
end

SUIConfig:RegisterModule(module, version);