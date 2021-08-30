--- @type StdUi
local StdUi = LibStub and LibStub('StdUi', true);
if not StdUi then
	return
end

local module, version = 'Spell', 2;
if not StdUi:UpgradeNeeded(module, version) then
	return
end

----------------------------------------------------
--- SpellBox
----------------------------------------------------

local SpellBoxEvents = {
	OnEnter = function(self)
		if self.editBox.value then
			GameTooltip:SetOwner(self.editBox);
			GameTooltip:SetSpellByID(self.editBox.value);
			GameTooltip:Show();
		end
	end,

	OnLeave = function(self)
		if self.editBox.value then
			GameTooltip:Hide();
		end
	end
};

function StdUi:SpellBox(parent, width, height, iconSize, spellValidator)
	iconSize = iconSize or 16;
	local editBox = self:EditBox(parent, width, height, '', spellValidator or self.Util.spellValidator);
	editBox:SetTextInsets(iconSize + 7, 3, 3, 3);

	local iconFrame = self:Panel(editBox, iconSize, iconSize);
	self:GlueLeft(iconFrame, editBox, 2, 0, true);

	local icon = self:Texture(iconFrame, iconSize, iconSize, 134400);
	icon:SetAllPoints();

	editBox.icon = icon;
	iconFrame.editBox = editBox;

	for k, v in pairs(SpellBoxEvents) do
		iconFrame:SetScript(k, v);
	end

	return editBox;
end

----------------------------------------------------
--- SpellInfo
----------------------------------------------------
local SpellInfoMethods = {
	SetSpell = function(self, nameOrId)
		local name, _, i, _, _, _, spellId = GetSpellInfo(nameOrId);
		self.spellId = spellId;
		self.spellName = name;

		self.icon:SetTexture(i);
		self.text:SetText(name);
	end
};

local SpellInfoEvents = {
	OnEnter = function(self)
		GameTooltip:SetOwner(self.widget);
		GameTooltip:SetSpellByID(self.widget.spellId);
		GameTooltip:Show();
	end,

	OnLeave = function()
		GameTooltip:Hide();
	end
};

function StdUi:SpellInfo(parent, width, height, iconSize)
	iconSize = iconSize or 16;
	local frame = self:Panel(parent, width, height);

	local iconFrame = self:Panel(frame, iconSize, iconSize);
	self:GlueLeft(iconFrame, frame, 2, 0, true);

	local icon = self:Texture(iconFrame, iconSize, iconSize);
	icon:SetAllPoints();

	local btn = self:SquareButton(frame, iconSize, iconSize, 'DELETE');
	StdUi:GlueRight(btn, frame, -3, 0, true);

	local text = self:Label(frame);
	text:SetPoint('LEFT', icon, 'RIGHT', 3, 0);
	text:SetPoint('RIGHT', btn, 'RIGHT', -3, 0);

	frame.removeBtn = btn;
	frame.icon = icon;
	frame.text = text;

	btn.parent = frame;

	iconFrame.widget = frame;

	for k, v in pairs(SpellInfoMethods) do
		frame[k] = v;
	end

	for k, v in pairs(SpellInfoEvents) do
		iconFrame:SetScript(k, v);
	end

	return frame;
end;

----------------------------------------------------
--- SpellCheckbox
----------------------------------------------------

local SpellCheckboxMethods = {
	SetSpell = function(self, nameOrId)
		local name, _, i, _, _, _, spellId = GetSpellInfo(nameOrId);
		self.spellId = spellId;
		self.spellName = name;

		self.icon:SetTexture(i);
		self.text:SetText(name);
	end
};

local SpellCheckboxEvents = {
	OnEnter = function(self)
		if self.spellId then
			GameTooltip:SetOwner(self);
			GameTooltip:SetSpellByID(self.spellId);
			GameTooltip:Show();
		end
	end,

	OnLeave = function(self)
		if self.spellId then
			GameTooltip:Hide();
		end
	end
};

function StdUi:SpellCheckbox(parent, width, height, iconSize)
	iconSize = iconSize or 16;
	local checkbox = self:Checkbox(parent, '', width, height);
	checkbox.spellId = nil;
	checkbox.spellName = '';

	local iconFrame = self:Panel(checkbox, iconSize, iconSize);
	iconFrame:SetPoint('LEFT', checkbox.target, 'RIGHT', 5, 0);

	local icon = self:Texture(iconFrame, iconSize, iconSize);
	icon:SetAllPoints();

	checkbox.icon = icon;

	checkbox.text:SetPoint('LEFT', iconFrame, 'RIGHT', 5, 0);

	for k, v in pairs(SpellCheckboxMethods) do
		checkbox[k] = v;
	end

	for k, v in pairs(SpellCheckboxEvents) do
		checkbox:SetScript(k, v);
	end

	return checkbox;
end;

StdUi:RegisterModule(module, version);
