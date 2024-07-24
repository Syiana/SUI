local Module = SUI:NewModule("Skins.Macro");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_MacroUI" then
                for i, v in pairs({
                    MacroFrame.NineSlice.TopEdge,
                    MacroFrame.NineSlice.RightEdge,
                    MacroFrame.NineSlice.BottomEdge,
                    MacroFrame.NineSlice.LeftEdge,
                    MacroFrame.NineSlice.TopRightCorner,
                    MacroFrame.NineSlice.TopLeftCorner,
                    MacroFrame.NineSlice.BottomLeftCorner,
                    MacroFrame.NineSlice.BottomRightCorner,
                    MacroFrameTab1.Left,
                    MacroFrameTab1.Middle,
                    MacroFrameTab1.Right,
                    MacroFrameTab1.LeftActive,
                    MacroFrameTab1.MiddleActive,
                    MacroFrameTab1.RightActive,
                    MacroFrameTab1.LeftHighlight,
                    MacroFrameTab1.MiddleHighlight,
                    MacroFrameTab1.RightHighlight,
                    MacroFrameTab2.Left,
                    MacroFrameTab2.Middle,
                    MacroFrameTab2.Right,
                    MacroFrameTab2.LeftActive,
                    MacroFrameTab2.MiddleActive,
                    MacroFrameTab2.RightActive,
                    MacroFrameTab2.LeftHighlight,
                    MacroFrameTab2.MiddleHighlight,
                    MacroFrameTab2.RightHighlight,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    MacroFrameInset.NineSlice.TopEdge,
                    MacroFrameInset.NineSlice.TopRightCorner,
                    MacroFrameInset.NineSlice.RightEdge,
                    MacroFrameInset.NineSlice.BottomRightCorner,
                    MacroFrameInset.NineSlice.BottomEdge,
                    MacroFrameInset.NineSlice.BottomLeftCorner,
                    MacroFrameInset.NineSlice.LeftEdge,
                    MacroFrameInset.NineSlice.TopLeftCorner,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    MacroFrame.Bg,
                    MacroFrame.TitleBg
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                for i, v in pairs({
                    MacroButtonScrollFrameTop,
                    MacroButtonScrollFrameMiddle,
                    MacroButtonScrollFrameBottom,
                    MacroButtonScrollFrameScrollBarThumbTexture,
                    MacroFrameTextBackground.NineSlice.TopEdge,
                    MacroFrameTextBackground.NineSlice.BottomEdge,
                    MacroFrameTextBackground.NineSlice.LeftEdge,
                    MacroFrameTextBackground.NineSlice.RightEdge,
                    MacroFrameTextBackground.NineSlice.TopRightCorner,
                    MacroFrameTextBackground.NineSlice.TopLeftCorner,
                    MacroFrameTextBackground.NineSlice.BottomRightCorner,
                    MacroFrameTextBackground.NineSlice.BottomLeftCorner,
                }) do
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
                --fix
                --_G.select(2, MacroFrame:GetRegions()):Hide()
            end
        end)
    end
end
