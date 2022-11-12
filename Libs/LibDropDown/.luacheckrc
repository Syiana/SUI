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

exclude_files = {
}

globals = {
	-- FrameXML objects we mutate
	'ColorPickerFrame', -- FrameXML/ColorPickerFrame.xml

	-- savedvariables

	-- binding constants
}

read_globals = {
	table = {fields = {'wipe'}},

	-- FrameXML objects
	'UIParent', -- FrameXML/UIParent.xml
	'GameTooltip', -- ???
	'UIMenus', -- FrameXML/UIParent.lua
	'OpacitySliderFrame', -- there are duplicates of this, bad Blizzard

	-- FrameXML functions
	'ShowUIPanel', -- FrameXML/UIParent.lua

	-- FrameXML constants

	-- SharedXML objects
	'CallbackRegistryMixin', -- SharedXML/CallbackRegistry.lua
	'SOUNDKIT', -- SharedXML/SoundKitConstants.lua

	-- SharedXML functions
	'Mixin', -- SharedXML/Mixin.lua
	'CreateColor', -- SharedXML/Color.lua
	'CreateTextureMarkup', -- SharedXML/TextureUtil.lua
	'CreateAtlasMarkup', -- SharedXML/TextureUtil.lua

	-- GlobalStrings
	'HIGHLIGHT_FONT_COLOR',

	-- namespaces
	'C_Texture',

	-- API
	'securecall',
	'CreateFrame',
	'CreateFont',
	'GetCursorPosition',
	'PlaySound',

	-- exposed from other addons
	'LibStub',
}
