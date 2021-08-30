local Fonts = SUI:NewModule('Data.Fonts');

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register('font', "Prototype", [[Interface\AddOns\SUI_Config\Media\Fonts\Prototype.ttf]]);

Fonts.data = {
    { value = 'Fonts\\FRIZQT__.TTF', text = 'Default' },
    { value = 'Interface\\AddOns\\SUI\\Media\\Fonts\\Prototype.ttf', text = 'Prototype' },
}