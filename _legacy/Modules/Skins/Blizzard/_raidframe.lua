local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(CompactRaidFrameManager, true)
    end
end
