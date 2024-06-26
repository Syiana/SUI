local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            GuildRegistrarFrameTopEdge,
            GuildRegistrarFrameRightEdge,
            GuildRegistrarFrameBottomEdge,
            GuildRegistrarFrameLeftEdge,
            GuildRegistrarFrameTopRightCorner,
            GuildRegistrarFrameTopLeftCorner,
            GuildRegistrarFrameBottomLeftCorner,
            GuildRegistrarFrameBottomRightCorner,
            TabardFrameTopEdge,
            TabardFrameRightEdge,
            TabardFrameBottomEdge,
            TabardFrameLeftEdge,
            TabardFrameTopRightCorner,
            TabardFrameTopLeftCorner,
            TabardFrameBottomLeftCorner,
            TabardFrameBottomRightCorner,
        }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
            GuildRegistrarFrameBg,
            GuildRegistrarFrameTitleBg,
            GuildRegistrarFrameInsetBg,
            TabardFrameBg,
            TabardFrameTitleBg,
            TabardFrameInsetBg }) do
            v:SetVertexColor(.3, .3, .3)
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
