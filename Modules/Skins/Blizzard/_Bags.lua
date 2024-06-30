local Module = SUI:NewModule("Skins.Bags");

function Module:OnEnable()
    if (SUI:Color()) then
        for i = 1, 12 do
            SUI:Skin(_G["ContainerFrame" .. i])
        end

        SUI:Skin(BackpackTokenFrame)
        SUI:Skin(BagItemSearchBox)

        -- Buttons
        if (SortBagsButton) then
            SUI:Skin({ select(2, SortBagsButton:GetRegions()) }, false, true, false, true)
        end
    end
end
