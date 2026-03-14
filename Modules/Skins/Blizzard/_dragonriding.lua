local Module = SUI:NewModule("Skins.Dragonriding");

function Module:OnEnable()
    if (SUI:Color()) then
        local function skinVigor()
            if not UIWidgetPowerBarContainerFrame then
                return
            end

            for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
                if child.DecorLeft and child.DecorLeft.GetAtlas then
                    local atlasName = child.DecorLeft:GetAtlas()
                    if atlasName == "dragonriding_vigor_decor" then
                        child.DecorLeft:SetDesaturated(true)
                        child.DecorLeft:SetVertexColor(unpack(SUI:Color(0.15)))
                        child.DecorLeft.SetVertexColor = function() end
                        child.DecorLeft.SetDesaturated = function() end

                        if child.DecorRight then
                            child.DecorRight:SetDesaturated(true)
                            child.DecorRight:SetVertexColor(unpack(SUI:Color(0.15)))
                            child.DecorRight.SetVertexColor = function() end
                            child.DecorRight.SetDesaturated = function() end
                        end
                    end
                end

                for _, vigor in ipairs({ child:GetChildren() }) do
                    if vigor.Frame and vigor.Frame.GetAtlas then
                        local atlasName = vigor.Frame:GetAtlas()
                        if atlasName == "dragonriding_vigor_frame" then
                            vigor.Frame:SetDesaturated(true)
                            vigor.Frame:SetVertexColor(unpack(SUI:Color(0.15)))
                            vigor.Frame.SetVertexColor = function() end
                            vigor.Frame.SetDesaturated = function() end
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
