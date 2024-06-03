local Module = SUI:NewModule("Skins.Azerit");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_AzeriteUI" then
        for i, v in pairs({ AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopEdge,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.RightEdge,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomEdge,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.LeftEdge,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopRightCorner,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.TopLeftCorner,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomLeftCorner,
          AzeriteEmpoweredItemUI.BorderFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          AzeriteEmpoweredItemUI.BorderFrame.Bg,
          AzeriteEmpoweredItemUI.BorderFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
    -- AzeriteRespec
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_AzeriteRespecUI" then
        for i, v in pairs({ AzeriteRespecFrame.NineSlice.TopEdge,
          AzeriteRespecFrame.NineSlice.RightEdge,
          AzeriteRespecFrame.NineSlice.BottomEdge,
          AzeriteRespecFrame.NineSlice.LeftEdge,
          AzeriteRespecFrame.NineSlice.TopRightCorner,
          AzeriteRespecFrame.NineSlice.TopLeftCorner,
          AzeriteRespecFrame.NineSlice.BottomLeftCorner,
          AzeriteRespecFrame.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          AzeriteRespecFrame.Bg,
          AzeriteRespecFrame.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
      end
    end)
    --Essence
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
      if name == "Blizzard_AzeriteEssenceUI" then
        for i, v in pairs({ AzeriteEssenceUI.NineSlice.TopEdge,
          AzeriteEssenceUI.NineSlice.RightEdge,
          AzeriteEssenceUI.NineSlice.BottomEdge,
          AzeriteEssenceUI.NineSlice.LeftEdge,
          AzeriteEssenceUI.NineSlice.TopRightCorner,
          AzeriteEssenceUI.NineSlice.TopLeftCorner,
          AzeriteEssenceUI.NineSlice.BottomLeftCorner,
          AzeriteEssenceUI.NineSlice.BottomRightCorner, }) do
            v:SetVertexColor(.15, .15, .15)
        end
        for i, v in pairs({
          AzeriteEssenceUI.Bg,
          AzeriteEssenceUI.TitleBg }) do
            v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          AzeriteEssenceUI.LeftInset.NineSlice.TopEdge,
          AzeriteEssenceUI.LeftInset.NineSlice.TopRightCorner,
          AzeriteEssenceUI.LeftInset.NineSlice.RightEdge,
          AzeriteEssenceUI.LeftInset.NineSlice.BottomRightCorner,
          AzeriteEssenceUI.LeftInset.NineSlice.BottomEdge,
          AzeriteEssenceUI.LeftInset.NineSlice.BottomLeftCorner,
          AzeriteEssenceUI.LeftInset.NineSlice.LeftEdge,
          AzeriteEssenceUI.LeftInset.NineSlice.TopLeftCorner,
          AzeriteEssenceUI.RightInset.NineSlice.TopEdge,
          AzeriteEssenceUI.RightInset.NineSlice.TopRightCorner,
          AzeriteEssenceUI.RightInset.NineSlice.RightEdge,
          AzeriteEssenceUI.RightInset.NineSlice.BottomRightCorner,
          AzeriteEssenceUI.RightInset.NineSlice.BottomEdge,
          AzeriteEssenceUI.RightInset.NineSlice.BottomLeftCorner,
          AzeriteEssenceUI.RightInset.NineSlice.LeftEdge,
          AzeriteEssenceUI.RightInset.NineSlice.TopLeftCorner, }) do
          v:SetVertexColor(.3, .3, .3)
        end
        for i, v in pairs({
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarBottom,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarMiddle,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollBarTop,
          AzeriteEssenceUI.EssenceList.ScrollBar.thumbTexture,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollUpButton.Normal,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollDownButton.Normal,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollUpButton.Disabled,
          AzeriteEssenceUI.EssenceList.ScrollBar.ScrollDownButton.Disabled, }) do
          v:SetVertexColor(.4, .4, .4)
        end
      end
    end)
  end
end