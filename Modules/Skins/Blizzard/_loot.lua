local Module = SUI:NewModule("Skins.Loot");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(LootFrame)
        SUI:Skin(LootFrameInset)
    end
end
