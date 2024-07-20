local Skin = SUI:NewModule("Skins.Bartender");

function Skin:OnEnable()
    if not IsAddOnLoaded("Bartender4") then return end

    if (SUI:Color()) then
        for _, v in pairs({
            BlizzardArtRightCap,
            BlizzardArtLeftCap,
            BlizzardArtTex0,
            BlizzardArtTex1,
            BlizzardArtTex2,
            BlizzardArtTex3,
        }) do
            if (v) then v:SetVertexColor(unpack(SUI:Color(0.15))) end
        end

        if (BT4StatusBarTrackingManager) then
            for _, v in pairs({
                BT4StatusBarTrackingManager.SingleBarLarge,
                BT4StatusBarTrackingManager.SingleBarSmall,
                BT4StatusBarTrackingManager.SingleBarLargeUpper,
                BT4StatusBarTrackingManager.SingleBarSmallUpper
            }) do
                if (v) then 
                    v:SetVertexColor(unpack(SUI:Color(0.15)))
                end
            end
        end
    end
end
