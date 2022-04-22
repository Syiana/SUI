local Skin = SUI:NewModule("Skins.ClassicUI.Background");

function Skin:OnEnable()
  local ClassicUI = IsAddOnLoaded("ClassicUI")
  if not (ClassicUI) then return end
  if (SUI:Color()) then
    for i, v in pairs({
      MainMenuBarArtFrameBackground.BackgroundLarge2,
      MainMenuBarArtFrameBackground.BagsArt,
      MainMenuBarArtFrameBackground.MicroButtonArt,
    }) do
      v:SetVertexColor(unpack(SUI:Color(0.15)))
    end
  end
end