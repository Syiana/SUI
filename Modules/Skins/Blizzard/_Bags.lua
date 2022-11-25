local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()

    function SUICombinedBags()
        local container = ContainerFrameCombinedBags
        SUIStyleBG(container)
        SUIStyleNineSlice(container)
        container.MoneyFrame.Border.Left:SetVertexColor(unpack(SUI:Color(0.1)))
        container.MoneyFrame.Border.Middle:SetVertexColor(unpack(SUI:Color(0.1)))
        container.MoneyFrame.Border.Right:SetVertexColor(unpack(SUI:Color(0.1)))

        --[[
    backdrop = {
      bgFile = "",
      edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
      tile = false,
      tileSize = 32,
      edgeSize = 10,
      insets = { left = 5, right = 5, top = 5, bottom = 5 }
    }
    ]]

        --local bH = container.CloseButton:GetHeight()
        --local bW = container.CloseButton:GetWidth()
        --local f = CreateFrame("Frame", "SUICloseButtonCorner", container.CloseButton, "BackdropTemplate")
        --f:SetSize(container.CloseButton.GetWidth(), container.CloseButton:GetHeight())
        --f:SetSize(bH+12, bW+12)
        --f:SetAllPoints()
        --f:SetPoint("TOPLEFT", container.CloseButton, "TOPLEFT", -5, 7)
        --f:SetBackdrop(backdrop)
        --f:SetBackdropBorderColor(0, 0, 0, 1)
        --container.CloseButton:SetTexture('closebutton')
    end

    function SUIDefaultBags()
        local nineSlice = {
            "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "Center", "LeftEdge", "RightEdge", "TopEdge",
            "TopLeftCorner", "TopRightCorner"
        }

        for i = 1, 6 do
            local container = _G["ContainerFrame" .. i]

            SUIStyleNineSlice(container)
            SUIStyleBG(container)

            -- Bag Slots
            for b = 1, 36 do
                local normalTexture = _G["ContainerFrame" .. i .. "Item" .. b .. "NormalTexture"]
                normalTexture:SetVertexColor(unpack(SUI:Color(0.1)))
            end
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
            "BottomEdge", "BottomLeftCorner", "BottomRightCorner", "Center", "LeftEdge", "RightEdge", "TopEdge",
            "TopLeftCorner", "TopRightCorner"
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
