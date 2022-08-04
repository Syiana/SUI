local Module = SUI:NewModule("Skins.Bank");

function Module:OnEnable()
  if (SUI:Color()) then
    for i, v in pairs({
      BankFrameTopEdge,
      BankFrameRightEdge,
      BankFrameBottomEdge,
      BankFrameLeftEdge,
      BankFrameTopRightCorner,
      BankFrameTopLeftCorner,
      BankFrameBottomLeftCorner,
      BankFrameBottomRightCorner,
    }) do
        v:SetVertexColor(.15, .15, .15)
    end
    for i, v in pairs({
      BankFrameBg,
      BankFrameTitleBg }) do
        v:SetVertexColor(.3, .3, .3)
    end
  end
end