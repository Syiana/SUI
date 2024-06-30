local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_AuctionUI" then
                SUI:Skin(AuctionFrame)
                SUI:Skin(AuctionFrameTab1)
                SUI:Skin(AuctionFrameTab2)
                SUI:Skin(AuctionFrameTab3)
                SUI:Skin(BrowseBuyoutButton)
                SUI:Skin(BrowseCloseButton)
                SUI:Skin(BrowseBidButton)
                SUI:Skin(BidBidButton)
                SUI:Skin(BidBuyoutButton)
                SUI:Skin(BidCloseButton)
                SUI:Skin(AuctionsCancelAuctionButton)
                SUI:Skin(AuctionsCloseButton)
                SUI:Skin(AuctionsCreateAuctionButton)
                SUI:Skin(BrowseSearchButton)
                SUI:Skin(BrowseResetButton)
                SUI:Skin(AuctionFilterButton1)
                SUI:Skin(AuctionFilterButton2)
                SUI:Skin(AuctionFilterButton3)
                SUI:Skin(AuctionFilterButton4)
                SUI:Skin(AuctionFilterButton5)
                SUI:Skin(AuctionFilterButton6)
                SUI:Skin(AuctionFilterButton7)
                SUI:Skin(AuctionFilterButton8)
                SUI:Skin(AuctionFilterButton9)
                SUI:Skin(AuctionFilterButton10)
                SUI:Skin(AuctionFilterButton11)
                SUI:Skin(AuctionFilterButton12)
                SUI:Skin(AuctionFilterButton13)
                SUI:Skin(AuctionFilterButton14)
                SUI:Skin(AuctionFilterButton15)
                SUI:Skin(BrowseFilterScrollFrame)
                SUI:Skin(BrowseName)
                SUI:Skin(BrowseMinLevel)
                SUI:Skin(BrowseMaxLevel)
                SUI:Skin(BrowseDropDown)
                SUI:Skin(BrowseBidPriceGold)
                SUI:Skin(BrowseBidPriceSilver)
                SUI:Skin(BrowseBidPriceCopper)
                SUI:Skin(BidQualitySort)
                SUI:Skin(BidLevelSort)
                SUI:Skin(BidDurationSort)
                SUI:Skin(BidBuyoutSort)
                SUI:Skin(BidStatusSort)
                SUI:Skin(BidBidSort)
                SUI:Skin(AuctionsQualitySort)
                SUI:Skin(AuctionsDurationSort)
                SUI:Skin(AuctionsHighBidderSort)
                SUI:Skin(AuctionsBidSort)
                SUI:Skin(StartPriceGold)
                SUI:Skin(StartPriceSilver)
                SUI:Skin(StartPriceCopper)
                SUI:Skin(BuyoutPriceGold)
                SUI:Skin(BuyoutPriceSilver)
                SUI:Skin(BuyoutPriceCopper)

                -- Reset Icon colors
                select(6, BrowseBidPriceGold:GetRegions()):SetVertexColor(1,1,1)
                select(6, BrowseBidPriceSilver:GetRegions()):SetVertexColor(1,1,1)
                select(6, BrowseBidPriceCopper:GetRegions()):SetVertexColor(1,1,1)
                select(6, StartPriceGold:GetRegions()):SetVertexColor(1,1,1)
                select(6, StartPriceSilver:GetRegions()):SetVertexColor(1,1,1)
                select(6, StartPriceCopper:GetRegions()):SetVertexColor(1,1,1)
                select(6, BuyoutPriceGold:GetRegions()):SetVertexColor(1,1,1)
                select(6, BuyoutPriceSilver:GetRegions()):SetVertexColor(1,1,1)
                select(6, BuyoutPriceCopper:GetRegions()):SetVertexColor(1,1,1)

                -- Buttons
                SUI:Skin({
                    BrowseBuyoutButton.Left,
                    BrowseBuyoutButton.Middle,
                    BrowseBuyoutButton.Right,
                    BrowseCloseButton.Left,
                    BrowseCloseButton.Middle,
                    BrowseCloseButton.Right,
                    BrowseBidButton.Left,
                    BrowseBidButton.Middle,
                    BrowseBidButton.Right,
                    BidBidButton.Left,
                    BidBidButton.Middle,
                    BidBidButton.Right,
                    BidBuyoutButton.Left,
                    BidBuyoutButton.Middle,
                    BidBuyoutButton.Right,
                    BidCloseButton.Left,
                    BidCloseButton.Middle,
                    BidCloseButton.Right,
                    AuctionsCancelAuctionButton.Left,
                    AuctionsCancelAuctionButton.Middle,
                    AuctionsCancelAuctionButton.Right,
                    AuctionsCloseButton.Left,
                    AuctionsCloseButton.Middle,
                    AuctionsCloseButton.Right,
                    AuctionsCreateAuctionButton.Left,
                    AuctionsCreateAuctionButton.Middle,
                    AuctionsCreateAuctionButton.Right,
                    BrowseSearchButton.Left,
                    BrowseSearchButton.Middle,
                    BrowseSearchButton.Right,
                    BrowseResetButton.Left,
                    BrowseResetButton.Middle,
                    BrowseResetButton.Right,
                }, false, true, false, true)

                if not (IsAddOnLoaded("Auctionator")) then return end
                local function updateAuctionTabs()
                    SUI:Skin(AuctionatorShoppingFrame)
                    SUI:Skin(AuctionatorShoppingFrame.NewListButton)
                    SUI:Skin(AuctionatorShoppingFrame.ImportButton)
                    SUI:Skin(AuctionatorShoppingFrame.ExportButton)
                    SUI:Skin(AuctionatorShoppingFrame.ExportCSV)
                    SUI:Skin(AuctionatorShoppingFrame.SearchOptions.SearchButton)
                    SUI:Skin(AuctionatorShoppingFrame.SearchOptions.MoreButton)
                    SUI:Skin(AuctionatorShoppingFrame.SearchOptions.AddToListButton)
                    SUI:Skin(AuctionatorShoppingFrame.SearchOptions)
                    SUI:Skin(AuctionatorShoppingFrame.ContainerTabs.ListsTab)
                    SUI:Skin(AuctionatorShoppingFrame.ContainerTabs.RecentsTab)
                    SUI:Skin(AuctionatorShoppingFrame.ListsContainer.Inset)
                    SUI:Skin(AuctionatorShoppingFrame.ShoppingResultsInset)
                    SUI:Skin(AuctionatorShoppingFrame.ResultsListing.HeaderContainer)
                    SUI:Skin(AuctionatorShoppingFrame.SearchOptions.SearchString)

                    SUI:Skin(AuctionatorSellingFrame.BuyFrame.CurrentPrices.Inset)
                    SUI:Skin(AuctionatorSellingFrame.BuyFrame.HistoryButton)
                    SUI:Skin(AuctionatorSellingFrame.BuyFrame.CurrentPrices.RefreshButton)
                    SUI:Skin(AuctionatorSellingFrame.BuyFrame.CurrentPrices.BuyButton)
                    SUI:Skin(AuctionatorSellingFrame.BuyFrame.CurrentPrices.CancelButton)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.GoldBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.SilverBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.CopperBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.GoldBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.SilverBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.CopperBox)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.Stacks.NumStacks)
                    SUI:Skin(AuctionatorSellingFrame.SaleItemFrame.Stacks.StackSize)
                    SUI:Skin(AuctionatorPostButton)
                    SUI:Skin(AuctionatorSellingFrame.BagInset)

                    SUI:Skin(AuctionatorCancellingFrame.HistoricalPriceInset)
                    SUI:Skin(AuctionatorCancelUndercutButton)

                    SUI:Skin(AuctionatorConfigFrame.OptionsButton)
                    SUI:Skin(AuctionatorConfigFrame.ScanButton)
                    SUI:Skin(AuctionatorConfigFrame)

                    SUI:Skin(AuctionFrameTab4)
                    SUI:Skin(AuctionFrameTab5)
                    SUI:Skin(AuctionFrameTab6)
                    SUI:Skin(AuctionFrameTab7)

                    -- Reset Icon Colors
                    select(6, AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.GoldBox:GetRegions()):SetVertexColor(1,1,1)
                    select(6, AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.SilverBox:GetRegions()):SetVertexColor(1,1,1)
                    select(6, AuctionatorSellingFrame.SaleItemFrame.UnitPrice.MoneyInput.CopperBox:GetRegions()):SetVertexColor(1,1,1)
                    select(6, AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.GoldBox:GetRegions()):SetVertexColor(1,1,1)
                    select(6, AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.SilverBox:GetRegions()):SetVertexColor(1,1,1)
                    select(6, AuctionatorSellingFrame.SaleItemFrame.StackPrice.MoneyInput.CopperBox:GetRegions()):SetVertexColor(1,1,1)

                    -- Buttons
                    SUI:Skin({
                        AuctionatorShoppingFrame.NewListButton.Left,
                        AuctionatorShoppingFrame.NewListButton.Middle,
                        AuctionatorShoppingFrame.NewListButton.Right,
                        AuctionatorShoppingFrame.ImportButton.Left,
                        AuctionatorShoppingFrame.ImportButton.Middle,
                        AuctionatorShoppingFrame.ImportButton.Right,
                        AuctionatorShoppingFrame.ExportButton.Left,
                        AuctionatorShoppingFrame.ExportButton.Middle,
                        AuctionatorShoppingFrame.ExportButton.Right,
                        AuctionatorShoppingFrame.ExportCSV.Left,
                        AuctionatorShoppingFrame.ExportCSV.Middle,
                        AuctionatorShoppingFrame.ExportCSV.Right,
                        AuctionatorShoppingFrame.SearchOptions.SearchButton.Left,
                        AuctionatorShoppingFrame.SearchOptions.SearchButton.Middle,
                        AuctionatorShoppingFrame.SearchOptions.SearchButton.Right,
                        AuctionatorShoppingFrame.SearchOptions.MoreButton.Left,
                        AuctionatorShoppingFrame.SearchOptions.MoreButton.Middle,
                        AuctionatorShoppingFrame.SearchOptions.MoreButton.Right,
                        AuctionatorShoppingFrame.SearchOptions.AddToListButton.Left,
                        AuctionatorShoppingFrame.SearchOptions.AddToListButton.Middle,
                        AuctionatorShoppingFrame.SearchOptions.AddToListButton.Right,
                        AuctionatorShoppingFrame.SearchOptions.Left,
                        AuctionatorShoppingFrame.SearchOptions.Middle,
                        AuctionatorShoppingFrame.SearchOptions.Right,
                        AuctionatorSellingFrame.BuyFrame.HistoryButton.Left,
                        AuctionatorSellingFrame.BuyFrame.HistoryButton.Middle,
                        AuctionatorSellingFrame.BuyFrame.HistoryButton.Right,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.RefreshButton.Left,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.RefreshButton.Middle,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.RefreshButton.Right,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.BuyButton.Left,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.BuyButton.Middle,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.BuyButton.Right,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.CancelButton.Left,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.CancelButton.Middle,
                        AuctionatorSellingFrame.BuyFrame.CurrentPrices.CancelButton.Right,
                        AuctionatorPostButton.Left,
                        AuctionatorPostButton.Middle,
                        AuctionatorPostButton.Right,
                        AuctionatorCancelUndercutButton.Left,
                        AuctionatorCancelUndercutButton.Middle,
                        AuctionatorCancelUndercutButton.Right,
                        AuctionatorConfigFrame.OptionsButton.Left,
                        AuctionatorConfigFrame.OptionsButton.Middle,
                        AuctionatorConfigFrame.OptionsButton.Right,
                        AuctionatorConfigFrame.ScanButton.Left,
                        AuctionatorConfigFrame.ScanButton.Middle,
                        AuctionatorConfigFrame.ScanButton.Right,
                    }, false, true, false, true)
                end
                C_Timer.After(0.1, updateAuctionTabs)
            end
        end)
    end
end
