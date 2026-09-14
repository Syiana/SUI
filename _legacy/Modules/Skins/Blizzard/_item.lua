local Module = SUI:NewModule("Skins.Item");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(ItemTextFrame, true)
        SUI:Skin(ItemTextFrame.NineSlice, true)
    end
end
