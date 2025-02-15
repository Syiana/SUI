local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(BankFrame, true)
        SUI:Skin(BankFrame.NineSlice, true)
        SUI:Skin(BankSlotsFrame.NineSlice, true)
        SUI:Skin(BankFrameMoneyFrameBorder, true)
        SUI:Skin(AccountBankPanel.NineSlice, true)
        SUI:Skin(AccountBankPanel.MoneyFrame.Border, true)

        ReagentBankFrame:HookScript("OnShow", function()
            SUI:Skin(ReagentBankFrame, true)
            SUI:Skin(ReagentBankFrame.NineSlice, true)
        end)

        -- Tabs
        SUI:Skin(BankFrameTab1, true)
        SUI:Skin(BankFrameTab2, true)
        SUI:Skin(BankFrameTab3, true)
    end
end
