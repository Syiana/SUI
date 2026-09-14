local Module = SUI:NewModule("Skins.Gossip");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GossipFrame, true)
        SUI:Skin(GossipFrame.NineSlice, true)
        SUI:Skin(GossipFrameInset, true)
        SUI:Skin(GossipFrameInset.NineSlice, true)
    end
end
