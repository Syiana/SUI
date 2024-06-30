local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        -- Tabard Frame
        SUI:Skin(TabardFrame)

        -- Guild NPC
        SUI:Skin(GuildRegistrarFrame)
        SUI:Skin(GuildRegistrarGreetingFrame)
        SUI:Skin(GuildRegistrarFrameEditBox)
        select(3, GuildRegistrarButton1:GetRegions()):SetTextColor(.8, .8, .8)
        select(3, GuildRegistrarButton2:GetRegions()):SetTextColor(.8, .8, .8)

        local texts = {
            GuildAvailableServicesText,
            GuildRegistrarPurchaseText
        }

        -- Set Text Colors
        for _, v in pairs(texts) do
            v:SetTextColor(.8, .8, .8)
        end

        -- Buttons
        SUI:Skin({
            TabardFrameAcceptButton.Left,
            TabardFrameAcceptButton.Middle,
            TabardFrameAcceptButton.Right,
            TabardFrameCancelButton.Left,
            TabardFrameCancelButton.Middle,
            TabardFrameCancelButton.Right,
            GuildRegistrarFrameGoodbyeButton.Left,
            GuildRegistrarFrameGoodbyeButton.Middle,
            GuildRegistrarFrameGoodbyeButton.Right,
            GuildRegistrarFramePurchaseButton.Left,
            GuildRegistrarFramePurchaseButton.Middle,
            GuildRegistrarFramePurchaseButton.Right,
            GuildRegistrarFrameCancelButton.Left,
            GuildRegistrarFrameCancelButton.Middle,
            GuildRegistrarFrameCancelButton.Right
        }, false, true, false, true)

        -- Guild Bank
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GuildBankUI" then
                SUI:Skin(GuildBankFrame)
                SUI:Skin(GuildBankFrameTab1)
                SUI:Skin(GuildBankFrameTab2)
                SUI:Skin(GuildBankFrameTab3)
                SUI:Skin(GuildBankFrameTab4)
                SUI:Skin(GuildBankInfoScrollFrame)
                SUI:Skin(GuildBankPopupFrame)
                SUI:Skin(BorderBox)
                SUI:Skin(GuildBankPopupFrame.ScrollFrame)

                for i = 1, GetNumGuildBankTabs()+1 do
                    local tab = _G["GuildBankTab" .. i]

                    if (tab) then
                        SUI:Skin(tab)
                    end
                end

                -- Buttons
                SUI:Skin({
                    GuildBankFrame.WithdrawButton.Left,
                    GuildBankFrame.WithdrawButton.Middle,
                    GuildBankFrame.WithdrawButton.Right,
                    GuildBankFrame.DepositButton.Left,
                    GuildBankFrame.DepositButton.Middle,
                    GuildBankFrame.DepositButton.Right,
                    GuildBankFrame.BuyInfo.PurchaseButton.Left,
                    GuildBankFrame.BuyInfo.PurchaseButton.Middle,
                    GuildBankFrame.BuyInfo.PurchaseButton.Right,
                    GuildBankPopupFrame.OkayButton.Left,
                    GuildBankPopupFrame.OkayButton.Middle,
                    GuildBankPopupFrame.OkayButton.Right,
                    GuildBankPopupFrame.CancelButton.Left,
                    GuildBankPopupFrame.CancelButton.Middle,
                    GuildBankPopupFrame.CancelButton.Right,
                    GuildBankInfoSaveButton.Left,
                    GuildBankInfoSaveButton.Middle,
                    GuildBankInfoSaveButton.Right
                }, false, true, false, true)
            end
        end)
    end
end
