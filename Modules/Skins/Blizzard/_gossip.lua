local Module = SUI:NewModule("Skins.Gossip");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GossipFrame)
        SUI:Skin(GossipFrame.NineSlice)
        SUI:Skin(GossipFrameInset)
        SUI:Skin(GossipFrameInset.NineSlice)
    end
end
