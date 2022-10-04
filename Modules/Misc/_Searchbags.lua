local Module = SUI:NewModule("Misc.Searchbags");

function Module:OnEnable()
    local db = SUI.db.profile.misc.searchbags
    if (db) then
        hooksecurefunc("ContainerFrame_Update", function( self )
            if self:GetID() == 0 then
                BagItemSearchBox:SetParent(self)
                BagItemSearchBox:SetPoint("TOPLEFT", self, "TOPLEFT", 55, -29)
                BagItemSearchBox:SetWidth(75)
                BagItemSearchBox.anchorBag = self
                BagItemSearchBox:Show()
            elseif BagItemSearchBox.anchorBag == self then
                BagItemSearchBox:ClearAllPoints()
                BagItemSearchBox:Hide()
                BagItemSearchBox.anchorBag = nil
            end
        end)
    end
end