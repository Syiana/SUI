local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()

    function SUICombinedBags()
        local container = _G["ContainerFrameCombinedBags"]
        if not container then return end  -- Exit if container doesn't exist
        
        SUIStyleBG(container)
        SUIStyleNineSlice(container)
        
        if container.MoneyFrame and container.MoneyFrame.Border then
            container.MoneyFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
            container.MoneyFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
            container.MoneyFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))
        end

        if container.Update then
            hooksecurefunc(container, "Update", function(self)
                if self.itemButtonPool then
                    for button, _ in self.itemButtonPool:EnumerateActive() do
                        if button.NormalTexture then
                            button.NormalTexture:SetVertexColor(unpack(SUI:Color(0.15)))
                        end
                    end
                end
            end)
        end
    end

    function SUIDefaultBags()
        for i = 1, 13 do
            local container = _G["ContainerFrame" .. i]
            
            -- Only proceed if container exists
            if container then
                SUIStyleNineSlice(container)
                SUIStyleBG(container)

                -- Bag Slots - only hook if Update method exists
                if container.Update then
                    hooksecurefunc(container, "Update", function(self)
                        if self.itemButtonPool then
                            for button, _ in self.itemButtonPool:EnumerateActive() do
                                if button.NormalTexture then
                                    button.NormalTexture:SetVertexColor(unpack(SUI:Color(0.15)))
                                end
                            end
                        end
                    end)
                end
            end
        end

        -- Handle ContainerFrame1MoneyFrame safely
        local moneyFrame = _G["ContainerFrame1MoneyFrame"]
        if moneyFrame and moneyFrame.Border then
            moneyFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
            moneyFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
            moneyFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))
        end

        -- Handle BackpackTokenFrame safely
        local backpackTokenFrame = _G["BackpackTokenFrame"]
        if backpackTokenFrame and backpackTokenFrame.Border then
            backpackTokenFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
            backpackTokenFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
            backpackTokenFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))
        end
    end

    function SUIStyleBG(container)
        if not container or not container.Bg then return end
        
        if container.Bg.TopSection then
            container.Bg.TopSection:SetVertexColor(unpack(SUI:Color(0.1)))
        end
        if container.Bg.BottomEdge then
            container.Bg.BottomEdge:SetVertexColor(unpack(SUI:Color(0.1)))
        end
        if container.Bg.BottomLeft then
            container.Bg.BottomLeft:SetVertexColor(0, 0, 0, 0.78)
        end
        if container.Bg.BottomRight then
            container.Bg.BottomRight:SetVertexColor(0, 0, 0, 0.78)
        end
    end

    function SUIStyleNineSlice(container)
        if not container or not container.NineSlice then return end
        
        local nineSlice = {
            "BottomEdge",
            "BottomLeftCorner",
            "BottomRightCorner",
            "Center",
            "LeftEdge",
            "RightEdge",
            "TopEdge",
            "TopLeftCorner",
            "TopRightCorner"
        }

        container.NineSlice:SetVertexColor(unpack(SUI:Color(1)))

        for _, ns in pairs(nineSlice) do
            if container.NineSlice[ns] then
                container.NineSlice[ns]:SetVertexColor(unpack(SUI:Color(0.1)))
            end
        end
    end

    if (SUI:Color()) then
        SUICombinedBags()
        SUIDefaultBags()
    end
end
