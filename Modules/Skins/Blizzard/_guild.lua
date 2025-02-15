local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        SUI:Skin(GuildRegistrarFrame)
        SUI:Skin(GuildRegistrarFrame.NineSlice)
        SUI:Skin(TabardFrame)
        SUI:Skin(TabardFrame.NineSlice)

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GuildBankUI" then
                SUI:Skin(GuildBankFrameTab1)
                SUI:Skin(GuildBankFrameTab2)
                SUI:Skin(GuildBankFrameTab3)
                SUI:Skin(GuildBankFrameTab4)
                SUI:Skin(GuildBankFrame)
                SUI:Skin({
                    GuildBankFrameLeft,
                    GuildBankFrameMiddle,
                    GuildBankFrameRight
                }, false, true)
                SUI:Skin(GuildBankFrame.MoneyFrameBG)
                SUI:Skin(GuildBankFrame.Column1)
                SUI:Skin(GuildBankFrame.Column2)
                SUI:Skin(GuildBankFrame.Column3)
                SUI:Skin(GuildBankFrame.Column4)
                SUI:Skin(GuildBankFrame.Column5)
                SUI:Skin(GuildBankFrame.Column6)
                SUI:Skin(GuildBankFrame.Column7)
            end
        end)
    end
end
