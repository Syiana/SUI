local Module = SUI:NewModule("Skins.Dragonriding");

function Module:OnEnable()
    local function skinVigor()
        for _, child in ipairs({UIWidgetPowerBarContainerFrame:GetChildren()}) do
            for _, v in ipairs({child:GetRegions()}) do
                if v:GetObjectType() == "Texture" then
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
            for _, vigor in ipairs({child:GetChildren()}) do
                for _, v in ipairs({vigor:GetRegions()}) do
                    if v:GetObjectType() == "Texture" then
                        v:SetVertexColor(unpack(SUI:Color(0.15)))
                    end
                end
            end
        end
    end

    UIWidgetPowerBarContainerFrame:HookScript("OnShow", skinVigor())
    --skinVigor()

end