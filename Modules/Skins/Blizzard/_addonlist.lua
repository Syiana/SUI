local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(AddonList.NineSlice, true)
        SUI:Skin(AddonList, true)
        SUI:Skin({ AddonListBg }, true, true)
    end
end
