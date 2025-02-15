local Module = SUI:NewModule("Skins.Wardrobe");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" or name == "Blizzard_Wardrobe" then
                SUI:Skin(WardrobeFrame)
                SUI:Skin(WardrobeFrame.NineSlice)
                SUI:Skin(WardrobeCollectionFrame)
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame)
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice)
                SUI:Skin({
                    WardrobeCollectionFrameScrollFrameScrollBarBottom,
                    WardrobeCollectionFrameScrollFrameScrollBarMiddle,
                    WardrobeCollectionFrameScrollFrameScrollBarTop,
                    WardrobeCollectionFrameScrollFrameScrollBarThumbTexture
                }, false, true)
            end
        end)
    end
end
