local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            -- Crafting Orders
            if name == "Blizzard_ProfessionsCustomerOrders" then
                SUI:Skin(ProfessionsCustomerOrdersFrame)
                SUI:Skin(ProfessionsCustomerOrdersFrame.NineSlice)
                SUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList.NineSlice)
                SUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameBorder)
                SUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameInset.NineSlice)

                -- Tabs
                SUI:Skin(ProfessionsCustomerOrdersFrameBrowseTab)
                SUI:Skin(ProfessionsCustomerOrdersFrameOrdersTab)
            end

            -- Auction House
            if name == "Blizzard_AuctionHouseUI" then
                SUI:Skin(AuctionHouseFrame)
                SUI:Skin(AuctionHouseFrame.NineSlice)
                SUI:Skin(AuctionHouseFrame.NineSlice)
                SUI:Skin(AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice)
                SUI:Skin(AuctionHouseFrame.BuyDialog)
                SUI:Skin(AuctionHouseFrame.BuyDialog.Border)
                SUI:Skin(AuctionHouseFrame.MoneyFrameBorder)
                SUI:Skin(AuctionHouseFrame.MoneyFrameInset.NineSlice)
                SUI:Skin(AuctionHouseFrame.CategoriesList)

                -- Tabs
                SUI:Skin(AuctionHouseFrameBuyTab)
                SUI:Skin(AuctionHouseFrameSellTab)
                SUI:Skin(AuctionHouseFrameAuctionsTab)
                SUI:Skin(AuctionHouseFrameAuctionsFrameAuctionsTab)
                SUI:Skin(AuctionHouseFrameAuctionsFrameBidsTab)
            end
        end)
    end
end
