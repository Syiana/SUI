local Module = SUI:NewModule("General.Sell");

function Module:OnEnable()
    local db = {
        sell = SUI.db.profile.general.automation.sell,
        module = SUI.db.profile.modules.general
    }

    if (db.sell and db.module) then
        local g = CreateFrame("Frame")
        g:RegisterEvent("MERCHANT_SHOW")
        g:SetScript("OnEvent", function()
            local bag, slot
            for bag = 0, 4 do
                for slot = 0, C_Container.GetContainerNumSlots(bag) do
                    local link = C_Container.GetContainerItemLink(bag, slot)
                    if link and (select(3, C_Item.GetItemInfo(link)) == 0) then
                        C_Container.UseContainerItem(bag, slot)
                    end
                end
            end
        end)
    end
end
