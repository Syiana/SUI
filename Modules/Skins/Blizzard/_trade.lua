local Module = SUI:NewModule("Skins.Trade");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TradeFrame)

        -- Buttons
        SUI:Skin({
            TradeFrameTradeButton.Left,
            TradeFrameTradeButton.Middle,
            TradeFrameTradeButton.Right,
            TradeFrameCancelButton.Left,
            TradeFrameCancelButton.Middle,
            TradeFrameCancelButton.Right
        }, false, true, false, true)
    end
end
