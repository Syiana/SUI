local Module = SUI:NewModule("Skins.Trade");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TradeFrame, true)
        SUI:Skin(TradeFrame.NineSlice, true)
        SUI:Skin(TradeFrame.RecipientOverlay, true)
        SUI:Skin(TradeFrameInset.NineSlice, true)
        SUI:Skin(TradePlayerEnchantInset, true)
        SUI:Skin(TradePlayerEnchantInset.NineSlice, true)
        SUI:Skin(TradePlayerItemsInset.NineSlice, true)
        SUI:Skin(TradeRecipientItemsInset.NineSlice, true)
        SUI:Skin(TradeRecipientMoneyBg, true)
        SUI:Skin(TradeRecipientMoneyInset.NineSlice, true)
        SUI:Skin(TradeRecipientEnchantInset, true)
        SUI:Skin(TradeRecipientEnchantInset.NineSlice, true)
    end
end
