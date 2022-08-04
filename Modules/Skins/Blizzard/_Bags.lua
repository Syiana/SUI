local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
  if (SUI:Color()) then
    for i = 1, 5 do
      _G["ContainerFrame".. i .."BackgroundTop"]:SetVertexColor(unpack(SUI:Color(0.1)))
      _G["ContainerFrame".. i .."BackgroundMiddle1"]:SetVertexColor(unpack(SUI:Color(0.1)))
      _G["ContainerFrame".. i .."BackgroundMiddle2"]:SetVertexColor(unpack(SUI:Color(0.1)))
      _G["ContainerFrame".. i .."BackgroundBottom"]:SetVertexColor(unpack(SUI:Color(0.1)))
    end
    --BackpackTokenFrame:GetRegions():SetVertexColor(unpack(SUI:Color(0.1)))
  end
end