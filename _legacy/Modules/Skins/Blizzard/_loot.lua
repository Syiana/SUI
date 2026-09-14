local Module = SUI:NewModule("Skins.Loot");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(LootFrame, true)
        SUI:Skin(LootFrame.NineSlice, true)
    end
end
