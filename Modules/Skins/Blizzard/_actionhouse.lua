local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            -- Crafting Orders
            if name == "Blizzard_ProfessionsCustomerOrders" then
                SUI:Skin(ProfessionsCustomerOrdersFrame, true)
                SUI:Skin(ProfessionsCustomerOrdersFrame.NineSlice, true)
                SUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList.NineSlice, true)
                SUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameBorder, true)
                SUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameInset.NineSlice, true)

                -- Tabs
                SUI:Skin(ProfessionsCustomerOrdersFrameBrowseTab, true)
                SUI:Skin(ProfessionsCustomerOrdersFrameOrdersTab, true)
            end

            -- Auction House
            if name == "Blizzard_AuctionHouseUI" then
                SUI:Skin(AuctionHouseFrame, true)
                SUI:Skin(AuctionHouseFrame.NineSlice, true)
                SUI:Skin(AuctionHouseFrame.NineSlice, true)
                SUI:Skin(AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice, true)
                SUI:Skin(AuctionHouseFrame.BuyDialog, true)
                SUI:Skin(AuctionHouseFrame.BuyDialog.Border, true)
                SUI:Skin(AuctionHouseFrame.MoneyFrameBorder, true)
                SUI:Skin(AuctionHouseFrame.MoneyFrameInset.NineSlice, true)
                SUI:Skin(AuctionHouseFrame.CategoriesList, true)

                -- Tabs
                SUI:Skin(AuctionHouseFrameBuyTab, true)
                SUI:Skin(AuctionHouseFrameSellTab, true)
                SUI:Skin(AuctionHouseFrameAuctionsTab, true)
                SUI:Skin(AuctionHouseFrameAuctionsFrameAuctionsTab, true)
                SUI:Skin(AuctionHouseFrameAuctionsFrameBidsTab, true)
            end
        end)
    end
end
