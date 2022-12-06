local Module = SUI:NewModule("Skins.RaidFrame");

function Module:OnEnable()
    if (SUI:Color()) then
        for _, region in pairs({ CompactRaidFrameManager:GetRegions() }) do
            if region:IsObjectType("Texture") then
                region:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end
    end
end
