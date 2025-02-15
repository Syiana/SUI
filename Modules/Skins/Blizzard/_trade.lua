local Module = SUI:NewModule("Skins.Trade");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TradeFrame, true)
        SUI:Skin(TradeFrame.NineSlice, true)
        SUI:Skin(TradeFrame.RecipientOverlay, true)
    end
end
