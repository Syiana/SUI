local Module = SUI:NewModule("Skins.ActionHouse");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
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
          AuctionHouseFrame.BuyDialog.Border.BottomEdge, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          AuctionHouseFrame.Bg,
          AuctionHouseFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
  end
end