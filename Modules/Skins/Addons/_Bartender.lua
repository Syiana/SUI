local Skin = SUI:NewModule("Skins.Bartender");

function Skin:OnEnable()
    local Bartender = C_AddOns.IsAddOnLoaded("Bartender4")
    if not (Bartender) then return end
    if (SUI:Color()) then
        for i, v in pairs({
            BT4StatusBarTrackingManager.SingleBarLarge,
            BT4StatusBarTrackingManager.SingleBarSmall,
            BT4StatusBarTrackingManager.SingleBarLargeUpper,
            BT4StatusBarTrackingManager.SingleBarSmallUpper,
            BlizzardArtRightCap,
            BlizzardArtLeftCap,
            BlizzardArtTex0,
            BlizzardArtTex1,
            BlizzardArtTex2,
            BlizzardArtTex3,
        }) do
            if (v) then v:SetVertexColor(unpack(SUI:Color(0.15))) end
        end
    end
end
