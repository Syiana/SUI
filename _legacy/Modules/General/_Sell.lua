local Module = SUI:NewModule("General.Sell");

function Module:OnEnable()
    local db = SUI.db.profile.general.automation.sell
    if (db) then
        local g = CreateFrame("Frame")
        g:RegisterEvent("MERCHANT_SHOW")
        g:SetScript("OnEvent", function()
            local bag, slot
            for bag = 0, 4 do
                for slot = 0, C_Container.GetContainerNumSlots(bag) do
                    local link = C_Container.GetContainerItemLink(bag, slot)
                    if link and (select(3, GetItemInfo(link)) == 0) then
                        C_Container.UseContainerItem(bag, slot)
                    end
                end
            end
        end)
    end
end
