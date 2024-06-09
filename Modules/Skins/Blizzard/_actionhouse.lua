local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ProfessionsCustomerOrders" then
                for i, v in pairs({
                    ProfessionsCustomerOrdersFrame.NineSlice.BottomEdge,
                    ProfessionsCustomerOrdersFrame.NineSlice.BottomLeftCorner,
                    ProfessionsCustomerOrdersFrame.NineSlice.BottomRightCorner,
                    ProfessionsCustomerOrdersFrame.NineSlice.Center,
                    ProfessionsCustomerOrdersFrame.NineSlice.LeftEdge,
                    ProfessionsCustomerOrdersFrame.NineSlice.RightEdge,
                    ProfessionsCustomerOrdersFrame.NineSlice.TopEdge,
                    ProfessionsCustomerOrdersFrame.NineSlice.TopLeftCorner,
                    ProfessionsCustomerOrdersFrame.NineSlice.TopRightCorner,
                    ProfessionsCustomerOrdersFrameBrowseTab.Left,
                    ProfessionsCustomerOrdersFrameBrowseTab.Middle,
                    ProfessionsCustomerOrdersFrameBrowseTab.Right,
                    ProfessionsCustomerOrdersFrameBrowseTab.LeftActive,
                    ProfessionsCustomerOrdersFrameBrowseTab.MiddleActive,
                    ProfessionsCustomerOrdersFrameBrowseTab.RightActive,
                    ProfessionsCustomerOrdersFrameBrowseTab.LeftHighlight,
                    ProfessionsCustomerOrdersFrameBrowseTab.MiddleHighlight,
                    ProfessionsCustomerOrdersFrameBrowseTab.RightHighlight,
                    ProfessionsCustomerOrdersFrameOrdersTab.Left,
                    ProfessionsCustomerOrdersFrameOrdersTab.Middle,
                    ProfessionsCustomerOrdersFrameOrdersTab.Right,
                    ProfessionsCustomerOrdersFrameOrdersTab.LeftActive,
                    ProfessionsCustomerOrdersFrameOrdersTab.MiddleActive,
                    ProfessionsCustomerOrdersFrameOrdersTab.RightActive,
                    ProfessionsCustomerOrdersFrameOrdersTab.LeftHighlight,
                    ProfessionsCustomerOrdersFrameOrdersTab.MiddleHighlight,
                    ProfessionsCustomerOrdersFrameOrdersTab.RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
            if name == "Blizzard_AuctionHouseUI" then
                for i, v in pairs({ AuctionHouseFrame.NineSlice.TopEdge,
                    AuctionHouseFrame.NineSlice.RightEdge,
                    AuctionHouseFrame.NineSlice.BottomEdge,
                    AuctionHouseFrame.NineSlice.LeftEdge,
                    AuctionHouseFrame.NineSlice.TopRightCorner,
                    AuctionHouseFrame.NineSlice.TopLeftCorner,
                    AuctionHouseFrame.NineSlice.BottomLeftCorner,
                    AuctionHouseFrame.NineSlice.BottomRightCorner,
                    AuctionHouseFrame.NineSlice.BottomEdge,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopEdge,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.RightEdge,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomEdge,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.LeftEdge,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopRightCorner,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.TopLeftCorner,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomLeftCorner,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomRightCorner,
                    AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice.BottomEdge,
                    AuctionHouseFrame.BuyDialog.Border.TopEdge,
                    AuctionHouseFrame.BuyDialog.Border.RightEdge,
                    AuctionHouseFrame.BuyDialog.Border.BottomEdge,
                    AuctionHouseFrame.BuyDialog.Border.LeftEdge,
                    AuctionHouseFrame.BuyDialog.Border.TopRightCorner,
                    AuctionHouseFrame.BuyDialog.Border.TopLeftCorner,
                    AuctionHouseFrame.BuyDialog.Border.BottomLeftCorner,
                    AuctionHouseFrame.BuyDialog.Border.BottomRightCorner,
                    AuctionHouseFrame.BuyDialog.Border.BottomEdge,
                    AuctionHouseFrame.MoneyFrameBorder.Left,
                    AuctionHouseFrame.MoneyFrameBorder.Middle,
                    AuctionHouseFrame.MoneyFrameBorder.Right,
                    AuctionHouseFrame.MoneyFrameInset.Bg,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.BottomEdge,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.BottomLeftCorner,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.BottomRightCorner,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.LeftEdge,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.RightEdge,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.TopEdge,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.TopLeftCorner,
                    AuctionHouseFrame.MoneyFrameInset.NineSlice.TopRightCorner,
                    AuctionHouseFrameBuyTab.Left,
                    AuctionHouseFrameBuyTab.Middle,
                    AuctionHouseFrameBuyTab.Right,
                    AuctionHouseFrameBuyTab.LeftActive,
                    AuctionHouseFrameBuyTab.MiddleActive,
                    AuctionHouseFrameBuyTab.RightActive,
                    AuctionHouseFrameBuyTab.LeftHighlight,
                    AuctionHouseFrameBuyTab.MiddleHighlight,
                    AuctionHouseFrameBuyTab.RightHighlight,
                    AuctionHouseFrameSellTab.Left,
                    AuctionHouseFrameSellTab.Middle,
                    AuctionHouseFrameSellTab.Right,
                    AuctionHouseFrameSellTab.LeftActive,
                    AuctionHouseFrameSellTab.MiddleActive,
                    AuctionHouseFrameSellTab.RightActive,
                    AuctionHouseFrameSellTab.LeftHighlight,
                    AuctionHouseFrameSellTab.MiddleHighlight,
                    AuctionHouseFrameSellTab.RightHighlight,
                    AuctionHouseFrameAuctionsTab.Left,
                    AuctionHouseFrameAuctionsTab.Middle,
                    AuctionHouseFrameAuctionsTab.Right,
                    AuctionHouseFrameAuctionsTab.LeftActive,
                    AuctionHouseFrameAuctionsTab.MiddleActive,
                    AuctionHouseFrameAuctionsTab.RightActive,
                    AuctionHouseFrameAuctionsTab.LeftHighlight,
                    AuctionHouseFrameAuctionsTab.MiddleHighlight,
                    AuctionHouseFrameAuctionsTab.RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    AuctionHouseFrame.Bg,
                    AuctionHouseFrame.TitleBg
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
