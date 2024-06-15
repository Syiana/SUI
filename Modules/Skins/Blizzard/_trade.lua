local Module = SUI:NewModule("Skins.Trade");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TradeFrame)
        SUI:Skin(TradeFrameTradeButton)
        SUI:Skin(TradeFrameCancelButton)
    end
end
