local Module = SUI:NewModule("Skins.Merchant");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MerchantFrame)
        SUI:Skin(MerchantFrameInset)
        SUI:Skin(MerchantBuyBackItem)
        SUI:Skin(MerchantMoneyInset)
        SUI:Skin(MerchantFrameTab1)
        SUI:Skin(MerchantFrameTab2)
        SUI:Skin(MerchantMoneyBg)
    end
end
