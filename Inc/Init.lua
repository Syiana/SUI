local ADDON, SUI = ...
local DEBUG = true
local LOGIN = CreateFrame("Frame")
LOGIN:RegisterEvent("PLAYER_LOGIN")
LOGIN:SetScript("OnEvent", function(self, event)
    if (SUI.CONFIG) then 
        for MODULE in pairs(SUI.CONFIG) do local MODULE = SUI.CONFIG[MODULE]
            if MODULE then
                if (type(MODULE) == "table") then
                    for FUNC in pairs(MODULE) do
                        FUNC = MODULE[FUNC]
                        if (type(FUNC) == "function") then FUNC() end
                    end
                else
                    MODULE()
                end
            end
        end 
        if (SUI.MODULES) then
            local MEDIA = {
                Color = SUIDB.THEMES.OPTIONS[SUIDB.THEMES.SELECTED],
                Font = SUIDB.FONTS.OPTIONS[SUIDB.FONTS.SELECTED],
                Tex = SUIDB.TEXTURES.OPTIONS[SUIDB.TEXTURES.SELECTED],
            }
            for MODULE in pairs(SUI.MODULES) do local MODULE = SUI.MODULES[MODULE]
                if MODULE then
                    if (type(MODULE) == "table" and MODULE['DB']) then DB = SUIDB[MODULE['DB']] else DB = nil end
                    if (type(MODULE) == "table") then
                        for FUNC in pairs(MODULE) do
                            FUNC = MODULE[FUNC]
                            if (type(FUNC) == "function") then FUNC(DB, MEDIA) end
                        end
                    else
                        MODULE(DB, MEDIA)
                    end
                end
            end 
        else 
            print("SUI: LOADING FAILED")
        end
    else
        print("SUI: MISSING CONFIG")
    end
end)