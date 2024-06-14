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
            end
        end)
    end
end
