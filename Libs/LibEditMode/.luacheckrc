std = 'lua51'

quiet = 1 -- suppress report output for files without warnings

-- see https://luacheck.readthedocs.io/en/stable/warnings.html#list-of-warnings
-- and https://luacheck.readthedocs.io/en/stable/cli.html#patterns
ignore = {
	'212/self', -- unused argument self
	'212/event', -- unused argument event
	'212/unit', -- unused argument unit
	'212/element', -- unused argument element
	'312/event', -- unused value of argument event
	'312/unit', -- unused value of argument unit
	'431', -- shadowing an upvalue
	'614', -- trailing whitespace in a comment
	'631', -- line is too long
}

read_globals = {
	-- FrameXML objects
	'UIParent', -- FrameXML/UIParent.xml
	'EditModeManagerFrame', -- FrameXML/EditModeManager.xml

	-- FrameXML functions
	'CopyTable', -- FrameXML/TableUtil.lua 

	-- SharedXML objects
	'ObjectPoolMixin', -- SharedXML/Pools.lua
	'EventRegistry', -- SharedXML/GlobalCallbackRegistry.lua
	'MinimalSliderWithSteppersMixin', -- SharedXML/Slider/MinimalSlider.lua

	-- SharedXML functions
	'Mixin', -- SharedXML/Mixin.lua
	'CreateFromMixins', -- SharedXML/Mixin.lua
	'GenerateClosure', -- SharedXML/FunctionUtil.lua
	'CreateMinimalSliderFormatter', -- SharedXML/Slider/MinimalSlider.lua

	-- SharedXML constants
	'SOUNDKIT', -- SharedXML/SoundKitConstants.lua

	-- GlobalStrings
	'HUD_EDIT_MODE_RESET_POSITION',
	'RESET_TO_DEFAULT',

	-- namespaces
	'C_EditMode',
	'Enum',

	-- API
	'CreateFrame',
	'PlaySound',
	'hooksecurefunc',

	-- exposed from other addons
	'LibStub',
}
