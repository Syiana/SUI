local Module = SUI:NewModule("Skins.Dragonriding");

function Module:OnEnable()
    if (SUI:Color()) then
        local function skinVigor()
            for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
                for _, v in ipairs({ child:GetRegions() }) do
                    if v:GetObjectType() == "Texture" then
                        v:SetDesaturated(true)
                        v:SetVertexColor(unpack(SUI:Color(0.15)))

                        v.SetVertexColor = function() end
                        v.SetDesaturated = function() end
                    end
                end
                for _, vigor in ipairs({ child:GetChildren() }) do
                    for _, v in ipairs({ vigor:GetRegions() }) do
                        if v:GetObjectType() == "Texture" then
                            v:SetDesaturated(true)
                            v:SetVertexColor(unpack(SUI:Color(0.15)))

                            v.SetVertexColor = function() end
                            v.SetDesaturated = function() end
                        end
                    end
                end
            end
        end

        local updateFrame = CreateFrame("Frame")
        updateFrame:RegisterEvent("UPDATE_UI_WIDGET")
        updateFrame:HookScript("OnEvent", function()
            skinVigor()
        end)
    end
end
