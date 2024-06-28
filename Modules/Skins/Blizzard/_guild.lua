local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(TabardFrame)
        SUI:Skin(TabardFrameAcceptButton)
        SUI:Skin(TabardFrameCancelButton)

        SUI:Skin(GuildRegistrarFrame)
        SUI:Skin(GuildRegistrarGreetingFrame)
        SUI:Skin(GuildRegistrarFrameGoodbyeButton)
        SUI:Skin(GuildRegistrarFrameEditBox)
        SUI:Skin(GuildRegistrarFramePurchaseButton)
        SUI:Skin(GuildRegistrarFrameCancelButton)
        select(3, GuildRegistrarButton1:GetRegions()):SetTextColor(.8, .8, .8)
        select(3, GuildRegistrarButton2:GetRegions()):SetTextColor(.8, .8, .8)

        local texts = {
            GuildAvailableServicesText,
            GuildRegistrarPurchaseText
        }

        for _, v in pairs(texts) do
            v:SetTextColor(.8, .8, .8)
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GuildBankUI" then
                SUI:Skin(GuildBankFrame)
                SUI:Skin(GuildBankFrameTab1)
                SUI:Skin(GuildBankFrameTab2)
                SUI:Skin(GuildBankFrameTab3)
                SUI:Skin(GuildBankFrameTab4)
                SUI:Skin(GuildBankFrame.WithdrawButton)
                SUI:Skin(GuildBankFrame.DepositButton)
                SUI:Skin(GuildBankInfoScrollFrame)
            end
        end)
    end
end
