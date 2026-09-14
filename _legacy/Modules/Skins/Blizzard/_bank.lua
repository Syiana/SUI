local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(BankFrame, true)
        SUI:Skin(BankFrame.NineSlice, true)
        
        -- Handle BankSlotsFrame (may not exist in current version)
        local bankSlotsFrame = _G["BankSlotsFrame"]
        if bankSlotsFrame and bankSlotsFrame.NineSlice then
            SUI:Skin(bankSlotsFrame.NineSlice, true)
        end
        
        -- Handle BankFrameMoneyFrameBorder (may not exist in current version)
        local bankFrameMoneyFrameBorder = _G["BankFrameMoneyFrameBorder"]
        if bankFrameMoneyFrameBorder then
            SUI:Skin(bankFrameMoneyFrameBorder, true)
        end
        
        -- Handle AccountBankPanel (may not exist in current version)
        local accountBankPanel = _G["AccountBankPanel"]
        if accountBankPanel then
            if accountBankPanel.NineSlice then
                SUI:Skin(accountBankPanel.NineSlice, true)
            end
            if accountBankPanel.MoneyFrame and accountBankPanel.MoneyFrame.Border then
                SUI:Skin(accountBankPanel.MoneyFrame.Border, true)
            end
        end

        -- Handle ReagentBankFrame (may not exist in current version)
        local reagentBankFrame = _G["ReagentBankFrame"]
        if reagentBankFrame then
            reagentBankFrame:HookScript("OnShow", function()
                SUI:Skin(reagentBankFrame, true)
                if reagentBankFrame.NineSlice then
                    SUI:Skin(reagentBankFrame.NineSlice, true)
                end
            end)
        end

        -- Handle Bank Frame Tabs (may not exist in current version)
        for i = 1, 3 do
            local tab = _G["BankFrameTab" .. i]
            if tab then
                SUI:Skin(tab, true)
            end
        end
    end
end
