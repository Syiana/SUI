local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GuildRegistrarFrame, true)
        SUI:Skin(GuildRegistrarFrame.NineSlice, true)
        SUI:Skin(TabardFrame, true)
        SUI:Skin(TabardFrame.NineSlice, true)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GuildBankUI" then
                SUI:Skin(GuildBankFrameTab1, true)
                SUI:Skin(GuildBankFrameTab2, true)
                SUI:Skin(GuildBankFrameTab3, true)
                SUI:Skin(GuildBankFrameTab4, true)
                SUI:Skin(GuildBankFrame, true)
                SUI:Skin({
                    GuildBankFrameLeft,
                    GuildBankFrameMiddle,
                    GuildBankFrameRight
                }, true, true)
                SUI:Skin(GuildBankFrame.MoneyFrameBG, true)
                SUI:Skin(GuildBankFrame.Column1, true)
                SUI:Skin(GuildBankFrame.Column2, true)
                SUI:Skin(GuildBankFrame.Column3, true)
                SUI:Skin(GuildBankFrame.Column4, true)
                SUI:Skin(GuildBankFrame.Column5, true)
                SUI:Skin(GuildBankFrame.Column6, true)
                SUI:Skin(GuildBankFrame.Column7, true)
            end
        end)
    end
end
