local Skin = SUI:NewModule("Skins.Bartender");

function Skin:OnEnable()
  local Bartender = IsAddOnLoaded("Bartender4")
  if not (Bartender) then return end
  if (SUI:Color()) then
    for i, v in pairs({
      BT4StatusTrackingBarManager.SingleBarLarge,
      BT4StatusTrackingBarManager.SingleBarSmall,
      BT4StatusTrackingBarManager.SingleBarLargeUpper,
      BT4StatusTrackingBarManager.SingleBarSmallUpper,
      BlizzardArtRightCap,
      BlizzardArtLeftCap,
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
  end
end