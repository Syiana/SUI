local LDD = LibStub('LibDropDown')

local Menu = LDD:NewButton(UIParent, 'LibDropDownTest')
Menu:SetPoint('CENTER', 0, 200)
Menu:SetJustifyH('LEFT')
Menu:SetStyle('DEFAULT') -- can be omitted, defaults to 'DEFAULT' 
Menu:SetText('TestDropDown')

Menu:SetCheckAlignment('LEFT')

Menu:Add({text = 'This is a menu with a long title', isTitle = true})

local info = {}
info.checked = true
info.text = 'Line 1'
info.args = {'line1value1', 'line1value2'}
info.func = function(button, ...)
	print('click', button, ...)
end
Menu:Add(info) -- add checkbutton

Menu:Add({isSpacer = true}) -- add spacer

info.text = 'Line 2'
info.args = {'line2value1', 'line2value2'}
info.checked = false
info.isRadio = true
Menu:Add(info) -- add radio button

Menu:Add({text = 'Disabled line', disabled = true}) -- add disabled line

Menu:Add({ -- add color picker
	text = 'ColorPicker',
	isColorPicker = true,
	colorR = 0.5,
	colorG = 0.3,
	colorB = 0.1,
	colorOpacity = 0.7, -- can be omitted
	colorPickerCallback = function(color)
		print(color:GetRGBA())
		print(color:GenerateHexColor())
	end
})

info.text = 'Line 3'
info.menu = {
	{
		text = 'Line 3 Line 1',
		func = print,
		args = {'Line 3 line1value1', 'Line 3 line1value2'}
	}
}
Menu:Add(info) -- add submenu

--[[ 
TODO:
- icons
- atlases
- tooltip
--]]
