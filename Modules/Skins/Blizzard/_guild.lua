local Module = SUI:NewModule("Skins.Guild");

function Module:OnEnable()
    if (SUI:Color()) then
        for i, v in pairs({
            GuildRegistrarFrame.NineSlice.TopEdge,
            GuildRegistrarFrame.NineSlice.RightEdge,
            GuildRegistrarFrame.NineSlice.BottomEdge,
            GuildRegistrarFrame.NineSlice.LeftEdge,
            GuildRegistrarFrame.NineSlice.TopRightCorner,
            GuildRegistrarFrame.NineSlice.TopLeftCorner,
            GuildRegistrarFrame.NineSlice.BottomLeftCorner,
            GuildRegistrarFrame.NineSlice.BottomRightCorner,
            GuildRegistrarFrame.NineSlice.Center,
            TabardFrame.NineSlice.TopEdge,
            TabardFrame.NineSlice.RightEdge,
            TabardFrame.NineSlice.BottomEdge,
            TabardFrame.NineSlice.LeftEdge,
            TabardFrame.NineSlice.TopRightCorner,
            TabardFrame.NineSlice.TopLeftCorner,
            TabardFrame.NineSlice.BottomLeftCorner,
            TabardFrame.NineSlice.BottomRightCorner,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end
        for i, v in pairs({
            GuildRegistrarFrame.TitleBg,
            TabardFrame.TitleBg,
        }) do
            v:SetVertexColor(unpack(SUI:Color(0.15)))
        end

        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_GuildBankUI" then
                for i, v in pairs({
                    GuildBankFrameTab1.Left,
                    GuildBankFrameTab1.Middle,
                    GuildBankFrameTab1.Right,
                    GuildBankFrameTab1.LeftActive,
                    GuildBankFrameTab1.MiddleActive,
                    GuildBankFrameTab1.RightActive,
                    GuildBankFrameTab1.LeftHighlight,
                    GuildBankFrameTab1.MiddleHighlight,
                    GuildBankFrameTab1.RightHighlight,
                    GuildBankFrameTab2.Left,
                    GuildBankFrameTab2.Middle,
                    GuildBankFrameTab2.Right,
                    GuildBankFrameTab2.LeftActive,
                    GuildBankFrameTab2.MiddleActive,
                    GuildBankFrameTab2.RightActive,
                    GuildBankFrameTab2.LeftHighlight,
                    GuildBankFrameTab2.MiddleHighlight,
                    GuildBankFrameTab2.RightHighlight,
                    GuildBankFrameTab3.Left,
                    GuildBankFrameTab3.Middle,
                    GuildBankFrameTab3.Right,
                    GuildBankFrameTab3.LeftActive,
                    GuildBankFrameTab3.MiddleActive,
                    GuildBankFrameTab3.RightActive,
                    GuildBankFrameTab3.LeftHighlight,
                    GuildBankFrameTab3.MiddleHighlight,
                    GuildBankFrameTab3.RightHighlight,
                    GuildBankFrameTab4.Left,
                    GuildBankFrameTab4.Middle,
                    GuildBankFrameTab4.Right,
                    GuildBankFrameTab4.LeftActive,
                    GuildBankFrameTab4.MiddleActive,
                    GuildBankFrameTab4.RightActive,
                    GuildBankFrameTab4.LeftHighlight,
                    GuildBankFrameTab4.MiddleHighlight,
                    GuildBankFrameTab4.RightHighlight,
                    GuildBankFrame.RedMarbleBG,
                    GuildBankFrame.Emblem.Left,
                    GuildBankFrame.Emblem.Middle,
                    GuildBankFrame.Emblem.Right,
                    GuildBankFrame.TitleBg,
                    GuildBankFrameLeft,
                    GuildBankFrameMiddle,
                    GuildBankFrameRight,
                    GuildBankFrame.TopBorder,
                    GuildBankFrame.TopLeftCorner,
                    GuildBankFrame.TopRightCorner,
                    GuildBankFrame.LeftBorder,
                    GuildBankFrame.RightBorder,
                    GuildBankFrame.BottomBorder,
                    GuildBankFrame.BotLeftCorner,
                    GuildBankFrame.BotRightCorner,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end)
    end
end
