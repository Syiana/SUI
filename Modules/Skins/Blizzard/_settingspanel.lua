local Module = SUI:NewModule("Skins.Settingspanel");

function Module:OnEnable()
  if (SUI:Color()) then
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function(self, event, name)
        for i, v in pairs({
            SettingsPanel.bg,
            SettingsPanel.Bg.TopSection,
            SettingsPanel.Bg.BottomEdge,
            SettingsPanel.NineSlice.TopEdge,
            SettingsPanel.NineSlice.TopLeftCorner,
            SettingsPanel.NineSlice.TopRightCorner,
            SettingsPanel.NineSlice.BottomLeftCorner,
            SettingsPanel.NineSlice.BottomRightCorner,
            SettingsPanel.NineSlice.BottomEdge,
            SettingsPanel.NineSlice.LeftEdge,
            SettingsPanel.NineSlice.RightEdge,
        }) do
            v:SetVertexColor(.15, .15, .15)
        end

        for i, v in pairs({
            SettingsPanel.Bg.BottomLeft,
            SettingsPanel.Bg.BottomRight
        }) do
            v:SetVertexColor(.02, .02, .02)
        end
    end)
  end
end