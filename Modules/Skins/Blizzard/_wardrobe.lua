local Module = SUI:NewModule("Skins.Wardrobe");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_Collections" or name == "Blizzard_Wardrobe" then
                SUI:Skin(WardrobeFrame, true)
                SUI:Skin(WardrobeFrame.NineSlice, true)
                SUI:Skin(WardrobeCollectionFrame, true)
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame, true)
                SUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice, true)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame, true)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset, true)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice, true)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset, true)
                SUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice, true)
                SUI:Skin({
                    WardrobeCollectionFrameScrollFrameScrollBarBottom,
                    WardrobeCollectionFrameScrollFrameScrollBarMiddle,
                    WardrobeCollectionFrameScrollFrameScrollBarTop,
                    WardrobeCollectionFrameScrollFrameScrollBarThumbTexture
                }, true, true)
            end
        end)
    end
end
