local Module = SUI:NewModule("Skins.Trade");

function Module:OnEnable()
    if (SUI:Color()) then
        for _, v in pairs({TradeFrame:GetRegions()}) do
            if (v:GetObjectType() == "Texture") then
                v:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end
        for _, v in pairs({TradeFrame.NineSlice:GetRegions()}) do
            if (v:GetObjectType() == "Texture") then
                v:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end
        TradeFrame.RecipientOverlay.portraitFrame:SetVertexColor(unpack(SUI:Color(0.15)))
    end
end
