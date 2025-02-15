local Module = SUI:NewModule("Skins.AddonList");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(AddonList.NineSlice)
        SUI:Skin(AddonList)
        SUI:Skin({ AddonListBg }, false, true)
    end
end
