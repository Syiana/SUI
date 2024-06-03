local Module = SUI:NewModule("Skins.LFG");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in ipairs({
      LFGListingFrameFrameBackgroundTop,
      LFGListingFrameFrameBackgroundBottom,
      LFGListingFrameFrameBackgroundTitle,
      LFGListingFrameBg,
      LFGListingFrameBackgroundArt,
      LFGParentFramePortrait,
    }) do
      v:SetVertexColor(unpack(SUI:Color()))
    end
  end
end