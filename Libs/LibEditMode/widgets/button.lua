local lib = LibStub('LibEditMode')
local internal = lib.internal

internal:CreatePool('button', function()
	return CreateFrame('Button', nil, UIParent, 'EditModeSystemSettingsDialogExtraButtonTemplate')
end)
