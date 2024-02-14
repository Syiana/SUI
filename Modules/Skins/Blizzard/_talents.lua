local Module = SUI:NewModule("Skins.Talents");

function Module:OnEnable()
    if (SUI:Color()) then
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, name)
            if name == "Blizzard_ClassTalentUI" then
                for i, v in pairs({
                    ClassTalentFrame.NineSlice.TopEdge,
                    ClassTalentFrame.NineSlice.RightEdge,
                    ClassTalentFrame.NineSlice.BottomEdge,
                    ClassTalentFrame.NineSlice.LeftEdge,
                    ClassTalentFrame.NineSlice.TopRightCorner,
                    ClassTalentFrame.NineSlice.TopLeftCorner,
                    ClassTalentFrame.NineSlice.BottomLeftCorner,
                    ClassTalentFrame.NineSlice.BottomRightCorner,
                    ClassTalentFrame.NineSlice.BottomEdge,
                    ClassTalentFrame.TalentsTab.TopEdge,
                    ClassTalentFrame.TalentsTab.RightEdge,
                    ClassTalentFrame.TalentsTab.BottomEdge,
                    ClassTalentFrame.TalentsTab.LeftEdge,
                    ClassTalentFrame.TalentsTab.TopRightCorner,
                    ClassTalentFrame.TalentsTab.TopLeftCorner,
                    ClassTalentFrame.TalentsTab.BottomLeftCorner,
                    ClassTalentFrame.TalentsTab.BottomRightCorner,
                    ClassTalentFrame.TalentsTab.BottomEdge,
                }) do
                    v:SetVertexColor(.15, .15, .15)
                end
                for i, v in pairs({
                    ClassTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarThumbTexture,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarTop,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarMiddle,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBarBottom,
                }) do
                    v:SetVertexColor(.4, .4, .4)
                end
                for i, v in pairs({
                    PVEFrameTopFiligree,
                    PVEFrameBottomFiligree,
                    PVEFrameBlueBg,
                    LFGListFrame.CategorySelection.Inset.CustomBG
                }) do
                    v:SetVertexColor(.5, .5, .5)
                end
                for i, v in pairs({
                    ClassTalentFrameTitleBg,
                    ClassTalentFrameBg,
                    ClassTalentFrameTalentsPvpTalentFrameTalentListBg
                }) do
                    v:SetVertexColor(.3, .3, .3)
                end
            end
        end)
    end
end
