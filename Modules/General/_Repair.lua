local Module = SUI:NewModule("General.Repair");

function Module:OnEnable()
    local db = SUI.db.profile.general.automation.repair
    if (db) then
        local g = CreateFrame("Frame")
        g:RegisterEvent("MERCHANT_SHOW")
        g:SetScript("OnEvent", function()
            if (CanMerchantRepair()) then
                local cost = GetRepairAllCost()
                if cost > 0 then
                    local money = GetMoney()
                    if IsInGuild() then
                        local guildMoney = GetGuildBankWithdrawMoney()
                        if guildMoney > GetGuildBankMoney() then
                            guildMoney = GetGuildBankMoney()
                        end

                        if guildMoney > cost and CanGuildBankRepair() then
                            RepairAllItems(1)
                            print(format("|cffff00d5S|r|cff027bffUI|r: Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
                            return
                        end
                    end
                    if money > cost then
                        RepairAllItems()
                        print(format("|cffff00d5S|r|cff027bffUI|r: Repair cost: %.1fg|r", cost * 0.0001))
                    else
                        print("|cffff00d5S|r|cff027bffUI|r: Not enough gold to cover the repair cost.")
                    end
                end
            end
        end)
    end
end
