local Module = SUI:NewModule("Skins.Item");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(ItemTextFrame)
        SUI:Skin(ItemTextFrame.NineSlice)
    end
end
