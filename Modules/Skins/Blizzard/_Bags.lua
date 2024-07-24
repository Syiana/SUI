local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()

    function SUICombinedBags()
        local container = ContainerFrameCombinedBags
        SUIStyleBG(container)
        SUIStyleNineSlice(container)
        container.MoneyFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
        container.MoneyFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
        container.MoneyFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))

        hooksecurefunc(ContainerFrameCombinedBags, "Update", function(self)
            for button, _ in self.itemButtonPool:EnumerateActive() do
                button.NormalTexture:SetVertexColor(unpack(SUI:Color(0.15)))
            end
        end)
    end

    function SUIDefaultBags()
        for i = 1, 13 do
            local container = _G["ContainerFrame" .. i]

            SUIStyleNineSlice(container)
            SUIStyleBG(container)

            -- Bag Slots
            local bagSlots = _G["ContainerFrame" .. i]
            hooksecurefunc(bagSlots, "Update", function(self)
                for button, _ in self.itemButtonPool:EnumerateActive() do
                    button.NormalTexture:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end)
            --print(bagSlots.NormalTexture)
        end

        ContainerFrame1MoneyFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
        ContainerFrame1MoneyFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
        ContainerFrame1MoneyFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))

        BackpackTokenFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
        BackpackTokenFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
        BackpackTokenFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))
    end

    function SUIStyleBG(container)
        container.Bg.TopSection:SetVertexColor(unpack(SUI:Color(0.1)))
        container.Bg.BottomEdge:SetVertexColor(unpack(SUI:Color(0.1)))
        container.Bg.BottomLeft:SetVertexColor(0, 0, 0, 0.78)
        container.Bg.BottomRight:SetVertexColor(0, 0, 0, 0.78)
    end

    function SUIStyleNineSlice(container)
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
            container.NineSlice[ns]:SetVertexColor(unpack(SUI:Color(0.1)))
        end
    end

    if (SUI:Color()) then
        SUICombinedBags()
        SUIDefaultBags()
    end
end
