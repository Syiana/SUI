local lib = LibStub('LibEditMode')
local internal = lib.internal

local checkboxMixin = {}
function checkboxMixin:Setup(data)
	self.setting = data
	self.Label:SetText(data.name)

	self.checked = data.get(lib.activeLayoutName)
	self.Button:SetChecked(not not self.checked)
end

function checkboxMixin:OnCheckButtonClick()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	self.checked = not self.checked
	self.setting.set(lib.activeLayoutName, not not self.checked)
end

internal:CreatePool(lib.SettingType.Checkbox, function()
	local frame = CreateFrame('Frame', nil, UIParent, 'EditModeSettingCheckboxTemplate')
	return Mixin(frame, checkboxMixin)
end)
