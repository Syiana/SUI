local Module = SUI:NewModule("Skins.Merchant");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(MerchantFrame, true)
        SUI:Skin(MerchantFrame.NineSlice, true)
        SUI:Skin(MerchantFrameInset, true)
        SUI:Skin(MerchantFrameInset.NineSlice, true)
        SUI:Skin(StackSplitFrame, true)
        SUI:Skin(MerchantMoneyBg, true)
        SUI:Skin(MerchantMoneyInset, true)
        SUI:Skin(MerchantMoneyInset.NineSlice, true)
        SUI:Skin({
            MerchantBuyBackItemSlotTexture,
        }, true, true)

        -- Merchant Buttons
        select(1, select(1, MerchantRepairItemButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantRepairAllButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantGuildBankRepairButton:GetRegions())):SetVertexColor(.15, .15, .15)
        select(1, select(1, MerchantSellAllJunkButton:GetRegions())):SetVertexColor(.15, .15, .15)

        -- Tabs
        SUI:Skin(MerchantFrameTab1, true)
        SUI:Skin(MerchantFrameTab2, true)
    end
end
