local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(BankFrame)
        SUI:Skin(BankFrame.NineSlice)
        SUI:Skin(BankSlotsFrame.NineSlice)
        SUI:Skin(BankFrameMoneyFrameBorder)
        SUI:Skin(AccountBankPanel.NineSlice)
        SUI:Skin(AccountBankPanel.MoneyFrame.Border)

        ReagentBankFrame:HookScript("OnShow", function()
            SUI:Skin(ReagentBankFrame)
            SUI:Skin(ReagentBankFrame.NineSlice)
        end)

        -- Tabs
        SUI:Skin(BankFrameTab1)
        SUI:Skin(BankFrameTab2)
        SUI:Skin(BankFrameTab3)
    end
end
