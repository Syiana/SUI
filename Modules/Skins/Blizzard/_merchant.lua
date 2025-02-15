local Module = SUI:NewModule("Skins.Merchant");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MerchantFrame)
        SUI:Skin(MerchantFrame.NineSlice)
        SUI:Skin(MerchantFrameInset)
        SUI:Skin(MerchantFrameInset.NineSlice)
        SUI:Skin(StackSplitFrame)
        SUI:Skin(MerchantMoneyBg)
        SUI:Skin(MerchantMoneyInset)
        SUI:Skin(MerchantMoneyInset.NineSlice)
        SUI:Skin({
            MerchantBuyBackItemSlotTexture,
        }, false, true)

        -- Merchant Buttons
        select(1, select(1, MerchantRepairItemButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantRepairAllButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantGuildBankRepairButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantSellAllJunkButton:GetRegions())):SetVertexColor(.15, .15, .15)

        -- Tabs
        SUI:Skin(MerchantFrameTab1)
        SUI:Skin(MerchantFrameTab2)
    end
end
